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
ChallengeCourseClear_state= {
cInit=0,
cIntro=1,
cIdle=2,
cMedals=3,
cBounce=4,
cButtonA=5,
cButtonB=6,
cButtonC=7,
cOutro=8,
cDone=9,
cGoToMarioChallangeMap=10,
cGoToUnlockState=11,
cBotIn=12,
cButtonD=13,
_stateCount=14
}
-------------------------------------------------------------
function onEntercInit()
inState = {}
inState.StartOver_SaveQuit = 0
inState.Next_StartOver_SaveQuit = 1
inState.Next_StartOver = 2
inState.StartOver_Quit_Edit = 3

type = {}
type.Default = -1
type .MyCourses = 0
type.MarioChallenge = 1
type .CourseBotChallengeCourses = 2
type .HundredMarioChallenge = 3
type .CourseWorld = 4
type .StreetPassCourse = 5
type.CourseSelect = 6

gGameplayType = GlobalData:getGameplayType()

gCurChallengeCourse = 0
gNextChallengeCourse = 0
gIsUnlockSeen = false
gIsFinishedLastWorldLevel = false
gIsAtCastle = false

topScreen = ui:getScreen(SCREEN.TOP)
botScreen = ui:getScreen(SCREEN.BOTTOM)

CourseBotLevel = 99
CourseBotWorld = 19 -- MCAT#3057 - world should be 19 (actualy indexing starts at 1)

function DEBUG_PRINT(result, messageTrue, messageFalse)
	if result then
		NN_LOG(messageTrue)
	else
		NN_LOG(messageFalse)
	end
end

function isWorldFinished(curLevelOffset, nextLevelOffset)
	local curWorld = GlobalData:getChallengeMapWorldIndex(curLevelOffset)
	local nextWorld = GlobalData:getChallengeMapWorldIndex(nextLevelOffset)
	return curWorld ~= nextWorld
end

function startFaderIn()
	local faderUI = ui:getUI("faderSquares")
	if faderUI then
		NN_LOG("FOUND FADER")
		faderUI:getScreen(SCREEN.BOTTOM):playAnimation("InBlock", false)
		return faderUI:getScreen(SCREEN.TOP):playAnimation("InBlock", false)
	end
	return nil
end

-- MCAT#2835 - check if need to show world 19 unlock
function world19UnlockCheck()
	local showWorld19Unlock = GlobalData:isWorld19Unlocked() and not GlobalData:isWorld19UnlockedSeen()
	if showWorld19Unlock then
		GlobalData:setWorld19UnlockedSeen()
	end
	return showWorld19Unlock
end

gShowWorld19Unlock = world19UnlockCheck()

--gCurChallengeCourse, cNextChallengeCourse, gIsFinishedLastWorldLevel, gIsAtCastle, gIsUnlockSeen
function getChallengeInfo()
	local curLevel = GlobalData:getChallengeLevelIndex()
	local nextLevel = curLevel + 1
	local beatChallengeMode = curLevel >= 87
	local worldIdx = GlobalData:getChallengeWorldIndex()
	local isUnlockSeen = GlobalData:isUnlockSeen(worldIdx) -- MCAT#2461
	local isAtCastle = isWorldFinished(curLevel, nextLevel) -- MCAT#2461 - at castle flag was set incorectly
	
	-- mark unlock as seen, just in case player shuts down the system
	if isAtCastle then
		GlobalData:setUnlockSeen(worldIdx)
		GlobalData:setChallengeMapWorldFinished(worldIdx) -- mCAT#2782 - seperate world unlock and what world player is on
	end
	return curLevel, nextLevel, beatChallengeMode, isAtCastle, isUnlockSeen
end
buttonA = botScreen:getButton("L_NextBtn_00")
if gGameplayType == type.MarioChallenge then
	gCurChallengeCourse, gNextChallengeCourse, gIsFinishedLastWorldLevel, gIsAtCastle, gIsUnlockSeen = getChallengeInfo()
	-- MCAT#3150 - reset  challenge map mode if we are on the last level
	if gIsFinishedLastWorldLevel then
		GlobalData:setCreditsOpen() -- MCAT#3210 - (a) credits not being open on reseting the system during results
		GlobalData:setRestartChallengeMap(false)
		GlobalData:setChallengePlaying(false)
	end
	DEBUG_PRINT(gIsUnlockSeen, "Unlock Seen", "Unlock not Seen")
	DEBUG_PRINT(gIsAtCastle, "At Castle", "Not at Castle")
	local btnAnim = botScreen:playAnimation("ClearType", false)
	if btnAnim then
		btnAnim:stop()
		-- MCAT#2967 - make sure that any new message is about adding new course to course bot
		if gShowWorld19Unlock then
			NN_LOG("Next_StartOver")
			topScreen:setTextFromMessageID("T_CourseGetText_00", "T_CourseGetText_02")
		else
			topScreen:setTextFromMessageID("T_CourseGetText_00", "T_CourseGetText_01")
		end
		if GlobalData:getChallengeLevelIndex() >= 87 then
			btnAnim:setFrame(inState.Next_StartOver) -- MCAT#1478, #1491, #1684 - show 'Next' 'Start Over'
		else
			NN_LOG("Next_StartOver_SaveQuit")
			btnAnim:setFrame(inState.Next_StartOver_SaveQuit)
		end
	end
end

if gGameplayType == type.CourseBotChallengeCourses then
	-- change button text for course bot challange course
	botScreen:setButtonMessageId("L_ExitBtn_00", "T_Btn_00", "T_ExitBtn_00")
	local anim = botScreen:playAnimation("ClearType", false)
	anim:stop()
	anim:setFrame(3)
	if GlobalData:getChallengeLevelIndex() >= 88 then
		topScreen:setTextFromMessageID("T_CourseGetText_00", "T_CourseGetText_02")
	end
end

-- get challenge and medal values from the game
challengeIndex = GlobalData:getLayoutChallengeLevelIndex()
gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(challengeIndex)
gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(challengeIndex)
isNormalMedalNew = GlobalData:getNormalChallengeCompleteNew()
isSpecialMedalNew = GlobalData:getSpecialChallengeCompleteNew()

gHasBothMedals = gotSpecialMedal and gotNormalMedal and (isNormalMedalNew or isSpecialMedalNew)

do
	local editButton = ui:getButton("L_EditBtn_00")
	if editButton ~= nil and gotNormalMedal and gotSpecialMedal then
		editButton:setButtonOverrideSFXByName("ON_RELEASED", "coursebot_window_play")
	else
		editButton:setButtonOverrideSFXByName("ON_RELEASED", "pm_save_quit_no")
	end
end

-- determine what to do
setNormalMedalOn = (gotNormalMedal  and not isNormalMedalNew)
setSpecialMedalOn = (gotSpecialMedal and not isSpecialMedalNew)
needNormalMedalIn = isNormalMedalNew 
needSpecialMedalIn = isSpecialMedalNew
medalChallengeNumber = challengeIndex

-- we will immediately show the special text if the user already gotten one of the medals previously
showingSpecialText = setNormalMedalOn or setSpecialMedalOn 

-- start setting up the layout
Medals:setupTextMessages(medalChallengeNumber)

animTopIn = topScreen:playAnimation("Default")

Medals:setStatus(0, setNormalMedalOn )
Medals:setStatus(1, setSpecialMedalOn )

if showingSpecialText then
	Medals:showSpecialText()
end

-- Show proper level number
topScreen:setTextW("T_CourseName_00", GlobalData:setChallengeLevelName())
if GlobalData:isNewCourseAddedToCourseBot() == false then
	topScreen:setVisible("T_CourseGetText_00", false)
end

-- MCAT#3057 - world 19 was never marked as finished, and this variable is used for unlocking items in the editor
if gGameplayType == type.CourseBotChallengeCourses then
	local isSeen = GlobalData:isUnlockSeen(CourseBotWorld) 
	if GlobalData:getChallengeLevelIndex() == CourseBotLevel and isSeen == false then
			GlobalData:setChallengeMapWorldFinished(19) 
	end
end

-- MCAT#1028 - disable ui input before medals presentations start
ui:disableInput()
GlobalData:writeProgress(false) -- force save the progress (MCAT#3150)
stateMachine:requestState(ChallengeCourseClear_state.cIntro)
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercIntro()
NN_LOG("Enter State cIntro")

animTopIn = topScreen:playAnimation("In")
animBotIn = botScreen :playAnimation("In")

          
end
function onUpdatecIntro()
if animTopIn ~= nil and animTopIn:isPlaying() == false then
	animTopIn = nil
	animTopInEx = topScreen:playAnimation("exprtInt_in_00")
end

if animTopInEx ~= nil and animTopInEx :isPlaying() == false then
            stateMachine:requestState(ChallengeCourseClear_state.cMedals)
            --stateMachine:requestState(ChallengeCourseClear_state.cIdle)
end

end
function onExitcIntro()

end
function onEntercIdle()
NN_LOG("Enter State cIdle")
-- MCAT#1028 - return ui input after medal animations
ui:enableInput()

if gotNormalMedal then
	Medals:playShineAnimation(0)
end

if gotSpecialMedal then
	Medals:playShineAnimation(1)
end
end
function onUpdatecIdle()

end
function onExitcIdle()

end
function onEntercMedals()
NN_LOG("Enter State cMedals")

gTimer = 0
if needNormalMedalIn then
	Sound:playSound("cm_goal_achieved")
	Medals:playInAnimation(0)
	Medals:setDrawingToFront("Coin")
elseif needSpecialMedalIn then
	Sound:playSound("cm_goal_achieved")
	Medals:playInAnimation(1)
	Medals:setDrawingToFront("Coin_00")
end
end
function onUpdatecMedals()
-- add delay before showing second medal
if gTimer > 0 then
	gTimer = gTimer - 1
	return
end

if needNormalMedalIn then
	if Medals:isInAnimationDone(0) then
		needNormalMedalIn  = false

		if not showingSpecialText then
			Medals:showSpecialText()
			showingSpecialText = true
		end

		if needSpecialMedalIn then
			gTimer = 60
			Sound:playSound("cm_goal_achieved")
			Medals:playInAnimation(1)		
			Medals:setDrawingToFront("Coin_00")	
		end
	end
elseif needSpecialMedalIn then
	if Medals:isInAnimationDone(1) then
		needSpecialMedalIn = false
	end
	if not showingSpecialText then
		Medals:showSpecialText()
		showingSpecialText = true
	end
else
	if gHasBothMedals then
		stateMachine:requestState(ChallengeCourseClear_state.cBounce)
	else
		stateMachine:requestState(ChallengeCourseClear_state.cBotIn)
	end
end
end
function onExitcMedals()

end
function onEntercBounce()
gBounceAnim = ui:getScreen(SCREEN.TOP):playAnimation("Medal_All", false)
Sound:playSound("cm_goal_achieved_bounce")
if not gBounceAnim then
	stateMachine:requestState(ChallengeCourseClear_state.cIdle)
end
end
function onUpdatecBounce()
if gBounceAnim:isPlaying() == false then
	stateMachine:requestState(ChallengeCourseClear_state.cBotIn)
end
end
function onExitcBounce()

end
function onEntercButtonA()
ui:disableInput() -- mcat #614 - stop taking input
--gCurChallengeCourse, gNextChallengeCourse, gIsFinishedLastWorldLevel, gIsAtCastle, gIsUnlockSeen
if GlobalData:getGameplayType() == type.MarioChallenge then
	if gIsFinishedLastWorldLevel then
		-- challenge mode finished, go to end sequence
		GlobalData:setCreditsOpen()
		if not gIsUnlockSeen or gShowWorld19Unlock then
			stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)	
		else
			GameState:switchScene("MarioChallengeEndWorldFinish")
		end
	else
		GlobalData:setChallengeLevelIndex(gNextChallengeCourse)
		GlobalData:setChallengeLevelPresentationIndex(gCurChallengeCourse) -- for walking from current node to the next node
		-- set quiting reason
		GlobalData:setChallengeModeLeaveReason(1)
		GlobalData:writeToSaveDataChallengeMode()
		if gIsAtCastle and not gIsUnlockSeen  or gShowWorld19Unlock then
			stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
		else
			stateMachine:requestState(ChallengeCourseClear_state.cGoToMarioChallangeMap)
		end
	end
end
end
function onUpdatecButtonA()

end
function onExitcButtonA()

end
function onEntercButtonB()
ui:disableInput() -- mcat #614 - stop taking input

GlobalData:setGameRestartPending(true)

if gGameplayType == type.CourseBotChallengeCourses then
	local isSeen = GlobalData:isUnlockSeen(CourseBotWorld) 
	if GlobalData:getChallengeLevelIndex() == CourseBotLevel and isSeen == false then
			GlobalData:setNextState(2) --CourseBotChallengeCourseIn
			GlobalData:setUnlockSeen(CourseBotWorld)
			stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
	elseif gShowWorld19Unlock then
		GlobalData:setNextState(2) --CourseBotChallengeCourseIn (MCAT#3161) - tell to replay level
		stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
	else
		GameState:switchScene("CourseBotChallengeCourseIn")
	end
elseif gGameplayType == type.HundredMarioChallenge then
	GameState:switchScene("MarioChallangeCourseIn")
elseif gGameplayType == type.MarioChallenge then 
--gCurChallengeCourse, gNextChallengeCourse, gIsFinishedLastWorldLevel, gIsAtCastle, gIsUnlockSeen
	if (gIsAtCastle or gIsFinishedLastWorldLevel) and not gIsUnlockSeen or gShowWorld19Unlock then
		GlobalData:setRestartChallengeCourse(true)
		stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
	else
		GameState:switchScene("MarioChallangeCourseIn") -- start over
	end
else 
	GameState:switchScene("gameplay")
end
end
function onUpdatecButtonB()

end
function onExitcButtonB()

end
function onEntercButtonC()
if GlobalData:getGameplayType() == type.MarioChallenge then
 --gCurChallengeCourse, gNextChallengeCourse, gIsFinishedLastWorldLevel, gIsAtCastle, gIsUnlockSeen
	GlobalData:setChallengeLevelIndex(gNextChallengeCourse)
	GlobalData:setChallengeLevelPresentationIndex(gCurChallengeCourse)
	GlobalData:writeToSaveDataChallengeMode()
	-- set quiting reason
	GlobalData:setChallengeModeLeaveReason(3)
	if gIsAtCastle and not gIsUnlockSeen  or gShowWorld19Unlock  then
		GameState:switchScene("UnlockState")
	else
		GameState:switchScene("MarioChallangeMap")
	end
else
	local isSeen = GlobalData:isUnlockSeen(CourseBotWorld) 
	if GlobalData:getChallengeLevelIndex() == CourseBotLevel and isSeen == false then
			GlobalData:setNextState(1) --coursebot
			GlobalData:setUnlockSeen(CourseBotWorld)
			stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
	elseif  gShowWorld19Unlock then
		GlobalData:setNextState(1) --coursebot
		stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
	else
			stateMachine:requestState(ChallengeCourseClear_state.cOutro)
	end
end
end
function onUpdatecButtonC()

end
function onExitcButtonC()

end
function onEntercOutro()
GlobalData:setNormalChallengeCompleteNew(false)
GlobalData:setSpecialChallengeCompleteNew(false)

if gGameplayType == type.CourseBotChallengeCourses then
	GameState:switchScene("CourseBot")
else
	GameState:switchScene("MarioChallangeMap")
end
         
end
function onUpdatecOutro()

end
function onExitcOutro()

end
function onEntercDone()

end
function onUpdatecDone()

end
function onExitcDone()

end
function onEntercGoToMarioChallangeMap()
gFaderAnim = startFaderIn()
end
function onUpdatecGoToMarioChallangeMap()
if gFaderAnim == nil then
	stateMachine:requestState(ChallengeCourseClear_state.cDone)
	return
end

if gFaderAnim:isPlaying() == false then
	stateMachine:requestState(ChallengeCourseClear_state.cDone)
	return
end


end
function onExitcGoToMarioChallangeMap()
GameState:switchScene("MarioChallangeMap")
end
function onEntercGoToUnlockState()
gFaderAnim = startFaderIn()
end
function onUpdatecGoToUnlockState()
if gFaderAnim == nil then
	stateMachine:requestState(ChallengeCourseClear_state.cDone)
	return
end

if gFaderAnim:isPlaying() == false then
	stateMachine:requestState(ChallengeCourseClear_state.cDone)
	return
end


end
function onExitcGoToUnlockState()
GameState:switchScene("UnlockState")
end
function onEntercBotIn()
animBotIn = botScreen :playAnimation("B_In_00")
end
function onUpdatecBotIn()
if animBotIn ~= nil and animBotIn:isPlaying() == false then
	stateMachine:requestState(ChallengeCourseClear_state.cIdle)
end
end
function onExitcBotIn()

end
function onEntercButtonD()
--edit button

-- get challenge and medal values from the game
medalChallengeNumber = GlobalData:getLayoutChallengeLevelIndex()
gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(medalChallengeNumber)
gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(medalChallengeNumber)

canEdit = gotNormalMedal and gotSpecialMedal

if canEdit == false then
	GlobalData:setPauseSelectionType(2)
	ui:changeScreen("QuitDialog", false, false)
	stateMachine:requestState(ChallengeCourseClear_state.cIdle)
	Sound:playSound("window_in")
else
	if GlobalData:hasSavedLevel() then
		GlobalData:setInfoView(false)
		local isSeen = GlobalData:isUnlockSeen(CourseBotWorld) 
		if GlobalData:getChallengeLevelIndex() == CourseBotLevel and isSeen == false then
			GlobalData:setNextState(0) --editor
			stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
			GlobalData:setUnlockSeen(CourseBotWorld)
		elseif gShowWorld19Unlock then
			GlobalData:setNextState(0) --editor
			stateMachine:requestState(ChallengeCourseClear_state.cGoToUnlockState)
		else
			GameState:switchScene("EditorNew")
		end
	else
		GlobalData:setPauseSelectionType(0)
		ui:changeScreen("QuitDialog", false, false)
		stateMachine:requestState(ChallengeCourseClear_state.cIdle)
		Sound:playSound("window_in")
	end
end
end
function onUpdatecButtonD()

end
function onExitcButtonD()

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
cIdle={}
cIdle.onEnter=onEntercIdle
cIdle.onUpdate=onUpdatecIdle
cIdle.onExit=onExitcIdle
cMedals={}
cMedals.onEnter=onEntercMedals
cMedals.onUpdate=onUpdatecMedals
cMedals.onExit=onExitcMedals
cBounce={}
cBounce.onEnter=onEntercBounce
cBounce.onUpdate=onUpdatecBounce
cBounce.onExit=onExitcBounce
cButtonA={}
cButtonA.onEnter=onEntercButtonA
cButtonA.onUpdate=onUpdatecButtonA
cButtonA.onExit=onExitcButtonA
cButtonB={}
cButtonB.onEnter=onEntercButtonB
cButtonB.onUpdate=onUpdatecButtonB
cButtonB.onExit=onExitcButtonB
cButtonC={}
cButtonC.onEnter=onEntercButtonC
cButtonC.onUpdate=onUpdatecButtonC
cButtonC.onExit=onExitcButtonC
cOutro={}
cOutro.onEnter=onEntercOutro
cOutro.onUpdate=onUpdatecOutro
cOutro.onExit=onExitcOutro
cDone={}
cDone.onEnter=onEntercDone
cDone.onUpdate=onUpdatecDone
cDone.onExit=onExitcDone
cGoToMarioChallangeMap={}
cGoToMarioChallangeMap.onEnter=onEntercGoToMarioChallangeMap
cGoToMarioChallangeMap.onUpdate=onUpdatecGoToMarioChallangeMap
cGoToMarioChallangeMap.onExit=onExitcGoToMarioChallangeMap
cGoToUnlockState={}
cGoToUnlockState.onEnter=onEntercGoToUnlockState
cGoToUnlockState.onUpdate=onUpdatecGoToUnlockState
cGoToUnlockState.onExit=onExitcGoToUnlockState
cBotIn={}
cBotIn.onEnter=onEntercBotIn
cBotIn.onUpdate=onUpdatecBotIn
cBotIn.onExit=onExitcBotIn
cButtonD={}
cButtonD.onEnter=onEntercButtonD
cButtonD.onUpdate=onUpdatecButtonD
cButtonD.onExit=onExitcButtonD
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (ChallengeCourseClear_state._stateCount,ChallengeCourseClear_state.cInit)
stateMachine:register(ChallengeCourseClear_state.cInit,cInit)
stateMachine:register(ChallengeCourseClear_state.cIntro,cIntro)
stateMachine:register(ChallengeCourseClear_state.cIdle,cIdle)
stateMachine:register(ChallengeCourseClear_state.cMedals,cMedals)
stateMachine:register(ChallengeCourseClear_state.cBounce,cBounce)
stateMachine:register(ChallengeCourseClear_state.cButtonA,cButtonA)
stateMachine:register(ChallengeCourseClear_state.cButtonB,cButtonB)
stateMachine:register(ChallengeCourseClear_state.cButtonC,cButtonC)
stateMachine:register(ChallengeCourseClear_state.cOutro,cOutro)
stateMachine:register(ChallengeCourseClear_state.cDone,cDone)
stateMachine:register(ChallengeCourseClear_state.cGoToMarioChallangeMap,cGoToMarioChallangeMap)
stateMachine:register(ChallengeCourseClear_state.cGoToUnlockState,cGoToUnlockState)
stateMachine:register(ChallengeCourseClear_state.cBotIn,cBotIn)
stateMachine:register(ChallengeCourseClear_state.cButtonD,cButtonD)
stateMachine:endRegister()
end

