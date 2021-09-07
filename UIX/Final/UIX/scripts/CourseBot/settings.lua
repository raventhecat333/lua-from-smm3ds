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
settings_state= {
cInit=0,
cJumpToManual=1,
cGoToCredits=2,
cEnd=3,
cToggleControls=4,
cClose=5,
cSpotPass=6,
_stateCount=7
}
-------------------------------------------------------------
function onEntercInit()
gameState = {}
gameState.COURSE_PLAY_STATE = 6
gameState.TUTORIAL_PLAY_STATE = 24
local button = ui:getButton("btn_credits")
if button then
	-- do not show credits during gameplay
	local state = GameState:getState()
	if state == gameState.COURSE_PLAY_STATE or state == gameState.TUTORIAL_PLAY_STATE then
		button:setVisible(false)
	else
		if GlobalData:isCreditsOpen() then
			button:setVisible(true)
		else
			button:setVisible(false)
		end
	end
end

button = ui:getButton("btn_controls")
if button then
	local keyConfig = GlobalData:getKeyConfig()
	if keyConfig == 0 then
		button:forceToggleOff()
	else
		button:forceToggleOn()
	end
end

local buttonOff = ui:getButton("btn_spotPass_OFF")
local buttonOn = ui:getButton("btn_spotPass_ON")
local spotPassState = GlobalData:getPlayReportState()
if buttonOff then
	buttonOff:setVisible(spotPassState == false)
end
if buttonOn then
	buttonOn:setVisible(spotPassState == true)
end

-- 
function stayInRelease(buttonName)
	local button = ui:getButton(buttonName)
	if button then
		button:setReleaseStay(true)
	end
end

stayInRelease("btn_ok")

end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercJumpToManual()
GameState:jumpToManual()
stateMachine:requestState(settings_state.cEnd)
end
function onUpdatecJumpToManual()

end
function onExitcJumpToManual()

end
function onEntercGoToCredits()
GameState:switchScene("Credits")
end
function onUpdatecGoToCredits()

end
function onExitcGoToCredits()

end
function onEntercEnd()

end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercToggleControls()
GlobalData:addPlayReportVal("sys022")

local keyConfig = GlobalData:getKeyConfig()
if keyConfig == 0 then
	keyConfig = 1
	Sound:playSound("settings_controls2")
else
	keyConfig = 0
	Sound:playSound("settings_controls1")
end
GlobalData:setKeyConfig(keyConfig)
stateMachine:requestState(settings_state.cEnd)
end
function onUpdatecToggleControls()

end
function onExitcToggleControls()

end
function onEntercClose()
ui:goToPreviousScreen()
stateMachine:requestState(settings_state.cEnd)
end
function onUpdatecClose()

end
function onExitcClose()

end
function onEntercSpotPass()
local playReportEnabled = GlobalData:getPlayReportState()
local spotPassConfirmUI = ui:getUI("PopupDialogLite")
local isAgreed = GlobalData:isAgreedEULA()

if isAgreed == true then
	if spotPassConfirmUI then

		local botScreen = spotPassConfirmUI:getScreen(1)

		if botScreen then
			botScreen:playAnimation("Type1_TwoButtonDialogue", false)
			if playReportEnabled == true then
				botScreen:setMessageId("T_Text", "Msg_PlayReport_DeactivateConfirm")
			else
				botScreen:setMessageId("T_Text", "Msg_PlayReport_ActivateConfirm")
			end
		end
	end

	Sound:playSound("window_in")
	ui:changeScreen("PopupDialogLiteGroup", false, false, false)
end

stateMachine:requestState(settings_state.cEnd)
end
function onUpdatecSpotPass()

end
function onExitcSpotPass()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cJumpToManual={}
cJumpToManual.onEnter=onEntercJumpToManual
cJumpToManual.onUpdate=onUpdatecJumpToManual
cJumpToManual.onExit=onExitcJumpToManual
cGoToCredits={}
cGoToCredits.onEnter=onEntercGoToCredits
cGoToCredits.onUpdate=onUpdatecGoToCredits
cGoToCredits.onExit=onExitcGoToCredits
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cToggleControls={}
cToggleControls.onEnter=onEntercToggleControls
cToggleControls.onUpdate=onUpdatecToggleControls
cToggleControls.onExit=onExitcToggleControls
cClose={}
cClose.onEnter=onEntercClose
cClose.onUpdate=onUpdatecClose
cClose.onExit=onExitcClose
cSpotPass={}
cSpotPass.onEnter=onEntercSpotPass
cSpotPass.onUpdate=onUpdatecSpotPass
cSpotPass.onExit=onExitcSpotPass
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (settings_state._stateCount,settings_state.cInit)
stateMachine:register(settings_state.cInit,cInit)
stateMachine:register(settings_state.cJumpToManual,cJumpToManual)
stateMachine:register(settings_state.cGoToCredits,cGoToCredits)
stateMachine:register(settings_state.cEnd,cEnd)
stateMachine:register(settings_state.cToggleControls,cToggleControls)
stateMachine:register(settings_state.cClose,cClose)
stateMachine:register(settings_state.cSpotPass,cSpotPass)
stateMachine:endRegister()
end

