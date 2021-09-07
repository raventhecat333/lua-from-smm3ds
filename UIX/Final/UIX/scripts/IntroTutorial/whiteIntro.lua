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
whiteIntro_state= {
cIntro=0,
cExit=1,
cArchiveChange=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercIntro()

end
function onUpdatecIntro()
if ui:isIdle() then
	if Input:isTriggered(BUTTON.A) then
		ui:changeScreen("Main", true, false, false)
		stateMachine:requestState(whiteIntro_state.cExit)
	end
end
end
function onExitcIntro()

end
function onEntercExit()
--gAnim = ui:getScreen(2):playAnimation("Out")
--ui:getScreen(1):playAnimation("Out")
end
function onUpdatecExit()
--if gAnim ~= nil and gAnim:isPlaying() == false then
--	stateMachine:requestState(whiteIntro_state.cArchiveChange)
--end
end
function onExitcExit()

end
function onEntercArchiveChange()

end
function onUpdatecArchiveChange()

end
function onExitcArchiveChange()

end
-------------------------------------------------------------
cIntro={}
cIntro.onEnter=onEntercIntro
cIntro.onUpdate=onUpdatecIntro
cIntro.onExit=onExitcIntro
cExit={}
cExit.onEnter=onEntercExit
cExit.onUpdate=onUpdatecExit
cExit.onExit=onExitcExit
cArchiveChange={}
cArchiveChange.onEnter=onEntercArchiveChange
cArchiveChange.onUpdate=onUpdatecArchiveChange
cArchiveChange.onExit=onExitcArchiveChange
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (whiteIntro_state._stateCount,whiteIntro_state.cIntro)
stateMachine:register(whiteIntro_state.cIntro,cIntro)
stateMachine:register(whiteIntro_state.cExit,cExit)
stateMachine:register(whiteIntro_state.cArchiveChange,cArchiveChange)
stateMachine:endRegister()
end

