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
pause_state= {
cGlobals=0,
cRun=1,
cSleep=2,
cQuitLevel=3,
cSaveAndQuitLevel=4,
cRestart=5,
cEditor=6,
cUnpause=7,
cSettings=8,
_stateCount=9
}
-------------------------------------------------------------
function onEntercGlobals()
type = {}
type.Default = -1
type.MyCourses = 0
type.MarioChallenge = 1
type .CourseBotChallengeCourses = 2
type .HundredMarioChallenge = 3
type .CourseWorld = 4
type .StreetPassCourse = 5
type.CourseSelect = 6
type.TutorialAdvanced = 8
type.WorldPlay = 9
type.ValidateCourse = 10

gGameplayType = GlobalData:getGameplayType()

local topScreen = ui:getScreen(2)
local botScreen = ui:getScreen(1)

if gGameplayType == type .CourseBotChallengeCourses then 
	NN_LOG("CourseBot")
	gAnim = topScreen:playAnimation("Mode_Coursebot_ChallengeCourses");
	gAnim = botScreen:playAnimation("StartOver_Edit_Exit");
elseif gGameplayType == type .MyCourses then
	NN_LOG("MyCourses")
	gAnim = topScreen :playAnimation("Mode_CourseBot");
	gAnim = botScreen:playAnimation("StartOver_Edit_Exit");
elseif gGameplayType == type .HundredMarioChallenge then
	NN_LOG("HundredMario")
	gAnim = topScreen :playAnimation("Mode_100Mario");
	gAnim = botScreen:playAnimation("Type__StartOver_SaveQuit");
elseif gGameplayType == type .CourseWorld then
	NN_LOG("CourseWorld")
	gAnim = topScreen :playAnimation("Mode_CourseWorld_RecomCourses");
	gAnim = botScreen:playAnimation("Type__StartOver_ExitCourse");
elseif gGameplayType == type .StreetPassCourse then
	NN_LOG("StreetPass")
	gAnim = topScreen :playAnimation("Mode_StreetPassCourses");
	gAnim = botScreen:playAnimation("Type__StartOver_ExitCourse");
elseif gGameplayType == type.MarioChallenge then
	NN_LOG("MarioChallenge")
	gAnim = topScreen :playAnimation("Mode_SuperMarioChallenge");
	gAnim = botScreen:playAnimation("Type__StartOver_SaveQuit");
elseif gGameplayType == type.WorldPlay then
	NN_LOG("WorldPlay")
	gAnim = topScreen :playAnimation("Mode_CourseBot");
	gAnim = botScreen:playAnimation("StartOver_Edit_Exit");
elseif gGameplayType == type.TutorialAdvanced then
	NN_LOG("Tuorial Advanced")
	gAnim = topScreen:playAnimation("Mode_ClearCheck");
	gAnim = botScreen:playAnimation("Type__StartOver_Quit");
else
	NN_LOG("Default")
	gAnim = topScreen :playAnimation("Mode_ClearCheck");
	gAnim = botScreen:playAnimation("Type_CourseClear");
end

--if gGameplayType == type .CourseBotChallengeCourses or  gGameplayType == type.MarioChallenge then
	-- get challenge and medal values from the game
	--medalChallengeNumber = GlobalData:getLayoutChallengeLevelIndex()
	--gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(medalChallengeNumber)
	--gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(medalChallengeNumber)

	--canEdit = gotNormalMedal and gotSpecialMedal

	--if canEdit == false then
		--ui:getButton("Parts_EditCourse"):forceDisable()
	--end
--end

-- make settings button to stay pressed
function stayInRelease(buttonName)
	local button = ui:getButton(buttonName)
	if button then
		button:setReleaseStay(true)
	end
end

stayInRelease("Settings")
stayInRelease("Parts_StartOver")
stayInRelease("Parts_SaveQuit")
stayInRelease("Parts_ExitCourse")
stayInRelease("Parts_EditCourse")
stayInRelease("Parts_Quit")

stateMachine:requestState(pause_state.cRun)	


end
function onUpdatecGlobals()

end
function onExitcGlobals()

end
function onEntercRun()

end
function onUpdatecRun()
if ui:isActive() and ui:isIdle() and ui:isFocused()  then -- MCAT#2048 - make sure that pause screen is in focus
	if Input:isTriggered(BUTTON.START) then
		Sound:playUnpause()
		ui:goToPreviousScreen()
	end
end
end
function onExitcRun()

end
function onEntercSleep()

end
function onUpdatecSleep()

end
function onExitcSleep()

end
function onEntercQuitLevel()
Sound:playSound("pm_100mario_challenge_start_over")

if gGameplayType == type.CourseBotChallengeCourses then
	GameState:switchScene("CourseBot")
elseif gGameplayType == type.MyCourses then
	GameState:switchScene("CourseBot")
elseif gGameplayType == type.WorldPlay then
	GlobalData:setGameplayType(0)
	GameState:switchScene("CourseBot")
elseif gGameplayType == type.HundredMarioChallenge then
	GameState:switchScene("CourseWorldNew")
elseif gGameplayType == type.CourseWorld then
	GameState:switchScene("CourseWorldNew")
elseif gGameplayType == type.StreetPassCourse then
	GameState:switchScene("CourseWorldNew")
elseif gGameplayType == type.Default then
	GameState:switchScene("debugMenu")
elseif gGameplayType == type.CourseSelect then
	GameState:switchScene("CourseSelect")
elseif gGameplayType == type.TutorialAdvanced then
	GameState:switchSceneByStateID(GlobalData:getRecordedGameState())
elseif gGameplayType == type.ValidateCourse then
	entryType = GlobalData:getCourseBotEntryType()

	if entryType == 5 then 
		GlobalData:setMyCoursesLevelIndex(-1)
		GlobalData:setGameplayType(type.StreetPassCourse)
	else
		GlobalData:setGameplayType(0)	
	end

	GameState:switchScene("CourseBot")
end
end
function onUpdatecQuitLevel()

end
function onExitcQuitLevel()

end
function onEntercSaveAndQuitLevel()
--Save Data Somewhere
Sound:playSound("pm_100mario_challenge_start_over")

if gGameplayType == type.CourseBotChallengeCourses then
	GameState:switchScene("CourseBot")
elseif gGameplayType == type.MyCourses then
	GameState:switchScene("CourseBot")
elseif gGameplayType == type.HundredMarioChallenge then
	--GameState:switchScene("CourseWorldNew")
	GlobalData:setPauseSelectionType(1)
	ui:changeScreen("QuitDialog", false, false)
elseif gGameplayType == type.CourseWorld then
	GameState:switchScene("CourseWorldNew")
elseif gGameplayType == type.StreetPassCourse then
	GameState:switchScene("CourseBot")
elseif gGameplayType == type.Default then
	GameState:switchScene("debugMenu")
elseif gGameplayType == type.CourseSelect then
	GameState:switchScene("CourseSelect")
elseif gGameplayType == type.MarioChallenge then
	--GameState:switchScene("MarioChallangeMap")
	GlobalData:setPauseSelectionType(1)
	ui:changeScreen("QuitDialog", false, false)
	stateMachine:requestState(pause_state.cRun)
elseif gGameplayType == type.TutorialAdvanced then
	GameState:switchSceneByStateID(GlobalData:getRecordedGameState())
end
end
function onUpdatecSaveAndQuitLevel()
-- if we've hit the update loop, we didn't go anywhere so switch back to pause_state.cRun
stateMachine:requestState(pause_state.cRun)
end
function onExitcSaveAndQuitLevel()

end
function onEntercRestart()
GlobalData:setGameRestartPending(true)
Sound:playSound("pm_100mario_challenge_start_over")

if gGameplayType == type.CourseBotChallengeCourses then
	GameState:switchScene("CourseBotChallengeCourseIn")
elseif gGameplayType == type.HundredMarioChallenge then
	-- close the pause menu and allow the game code to handle the transition
	ui:goToPreviousScreen()
	GameState:switchScene("100MarioCourseIn")
elseif gGameplayType == type.MarioChallenge then
	-- close the pause menu and allow the game code to handle the transition
	ui:goToPreviousScreen()
	GameState:switchScene("MarioChallangeCourseIn")
elseif gGameplayType == type.WorldPlay then
	-- close the pause menu and allow the game code to handle the transition
	ui:goToPreviousScreen()
	GameState:switchScene("gameplay")
else
	GameState:switchScene("gameplay")
end
end
function onUpdatecRestart()

end
function onExitcRestart()

end
function onEntercEditor()
if gGameplayType == type .CourseBotChallengeCourses or  gGameplayType == type.MarioChallenge then
	-- get challenge and medal values from the game
	medalChallengeNumber = GlobalData:getLayoutChallengeLevelIndex()
	gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(medalChallengeNumber)
	gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(medalChallengeNumber)

	canEdit = gotNormalMedal and gotSpecialMedal

	if canEdit == false then
		Sound:playSound("pm_save_quit_no")
		GlobalData:setPauseSelectionType(2)
		ui:changeScreen("QuitDialog", false, false)
		stateMachine:requestState(pause_state.cRun)
		Sound:playSound("window_in")
	else
		Sound:playSound("coursebot_window_play")
		if GlobalData:hasSavedLevel() then
			GameState:switchScene("EditorNew")
		else
			GlobalData:setPauseSelectionType(0)
			ui:changeScreen("QuitDialog", false, false)
			stateMachine:requestState(pause_state.cRun)
			Sound:playSound("window_in")
		end
	end
elseif GlobalData:hasSavedLevel() then
	Sound:playSound("coursebot_window_play")
	if gGameplayType == type.ValidateCourse then 
		GlobalData:setGameplayType(type.MyCourses)
	end
	GlobalData:setInfoView(false)
	GameState:switchScene("EditorNew")
else
	Sound:playSound("coursebot_window_play")
	GlobalData:setPauseSelectionType(0)
	ui:changeScreen("QuitDialog", false, false)
	stateMachine:requestState(pause_state.cRun)
	Sound:playSound("window_in")
end
end
function onUpdatecEditor()

end
function onExitcEditor()

end
function onEntercUnpause()
Sound:playUnpause()
ui:goToPreviousScreen()
stateMachine:requestState(pause_state.cRun)

end
function onUpdatecUnpause()

end
function onExitcUnpause()

end
function onEntercSettings()
GlobalData:addPlayReportVal("sys020")
ui:changeScreen("Settings", false, false)
stateMachine:requestState(pause_state.cRun)
end
function onUpdatecSettings()

end
function onExitcSettings()

end
-------------------------------------------------------------
cGlobals={}
cGlobals.onEnter=onEntercGlobals
cGlobals.onUpdate=onUpdatecGlobals
cGlobals.onExit=onExitcGlobals
cRun={}
cRun.onEnter=onEntercRun
cRun.onUpdate=onUpdatecRun
cRun.onExit=onExitcRun
cSleep={}
cSleep.onEnter=onEntercSleep
cSleep.onUpdate=onUpdatecSleep
cSleep.onExit=onExitcSleep
cQuitLevel={}
cQuitLevel.onEnter=onEntercQuitLevel
cQuitLevel.onUpdate=onUpdatecQuitLevel
cQuitLevel.onExit=onExitcQuitLevel
cSaveAndQuitLevel={}
cSaveAndQuitLevel.onEnter=onEntercSaveAndQuitLevel
cSaveAndQuitLevel.onUpdate=onUpdatecSaveAndQuitLevel
cSaveAndQuitLevel.onExit=onExitcSaveAndQuitLevel
cRestart={}
cRestart.onEnter=onEntercRestart
cRestart.onUpdate=onUpdatecRestart
cRestart.onExit=onExitcRestart
cEditor={}
cEditor.onEnter=onEntercEditor
cEditor.onUpdate=onUpdatecEditor
cEditor.onExit=onExitcEditor
cUnpause={}
cUnpause.onEnter=onEntercUnpause
cUnpause.onUpdate=onUpdatecUnpause
cUnpause.onExit=onExitcUnpause
cSettings={}
cSettings.onEnter=onEntercSettings
cSettings.onUpdate=onUpdatecSettings
cSettings.onExit=onExitcSettings
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (pause_state._stateCount,pause_state.cGlobals)
stateMachine:register(pause_state.cGlobals,cGlobals)
stateMachine:register(pause_state.cRun,cRun)
stateMachine:register(pause_state.cSleep,cSleep)
stateMachine:register(pause_state.cQuitLevel,cQuitLevel)
stateMachine:register(pause_state.cSaveAndQuitLevel,cSaveAndQuitLevel)
stateMachine:register(pause_state.cRestart,cRestart)
stateMachine:register(pause_state.cEditor,cEditor)
stateMachine:register(pause_state.cUnpause,cUnpause)
stateMachine:register(pause_state.cSettings,cSettings)
stateMachine:endRegister()
end

