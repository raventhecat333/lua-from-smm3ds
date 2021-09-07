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
title_state= {
init=0,
cGoToMap=1,
cGoToEditor=2,
cGoToCourseWorld=3,
cOpenPlayOptions=4,
cClosePlayOptions=5,
cGoToTutorial=6,
cGoToCourseBot=7,
cEnd=8,
cInPlayOptions=9,
_stateCount=10
}
-------------------------------------------------------------
function onEnterinit()
function updateLogo(showWhite)
	local topScreen = ui:getScreen(SCREEN.TOP)
	if topScreen then
		topScreen:setVisible("N_LogoWhite", showWhite)
		topScreen:setVisible("N_labels_White", showWhite)
		topScreen:setVisible("N_LogoBlack", ~showWhite)
		topScreen:setVisible("N_labels_Black", ~showWhite)
	end
end

function stayInRelease(buttonName)
	local button = ui:getButton(buttonName)
	if button then
		button:setReleaseStay(true)
	end
end

-- make buttons stay in release
stayInRelease("L_MarioChallenge_Btn")
stayInRelease("L_Network_Btn")
stayInRelease("L_Coursebot_Btn")

stateMachine:requestState(title_state.cEnd)
end
function onUpdateinit()

end
function onExitinit()

end
function onEntercGoToMap()
GlobalData:addPlayReportVal("sys012")

Sound:stopMusic()
Sound:stopAmbientSound()
GlobalData:readFromSaveDataChallengeMode()
GlobalData:setStateIdx(0)
GameState:switchScene("MarioChallangeMap")
GameState:freezeGameUpdate()

end
function onUpdatecGoToMap()

end
function onExitcGoToMap()

end
function onEntercGoToEditor()
GlobalData:addPlayReportVal("sys011")

gAnimTop = ui:getScreen(SCREEN.TOP):playAnimation("DecideEditBtn", false)

gAnimBot = ui:getScreen(SCREEN.BOTTOM):playAnimation("DecideEditBtn", false)

Sound:playSound("title_decide01")
Sound:stopMusic(135)
Sound:stopAmbientSound()
ui:disableInput() -- disable ui input when doing transition to editor
GameState:freezeGameUpdate()

end
function onUpdatecGoToEditor()
if (gAnimTop ~= nil and gAnimTop:isPlaying() == false) then
	GameState:switchScene("Editor")
	stateMachine:requestState(title_state.cEnd)
end
end
function onExitcGoToEditor()

end
function onEntercGoToCourseWorld()
GlobalData:addPlayReportVal("sys013")

Sound:stopMusic()
Sound:stopAmbientSound()
GameState:switchScene("CourseWorldNew")
GameState:freezeGameUpdate()
end
function onUpdatecGoToCourseWorld()

end
function onExitcGoToCourseWorld()

end
function onEntercOpenPlayOptions()
gOpeningOptions = ui:getScreen(SCREEN.BOTTOM):playAnimation("DecidePlayBtn", false)
ui:disableInput()
Sound:playSound("play_button_appear")
end
function onUpdatecOpenPlayOptions()
if gOpeningOptions:isPlaying() == false then
	stateMachine:requestState(title_state.cInPlayOptions)
end
end
function onExitcOpenPlayOptions()

end
function onEntercClosePlayOptions()
Sound:playSound("title_cancel")
ui:disableInput()
gCloseOptionsAnim =  ui:getScreen(SCREEN.BOTTOM):playAnimation("DecideBackBtn", false)
end
function onUpdatecClosePlayOptions()
if gCloseOptionsAnim:isPlaying() == false then
	ui:enableInput()
	stateMachine:requestState(title_state.cEnd)
end
end
function onExitcClosePlayOptions()

end
function onEntercGoToTutorial()
GameState:switchScene("Tutorial0")
GameState:freezeGameUpdate()
end
function onUpdatecGoToTutorial()

end
function onExitcGoToTutorial()

end
function onEntercGoToCourseBot()
GlobalData:addPlayReportVal("sys009")

Sound:stopMusic()
Sound:stopAmbientSound()
GameState:switchScene("CourseBot")
GameState:freezeGameUpdate()

end
function onUpdatecGoToCourseBot()

end
function onExitcGoToCourseBot()

end
function onEntercEnd()
ui:disablePadInput()
ui:enableInput()
GlobalData:enableTitlePlayerController()
end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercInPlayOptions()
ui:enablePadInput()
ui:enableInput()
GlobalData:disableTitlePlayerController()
end
function onUpdatecInPlayOptions()
if ui:isPhysicalButtonEnabled() == false then return end -- mcat #966 - do not let any input if ui input is disabled
if Input:isTriggered(BUTTON.B) then
	ui:disableInput()
	stateMachine:requestState(title_state.cClosePlayOptions)
end
end
function onExitcInPlayOptions()

end
-------------------------------------------------------------
init={}
init.onEnter=onEnterinit
init.onUpdate=onUpdateinit
init.onExit=onExitinit
cGoToMap={}
cGoToMap.onEnter=onEntercGoToMap
cGoToMap.onUpdate=onUpdatecGoToMap
cGoToMap.onExit=onExitcGoToMap
cGoToEditor={}
cGoToEditor.onEnter=onEntercGoToEditor
cGoToEditor.onUpdate=onUpdatecGoToEditor
cGoToEditor.onExit=onExitcGoToEditor
cGoToCourseWorld={}
cGoToCourseWorld.onEnter=onEntercGoToCourseWorld
cGoToCourseWorld.onUpdate=onUpdatecGoToCourseWorld
cGoToCourseWorld.onExit=onExitcGoToCourseWorld
cOpenPlayOptions={}
cOpenPlayOptions.onEnter=onEntercOpenPlayOptions
cOpenPlayOptions.onUpdate=onUpdatecOpenPlayOptions
cOpenPlayOptions.onExit=onExitcOpenPlayOptions
cClosePlayOptions={}
cClosePlayOptions.onEnter=onEntercClosePlayOptions
cClosePlayOptions.onUpdate=onUpdatecClosePlayOptions
cClosePlayOptions.onExit=onExitcClosePlayOptions
cGoToTutorial={}
cGoToTutorial.onEnter=onEntercGoToTutorial
cGoToTutorial.onUpdate=onUpdatecGoToTutorial
cGoToTutorial.onExit=onExitcGoToTutorial
cGoToCourseBot={}
cGoToCourseBot.onEnter=onEntercGoToCourseBot
cGoToCourseBot.onUpdate=onUpdatecGoToCourseBot
cGoToCourseBot.onExit=onExitcGoToCourseBot
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cInPlayOptions={}
cInPlayOptions.onEnter=onEntercInPlayOptions
cInPlayOptions.onUpdate=onUpdatecInPlayOptions
cInPlayOptions.onExit=onExitcInPlayOptions
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (title_state._stateCount,title_state.init)
stateMachine:register(title_state.init,init)
stateMachine:register(title_state.cGoToMap,cGoToMap)
stateMachine:register(title_state.cGoToEditor,cGoToEditor)
stateMachine:register(title_state.cGoToCourseWorld,cGoToCourseWorld)
stateMachine:register(title_state.cOpenPlayOptions,cOpenPlayOptions)
stateMachine:register(title_state.cClosePlayOptions,cClosePlayOptions)
stateMachine:register(title_state.cGoToTutorial,cGoToTutorial)
stateMachine:register(title_state.cGoToCourseBot,cGoToCourseBot)
stateMachine:register(title_state.cEnd,cEnd)
stateMachine:register(title_state.cInPlayOptions,cInPlayOptions)
stateMachine:endRegister()
end

