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
QuitDialog_state= {
cEnter=0,
cYes=1,
cRun=2,
cInit=3,
cNo=4,
cOk=5,
_stateCount=6
}
-------------------------------------------------------------
function onEntercEnter()
type = {}
type.Default = -1
type.MyCourses = 0
type.MarioChallenge = 1
type.CourseBotChallengeCourses = 2
type.HundredMarioChallenge = 3
type.CourseWorld = 4
type.StreetPassCourse = 5
type.CourseSelect = 6
type.TutorialAdvanced = 8
type.WorldPlay = 9
type.ValidateCourse = 10

-- set the dialog text
botScreen = ui:getScreen(SCREEN.BOTTOM)
gGameplayType = GlobalData:getGameplayType()

-- make sure that buttons stay in pressed state
function stayInRelease(buttonName)
	local button = ui:getButton(buttonName)
	if button then
		button:setReleaseStay(true)
	end
end

stayInRelease("btn_ok")
stayInRelease("btn_yes")
stayInRelease("btn_no")

stateMachine:requestState(QuitDialog_state.cRun)

end
function onUpdatecEnter()

end
function onExitcEnter()

end
function onEntercYes()
EditNotSaved = 0
QuitSave = 1
ChallengeMedals = 2

if gPauseType  == EditNotSaved then
	if gGameplayType == type.ValidateCourse then 
		GlobalData:setGameplayType(type.MyCourses)
	end
	GlobalData:setInfoView(false)
	GameState:switchScene("EditorNew")
elseif gPauseType == QuitSave then
	-- we should always be in 100 mario challenge, so return to course world
	if gGameplayType == type.HundredMarioChallenge then
		GameState:switchScene("CourseWorldNew")
	elseif gGameplayType == type.MarioChallenge then
		GameState:switchScene("MarioChallangeMap")
	end
end
end
function onUpdatecYes()

end
function onExitcYes()

end
function onEntercRun()

end
function onUpdatecRun()
if ui:isActive() and ui:isIdle() then
	stateMachine:requestState(QuitDialog_state.cInit)
end
end
function onExitcRun()

end
function onEntercInit()
gPauseType = GlobalData:getPauseSelectionType()
botScreen = ui:getScreen(SCREEN.BOTTOM)
EditNotSaved = 0
QuitSave = 1
ChallengeMedals = 2

if gPauseType == EditNotSaved then
	NN_LOG("Hi")
	botScreen:playAnimation("Type1_TwoButtonDialogue")
	botScreen:setMessageId("T_Text", "Msg_UnsavedWorkLost")
	botScreen:setButtonMessageId("btn_yes", "T_Btn_00", "BtnR_0019")
	botScreen:setButtonMessageId("btn_no", "T_Btn_00", "BtnL_0019")
elseif gPauseType == QuitSave then
	NN_LOG("Bye")
	botScreen:playAnimation("Type1_TwoButtonDialogue")
	botScreen:setMessageId("T_Text", "Msg_0019")
	botScreen:setButtonMessageId("btn_yes", "T_Btn_00", "BtnR_0019")
	botScreen:setButtonMessageId("btn_no", "T_Btn_00", "BtnL_0019")
elseif gPauseType == ChallengeMedals then
	NN_LOG("Sup")
	botScreen:playAnimation("Type1_OneButtonDialogue")
	botScreen:setMessageId("T_Text", "msg_CannotEdit_NeedMedals")
	botScreen:setButtonMessageId("btn_okay", "T_Btn_00", "BtnC_0007")
end

botScreen:playAnimation("Type1_In")
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercNo()
Sound:playSound("window_out")
ui:goToPreviousScreen()
stateMachine:requestState(QuitDialog_state.cRun)
end
function onUpdatecNo()

end
function onExitcNo()

end
function onEntercOk()
Sound:playSound("window_out")
ui:goToPreviousScreen()
stateMachine:requestState(QuitDialog_state.cRun)
end
function onUpdatecOk()

end
function onExitcOk()

end
-------------------------------------------------------------
cEnter={}
cEnter.onEnter=onEntercEnter
cEnter.onUpdate=onUpdatecEnter
cEnter.onExit=onExitcEnter
cYes={}
cYes.onEnter=onEntercYes
cYes.onUpdate=onUpdatecYes
cYes.onExit=onExitcYes
cRun={}
cRun.onEnter=onEntercRun
cRun.onUpdate=onUpdatecRun
cRun.onExit=onExitcRun
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cNo={}
cNo.onEnter=onEntercNo
cNo.onUpdate=onUpdatecNo
cNo.onExit=onExitcNo
cOk={}
cOk.onEnter=onEntercOk
cOk.onUpdate=onUpdatecOk
cOk.onExit=onExitcOk
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (QuitDialog_state._stateCount,QuitDialog_state.cEnter)
stateMachine:register(QuitDialog_state.cEnter,cEnter)
stateMachine:register(QuitDialog_state.cYes,cYes)
stateMachine:register(QuitDialog_state.cRun,cRun)
stateMachine:register(QuitDialog_state.cInit,cInit)
stateMachine:register(QuitDialog_state.cNo,cNo)
stateMachine:register(QuitDialog_state.cOk,cOk)
stateMachine:endRegister()
end

