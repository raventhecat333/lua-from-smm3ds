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
TelopDialog_state= {
cInit=0,
cEnd=1,
_stateCount=2
}
-------------------------------------------------------------
function onEntercInit()
gTimer = 60
end
function onUpdatecInit()



if ui:isActive() then
	if gTimer == 0 then
		
		gTimer = -1
	elseif gTimer > 0 then
		gTimer = gTimer - 1
	end
	if ui:isIdle() then
		ui:changeScreen("Map")
	end
end
end
function onExitcInit()

end
function onEntercEnd()

end
function onUpdatecEnd()

end
function onExitcEnd()

end
-------------------------------------------------------------
cInit={}
cInit.onEnter=onEntercInit
cInit.onUpdate=onUpdatecInit
cInit.onExit=onExitcInit
cEnd={}
cEnd.onEnter=onEntercEnd
cEnd.onUpdate=onUpdatecEnd
cEnd.onExit=onExitcEnd
-------------------------------------------------------------
function register()
NN_LOG("State Machine Register")
stateMachine:startRegister (TelopDialog_state._stateCount,TelopDialog_state.cInit)
stateMachine:register(TelopDialog_state.cInit,cInit)
stateMachine:register(TelopDialog_state.cEnd,cEnd)
stateMachine:endRegister()
end

