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
SpotPassConfirm_state= {
cDefault=0,
cYes=1,
cNo=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercDefault()

end
function onUpdatecDefault()

end
function onExitcDefault()

end
function onEntercYes()
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

ui:goToPreviousScreen()
stateMachine:requestState(SpotPassConfirm_state.cDefault)
end
function onUpdatecYes()

end
function onExitcYes()

end
function onEntercNo()
ui:goToPreviousScreen()
stateMachine:requestState(SpotPassConfirm_state.cDefault)
end
function onUpdatecNo()

end
function onExitcNo()

end
-------------------------------------------------------------
cDefault={}
cDefault.onEnter=onEntercDefault
cDefault.onUpdate=onUpdatecDefault
cDefault.onExit=onExitcDefault
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
stateMachine:startRegister (SpotPassConfirm_state._stateCount,SpotPassConfirm_state.cDefault)
stateMachine:register(SpotPassConfirm_state.cDefault,cDefault)
stateMachine:register(SpotPassConfirm_state.cYes,cYes)
stateMachine:register(SpotPassConfirm_state.cNo,cNo)
stateMachine:endRegister()
end

