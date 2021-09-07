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
HundredMarioTitle_state= {
cCourseWorld=0,
_stateCount=1
}
-------------------------------------------------------------
function onEntercCourseWorld()
local topScreen = ui:getScreen(2)
local botScreen = ui:getScreen(1)

-- animA = topScreen:playAnimation("Out")
-- animB = botScreen:playAnimation("Out")
end
function onUpdatecCourseWorld()

end
function onExitcCourseWorld()

end
-------------------------------------------------------------
cCourseWorld={}
cCourseWorld.onEnter=onEntercCourseWorld
cCourseWorld.onUpdate=onUpdatecCourseWorld
cCourseWorld.onExit=onExitcCourseWorld
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (HundredMarioTitle_state._stateCount,HundredMarioTitle_state.cCourseWorld)
stateMachine:register(HundredMarioTitle_state.cCourseWorld,cCourseWorld)
stateMachine:endRegister()
end

