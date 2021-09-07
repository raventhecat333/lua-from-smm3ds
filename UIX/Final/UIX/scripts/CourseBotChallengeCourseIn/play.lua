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
_stateCount=4
}
-------------------------------------------------------------
function onEntercWait()
counter = 60

local topScreen = ui:getScreen(2)
topScreen:setTextW("T_CourseName_00", GlobalData:setChallengeLevelName())
topScreen:setVisible("N_Zanki_00", false)

x,y = topScreen:getPositionXY("N_Mario_00")

topScreen:setPositionXY("N_Mario_00", 0, y)

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
topScreen = ui:getScreen(2)

animA = topScreen:playAnimation("AnimA")

Sound:playSound("courseplay_walk_dot")
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

animB = topScreen:playAnimation("AnimB")
end
function onUpdatec10In()
if animB ~= nil and animB:isPlaying() == false then
	stateMachine:requestState(play_state.cStateDone)
end
end
function onExitc10In()

end
function onEntercStateDone()
GlobalData:playCourseBotChallengeLevel()
GameState:switchScene("gameplay")
end
function onUpdatecStateDone()

end
function onExitcStateDone()

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
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (play_state._stateCount,play_state.cWait)
stateMachine:register(play_state.cWait,cWait)
stateMachine:register(play_state.cInit,cInit)
stateMachine:register(play_state.c10In,c10In)
stateMachine:register(play_state.cStateDone,cStateDone)
stateMachine:endRegister()
end

