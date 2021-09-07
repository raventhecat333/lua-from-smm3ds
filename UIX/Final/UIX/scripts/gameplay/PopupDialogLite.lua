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
PopupDialogLite_state= {
cInit=0,
cDefault=1,
cActive=2,
cYes=3,
cNo=4,
_stateCount=5
}
-------------------------------------------------------------
function onEntercInit()
ui:msgBinLoad("CommonMsg/Cmn_SystemMessage.msbt")

local buttonYes = ui:getButton("btn_yes")
local buttonNo = ui:getButton("btn_no")
if buttonYes then
	gYesOnReleasedSFX = buttonYes:getButtonOverrideSFX("ON_RELEASED")
else
	gYesOnReleasedSFX = -1	
end
if buttonNo then
	gNoOnReleasedSFX = buttonNo:getButtonOverrideSFX("ON_RELEASED")
else
	gNoOnReleasedSFX = -1
end

-- use text box position that uses buttons
local screen = ui:getScreen(SCREEN.BOTTOM)
if screen then
	screen:playAnimation("Type1_OneButtonDialogue", false)
end

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

stateMachine:requestState(PopupDialogLite_state.cDefault)
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercDefault()
local popupUI = ui:getUI("PopupDialogLite")
if gYesOnReleasedSFX ~= -1 then
	local buttonYes = popupUI:getButton("btn_yes")
	if buttonYes then
		buttonYes:setButtonOverrideSFX("ON_RELEASED", gYesOnReleasedSFX)
	end
end
if gNoOnReleasedSFX ~= -1 then
	local buttonNo = popupUI:getButton("btn_no")
	if buttonNo then
		buttonNo:setButtonOverrideSFX("ON_RELEASED", gNoOnReleasedSFX)
	end
end

end
function onUpdatecDefault()
if ui:isActive() == true then
	stateMachine:requestState(PopupDialogLite_state.cActive)
end
end
function onExitcDefault()

end
function onEntercActive()
if ui:isPreviousScreen("settings") then
	local buttonYes = ui:getButton("btn_yes")
	local buttonNo = ui:getButton("btn_no")
	if buttonYes then
		buttonYes:setButtonOverrideSFXByName("ON_RELEASED", "pm_save_quit_yes")
	end
	if buttonNo then
		buttonNo:setButtonOverrideSFXByName("ON_RELEASED", "pm_save_quit_no")
	end
end
end
function onUpdatecActive()

end
function onExitcActive()

end
function onEntercYes()
if ui:isPreviousScreen("settings") then
	local playReportEnabled = GlobalData:getPlayReportState()

	if playReportEnabled == true then
		playReportEnabled = false
	else
		playReportEnabled = true
	end

	GlobalData:setPlayReportState(playReportEnabled)

	local settingsUI = ui:getUI("settings")
	if settingsUI then
		local buttonOff = settingsUI:getButton("btn_spotPass_OFF")
		local buttonOn = settingsUI:getButton("btn_spotPass_ON")
		if buttonOff then
			buttonOff:setVisible(playReportEnabled == false)
		end
		if buttonOn then
			buttonOn:setVisible(playReportEnabled == true)
		end
	end
	Sound:playSound("window_out")
	ui:goToPreviousScreen()
end
stateMachine:requestState(PopupDialogLite_state.cDefault)
end
function onUpdatecYes()

end
function onExitcYes()

end
function onEntercNo()
if ui:isPreviousScreen("settings") then
	Sound:playSound("window_out")
	ui:goToPreviousScreen()
end
stateMachine:requestState(PopupDialogLite_state.cDefault)
end
function onUpdatecNo()

end
function onExitcNo()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cDefault={}
cDefault.onEnter=onEntercDefault
cDefault.onUpdate=onUpdatecDefault
cDefault.onExit=onExitcDefault
cActive={}
cActive.onEnter=onEntercActive
cActive.onUpdate=onUpdatecActive
cActive.onExit=onExitcActive
cYes={}
cYes.onEnter=onEntercYes
cYes.onUpdate=onUpdatecYes
cYes.onExit=onExitcYes
cNo={}
cNo.onEnter=onEntercNo
cNo.onUpdate=onUpdatecNo
cNo.onExit=onExitcNo
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (PopupDialogLite_state._stateCount,PopupDialogLite_state.cInit)
stateMachine:register(PopupDialogLite_state.cInit,cInit)
stateMachine:register(PopupDialogLite_state.cDefault,cDefault)
stateMachine:register(PopupDialogLite_state.cActive,cActive)
stateMachine:register(PopupDialogLite_state.cYes,cYes)
stateMachine:register(PopupDialogLite_state.cNo,cNo)
stateMachine:endRegister()
end

