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
CourseWorld_state= {
cChallengeTouchOn=0,
cHundredMario=1,
cEnd=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercChallengeTouchOn()
gAnim = ui:getScreen(0):playAnimation("TouchOnOff")
end
function onUpdatecChallengeTouchOn()

end
function onExitcChallengeTouchOn()

end
function onEntercHundredMario()
local topScreen = ui:getScreen(2)
local botScreen = ui:getScreen(1)

ui:changeScreen("HundredMario", false, false, false)
stateMachine:requestState(CourseWorld_state.cEnd)

-- animA = topScreen:playAnimation("Out")
-- animB = botScreen:playAnimation("Out")

end
function onUpdatecHundredMario()

end
function onExitcHundredMario()

end
function onEntercEnd()

end
function onUpdatecEnd()

end
function onExitcEnd()

end
-------------------------------------------------------------
cChallengeTouchOn={}
cChallengeTouchOn.onEnter=onEntercChallengeTouchOn
cChallengeTouchOn.onUpdate=onUpdatecChallengeTouchOn
cChallengeTouchOn.onExit=onExitcChallengeTouchOn
cHundredMario={}
cHundredMario.onEnter=onEntercHundredMario
cHundredMario.onUpdate=onUpdatecHundredMario
cHundredMario.onExit=onExitcHundredMario
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (CourseWorld_state._stateCount,CourseWorld_state.cChallengeTouchOn)
stateMachine:register(CourseWorld_state.cChallengeTouchOn,cChallengeTouchOn)
stateMachine:register(CourseWorld_state.cHundredMario,cHundredMario)
stateMachine:register(CourseWorld_state.cEnd,cEnd)
stateMachine:endRegister()
end

