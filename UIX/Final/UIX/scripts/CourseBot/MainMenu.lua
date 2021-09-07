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
MainMenu_state= {
cInit=0,
cMarioChallenge=1,
cCourseWorld=2,
cCourseBot=3,
cEditor=4,
cProfile=5,
cSettings=6,
cTutorial=7,
cTitle=8,
cEnd=9,
cExit=10,
cJumpToManual=11,
_stateCount=12
}
-------------------------------------------------------------
function onEntercInit()
gameState = {}
gameState.MARIO_CHALLANGE_MAP_STATE = 12
gameState.COURSE_BOT_STATE = 19
gameState.COURSE_EDIT_STATE = 7
gameState.COURSE_WORLD_STATE = 18
gameState.TUTORIAL_EDIT_STATE = 23
gameState.TUTORIAL_STATE = 16


-- trying to put code in one place to keep it easier to maintain
local state = GameState:getState()
if state == gameState.MARIO_CHALLANGE_MAP_STATE then
	ui:bindPadToButton(BUTTON.START, "MapLong", "L_MenuBtn_00")
	ui:bindPadToButton(BUTTON.START, "MainMenuBtn", "btn_MainMenu")
elseif state == gameState.COURSE_BOT_STATE then
	ui:bindPadToButton(BUTTON.START, "courseBot", "Parts_Menu_00")
	ui:bindPadToButton(BUTTON.B, "courseBot", "Parts_Back_00")
	ui:bindPadToButton(BUTTON.SELECT, "courseBot", "Parts_Category_00")
elseif state == gameState.TUTORIAL_STATE or state == gameState.TUTORIAL_EDIT_STATE then
	ui:bindPadToButton(BUTTON.START, "Editor", "btn_mainmenu")
	ui:bindPadToButton(BUTTON.START, "MainMenuBtn", "btn_MainMenu") -- MCAT#855 - register start button to main menu btn during conversation
	ui:bindPadToButton(BUTTON.A, "Dialog", "Parts_00") -- bind to conversation 'A' button
	ui:bindPadToButton(BUTTON.A, "Dialog", "Parts_16") -- bind to conversation 'A' button
elseif  state == gameState.COURSE_EDIT_STATE then
	ui:bindPadToButton(BUTTON.START, "Editor", "btn_mainmenu")
	ui:bindPadToButton(BUTTON.SELECT, "Editor", "btn_play")
	ui:bindPadToButton(BUTTON.SELECT, "Editor", "btn_edit")
elseif state == gameState.COURSE_WORLD_STATE then
	ui:bindPadToButton(BUTTON.START, "CourseWorld", "mainMenu")
	ui:bindPadToButton(BUTTON.START, "Recommended", "mainMenu")
	ui:bindPadToButton(BUTTON.START, "StreetPassOutbox", "mainMenu")
	ui:bindPadToButton(BUTTON.START, "StreetPassInbox", "mainMenu")
end

local screen = ui:getScreen(SCREEN.BOTTOM)
if screen then
	local state = GameState:getState()
	if state == gameState.MARIO_CHALLANGE_MAP_STATE then
		screen:setAsSelected("L_OriginalPlayBtn_00")
	elseif state == gameState.COURSE_BOT_STATE then
		screen:setAsSelected("L_CoursebotBtn_00")
	elseif state == gameState.COURSE_EDIT_STATE then
		screen:setAsSelected("L_EditBtn_00")
	elseif state == gameState.COURSE_WORLD_STATE then
		screen:setAsSelected("L_NetworkBtn_00")
	end
end

function stayInRelease(buttonName)
	local button = ui:getButton(buttonName)
	if button then
		button:setReleaseStay(true)
	end
end

-- make buttons stay in release
stayInRelease("L_OriginalPlayBtn_00")
stayInRelease("L_CoursebotBtn_00")
stayInRelease("L_EditBtn_00")
stayInRelease("L_NetworkBtn_00")
stayInRelease("L_TitleBtn_00")
-- MCAT#2711 - keep button in released stay on main menu
stayInRelease("L_YamamuraBtn_00")
stayInRelease("L_ProfileBtn")
stayInRelease("L_OptionBtn_00")

stateMachine:requestState(MainMenu_state.cEnd)


end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercMarioChallenge()
GlobalData:addPlayReportVal("sys023")

Sound:stopMusic()
GameState:switchScene("MarioChallangeMap")

local state = GameState:getState()
if state == gameState.COURSE_BOT_STATE then
	GlobalData:setInfoView(false)
end
end
function onUpdatecMarioChallenge()

end
function onExitcMarioChallenge()

end
function onEntercCourseWorld()
GlobalData:addPlayReportVal("sys017")

Sound:stopMusic()
GameState:switchScene("CourseWorldNew")
GlobalData:setInfoView(false)

local state = GameState:getState()
if state == gameState.COURSE_BOT_STATE then
	GlobalData:setInfoView(false)
end
end
function onUpdatecCourseWorld()

end
function onExitcCourseWorld()

end
function onEntercCourseBot()
GlobalData:addPlayReportVal("sys018")

GlobalData:setCourseBotEntryType(0) 
Sound:stopMusic()
GameState:switchScene("CourseBot")
end
function onUpdatecCourseBot()

end
function onExitcCourseBot()

end
function onEntercEditor()
GlobalData:addPlayReportVal("sys015")

Sound:stopMusic()
GameState:switchScene("CourseMaker")

local state = GameState:getState()
if state == gameState.COURSE_BOT_STATE then
	GlobalData:setInfoView(false)
end
end
function onUpdatecEditor()

end
function onExitcEditor()

end
function onEntercProfile()
GlobalData:addPlayReportVal("sys019")

ui:changeScreen("Profile", false, false, false)

stateMachine:requestState(MainMenu_state.cEnd)
end
function onUpdatecProfile()

end
function onExitcProfile()

end
function onEntercSettings()
GlobalData:addPlayReportVal("sys020")

Sound:playSound("window_in")
ui:changeScreen("Settings", false, false, false)

stateMachine:requestState(MainMenu_state.cEnd)
end
function onUpdatecSettings()

end
function onExitcSettings()

end
function onEntercTutorial()
GlobalData:addPlayReportVal("sys016")

Sound:playSound("window_in")
ui:changeScreen("TutorialDialog", false, false)

stateMachine:requestState(MainMenu_state.cEnd)
end
function onUpdatecTutorial()

end
function onExitcTutorial()

end
function onEntercTitle()
GlobalData:addPlayReportVal("sys014")

Sound:stopMusic()
GameState:switchScene("title")
end
function onUpdatecTitle()

end
function onExitcTitle()

end
function onEntercEnd()

end
function onUpdatecEnd()
if ui:isPhysicalButtonEnabled() == false then return end -- do not let to trigger main menu with 'Start' if ui input is blocked
if Input:isAnyPressedExcept(BUTTON.START) then return end -- do not let to trigger main menu when any button is pressed except start

local uiIsIdle = ui:isIdle()
local uiIsActive = ui:isActive()

if GlobalData:isBusy() == false then	
	if uiIsIdle == true or uiIsActive == false then
		if Input:isTriggered(BUTTON.START, uiIsActive or GlobalData:forceShowMainMenu()) then -- force button trigger check
			if uiIsIdle == true and ui:isFocused() then -- only able to exit main menu when it is in focus
				ui:goToPreviousScreen()
				uiIsIdle = false
			elseif  uiIsActive == false then
				ui:changeScreen("MainMenu", false, false)
				uiIsActive = true
			end
		end
	end
end
end
function onExitcEnd()

end
function onEntercExit()
if GameState:getState() == 7 then -- special for editor
	gMainMenuOutroAnim = ui:getScreen(1):playAnimation("Out");
end


end
function onUpdatecExit()
if gMainMenuOutroAnim ~= nil and not gMainMenuOutroAnim:isPlaying() then
	Editor:tellState(2);
	ui:changeScreen("MainGroup", true, false, false);
	gMainMenuOutroAnim = nil;
	stateMachine:requestState(End);
end

end
function onExitcExit()

end
function onEntercJumpToManual()
GlobalData:addPlayReportVal("sys021")

GameState:jumpToManual()
stateMachine:requestState(MainMenu_state.cEnd)
end
function onUpdatecJumpToManual()

end
function onExitcJumpToManual()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cMarioChallenge={}
cMarioChallenge.onEnter=onEntercMarioChallenge
cMarioChallenge.onUpdate=onUpdatecMarioChallenge
cMarioChallenge.onExit=onExitcMarioChallenge
cCourseWorld={}
cCourseWorld.onEnter=onEntercCourseWorld
cCourseWorld.onUpdate=onUpdatecCourseWorld
cCourseWorld.onExit=onExitcCourseWorld
cCourseBot={}
cCourseBot.onEnter=onEntercCourseBot
cCourseBot.onUpdate=onUpdatecCourseBot
cCourseBot.onExit=onExitcCourseBot
cEditor={}
cEditor.onEnter=onEntercEditor
cEditor.onUpdate=onUpdatecEditor
cEditor.onExit=onExitcEditor
cProfile={}
cProfile.onEnter=onEntercProfile
cProfile.onUpdate=onUpdatecProfile
cProfile.onExit=onExitcProfile
cSettings={}
cSettings.onEnter=onEntercSettings
cSettings.onUpdate=onUpdatecSettings
cSettings.onExit=onExitcSettings
cTutorial={}
cTutorial.onEnter=onEntercTutorial
cTutorial.onUpdate=onUpdatecTutorial
cTutorial.onExit=onExitcTutorial
cTitle={}
cTitle.onEnter=onEntercTitle
cTitle.onUpdate=onUpdatecTitle
cTitle.onExit=onExitcTitle
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cExit={}
cExit.onEnter=onEntercExit
cExit.onUpdate=onUpdatecExit
cExit.onExit=onExitcExit
cJumpToManual={}
cJumpToManual.onEnter=onEntercJumpToManual
cJumpToManual.onUpdate=onUpdatecJumpToManual
cJumpToManual.onExit=onExitcJumpToManual
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (MainMenu_state._stateCount,MainMenu_state.cInit)
stateMachine:register(MainMenu_state.cInit,cInit)
stateMachine:register(MainMenu_state.cMarioChallenge,cMarioChallenge)
stateMachine:register(MainMenu_state.cCourseWorld,cCourseWorld)
stateMachine:register(MainMenu_state.cCourseBot,cCourseBot)
stateMachine:register(MainMenu_state.cEditor,cEditor)
stateMachine:register(MainMenu_state.cProfile,cProfile)
stateMachine:register(MainMenu_state.cSettings,cSettings)
stateMachine:register(MainMenu_state.cTutorial,cTutorial)
stateMachine:register(MainMenu_state.cTitle,cTitle)
stateMachine:register(MainMenu_state.cEnd,cEnd)
stateMachine:register(MainMenu_state.cExit,cExit)
stateMachine:register(MainMenu_state.cJumpToManual,cJumpToManual)
stateMachine:endRegister()
end

