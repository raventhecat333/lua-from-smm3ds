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
Editor_state= {
Init=0,
ToggleMultiGrabMode=1,
ToggleCopyMode=2,
ModeNone=3,
PlacePipe=4,
PipePlaced=5,
ToggleEraseMode=6,
ToggleSkin=7,
ToggleCourseType=8,
ToggleSFX=9,
TogglePlay=10,
ToggleLeftPannel=11,
ToggleRightPannel=12,
ToMainMenu=13,
ToPaletteList=14,
ToCourseBot=15,
ToTimerScroll=16,
UseSkinM1=17,
UseSkinM3=18,
UseSkinMW=19,
UseSkinMU=20,
GroundCourseType=21,
UndergroundCrourseType=22,
UnderwaterCourseType=23,
GhostHouseCourseType=24,
AirshipCourseType=25,
CastleCourseType=26,
ToggleMarioPlot=27,
ToggleArea=28,
TapOut=29,
End=30,
Restore=31,
_stateCount=32
}
-------------------------------------------------------------
function onEnterInit()
gShowSkins = false;
gShowSkinsAnim = nil;
gHideSkinsAnim = nil;
gShowCourseTypes = false;
gShowCourseTypesAnim = nil;
gHideCourseTypesAnim = nil;
gShowSFX = false;
gPlay = false;
PANNEL_LEFT= 0;
PANNEL_RIGHT= 1;
PANNEL_CLOSING = 0;
PANNEL_OPENING = 1;
gLeftPannelState = 1;
gRightPannelState = 1;
gPannelLeftAnim = nil;
gPannelRightAnim = nil;
gInEraseMode = false;
gInMGrabMode = false;
gInCopyMode = false;
LETTER_A = 1;
LETTER_B = 2;
LETTER_C = 3;
LETTER_D = 4;
MODE_NONE = 0;
MODE_ERASE_A = 1;
MODE_ERASE_B = 2;
MODE_ERASE_C = 3;
MODE_ERASE_D = 4;
MODE_MGRAB_A = 6;
MODE_MGRAB_B = 7;
MODE_MGRAB_C = 8;
MODE_MGRAB_D = 9;
MODE_COPY_A = 11;
MODE_COPY_B = 12;
MODE_COPY_C = 13;
MODE_COPY_D = 14;
MODE_COUNT = 5;
gMode = MODE_NONE;
STATE_MAIN_MENU = 1;
STATE_SKIN_SELECT = 2;
STATE_COURSE_TYPE_SELECT = 4;
STATE_PALETTE_SELECT = 8;
STATE_COURSE_BOT = 16;
STATE_SFX_FROG = 32;
STATE_MARIO_PLOT = 64;
STATE_NO_INPUT= 128;
STATE_AREA = 256;
STATE_TIMER_SCROLL = 512;
SKIN_M1 = 0;
SKIN_M3 = 1;
SKIN_MW = 2;
SKIN_MU = 3;
COURSETYPE_GROUND = 0;
COURSETYPE_UNDERGROUND = 1;
COURSETYPE_CASTLE = 2;
COURSETYPE_AIRSHIP = 3;
COURSETYPE_UNDERWATER = 4;
COURSETYPE_GHOSTHOUSE = 5;
gOverlayInAnim = nil;
gOverlayOutAnim = nil;
gMarioPlotOn = false;
PALETTE_NONE = 0;
PALETTE_EDIT = 1;
PALETTE_SFX = 2;
gPaletteState = PALETTE_EDIT;
gPlacePipeIdleAnim = nil;
-- need to initialize stage types later on ( it's too early in the flow right now )
gSkinType = -1;
gCourseType =-1;
gSkipListCloseSound = false;

function printState() 
	--NN_LOG(string.format("gMode:%d gInEraseMode:%d gInMGrabMode:%d gInCopyMode:%d", gMode, gInEraseMode, gInMGrabMode, gInCopyMode));
	NN_LOG("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!WASDFASDFASDFAS");
end

function isABCorD(mode)
    local letter = mode % MODE_COUNT;
    if letter == LETTER_A then
        return "A";
    elseif letter == LETTER_B then
        return "B";
    elseif letter == LETTER_C then
        return "C";
    elseif letter == LETTER_D then
        return "D";
    else
        return "";
    end
end

function isEMorC(mode) 
	if inEraseMode(mode) then
		return "erase";
	elseif inMGrabMode(mode) then
		return "grab";
	elseif inCopyMode(mode) then
		return "copy";
	else
		return "";
	end
end

function isAorB(panelState) 
	if panelState == PANNEL_OPENING then
		return "A"
	elseif panelState == PANNEL_CLOSING then
		return "B"
	else
		return ""
	end
end

function isOutOrIn(panelState) 
	if panelState == PANNEL_OPENING then
		return "INTRO"
	elseif panelState == PANNEL_CLOSING then
		return "OUTRO"
	else
		return ""
	end
end

function playCorrectSlideAnimRight(leftPanelState, rightPanelState, mode)
	NN_LOG("mode_" .. isEMorC(mode) .. "_RIGHT_SIDEBAR_" .. isAorB(leftPanelState) .. "_" .. isOutOrIn(rightPanelState));
	ui:getScreen(1):playAnimation("mode_" .. isEMorC(mode) .. "_RIGHT_SIDEBAR_" .. isAorB(leftPanelState) .. "_" .. isOutOrIn(rightPanelState));
end

function playCorrectSlideAnimLeft(leftPanelState, rightPanelState, mode)
	NN_LOG("mode_" .. isEMorC(mode) .. "_LEFT_SIDEBAR_" .. isAorB(rightPanelState) .. "_" .. isOutOrIn(leftPanelState));
	ui:getScreen(1):playAnimation("mode_" .. isEMorC(mode) .. "_LEFT_SIDEBAR_" .. isAorB(rightPanelState) .. "_" .. isOutOrIn(leftPanelState));
end

function switchPaletteStateTo(newState) 
	if newState == gPaletteState then 
		return; 
	end
	if gPaletteState == PALETTE_EDIT then
		if not gInEraseMode == true then
			NN_LOG("mode_item_palette_OUTRO");
			ui:getScreen(1):playAnimation("mode_item_palette_OUTRO");
		end
	elseif gPaletteState == PALETTE_SFX then
		NN_LOG("mode_SFX_OUTRO");
		ui:getScreen(1):playAnimation("mode_SFX_OUTRO");
		if not gInEraseMode == true then
			NN_LOG("mode_SFX_palette_OUTRO");
			ui:getScreen(1):playAnimation("mode_SFX_palette_OUTRO");
		end
	end
	if newState == PALETTE_EDIT then
		if not gInEraseMode == true then
			NN_LOG("mode_item_palette_SFX_INTRO");
			ui:getScreen(1):playAnimation("mode_item_palette_SFX_INTRO");
		end
	elseif newState == PALETTE_SFX then
		NN_LOG("mode_SFX_INTRO");
		ui:getScreen(1):playAnimation("mode_SFX_INTRO");
		if not gInEraseMode == true then
			NN_LOG("mode_SFX_palette_INTRO");
			ui:getScreen(1):playAnimation("mode_SFX_palette_INTRO");
		end
	end
	gPaletteState = newState;
end	

function inEraseMode(mode)
    return mode >= MODE_ERASE_A and mode <= MODE_ERASE_D;
end

function inMGrabMode(mode)
    return mode >= MODE_MGRAB_A and mode <= MODE_MGRAB_D;
end

function inCopyMode(mode)
    return mode >= MODE_COPY_A and mode <= MODE_COPY_D;
end

function playCorrectModeAnimOut()
    local anim = nil;
    if gMode ~= MODE_NONE then
	NN_LOG("mode_" .. isEMorC(gMode) .. "_" .. isABCorD(gMode) .. "_OUTRO");
	anim = ui:getScreen(1):playAnimation("mode_" .. isEMorC(gMode) .. "_" .. isABCorD(gMode) .. "_OUTRO");
	gMode = MODE_NONE;
    end
    return anim;
end

function whatModeShouldWeBeIn()
    if gInEraseMode == true then
        if gLeftPannelState == 1 and gRightPannelState == 1 then
	NN_LOG("MODE_ERASE_A");
            return MODE_ERASE_A;
        elseif gLeftPannelState == 0 and gRightPannelState == 0 then
	NN_LOG("MODE_ERASE_B");
            return MODE_ERASE_B;
        elseif gLeftPannelState == 0 and gRightPannelState == 1 then
	NN_LOG("MODE_ERASE_C");
            return MODE_ERASE_C;
        elseif gLeftPannelState == 1 and gRightPannelState == 0 then
	NN_LOG("MODE_ERASE_D");
            return MODE_ERASE_D;
        else
	NN_LOG("MODE_NONE");
            return MODE_NONE;
        end
     elseif gInMGrabMode == true then
        if gLeftPannelState == 1 and gRightPannelState == 1 then
	NN_LOG("MODE_MGRAB_A");
            return MODE_MGRAB_A;
        elseif gLeftPannelState == 0 and gRightPannelState == 0 then
	NN_LOG("MODE_MGRAB_B");
            return MODE_MGRAB_B;
        elseif gLeftPannelState == 0 and gRightPannelState == 1 then
	NN_LOG("MODE_MGRAB_C");
            return MODE_MGRAB_C;
        elseif gLeftPannelState == 1 and gRightPannelState == 0 then
	NN_LOG("MODE_MGRAB_D");
            return MODE_MGRAB_D;
        else
	NN_LOG("MODE_NONE");
            return MODE_NONE;
        end
     elseif gInCopyMode == true then
        if gLeftPannelState == 1 and gRightPannelState == 1 then
	NN_LOG("MODE_COPY_A");
            return MODE_COPY_A;
        elseif gLeftPannelState == 0 and gRightPannelState == 0 then
	NN_LOG("MODE_COPY_B");
            return MODE_COPY_B;
        elseif gLeftPannelState == 0 and gRightPannelState == 1 then
	NN_LOG("MODE_COPY_C");
            return MODE_COPY_C;
        elseif gLeftPannelState == 1 and gRightPannelState == 0 then
	NN_LOG("MODE_COPY_C");
            return MODE_COPY_D;
        else
            return MODE_NONE;
        end
    else
        return MODE_NONE;
    end
end

function playCorrectModeAnimIn()
	local properMode = whatModeShouldWeBeIn();
	local anim = nil;
	if gInEraseMode == true and not inEraseMode(gMode) then
		NN_LOG("mode_erase_" .. isABCorD(properMode) .. "_INTRO");
		anim = ui:getScreen(1):playAnimation("mode_erase_" .. isABCorD(properMode) .. "_INTRO");
	elseif gInMGrabMode == true and not inMGrabMode(gMode) then
		NN_LOG("mode_grab_" .. isABCorD(properMode) .. "_INTRO");
		anim = ui:getScreen(1):playAnimation("mode_grab_" .. isABCorD(properMode) .. "_INTRO");
	elseif gInCopyMode == true and not inCopyMode(gMode) then
		NN_LOG("mode_copy_" .. isABCorD(properMode) .. "_INTRO");
		anim = ui:getScreen(1):playAnimation("mode_copy_" .. isABCorD(properMode) .. "_INTRO");
    	end
	gMode = properMode;
	return anim;
end

end
function onUpdateInit()

end
function onExitInit()

end
function onEnterToggleMultiGrabMode()
NN_LOG("ToggleMultiGrabMode start");
if gInMGrabMode == false then
	gInEraseMode = false;
	gInCopyMode = false;
	gInMGrabMode = true;
	Editor:focusButtonGroup("grab_copy_mode");
	NN_LOG("FOCUS ON");
	playCorrectModeAnimIn();
else
	gInMGrabMode = false;
	Editor:focusClear();
	NN_LOG("FOCUS OFF");
	playCorrectModeAnimOut();
end
NN_LOG("ToggleMultiGrabMode end");
stateMachine:requestState(Editor_state.End);
end
function onUpdateToggleMultiGrabMode()

end
function onExitToggleMultiGrabMode()

end
function onEnterToggleCopyMode()
NN_LOG("ToggleCopyMode start");
if gInCopyMode == false then
	gInEraseMode = false;
	gInMGrabMode = false;
	gInCopyMode = true;
	Editor:focusButtonGroup("grab_copy_mode");
	NN_LOG("FOCUS ON");
	playCorrectModeAnimIn();
else
	gInCopyMode = false;
	Editor:focusClear();
	NN_LOG("FOCUS OFF");
	playCorrectModeAnimOut();
end
NN_LOG("ToggleCopyMode end");
stateMachine:requestState(Editor_state.End);
end
function onUpdateToggleCopyMode()

end
function onExitToggleCopyMode()

end
function onEnterModeNone()
NN_LOG("MODE NONE")
gInEraseMode = false;
gInMGrabMode = false;
gInCopyMode = false;
playCorrectModeAnimOut();
Editor:focusClear();
stateMachine:requestState(Editor_state.End);
end
function onUpdateModeNone()

end
function onExitModeNone()

end
function onEnterPlacePipe()
NN_LOG("subArea_INTRO")
gPlacePipeAnim = ui:getScreen(1):playAnimation("subArea_INTRO");
if gShowSFX == true then
	ui:getScreen(1):playAnimation("subArea_INTRO_SFX");
else
	ui:getScreen(1):playAnimation("subArea_INTRO_ITEM");
end

end
function onUpdatePlacePipe()

if gPlacePipeAnim ~= nil and not gPlacePipeAnim:isPlaying() then
	gPlacePipeAnim = nil;
	NN_LOG("subArea_IDLE")
	gPlacePipeIdleAnim = ui:getScreen(1):playAnimation("subArea_IDLE");
	stateMachine:requestState(Editor_state.End);
end
end
function onExitPlacePipe()

end
function onEnterPipePlaced()
if gPlacePipeIdleAnim ~= nil and gPlacePipeIdleAnim:isPlaying() then
	gPlacePipeIdleAnim:stop();
	gPlacePipeIdleAnim = nil;
end
NN_LOG("subArea_OUTRO")
ui:getScreen(1):playAnimation("subArea_OUTRO");
if gShowSFX == true then
	ui:getScreen(1):playAnimation("subArea_OUTRO_SFX");
else
	ui:getScreen(1):playAnimation("subArea_OUTRO_ITEM");
end

end
function onUpdatePipePlaced()

end
function onExitPipePlaced()

end
function onEnterToggleEraseMode()
if gInEraseMode == false then
	gInMGrabMode = false;
	gInCopyMode = false;
	gInEraseMode = true;
	if gPaletteState == PALETTE_EDIT then
		NN_LOG("mode_item_palette_OUTRO");
		ui:getScreen(1):playAnimation("mode_item_palette_OUTRO");
	elseif gPaletteState == PALETTE_SFX then
		NN_LOG("mode_SFX_palette_OUTRO");
		ui:getScreen(1):playAnimation("mode_SFX_palette_OUTRO");
	end
	playCorrectModeAnimIn();
else
	gInEraseMode = false;
	if gPaletteState == PALETTE_EDIT then
		NN_LOG("playing mode_item_palette_INTRO");
		ui:getScreen(1):playAnimation("mode_item_palette_INTRO");
	elseif gPaletteState == PALETTE_SFX then
		NN_LOG("playing mode_SFX_palette_INTRO");
		ui:getScreen(1):playAnimation("mode_SFX_palette_INTRO");
	end
	playCorrectModeAnimOut();
end
Editor:lockInput();
stateMachine:requestState(Editor_state.End);
end
function onUpdateToggleEraseMode()

end
function onExitToggleEraseMode()
Editor:unlockInput();
end
function onEnterToggleSkin()
if gShowSkins == false then
	NN_LOG("menu_skin_SHOW");
	Editor:focusButtonGroup("FocusGroupSkin");
	gShowSkinsAnim = ui:getScreen(1):playAnimation("menu_skin_SHOW");
	gShowSkins = true;
	Sound:playSound("skin_list_open");
	gSkinType = GlobalData:getSkinType();
	Editor:cancelSceneSkinName();
else
	NN_LOG("menu_skin_HIDE");
	Editor:focusClear();
	gHideSkinsAnim = ui:getScreen(1):playAnimation("menu_skin_HIDE");
	Editor:tellState(STATE_SKIN_SELECT);
	gShowSkins = false;
	if gSkipListCloseSound then
		gSkipListCloseSound = false;
	else
		Sound:playSound("list_closes");
	end
end

Editor:lockInput();
--Editor:lockInputUIFriendly()
end
function onUpdateToggleSkin()

if gShowSkinsAnim ~= nil and not gShowSkinsAnim:isPlaying() then
	gShowSkinsAnim = nil;
	Editor:tellState(STATE_SKIN_SELECT);
	stateMachine:requestState(Editor_state.End);
end

if gHideSkinsAnim ~= nil and not gHideSkinsAnim:isPlaying() then
	gHideSkinsAnim = nil;
	Editor:nextSkinIndex();
	stateMachine:requestState(Editor_state.End);	
end
end
function onExitToggleSkin()
Editor:unlockInput()
--Editor:unlockInputUIFriendly()
end
function onEnterToggleCourseType()
if gShowCourseTypes== false then
	NN_LOG("menu_coursetype_SHOW");
	Editor:focusButtonGroup("FocusGroupCourseType");
	gShowCourseTypesAnim = ui:getScreen(1):playAnimation("menu_coursetype_SHOW");
	gShowCourseTypes = true;
	Sound:playSound("scene_list_open");
	gCourseType = GlobalData:getCourseType();
	Editor:cancelSceneSkinName();
else
	Editor:focusClear();
	Editor:tellState(STATE_COURSE_TYPE_SELECT);
	NN_LOG("menu_coursetype_HIDE");
	gHideCourseTypesAnim = ui:getScreen(1):playAnimation("menu_coursetype_HIDE");
	gShowCourseTypes = false;
	if gSkipListCloseSound then
		gSkipListCloseSound = false;
	else
		Sound:playSound("list_closes");
	end
end

Editor:lockInput();
--Editor:lockInputUIFriendly()
end
function onUpdateToggleCourseType()

if gShowCourseTypesAnim ~= nil and not gShowCourseTypesAnim:isPlaying() then
	NN_LOG("DONE SHOWING COURSE TYPE");
	gShowCourseTypesAnim = nil;
	Editor:tellState(STATE_COURSE_TYPE_SELECT);
	stateMachine:requestState(Editor_state.End);
end

if gHideCourseTypesAnim ~= nil and not gHideCourseTypesAnim:isPlaying() then
	gHideCourseTypesAnim = nil;
	Editor:nextSceneIndex();
	stateMachine:requestState(Editor_state.End);	
end
end
function onExitToggleCourseType()
Editor:unlockInput();
--Editor:unlockInputUIFriendly()
end
function onEnterToggleSFX()

if gShowSFX== false then
	Editor:tellState(STATE_SFX_FROG);
	gShowSFX= true;
	Sound:playSound("editor_icons_drop");
	switchPaletteStateTo(PALETTE_SFX);
else
	Editor:tellState(STATE_SFX_FROG);
	gShowSFX= false;
	Sound:playSound("palette_icons_drop");
	switchPaletteStateTo(PALETTE_EDIT);
end
Editor:lockInput();
stateMachine:requestState(Editor_state.End);
end
function onUpdateToggleSFX()

end
function onExitToggleSFX()
Editor:unlockInput();
end
function onEnterTogglePlay()
if gPlay == false then
	NN_LOG("transition_PLAY");
	ui:getScreen(1):playAnimation("transition_PLAY");
	gPlay= true;
else
	NN_LOG("transition_EDIT");
	ui:getScreen(1):playAnimation("transition_EDIT");
	gPlay= false;
end
stateMachine:requestState(Editor_state.End);
end
function onUpdateTogglePlay()

end
function onExitTogglePlay()

end
function onEnterToggleLeftPannel()
NN_LOG("LEFT PANNEL TOGGLE")
Editor:lockInput();
if gLeftPannelState == 1 then
	NN_LOG("sidebar_LEFT_OUT");
	gPannelLeftAnim = ui:getScreen(1):playAnimation("sidebar_LEFT_OUT");
	gLeftPannelState = PANNEL_CLOSING;
	playCorrectSlideAnimLeft(gLeftPannelState, gRightPannelState, gMode);
else
	NN_LOG("sidebar_LEFT_IN");
	gPannelLeftAnim = ui:getScreen(1):playAnimation("sidebar_LEFT_IN");
	gLeftPannelState = PANNEL_OPENING;
	playCorrectSlideAnimLeft(gLeftPannelState, gRightPannelState, gMode);
end
Editor:sideBarSwitchStart(PANNEL_LEFT, gLeftPannelState);

end
function onUpdateToggleLeftPannel()

if gPannelLeftAnim ~= nil and not gPannelLeftAnim:isPlaying() then
	gPannelLeftAnim = nil;
	Editor:sideBarSwitchEnd(PANNEL_LEFT);
	gMode = whatModeShouldWeBeIn();
	stateMachine:requestState(Editor_state.End);
end
end
function onExitToggleLeftPannel()
Editor:unlockInput();
end
function onEnterToggleRightPannel()
NN_LOG("RIGHT PANNEL TOGGLE")
Editor:lockInput();	
if gRightPannelState == 1 then
	NN_LOG("sidebar_RIGHT_OUT");
	gPannelRightAnim = ui:getScreen(1):playAnimation("sidebar_RIGHT_OUT");
	gRightPannelState = PANNEL_CLOSING;
	playCorrectSlideAnimRight(gLeftPannelState, gRightPannelState, gMode);
else
	NN_LOG("sidebar_RIGHT_IN");
	gPannelRightAnim = ui:getScreen(1):playAnimation("sidebar_RIGHT_IN");
	gRightPannelState = PANNEL_OPENING;
	playCorrectSlideAnimRight(gLeftPannelState, gRightPannelState, gMode);
end
Editor:sideBarSwitchStart(PANNEL_RIGHT, gRightPannelState);
end
function onUpdateToggleRightPannel()

if gPannelRightAnim ~= nil and not gPannelRightAnim:isPlaying() then
	gPannelRightAnim = nil;
	Editor:sideBarSwitchEnd(PANNEL_RIGHT);
	gMode = whatModeShouldWeBeIn();
	stateMachine:requestState(Editor_state.End);
end
end
function onExitToggleRightPannel()
Editor:unlockInput();
end
function onEnterToMainMenu()

Editor:tellState(STATE_MAIN_MENU);
ui:changeScreen("MainMenu", false, false, false);
stateMachine:requestState(Editor_state.End);

end
function onUpdateToMainMenu()

end
function onExitToMainMenu()

end
function onEnterToPaletteList()

Editor:tellState(STATE_PALETTE_SELECT);
Editor:handlePaletteOpenStart();
Sound:playSound("palette_list_open");
Sound:enableDialogDuckMusic();
ui:changeScreen("PaletteListGroup", false, false, false);
stateMachine:requestState(Editor_state.End);

end
function onUpdateToPaletteList()

end
function onExitToPaletteList()

end
function onEnterToCourseBot()

Editor:tellState(STATE_COURSE_BOT);
ui:changeScreen("CourseBotGroup", false, false, false);
Editor:lockInput();
stateMachine:requestState(Editor_state.End);

end
function onUpdateToCourseBot()

end
function onExitToCourseBot()
Editor:unlockInput();
end
function onEnterToTimerScroll()

Editor:tellState(STATE_TIMER_SCROLL);
ui:changeScreen("TimerScrollGroup", false, false, false);
Sound:enableDialogDuckMusic();
Editor:lockInput();
stateMachine:requestState(Editor_state.End);

end
function onUpdateToTimerScroll()

end
function onExitToTimerScroll()
Editor:unlockInput();
end
function onEnterUseSkinM1()
if gSkinType == SKIN_M1 then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_skin");
	gSkipListCloseSound = true;
end
gCourseType = SKIN_M1;

Editor:swapSkin(SKIN_M1);
stateMachine:requestState(Editor_state.ToggleSkin);
end
function onUpdateUseSkinM1()

end
function onExitUseSkinM1()

end
function onEnterUseSkinM3()
if gSkinType == SKIN_M3 then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_skin");
	gSkipListCloseSound = true;
end
gCourseType = SKIN_M3;

Editor:swapSkin(SKIN_M3);
stateMachine:requestState(Editor_state.ToggleSkin);
end
function onUpdateUseSkinM3()

end
function onExitUseSkinM3()

end
function onEnterUseSkinMW()
if gSkinType == SKIN_MW then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_skin");
	gSkipListCloseSound = true;
end
gCourseType = SKIN_MW;

Editor:swapSkin(SKIN_MW);
stateMachine:requestState(Editor_state.ToggleSkin);
end
function onUpdateUseSkinMW()

end
function onExitUseSkinMW()

end
function onEnterUseSkinMU()
if gSkinType == SKIN_MU then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_skin");
	gSkipListCloseSound = true;
end
gCourseType = SKIN_MU;

Editor:swapSkin(SKIN_MU);
stateMachine:requestState(Editor_state.ToggleSkin);
end
function onUpdateUseSkinMU()

end
function onExitUseSkinMU()

end
function onEnterGroundCourseType()
if gCourseType == COURSETYPE_GROUND then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_scene");
	gSkipListCloseSound = true;
end
gCourseType = COURSETYPE_GROUND;

Editor:swapCourseType(COURSETYPE_GROUND);
stateMachine:requestState(Editor_state.ToggleCourseType);
end
function onUpdateGroundCourseType()

end
function onExitGroundCourseType()

end
function onEnterUndergroundCrourseType()
if gCourseType == COURSETYPE_UNDERGROUND then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_scene");
	gSkipListCloseSound = true;
end
gCourseType = COURSETYPE_UNDERGROUND;

Editor:swapCourseType(COURSETYPE_UNDERGROUND);
stateMachine:requestState(Editor_state.ToggleCourseType);
end
function onUpdateUndergroundCrourseType()

end
function onExitUndergroundCrourseType()

end
function onEnterUnderwaterCourseType()
if gCourseType == COURSETYPE_UNDERWATER then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_scene");
	gSkipListCloseSound = true;
end
gCourseType = COURSETYPE_UNDERWATER;

Editor:swapCourseType(COURSETYPE_UNDERWATER);
stateMachine:requestState(Editor_state.ToggleCourseType);
end
function onUpdateUnderwaterCourseType()

end
function onExitUnderwaterCourseType()

end
function onEnterGhostHouseCourseType()
if gCourseType == COURSETYPE_GHOSTHOUSE then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_scene");
	gSkipListCloseSound = true;
end
gCourseType = COURSETYPE_GHOSTHOUSE;

Editor:swapCourseType(COURSETYPE_GHOSTHOUSE);
stateMachine:requestState(Editor_state.ToggleCourseType);
end
function onUpdateGhostHouseCourseType()

end
function onExitGhostHouseCourseType()

end
function onEnterAirshipCourseType()
if gCourseType == COURSETYPE_AIRSHIP then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_scene");
	gSkipListCloseSound = true;
end
gCourseType = COURSETYPE_AIRSHIP;

Editor:swapCourseType(COURSETYPE_AIRSHIP);
stateMachine:requestState(Editor_state.ToggleCourseType);
end
function onUpdateAirshipCourseType()

end
function onExitAirshipCourseType()

end
function onEnterCastleCourseType()
if gCourseType == COURSETYPE_CASTLE then
	Sound:playSound("select_current");
else
	Sound:playSound("decide_scene");
	gSkipListCloseSound = true;
end
gCourseType = COURSETYPE_CASTLE;

Editor:swapCourseType(COURSETYPE_CASTLE);
stateMachine:requestState(Editor_state.ToggleCourseType);
end
function onUpdateCastleCourseType()

end
function onExitCastleCourseType()

end
function onEnterToggleMarioPlot()

if gMarioPlotOn == false then
   gMarioPlotOn = true;
   Editor:tellState(STATE_MARIO_PLOT);
else
   gMarioPlotOn = false;
   Editor:tellState(STATE_MARIO_PLOT);
end
stateMachine:requestState(Editor_state.End);

end
function onUpdateToggleMarioPlot()

end
function onExitToggleMarioPlot()

end
function onEnterToggleArea()

Editor:tellState(STATE_AREA);
stateMachine:requestState(Editor_state.End);
end
function onUpdateToggleArea()

end
function onExitToggleArea()

end
function onEnterTapOut()
--Editor:lockInputUIFriendly()
--Editor:lockInput();

if gShowSkins == true then
	NN_LOG("TAP OUT SKINS");
	stateMachine:requestState(Editor_state.ToggleSkin);
end

if gShowCourseTypes== true then
	NN_LOG("TAP OUT COURSE");
	stateMachine:requestState(Editor_state.ToggleCourseType);
end
end
function onUpdateTapOut()

end
function onExitTapOut()

end
function onEnterEnd()

end
function onUpdateEnd()

end
function onExitEnd()

end
function onEnterRestore()
gShowSFX = false;

stateMachine:requestState(Editor_state.End);
end
function onUpdateRestore()

end
function onExitRestore()

end
-------------------------------------------------------------
Init={}
Init.onEnter=onEnterInit
Init.onUpdate=onUpdateInit
Init.onExit=onExitInit
ToggleMultiGrabMode={}
ToggleMultiGrabMode.onEnter=onEnterToggleMultiGrabMode
ToggleMultiGrabMode.onUpdate=onUpdateToggleMultiGrabMode
ToggleMultiGrabMode.onExit=onExitToggleMultiGrabMode
ToggleCopyMode={}
ToggleCopyMode.onEnter=onEnterToggleCopyMode
ToggleCopyMode.onUpdate=onUpdateToggleCopyMode
ToggleCopyMode.onExit=onExitToggleCopyMode
ModeNone={}
ModeNone.onEnter=onEnterModeNone
ModeNone.onUpdate=onUpdateModeNone
ModeNone.onExit=onExitModeNone
PlacePipe={}
PlacePipe.onEnter=onEnterPlacePipe
PlacePipe.onUpdate=onUpdatePlacePipe
PlacePipe.onExit=onExitPlacePipe
PipePlaced={}
PipePlaced.onEnter=onEnterPipePlaced
PipePlaced.onUpdate=onUpdatePipePlaced
PipePlaced.onExit=onExitPipePlaced
ToggleEraseMode={}
ToggleEraseMode.onEnter=onEnterToggleEraseMode
ToggleEraseMode.onUpdate=onUpdateToggleEraseMode
ToggleEraseMode.onExit=onExitToggleEraseMode
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
ToggleLeftPannel={}
ToggleLeftPannel.onEnter=onEnterToggleLeftPannel
ToggleLeftPannel.onUpdate=onUpdateToggleLeftPannel
ToggleLeftPannel.onExit=onExitToggleLeftPannel
ToggleRightPannel={}
ToggleRightPannel.onEnter=onEnterToggleRightPannel
ToggleRightPannel.onUpdate=onUpdateToggleRightPannel
ToggleRightPannel.onExit=onExitToggleRightPannel
ToMainMenu={}
ToMainMenu.onEnter=onEnterToMainMenu
ToMainMenu.onUpdate=onUpdateToMainMenu
ToMainMenu.onExit=onExitToMainMenu
ToPaletteList={}
ToPaletteList.onEnter=onEnterToPaletteList
ToPaletteList.onUpdate=onUpdateToPaletteList
ToPaletteList.onExit=onExitToPaletteList
ToCourseBot={}
ToCourseBot.onEnter=onEnterToCourseBot
ToCourseBot.onUpdate=onUpdateToCourseBot
ToCourseBot.onExit=onExitToCourseBot
ToTimerScroll={}
ToTimerScroll.onEnter=onEnterToTimerScroll
ToTimerScroll.onUpdate=onUpdateToTimerScroll
ToTimerScroll.onExit=onExitToTimerScroll
UseSkinM1={}
UseSkinM1.onEnter=onEnterUseSkinM1
UseSkinM1.onUpdate=onUpdateUseSkinM1
UseSkinM1.onExit=onExitUseSkinM1
UseSkinM3={}
UseSkinM3.onEnter=onEnterUseSkinM3
UseSkinM3.onUpdate=onUpdateUseSkinM3
UseSkinM3.onExit=onExitUseSkinM3
UseSkinMW={}
UseSkinMW.onEnter=onEnterUseSkinMW
UseSkinMW.onUpdate=onUpdateUseSkinMW
UseSkinMW.onExit=onExitUseSkinMW
UseSkinMU={}
UseSkinMU.onEnter=onEnterUseSkinMU
UseSkinMU.onUpdate=onUpdateUseSkinMU
UseSkinMU.onExit=onExitUseSkinMU
GroundCourseType={}
GroundCourseType.onEnter=onEnterGroundCourseType
GroundCourseType.onUpdate=onUpdateGroundCourseType
GroundCourseType.onExit=onExitGroundCourseType
UndergroundCrourseType={}
UndergroundCrourseType.onEnter=onEnterUndergroundCrourseType
UndergroundCrourseType.onUpdate=onUpdateUndergroundCrourseType
UndergroundCrourseType.onExit=onExitUndergroundCrourseType
UnderwaterCourseType={}
UnderwaterCourseType.onEnter=onEnterUnderwaterCourseType
UnderwaterCourseType.onUpdate=onUpdateUnderwaterCourseType
UnderwaterCourseType.onExit=onExitUnderwaterCourseType
GhostHouseCourseType={}
GhostHouseCourseType.onEnter=onEnterGhostHouseCourseType
GhostHouseCourseType.onUpdate=onUpdateGhostHouseCourseType
GhostHouseCourseType.onExit=onExitGhostHouseCourseType
AirshipCourseType={}
AirshipCourseType.onEnter=onEnterAirshipCourseType
AirshipCourseType.onUpdate=onUpdateAirshipCourseType
AirshipCourseType.onExit=onExitAirshipCourseType
CastleCourseType={}
CastleCourseType.onEnter=onEnterCastleCourseType
CastleCourseType.onUpdate=onUpdateCastleCourseType
CastleCourseType.onExit=onExitCastleCourseType
ToggleMarioPlot={}
ToggleMarioPlot.onEnter=onEnterToggleMarioPlot
ToggleMarioPlot.onUpdate=onUpdateToggleMarioPlot
ToggleMarioPlot.onExit=onExitToggleMarioPlot
ToggleArea={}
ToggleArea.onEnter=onEnterToggleArea
ToggleArea.onUpdate=onUpdateToggleArea
ToggleArea.onExit=onExitToggleArea
TapOut={}
TapOut.onEnter=onEnterTapOut
TapOut.onUpdate=onUpdateTapOut
TapOut.onExit=onExitTapOut
End={}
End.onEnter=onEnterEnd
End.onUpdate=onUpdateEnd
End.onExit=onExitEnd
Restore={}
Restore.onEnter=onEnterRestore
Restore.onUpdate=onUpdateRestore
Restore.onExit=onExitRestore
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Editor_state._stateCount,Editor_state.Init)
stateMachine:register(Editor_state.Init,Init)
stateMachine:register(Editor_state.ToggleMultiGrabMode,ToggleMultiGrabMode)
stateMachine:register(Editor_state.ToggleCopyMode,ToggleCopyMode)
stateMachine:register(Editor_state.ModeNone,ModeNone)
stateMachine:register(Editor_state.PlacePipe,PlacePipe)
stateMachine:register(Editor_state.PipePlaced,PipePlaced)
stateMachine:register(Editor_state.ToggleEraseMode,ToggleEraseMode)
stateMachine:register(Editor_state.ToggleSkin,ToggleSkin)
stateMachine:register(Editor_state.ToggleCourseType,ToggleCourseType)
stateMachine:register(Editor_state.ToggleSFX,ToggleSFX)
stateMachine:register(Editor_state.TogglePlay,TogglePlay)
stateMachine:register(Editor_state.ToggleLeftPannel,ToggleLeftPannel)
stateMachine:register(Editor_state.ToggleRightPannel,ToggleRightPannel)
stateMachine:register(Editor_state.ToMainMenu,ToMainMenu)
stateMachine:register(Editor_state.ToPaletteList,ToPaletteList)
stateMachine:register(Editor_state.ToCourseBot,ToCourseBot)
stateMachine:register(Editor_state.ToTimerScroll,ToTimerScroll)
stateMachine:register(Editor_state.UseSkinM1,UseSkinM1)
stateMachine:register(Editor_state.UseSkinM3,UseSkinM3)
stateMachine:register(Editor_state.UseSkinMW,UseSkinMW)
stateMachine:register(Editor_state.UseSkinMU,UseSkinMU)
stateMachine:register(Editor_state.GroundCourseType,GroundCourseType)
stateMachine:register(Editor_state.UndergroundCrourseType,UndergroundCrourseType)
stateMachine:register(Editor_state.UnderwaterCourseType,UnderwaterCourseType)
stateMachine:register(Editor_state.GhostHouseCourseType,GhostHouseCourseType)
stateMachine:register(Editor_state.AirshipCourseType,AirshipCourseType)
stateMachine:register(Editor_state.CastleCourseType,CastleCourseType)
stateMachine:register(Editor_state.ToggleMarioPlot,ToggleMarioPlot)
stateMachine:register(Editor_state.ToggleArea,ToggleArea)
stateMachine:register(Editor_state.TapOut,TapOut)
stateMachine:register(Editor_state.End,End)
stateMachine:register(Editor_state.Restore,Restore)
stateMachine:endRegister()
end

