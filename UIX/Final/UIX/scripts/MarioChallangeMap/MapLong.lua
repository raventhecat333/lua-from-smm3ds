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
MapLong_state= {
cGlobals=0,
cInit=1,
cWait=2,
cCloseCurtains=3,
cWorld2=4,
cOpenCurtains=5,
cIdle=6,
cMapIn=7,
cMapInAdvance=8,
cTelop=9,
cMoveKuribo=10,
cAppearMario=11,
cAppearNextMapPoint=12,
cMoveMarioAndStand=13,
cMarioJumpBeforeDisappear=14,
cDisappearMario=15,
cEnterLevel=16,
cDemoCancel=17,
cDemoCloseCurtain=18,
cDemoOpenCurtains=19,
cDemoMoveKuriboJourneyIn=20,
cDemoMoveKuriboJourneyMiddle=21,
cDemoMoveKuriboJourneyOut=22,
cDemoMoveKuriboToEndIn=23,
cDemoMoveKuriboToEnd=24,
cDemoKuriboEnterCastle=25,
cPeachCallForHelp=26,
cDemoLevelWarp=27,
cMarioMoveToNextWorld=28,
cMarioEnterWorld=29,
cDemoUpdateTheme=30,
cDelayBeforeMove=31,
cDemoFadeIn=32,
cDemoFadeOut=33,
cDemoFadeLevelWarp=34,
cDebug=35,
cConversationChangeLevelStart=36,
cConversationStart=37,
cInConversation=38,
cInConversationChangeLevel=39,
cStart=40,
cContinue=41,
cDone=42,
cRiseTheFlag=43,
cFaderInToMapIn=44,
cEndButton=45,
_stateCount=46
}
-------------------------------------------------------------
function onEntercGlobals()
-- globals ---------------------------------------------------------------------
gLevelJumpIndex = 0
gKuriboMove = false
gMarioId = 0
gKuriboId = 1
gPeachCastleId = 2
gBowserCastleId = 3
gDialogSeen = nil

gCancelActive = false

gTimer = 0

gMarioMoveToNextWorld = false
gIs1stDemoFlag = true
gCurrentLevelIndex = 0
gWorldIndex = 0
gNextWorldIndex = gWorldIndex + 1
gWorldCount = 0
gLevelCount = 100
gWorldLevelIndex = 0
gNextState = -1

gLevelDesc = {}
gLevelDesc[0] = {nodeCount=4,openCount=0,levelName="World-1",desc="Tutorial text for the World 1",lives=90}
gLevelDesc[1] = {nodeCount=4,openCount=1,levelName="World-2",desc="Tutorial text for the World 2",lives=10}
gLevelDesc[2] = {nodeCount=4,openCount=1,levelName="World-3",desc="Tutorial text for the World 3",lives=99}
gLevelDesc[3] = {nodeCount=4,openCount=1,levelName="World-4",desc="Tutorial text for the World 4",lives=99}
gLevelDesc[4] = {nodeCount=4,openCount=1,levelName="World-5",desc="Tutorial text for the World 5",lives=99}
gLevelDesc[5] = {nodeCount=4,openCount=1,levelName="World-6",desc="Tutorial text for the World 6",lives=99}
gLevelDesc[6] = {nodeCount=4,openCount=1,levelName="World-7",desc="Tutorial text for the World 7",lives=99}
gLevelDesc[7] = {nodeCount=6,openCount=1,levelName="World-8",desc="Tutorial text for the World 8",lives=99}
gLevelDesc[8] = {nodeCount=8,openCount=1,levelName="World-9",desc="Tutorial text for the World 9",lives=99}
gLevelDesc[9] = {nodeCount=4,openCount=1,levelName="World-10",desc="Tutorial text for the World 10",lives=99}
gLevelDesc[10] = {nodeCount=4,openCount=1,levelName="World-11",desc="Tutorial text for the World 11",lives=99}
gLevelDesc[11] = {nodeCount=4,openCount=1,levelName="World-12",desc="Tutorial text for the World 12",lives=99}
gLevelDesc[12] = {nodeCount=6,openCount=1,levelName="World-13",desc="Tutorial text for the World 13",lives=99}
gLevelDesc[13] = {nodeCount=4,openCount=1,levelName="World-14",desc="Tutorial text for the World 14",lives=99}
gLevelDesc[14] = {nodeCount=4,openCount=1,levelName="World-15",desc="Tutorial text for the World 15",lives=99}
gLevelDesc[15] = {nodeCount=4,openCount=1,levelName="World-16",desc="Tutorial text for the World 16",lives=99}
gLevelDesc[16] = {nodeCount=8,openCount=1,levelName="World-17",desc="Tutorial text for the World 17",lives=99}
gLevelDesc[17] = {nodeCount=8,openCount=1,levelName="World-18",desc="Tutorial text for the World 18",lives=99}
gWorldCount = #gLevelDesc + 1 -- 19

-- offset table used to snap mario to nodes
gOffsetTable = {}
gOffsetTable[4] = {}
-- {-4,0,5,9.5}
gOffsetTable[4][0] = -4
gOffsetTable[4][1] = 0
gOffsetTable[4][2] = 5
gOffsetTable[4][3] = 9.5
-- {-4,-2,1,4,7,9.5}
gOffsetTable[6] = {} 
gOffsetTable[6][0] = -4
gOffsetTable[6][1] = -2
gOffsetTable[6][2] = 1
gOffsetTable[6][3] = 4
gOffsetTable[6][4] = 7
gOffsetTable[6][5] = 9.5
-- {-4,-1,1,2,4,6,9,9.5}
gOffsetTable[8] = {}
gOffsetTable[8][0] = -4
gOffsetTable[8][1] = -1
gOffsetTable[8][2] = 1
gOffsetTable[8][3] = 2
gOffsetTable[8][4] = 4
gOffsetTable[8][5] = 6
gOffsetTable[8][6] = 9
gOffsetTable[8][7] = 9.5


gCanSkipConversation = false
---------------------------------------------------------------------------------
-- enums ----------------------------------------------------------------------
enumMarioAnims = {}
enumMarioAnims.In = 0
enumMarioAnims.Stand = 1
enumMarioAnims.Walk = 2
enumMarioAnims.Jump = 3
enumMarioAnims.TwoJump = 4
enumMarioAnims.Go = 5
enumMarioAnims.Out = 6

enumKuriboAnims = {}
enumKuriboAnims.Default = 0
enumKuriboAnims.Stand = 1
enumKuriboAnims.Walk = 2

enumCastleAnims = {}
enumCastleAnims.Anim = 0
enumCastleAnims.AnmKoopa = 5
enumCastleAnims.Default = 6
enumCastleAnims.FlagIn = 7
enumCastleAnims.FlagIdle = 8
---------------------------------------------------------------------------------

function showDarkFlowers(show)
	ui:getScreen(SCREEN.TOP):setVisible("N18_Grass_08", show)
	ui:getScreen(SCREEN.TOP):setVisible("N18_Grass_09", show)
	ui:getScreen(SCREEN.TOP):setVisible("N18_Grass_10", show)
	ui:getScreen(SCREEN.TOP):setVisible("N18_Grass_11", show)
end

function showFlowers1(show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_00", show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_01", show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_02", show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_03", show)
end

function showFlowers2(show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_07", show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_06", show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_05", show)
	ui:getScreen(SCREEN.TOP):setVisible("N_Grass_04", show)
end

function setupWorld(worldIndex, showOpen, levelIndex)
	local map = ChallangeMap
	map:beginGen(worldIndex, gWorldCount)
	map:setLevelTheme(worldIndex )
	map:setCurtainTheme(worldIndex)
	map:setLevelNodeCount(gLevelDesc[worldIndex].nodeCount)
	local openCount = 0
	if showOpen then
		openCount = getLastOpenLevel(levelIndex)
	end
	map:setLevelNodeOpenCount(openCount)
	--map:setLiveCount(99)
	map:setCurtainTheme(worldIndex)
	map:endGen()

	ChallangeMap:setWorldCleared(false)

	if gWorldCount - worldIndex == 1 then
		showDarkFlowers(true)
		showFlowers1(false)
		showFlowers2(false)
	else
		showDarkFlowers(false)
		showFlowers1(true)
		showFlowers2(false)
	end
end

function jumpToWorld(levelIndex, showOpen)
	local worldIndex = getWorldIndex(levelIndex)
	setupWorld(worldIndex, showOpen, levelIndex)
end

function getWorldIndex(levelIndex)
	local worldIndex = 0
	local world = gLevelDesc[0]
	local offset = 0
	for var=1,gWorldCount,1 do
		if world then
			offset = offset + world.nodeCount
			if levelIndex < offset then
				return worldIndex
			end
		end
		world = gLevelDesc[var]
		worldIndex = var
	end
end

function getLastOpenLevel(levelIndex)
	local world = gLevelDesc[0]
	local offset = 0
	for var=1,gWorldCount,1 do
		if world then
			offset = offset + world.nodeCount
			if levelIndex < offset then
				return world.nodeCount - (offset - levelIndex)
			end
		end
		world = gLevelDesc[var]
	end
end

function getCurrentOpenLevelCount(levelIndex)
	local world = gLevelDesc[0]
	local offset = 0
	for var=1,gWorldCount,1 do
		if world then
			offset = offset + world.nodeCount
			if levelIndex < offset then
				return world.nodeCount - (offset - levelIndex - 1)
			end
		end
		world = gLevelDesc[var]
	end
end

function setupMapFreeze(showBottom)
	local topScreen = ui:getScreen(2)
	local botScreen = ui:getScreen(1)
	local anim = topScreen:playAnimation("Map_swapOUT")
	anim:pause()
	anim:setFrame(anim:getLength())
	anim = topScreen:playAnimation("MapIn")
	anim:pause()
	anim:setFrame(anim:getLength())
	if not showBottom then
		anim = botScreen:playAnimation("MapIn")
		anim:pause()
		anim:setFrame(anim:getLength())
	end
	--setLevel(gWorldIndex,gCurrentLevelIndex+1)
	
	local desc = gLevelDesc[gWorldIndex]
	if desc.nodeCount == gWorldLevelIndex then
		
	else
		--[[local marioStandLevel = GlobalData:getChallengeLevelPresentationIndex()
		if marioStandLevel == -1 then
			setMarioStartPosition(gWorldLevelIndex)
		else
			setMarioStartPosition(marioStandLevel)
		end]]--
	end
end

function isBossLevel()
	local desc = gLevelDesc[gWorldIndex]
	return desc.nodeCount-1 == gWorldLevelIndex
end

function getXOffset(levelIndex)
	local levelCount = gLevelDesc[gWorldIndex].nodeCount
	local xOffset = gOffsetTable[levelCount][levelIndex]
	return xOffset
end

function setMarioStartPosition(levelIndex)
	-- get target node index
	local marioAnim = ui:getScreen(SCREEN.TOP):playAnimation("MoveMario_start")
	if marioAnim ~= nil then
		marioAnim:pause()
		marioAnim:setFrame(60)
	end
	local xOffset = getXOffset(levelIndex)
	ChallangeMap:placePlayer(levelIndex, xOffset)
end

-----
function initLives()
	ChallangeMap:setLiveCount(GlobalData:getLifes())
end

function isFirstTimePlay()
	return GlobalData:isChallengePlaying() == false
end

function isComeFromTitle() 
	local reasonToEnter = GlobalData:getChallengeModeLeaveReason()
	return reasonToEnter == 0 or reasonToEnter > 1
end

function setLevel(index, openCount)
	local desc = gLevelDesc[index]
	local map = ChallangeMap
	map:beginGen(index, gWorldCount)
	map:setLevelNodeCount(desc.nodeCount)
	map:setLevelNodeOpenCount(openCount)
	map:endGen()
end

function showSWAP(show)
	ui:getScreen(2):setVisible("SWAP_P_BG_00", show)
	ui:getScreen(2):setVisible("SWAP_P_Yama_00", show)
	ui:getScreen(2):setVisible("SWAP_WorldMapKuribo_00", false)
	ui:getScreen(2):setVisible("SWAP_WorldMap_00", false)
	ui:getScreen(2):setVisible("SWAP_WM_Kumo_00", show)
	ui:getScreen(2):setVisible("SWAP_World_path_01", show)
end

function isAtBossLevel()
	local desc = gLevelDesc[gWorldIndex ]
	return desc.nodeCount-1 == gWorldLevelIndex 
end

function initFader()
	local faderUI = ui:getUI("fade_circle")
	if faderUI then
		NN_LOG("found fader")
		local topScreen = faderUI:getScreen(SCREEN.TOP)
		topScreen:setVisible("P_Fade_00", false)
		topScreen:setVisible("W_CircleW_00", false)
		topScreen:setVisible("N_Block_00", false)
		topScreen:setVisible("N_Pos_00", true)
		local faderAnim = topScreen:playAnimation("InCircle", false)
		if faderAnim then
			faderAnim:stop()
			faderAnim:setFrame(0)
		end
	end
end

function initFaderSquares()
	local faderUI = ui:getUI("fade_circle")
	if faderUI then
		NN_LOG("found fader")
		local topScreen = faderUI:getScreen(SCREEN.TOP)
		topScreen:setVisible("N_Pos_00", false)
		topScreen:setVisible("N_Block_00", true)
		local faderAnim = topScreen:playAnimation("InCircle", false)
		if faderAnim then
			faderAnim:stop()
			faderAnim:setFrame(0)
		end
	end
end

function setFaderPosition(x, y)
	local faderUI = ui:getUI("fade_circle")
	if faderUI then
		local topScreen = faderUI:getScreen(SCREEN.TOP)
		if topScreen then
			topScreen:setPositionXY("N_Pos_00", x, y)
		end
	end
end

function startFaderIn()
	initFader()
	local faderUI = ui:getUI("fade_circle")
	if faderUI then
		return faderUI:getScreen(SCREEN.TOP):playAnimation("InCircle", false)
	end
	return nil
end

function startFaderSquares()
	initFaderSquares()
	local faderUI = ui:getUI("fade_circle")
	if faderUI then
		return faderUI:getScreen(SCREEN.TOP):playAnimation("OutBlock", false)
	end
	return nil
end

function hideStartButton()
	ui:getScreen(SCREEN.BOTTOM):setVisible("Start_Btn", false)
	ui:getScreen(SCREEN.BOTTOM):setVisible("L_MenuBtn_00", false) -- mcat#25 - no button no problem
end

function hasConversationSeen(worldIndex)
	return GlobalData:hasChallengeMapDialogSeen(worldIndex+1)
end

function setWorldMusic()
	if gWorldIndex == 0 then
		Sound:changeChallengeWorldMusic(0)
	elseif gWorldIndex == 17 then
		Sound:changeChallengeWorldMusic(3)
	elseif gWorldIndex % 2 == 0 then
		Sound:changeChallengeWorldMusic(2)
	else
		Sound:changeChallengeWorldMusic(1)
	end
end

--commented out for M3
stateMachine:requestState(MapLong_state.cInit)
end
function onUpdatecGlobals()

end
function onExitcGlobals()
--GlobalData:setChallengeLevelIndex(0)

end
function onEntercInit()
GlobalData:readFromSaveDataChallengeMode() -- #10133 making sure that we are always getting correct challenge level index
GlobalData:clearBusy() -- let main menu to be open
if GlobalData:isRestartChallengeMap() then
	-- hide start button
	hideStartButton()
end

initFader()

initLives()

local anim = ui:getScreen(SCREEN.TOP):playAnimation("MapIn")
if anim then
	anim:stop()
	anim:setFrame(0)
end

gIs1stDemoFlag = isFirstTimePlay()
if gIs1stDemoFlag == false then
	if GlobalData:getChallengeLevelPresentationIndex() ~= -1 then
		gCurrentLevelIndex = GlobalData:getChallengeLevelPresentationIndex()
	else
		gCurrentLevelIndex = GlobalData:getChallengeLevelIndex()
	end
end

gWorldIndex = getWorldIndex(gCurrentLevelIndex)
jumpToWorld(gCurrentLevelIndex, true)
gWorldLevelIndex = getLastOpenLevel(gCurrentLevelIndex)
NN_LOG("World ID")
NN_LOG(gWorldIndex)
NN_LOG("Level ID")
NN_LOG(gWorldLevelIndex)
NN_LOG("Global level ID")
NN_LOG(gCurrentLevelIndex)

gComeFromTitle = isComeFromTitle()
GlobalData:setChallengeModeLeaveReason(0) -- clear the flag
startWorld = 0
endWorld = gWorldCount - 1

local map = ChallangeMap

g_swapColors = false
g_currentJourneyWorld = 9
g_nextJourneyWorld = 10

-- hide peach
if gWorldIndex == endWorld then
	ui:getScreen(2):setVisible("P_Peach_00", true)
	ui:getScreen(2):playAnimation("AnimB")
else
	ui:getScreen(2):setVisible("P_Peach_00", false)
end
-- show small shadow for tower, and big shadow for mega castle
ui:getScreen(SCREEN.TOP):setVisible("B_CastleSh_03", gWorldIndex == endWorld)
ui:getScreen(SCREEN.TOP):setVisible("P_TowerSh_00", gWorldIndex ~= endWorld)

-- hide SWAP
showSWAP(false)

gCanSkipConversation = hasConversationSeen(gWorldIndex)
setWorldMusic()

if gIs1stDemoFlag then
	local anim = ui:getScreen(1):playAnimation("Button_change")
	anim:pause()
	anim:setFrame(0)
	
	if GlobalData:isRestartChallengeMap() then
		GlobalData:setLifes(10)
		ChallangeMap:setLiveCount(GlobalData:getLifes())
		GlobalData:setRestartChallengeMap(false)
		stateMachine:requestState(MapLong_state.cMapIn)
	else
		stateMachine:requestState(MapLong_state.cIdle)
	end
elseif gComeFromTitle then --coming from Title screen
	local anim = ui:getScreen(1):playAnimation("Button_change")
	anim:pause()
	anim:setFrame(1)
	NN_LOG("Mario Start Position")
	NN_LOG(gWorldLevelIndex)
	if GlobalData:getChallengeLevelPresentationIndex() == -1 then -- normal mode
		ChallangeMap:markNodeAs(0)
		setMarioStartPosition(gWorldLevelIndex)
	else -- has presentation comming
		if not isAtBossLevel() then
			setMarioStartPosition(gWorldLevelIndex)
		else
			ChallangeMap:showMario(0)
		end
	end
	ChallangeMap:setLevelNodeOpenCount(getCurrentOpenLevelCount(gCurrentLevelIndex))
	stateMachine:requestState(MapLong_state.cIdle)
else
	NN_LOG("Mario Start Position")
	NN_LOG(gWorldLevelIndex)
	ChallangeMap:setLevelNodeOpenCount(getCurrentOpenLevelCount(gCurrentLevelIndex))
	if not isAtBossLevel() then
		setMarioStartPosition(gWorldLevelIndex)
	else
		ChallangeMap:showMario(0)
	end
	initFaderSquares()
	setupMapFreeze(false)
	stateMachine:requestState(MapLong_state.cFaderInToMapIn)
	--stateMachine:requestState(MapLong_state.cMapIn)
	--gCurrentLevelIndex = 0
end
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercWait()

end
function onUpdatecWait()

end
function onExitcWait()

end
function onEntercCloseCurtains()
ChallangeMap:setCurtainTheme(gWorldIndex)
local topScreen = ui:getScreen(2)
anim = topScreen:playAnimation("Map_swapIN")
end
function onUpdatecCloseCurtains()
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cWorld2)
end
end
function onExitcCloseCurtains()

end
function onEntercWorld2()
setLevel(gWorldIndex)
stateMachine:requestState(MapLong_state.cOpenCurtains)
end
function onUpdatecWorld2()

end
function onExitcWorld2()

end
function onEntercOpenCurtains()
local topScreen = ui:getScreen(2)

anim = topScreen:playAnimation("Map_swapOUT")
end
function onUpdatecOpenCurtains()
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cIdle)
end
end
function onExitcOpenCurtains()

end
function onEntercIdle()
if GlobalData:isRestartChallengeMap() then
	GlobalData:setLifes(startLives)
	ChallangeMap:setLiveCount(GlobalData:getLifes())
	stateMachine:requestState(MapLong_state.cMapIn)
end

--used for cheat
--[[
function snapTo(value, min, max)
	if value < min then value = min end
	if value > max then value = max end
	return value
end

function incSnapTo(value, inc, min, max)
	value = value + inc
	value = snapTo(value, min, max)
	return value
end

function decSnapTo(value, dec, min, max)
	value = value - dec
	value = snapTo(value, min, max)
	return value
end
anim = ui:getScreen(SCREEN.TOP):playAnimation("MapIn")
anim:pause()
anim:setFrame(99999)
]]--

end
function onUpdatecIdle()
-- cheat
--[[
if Input:isPressed(BUTTON.B) then
if Input:isTriggered(BUTTON.LEFT) then
	local levelIndex = GlobalData:getChallengeLevelIndex()
	levelIndex = decSnapTo(levelIndex, 4, 0, 87)
	GlobalData:setChallengeLevelIndex(levelIndex)
	GlobalData:setChallengeLevelPresentationIndex(-1)
	GlobalData:writeToSaveDataChallengeMode()
	GameState:switchScene("MarioChallangeMap")
end

if Input:isTriggered(BUTTON.RIGHT) then
	local levelIndex = GlobalData:getChallengeLevelIndex()
	levelIndex = incSnapTo(levelIndex, 4, 0, 87)
	GlobalData:setChallengeLevelIndex(levelIndex)
	GlobalData:setChallengeLevelPresentationIndex(-1)
	GlobalData:writeToSaveDataChallengeMode()
	GameState:switchScene("MarioChallangeMap")
end
else
if Input:isTriggered(BUTTON.LEFT) then
	local levelIndex = GlobalData:getChallengeLevelIndex()
	levelIndex = decSnapTo(levelIndex, 1, 0, 87)
	GlobalData:setChallengeLevelIndex(levelIndex)
	GlobalData:setChallengeLevelPresentationIndex(-1)
	GlobalData:writeToSaveDataChallengeMode()
	GameState:switchScene("MarioChallangeMap")
end

if Input:isTriggered(BUTTON.RIGHT) then
	local levelIndex = GlobalData:getChallengeLevelIndex()
	levelIndex = incSnapTo(levelIndex, 1, 0, 87)
	GlobalData:setChallengeLevelIndex(levelIndex)
	GlobalData:setChallengeLevelPresentationIndex(-1)
	GlobalData:writeToSaveDataChallengeMode()
	GameState:switchScene("MarioChallangeMap")
end
end

if Input:isTriggered(BUTTON.A) then
	local levelIndex = GlobalData:getChallengeLevelIndex()
	GlobalData:setChallengeLevelIndex(levelIndex)
	GlobalData:setChallengeLevelPresentationIndex(levelIndex-1)
	GlobalData:writeToSaveDataChallengeMode()
	GameState:switchScene("MarioChallangeMap")
end

if Input:isTriggered(BUTTON.SELECT) then
	GameState:switchScene("MarioChallangeMap")
end
]]--
end
function onExitcIdle()

end
function onEntercMapIn()
local topScreen = ui:getScreen(2)
local botScreen = ui:getScreen(1)

GlobalData:setBusy()

if gIs1stDemoFlag == true then
	setLevel(0, 0) --1st world with no levels open
	anim = topScreen:playAnimation("MapIn")
	botScreen:playAnimation("MapIn")
	ChallangeMap:showMario(0)
	ChallangeMap:startWave()
elseif gComeFromTitle then
	anim = topScreen:playAnimation("MapIn")
	botScreen:playAnimation("MapIn")
	ChallangeMap:showMario(0)
	ChallangeMap:startWave()
else
	setupMapFreeze(false)
end

if gIs1stDemoFlag == false and gComeFromTitle == false then
	stateMachine:requestState(MapLong_state.cDelayBeforeMove)
end


if gWorldIndex == 17 then
	--ui:getScreen(2):setVisible("P_Peach_00", true)
	--ui:getScreen(2):playAnimation("AnimB")
end

end
function onUpdatecMapIn()
if gTimer > 0 then
	gTimer = gTimer - 1
	return
end

if anim ~= nil then
	if anim:getFrame() == 150 then
		if gIs1stDemoFlag then
			ChallangeMap:showMario(0)
		else
			local inTheCastle = isAtBossLevel() and GlobalData:getChallengeLevelPresentationIndex() ~= -1
			if not inTheCastle then
				ChallangeMap:showMario(1)
			end
		end		
	end
end

if anim ~= nil and anim:isPlaying() == false then
	ui:enableUIInput() -- need to interact with conversation bubbles
	if gIs1stDemoFlag then
		stateMachine:requestState(MapLong_state.cConversationStart)
	elseif gComeFromTitle then
		stateMachine:requestState(MapLong_state.cDelayBeforeMove)
	end
end



end
function onExitcMapIn()

end
function onEntercMapInAdvance()
local topScreen = ui:getScreen(2)
local botScreen = ui:getScreen(1)

if true then
	setLevel(0, 0) --1st world with no levels open
	anim = topScreen:playAnimation("MapIn")
	botScreen:playAnimation("MapIn")
end



end
function onUpdatecMapInAdvance()
if gTimer > 0 then
	gTimer = gTimer - 1
	return
end

if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cMapIn)
end




end
function onExitcMapInAdvance()

end
function onEntercTelop()
local topScreen = ui:getScreen(SCREEN.TOP)

ui:changeScreen("TelopDialog", false, false)

Sound:playChallengeIntroMusic()
end
function onUpdatecTelop()
if ui:isFocused() then
	local uiAToSkip = ui:getUI("AToSkip_Map")
	if uiAToSkip then
		uiAToSkip:getScreen(SCREEN.BOTTOM):playAnimation("IN", false)
	end
	stateMachine:requestState(MapLong_state.cMoveKuribo)	
end
end
function onExitcTelop()

end
function onEntercMoveKuribo()

local topScreen = ui:getScreen(2)

anim = topScreen:playAnimation("MoveKuribo_start")
ChallangeMap:objectPlayAnim(gKuriboId, enumKuriboAnims.Stand, true)

end
function onUpdatecMoveKuribo()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end

if anim ~= nil and anim:getFrame() == 60 then
	ChallangeMap:objectPlayAnim(gKuriboId, enumKuriboAnims.Walk, true)
	ChallangeMap:objectPlayAnim(gKuriboId, enumKuriboAnims.Default)
end

if anim ~= nil and anim:isPlaying() == false then
--	stateMachine:requestState(MapLong_state.cDemoCloseCurtain)
	stateMachine:requestState(MapLong_state.cDemoFadeIn)
end

end
function onExitcMoveKuribo()
gLevelJumpIndex= gLevelJumpIndex+ 1
gKuriboMove  = true
end
function onEntercAppearMario()
-- have to hide A to skip message when mario is jumping out of castle
local uiA = ui:getUI("AToSkip_Map")
if uiA then
	uiA:getScreen(SCREEN.BOTTOM):playAnimation("IN", true)
end
local topScreen = ui:getScreen(2)

ChallangeMap:showMario(0)
anim = topScreen:playAnimation("MoveMario_start")
ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Jump, true)
ChallangeMap:objectPlayAnim(gPeachCastleId, enumCastleAnims.Anim, true)
end
function onUpdatecAppearMario()
if anim ~= nil and anim:getFrame() == 48 then
	anim:pause()
	ChallangeMap:showMario(1)
	stateMachine:requestState(MapLong_state.cAppearNextMapPoint)
end
end
function onExitcAppearMario()

end
function onEntercAppearNextMapPoint()
gTimer = 20

ChallangeMap:openNextLevelNode()

--ChallangeMap:objectPlayAnim(mario, marioAnims.Walk, true)


end
function onUpdatecAppearNextMapPoint()
if gTimer > 0 then
	gTimer = gTimer - 1
	return
end

stateMachine:requestState(MapLong_state.cMoveMarioAndStand)
end
function onExitcAppearNextMapPoint()

end
function onEntercMoveMarioAndStand()
local topScreen = ui:getScreen(2)

if gIs1stDemoFlag == false then
	local startOffset = getXOffset(gWorldLevelIndex)
	local endOffset = getXOffset(gWorldLevelIndex+1)
	ChallangeMap:moveFromTo(gWorldLevelIndex, gWorldLevelIndex+1, startOffset, endOffset)
else
	local startOffset = getXOffset(gWorldLevelIndex)
	ChallangeMap:moveTo(gWorldLevelIndex, startOffset )
end

ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Walk, true)

end
function onUpdatecMoveMarioAndStand()
if ChallangeMap:isMoving() == false then
	ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Stand, true)
	Sound:playSound("cm_mario_arrive")
	stateMachine:requestState(MapLong_state.cMarioJumpBeforeDisappear)
end
end
function onExitcMoveMarioAndStand()

end
function onEntercMarioJumpBeforeDisappear()

local desc = gLevelDesc[gWorldIndex]
if desc.nodeCount-1 == gCurrentLevelIndex +1 then
	--ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Jump, true)
else
	--ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Jump, true)
end

--jumpWaitTimer = 20
waitTimer = 0
end
function onUpdatecMarioJumpBeforeDisappear()
--[[if jumpWaitTimer == 1 then
	ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Jump, true)
	jumpWaitTimer = jumpWaitTimer - 1
elseif jumpWaitTimer > 0 then
	jumpWaitTimer = jumpWaitTimer - 1
	return
end]]--


if waitTimer > 0 then waitTimer = waitTimer - 1 end

if waitTimer <= 0 then
	--ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Out, true)
	stateMachine:requestState(MapLong_state.cDisappearMario)
end
end
function onExitcMarioJumpBeforeDisappear()

end
function onEntercDisappearMario()

local desc = gLevelDesc[gWorldIndex]
if desc.nodeCount-1 == gCurrentLevelIndex +1 then
	ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Go, true)
else
	ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Go, true)
end

waitTimer = 60
end
function onUpdatecDisappearMario()
if waitTimer > 0 then waitTimer = waitTimer - 1 end

if waitTimer <= 0 then
	--ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Out, true)
	stateMachine:requestState(MapLong_state.cEnterLevel)
end
end
function onExitcDisappearMario()

end
function onEntercEnterLevel()
local x, y = ui:getScreen(SCREEN.TOP):getGlobalPositionXY("N_WorldMapMario_00")
setFaderPosition(x, y+8)
gFaderAnim = startFaderIn()

Sound:playSound("cm_smear")
Sound:stopMusic(60)
end
function onUpdatecEnterLevel()
if gFaderAnim == nil then
	stateMachine:requestState(MapLong_state.cDone)
	return
end

if gFaderAnim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDone)
	return
end
end
function onExitcEnterLevel()

end
function onEntercDemoCancel()
--[[local uiA = ui:getUI("AToSkip_Map")
if uiA then
	uiA:getScreen(SCREEN.BOTTOM):playAnimation("IN", true)
end]]--

gLevelJumpIndex = startWorld 
gCancelActive = true

Sound:playSound("cm_interrupt_intro")
Sound:stopMusic(60)

stateMachine:requestState(MapLong_state.cDemoFadeIn)
end
function onUpdatecDemoCancel()

end
function onExitcDemoCancel()

end
function onEntercDemoCloseCurtain()
Sound:playSound("cm_curtain_close")
ChallangeMap:setCurtainTheme(gWorldIndex)
ChallangeMap:setLevelNameMSG(gLevelDesc[gWorldIndex].levelName)
local topScreen = ui:getScreen(2)
if gMarioMoveToNextWorld == false then
	topScreen:setVisible("N_Curtain_01", false)
	topScreen:setVisible("N_Curtain_00", false)
	topScreen:setVisible("Fade", true)
else
	topScreen:setVisible("N_Curtain_01", true)
	topScreen:setVisible("N_Curtain_00", true)
	topScreen:setVisible("Fade", false)
end
anim = topScreen:playAnimation("Map_swapIN")
end
function onUpdatecDemoCloseCurtain()
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDemoLevelWarp)
end
end
function onExitcDemoCloseCurtain()
showSWAP(false)

if g_animSwapTrans ~= nil then
	g_animSwapTrans:pause()
	g_animSwapTrans:setFrame(0)
end
end
function onEntercDemoOpenCurtains()
Sound:playSound("cm_curtain_open")
if gLevelJumpIndex~= endWorld and gLevelJumpIndex~= startWorld then
	--showSWAP(true)
end

if g_swapColors == true then
	-- black color is current world, white color is next world
	--ChallangeMap:setTransitionTheme(g_nextJourneyWorld, g_currentJourneyWorld)
else
	-- white color is current world, black color is next world
	--ChallangeMap:setTransitionTheme(g_currentJourneyWorld, g_nextJourneyWorld)
end
--g_swapColors = not g_swapColors

local topScreen = ui:getScreen(2)

anim = topScreen:playAnimation("Map_swapOUT")
--ChallangeMap:setCurtainTheme(gLevelJumpIndex)
end
function onUpdatecDemoOpenCurtains()
if anim ~= nil and anim:isPlaying() == false then
	if gKuriboMove  == true then
		if gLevelJumpIndex== endWorld then
			stateMachine:requestState(MapLong_state.cDemoMoveKuriboToEndIn)
		elseif gLevelJumpIndex== startWorld then
			stateMachine:requestState(MapLong_state.cAppearMario)
		else
			stateMachine:requestState(MapLong_state.cDemoMoveKuriboJourneyIn)
		end
	else
		stateMachine:requestState(MapLong_state.cMarioEnterWorld)
	end
end
end
function onExitcDemoOpenCurtains()

end
function onEntercDemoMoveKuriboJourneyIn()
local topScreen = ui:getScreen(2)

-- show small shadow for tower, and big shadow for mega castle
ui:getScreen(SCREEN.TOP):setVisible("B_CastleSh_03", gWorldIndex == endWorld)
ui:getScreen(SCREEN.TOP):setVisible("P_TowerSh_00", gWorldIndex ~= endWorld)


--ui:getScreen(2):setVisible("SWAP_WorldMapKuribo_00", true)
anim = topScreen:playAnimation("SWAP_peac_in")
anim = topScreen:playAnimation("BG_in")
--topScreen:playAnimation("SWAP_BG")

g_animKuriboWalking = nil

end
function onUpdatecDemoMoveKuriboJourneyIn()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDemoMoveKuriboJourneyMiddle)
end
end
function onExitcDemoMoveKuriboJourneyIn()

end
function onEntercDemoMoveKuriboJourneyMiddle()

showSWAP(true)
if g_swapColors == true then
	-- black color is current world, white color is next world
	ChallangeMap:setTransitionTheme(g_nextJourneyWorld, g_currentJourneyWorld)
else
	-- white color is current world, black color is next world
	ChallangeMap:setTransitionTheme(g_currentJourneyWorld, g_nextJourneyWorld)
end
g_swapColors = not g_swapColors
local topScreen = ui:getScreen(2)
-- = topScreen:playAnimation("SWAP_peac_idle")
g_animKuriboWalking = topScreen:playAnimation("SWAP_transition_00")
g_animSwapTrans = topScreen:playAnimation("BG_idle")
end
function onUpdatecDemoMoveKuriboJourneyMiddle()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil then
	if g_animSwapTrans:getFrame() == 40 or g_animSwapTrans:getFrame() == 130 or g_animSwapTrans:getFrame() == 220 or g_animSwapTrans:getFrame() == 310 or g_animSwapTrans:getFrame() == 400 or g_animSwapTrans:getFrame() == 490 then
		-- anim:pause()
		stateMachine:requestState(MapLong_state.cDemoUpdateTheme)
	end
	if g_animSwapTrans:getFrame() == 0 or g_animSwapTrans:getFrame() == 90 or g_animSwapTrans:getFrame() == 180 or g_animSwapTrans:getFrame() == 270 or g_animSwapTrans:getFrame() == 360 or g_animSwapTrans:getFrame() == 450 then
		ChallangeMap:setSpecialTransitionTheme(g_nextJourneyWorld, g_currentJourneyWorld)
	end
end
end
function onExitcDemoMoveKuriboJourneyMiddle()

end
function onEntercDemoMoveKuriboJourneyOut()
local topScreen = ui:getScreen(2)

if g_animKuriboWalking ~= nil then
	g_animKuriboWalking:pause()
end

anim = topScreen:playAnimation("SWAP_peac_Out_00")
--anim:setFrame(73)
end
function onUpdatecDemoMoveKuriboJourneyOut()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDemoFadeIn)
end
end
function onExitcDemoMoveKuriboJourneyOut()
gLevelJumpIndex= gLevelJumpIndex+ 1
if gLevelJumpIndex>= endWorld then
	gLevelJumpIndex= endWorld
end
end
function onEntercDemoMoveKuriboToEndIn()
local topScreen = ui:getScreen(2)

anim = topScreen:playAnimation("MoveKuribo_in")
end
function onUpdatecDemoMoveKuriboToEndIn()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDemoMoveKuriboToEnd)
end
end
function onExitcDemoMoveKuriboToEndIn()

end
function onEntercDemoMoveKuriboToEnd()
local topScreen = ui:getScreen(2)

anim = topScreen:playAnimation("MoveKuribo_start")
anim:setFrame(73)
end
function onUpdatecDemoMoveKuriboToEnd()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil and anim:getFrame() == 157 then
	ChallangeMap:objectPlayAnim(gKuriboId, enumKuriboAnims.Stand, true)
	anim:pause()
	stateMachine:requestState(MapLong_state.cDemoKuriboEnterCastle)
end
end
function onExitcDemoMoveKuriboToEnd()

end
function onEntercDemoKuriboEnterCastle()

local topScreen = ui:getScreen(2)

anim = topScreen:playAnimation("MoveKuribo_castle")
end
function onUpdatecDemoKuriboEnterCastle()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cPeachCallForHelp)
end

end
function onExitcDemoKuriboEnterCastle()

end
function onEntercPeachCallForHelp()
local topScreen = ui:getScreen(2)
ui:getScreen(2):setVisible("P_Peach_00", true)
anim = topScreen:playAnimation("AnimB")
end
function onUpdatecPeachCallForHelp()
if Input:isTriggered(BUTTON.A, true) then
	stateMachine:requestState(MapLong_state.cDemoCancel)
	return
end
if anim ~= nil and anim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDemoFadeIn)
end
end
function onExitcPeachCallForHelp()
gLevelJumpIndex = startWorld
end
function onEntercDemoLevelWarp()
--setLevel(gLevelJumpIndex, 0)
setupWorld(gWorldIndex , true, GlobalData:getChallengeLevelIndex()+1)
local desc = gLevelDesc[gWorldIndex ]
--ChallangeMap:setLevelNameMSG(desc.levelName)
if gIs1stDemoFlag == false then
	local topScreen = ui:getScreen(2)
	anim = topScreen:playAnimation("AnimB")
	--ChallangeMap:openNextLevelNode()
end

-- hide peach as we dont need to show her
ui:getScreen(SCREEN.TOP):setVisible("N_Peach_01", gWorldIndex == endWorld)
-- show small shadow for tower, and big shadow for mega castle
ui:getScreen(SCREEN.TOP):setVisible("B_CastleSh_03", gWorldIndex == endWorld)
ui:getScreen(SCREEN.TOP):setVisible("P_TowerSh_00", gWorldIndex ~= endWorld)


ChallangeMap:markNodeAs(0, 0)

setWorldMusic()

stateMachine:requestState(MapLong_state.cDemoOpenCurtains)
--stateMachine:requestState(MapLong_state.cDemoFadeOut)
end
function onUpdatecDemoLevelWarp()

end
function onExitcDemoLevelWarp()

end
function onEntercMarioMoveToNextWorld()

local topScreen = ui:getScreen(2)
g_waitTime = 30
gMarioMoveToNextWorld = true
g_anim = topScreen:playAnimation("MoveMario_finish")
ChallangeMap:showMario(0)
ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Jump, true)
ChallangeMap:objectPlayAnim(gBowserCastleId, enumCastleAnims.Anim, false)
end
function onUpdatecMarioMoveToNextWorld()
if g_anim ~= nil then
	if g_anim:isPlaying() == false then
		if g_waitTime <= 0 then
			stateMachine:requestState(MapLong_state.cDemoCloseCurtain)
		end
		g_waitTime = g_waitTime - 1
	end
	if g_anim:getFrame() == 40 then
		ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Walk, true)
	end
end
end
function onExitcMarioMoveToNextWorld()
gWorldIndex = gWorldIndex + 1
gLevelJumpIndex= gWorldIndex
end
function onEntercMarioEnterWorld()
local topScreen = ui:getScreen(2)

ChallangeMap:showMario(0)
g_anim = topScreen:playAnimation("MoveMario_in")
ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Walk, true)
end
function onUpdatecMarioEnterWorld()
if g_anim ~= nil then
	if g_anim:isPlaying() == false then
		ChallangeMap:objectPlayAnim(gMarioId, enumMarioAnims.Stand, true)
		Sound:playSound("cm_mario_arrive")
		setMarioStartPosition(0)
		stateMachine:requestState(MapLong_state.cDisappearMario)
	end
end
end
function onExitcMarioEnterWorld()

end
function onEntercDemoUpdateTheme()
--ChallangeMap:setTransitionTheme(1, 2)
g_currentJourneyWorld = g_nextJourneyWorld
g_nextJourneyWorld = g_nextJourneyWorld + 1
endWorld = 17
if g_nextJourneyWorld >= endWorld then
	ChallangeMap:setTransitionTheme(g_currentJourneyWorld, g_currentJourneyWorld)
	endWorld = 17 -- jump to the last world
	gLevelJumpIndex = endWorld 
	stateMachine:requestState(MapLong_state.cDemoMoveKuriboJourneyOut)
else
	stateMachine:requestState(MapLong_state.cDemoMoveKuriboJourneyMiddle)
end

end
function onUpdatecDemoUpdateTheme()

end
function onExitcDemoUpdateTheme()

end
function onEntercDelayBeforeMove()
gTimer = 60
end
function onUpdatecDelayBeforeMove()
if gTimer > 0 then
	gTimer = gTimer - 1
	return
end

local desc = gLevelDesc[gWorldIndex]
if isAtBossLevel() and GlobalData:getChallengeLevelPresentationIndex() ~= -1 then
--if desc.nodeCount == gWorldLevelIndex then
	
	stateMachine:requestState(MapLong_state.cRiseTheFlag)
	--stateMachine:requestState(MapLong_state.cConversationChangeLevelStart)
	--stateMachine:requestState(MapLong_state.cMarioMoveToNextWorld)
elseif GlobalData:getChallengeLevelPresentationIndex() == -1 then
	stateMachine:requestState(MapLong_state.cDisappearMario)
else
	stateMachine:requestState(MapLong_state.cAppearNextMapPoint)
end
end
function onExitcDelayBeforeMove()

end
function onEntercDemoFadeIn()
gAnim = ui:getScreen(2):playAnimation("Map_BlackFadeIN_00")
end
function onUpdatecDemoFadeIn()

if gAnim ~= nil and gAnim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cDemoFadeLevelWarp)
end

end
function onExitcDemoFadeIn()
showSWAP(false)

if g_animSwapTrans ~= nil then
	g_animSwapTrans:pause()
	g_animSwapTrans:setFrame(0)
	local anim = ui:getScreen(2):playAnimation("BG_in")
	anim:pause()
	anim:setFrame(0)
end
end
function onEntercDemoFadeOut()
if gLevelJumpIndex ~= endWorld and gLevelJumpIndex ~= startWorld then
	showSWAP(true)
	-- hide info panel
	ui:getScreen(2):setVisible("W_InfoBG_01", false)
	
	if g_swapColors == true then
		-- black color is current world, white color is next world
		ChallangeMap:setTransitionTheme(g_nextJourneyWorld, g_currentJourneyWorld)
	else
		-- white color is current world, black color is next world
		ChallangeMap:setTransitionTheme(g_currentJourneyWorld, g_nextJourneyWorld)
	end
else
	showSWAP(false)
	-- show info panel
	ui:getScreen(2):setVisible("W_InfoBG_01", true)
end

-- hide peach as we dont need to show her
ui:getScreen(SCREEN.TOP):setVisible("N_Peach_01", gLevelJumpIndex == endWorld)
-- show small shadow for tower, and big shadow for mega castle
ui:getScreen(SCREEN.TOP):setVisible("B_CastleSh_03", gLevelJumpIndex == endWorld)
ui:getScreen(SCREEN.TOP):setVisible("P_TowerSh_00", gLevelJumpIndex ~= endWorld)


--g_swapColors = not g_swapColors

local topScreen = ui:getScreen(2)

gAnim = topScreen:playAnimation("Map_BlackFadeOUT_00")
ChallangeMap:setCurtainTheme(gLevelJumpIndex)
end
function onUpdatecDemoFadeOut()
if gAnim ~= nil and gAnim:isPlaying() == false then
	if gKuriboMove  == true then
		if gLevelJumpIndex== endWorld then
			stateMachine:requestState(MapLong_state.cDemoMoveKuriboToEndIn)
		elseif gLevelJumpIndex== startWorld then
			stateMachine:requestState(MapLong_state.cAppearMario)
		else
			stateMachine:requestState(MapLong_state.cDemoMoveKuriboJourneyIn)
		end
	else
		stateMachine:requestState(MapLong_state.cMarioEnterWorld)
	end
end
end
function onExitcDemoFadeOut()

end
function onEntercDemoFadeLevelWarp()
setupWorld(gLevelJumpIndex)
local desc = gLevelDesc[gLevelJumpIndex]
ChallangeMap:setLevelNameMSG(desc.levelName)
if gIs1stDemoFlag == false then
	local topScreen = ui:getScreen(2)
	anim = topScreen:playAnimation("AnimB")
	ChallangeMap:openNextLevelNode()
end



if gCancelActive then
	-- hide kuribos
	ui:getScreen(SCREEN.TOP):setVisible("L_WorldMapKuribo_00", false)
	showSWAP(false)
	local cancelAnim = ui:getScreen(SCREEN.TOP):playAnimation("SWAP_peac_in")
	if cancelAnim then 
		cancelAnim:stop()
		cancelAnim:setFrame(0)
	end
	cancelAnim = ui:getScreen(SCREEN.TOP):playAnimation("BG_in")
	if cancelAnim then
		cancelAnim:stop()
		cancelAnim:setFrame(0)
	end
end

stateMachine:requestState(MapLong_state.cDemoFadeOut)
end
function onUpdatecDemoFadeLevelWarp()

end
function onExitcDemoFadeLevelWarp()

end
function onEntercDebug()

end
function onUpdatecDebug()
if Input:isTriggered(BUTTON.RIGHT) then
	local nextLevel = GlobalData:getChallengeLevelIndex()
	nextLevel = nextLevel + 1
	GlobalData:setChallengeLevelIndex(nextLevel)
	gCurrentLevelIndex = GlobalData:getChallengeLevelIndex()-1
	stateMachine:requestState(MapLong_state.cInit)
end
end
function onExitcDebug()

end
function onEntercConversationChangeLevelStart()
GlobalData:clearBusy() -- let player to press start and enter Main Menu
GlobalData:skipChallengeConversation(gCanSkipConversation)
ConversationController:showBubbleNext(nil)
stateMachine:requestState(MapLong_state.cInConversationChangeLevel)
end
function onUpdatecConversationChangeLevelStart()

end
function onExitcConversationChangeLevelStart()

end
function onEntercConversationStart()
GlobalData:clearBusy() -- let player to press start and enter Main Menu
GlobalData:skipChallengeConversation(gCanSkipConversation)
ConversationController:showBubbleNext(nil)
stateMachine:requestState(MapLong_state.cInConversation)
end
function onUpdatecConversationStart()

end
function onExitcConversationStart()

end
function onEntercInConversation()

end
function onUpdatecInConversation()
if ui:isFocused() and ui:isActive() then
	-- mark dialog as seen
	gDialogSeen = 1
	-- returning back from conversation
	GlobalData:setBusy() -- from here do not let player to enter main menu
	stateMachine:requestState(MapLong_state.cTelop)
end
end
function onExitcInConversation()

end
function onEntercInConversationChangeLevel()

end
function onUpdatecInConversationChangeLevel()
if ui:isFocused() and ui:isActive() then
	-- mark dialog as seen
	gDialogSeen = GlobalData:getChallengeWorldIndex()+2 -- counting includes very first dialog before Peach capture
	-- returning back from conversation
	GlobalData:setBusy() -- from here do not let player to enter main menu
	stateMachine:requestState(MapLong_state.cMarioMoveToNextWorld)
end
end
function onExitcInConversationChangeLevel()

end
function onEntercStart()
local startLives = 10

GlobalData:startNewChallengeMapData()
ui:disableUIInput()

if GlobalData:isChallengePlaying() then
	Sound:playSound("window_in")
	ui:changeScreen("ContinueDialog", false, false, false)
	stateMachine:requestState(MapLong_state.cEndButton)
	-- want to restart
	--[[GlobalData:setChallengePlaying(false)
	GlobalData:setChallengeLevelIndex(0)
	GlobalData:setChallengeWorldIndex(0)
	GlobalData:setChallengeLevelPresentationIndex(0)
	GlobalData:writeToSaveDataChallengeMode()
	GlobalData:setRestartChallengeMap(true)
	GameState:switchScene("MarioChallangeMap")]]--
else
	-- first time play
	GlobalData:setLifes(startLives)
	ChallangeMap:setLiveCount(GlobalData:getLifes())
	stateMachine:requestState(MapLong_state.cMapIn)
end


end
function onUpdatecStart()

end
function onExitcStart()

end
function onEntercContinue()
ui:disableUIInput()
stateMachine:requestState(MapLong_state.cMapIn)



end
function onUpdatecContinue()

end
function onExitcContinue()

end
function onEntercDone()
--GameState:switchScene("MarioChallangeCourseIn", "CIRCLE")
GlobalData:setStateIdx(-1)
NN_LOG("\nCheck world")
NN_LOG(gCurrentLevelIndex)
gWorldIndex = getWorldIndex(GlobalData:getChallengeLevelIndex())
gWorldLevelIndex = getLastOpenLevel(GlobalData:getChallengeLevelIndex())
GlobalData:setAsBossStage(isBossLevel())
GlobalData:setChallengeLevelPresentationIndex(-1)
GlobalData:setChallengePlaying(true)
GlobalData:writeToSaveDataChallengeMode() -- make sure we save it later
if gDialogSeen ~= nil then
	-- mark dialog as seen
	GlobalData:setChallengeMapDialogSeen(gDialogSeen)
	gDialogSeen = nil
end
GlobalData:playMarioChallenge()
local nextWorldIndex =  getWorldIndex(gCurrentLevelIndex+2)
if nextWorldIndex ~= nil then
	NN_LOG("Next world index")
	NN_LOG(nextWorldIndex )
	GlobalData:setChallengeWorldIndex(nextWorldIndex )
else
	GlobalData:setChallengeWorldIndex(18) -- MCAT#1562 - flag that world 18 is finished
end
GameState:switchScene("MarioChallangeCourseIn")
end
function onUpdatecDone()

end
function onExitcDone()

end
function onEntercRiseTheFlag()
ChallangeMap:setWorldCleared(true)
gTimer = 60

Sound:playSound("cm_white_flag")
end
function onUpdatecRiseTheFlag()
if gTimer == 0 then
	stateMachine:requestState(MapLong_state.cConversationChangeLevelStart)
end

gTimer = gTimer - 1
end
function onExitcRiseTheFlag()

end
function onEntercFaderInToMapIn()
gFaderAnim = startFaderSquares()
end
function onUpdatecFaderInToMapIn()
if gFaderAnim == nil then
	stateMachine:requestState(MapLong_state.cMapIn)
	return
end

if gFaderAnim:isPlaying() == false then
	stateMachine:requestState(MapLong_state.cMapIn)
	return
end
end
function onExitcFaderInToMapIn()

end
function onEntercEndButton()

end
function onUpdatecEndButton()

end
function onExitcEndButton()

end
-------------------------------------------------------------
cGlobals={}
cGlobals.onEnter=onEntercGlobals
cGlobals.onUpdate=onUpdatecGlobals
cGlobals.onExit=onExitcGlobals
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cWait={}
cWait.onEnter=onEntercWait
cWait.onUpdate=onUpdatecWait
cWait.onExit=onExitcWait
cCloseCurtains={}
cCloseCurtains.onEnter=onEntercCloseCurtains
cCloseCurtains.onUpdate=onUpdatecCloseCurtains
cCloseCurtains.onExit=onExitcCloseCurtains
cWorld2={}
cWorld2.onEnter=onEntercWorld2
cWorld2.onUpdate=onUpdatecWorld2
cWorld2.onExit=onExitcWorld2
cOpenCurtains={}
cOpenCurtains.onEnter=onEntercOpenCurtains
cOpenCurtains.onUpdate=onUpdatecOpenCurtains
cOpenCurtains.onExit=onExitcOpenCurtains
cIdle={}
cIdle.onEnter=onEntercIdle
cIdle.onUpdate=onUpdatecIdle
cIdle.onExit=onExitcIdle
cMapIn={}
cMapIn.onEnter=onEntercMapIn
cMapIn.onUpdate=onUpdatecMapIn
cMapIn.onExit=onExitcMapIn
cMapInAdvance={}
cMapInAdvance.onEnter=onEntercMapInAdvance
cMapInAdvance.onUpdate=onUpdatecMapInAdvance
cMapInAdvance.onExit=onExitcMapInAdvance
cTelop={}
cTelop.onEnter=onEntercTelop
cTelop.onUpdate=onUpdatecTelop
cTelop.onExit=onExitcTelop
cMoveKuribo={}
cMoveKuribo.onEnter=onEntercMoveKuribo
cMoveKuribo.onUpdate=onUpdatecMoveKuribo
cMoveKuribo.onExit=onExitcMoveKuribo
cAppearMario={}
cAppearMario.onEnter=onEntercAppearMario
cAppearMario.onUpdate=onUpdatecAppearMario
cAppearMario.onExit=onExitcAppearMario
cAppearNextMapPoint={}
cAppearNextMapPoint.onEnter=onEntercAppearNextMapPoint
cAppearNextMapPoint.onUpdate=onUpdatecAppearNextMapPoint
cAppearNextMapPoint.onExit=onExitcAppearNextMapPoint
cMoveMarioAndStand={}
cMoveMarioAndStand.onEnter=onEntercMoveMarioAndStand
cMoveMarioAndStand.onUpdate=onUpdatecMoveMarioAndStand
cMoveMarioAndStand.onExit=onExitcMoveMarioAndStand
cMarioJumpBeforeDisappear={}
cMarioJumpBeforeDisappear.onEnter=onEntercMarioJumpBeforeDisappear
cMarioJumpBeforeDisappear.onUpdate=onUpdatecMarioJumpBeforeDisappear
cMarioJumpBeforeDisappear.onExit=onExitcMarioJumpBeforeDisappear
cDisappearMario={}
cDisappearMario.onEnter=onEntercDisappearMario
cDisappearMario.onUpdate=onUpdatecDisappearMario
cDisappearMario.onExit=onExitcDisappearMario
cEnterLevel={}
cEnterLevel.onEnter=onEntercEnterLevel
cEnterLevel.onUpdate=onUpdatecEnterLevel
cEnterLevel.onExit=onExitcEnterLevel
cDemoCancel={}
cDemoCancel.onEnter=onEntercDemoCancel
cDemoCancel.onUpdate=onUpdatecDemoCancel
cDemoCancel.onExit=onExitcDemoCancel
cDemoCloseCurtain={}
cDemoCloseCurtain.onEnter=onEntercDemoCloseCurtain
cDemoCloseCurtain.onUpdate=onUpdatecDemoCloseCurtain
cDemoCloseCurtain.onExit=onExitcDemoCloseCurtain
cDemoOpenCurtains={}
cDemoOpenCurtains.onEnter=onEntercDemoOpenCurtains
cDemoOpenCurtains.onUpdate=onUpdatecDemoOpenCurtains
cDemoOpenCurtains.onExit=onExitcDemoOpenCurtains
cDemoMoveKuriboJourneyIn={}
cDemoMoveKuriboJourneyIn.onEnter=onEntercDemoMoveKuriboJourneyIn
cDemoMoveKuriboJourneyIn.onUpdate=onUpdatecDemoMoveKuriboJourneyIn
cDemoMoveKuriboJourneyIn.onExit=onExitcDemoMoveKuriboJourneyIn
cDemoMoveKuriboJourneyMiddle={}
cDemoMoveKuriboJourneyMiddle.onEnter=onEntercDemoMoveKuriboJourneyMiddle
cDemoMoveKuriboJourneyMiddle.onUpdate=onUpdatecDemoMoveKuriboJourneyMiddle
cDemoMoveKuriboJourneyMiddle.onExit=onExitcDemoMoveKuriboJourneyMiddle
cDemoMoveKuriboJourneyOut={}
cDemoMoveKuriboJourneyOut.onEnter=onEntercDemoMoveKuriboJourneyOut
cDemoMoveKuriboJourneyOut.onUpdate=onUpdatecDemoMoveKuriboJourneyOut
cDemoMoveKuriboJourneyOut.onExit=onExitcDemoMoveKuriboJourneyOut
cDemoMoveKuriboToEndIn={}
cDemoMoveKuriboToEndIn.onEnter=onEntercDemoMoveKuriboToEndIn
cDemoMoveKuriboToEndIn.onUpdate=onUpdatecDemoMoveKuriboToEndIn
cDemoMoveKuriboToEndIn.onExit=onExitcDemoMoveKuriboToEndIn
cDemoMoveKuriboToEnd={}
cDemoMoveKuriboToEnd.onEnter=onEntercDemoMoveKuriboToEnd
cDemoMoveKuriboToEnd.onUpdate=onUpdatecDemoMoveKuriboToEnd
cDemoMoveKuriboToEnd.onExit=onExitcDemoMoveKuriboToEnd
cDemoKuriboEnterCastle={}
cDemoKuriboEnterCastle.onEnter=onEntercDemoKuriboEnterCastle
cDemoKuriboEnterCastle.onUpdate=onUpdatecDemoKuriboEnterCastle
cDemoKuriboEnterCastle.onExit=onExitcDemoKuriboEnterCastle
cPeachCallForHelp={}
cPeachCallForHelp.onEnter=onEntercPeachCallForHelp
cPeachCallForHelp.onUpdate=onUpdatecPeachCallForHelp
cPeachCallForHelp.onExit=onExitcPeachCallForHelp
cDemoLevelWarp={}
cDemoLevelWarp.onEnter=onEntercDemoLevelWarp
cDemoLevelWarp.onUpdate=onUpdatecDemoLevelWarp
cDemoLevelWarp.onExit=onExitcDemoLevelWarp
cMarioMoveToNextWorld={}
cMarioMoveToNextWorld.onEnter=onEntercMarioMoveToNextWorld
cMarioMoveToNextWorld.onUpdate=onUpdatecMarioMoveToNextWorld
cMarioMoveToNextWorld.onExit=onExitcMarioMoveToNextWorld
cMarioEnterWorld={}
cMarioEnterWorld.onEnter=onEntercMarioEnterWorld
cMarioEnterWorld.onUpdate=onUpdatecMarioEnterWorld
cMarioEnterWorld.onExit=onExitcMarioEnterWorld
cDemoUpdateTheme={}
cDemoUpdateTheme.onEnter=onEntercDemoUpdateTheme
cDemoUpdateTheme.onUpdate=onUpdatecDemoUpdateTheme
cDemoUpdateTheme.onExit=onExitcDemoUpdateTheme
cDelayBeforeMove={}
cDelayBeforeMove.onEnter=onEntercDelayBeforeMove
cDelayBeforeMove.onUpdate=onUpdatecDelayBeforeMove
cDelayBeforeMove.onExit=onExitcDelayBeforeMove
cDemoFadeIn={}
cDemoFadeIn.onEnter=onEntercDemoFadeIn
cDemoFadeIn.onUpdate=onUpdatecDemoFadeIn
cDemoFadeIn.onExit=onExitcDemoFadeIn
cDemoFadeOut={}
cDemoFadeOut.onEnter=onEntercDemoFadeOut
cDemoFadeOut.onUpdate=onUpdatecDemoFadeOut
cDemoFadeOut.onExit=onExitcDemoFadeOut
cDemoFadeLevelWarp={}
cDemoFadeLevelWarp.onEnter=onEntercDemoFadeLevelWarp
cDemoFadeLevelWarp.onUpdate=onUpdatecDemoFadeLevelWarp
cDemoFadeLevelWarp.onExit=onExitcDemoFadeLevelWarp
cDebug={}
cDebug.onEnter=onEntercDebug
cDebug.onUpdate=onUpdatecDebug
cDebug.onExit=onExitcDebug
cConversationChangeLevelStart={}
cConversationChangeLevelStart.onEnter=onEntercConversationChangeLevelStart
cConversationChangeLevelStart.onUpdate=onUpdatecConversationChangeLevelStart
cConversationChangeLevelStart.onExit=onExitcConversationChangeLevelStart
cConversationStart={}
cConversationStart.onEnter=onEntercConversationStart
cConversationStart.onUpdate=onUpdatecConversationStart
cConversationStart.onExit=onExitcConversationStart
cInConversation={}
cInConversation.onEnter=onEntercInConversation
cInConversation.onUpdate=onUpdatecInConversation
cInConversation.onExit=onExitcInConversation
cInConversationChangeLevel={}
cInConversationChangeLevel.onEnter=onEntercInConversationChangeLevel
cInConversationChangeLevel.onUpdate=onUpdatecInConversationChangeLevel
cInConversationChangeLevel.onExit=onExitcInConversationChangeLevel
cStart={}
cStart.onEnter=onEntercStart
cStart.onUpdate=onUpdatecStart
cStart.onExit=onExitcStart
cContinue={}
cContinue.onEnter=onEntercContinue
cContinue.onUpdate=onUpdatecContinue
cContinue.onExit=onExitcContinue
cDone={}
cDone.onEnter=onEntercDone
cDone.onUpdate=onUpdatecDone
cDone.onExit=onExitcDone
cRiseTheFlag={}
cRiseTheFlag.onEnter=onEntercRiseTheFlag
cRiseTheFlag.onUpdate=onUpdatecRiseTheFlag
cRiseTheFlag.onExit=onExitcRiseTheFlag
cFaderInToMapIn={}
cFaderInToMapIn.onEnter=onEntercFaderInToMapIn
cFaderInToMapIn.onUpdate=onUpdatecFaderInToMapIn
cFaderInToMapIn.onExit=onExitcFaderInToMapIn
cEndButton={}
cEndButton.onEnter=onEntercEndButton
cEndButton.onUpdate=onUpdatecEndButton
cEndButton.onExit=onExitcEndButton
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (MapLong_state._stateCount,MapLong_state.cGlobals)
stateMachine:register(MapLong_state.cGlobals,cGlobals)
stateMachine:register(MapLong_state.cInit,cInit)
stateMachine:register(MapLong_state.cWait,cWait)
stateMachine:register(MapLong_state.cCloseCurtains,cCloseCurtains)
stateMachine:register(MapLong_state.cWorld2,cWorld2)
stateMachine:register(MapLong_state.cOpenCurtains,cOpenCurtains)
stateMachine:register(MapLong_state.cIdle,cIdle)
stateMachine:register(MapLong_state.cMapIn,cMapIn)
stateMachine:register(MapLong_state.cMapInAdvance,cMapInAdvance)
stateMachine:register(MapLong_state.cTelop,cTelop)
stateMachine:register(MapLong_state.cMoveKuribo,cMoveKuribo)
stateMachine:register(MapLong_state.cAppearMario,cAppearMario)
stateMachine:register(MapLong_state.cAppearNextMapPoint,cAppearNextMapPoint)
stateMachine:register(MapLong_state.cMoveMarioAndStand,cMoveMarioAndStand)
stateMachine:register(MapLong_state.cMarioJumpBeforeDisappear,cMarioJumpBeforeDisappear)
stateMachine:register(MapLong_state.cDisappearMario,cDisappearMario)
stateMachine:register(MapLong_state.cEnterLevel,cEnterLevel)
stateMachine:register(MapLong_state.cDemoCancel,cDemoCancel)
stateMachine:register(MapLong_state.cDemoCloseCurtain,cDemoCloseCurtain)
stateMachine:register(MapLong_state.cDemoOpenCurtains,cDemoOpenCurtains)
stateMachine:register(MapLong_state.cDemoMoveKuriboJourneyIn,cDemoMoveKuriboJourneyIn)
stateMachine:register(MapLong_state.cDemoMoveKuriboJourneyMiddle,cDemoMoveKuriboJourneyMiddle)
stateMachine:register(MapLong_state.cDemoMoveKuriboJourneyOut,cDemoMoveKuriboJourneyOut)
stateMachine:register(MapLong_state.cDemoMoveKuriboToEndIn,cDemoMoveKuriboToEndIn)
stateMachine:register(MapLong_state.cDemoMoveKuriboToEnd,cDemoMoveKuriboToEnd)
stateMachine:register(MapLong_state.cDemoKuriboEnterCastle,cDemoKuriboEnterCastle)
stateMachine:register(MapLong_state.cPeachCallForHelp,cPeachCallForHelp)
stateMachine:register(MapLong_state.cDemoLevelWarp,cDemoLevelWarp)
stateMachine:register(MapLong_state.cMarioMoveToNextWorld,cMarioMoveToNextWorld)
stateMachine:register(MapLong_state.cMarioEnterWorld,cMarioEnterWorld)
stateMachine:register(MapLong_state.cDemoUpdateTheme,cDemoUpdateTheme)
stateMachine:register(MapLong_state.cDelayBeforeMove,cDelayBeforeMove)
stateMachine:register(MapLong_state.cDemoFadeIn,cDemoFadeIn)
stateMachine:register(MapLong_state.cDemoFadeOut,cDemoFadeOut)
stateMachine:register(MapLong_state.cDemoFadeLevelWarp,cDemoFadeLevelWarp)
stateMachine:register(MapLong_state.cDebug,cDebug)
stateMachine:register(MapLong_state.cConversationChangeLevelStart,cConversationChangeLevelStart)
stateMachine:register(MapLong_state.cConversationStart,cConversationStart)
stateMachine:register(MapLong_state.cInConversation,cInConversation)
stateMachine:register(MapLong_state.cInConversationChangeLevel,cInConversationChangeLevel)
stateMachine:register(MapLong_state.cStart,cStart)
stateMachine:register(MapLong_state.cContinue,cContinue)
stateMachine:register(MapLong_state.cDone,cDone)
stateMachine:register(MapLong_state.cRiseTheFlag,cRiseTheFlag)
stateMachine:register(MapLong_state.cFaderInToMapIn,cFaderInToMapIn)
stateMachine:register(MapLong_state.cEndButton,cEndButton)
stateMachine:endRegister()
end

