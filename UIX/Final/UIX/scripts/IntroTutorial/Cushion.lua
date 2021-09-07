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
Cushion_state= {
cInit=0,
cClose=1,
cEnd=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercInit()
Tutorial:setWait(true)
end
function onUpdatecInit()
if ui:isIdle() == false then return end -- MCAT#2370 - let intro animation to fully finish

if Input:isTriggered(BUTTON.A) or Input:isTouchReleased() then -- #11362 support for touch in intro tutorial start up
	Sound:playSound("press_a_first")
	stateMachine:requestState(Cushion_state.cClose)
end
end
function onExitcInit()

end
function onEntercClose()
gAnim = ui:getScreen(SCREEN.TOP):playAnimation("Out", false)
ui:getScreen(SCREEN.BOTTOM):playAnimation("Out", false)
anim = ui:getScreen(SCREEN.TOP):playAnimation("Loop", false)
if anim ~= nil then
	anim:pause()
end
anim = ui:getScreen(SCREEN.BOTTOM):playAnimation("Loop", false)
if anim ~= nil then
	anim:pause()
end
end
function onUpdatecClose()
if gAnim ~= nil and gAnim:isPlaying() == false then
	stateMachine:requestState(Cushion_state.cEnd)
end
end
function onExitcClose()

end
function onEntercEnd()
Tutorial:setWait(false)
Sound:playEditorMusic()

ui:changeScreen("Main", true, true, false)
end
function onUpdatecEnd()

end
function onExitcEnd()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cClose={}
cClose.onEnter=onEntercClose
cClose.onUpdate=onUpdatecClose
cClose.onExit=onExitcClose
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Cushion_state._stateCount,Cushion_state.cInit)
stateMachine:register(Cushion_state.cInit,cInit)
stateMachine:register(Cushion_state.cClose,cClose)
stateMachine:register(Cushion_state.cEnd,cEnd)
stateMachine:endRegister()
end

