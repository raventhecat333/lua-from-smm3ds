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
Tutdummy_state= {
cInit=0,
cEnterIntro=1,
cIntro=2,
cWaitDialog=3,
cEnd=4,
cInteraction=5,
cPlay=6,
cExitPlay=7,
cPlayEnter=8,
cWaitDialogPlay=9,
cIntroWaitPlay=10,
cEraserMode=11,
_stateCount=12
}
-------------------------------------------------------------
function onEntercInit()
Editor:tellState(STATE_MAIN_MENU);
gTimer = 4

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

gFadeAnim = nil
gTutorialType = tutorialType.INVALID


end
function onUpdatecInit()
if Tutorial:isSetToWait() then return end

gTimer = gTimer - 1

if gTimer <= 0 then
	stateMachine:requestState(Tutdummy_state.cEnterIntro)
end
end
function onExitcInit()

end
function onEntercEnterIntro()
gTimer = 60

gJumpTableIndex = 0

gcIntroMessageIdCount = 7
gState = 0

function showMessageBubble()
	gTutorialType = Tutorial:showBubbleNext(nil)
	Tutorial:lockInput()
	if gTutorialType == tutorialType.INVALID then
		stateMachine:requestState(Tutdummy_state.cEnd)
	elseif gTutorialType == tutorialType.EDIT  then
		stateMachine:requestState(Tutdummy_state.cWaitDialog)
	elseif gTutorialType == tutorialType.MESSAGE_EDIT then
		stateMachine:requestState(Tutdummy_state.cWaitDialog)
	elseif gTutorialType == tutorialType.PLAY  then
		stateMachine:requestState(Tutdummy_state.cWaitDialog)
	elseif gTutorialType == tutorialType.MESSAGE_PLAY then
		stateMachine:requestState(Tutdummy_state.cWaitDialog)
	elseif gTutorialType == tutorialType.MESSAGE_OPTIONS then
		stateMachine:requestState(Tutdummy_state.cWaitDialog)
	end
end

function showHighlight()
	 local msg = gcIntroMessageIds[gState]
	--Tutorial:highlight(msg.menuItem)
end

function setLessonTitle(lesson, info)
	--Tutorial:setMessageId(2, "T_Lesson_00", "Tut0_Title0")
	--Tutorial:setMessageId(2, "T_LessonINFO_00", "Tut0_Title1")
	Tutorial:lockInput()
end

setLessonTitle("Lesson : 0", "Mario Maker Basics")
Tutorial:showTitle()

function goNextState()
	gState = gState + 1
	showMessageBubble()
end

stateMachine:requestState(Tutdummy_state.cIntro)
end
function onUpdatecEnterIntro()

end
function onExitcEnterIntro()
showMessageBubble()
end
function onEntercIntro()

stateMachine:requestState(Tutdummy_state.cWaitDialog)

end
function onUpdatecIntro()

end
function onExitcIntro()
gTutorialType = Tutorial:getTutorialType()
end
function onEntercWaitDialog()
gTimer = 40

gMenuItemTimer = 25
end
function onUpdatecWaitDialog()
if Tutorial:isActive() == false then return end
if Tutorial:canReadInput() == false then return end

gTutorialType = Tutorial:getTutorialType()
if Tutorial:isCameraActive() == false then -- wait for camera stop moving before letting user input
	if gTutorialType ~= tutorialType.WAIT_OVERLAYBUTTON or gTutorialType ~= tutorialType.MESSAGE_OPTIONS then
		if Input:isTriggered(BUTTON.A) or Tutorial:getAnswer() == tutorialAnswer.NEXT then
			if gState == 0 then
				Tutorial:hideTitle()
			end
			if gTutorialType == tutorialType.MESSAGE_EDIT then
				goNextState()
				stateMachine:requestState(Tutdummy_state.cIntro)
			elseif gTutorialType == tutorialType.EDIT then
				stateMachine:requestState(Tutdummy_state.cInteraction)
			elseif gTutorialType == tutorialType.PLAY then
				stateMachine:requestState(Tutdummy_state.cPlayEnter)
			elseif gTutorialType == tutorialType.MESSAGE_PLAY then
				goNextState()
				stateMachine:requestState(Tutdummy_state.cIntro)
			elseif gTutorialType == tutorialType.MESSAGE_OPTIONS then
				goNextState()
				stateMachine:requestState(Tutdummy_state.cIntro)
			end
		end
	end
end
end
function onExitcWaitDialog()

end
function onEntercEnd()
Tutorial:goNextTutorial()
end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercInteraction()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecInteraction()
if Tutorial:isClosed() then
	if Tutorial:isPlayMode() then
		stateMachine:requestState(Tutdummy_state.cPlay)
	elseif Tutorial:checkPlacement() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcInteraction()
Tutorial:finishInteraction()
end
function onEntercPlay()
Tutorial:unlockInput()
end
function onUpdatecPlay()
if Tutorial:checkPlayMode() then
	if Tutorial:getTutorialType() == tutorialType.MESSAGE_PLAY then
		stateMachine:requestState(Tutdummy_state.cWaitDialogPlay)
	else
		stateMachine:requestState(Tutdummy_state.cExitPlay)
	end
end


end
function onExitcPlay()
Tutorial:lockInput()
if Tutorial:getTutorialType() ~= tutorialType.MESSAGE_PLAY then
	Tutorial:edit()	
else
	gTutorialType = Tutorial:showBubbleNext(nil) -- showing next dialog from C++ code
end
end
function onEntercExitPlay()
gTimer = 60
end
function onUpdatecExitPlay()


if gTimer <= 0 then
	stateMachine:requestState(Tutdummy_state.cIntro)
else
	gTimer = gTimer - 1
end
end
function onExitcExitPlay()
--goNextState() -- showing next dialog from C++ code
end
function onEntercPlayEnter()
Tutorial:play()
stateMachine:requestState(Tutdummy_state.cPlay)
end
function onUpdatecPlayEnter()

end
function onExitcPlayEnter()

end
function onEntercWaitDialogPlay()

end
function onUpdatecWaitDialogPlay()
if Tutorial:isActive() == false then return end
if Tutorial:canReadInput() == false then return end

if Tutorial:getTutorialType() == tutorialType.MESSAGE_PLAY then
	if Input:isTriggered(BUTTON.A) or Tutorial:getAnswer() == tutorialAnswer.NEXT then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntroWaitPlay)
	end
end
end
function onExitcWaitDialogPlay()
gTutorialType = Tutorial:getTutorialType()
end
function onEntercIntroWaitPlay()
stateMachine:requestState(Tutdummy_state.cWaitDialogPlay)
end
function onUpdatecIntroWaitPlay()

end
function onExitcIntroWaitPlay()

end
function onEntercEraserMode()
Tutorial:closeDialog()
Tutorial:unlockInput()
end
function onUpdatecEraserMode()
if Tutorial:isClosed() then
	if Tutorial:isPlayMode() then
		stateMachine:requestState(Tutdummy_state.cPlay)
	elseif Tutorial:checkErasement() == true or true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcEraserMode()
Tutorial:toggleEraseMode()
end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cEnterIntro={}
cEnterIntro.onEnter=onEntercEnterIntro
cEnterIntro.onUpdate=onUpdatecEnterIntro
cEnterIntro.onExit=onExitcEnterIntro
cIntro={}
cIntro.onEnter=onEntercIntro
cIntro.onUpdate=onUpdatecIntro
cIntro.onExit=onExitcIntro
cWaitDialog={}
cWaitDialog.onEnter=onEntercWaitDialog
cWaitDialog.onUpdate=onUpdatecWaitDialog
cWaitDialog.onExit=onExitcWaitDialog
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cInteraction={}
cInteraction.onEnter=onEntercInteraction
cInteraction.onUpdate=onUpdatecInteraction
cInteraction.onExit=onExitcInteraction
cPlay={}
cPlay.onEnter=onEntercPlay
cPlay.onUpdate=onUpdatecPlay
cPlay.onExit=onExitcPlay
cExitPlay={}
cExitPlay.onEnter=onEntercExitPlay
cExitPlay.onUpdate=onUpdatecExitPlay
cExitPlay.onExit=onExitcExitPlay
cPlayEnter={}
cPlayEnter.onEnter=onEntercPlayEnter
cPlayEnter.onUpdate=onUpdatecPlayEnter
cPlayEnter.onExit=onExitcPlayEnter
cWaitDialogPlay={}
cWaitDialogPlay.onEnter=onEntercWaitDialogPlay
cWaitDialogPlay.onUpdate=onUpdatecWaitDialogPlay
cWaitDialogPlay.onExit=onExitcWaitDialogPlay
cIntroWaitPlay={}
cIntroWaitPlay.onEnter=onEntercIntroWaitPlay
cIntroWaitPlay.onUpdate=onUpdatecIntroWaitPlay
cIntroWaitPlay.onExit=onExitcIntroWaitPlay
cEraserMode={}
cEraserMode.onEnter=onEntercEraserMode
cEraserMode.onUpdate=onUpdatecEraserMode
cEraserMode.onExit=onExitcEraserMode
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Tutdummy_state._stateCount,Tutdummy_state.cInit)
stateMachine:register(Tutdummy_state.cInit,cInit)
stateMachine:register(Tutdummy_state.cEnterIntro,cEnterIntro)
stateMachine:register(Tutdummy_state.cIntro,cIntro)
stateMachine:register(Tutdummy_state.cWaitDialog,cWaitDialog)
stateMachine:register(Tutdummy_state.cEnd,cEnd)
stateMachine:register(Tutdummy_state.cInteraction,cInteraction)
stateMachine:register(Tutdummy_state.cPlay,cPlay)
stateMachine:register(Tutdummy_state.cExitPlay,cExitPlay)
stateMachine:register(Tutdummy_state.cPlayEnter,cPlayEnter)
stateMachine:register(Tutdummy_state.cWaitDialogPlay,cWaitDialogPlay)
stateMachine:register(Tutdummy_state.cIntroWaitPlay,cIntroWaitPlay)
stateMachine:register(Tutdummy_state.cEraserMode,cEraserMode)
stateMachine:endRegister()
end

