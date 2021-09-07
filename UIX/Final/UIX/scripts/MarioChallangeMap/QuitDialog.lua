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
cEnd=1,
cYes=2,
cNo=3,
_stateCount=4
}
-------------------------------------------------------------
function onEntercEnter()
local botScreen = ui:getScreen(SCREEN.BOTTOM)
botScreen :setMessageId("T_Text", "Msg_0009") -- MCAT#2532 using 1 textbox from simplified dialog

botScreen:setButtonMessageId("btn_yes", "T_Btn_00", "BtnR_0009")

botScreen:setButtonMessageId("btn_no", "T_Btn_00", "BtnL_0009")
end
function onUpdatecEnter()

end
function onExitcEnter()

end
function onEntercEnd()

end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercYes()
GlobalData:setChallengePlaying(false)
GlobalData:setChallengeLevelIndex(0)
GlobalData:setChallengeWorldIndex(0)
GlobalData:setChallengeLevelPresentationIndex(0)
GlobalData:writeToSaveDataChallengeMode()
GlobalData:setRestartChallengeMap(true)
Sound:playSound("window_out")
GameState:switchScene("MarioChallangeMap")
end
function onUpdatecYes()

end
function onExitcYes()

end
function onEntercNo()
Sound:playSound("window_out")
ui:goToPreviousScreen() 
ui:getUI("MapLong"):enableUIInput() -- mcat#1477 - enable back ui input
stateMachine:requestState(QuitDialog_state.cEnd)
end
function onUpdatecNo()

end
function onExitcNo()

end
-------------------------------------------------------------
cEnter={}
cEnter.onEnter=onEntercEnter
cEnter.onUpdate=onUpdatecEnter
cEnter.onExit=onExitcEnter
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
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
stateMachine:startRegister (QuitDialog_state._stateCount,QuitDialog_state.cEnter)
stateMachine:register(QuitDialog_state.cEnter,cEnter)
stateMachine:register(QuitDialog_state.cEnd,cEnd)
stateMachine:register(QuitDialog_state.cYes,cYes)
stateMachine:register(QuitDialog_state.cNo,cNo)
stateMachine:endRegister()
end

