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
WorldClearDialog_state= {
cInit=0,
cEnterConversation=1,
cConversation=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercInit()

end
function onUpdatecInit()
if ui:isIdle() and ui:isActive() then
	stateMachine:requestState(WorldClearDialog_state.cEnterConversation)
end
end
function onExitcInit()

end
function onEntercEnterConversation()
ConversationController:showBubbleNext(nil)
stateMachine:requestState(WorldClearDialog_state.cConversation)
end
function onUpdatecEnterConversation()

end
function onExitcEnterConversation()

end
function onEntercConversation()

end
function onUpdatecConversation()

end
function onExitcConversation()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cEnterConversation={}
cEnterConversation.onEnter=onEntercEnterConversation
cEnterConversation.onUpdate=onUpdatecEnterConversation
cEnterConversation.onExit=onExitcEnterConversation
cConversation={}
cConversation.onEnter=onEntercConversation
cConversation.onUpdate=onUpdatecConversation
cConversation.onExit=onExitcConversation
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (WorldClearDialog_state._stateCount,WorldClearDialog_state.cInit)
stateMachine:register(WorldClearDialog_state.cInit,cInit)
stateMachine:register(WorldClearDialog_state.cEnterConversation,cEnterConversation)
stateMachine:register(WorldClearDialog_state.cConversation,cConversation)
stateMachine:endRegister()
end

