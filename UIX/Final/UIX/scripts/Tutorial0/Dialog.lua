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
Dialog_state= {
cInit=0,
cGoToNextTutorial=1,
cGoToTutorialMenu=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercInit()

end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercGoToNextTutorial()
if Tutorial:isLastTutorial() then
	GameState:switchScene("EditorNew")
elseif Tutorial:isAdvanceTutorial() then
	GameState:switchScene("TutorialAdvancedPlay")
else
	GameState:switchScene("Tutorial0")
end
end
function onUpdatecGoToNextTutorial()

end
function onExitcGoToNextTutorial()

end
function onEntercGoToTutorialMenu()
--GameState:switchScene("EditorNew")
GameState:switchSceneByStateID(GlobalData:getRecordedGameState())
end
function onUpdatecGoToTutorialMenu()

end
function onExitcGoToTutorialMenu()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cGoToNextTutorial={}
cGoToNextTutorial.onEnter=onEntercGoToNextTutorial
cGoToNextTutorial.onUpdate=onUpdatecGoToNextTutorial
cGoToNextTutorial.onExit=onExitcGoToNextTutorial
cGoToTutorialMenu={}
cGoToTutorialMenu.onEnter=onEntercGoToTutorialMenu
cGoToTutorialMenu.onUpdate=onUpdatecGoToTutorialMenu
cGoToTutorialMenu.onExit=onExitcGoToTutorialMenu
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Dialog_state._stateCount,Dialog_state.cInit)
stateMachine:register(Dialog_state.cInit,cInit)
stateMachine:register(Dialog_state.cGoToNextTutorial,cGoToNextTutorial)
stateMachine:register(Dialog_state.cGoToTutorialMenu,cGoToTutorialMenu)
stateMachine:endRegister()
end

