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
play_state= {
cWait=0,
cInit=1,
c10In=2,
cStateDone=3,
cEnd=4,
_stateCount=5
}
-------------------------------------------------------------
function onEntercWait()
counter = 60
skipPresentation = false

-- show castle door
local topScreen = ui:getScreen(2)
if GlobalData:isBossStage() then
	local anim = topScreen:playAnimation("Type", false)
	anim:stop()
	anim:setFrame(1)
end

if not CourseIn:is100MarioAnimANeeded() then
	ui:setAnimationFrame("AnimA", 2, 9999)
end
if not CourseIn:is100MarioAnimBNeeded() then
	ui:setAnimationFrame("AnimB", 2, 9999)
end

-- topScreen:setText("T_CourseName_00", GlobalData:setLevelName())
topScreen:setText("T_Zanki_00", GlobalData:getLifes())

-- #11204 - hiding Yam + bubble
local botScreen = ui:getScreen(SCREEN.BOTTOM)
if botScreen then
	botScreen:setVisible("W_bubble_00", false)
	botScreen:setVisible("T_Start_00", false)
	botScreen:setVisible("p_yamamura_shadow_00", false)
	botScreen:setVisible("p_yamamura_00", false)
	botScreen:setVisible("p_bubbleTip_00", false)
end
end
function onUpdatecWait()
if Input:isTriggered(BUTTON.A) and CourseIn:isReadyToFinish() then
	skipPresentation = true
end

-- wait for the initial course information to finish downloading before starting
if CourseIn:isReadyToStart() then
	counter = counter - 1
	if counter <= 0 then
		stateMachine:requestState(play_state.cInit)
	end
end
end
function onExitcWait()

end
function onEntercInit()
topScreen = ui:getScreen(2)

if CourseIn:is100MarioAnimANeeded() then
	animA = topScreen:playAnimation("AnimA")
	Sound:playSound("cw_100_marios_walk_in")
else
	stateMachine:requestState(play_state.c10In)
end
end
function onUpdatecInit()
if Input:isTriggered(BUTTON.A) and CourseIn:isReadyToFinish() then
	skipPresentation = true
end

if skipPresentation == true then
	stateMachine:requestState(play_state.cEnd)
elseif animA ~= nil and animA:isPlaying() == false then
	stateMachine:requestState(play_state.c10In)
end

end
function onExitcInit()

end
function onEnterc10In()
topScreen = ui:getScreen(2)

if CourseIn:is100MarioAnimBNeeded() then
	animB = topScreen:playAnimation("AnimB")
	Sound:playSound("cm_small_mario_jump")

	local lives = GlobalData:getLifes()
	if lives >= 80 then
		Sound:playSound("cw_80_or_more_marios")
	elseif lives >= 60 then
		Sound:playSound("cw_60_or_more_marios")
	elseif lives >= 40 then
		Sound:playSound("cw_40_or_more_marios")
	elseif lives >= 20 then
		Sound:playSound("cw_20_or_more_marios")
	elseif lives >= 10 then
		Sound:playSound("cw_10_or_more_marios")
	else
		Sound:playSound("cw_0_or_more_marios")
	end
else
	stateMachine:requestState(play_state.cStateDone)
end
end
function onUpdatec10In()
if Input:isTriggered(BUTTON.A) and CourseIn:isReadyToFinish() then
	skipPresentation = true
end

if skipPresentation == true then
	stateMachine:requestState(play_state.cEnd)
elseif animB ~= nil and animB:isPlaying() == false then
	stateMachine:requestState(play_state.cStateDone)
end

end
function onExitc10In()

end
function onEntercStateDone()
counter = 40

end
function onUpdatecStateDone()
if Input:isTriggered(BUTTON.A) and CourseIn:isReadyToFinish() then
	skipPresentation = true
end

if skipPresentation == true then
	stateMachine:requestState(play_state.cEnd)
elseif counter <= 0 then
	-- wait for the course data to finish downloading
	if CourseIn:isReadyToFinish() then
		stateMachine:requestState(play_state.cEnd)
	end
else
	counter = counter - 1
end
end
function onExitcStateDone()

end
function onEntercEnd()
-- fade out any sfx that may be playing
Sound:stopSound("cw_100_marios_walk_in", 15)
Sound:stopSound("cm_small_mario_jump", 15)
Sound:stopSound("cw_80_or_more_marios", 15)
Sound:stopSound("cw_60_or_more_marios", 15)
Sound:stopSound("cw_40_or_more_marios", 15)
Sound:stopSound("cw_20_or_more_marios", 15)
Sound:stopSound("cw_10_or_more_marios", 15)
Sound:stopSound("cw_0_or_more_marios", 15)

GameState:switchScene("gameplay")

end
function onUpdatecEnd()

end
function onExitcEnd()

end
-------------------------------------------------------------
cWait={}
cWait.onEnter=onEntercWait
cWait.onUpdate=onUpdatecWait
cWait.onExit=onExitcWait
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
c10In={}
c10In.onEnter=onEnterc10In
c10In.onUpdate=onUpdatec10In
c10In.onExit=onExitc10In
cStateDone={}
cStateDone.onEnter=onEntercStateDone
cStateDone.onUpdate=onUpdatecStateDone
cStateDone.onExit=onExitcStateDone
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (play_state._stateCount,play_state.cWait)
stateMachine:register(play_state.cWait,cWait)
stateMachine:register(play_state.cInit,cInit)
stateMachine:register(play_state.c10In,c10In)
stateMachine:register(play_state.cStateDone,cStateDone)
stateMachine:register(play_state.cEnd,cEnd)
stateMachine:endRegister()
end

