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
cEnd=3,
_stateCount=4
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
		stateMachine:requestState(Conversation_state.cEnd)
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

end
function onUpdatecExecute()
if ConversationController:isActive() == false then return end
if ConversationController:canReadInput() == false then return end

gTutorialType = ConversationController:getTutorialType()
if Input:isTriggered(BUTTON.A) or ConversationController:getAnswer() == tutorialAnswer.NEXT then
	if gTutorialType == tutorialType.MESSAGE_EDIT then
		goNextState()
		-- MCAT#2304
		if ConversationController:getTutorialType() == tutorialAnswer.INVALID then
			stateMachine:requestState(Conversation_state.cEnd)
			return
		end
		stateMachine:requestState(Conversation_state.cIntro)
	elseif gTutorialType == tutorialType.MESSAGE_OPTIONS then
		goNextState()
		stateMachine:requestState(Conversation_state.cIntro)
	elseif gTutorialType == tutorialType.INVALID then
		stateMachine:requestState(Conversation_state.cEnd)
	end
end
end
function onExitcExecute()

end
function onEntercEnd()
ConversationController:closeDialog()
GlobalData:setChallengeLevelIndex(0)
GlobalData:setChallengeWorldIndex(0)
GlobalData:setChallengeLevelPresentationIndex(0)
GlobalData:setChallengePlaying(false)
GlobalData:writeToSaveDataChallengeMode() -- make sure we saved
GameState:switchScene("MarioChallangeMap")
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
stateMachine:register(Conversation_state.cEnd,cEnd)
stateMachine:endRegister()
end

