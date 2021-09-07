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
HundredMarioEasy_state= {
cInit=0,
cGlobals=1,
TestMapIn=2,
cEnd=3,
cDialog=4,
cMoveKuribo=5,
_stateCount=6
}
-------------------------------------------------------------
function onEntercInit()
-- Init Info---------------------------------------------------------------------

end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercGlobals()
-- globals ---------------------------------------------------------------------

animDone = false
diagDone = false
end
function onUpdatecGlobals()

end
function onExitcGlobals()

end
function onEnterTestMapIn()
topScreen = ui:getScreen(SCREEN.TOP)
botScreen = ui:getScreen(SCREEN.BOTTOM)

anim = topScreen:playAnimation("MapIn")
ui:changeScreen("Fader", false, false, false)

end
function onUpdateTestMapIn()
if animDone == true then
	stateMachine:requestState(HundredMarioEasy_state.cDialog)
end

if anim ~= nil and anim:isPlaying() == false then
	anim = topScreen:playAnimation("Anm_Koopa_00")
	animDone = true
end
	
end
function onExitTestMapIn()
animDone = false
end
function onEntercEnd()
--disable the start button after intro anim for M3
ui:getButton("L_StartBtn_00"):forceDisable()
end
function onUpdatecEnd()

end
function onExitcEnd()

end
function onEntercDialog()
topScreen = ui:getScreen(SCREEN.TOP)
ui:changeScreen("Dialog", false, false)
end
function onUpdatecDialog()
if ui:isFocused() then
	stateMachine:requestState(HundredMarioEasy_state.cMoveKuribo)
	ui:changeScreen("Fader", false, false, false)
end
end
function onExitcDialog()

end
function onEntercMoveKuribo()
topScreen = ui:getScreen(SCREEN.TOP)
anim = topScreen:playAnimation("MoveKuribo")
end
function onUpdatecMoveKuribo()
if anim ~= nil and anim:isPlaying() == false then
	ui:changeScreen("HundredMario", true, true, false)
	stateMachine:requestState(HundredMarioEasy_state.cEnd)
end
end
function onExitcMoveKuribo()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cGlobals={}
cGlobals.onEnter=onEntercGlobals
cGlobals.onUpdate=onUpdatecGlobals
cGlobals.onExit=onExitcGlobals
TestMapIn={}
TestMapIn.onEnter=onEnterTestMapIn
TestMapIn.onUpdate=onUpdateTestMapIn
TestMapIn.onExit=onExitTestMapIn
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
cDialog={}
cDialog.onEnter=onEntercDialog
cDialog.onUpdate=onUpdatecDialog
cDialog.onExit=onExitcDialog
cMoveKuribo={}
cMoveKuribo.onEnter=onEntercMoveKuribo
cMoveKuribo.onUpdate=onUpdatecMoveKuribo
cMoveKuribo.onExit=onExitcMoveKuribo
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (HundredMarioEasy_state._stateCount,HundredMarioEasy_state.cInit)
stateMachine:register(HundredMarioEasy_state.cInit,cInit)
stateMachine:register(HundredMarioEasy_state.cGlobals,cGlobals)
stateMachine:register(HundredMarioEasy_state.TestMapIn,TestMapIn)
stateMachine:register(HundredMarioEasy_state.cEnd,cEnd)
stateMachine:register(HundredMarioEasy_state.cDialog,cDialog)
stateMachine:register(HundredMarioEasy_state.cMoveKuribo,cMoveKuribo)
stateMachine:endRegister()
end

