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
cGoToTitle=3,
cCloseDialog=4,
cEnd=5,
cGoToEditor=6,
cGoToEditorNow=7,
_stateCount=8
}
-------------------------------------------------------------
function onEntercInit()

end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercGoToNextTutorial()
Sound:stopMusic()

GameState:switchScene("Tutorial0")
end
function onUpdatecGoToNextTutorial()

end
function onExitcGoToNextTutorial()

end
function onEntercGoToTutorialMenu()
GameState:switchScene("tutDbgMenu")
end
function onUpdatecGoToTutorialMenu()

end
function onExitcGoToTutorialMenu()

end
function onEntercGoToTitle()
GameState:switchScene("title")
end
function onUpdatecGoToTitle()

end
function onExitcGoToTitle()

end
function onEntercCloseDialog()
Tutorial:closeDialog()

end
function onUpdatecCloseDialog()
if Tutorial:isClosed() then
	stateMachine:requestState(Dialog_state.cEnd)
end
end
function onExitcCloseDialog()

end
function onEntercEnd()

end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercGoToEditor()
Tutorial:showBubbleNext("Intro_Message10")

end
function onUpdatecGoToEditor()
if Tutorial:isActive() == false then return end
if Tutorial:canReadInput() == false then return end

if Input:isTriggered(BUTTON.A) or Tutorial:getAnswer() == 2 then
	stateMachine:requestState(Dialog_state.cGoToEditorNow)
end
end
function onExitcGoToEditor()

end
function onEntercGoToEditorNow()
Tutorial:closeDialog()
Tutorial:unlockInput()
end
function onUpdatecGoToEditorNow()
if Tutorial:isClosed() then
	GameState:switchScene("IntroTutorialEditor")
	stateMachine:requestState(Dialog_state.cEnd)
end
end
function onExitcGoToEditorNow()

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
cGoToTitle={}
cGoToTitle.onEnter=onEntercGoToTitle
cGoToTitle.onUpdate=onUpdatecGoToTitle
cGoToTitle.onExit=onExitcGoToTitle
cCloseDialog={}
cCloseDialog.onEnter=onEntercCloseDialog
cCloseDialog.onUpdate=onUpdatecCloseDialog
cCloseDialog.onExit=onExitcCloseDialog
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cGoToEditor={}
cGoToEditor.onEnter=onEntercGoToEditor
cGoToEditor.onUpdate=onUpdatecGoToEditor
cGoToEditor.onExit=onExitcGoToEditor
cGoToEditorNow={}
cGoToEditorNow.onEnter=onEntercGoToEditorNow
cGoToEditorNow.onUpdate=onUpdatecGoToEditorNow
cGoToEditorNow.onExit=onExitcGoToEditorNow
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Dialog_state._stateCount,Dialog_state.cInit)
stateMachine:register(Dialog_state.cInit,cInit)
stateMachine:register(Dialog_state.cGoToNextTutorial,cGoToNextTutorial)
stateMachine:register(Dialog_state.cGoToTutorialMenu,cGoToTutorialMenu)
stateMachine:register(Dialog_state.cGoToTitle,cGoToTitle)
stateMachine:register(Dialog_state.cCloseDialog,cCloseDialog)
stateMachine:register(Dialog_state.cEnd,cEnd)
stateMachine:register(Dialog_state.cGoToEditor,cGoToEditor)
stateMachine:register(Dialog_state.cGoToEditorNow,cGoToEditorNow)
stateMachine:endRegister()
end

