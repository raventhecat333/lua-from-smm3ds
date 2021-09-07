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
static={}
play_state= {
cWait=0,
cInit=1,
c10In=2,
cStateDone=3,
_stateCount=4
}
-------------------------------------------------------------
function onEntercWait()
g_1stTimeIn = false

g_lives = 9

counter = 60

local topScreen = ui:getScreen(2)
topScreen:setText("T_CourseName_00", "Level Name Goes Here")
topScreen:setText("T_Zanki_00", g_lives)

NN_LOG(string.format("%d", g_lives))

if g_1stTimeIn == false then
	animA = topScreen:playAnimation("AnimA")
	animA:pause()
	animA:setFrame(animA:getLength())
end
end
function onUpdatecWait()
counter = counter - 1
if counter <= 0 then
	stateMachine:requestState(play_state.cInit)
end
end
function onExitcWait()

end
function onEntercInit()
topScreen = ui:getScreen(2)

if g_1stTimeIn then
	animA = topScreen:playAnimation("AnimA")
end

end
function onUpdatecInit()
if animA:isPlaying() == false then
	stateMachine:requestState(play_state.c10In)
end
end
function onExitcInit()

end
function onEnterc10In()
topScreen = ui:getScreen(2)

animB = topScreen:playAnimation("AnimB")
end
function onUpdatec10In()
if animB:isPlaying() == false then
	stateMachine:requestState(play_state.cStateDone)
end
end
function onExitc10In()

end
function onEntercStateDone()

end
function onUpdatecStateDone()

end
function onExitcStateDone()

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
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (play_state._stateCount,play_state.cWait)
stateMachine:register(play_state.cWait,cWait)
stateMachine:register(play_state.cInit,cInit)
stateMachine:register(play_state.c10In,c10In)
stateMachine:register(play_state.cStateDone,cStateDone)
stateMachine:endRegister()
end

