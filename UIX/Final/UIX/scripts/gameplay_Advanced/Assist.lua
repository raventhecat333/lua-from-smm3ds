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
Assist_state= {
cInit=0,
cEnd=1,
cDialog=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercInit()

	stateMachine:requestState(Assist_state.cDialog)

end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercEnd()
ConversationController:closeDialog()

end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercDialog()

end
function onUpdatecDialog()
if ConversationController:isActive() == false then return end
if ConversationController:canReadInput() == false then return end

	if Input:isTriggered(BUTTON.A) or ConversationController:getAnswer() == 2 then
		stateMachine:requestState(Assist_state.cEnd)
	end
end
function onExitcDialog()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cDialog={}
cDialog.onEnter=onEntercDialog
cDialog.onUpdate=onUpdatecDialog
cDialog.onExit=onExitcDialog
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Assist_state._stateCount,Assist_state.cInit)
stateMachine:register(Assist_state.cInit,cInit)
stateMachine:register(Assist_state.cEnd,cEnd)
stateMachine:register(Assist_state.cDialog,cDialog)
stateMachine:endRegister()
end

