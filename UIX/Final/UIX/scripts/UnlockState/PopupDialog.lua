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
PopupDialog_state= {
cInit=0,
_stateCount=1
}
-------------------------------------------------------------
function onEntercInit()
local buttonList =
{
"btn_ok",
"btn_cancel",
"btn_yes",
"btn_no",
"btn_no_00",
"btn_yes_01",
"btn_no_01"
}

for i=1,7 do
	local button = ui:getButton(buttonList[i])
	if button then
		button:setReleaseStay(true)
	end
end

-- MCAT#2994, MCAT#2995 - use different message for unlock screen
ui:getScreen(SCREEN.BOTTOM):setButtonMessageId("btn_ok", "T_Btn_00", "GenericBtn_OK_00")
end
function onUpdatecInit()

end
function onExitcInit()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (PopupDialog_state._stateCount,PopupDialog_state.cInit)
stateMachine:register(PopupDialog_state.cInit,cInit)
stateMachine:endRegister()
end

