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
Conversation_state= {
cInit=0,
cIntro=1,
cExecute=2,
cEnterLeaving=3,
cEnd=4,
_stateCount=5
}
-------------------------------------------------------------
function onEntercInit()
tutorialType = {}
tutorialType.INVALID = -1
tutorialType.MESSAGE_EDIT= 0
tutorialType.MESSAGE_PLAY= 1
tutorialType.MESSAGE_OPTIONS = 2
tutorialType.EDIT = 3
tutorialType.PLAY = 4
tutorialType.WAIT_OVERLAYBUTTON = 5

tutorialAnswer = {}
tutorialAnswer.INVALID = -1
tutorialAnswer.YES = 0
tutorialAnswer.NO = 1
tutorialAnswer.NEXT = 2

gTimer = 60

gJumpTableIndex = 0

gcIntroMessageIdCount = 7
gState = 0

function showMessageBubble()
	gTutorialType = ConversationController:showBubbleNext(nil)
	--Tutorial:lockInput()
	if gTutorialType == tutorialType.INVALID then
		-- MCAT#2304 - trigger leave when tutorial type is invalid
		stateMachine:requestState(Conversation_state.cEnterLeaving)
	elseif gTutorialType == tutorialType.MESSAGE_EDIT then
		stateMachine:requestState(Conversation_state.cExecute)
	elseif gTutorialType == tutorialType.MESSAGE_OPTIONS then
		stateMachine:requestState(Conversation_state.cExecute)
	end
end

function goNextState()
	showMessageBubble()
end
end
function onUpdatecInit()
if ui:isIdle() and ui:isActive() then
	stateMachine:requestState(Conversation_state.cIntro)
end
end
function onExitcInit()

end
function onEntercIntro()
stateMachine:requestState(Conversation_state.cExecute)

end
function onUpdatecIntro()

end
function onExitcIntro()
gTutorialType = Tutorial:getTutorialType()
end
function onEntercExecute()
gTimer = 40

end
function onUpdatecExecute()
if ConversationController:isActive() == false then return end
if ConversationController:canReadInput() == false then return end

gTutorialType = ConversationController:getTutorialType()
if Input:isTriggered(BUTTON.A) or ConversationController:getAnswer() == tutorialAnswer.NEXT then
	if gTutorialType == tutorialType.MESSAGE_EDIT then
		goNextState()
		if ConversationController:getTutorialType() == tutorialType.INVALID then
			stateMachine:requestState(Conversation_state.cEnterLeaving)
			return
		end
		stateMachine:requestState(Conversation_state.cIntro)
	elseif gTutorialType == tutorialType.MESSAGE_OPTIONS then
		goNextState()
		stateMachine:requestState(Conversation_state.cIntro)
	elseif gTutorialType == tutorialType.INVALID then
		stateMachine:requestState(Conversation_state.cEnterLeaving)
	end
end

end
function onExitcExecute()

end
function onEntercEnterLeaving()
ui:disableInput() -- mcat#1955 - disable all the ui input as we do not need it anymore until next time
gTimer = 30
ConversationController:closeDialog()
end
function onUpdatecEnterLeaving()
if gTimer <= 0 then
	stateMachine:requestState(Conversation_state.cEnd)
else
	gTimer = gTimer - 1
end
end
function onExitcEnterLeaving()
ui:changeScreen("Map")
end
function onEntercEnd()

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
cIntro={}
cIntro.onEnter=onEntercIntro
cIntro.onUpdate=onUpdatecIntro
cIntro.onExit=onExitcIntro
cExecute={}
cExecute.onEnter=onEntercExecute
cExecute.onUpdate=onUpdatecExecute
cExecute.onExit=onExitcExecute
cEnterLeaving={}
cEnterLeaving.onEnter=onEntercEnterLeaving
cEnterLeaving.onUpdate=onUpdatecEnterLeaving
cEnterLeaving.onExit=onExitcEnterLeaving
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Conversation_state._stateCount,Conversation_state.cInit)
stateMachine:register(Conversation_state.cInit,cInit)
stateMachine:register(Conversation_state.cIntro,cIntro)
stateMachine:register(Conversation_state.cExecute,cExecute)
stateMachine:register(Conversation_state.cEnterLeaving,cEnterLeaving)
stateMachine:register(Conversation_state.cEnd,cEnd)
stateMachine:endRegister()
end

