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
Dialog_state= {
cPlayTest=0,
cDone=1,
_stateCount=2
}
-------------------------------------------------------------
function onEntercPlayTest()
topScreen = ui:getScreen(SCREEN.TOP)
end
function onUpdatecPlayTest()
if ui:isActive() and ui:isIdle() then
	NN_LOG("Attempting to change screens")
	stateMachine:requestState(Dialog_state.cDone)
end

--if Input:isTriggered(BUTTON.A) then
--	NN_LOG("Attempting to change screens")
--	stateMachine:requestState(Dialog_state.cDone)
--end
end
function onExitcPlayTest()

end
function onEntercDone()
ui:changeScreen("HundredMario", true, false, false)
end
function onUpdatecDone()

end
function onExitcDone()
NN_LOG("Leaving Dialog_state.cDone in Dialog")
end
-------------------------------------------------------------
cPlayTest={}
cPlayTest.onEnter=onEntercPlayTest
cPlayTest.onUpdate=onUpdatecPlayTest
cPlayTest.onExit=onExitcPlayTest
cDone={}
cDone.onEnter=onEntercDone
cDone.onUpdate=onUpdatecDone
cDone.onExit=onExitcDone
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Dialog_state._stateCount,Dialog_state.cPlayTest)
stateMachine:register(Dialog_state.cPlayTest,cPlayTest)
stateMachine:register(Dialog_state.cDone,cDone)
stateMachine:endRegister()
end

