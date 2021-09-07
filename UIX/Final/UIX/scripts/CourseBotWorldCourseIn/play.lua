BUTTON={}
BUTTON.A=1
BUTTON.B=2
BUTTON.SELECT=4
BUTTON.START=8
BUTTON.RIGHT=16
BUTTON.LEFT=32
BUTTON.UP=64
BUTTON.DOWN=128
BUTTON.R=256
BUTTON.L=512
BUTTON.X=1024
BUTTON.Y=2048
BUTTON.ZL=16384
BUTTON.ZR=32768
SCREEN={}
SCREEN.TOP=2
SCREEN.BOTTOM=1
static={}
play_state= {
cWait=0,
cInit=1,
c10In=2,
cStateDone=3,
cIntermediate=4,
_stateCount=5
}
-------------------------------------------------------------
function onEntercWait()
index = GlobalData:getMyCoursesWorldIndex()
local topScreen = ui:getScreen(2)

NN_LOG(index)

anim = nil

if index == 1 then
	anim = topScreen:playAnimation("AnimB")
	anim:stop()
	anim:setFrame(0)
elseif index == 2 then
	anim = topScreen:playAnimation("AnimC")
	anim:stop()
	anim:setFrame(0)
elseif index == 3 then
	anim = topScreen:playAnimation("AnimD")
	anim:stop()
	anim:setFrame(0)
end

-- #11204 - hiding Yam + bubble
local botScreen = ui:getScreen(SCREEN.BOTTOM)
if botScreen then
	botScreen:setVisible("W_bubble_00", false)
	botScreen:setVisible("T_Start_00", false)
	botScreen:setVisible("p_yamamura_shadow_00", false)
	botScreen:setVisible("p_yamamura_00", false)
	botScreen:setVisible("p_bubbleTip_00", false)
end

stateMachine:requestState(play_state.cIntermediate)
end
function onUpdatecWait()

end
function onExitcWait()

end
function onEntercInit()
topScreen = ui:getScreen(2)

if index == 0 then
	anim = topScreen:playAnimation("AnimA")
	Sound:playSound("worldplay_walk_dot")
elseif index == 1 then
	anim = topScreen:playAnimation("AnimB")
	Sound:playSound("worldplay_walk_dot")
elseif index == 2 then
	anim = topScreen:playAnimation("AnimC")
	Sound:playSound("worldplay_walk_dot")
elseif index == 3 then
	anim = topScreen:playAnimation("AnimD")
	Sound:playSound("worldplay_walk_dot")
end
end
function onUpdatecInit()
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(play_state.c10In)
end
end
function onExitcInit()

end
function onEnterc10In()
topScreen = ui:getScreen(2)

animOut = topScreen:playAnimation("Out")
end
function onUpdatec10In()
if animOut ~= nil and animOut:isPlaying() == false then
	stateMachine:requestState(play_state.cStateDone)
end
end
function onExitc10In()

end
function onEntercStateDone()
GlobalData:playMyCoursesWorldLevel()
GameState:switchScene("gameplay")
end
function onUpdatecStateDone()

end
function onExitcStateDone()

end
function onEntercIntermediate()
counter = 120
end
function onUpdatecIntermediate()
counter = counter - 1
if counter <= 0 then
	stateMachine:requestState(play_state.cInit)
end
end
function onExitcIntermediate()

end
-------------------------------------------------------------
cWait={}
cWait.onEnter=onEntercWait
cWait.onUpdate=onUpdatecWait
cWait.onExit=onExitcWait
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
c10In={}
c10In.onEnter=onEnterc10In
c10In.onUpdate=onUpdatec10In
c10In.onExit=onExitc10In
cStateDone={}
cStateDone.onEnter=onEntercStateDone
cStateDone.onUpdate=onUpdatecStateDone
cStateDone.onExit=onExitcStateDone
cIntermediate={}
cIntermediate.onEnter=onEntercIntermediate
cIntermediate.onUpdate=onUpdatecIntermediate
cIntermediate.onExit=onExitcIntermediate
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (play_state._stateCount,play_state.cWait)
stateMachine:register(play_state.cWait,cWait)
stateMachine:register(play_state.cInit,cInit)
stateMachine:register(play_state.c10In,c10In)
stateMachine:register(play_state.cStateDone,cStateDone)
stateMachine:register(play_state.cIntermediate,cIntermediate)
stateMachine:endRegister()
end

