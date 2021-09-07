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
100MarioCourseClear_state= {
cInit=0,
_stateCount=1
}
-------------------------------------------------------------
function onEntercInit()

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
stateMachine:startRegister (100MarioCourseClear_state._stateCount,100MarioCourseClear_state.cInit)
stateMachine:register(100MarioCourseClear_state.cInit,cInit)
stateMachine:endRegister()
end

