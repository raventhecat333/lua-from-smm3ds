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
TimerScroll_state= {
Enter=0,
OK=1,
Exit=2,
_stateCount=3
}
-------------------------------------------------------------
function onEnterEnter()

end
function onUpdateEnter()

end
function onExitEnter()

end
function onEnterOK()
gOutroAnim = ui:getScreen(1):playAnimation("OUTRO");
Sound:disableDialogDuckMusic();
end
function onUpdateOK()
if gOutroAnim ~= nil and not gOutroAnim:isPlaying() then
	Editor:tellState(512);
	ui:changeScreen("Main", true, false, false);
	stateMachine:requestState(End);
end
end
function onExitOK()

end
function onEnterExit()

end
function onUpdateExit()

end
function onExitExit()

end
-------------------------------------------------------------
Enter={}
Enter.onEnter=onEnterEnter
Enter.onUpdate=onUpdateEnter
Enter.onExit=onExitEnter
OK={}
OK.onEnter=onEnterOK
OK.onUpdate=onUpdateOK
OK.onExit=onExitOK
Exit={}
Exit.onEnter=onEnterExit
Exit.onUpdate=onUpdateExit
Exit.onExit=onExitExit
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (TimerScroll_state._stateCount,TimerScroll_state.Enter)
stateMachine:register(TimerScroll_state.Enter,Enter)
stateMachine:register(TimerScroll_state.OK,OK)
stateMachine:register(TimerScroll_state.Exit,Exit)
stateMachine:endRegister()
end

