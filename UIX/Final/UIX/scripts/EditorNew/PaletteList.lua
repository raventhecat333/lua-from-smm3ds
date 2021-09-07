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
PaletteList_state= {
Start=0,
Exit=1,
ForceExit=2,
End=3,
_stateCount=4
}
-------------------------------------------------------------
function onEnterStart()

gPaletteOutroAnim = nil;
gWaitingForMarchingToStop = false;
gStillWaiting = false;
end
function onUpdateStart()

end
function onExitStart()

end
function onEnterExit()
NN_LOG("TRY EXIT");
if Editor:isEditingPalette() == false then
	NN_LOG("NOT EDITING");
	gPaletteOutroAnim = ui:getScreen(1):playAnimation("OUTRO");
	Editor:handlePaletteCloseStart();
	Sound:playSound("palette_list_close");
	Sound:disableDialogDuckMusic();
else
	stateMachine:requestState(PaletteList_state.End);
end



end
function onUpdateExit()

if gPaletteOutroAnim ~= nil and not gPaletteOutroAnim:isPlaying() then
	Editor:tellState(8);
	glPaletteOutroAnim = nil;
	NN_LOG("CHANGE SCREEN MAINGROUP");
	ui:changeScreen("MainGroup", true, false, false);
	stateMachine:requestState(PaletteList_state.End);
end

end
function onExitExit()

end
function onEnterForceExit()
if Editor:isEditingPalette() == true then
	gWaitingForMarchingToStop = true;
	gPaletteOutroAnim  = nil;
	Editor:stopTheMarching();	
else
	gPaletteOutroAnim = ui:getScreen(1):playAnimation("OUTRO");
	Editor:handlePaletteCloseStart();
	Sound:playSound("palette_list_close");
	Sound:disableDialogDuckMusic();
end


end
function onUpdateForceExit()

if gPaletteOutroAnim ~= nil and not gPaletteOutroAnim:isPlaying() then
	Editor:tellState(8);
	glPaletteOutroAnim = nil;
	ui:changeScreen("MainGroup", true, false, false);
	stateMachine:requestState(PaletteList_state.End);
end

if gWaitingForMarchingToStop == true then
	gStillWaiting = Editor:isEditingPalette();
	if gStillWaiting == false then
		gWaitingForMarchingToStop = false;
		gPaletteOutroAnim = ui:getScreen(1):playAnimation("OUTRO");
		Editor:handlePaletteCloseStart();
		Sound:playSound("palette_list_close");
		Sound:disableDialogDuckMusic();
	end
end

end
function onExitForceExit()

end
function onEnterEnd()

end
function onUpdateEnd()

end
function onExitEnd()

end
-------------------------------------------------------------
Start={}
Start.onEnter=onEnterStart
Start.onUpdate=onUpdateStart
Start.onExit=onExitStart
Exit={}
Exit.onEnter=onEnterExit
Exit.onUpdate=onUpdateExit
Exit.onExit=onExitExit
ForceExit={}
ForceExit.onEnter=onEnterForceExit
ForceExit.onUpdate=onUpdateForceExit
ForceExit.onExit=onExitForceExit
End={}
End.onEnter=onEnterEnd
End.onUpdate=onUpdateEnd
End.onExit=onExitEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (PaletteList_state._stateCount,PaletteList_state.Start)
stateMachine:register(PaletteList_state.Start,Start)
stateMachine:register(PaletteList_state.Exit,Exit)
stateMachine:register(PaletteList_state.ForceExit,ForceExit)
stateMachine:register(PaletteList_state.End,End)
stateMachine:endRegister()
end

