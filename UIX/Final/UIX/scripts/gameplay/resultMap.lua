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
static={}
resultMap_state= {
cGlobals=0,
cActive=1,
cInit=2,
cShowMedal1=3,
cShowMedal2=4,
cWait=5,
_stateCount=6
}
-------------------------------------------------------------
function onEntercGlobals()
gTimer = 0
gNextState = -1
stateMachine:requestState(resultMap_state.cInit)
end
function onUpdatecGlobals()

end
function onExitcGlobals()

end
function onEntercActive()

end
function onUpdatecActive()

end
function onExitcActive()

end
function onEntercInit()

end
function onUpdatecInit()
if ui:isIdle() and ui:isActive() then
	if Input:isTriggered(BUTTON.A) then
		stateMachine:requestState(resultMap_state.cShowMedal1)
	end
end
end
function onExitcInit()

end
function onEntercShowMedal1()
gAnim = ui:getScreen(2):playAnimation("Conditional_in")

end
function onUpdatecShowMedal1()
if gAnim ~= nil and gAnim:isPlaying() == false then
	if Input:isTriggered(BUTTON.A) then
--	gTimer = 60
--	gNextState =resultMap_state.cShowMedal2
		stateMachine:requestState(resultMap_state.cShowMedal2)
	end
end
end
function onExitcShowMedal1()

end
function onEntercShowMedal2()
gAnim = ui:getScreen(2):playAnimation("Speciall_in")

end
function onUpdatecShowMedal2()

end
function onExitcShowMedal2()

end
function onEntercWait()

end
function onUpdatecWait()
if gTimer > 0 then
	gTimer = gTimer - 1
	return
end

stateMachine:requestState(gNextState)
end
function onExitcWait()

end
-------------------------------------------------------------
cGlobals={}
cGlobals.onEnter=onEntercGlobals
cGlobals.onUpdate=onUpdatecGlobals
cGlobals.onExit=onExitcGlobals
cActive={}
cActive.onEnter=onEntercActive
cActive.onUpdate=onUpdatecActive
cActive.onExit=onExitcActive
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cShowMedal1={}
cShowMedal1.onEnter=onEntercShowMedal1
cShowMedal1.onUpdate=onUpdatecShowMedal1
cShowMedal1.onExit=onExitcShowMedal1
cShowMedal2={}
cShowMedal2.onEnter=onEntercShowMedal2
cShowMedal2.onUpdate=onUpdatecShowMedal2
cShowMedal2.onExit=onExitcShowMedal2
cWait={}
cWait.onEnter=onEntercWait
cWait.onUpdate=onUpdatecWait
cWait.onExit=onExitcWait
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (resultMap_state._stateCount,resultMap_state.cGlobals)
stateMachine:register(resultMap_state.cGlobals,cGlobals)
stateMachine:register(resultMap_state.cActive,cActive)
stateMachine:register(resultMap_state.cInit,cInit)
stateMachine:register(resultMap_state.cShowMedal1,cShowMedal1)
stateMachine:register(resultMap_state.cShowMedal2,cShowMedal2)
stateMachine:register(resultMap_state.cWait,cWait)
stateMachine:endRegister()
end

