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
boot_state= {
cStart=0,
cEnd=1,
_stateCount=2
}
-------------------------------------------------------------
function onEntercStart()
table = {}
table[0] = "Boot_Yamamura_01"
table[1] = "Boot_Yamamura_02"
table[2] = "Boot_Yamamura_03"
table[3] = "Boot_Yamamura_04"
table[4] = "Boot_Yamamura_05"
table[5] = "Boot_Yamamura_06"
table[6] = "Boot_Yamamura_07"
table[7] = "Boot_Yamamura_08"

local val = GlobalData:getRandom(0,7)

ui:getScreen(SCREEN.BOTTOM):playAnimation(table[val], false)
end
function onUpdatecStart()
if ui:isIdle() or Input:isTriggered(BUTTON.A) then
	stateMachine:requestState(boot_state.cEnd)
end
end
function onExitcStart()

end
function onEntercEnd()
--Sound:stopMusic()
--GameState:switchScene("InitSaveMemState")
end
function onUpdatecEnd()

end
function onExitcEnd()

end
-------------------------------------------------------------
cStart={}
cStart.onEnter=onEntercStart
cStart.onUpdate=onUpdatecStart
cStart.onExit=onExitcStart
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (boot_state._stateCount,boot_state.cStart)
stateMachine:register(boot_state.cStart,cStart)
stateMachine:register(boot_state.cEnd,cEnd)
stateMachine:endRegister()
end

