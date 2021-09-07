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
tutorialSelection_state= {
cInit=0,
cGoToMainMenu=1,
_stateCount=2
}
-------------------------------------------------------------
function onEntercInit()

end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercGoToMainMenu()
ui:goToPreviousScreen()

stateMachine:requestState(tutorialSelection_state.cInit)
end
function onUpdatecGoToMainMenu()

end
function onExitcGoToMainMenu()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cGoToMainMenu={}
cGoToMainMenu.onEnter=onEntercGoToMainMenu
cGoToMainMenu.onUpdate=onUpdatecGoToMainMenu
cGoToMainMenu.onExit=onExitcGoToMainMenu
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (tutorialSelection_state._stateCount,tutorialSelection_state.cInit)
stateMachine:register(tutorialSelection_state.cInit,cInit)
stateMachine:register(tutorialSelection_state.cGoToMainMenu,cGoToMainMenu)
stateMachine:endRegister()
end

