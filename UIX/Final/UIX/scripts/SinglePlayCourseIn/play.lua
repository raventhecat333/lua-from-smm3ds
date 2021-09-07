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
cEnd=1,
cInit=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercWait()
counter = 60

-- #11204 - hiding Yam + bubble
local botScreen = ui:getScreen(SCREEN.BOTTOM)
if botScreen then
	botScreen:setVisible("W_bubble_00", false)
	botScreen:setVisible("T_Start_00", false)
	botScreen:setVisible("p_yamamura_shadow_00", false)
	botScreen:setVisible("p_yamamura_00", false)
	botScreen:setVisible("p_bubbleTip_00", false)
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
function onEntercEnd()
GameState:switchScene("gameplay")

end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercInit()
topScreen = ui:getScreen(2)
animA = topScreen:playAnimation("AnimA")
Sound:playSound("courseplay_walk_dot")

end
function onUpdatecInit()
if animA ~= nil and animA:isPlaying() == false then
	stateMachine:requestState(play_state.cEnd)
end
end
function onExitcInit()

end
-------------------------------------------------------------
cWait={}
cWait.onEnter=onEntercWait
cWait.onUpdate=onUpdatecWait
cWait.onExit=onExitcWait
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (play_state._stateCount,play_state.cWait)
stateMachine:register(play_state.cWait,cWait)
stateMachine:register(play_state.cEnd,cEnd)
stateMachine:register(play_state.cInit,cInit)
stateMachine:endRegister()
end

