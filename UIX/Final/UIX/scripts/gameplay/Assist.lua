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
Assist_state= {
cInit=0,
cShowDialog=1,
cUseRescueItem=2,
cDoNotUseRescueItem=3,
cEnd=4,
cEnd2=5,
cNextDialog=6,
_stateCount=7
}
-------------------------------------------------------------
function onEntercInit()
tutorialType = {}
tutorialType.INVALID = -1
tutorialType.MESSAGE_EDIT= 0
tutorialType.MESSAGE_PLAY= 1
tutorialType.MESSAGE_OPTIONS = 2
tutorialType.EDIT = 3
tutorialType.PLAY = 4
tutorialType.WAIT_OVERLAYBUTTON = 5

function showBottomScreen(show)
	local area = ui:getUI("gameArea")
	if area then
		area:setVisible(show)
	end
end
end
function onUpdatecInit()
if ui:isIdle() then
	stateMachine:requestState(Assist_state.cShowDialog)
end
end
function onExitcInit()

end
function onEntercShowDialog()
showBottomScreen(false)
ConversationController:showBubbleNext(nil)

end
function onUpdatecShowDialog()
if ConversationController:isActive() == false then return end
if ConversationController:canReadInput() == false then return end

if ConversationController:getTutorialType() == tutorialType.MESSAGE_EDIT then
	if Input:isTriggered(BUTTON.A) or ConversationController:getAnswer() == 2 then
		stateMachine:requestState(Assist_state.cNextDialog)
	end
end
end
function onExitcShowDialog()

end
function onEntercUseRescueItem()
GlobalData:useRescueItem(true)
stateMachine:requestState(Assist_state.cEnd)
end
function onUpdatecUseRescueItem()

end
function onExitcUseRescueItem()

end
function onEntercDoNotUseRescueItem()
GlobalData:useRescueItem(false)
stateMachine:requestState(Assist_state.cEnd)
end
function onUpdatecDoNotUseRescueItem()

end
function onExitcDoNotUseRescueItem()

end
function onEntercEnd()
gTimer = 30
ConversationController:closeDialog()
end
function onUpdatecEnd()
if gTimer <= 0 then
	stateMachine:requestState(Assist_state.cEnd2)
else
	gTimer = gTimer - 1
end
end
function onExitcEnd()

end
function onEntercEnd2()
if GameState:getState() ~= 23 then -- tutorial play state
	showBottomScreen(true)
	ui:changeScreen("Game", true, false)
end
end
function onUpdatecEnd2()

end
function onExitcEnd2()

end
function onEntercNextDialog()
stateMachine:requestState(Assist_state.cShowDialog)
end
function onUpdatecNextDialog()

end
function onExitcNextDialog()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cShowDialog={}
cShowDialog.onEnter=onEntercShowDialog
cShowDialog.onUpdate=onUpdatecShowDialog
cShowDialog.onExit=onExitcShowDialog
cUseRescueItem={}
cUseRescueItem.onEnter=onEntercUseRescueItem
cUseRescueItem.onUpdate=onUpdatecUseRescueItem
cUseRescueItem.onExit=onExitcUseRescueItem
cDoNotUseRescueItem={}
cDoNotUseRescueItem.onEnter=onEntercDoNotUseRescueItem
cDoNotUseRescueItem.onUpdate=onUpdatecDoNotUseRescueItem
cDoNotUseRescueItem.onExit=onExitcDoNotUseRescueItem
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cEnd2={}
cEnd2.onEnter=onEntercEnd2
cEnd2.onUpdate=onUpdatecEnd2
cEnd2.onExit=onExitcEnd2
cNextDialog={}
cNextDialog.onEnter=onEntercNextDialog
cNextDialog.onUpdate=onUpdatecNextDialog
cNextDialog.onExit=onExitcNextDialog
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Assist_state._stateCount,Assist_state.cInit)
stateMachine:register(Assist_state.cInit,cInit)
stateMachine:register(Assist_state.cShowDialog,cShowDialog)
stateMachine:register(Assist_state.cUseRescueItem,cUseRescueItem)
stateMachine:register(Assist_state.cDoNotUseRescueItem,cDoNotUseRescueItem)
stateMachine:register(Assist_state.cEnd,cEnd)
stateMachine:register(Assist_state.cEnd2,cEnd2)
stateMachine:register(Assist_state.cNextDialog,cNextDialog)
stateMachine:endRegister()
end

