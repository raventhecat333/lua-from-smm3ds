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
CourseBotWorldCourseClear_state= {
cInit=0,
cLoop=1,
cEnd=2,
cExit=3,
_stateCount=4
}
-------------------------------------------------------------
function onEntercInit()
GlobalData:setGameplayType(0)

topScreen = ui:getScreen(2)

animIn = topScreen:playAnimation("In")
end
function onUpdatecInit()
if animIn ~= nil and animIn:isPlaying() == false then
	stateMachine:requestState(CourseBotWorldCourseClear_state.cLoop)
end
end
function onExitcInit()

end
function onEntercLoop()
counter = 120

topScreen = ui:getScreen(2)
animLoop = topScreen:playAnimation("Loop")
end
function onUpdatecLoop()
counter = counter - 1
if counter <= 0 then
	stateMachine:requestState(CourseBotWorldCourseClear_state.cEnd)
end
end
function onExitcLoop()

end
function onEntercEnd()
topScreen = ui:getScreen(2)

animOut = topScreen:playAnimation("Out")
end
function onUpdatecEnd()
if animOut ~= nil and animOut:isPlaying() == false then
	stateMachine:requestState(CourseBotWorldCourseClear_state.cExit)
end
end
function onExitcEnd()

end
function onEntercExit()
GameState:switchScene("CourseBot")
end
function onUpdatecExit()

end
function onExitcExit()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cLoop={}
cLoop.onEnter=onEntercLoop
cLoop.onUpdate=onUpdatecLoop
cLoop.onExit=onExitcLoop
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cExit={}
cExit.onEnter=onEntercExit
cExit.onUpdate=onUpdatecExit
cExit.onExit=onExitcExit
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (CourseBotWorldCourseClear_state._stateCount,CourseBotWorldCourseClear_state.cInit)
stateMachine:register(CourseBotWorldCourseClear_state.cInit,cInit)
stateMachine:register(CourseBotWorldCourseClear_state.cLoop,cLoop)
stateMachine:register(CourseBotWorldCourseClear_state.cEnd,cEnd)
stateMachine:register(CourseBotWorldCourseClear_state.cExit,cExit)
stateMachine:endRegister()
end

