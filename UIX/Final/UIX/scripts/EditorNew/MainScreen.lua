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
MainScreen_state= {
Init=0,
ToggleSkin=1,
ToggleCourseType=2,
ToggleSFX=3,
TogglePlay=4,
End=5,
_stateCount=6
}
-------------------------------------------------------------
function onEnterInit()
gShowSkins = false;
gShowCourseTypes = false;
gShowSFX = false;
gPlay = false;
end
function onUpdateInit()

end
function onExitInit()

end
function onEnterToggleSkin()
if gShowSkins == false then
	ui:getScreen(1):playAnimation("menu_skin_SHOW");
	gShowSkins = true;
else
	ui:getScreen(1):playAnimation("menu_skin_HIDE");
	gShowSkins = false;
end
stateMachine:requestState(MainScreen_state.End);
end
function onUpdateToggleSkin()

end
function onExitToggleSkin()

end
function onEnterToggleCourseType()
if gShowCourseTypes== false then
	ui:getScreen(1):playAnimation("menu_coursetype_SHOW");
	gShowCourseTypes = true;
else
	ui:getScreen(1):playAnimation("menu_coursetype_HIDE");
	gShowCourseTypes = false;
end
stateMachine:requestState(MainScreen_state.End);

end
function onUpdateToggleCourseType()

end
function onExitToggleCourseType()

end
function onEnterToggleSFX()
if gShowSFX== false then
	ui:getScreen(1):playAnimation("mode_SFX_INTRO");
	gShowSFX= true;
else
	ui:getScreen(1):playAnimation("mode_SFX_OUTRO");
	gShowSFX= false;
end
stateMachine:requestState(MainScreen_state.End);
end
function onUpdateToggleSFX()

end
function onExitToggleSFX()

end
function onEnterTogglePlay()
if gPlay == false then
	ui:getScreen(1):playAnimation("transition_PLAY");
	gPlay= true;
else
	ui:getScreen(1):playAnimation("transition_EDIT");
	gPlay= false;
end
stateMachine:requestState(MainScreen_state.End);
end
function onUpdateTogglePlay()

end
function onExitTogglePlay()

end
function onEnterEnd()

end
function onUpdateEnd()

end
function onExitEnd()

end
-------------------------------------------------------------
Init={}
Init.onEnter=onEnterInit
Init.onUpdate=onUpdateInit
Init.onExit=onExitInit
ToggleSkin={}
ToggleSkin.onEnter=onEnterToggleSkin
ToggleSkin.onUpdate=onUpdateToggleSkin
ToggleSkin.onExit=onExitToggleSkin
ToggleCourseType={}
ToggleCourseType.onEnter=onEnterToggleCourseType
ToggleCourseType.onUpdate=onUpdateToggleCourseType
ToggleCourseType.onExit=onExitToggleCourseType
ToggleSFX={}
ToggleSFX.onEnter=onEnterToggleSFX
ToggleSFX.onUpdate=onUpdateToggleSFX
ToggleSFX.onExit=onExitToggleSFX
TogglePlay={}
TogglePlay.onEnter=onEnterTogglePlay
TogglePlay.onUpdate=onUpdateTogglePlay
TogglePlay.onExit=onExitTogglePlay
End={}
End.onEnter=onEnterEnd
End.onUpdate=onUpdateEnd
End.onExit=onExitEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (MainScreen_state._stateCount,MainScreen_state.Init)
stateMachine:register(MainScreen_state.Init,Init)
stateMachine:register(MainScreen_state.ToggleSkin,ToggleSkin)
stateMachine:register(MainScreen_state.ToggleCourseType,ToggleCourseType)
stateMachine:register(MainScreen_state.ToggleSFX,ToggleSFX)
stateMachine:register(MainScreen_state.TogglePlay,TogglePlay)
stateMachine:register(MainScreen_state.End,End)
stateMachine:endRegister()
end

