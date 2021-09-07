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
SlidePassExplain_state= {
cEnter=0,
cInit=1,
_stateCount=2
}
-------------------------------------------------------------
function onEntercEnter()

end
function onUpdatecEnter()
if ui:isActive() then -- init dialog on activate
	stateMachine:requestState(SlidePassExplain_state.cInit)
end
end
function onExitcEnter()

end
function onEntercInit()
-- set the dialog text
local botScreen = ui:getScreen(SCREEN.BOTTOM)
botScreen :setMessageId("T_Text", "Msg_0006")
botScreen:setButtonMessageId("btn_ok", "T_Btn_00", "BtnC_0006")

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

end
function onUpdatecInit()

end
function onExitcInit()

end
-------------------------------------------------------------
cEnter={}
cEnter.onEnter=onEntercEnter
cEnter.onUpdate=onUpdatecEnter
cEnter.onExit=onExitcEnter
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (SlidePassExplain_state._stateCount,SlidePassExplain_state.cEnter)
stateMachine:register(SlidePassExplain_state.cEnter,cEnter)
stateMachine:register(SlidePassExplain_state.cInit,cInit)
stateMachine:endRegister()
end

