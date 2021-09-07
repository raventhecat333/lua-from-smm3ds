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
Credits_state= {
cInit=0,
cCredits=1,
cEnd=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercInit()
stateMachine:requestState(Credits_state.cCredits)
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercCredits()
gAnim = ui:getScreen(SCREEN.TOP):getAnimation("all")

end
function onUpdatecCredits()
if gAnim ~= nil and gAnim:isPlaying() == false then
	stateMachine:requestState(Credits_state.cEnd)
end
if Input:isTriggered(BUTTON.START) then
	stateMachine:requestState(Credits_state.cEnd)
end
end
function onExitcCredits()

end
function onEntercEnd()
--GameState:switchScene("MarioChallangeMap")
Sound:stopMusic(15)
if GlobalData:getRecordedGameState() == -1 then
	GameState:switchScene("debugMenu")
else
	GameState:switchSceneByStateID(GlobalData:getRecordedGameState())
end
end
function onUpdatecEnd()

end
function onExitcEnd()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cCredits={}
cCredits.onEnter=onEntercCredits
cCredits.onUpdate=onUpdatecCredits
cCredits.onExit=onExitcCredits
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Credits_state._stateCount,Credits_state.cInit)
stateMachine:register(Credits_state.cInit,cInit)
stateMachine:register(Credits_state.cCredits,cCredits)
stateMachine:register(Credits_state.cEnd,cEnd)
stateMachine:endRegister()
end

