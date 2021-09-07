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
courseBot_state= {
cGlobals=0,
cInit=1,
cRun=2,
cWorldPlay=3,
cLevelPlay=4,
cChangeCategory=5,
cChallenge=6,
cChallengeInfo=7,
cMyCourses=8,
cMyCoursesInfo=9,
cChallengePlay=10,
cAnimOut=11,
cGoToEditor=12,
cInfoOut=13,
cMyCoursesPlay=14,
cSave=15,
cGoToEditorNewCourse=16,
cDelete=17,
cConfirmDelete=18,
cPlayWorldLevel=19,
cBack=20,
cLocalShareSend=21,
cLocalShareReceive=22,
cChangeName=23,
cLocalShareInProgress=24,
cCategoryChangePrep=25,
cDeleteCancelled=26,
cDeleteWait=27,
_stateCount=28
}
-------------------------------------------------------------
function onEntercGlobals()
layout = {}
layout.MyCourses = 0
layout.ChallengeCourses= 1
layout.COUNT = 2

-- used to check for mycourses course slot status
slot = {}
slot.Corrupted = -1
slot.Empty = 0
slot.Saving = 1
slot.Loading = 2
slot.Valid = 3

-- used to check if saving or importing level
entryType = {}
entryType.Play = 0
entryType.Save = 1
entryType.LoadInEditor = 2
entryType.Download = 3
entryType.LocalShare = 4
entryType.StreetPassLevel = 5

topScreen = ui:getScreen(2)
botScreen = ui:getScreen(1)

InfoFlag = false

SelectToggle = false

SELECT_BUTTON = 4

gMouthOpenAnim = nil
gCategoryChange = false
gNameChange = false
gDeleteCancelled = false

ui:getScreen(2):setVisible("N_LocalShare", gCategory == layout.MyCourses)

if GlobalData then
	gLevelIndex = GlobalData:getChallengeLevelIndex()
	gInfoView = GlobalData:showInfoView()
	if gInfoView == true then
		NN_LOG("INFO ON")
	end
	gCourseBotEntry = GlobalData:getCourseBotEntryType()
	gGameplayType = GlobalData:getGameplayType()
	
	if gCourseBotEntry == entryType.Play or gCourseBotEntry == entryType.LoadInEditor then
		gSavedCategory = GlobalData:getCategory()
	else
		GlobalData:setCategory(layout.MyCourses)
		gSavedCategory = layout.MyCourses
	end
else
-- for preview state
	gLevelIndex = -1
	gInfoView = false 
	gSavedCategory =  1
end

gCategory = gSavedCategory

gScrollStateFrameCount = 100
gScrollStateFrame = 0
gScrollStateAnim = ui:getScreen(2):getAnimation("ScrollState")
gScrollStateAnimBot = ui:getScreen(1):getAnimation("ScrollState")

gFromLocalShare = false
gLocalShareCourseInfoOpen = false
gLocalShareReceivedInfoOpen = false

function startCategorySwitch()
	gCategory = (gCategory + 1) % layout.COUNT
	ui:getScreen(2):playAnimation("ChangeCategory", false)
	ui:getScreen(1):playAnimation("ChangeCategory", false)
end
function switchCategory()
	gScrollStateAnim:setFrame(0)
	gScrollStateFrame = 0
	ui:getScreen(2):setVisible("N_Save_00", false)
	--ui:getScreen(2):setVisible("N_MyData_00", gCategory == layout.MyCourses)

	gMouthOpenAnim = ui:getScreen(2):playAnimation("ChangeCategory", true)
	ui:getScreen(1):playAnimation("ChangeCategory", true)

	GlobalData:setCategory(gCategory)	
	CourseBot:resetScroll()
end

function updateScroll(val)
	gScrollStateFrame = gScrollStateFrame + val
	if gScrollStateFrame < 0 then gScrollStateFrame = 0 end
	if gScrollStateFrame >= gScrollStateFrameCount then gScrollStateFrame = gScrollStateFrameCount - 1 end

	if gScrollStateAnim ~= nil and gScrollStateAnimBot ~= nil then
		gScrollStateAnim:setFrame(gScrollStateFrame)
		gScrollStateAnimBot:setFrame(gScrollStateFrame)
	end
end

function initCourseInfoScreen()
	topScreen:setVisible("N_SaveWin_00", false)
	topScreen:setVisible("N_ImportWin_00", false)
	topScreen:setVisible("N_MyDataWin_00", false)
	topScreen:setVisible("N_SampleDataWin_00", false)
	topScreen:setVisible("N_DelWin_00", false)
	topScreen:setVisible("N_Empty_00", false)
	topScreen:setVisible("N_Info_00", false)
	topScreen:setVisible("N_WorldWin_00", false)
	topScreen:setVisible("N_Challenge_00", false)
	topScreen:setVisible("N_ChallengeGold_00", false)

	botScreen:setVisible("N_WorldWin_00", false)
	botScreen:setVisible("N_SaveWin_00", false)
	botScreen:setVisible("N_ImportWin_00", false)
	botScreen:setVisible("N_MyDataWin_00", false)
	botScreen:setVisible("N_DelWin_00", false)
	botScreen:setVisible("N_Challenge_00", false)
	botScreen:setVisible("N_New_00", false)
	botScreen:setVisible("N_ChallengeGOLD_00", false)
	botScreen:setVisible("N_ImportWinNew_00", false)
	botScreen:setVisible("N_ChallengeWin", false)
end

-- hide play dialog
ui:getScreen(1):setVisible("N_Btn_00", true)
ui:getScreen(1):setVisible("N_Btn_01", false)

stateMachine:requestState(courseBot_state.cInit)
end
function onUpdatecGlobals()

end
function onExitcGlobals()

end
function onEntercInit()
updateScroll(0)

botScreen:setVisible("L_Save_00", false)
botScreen:setVisible("L_CourseDataDrag_00", false)
botScreen:setVisible("N_Challenge_00", false)
botScreen:setVisible("N_New_00", false)

--show proper top robot text
topScreen:setVisible("N_LocalShare", false)
topScreen:setVisible("N_MyData_00", false)
topScreen:setVisible("N_Import_00", false)
topScreen:setVisible("N_SaveChoiceTxt_00", false)
topScreen:setVisible("N_SaveTxt_00", false)
topScreen:setVisible("N_SaveEndTxt_00", false)
topScreen:setVisible("N_StreetPass", false)
topScreen:setVisible("N_DeleteEndTxt_00", false)
topScreen:setVisible("N_DeleteTxt_00", false)

--show proper top robot text
botScreen:setVisible("Parts_Menu_00", false)
botScreen:setVisible("Parts_Category_00", false)
botScreen:setVisible("Parts_Back_00", false)

if gCourseBotEntry == entryType.Save or gCourseBotEntry == entryType.Download then
	topScreen:setVisible("N_SaveChoiceTxt_00", true)
	botScreen:setVisible("Parts_Back_00", true)
elseif gCourseBotEntry == entryType.StreetPassLevel then
	topScreen:setVisible("N_StreetPass", true)
	--topScreen:setVisible("N_Save_00", true)
	botScreen:setVisible("Parts_Back_00", true)
elseif gCourseBotEntry == entryType.LoadInEditor then
	topScreen:setVisible("N_Import_00", true)
	botScreen:setVisible("Parts_Back_00", true)
	botScreen:setVisible("Parts_Category_00", true)
else
	topScreen:setVisible("N_MyData_00", true)
	botScreen:setVisible("Parts_Menu_00", true)
	botScreen:setVisible("Parts_Category_00", true)
end

button = botScreen:getButton("L_KeyboardBtn_00")
button:setReleaseStay()

-- if saved global category is set to MyCourses
if gSavedCategory == layout.MyCourses then
	if gInfoView == false then
		stateMachine:requestState(courseBot_state.cRun)
	else
		GlobalData:setInfoView(false)
		stateMachine:requestState(courseBot_state.cMyCourses)
	end
-- if saved global category is set to ChallengeCourses
else
	local categoryButton = botScreen:getButton("Parts_Category_00")
	if categoryButton ~= nil then
		categoryButton :forceToggle()
	end
	stateMachine:requestState(courseBot_state.cChallenge)		
end
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercRun()

end
function onUpdatecRun()
if ui:isFocused() == false then
	return
end

if GlobalData:getScrolling() then
	if GlobalData:getIncreasing() then 
		updateScroll(1)
	else
		updateScroll(-1)
	end
end

if CourseBot:isDragging() == false and CourseBot:isDeleting() == false and CourseBot:isSaveInProgress() == false then
	if Input:isTriggered(SELECT_BUTTON) then
		ui:disableInput(0) --MCAT2493 MCAT2722
		SelectToggle = true
		CourseBot:setAnimPlaying(true)
		stateMachine:requestState(courseBot_state.cCategoryChangePrep)
		return
	end

	if InfoFlag == true then
		if Input:isTriggered(BUTTON.B) then 
			ui:disableInput(0) --MCAT2493 MCAT2722
			Sound:playSound("close_window");
			stateMachine:requestState(courseBot_state.cInfoOut)
			return
		end
	end

	if Input:isTriggered(BUTTON.B) then 
		if gCourseBotEntry ~= entryType.Play then
			Sound:playSound("coursebot_back");
			stateMachine:requestState(courseBot_state.cBack)
			return
		end
	end
end

if gCategoryChange == true then
	if gMouthOpenAnim ~= nil and gMouthOpenAnim:isPlaying() == false then
		CourseBot:setAnimPlaying(false)
		gCategoryChange = false
		ui:enableInput(0) --MCAT2493
	end
end

if gNameChange == true then
	if CourseBot:isNameChangeCancelled() == true then
		gNameChange = false
		CourseBot:resetNameChangeCancel()
	elseif CourseBot:isNameChangeDone() == true then
		gNameChange = false
		stateMachine:requestState(courseBot_state.cMyCoursesInfo)
	end
end
end
function onExitcRun()

end
function onEntercWorldPlay()
initCourseInfoScreen()
InfoFlag = true
GlobalData:setInfoView(true)

topScreen:playAnimation("In")
topScreen:setVisible("N_WorldWin_00", true)


botScreen:playAnimation("In")
botScreen:setVisible("N_WorldWin_00", true)

end
function onUpdatecWorldPlay()
if InfoFlag == true then
	if Input:isTriggered(BUTTON.B) then 
		Sound:playSound("close_window");
		stateMachine:requestState(courseBot_state.cInfoOut)
	end
end
end
function onExitcWorldPlay()

end
function onEntercLevelPlay()
-- moved to cMyCourse and courseBot_state.cMyCoursesInfo

end
function onUpdatecLevelPlay()
if Input:isTriggered(BUTTON.B) then
	stateMachine:requestState(courseBot_state.cRun)
end

-- close button not appearing in list of buttons. hacking it in.
if closeButton ~= nil and closeButton:isTouchRelease() == true then
	stateMachine:requestState(courseBot_state.cRun)
end

if Input:isPressed(4) then 
	stateMachine:requestState(courseBot_state.cInfoOut)
end
end
function onExitcLevelPlay()
ui:getScreen(2):playAnimation("Out")
ui:getScreen(1):playAnimation("Out")
end
function onEntercChangeCategory()
gTimer = 20 -- wait extra frames
gAnim = ui:getScreen(2):playAnimation("CloseMouth", false)

gCategoryChange = true
CourseBot:resetScrollVelocity()
startCategorySwitch()

end
function onUpdatecChangeCategory()
if gAnim ~= nil and gAnim:isPlaying() == false then
	if gTimer <= 0 then
		switchCategory()

		if gCategory == layout.ChallengeCourses then
			stateMachine:requestState(courseBot_state.cChallenge)
		else
			stateMachine:requestState(courseBot_state.cMyCourses)
		end
	end
	gTimer = gTimer - 1
end

if SelectToggle then 
	local categoryButton = botScreen:getButton("Parts_Category_00")
	if categoryButton ~= nil then
		Sound:playSound("coursebot_category");
		categoryButton :forceToggle()
	end

	SelectToggle = false
end
end
function onExitcChangeCategory()
ui:getScreen(2):playAnimation("OpenMouth")
end
function onEntercChallenge()
-- hide play dialog
botScreen :setVisible("N_Btn_01", true)
botScreen :setVisible("N_Btn_00", false)

-- if we were previously looking at info request info state
if gInfoView == true then
	NN_LOG("INFO TRUE")
	 gInfoView = false
	 stateMachine:requestState(courseBot_state.cChallengeInfo)
else 
	stateMachine:requestState(courseBot_state.cRun)		
end
end
function onUpdatecChallenge()

end
function onExitcChallenge()

end
function onEntercChallengeInfo()
unlocked = CourseBot:isLevelUnlocked() 

if unlocked  == false then
	InfoFlag = false
	stateMachine:requestState(courseBot_state.cRun)	
else 
	local editButton = ui:getButton("L_EditBtn_02")
	
	-- get challenge and medal values from the game
	medalChallengeNumber = GlobalData:getLayoutChallengeLevelIndex()
	gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(medalChallengeNumber)
	gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(medalChallengeNumber)

	-- determine what to do
	setNormalMedalOn = gotNormalMedal 
	setSpecialMedalOn = gotSpecialMedal 

	initCourseInfoScreen()

	if gCourseBotEntry == entryType.LoadInEditor then
		topScreen:setVisible("N_Info_00", true)
		topScreen:setVisible("N_ImportWin_00", true)

		botScreen:setVisible("N_ImportWin_00", true) 
		
		editButton = ui:getButton("L_ImportBtn_00")
	elseif gCourseBotEntry == entryType.Play then
		topScreen:setVisible("N_Info_00", true)
		botScreen:setVisible("N_ChallengeWin", true)

		if gotNormalMedal and gotSpecialMedal then
			topScreen:setVisible("N_ChallengeGold_00", true)
			botScreen:setVisible("N_ChallengeGOLD_00", true)
			botScreen:setVisible("N_Challenge_00", false)
			editButton = ui:getButton("L_EditBtn_03")
		else
			topScreen:setVisible("N_Challenge_00", true)
			botScreen:setVisible("N_Challenge_00", true)
			botScreen:setVisible("N_ChallengeGOLD_00", false)
		end
	else
		stateMachine:requestState(courseBot_state.cRun)
	end

	if editButton ~= nil and gotNormalMedal and gotSpecialMedal then
		editButton:setButtonOverrideSFXByName("ON_RELEASED", "coursebot_window_play")
	else
		editButton:setButtonOverrideSFXByName("ON_RELEASED", "pm_save_quit_no")
	end
	
	InfoFlag = true
	GlobalData:setInfoView(true)
	gAnim = topScreen:playAnimation("In")
	botScreen:playAnimation("In")

	-- setting text of buttons based on index of level selected
	topScreen:setTextW("T_CourseName_01", CourseBot:getChallengeLevelName())
	topScreen:setTextW("T_CourseName_02", CourseBot:getChallengeLevelName())

	-- we will immediately show the special text if the user already gotten one of the medals previously
	showingSpecialText = setNormalMedalOn or setSpecialMedalOn 

	Medals:setStatus(0, setNormalMedalOn )
	Medals:setStatus(1, setSpecialMedalOn )

	Medals:showSpecialText(showingSpecialText )

	Medals:setupTextMessages(medalChallengeNumber)
	-- start setting up the layout
end
end
function onUpdatecChallengeInfo()
if ui:isFocused() == false then
	return
end

if gAnim ~= nil and gAnim:isPlaying() == false then
	if Input:isTriggered(SELECT_BUTTON) then 
		ui:disableInput(0) --MCAT2493 MCAT2722
		SelectToggle = true
		CourseBot:setAnimPlaying(true)
		stateMachine:requestState(courseBot_state.cCategoryChangePrep)
	end
end

if InfoFlag == true then
	if Input:isTriggered(BUTTON.B) then 
		ui:disableInput(0) --MCAT2493 MCAT2722
		Sound:playSound("close_window");
		stateMachine:requestState(courseBot_state.cInfoOut)
		return
	end
end
end
function onExitcChallengeInfo()

end
function onEntercMyCourses()
-- hide play dialog
botScreen:setVisible("N_Btn_00", true)
botScreen:setVisible("N_Btn_01", false)

-- if we were previously looking at info request info state
if gInfoView == true then
	 gInfoView = false
	CourseBot:setInfoScreen()
	 stateMachine:requestState(courseBot_state.cMyCoursesInfo)
else 
	stateMachine:requestState(courseBot_state.cRun)		
end
end
function onUpdatecMyCourses()

end
function onExitcMyCourses()

end
function onEntercMyCoursesInfo()
playIn = false

--type of course stored there
savedType = GlobalData:getSlotType()

-- set the screen components hidden
initCourseInfoScreen()

local editButton = ui:getButton("L_EditBtn_00")

--set up different view types
if gCourseBotEntry == entryType.Play then 
	if savedType ~= slot.Saving and savedType ~= slot.Loading and savedType ~= slot.Corrupted then
		
		if GlobalData:showInfoView() == false then 
			playIn = true
			InfoFlag = true
		end

		if savedType == slot.Corrupted then
			--do something here
		elseif savedType == slot.Empty then
			topScreen:setVisible("N_SampleDataWin_00", true)
			botScreen:setVisible("N_New_00", true)

			if gFromLocalShare == true then
				gFromLocalShare = false
			end

			--closeButton = botScreen:getButton("Parts_Close_06")
		elseif savedType == slot.Valid then
			topScreen:setVisible("N_Info_00", true)
			topScreen:setVisible("N_SampleDataWin_00", true)

			botScreen:setVisible("N_MyDataWin_00", true)

			-- setting text of buttons based on index of level selected
			topScreen:setTextW("T_CourseName_00", GlobalData:getMyCoursesLevelName())

			if gFromLocalShare == true then
				if CourseBot:isClearChecked() == true then
					CourseBot:playCourseCleared()
				end
				gFromLocalShare = false
			end
		end
	else
		stateMachine:requestState(courseBot_state.cRun)
	end
elseif gCourseBotEntry == entryType.LoadInEditor then
	if savedType == slot.Valid then
		playIn = true
		editButton = ui:getButton("L_ImportBtn_00")

		topScreen:setVisible("N_Info_00", true)
		topScreen:setVisible("N_ImportWin_00", true)
		botScreen:setVisible("N_ImportWin_00", true) 
		
		topScreen:setTextW("T_CourseName_00", CourseBot:getMyCoursesLevelName())		
	elseif savedType == slot.Loading then
		stateMachine:requestState(courseBot_state.cRun)
	else 
		playIn = true

		topScreen:setVisible("N_ImportWin_00", true)
		botScreen:setVisible("N_ImportWinNew_00", true) 
	end

	InfoFlag = true
elseif  gCourseBotEntry == entryType.Save or gCourseBotEntry == entryType.Download then
	if savedType == slot.Valid or savedType == slot.Empty then
		gMouthAnim = topScreen:playAnimation("CloseMouth")	
		
		if savedType == slot.Valid then
			playIn = true
			topScreen:setVisible("N_SaveWin_00", true)
			topScreen:setVisible("N_Empty_00", true)

			botScreen:setVisible("N_SaveWin_00", true)

			topScreen:setVisible("N_Info_00", true)
			topScreen:setTextW("T_CourseName_00", CourseBot:getMyCoursesLevelName())	

			InfoFlag = true
		end	
	elseif savedType ~= slot.Empty then
		stateMachine:requestState(courseBot_state.cRun)
	end
elseif gCourseBotEntry == entryType.SetStreetPassLevel then
	stateMachine:requestState(courseBot_state.cRun)
else
	stateMachine:requestState(courseBot_state.cRun)
end

if gFromLocalShare == true then
	playIn = false
	gFromLocalShare = false
end

if playIn == true then
	if editButton ~= nil then
		editButton:setButtonOverrideSFXByName("ON_RELEASED", "coursebot_window_play")
	end

	GlobalData:setInfoView(true)
	if gDeleteCancelled == false then
		topScreen:playAnimation("In")
	else
		gDeleteCancelled = false
	end
	gAnim = botScreen:playAnimation("In")
end
end
function onUpdatecMyCoursesInfo()
if ui:isFocused() == false then
	return
end

--type of course stored there
local newSlotType = GlobalData:getSlotType()

if newSlotType ~= savedType then
	initCourseInfoScreen()
	if newSlotType ~= slot.Saving and newSlotType ~= slot.Loading and newSlotType ~= slot.Corrupted then
		if newSlotType == slot.Valid then
			topScreen:setVisible("N_Info_00", true)
			topScreen:setVisible("N_SampleDataWin_00", true)

			botScreen:setVisible("N_MyDataWin_00", true)

			-- setting text of buttons based on index of level selected
			topScreen:setTextW("T_CourseName_00", CourseBot:getMyCoursesLevelName())
			closeButton = botScreen:getButton("Parts_Close_00")
		end
	else
		stateMachine:requestState(courseBot_state.cRun)
	end
end

canSelect = (gCourseBotEntry == entryType.Play or gCourseBotEntry == entryType.LoadInEditor) and (not CourseBot:isClearedAnimPlaying()) 

if gAnim ~= nil and gAnim:isPlaying() == false and CourseBot:isSaveInProgress() == false and CourseBot:isDeleting() == false then
	if Input:isTriggered(SELECT_BUTTON) and canSelect then 
		ui:disableInput(0) --MCAT2493 MCAT2722
		SelectToggle = true
		CourseBot:setAnimPlaying(true)
		stateMachine:requestState(courseBot_state.cCategoryChangePrep)
		return
	end
	if gCourseBotEntry == entryType.Play and CourseBot:isClearedAnimPlaying() == false then 
		-- we want to enable input only once
		if ui:isGlobalInputEnabled() == false then
			ui:enableInput(0) --MCAT2493 MCAT2722
		end
		CourseBot:enableInput()
		CourseBot:setButtonLocalShareFalse()
	end
	if InfoFlag == true then
		if Input:isTriggered(BUTTON.B) == true then 
			ui:disableInput(0) --MCAT2493 MCAT2722
			Sound:playSound("close_window");
			stateMachine:requestState(courseBot_state.cInfoOut)
			return
		end
	end
end

if  gCourseBotEntry == entryType.Save or gCourseBotEntry == entryType.Download then
	if gMouthAnim ~= nil and gMouthAnim:isPlaying() == false then
		if savedType == slot.Empty then
			CourseBot:saveNewCourse()
			stateMachine:requestState(courseBot_state.cRun)
		end
	end
end


end
function onExitcMyCoursesInfo()
receiveButton0 = botScreen:getButton("L_ReceiveBtn_00")
receiveButton1 = botScreen:getButton("L_ReceiveBtn_01")
sendButton = botScreen:getButton("L_ShareBtn_00")
if playIn == true then
	if receiveButton0 == nil or receiveButton0 :isTouchRelease() then
		-- don't close
		NN_LOG("[cMyCourseInfo] - Receive 0")
	elseif receiveButton1 == nil or receiveButton1:isTouchRelease() then
		-- don't close
		NN_LOG("[cMyCourseInfo] - Receive 1")
	elseif sendButton == nil or sendButton :isTouchRelease() then
		-- don't close
		NN_LOG("[cMyCourseInfo] - Send")
	else
		if  gCourseBotEntry == entryType.Save or gCourseBotEntry == entryType.Download then
			if savedType == slot.Valid then
				--topScreen:playAnimation("OpenMouth")
			end
		end
	end
end
end
function onEntercChallengePlay()
GlobalData:setGameplayType(2)
GameState:switchScene("CourseBotChallengeCourseIn")
Sound:stopMusic()

end
function onUpdatecChallengePlay()

end
function onExitcChallengePlay()

end
function onEntercAnimOut()
topScreen:playAnimation("OpenMouth")
ui:disableInput(0) --MCAT2493 MCAT2722	
ui:getScreen(2):playAnimation("Out")
animA = ui:getScreen(1):playAnimation("Out")
end
function onUpdatecAnimOut()
if animA ~= nil and animA:isPlaying() == false then
	ui:getScreen(1):setVisible("N_Challenge_00", false)
	ui:getScreen(1):setVisible("N_New_00", false)
	ui:getScreen(1):setVisible("N_WorldWin_00", false)
	InfoFlag = false
	GlobalData:setInfoView(false)
	ui:enableInput(0) --MCAT2493 MCAT2722
	if gFromLocalShare  == true then
		-- goto to courseBot_state.cLocalShareInProgress until we need to go back to the cMyCourseInfo
		gFromLocalShare = false
		stateMachine:requestState(courseBot_state.cLocalShareInProgress)
	else
		stateMachine:requestState(courseBot_state.cRun)
	end	
end
end
function onExitcAnimOut()
if CourseBot:isSaveInProgress() == true then
	CourseBot:setSaveInProgress(false)
end
end
function onEntercGoToEditor()
-- Based on gGameplayData enum for coursebot challenge course
local challengeCourse = 2 
local Editor= 7

CourseBot:disableInput()

if gCategory == layout.ChallengeCourses then
	-- get challenge and medal values from the game
	medalChallengeNumber = GlobalData:getLayoutChallengeLevelIndex()
	gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(medalChallengeNumber)
	gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(medalChallengeNumber)

	canEdit = gotNormalMedal and gotSpecialMedal

	if canEdit == true then
		CourseBot:tryLoad()
		GlobalData:setMyCoursesLevelIndex(-1)
		GlobalData:setGameplayType(Editor)
	else
		CourseBot:editIsLocked()
	end
elseif gCategory == layout.MyCourses then
	CourseBot:tryLoad()	
	GlobalData:setChallengeLevelIndex(-1)
end

stateMachine:requestState(courseBot_state.cRun)

end
function onUpdatecGoToEditor()

end
function onExitcGoToEditor()

end
function onEntercInfoOut()
if InfoFlag == true then
	topScreen:playAnimation("OpenMouth")	
	ui:getScreen(2):playAnimation("Out")
	animA = ui:getScreen(1):playAnimation("Out")
end
end
function onUpdatecInfoOut()
if InfoFlag == true then
	if animA ~= nil and animA:isPlaying() == false then
		ui:getScreen(1):setVisible("N_Challenge_00", false)
		ui:getScreen(1):setVisible("N_New_00", false)
		InfoFlag = false
		GlobalData:setInfoView(false)
		ui:enableInput(0) --MCAT2493
		stateMachine:requestState(courseBot_state.cRun)
	end
end
end
function onExitcInfoOut()

end
function onEntercMyCoursesPlay()
canPlay = CourseBot:clearCheckTry()

if canPlay == true then
	GlobalData:setGameplayType(0)
	CourseBot:playMyCourse()
else
	stateMachine:requestState(courseBot_state.cRun)	
end

end
function onUpdatecMyCoursesPlay()

end
function onExitcMyCoursesPlay()

end
function onEntercSave()
ui:disableInput(0) -- MCAT#3174 - disable input as callback gets triggered
InfoFlag = false
topScreen:playAnimation("CloseMouth")
ui:getScreen(2):playAnimation("Out")
animA = ui:getScreen(1):playAnimation("Out")	
end
function onUpdatecSave()
if animA ~= nil and animA:isPlaying() == false then
	if CourseBot:saveNewCourse() == true then
		stateMachine:requestState(courseBot_state.cRun)
	else
		stateMachine:requestState(courseBot_state.cRun)
	end		
end
end
function onExitcSave()

end
function onEntercGoToEditorNewCourse()
CourseBot:tryLoad()	
GlobalData:setChallengeLevelIndex(-1)
stateMachine:requestState(courseBot_state.cRun)	

end
function onUpdatecGoToEditorNewCourse()

end
function onExitcGoToEditorNewCourse()

end
function onEntercDelete()
ui:disableInput(0) --MCAT2493 MCAT2722
anim2 = botScreen:playAnimation("Out")
end
function onUpdatecDelete()
if anim2 ~= nil and anim2:isPlaying() == false then
	botScreen:setVisible("N_DelWin_00", true)
	topScreen:setVisible("N_DelWin_00", true)

	gAnim = botScreen:playAnimation("In")

	stateMachine:requestState(courseBot_state.cDeleteWait)
end

end
function onExitcDelete()

end
function onEntercConfirmDelete()
CourseBot:deleteCourse()
stateMachine:requestState(courseBot_state.cAnimOut)
end
function onUpdatecConfirmDelete()

end
function onExitcConfirmDelete()

end
function onEntercPlayWorldLevel()
--ui:getScreen(2):playAnimation("Out")
--animA = ui:getScreen(1):playAnimation("Out")
end
function onUpdatecPlayWorldLevel()
--if animA ~= nil and animA:isPlaying() == false then
	GlobalData:setMyCoursesWorldIndex(0)
	GlobalData:playMyCoursesWorldLevel()
	GlobalData:setGameplayType(9)
	CourseBot:playMyCourse()
	Sound:stopMusic()
--end
end
function onExitcPlayWorldLevel()

end
function onEntercBack()
Sound:stopMusic()
CourseBot:setExit()
end
function onUpdatecBack()

end
function onExitcBack()

end
function onEntercLocalShareSend()

if CourseBot:isShareable() == true then
	CourseBot:localShareSend()
	gFromLocalShare = false
	gLocalShareCourseInfoOpen = true

	topScreen:setVisible("N_MyData_00", false)
	topScreen:setVisible("N_LocalShare", true)
	topScreen:playAnimation("OpenMouth")
else
	stateMachine:requestState(courseBot_state.cRun)
end

end
function onUpdatecLocalShareSend()
if CourseBot:isLocalShareNeedCloseInfo() == true then
	-- close the course info after the initial confirmation logic?
	-- these flags should cause the flow to goto courseBot_state.cLocalShareInProgress after courseBot_state.cAnimOut
	gFromLocalShare  = true
	gLocalShareCourseInfoOpen = false
	stateMachine:requestState(courseBot_state.cAnimOut)
elseif CourseBot:isLocalShareNeedGotoInfo() == true then
	-- this happens if the user cancels the confirmation dialogs before doing any sharing
	gFromLocalShare  = true
	gLocalShareCourseInfoOpen = false
	if CourseBot:isSaveInProgress() == false then 
		stateMachine:requestState(courseBot_state.cMyCoursesInfo)
	end
end
end
function onExitcLocalShareSend()

end
function onEntercLocalShareReceive()
CourseBot:localShareReceive()
gFromLocalShare = false
gLocalShareCourseInfoOpen = true

topScreen:setVisible("N_MyData_00", false)
topScreen:setVisible("N_LocalShare", true)
topScreen:playAnimation("OpenMouth")
end
function onUpdatecLocalShareReceive()
if CourseBot:isLocalShareNeedCloseInfo() == true then
	-- these flags should cause the flow to goto courseBot_state.cLocalShareInProgress after courseBot_state.cAnimOut
	gFromLocalShare  = true
	gLocalShareCourseInfoOpen = false
	stateMachine:requestState(courseBot_state.cAnimOut)
elseif CourseBot:isLocalShareNeedGotoInfo() == true then
	gFromLocalShare  = true
	if CourseBot:isSaveInProgress() == false then 
		stateMachine:requestState(courseBot_state.cMyCoursesInfo)
	end
end
end
function onExitcLocalShareReceive()

end
function onEntercChangeName()
button = botScreen:getButton("L_KeyboardBtn_00")
button:setReleaseStay()
gNameChange = true
CourseBot:disableInput()
CourseBot:changeCourseName()
GlobalData:setInfoView(false)
stateMachine:requestState(courseBot_state.cRun)

end
function onUpdatecChangeName()

end
function onExitcChangeName()

end
function onEntercLocalShareInProgress()
gFromLocalShare = false
gLocalShareCourseInfoOpen = false
gLocalShareReceivedInfoOpen  = false
animA = nil
end
function onUpdatecLocalShareInProgress()
-- this state happens after the course info dialog goes away
-- during local share but before a level has been sent or received
if CourseBot:isLocalShareNeedGotoInfo() == true then
	-- this happens when the level has been sent or
	-- received and  local share has been finished

	-- the receive UI is open, close it
	if gLocalShareReceivedInfoOpen  == true then
		gFromLocalShare  = true
		gLocalShareReceivedInfoOpen = false
		animA = topScreen:playAnimation("Out")
	-- wait for the receive UI to close
	elseif animA ~= nil then
		if animA:isPlaying() == false then
			ui:getScreen(1):setVisible("N_Challenge_00", false)
			ui:getScreen(1):setVisible("N_New_00", false)
			ui:getScreen(1):setVisible("N_WorldWin_00", false)
			animA = nil
			gLocalShareCourseInfoOpen = false
		end
	-- everything should be closed, go to the CourseInfo state and play the animations
	else
		gFromLocalShare = true
		gLocalShareCourseInfoOpen = false
		
		if CourseBot:isSaveInProgress() == false then 
			stateMachine:requestState(courseBot_state.cMyCoursesInfo)
		end
	end
elseif CourseBot:isLocalShareNeedReceivedLevelInfo() == true then
	-- if the UI is not open then activate it
	if gLocalShareCourseInfoOpen == false and gLocalShareReceivedInfoOpen  == false then
		initCourseInfoScreen()
		topScreen:setVisible("N_Info_00", true)
		topScreen:setVisible("N_SampleDataWin_00", true)

		-- local share received UI needs to be activated (a course was received)	
		CourseBot:localShareSetIcons()

		-- setting text of buttons based on index of level selected
		topScreen:setTextW("T_CourseName_00", CourseBot:getCachedLevelName())
		topScreen:playAnimation("In")

		gLocalShareReceivedInfoOpen   = true
	end
end
end
function onExitcLocalShareInProgress()

end
function onEntercCategoryChangePrep()
if gCourseBotEntry ~= entryType.Play and gCourseBotEntry ~= entryType.LoadInEditor then
 	stateMachine:requestState(courseBot_state.cRun)
	SelectToggle = false
elseif InfoFlag == true then
	Sound:playSound("close_window");
	ui:disableInput(0) --MCAT2493 MCAT2722
	ui:getScreen(2):playAnimation("Out")
	animA = ui:getScreen(1):playAnimation("Out")
else 
	ui:disableInput(0) --MCAT2493 MCAT2722
	stateMachine:requestState(courseBot_state.cChangeCategory)
end
end
function onUpdatecCategoryChangePrep()
if InfoFlag == true then
	if animA ~= nil and animA:isPlaying() == false then
		ui:getScreen(1):setVisible("N_Challenge_00", false)
		ui:getScreen(1):setVisible("N_New_00", false)
		InfoFlag = false
		stateMachine:requestState(courseBot_state.cChangeCategory)
	end
	GlobalData:setInfoView(false)
end
end
function onExitcCategoryChangePrep()

end
function onEntercDeleteCancelled()
animA = ui:getScreen(1):playAnimation("Out")
ui:disableInput(0) --MCAT2493 MCAT2722
end
function onUpdatecDeleteCancelled()
if animA ~= nil and animA:isPlaying() == false then
	InfoFlag = false
	GlobalData:setInfoView(false)
	gDeleteCancelled = true
	CourseBot:setAnimPlaying(false)
	stateMachine:requestState(courseBot_state.cMyCoursesInfo)
end
end
function onExitcDeleteCancelled()

end
function onEntercDeleteWait()

end
function onUpdatecDeleteWait()
if ui:isFocused() == false then
	return
end

if gAnim ~= nil and gAnim:isPlaying() == false then
	-- we want to enable input only once
	if ui:isGlobalInputEnabled() == false then
		ui:enableInput(0) --MCAT2493 MCAT2722
	end
	if Input:isTriggered(SELECT_BUTTON) then 
		SelectToggle = true
		stateMachine:requestState(courseBot_state.cCategoryChangePrep)
	end
end

if Input:isTriggered(BUTTON.B) then 
	Sound:playSound("close_window");
	stateMachine:requestState(courseBot_state.cDeleteCancelled)
	return
end
end
function onExitcDeleteWait()

end
-------------------------------------------------------------
cGlobals={}
cGlobals.onEnter=onEntercGlobals
cGlobals.onUpdate=onUpdatecGlobals
cGlobals.onExit=onExitcGlobals
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cRun={}
cRun.onEnter=onEntercRun
cRun.onUpdate=onUpdatecRun
cRun.onExit=onExitcRun
cWorldPlay={}
cWorldPlay.onEnter=onEntercWorldPlay
cWorldPlay.onUpdate=onUpdatecWorldPlay
cWorldPlay.onExit=onExitcWorldPlay
cLevelPlay={}
cLevelPlay.onEnter=onEntercLevelPlay
cLevelPlay.onUpdate=onUpdatecLevelPlay
cLevelPlay.onExit=onExitcLevelPlay
cChangeCategory={}
cChangeCategory.onEnter=onEntercChangeCategory
cChangeCategory.onUpdate=onUpdatecChangeCategory
cChangeCategory.onExit=onExitcChangeCategory
cChallenge={}
cChallenge.onEnter=onEntercChallenge
cChallenge.onUpdate=onUpdatecChallenge
cChallenge.onExit=onExitcChallenge
cChallengeInfo={}
cChallengeInfo.onEnter=onEntercChallengeInfo
cChallengeInfo.onUpdate=onUpdatecChallengeInfo
cChallengeInfo.onExit=onExitcChallengeInfo
cMyCourses={}
cMyCourses.onEnter=onEntercMyCourses
cMyCourses.onUpdate=onUpdatecMyCourses
cMyCourses.onExit=onExitcMyCourses
cMyCoursesInfo={}
cMyCoursesInfo.onEnter=onEntercMyCoursesInfo
cMyCoursesInfo.onUpdate=onUpdatecMyCoursesInfo
cMyCoursesInfo.onExit=onExitcMyCoursesInfo
cChallengePlay={}
cChallengePlay.onEnter=onEntercChallengePlay
cChallengePlay.onUpdate=onUpdatecChallengePlay
cChallengePlay.onExit=onExitcChallengePlay
cAnimOut={}
cAnimOut.onEnter=onEntercAnimOut
cAnimOut.onUpdate=onUpdatecAnimOut
cAnimOut.onExit=onExitcAnimOut
cGoToEditor={}
cGoToEditor.onEnter=onEntercGoToEditor
cGoToEditor.onUpdate=onUpdatecGoToEditor
cGoToEditor.onExit=onExitcGoToEditor
cInfoOut={}
cInfoOut.onEnter=onEntercInfoOut
cInfoOut.onUpdate=onUpdatecInfoOut
cInfoOut.onExit=onExitcInfoOut
cMyCoursesPlay={}
cMyCoursesPlay.onEnter=onEntercMyCoursesPlay
cMyCoursesPlay.onUpdate=onUpdatecMyCoursesPlay
cMyCoursesPlay.onExit=onExitcMyCoursesPlay
cSave={}
cSave.onEnter=onEntercSave
cSave.onUpdate=onUpdatecSave
cSave.onExit=onExitcSave
cGoToEditorNewCourse={}
cGoToEditorNewCourse.onEnter=onEntercGoToEditorNewCourse
cGoToEditorNewCourse.onUpdate=onUpdatecGoToEditorNewCourse
cGoToEditorNewCourse.onExit=onExitcGoToEditorNewCourse
cDelete={}
cDelete.onEnter=onEntercDelete
cDelete.onUpdate=onUpdatecDelete
cDelete.onExit=onExitcDelete
cConfirmDelete={}
cConfirmDelete.onEnter=onEntercConfirmDelete
cConfirmDelete.onUpdate=onUpdatecConfirmDelete
cConfirmDelete.onExit=onExitcConfirmDelete
cPlayWorldLevel={}
cPlayWorldLevel.onEnter=onEntercPlayWorldLevel
cPlayWorldLevel.onUpdate=onUpdatecPlayWorldLevel
cPlayWorldLevel.onExit=onExitcPlayWorldLevel
cBack={}
cBack.onEnter=onEntercBack
cBack.onUpdate=onUpdatecBack
cBack.onExit=onExitcBack
cLocalShareSend={}
cLocalShareSend.onEnter=onEntercLocalShareSend
cLocalShareSend.onUpdate=onUpdatecLocalShareSend
cLocalShareSend.onExit=onExitcLocalShareSend
cLocalShareReceive={}
cLocalShareReceive.onEnter=onEntercLocalShareReceive
cLocalShareReceive.onUpdate=onUpdatecLocalShareReceive
cLocalShareReceive.onExit=onExitcLocalShareReceive
cChangeName={}
cChangeName.onEnter=onEntercChangeName
cChangeName.onUpdate=onUpdatecChangeName
cChangeName.onExit=onExitcChangeName
cLocalShareInProgress={}
cLocalShareInProgress.onEnter=onEntercLocalShareInProgress
cLocalShareInProgress.onUpdate=onUpdatecLocalShareInProgress
cLocalShareInProgress.onExit=onExitcLocalShareInProgress
cCategoryChangePrep={}
cCategoryChangePrep.onEnter=onEntercCategoryChangePrep
cCategoryChangePrep.onUpdate=onUpdatecCategoryChangePrep
cCategoryChangePrep.onExit=onExitcCategoryChangePrep
cDeleteCancelled={}
cDeleteCancelled.onEnter=onEntercDeleteCancelled
cDeleteCancelled.onUpdate=onUpdatecDeleteCancelled
cDeleteCancelled.onExit=onExitcDeleteCancelled
cDeleteWait={}
cDeleteWait.onEnter=onEntercDeleteWait
cDeleteWait.onUpdate=onUpdatecDeleteWait
cDeleteWait.onExit=onExitcDeleteWait
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (courseBot_state._stateCount,courseBot_state.cGlobals)
stateMachine:register(courseBot_state.cGlobals,cGlobals)
stateMachine:register(courseBot_state.cInit,cInit)
stateMachine:register(courseBot_state.cRun,cRun)
stateMachine:register(courseBot_state.cWorldPlay,cWorldPlay)
stateMachine:register(courseBot_state.cLevelPlay,cLevelPlay)
stateMachine:register(courseBot_state.cChangeCategory,cChangeCategory)
stateMachine:register(courseBot_state.cChallenge,cChallenge)
stateMachine:register(courseBot_state.cChallengeInfo,cChallengeInfo)
stateMachine:register(courseBot_state.cMyCourses,cMyCourses)
stateMachine:register(courseBot_state.cMyCoursesInfo,cMyCoursesInfo)
stateMachine:register(courseBot_state.cChallengePlay,cChallengePlay)
stateMachine:register(courseBot_state.cAnimOut,cAnimOut)
stateMachine:register(courseBot_state.cGoToEditor,cGoToEditor)
stateMachine:register(courseBot_state.cInfoOut,cInfoOut)
stateMachine:register(courseBot_state.cMyCoursesPlay,cMyCoursesPlay)
stateMachine:register(courseBot_state.cSave,cSave)
stateMachine:register(courseBot_state.cGoToEditorNewCourse,cGoToEditorNewCourse)
stateMachine:register(courseBot_state.cDelete,cDelete)
stateMachine:register(courseBot_state.cConfirmDelete,cConfirmDelete)
stateMachine:register(courseBot_state.cPlayWorldLevel,cPlayWorldLevel)
stateMachine:register(courseBot_state.cBack,cBack)
stateMachine:register(courseBot_state.cLocalShareSend,cLocalShareSend)
stateMachine:register(courseBot_state.cLocalShareReceive,cLocalShareReceive)
stateMachine:register(courseBot_state.cChangeName,cChangeName)
stateMachine:register(courseBot_state.cLocalShareInProgress,cLocalShareInProgress)
stateMachine:register(courseBot_state.cCategoryChangePrep,cCategoryChangePrep)
stateMachine:register(courseBot_state.cDeleteCancelled,cDeleteCancelled)
stateMachine:register(courseBot_state.cDeleteWait,cDeleteWait)
stateMachine:endRegister()
end

