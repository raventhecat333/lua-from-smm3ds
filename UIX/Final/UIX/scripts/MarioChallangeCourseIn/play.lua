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
cWaitForInput=4,
cEnd=5,
_stateCount=6
}
-------------------------------------------------------------
function onEntercWait()
gameStateType = {}
gameStateType.MARIO_CHALLENGE_MAP = 12

counter = 60
-- show castle door
local topScreen = ui:getScreen(2)
if GlobalData:isBossStage() then
	local anim = topScreen:playAnimation("Type", false)
	anim:stop()
	anim:setFrame(1)
end


topScreen:setTextW("T_CourseName_00", GlobalData:setSMChallengeLevelName())
topScreen:setText("T_Zanki_00", GlobalData:getLifes())

-- get challenge and medal values from the game
medalChallengeNumber = GlobalData:getLayoutChallengeLevelIndex()

gotNormalMedal = GlobalData:isNormalChallengeGoalComplete(medalChallengeNumber) -- #10119
gotSpecialMedal = GlobalData:isSpecialChallengeGoalComplete(medalChallengeNumber) -- #10119

-- determine what to do
setNormalMedalOn = gotNormalMedal 
setSpecialMedalOn = gotSpecialMedal 

-- we will immediately show the special text if the user already gotten one of the medals previously
showingSpecialText = setNormalMedalOn or setSpecialMedalOn 

-- start setting up the layout
Medals:setupTextMessages(medalChallengeNumber)

Medals:setStatus(0, setNormalMedalOn )
Medals:setStatus(1, setSpecialMedalOn )

if showingSpecialText then
	Medals:showSpecialText()
end

-- #11204 - hiding Yam + bubble
local botScreen = ui:getScreen(SCREEN.BOTTOM)
if botScreen then
	botScreen:setVisible("W_bubble_00", false)
	botScreen:setVisible("T_Start_00", false)
	botScreen:setVisible("p_yamamura_shadow_00", false)
	botScreen:setVisible("p_yamamura_00", false)
	botScreen:setVisible("p_bubbleTip_00", false)
end

-- #10316 - center mario
if GlobalData:getLifes() < 10 then
	ui:getScreen(SCREEN.TOP):setPositionXY("N_Zanki_00", 8, -7)
	ui:getScreen(SCREEN.TOP):setPositionXY("N_Mario_00", -24, 17)
end
end
function onUpdatecWait()
counter = counter - 1
if counter <= 0 then
	stateMachine:requestState(play_state.cInit)
end
end
function onExitcWait()

end
function onEntercInit()
Sound:playSound("cm_small_mario_jump") -- #9395

topScreen = ui:getScreen(2)

animA = topScreen:playAnimation("AnimA")
end
function onUpdatecInit()
if animA ~= nil and animA:isPlaying() == false then
	stateMachine:requestState(play_state.c10In)
end
end
function onExitcInit()

end
function onEnterc10In()

topScreen = ui:getScreen(2)

animB = topScreen:playAnimation("AnimB", false)
end
function onUpdatec10In()
if animB:isPlaying() == false then
	stateMachine:requestState(play_state.cStateDone)
end
end
function onExitc10In()

end
function onEntercStateDone()
counter = 40

end
function onUpdatecStateDone()
if counter <= 0 then
	if GameState:getPrevState() == gameStateType.MARIO_CHALLENGE_MAP then
		stateMachine:requestState(play_state.cWaitForInput)
	else
		stateMachine:requestState(play_state.cEnd)
	end
else
	counter = counter - 1
end
end
function onExitcStateDone()

end
function onEntercWaitForInput()
local uiWait = ui:getUI("AToSkip_MapIn")
if uiWait then
	uiWait:getScreen(SCREEN.BOTTOM):playAnimation("IN", false)
end
end
function onUpdatecWaitForInput()
if Input:isTriggered(BUTTON.A) then
	stateMachine:requestState(play_state.cEnd)
	Sound:playSound("cm_lets_a_go")
end
end
function onExitcWaitForInput()

end
function onEntercEnd()
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
cWaitForInput={}
cWaitForInput.onEnter=onEntercWaitForInput
cWaitForInput.onUpdate=onUpdatecWaitForInput
cWaitForInput.onExit=onExitcWaitForInput
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
stateMachine:register(play_state.cWaitForInput,cWaitForInput)
stateMachine:register(play_state.cEnd,cEnd)
stateMachine:endRegister()
end

