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
CourseBotScreen_state= {
Start=0,
AnimateOut=1,
AnimateOut3=2,
Save=3,
SaveCurrent=4,
Load=5,
GTFO=6,
End=7,
_stateCount=8
}
-------------------------------------------------------------
function onEnterStart()

gCourseBotAnim = nil;

if Editor:isNewCourse() == true then
	Editor:decorateLoadSave();
	if GameState:getFrameCount() ~= 0 then
		ui:getScreen(1):playAnimation("savemenu_2Button_INTRO");
	end
	stateMachine:requestState(CourseBotScreen_state.End);
else
	Editor:decorateLoadSave();
	if GameState:getFrameCount() ~= 0 then
		ui:getScreen(1):playAnimation("savemenu_3Button_INTRO");
	end
	stateMachine:requestState(CourseBotScreen_state.End);
end



end
function onUpdateStart()

end
function onExitStart()

end
function onEnterAnimateOut()
ui:disableInput(0)
gCourseBotAnim = ui:getScreen(1):playAnimation("savemenu_2Button_OUTRO");
end
function onUpdateAnimateOut()

if gCourseBotAnim ~= nil and not gCourseBotAnim:isPlaying() then
	Editor:tellState(16);
	ui:changeScreen("MainGroup", true, false, false);
	gCourseBotAnim = nil;
	ui:enableInput(0)
	stateMachine:requestState(CourseBotScreen_state.End);
end

end
function onExitAnimateOut()

end
function onEnterAnimateOut3()

gCourseBotAnim = ui:getScreen(1):playAnimation("savemenu_3Button_OUTRO");
end
function onUpdateAnimateOut3()

if gCourseBotAnim ~= nil and not gCourseBotAnim:isPlaying() then
	Editor:tellState(16);
	ui:changeScreen("MainGroup", true, false, false);
	gCourseBotAnim = nil;
	stateMachine:requestState(CourseBotScreen_state.End);
end

end
function onExitAnimateOut3()

end
function onEnterSave()

-- Stopping of music and switching scene need to wait for thumbnail generation to finish
-- GlobalData:setCourseBotEntryType(1);
-- GlobalData:setGameplayType(7); 
-- Sound:stopMusic();
-- GameState:switchScene("CourseBot");
Editor:requestNewSave();
stateMachine:requestState(CourseBotScreen_state.End)
end
function onUpdateSave()

end
function onExitSave()

end
function onEnterSaveCurrent()

--GlobalData:setCourseBotEntryType(1);
--GlobalData:setGameplayType(7); 
Editor:saveCurrent();
stateMachine:requestState(CourseBotScreen_state.End);
end
function onUpdateSaveCurrent()

end
function onExitSaveCurrent()

end
function onEnterLoad()

GlobalData:setCourseBotEntryType(2);
GlobalData:setGameplayType(7); 
Sound:stopMusic();
GameState:switchScene("CourseBot");
stateMachine:requestState(CourseBotScreen_state.End);
end
function onUpdateLoad()

end
function onExitLoad()

end
function onEnterGTFO()
if Editor:isNewCourse() == true then
	stateMachine:requestState(CourseBotScreen_state.AnimateOut);
else
	stateMachine:requestState(CourseBotScreen_state.AnimateOut3);
end
end
function onUpdateGTFO()

end
function onExitGTFO()

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
AnimateOut={}
AnimateOut.onEnter=onEnterAnimateOut
AnimateOut.onUpdate=onUpdateAnimateOut
AnimateOut.onExit=onExitAnimateOut
AnimateOut3={}
AnimateOut3.onEnter=onEnterAnimateOut3
AnimateOut3.onUpdate=onUpdateAnimateOut3
AnimateOut3.onExit=onExitAnimateOut3
Save={}
Save.onEnter=onEnterSave
Save.onUpdate=onUpdateSave
Save.onExit=onExitSave
SaveCurrent={}
SaveCurrent.onEnter=onEnterSaveCurrent
SaveCurrent.onUpdate=onUpdateSaveCurrent
SaveCurrent.onExit=onExitSaveCurrent
Load={}
Load.onEnter=onEnterLoad
Load.onUpdate=onUpdateLoad
Load.onExit=onExitLoad
GTFO={}
GTFO.onEnter=onEnterGTFO
GTFO.onUpdate=onUpdateGTFO
GTFO.onExit=onExitGTFO
End={}
End.onEnter=onEnterEnd
End.onUpdate=onUpdateEnd
End.onExit=onExitEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (CourseBotScreen_state._stateCount,CourseBotScreen_state.Start)
stateMachine:register(CourseBotScreen_state.Start,Start)
stateMachine:register(CourseBotScreen_state.AnimateOut,AnimateOut)
stateMachine:register(CourseBotScreen_state.AnimateOut3,AnimateOut3)
stateMachine:register(CourseBotScreen_state.Save,Save)
stateMachine:register(CourseBotScreen_state.SaveCurrent,SaveCurrent)
stateMachine:register(CourseBotScreen_state.Load,Load)
stateMachine:register(CourseBotScreen_state.GTFO,GTFO)
stateMachine:register(CourseBotScreen_state.End,End)
stateMachine:endRegister()
end

