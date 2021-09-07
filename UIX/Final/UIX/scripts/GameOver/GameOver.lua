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
GameOver_state= {
cScript=0,
_stateCount=1
}
-------------------------------------------------------------
function onEntercScript()
GameSaveDataTest:setLives(10) -- give back 10 lives
end
function onUpdatecScript()
if Input:isTriggered(BUTTON.A) then
	GameState:switchScene("MarioChallangeMap")
end
end
function onExitcScript()

end
-------------------------------------------------------------
cScript={}
cScript.onEnter=onEntercScript
cScript.onUpdate=onUpdatecScript
cScript.onExit=onExitcScript
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (GameOver_state._stateCount,GameOver_state.cScript)
stateMachine:register(GameOver_state.cScript,cScript)
stateMachine:endRegister()
end

