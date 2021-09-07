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
cSkinMode=12,
cThemeMode=13,
cAutoScrollMode=14,
cTimeMode=15,
cEnteringSubArea=16,
cEnterReset=17,
cEnterUndo=18,
cTrailMode=19,
cSFXModeEnter=20,
cInteractionReNotification=21,
cInit2=22,
_stateCount=23
}
-------------------------------------------------------------
function onEntercInit()
uiInputIDs = {}
uiInputIDs.General = 0
uiInputIDs.Tutorial = 1
uiInputIDs.TutorialToPlay = 2
uiInputIDs.Conversation = 3
Tutorial:showTitle() -- show tutorial title the frame we come in tutorial
stateMachine:requestState(Tutdummy_state.cInit2)

end
function onUpdatecInit()

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
		stateMachine:requestState(Tutdummy_state.cWaitDialogPlay)
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
if gTutorialType == tutorialType.INVALID then -- #11321 - the last advanced tutorial will return back to the tutorial menu selection
	stateMachine:requestState(Tutdummy_state.cEnd)
else
	stateMachine:requestState(Tutdummy_state.cWaitDialog)
end

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
				-- disable input early
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
-- most propbraly last advanced tutorial if message studio is setup correctly
if Tutorial:isLastTutorial() == true then
	GlobalData:addPlayReportVal("blc500")
end
GameState:switchSceneByStateID(GlobalData:getRecordedGameState())
--Tutorial:goNextTutorial()
end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercInteraction()
gInteractionTimer = 30 -- #11306 - delaying interaction with level after tutorial closing
gReNotificationTimer = 30*60 -- #10285 - every 30 seconds tell the player what have to be done

Tutorial:closeDialog()
--Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);


-- have to call after :closeDialog() as it disabled mainMenu input
GlobalData:clearBusy() -- mcat #855 - let to open main menu with start button
end
function onUpdatecInteraction()
if gInteractionTimer == 1 then
	Tutorial:unlockInput()
	ui:enableInput(uiInputIDs.Conversation) -- MCAT#855 - clear conversation flag
	gInteractionTimer = 0
elseif gInteractionTimer > 1 then -- make sure that unlock input is not called every frame
	gInteractionTimer = gInteractionTimer - 1
	return
end

if Tutorial:isClosed() then
	if Tutorial:isPlayMode() then
		stateMachine:requestState(Tutdummy_state.cPlay)
	elseif Tutorial:checkPlacement() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end

if Tutorial:isNotificationEnabled() then -- show notification only when reset button is active
	if gReNotificationTimer > 0 then
		gReNotificationTimer = gReNotificationTimer - 1
	else
		-- MCAT#2235 - do not show notification while screen is touched
		if Input:isTouched() == false then
			stateMachine:requestState(Tutdummy_state.cInteractionReNotification)
		end
	end
end
end
function onExitcInteraction()
GlobalData:setBusy()
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
	--gTutorialType = Tutorial:showBubbleNext(nil) -- showing next dialog from C++ code
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
gTimer = 30

end
function onUpdatecPlayEnter()
if gTimer == 0 then
	stateMachine:requestState(Tutdummy_state.cPlay)
else 
	gTimer = gTimer - 1
end
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
if Tutorial:getTutorialType() ~= tutorialType.MESSAGE_PLAY then
	Tutorial:lockInput()
	Tutorial:edit()
	stateMachine:requestState(Tutdummy_state.cExitPlay)
else
	stateMachine:requestState(Tutdummy_state.cWaitDialogPlay)
end
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
	elseif Tutorial:checkErasement() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcEraserMode()
Tutorial:toggleEraseMode()
end
function onEntercSkinMode()
Tutorial:unlockInput()
end
function onUpdatecSkinMode()
if Tutorial:isClosed() then
	if Tutorial:hasChosenSkin() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcSkinMode()

end
function onEntercThemeMode()
Tutorial:unlockInput()
end
function onUpdatecThemeMode()
if Tutorial:isClosed() then
	if Tutorial:hasChosenTheme() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcThemeMode()

end
function onEntercAutoScrollMode()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecAutoScrollMode()
if Tutorial:isClosed() then
	if Tutorial:hasChosenAutoScroll() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end

	

end
function onExitcAutoScrollMode()
Tutorial:finishInteraction()
end
function onEntercTimeMode()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecTimeMode()
if Tutorial:isClosed() then
	if Tutorial:hasChosenTime() == true then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcTimeMode()
Tutorial:finishInteraction()
end
function onEntercEnteringSubArea()
Tutorial:unlockInput()
end
function onUpdatecEnteringSubArea()
if Tutorial:isClosed() then
	if Tutorial:hasEnteredSubArea() == true then
		stateMachine:requestState(Tutdummy_state.cPlayEnter)
	end
end
end
function onExitcEnteringSubArea()

end
function onEntercEnterReset()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecEnterReset()
if Tutorial:isClosed() then
	if Tutorial:checkReset() then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcEnterReset()
Tutorial:finishInteraction()
end
function onEntercEnterUndo()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecEnterUndo()
if Tutorial:isClosed() then
	if Tutorial:checkUndo() then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcEnterUndo()
Tutorial:finishInteraction()
end
function onEntercTrailMode()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecTrailMode()
if Tutorial:isClosed() then
	if Tutorial:checkTrail() then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end
end
end
function onExitcTrailMode()
Tutorial:finishInteraction()
end
function onEntercSFXModeEnter()
Tutorial:closeDialog()
Tutorial:unlockInput()
Editor:tellState(STATE_MAIN_MENU);
end
function onUpdatecSFXModeEnter()
if Tutorial:isClosed() then
	if Tutorial:checkSFXChoosen() then
		goNextState()
		stateMachine:requestState(Tutdummy_state.cIntro)
	end 
end
end
function onExitcSFXModeEnter()
Tutorial:finishInteraction()
end
function onEntercInteractionReNotification()
Tutorial:lockInput()
Tutorial:showBubbleNext("TutAll_Basic_PlayCheck_02")
end
function onUpdatecInteractionReNotification()
if Tutorial:isActive() == false then return end
if Tutorial:canReadInput() == false then return end


if Input:isTriggered(BUTTON.A) or Tutorial:getAnswer() == tutorialAnswer.NEXT then
	stateMachine:requestState(Tutdummy_state.cInteraction)
end
end
function onExitcInteractionReNotification()

end
function onEntercInit2()
Editor:tellState(STATE_MAIN_MENU);


Tutorial:lockInput()
gTimer = 60 -- wait for 1 second for everything to finish loading

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
function onUpdatecInit2()
-- do not update counter if editor is not focused
if not ui:getUI("Editor"):isFocused() then
	return
end

gTimer = gTimer - 1

if gTimer <= 0 then
	stateMachine:requestState(Tutdummy_state.cEnterIntro)
end
end
function onExitcInit2()

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
cSkinMode={}
cSkinMode.onEnter=onEntercSkinMode
cSkinMode.onUpdate=onUpdatecSkinMode
cSkinMode.onExit=onExitcSkinMode
cThemeMode={}
cThemeMode.onEnter=onEntercThemeMode
cThemeMode.onUpdate=onUpdatecThemeMode
cThemeMode.onExit=onExitcThemeMode
cAutoScrollMode={}
cAutoScrollMode.onEnter=onEntercAutoScrollMode
cAutoScrollMode.onUpdate=onUpdatecAutoScrollMode
cAutoScrollMode.onExit=onExitcAutoScrollMode
cTimeMode={}
cTimeMode.onEnter=onEntercTimeMode
cTimeMode.onUpdate=onUpdatecTimeMode
cTimeMode.onExit=onExitcTimeMode
cEnteringSubArea={}
cEnteringSubArea.onEnter=onEntercEnteringSubArea
cEnteringSubArea.onUpdate=onUpdatecEnteringSubArea
cEnteringSubArea.onExit=onExitcEnteringSubArea
cEnterReset={}
cEnterReset.onEnter=onEntercEnterReset
cEnterReset.onUpdate=onUpdatecEnterReset
cEnterReset.onExit=onExitcEnterReset
cEnterUndo={}
cEnterUndo.onEnter=onEntercEnterUndo
cEnterUndo.onUpdate=onUpdatecEnterUndo
cEnterUndo.onExit=onExitcEnterUndo
cTrailMode={}
cTrailMode.onEnter=onEntercTrailMode
cTrailMode.onUpdate=onUpdatecTrailMode
cTrailMode.onExit=onExitcTrailMode
cSFXModeEnter={}
cSFXModeEnter.onEnter=onEntercSFXModeEnter
cSFXModeEnter.onUpdate=onUpdatecSFXModeEnter
cSFXModeEnter.onExit=onExitcSFXModeEnter
cInteractionReNotification={}
cInteractionReNotification.onEnter=onEntercInteractionReNotification
cInteractionReNotification.onUpdate=onUpdatecInteractionReNotification
cInteractionReNotification.onExit=onExitcInteractionReNotification
cInit2={}
cInit2.onEnter=onEntercInit2
cInit2.onUpdate=onUpdatecInit2
cInit2.onExit=onExitcInit2
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
stateMachine:register(Tutdummy_state.cSkinMode,cSkinMode)
stateMachine:register(Tutdummy_state.cThemeMode,cThemeMode)
stateMachine:register(Tutdummy_state.cAutoScrollMode,cAutoScrollMode)
stateMachine:register(Tutdummy_state.cTimeMode,cTimeMode)
stateMachine:register(Tutdummy_state.cEnteringSubArea,cEnteringSubArea)
stateMachine:register(Tutdummy_state.cEnterReset,cEnterReset)
stateMachine:register(Tutdummy_state.cEnterUndo,cEnterUndo)
stateMachine:register(Tutdummy_state.cTrailMode,cTrailMode)
stateMachine:register(Tutdummy_state.cSFXModeEnter,cSFXModeEnter)
stateMachine:register(Tutdummy_state.cInteractionReNotification,cInteractionReNotification)
stateMachine:register(Tutdummy_state.cInit2,cInit2)
stateMachine:endRegister()
end

