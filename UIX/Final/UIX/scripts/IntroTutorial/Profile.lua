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
Profile_state= {
cInit=0,
cWait=1,
cBlock=2,
_stateCount=3
}
-------------------------------------------------------------
function onEntercInit()
gNeedOpenSound = true
gNeedCloseSound = true
gReachedIdle = false
gIsOpen = false
stateMachine:requestState(Profile_state.cWait)
end
function onUpdatecInit()

end
function onExitcInit()

end
function onEntercWait()
topScreen = ui:getScreen(SCREEN.TOP)
botScreen = ui:getScreen(SCREEN.BOTTOM)
active = gIsOpen
end
function onUpdatecWait()
prevActive = active
active = ui:isActive()

if prevActive ~= active then
	if active then
		gIsOpen = true
		if gNeedOpenSound == true then
			Sound:playSound("cw_pageopen")
			gNeedOpenSound = false
		end
		-- this will setup the Local profile if the data hasn't yet been done
		Profile:beginProfile()

		--Set super mario challenge numbers
		Profile:setNormalMedalCount()
		Profile:setSpecialMedalCount()
		Profile:setChallengeCoursesCleared()
		
		--Set mii picture and name
		Profile:setMiiPicture()
		Profile:setFlag()
		--Set profile updated info

		--Set Sharing and Streetpass numbers
		Profile:setStreetPassExchanges()
		Profile:setLocalShareExchanges()

		-- Set 100 mario challenge numbers
		Profile:setEasyClears()
		Profile:setNormalClears()
		Profile:setExpertClears()
		Profile:setSuperExpertClears()

		--Set Course World Numbers numbers
		Profile:setCoursesPlayed()
		Profile:setCoursesCleared()
		Profile:setTotalPlays()
		Profile:setLivesLost()
	else
		gIsOpen = false
		gNeedOpenSound = true
		gNeedCloseSound = true
		gReachedIdle = false
		Profile:endProfile()
	end
elseif active == true then
	if ui:isIdle() == true then
		gReachedIdle = true
	else
		if gNeedCloseSound == true and gReachedIdle == true then
			Sound:playSound("cw_pageclose")
			gNeedCloseSound = false
		end
	end
end
end
function onExitcWait()

end
function onEntercBlock()
Profile:blockUIStateBegin()
      
end
function onUpdatecBlock()
if Profile:getIsInBlockUIState() == false then
	stateMachine:requestState(Profile_state.cWait)
end
      
end
function onExitcBlock()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cWait={}
cWait.onEnter=onEntercWait
cWait.onUpdate=onUpdatecWait
cWait.onExit=onExitcWait
cBlock={}
cBlock.onEnter=onEntercBlock
cBlock.onUpdate=onUpdatecBlock
cBlock.onExit=onExitcBlock
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (Profile_state._stateCount,Profile_state.cInit)
stateMachine:register(Profile_state.cInit,cInit)
stateMachine:register(Profile_state.cWait,cWait)
stateMachine:register(Profile_state.cBlock,cBlock)
stateMachine:endRegister()
end

