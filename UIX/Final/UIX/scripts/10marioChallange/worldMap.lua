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
static={}
worldMap_state= {
cInit=0,
cDemoMapIn=1,
c1stDemoTelopIn=2,
c1stDemoMoveKuribo=3,
c1stDemoAnimB=4,
c1stDemoAppearMario=5,
cDemoAppearNextMapPoint=6,
cDemoWalkAndStandMario=7,
_stateCount=8
}
-------------------------------------------------------------
function onEntercInit()
--[[topScreen = ui:getScreen(2)
botScreen = ui:getScreen(1)

local levelSpots = {}
levelSpots [0] = "L_WorldMapCourseEsy_00"
levelSpots [1] = "L_WorldMapCourseEsy_01"
levelSpots [2] = "L_WorldMapCourseEsy_02"
levelSpots [3] = "L_WorldMapCourseEsy_03"
levelSpots [4] = "L_WorldMapCourseEsy_04"
levelSpots [5] = "L_WorldMapCourseEsy_05"
levelSpots [6] = "L_WorldMapCourseEsy_06"
levelSpots [7] = "L_WorldMapCourseEsy_07"

for i = 0, 7, 1 do
	topScreen:setVisible(levelSpots[i], false)
end

stateMachine:requestState(worldMap_state.cDemoMapIn)]]--
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercDemoMapIn()
mapInAnim = topScreen:playAnimation("MapIn")
botScreen:playAnimation("MapIn")
end
function onUpdatecDemoMapIn()
if mapInAnim:isPlaying() == false then
	stateMachine:requestState(worldMap_state.c1stDemoTelopIn)
end
end
function onExitcDemoMapIn()

end
function onEnterc1stDemoTelopIn()
telopAnim = topScreen:playAnimation("Telop")
end
function onUpdatec1stDemoTelopIn()
if telopAnim:isPlaying() == false then
	stateMachine:requestState(worldMap_state.c1stDemoMoveKuribo)
end
end
function onExitc1stDemoTelopIn()

end
function onEnterc1stDemoMoveKuribo()
moveKuriboAnim = topScreen:playAnimation("MoveKuribo")

end
function onUpdatec1stDemoMoveKuribo()
if moveKuriboAnim:isPlaying() == false then
	stateMachine:reqestState(worldMap_state.c1stDemoAnimB)
end
end
function onExitc1stDemoMoveKuribo()

end
function onEnterc1stDemoAnimB()
animB = topScreen:playAnimation("AnimB")
end
function onUpdatec1stDemoAnimB()
if animB:isPlaying() == false then
	stateMachine:requestState(worldMap_state.c1stDemoAppearMario)
end
end
function onExitc1stDemoAnimB()

end
function onEnterc1stDemoAppearMario()
moveMarioAnim = topScreen:playAnimation("MoveMario")

end
function onUpdatec1stDemoAppearMario()
if moveMarioAnim:getFrame() <= 48.0 then return end

moveMarionAnim:pause()
stateMachine:requestState(worldMap_state.cDemoAppearNextMapPoint)

end
function onExitc1stDemoAppearMario()

end
function onEntercDemoAppearNextMapPoint()
topScreen:setVisible("L_WorldMapCourseEsy_00", true)
stateMachine:requestState(worldMap_state.cDemoWalkAndStandMario)
end
function onUpdatecDemoAppearNextMapPoint()

end
function onExitcDemoAppearNextMapPoint()

end
function onEntercDemoWalkAndStandMario()
local startFrame = 48
moveMarioAnim = topScreen:playAnimation("MoveMario")
moveMarioAnim:setFrame(startFrame)
--moveMarioAnim:play()
end
function onUpdatecDemoWalkAndStandMario()

end
function onExitcDemoWalkAndStandMario()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cDemoMapIn={}
cDemoMapIn.onEnter=onEntercDemoMapIn
cDemoMapIn.onUpdate=onUpdatecDemoMapIn
cDemoMapIn.onExit=onExitcDemoMapIn
c1stDemoTelopIn={}
c1stDemoTelopIn.onEnter=onEnterc1stDemoTelopIn
c1stDemoTelopIn.onUpdate=onUpdatec1stDemoTelopIn
c1stDemoTelopIn.onExit=onExitc1stDemoTelopIn
c1stDemoMoveKuribo={}
c1stDemoMoveKuribo.onEnter=onEnterc1stDemoMoveKuribo
c1stDemoMoveKuribo.onUpdate=onUpdatec1stDemoMoveKuribo
c1stDemoMoveKuribo.onExit=onExitc1stDemoMoveKuribo
c1stDemoAnimB={}
c1stDemoAnimB.onEnter=onEnterc1stDemoAnimB
c1stDemoAnimB.onUpdate=onUpdatec1stDemoAnimB
c1stDemoAnimB.onExit=onExitc1stDemoAnimB
c1stDemoAppearMario={}
c1stDemoAppearMario.onEnter=onEnterc1stDemoAppearMario
c1stDemoAppearMario.onUpdate=onUpdatec1stDemoAppearMario
c1stDemoAppearMario.onExit=onExitc1stDemoAppearMario
cDemoAppearNextMapPoint={}
cDemoAppearNextMapPoint.onEnter=onEntercDemoAppearNextMapPoint
cDemoAppearNextMapPoint.onUpdate=onUpdatecDemoAppearNextMapPoint
cDemoAppearNextMapPoint.onExit=onExitcDemoAppearNextMapPoint
cDemoWalkAndStandMario={}
cDemoWalkAndStandMario.onEnter=onEntercDemoWalkAndStandMario
cDemoWalkAndStandMario.onUpdate=onUpdatecDemoWalkAndStandMario
cDemoWalkAndStandMario.onExit=onExitcDemoWalkAndStandMario
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (worldMap_state._stateCount,worldMap_state.cInit)
stateMachine:register(worldMap_state.cInit,cInit)
stateMachine:register(worldMap_state.cDemoMapIn,cDemoMapIn)
stateMachine:register(worldMap_state.c1stDemoTelopIn,c1stDemoTelopIn)
stateMachine:register(worldMap_state.c1stDemoMoveKuribo,c1stDemoMoveKuribo)
stateMachine:register(worldMap_state.c1stDemoAnimB,c1stDemoAnimB)
stateMachine:register(worldMap_state.c1stDemoAppearMario,c1stDemoAppearMario)
stateMachine:register(worldMap_state.cDemoAppearNextMapPoint,cDemoAppearNextMapPoint)
stateMachine:register(worldMap_state.cDemoWalkAndStandMario,cDemoWalkAndStandMario)
stateMachine:endRegister()
end

