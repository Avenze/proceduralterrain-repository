local seat = script.Parent

local maxSpeed = seat.MaxSpeed
local torque = 300000
local turnAngle = 35

local springStiffness = 425000
local springDampening = 12000

local topParent = script.Parent.Parent
local connectHingeGroup = topParent.ConnectHingeGroups

local cylinFL = connectHingeGroup.HingeConnectFL.Cylin
local cylinFR = connectHingeGroup.HingeConnectFR.Cylin
local prisBL = connectHingeGroup.HingeConnectBL.Pris
local prisBR = connectHingeGroup.HingeConnectBR.Pris

local hingeFL = connectHingeGroup.HingeConnectFL.Hinge
local hingeFR = connectHingeGroup.HingeConnectFR.Hinge
local hingeBL = connectHingeGroup.HingeConnectBL.Hinge
local hingeBR = connectHingeGroup.HingeConnectBR.Hinge

local springFL = connectHingeGroup.HingeConnectFL.Spring
local springFR = connectHingeGroup.HingeConnectFR.Spring
local springBL = connectHingeGroup.HingeConnectBL.Spring
local springBR = connectHingeGroup.HingeConnectBR.Spring

cylinFL.AngularSpeed = seat.TurnSpeed
cylinFR.AngularSpeed = seat.TurnSpeed

hingeFL.MotorMaxTorque = torque
hingeFR.MotorMaxTorque = torque
hingeBL.MotorMaxTorque = torque
hingeBR.MotorMaxTorque = torque

springFL.Damping = springDampening
springFR.Damping = springDampening
springBL.Damping = springDampening
springBR.Damping = springDampening

springFL.Stiffness = springStiffness
springFR.Stiffness = springStiffness
springBL.Stiffness = springStiffness
springBR.Stiffness = springStiffness

seat:GetPropertyChangedSignal("Throttle"):Connect(function()
	local value = seat.Throttle
	
	if value == 1 then
		hingeFR.AngularVelocity = -maxSpeed
		hingeBR.AngularVelocity = -maxSpeed
		
		hingeFL.AngularVelocity = maxSpeed
		hingeBL.AngularVelocity = maxSpeed
	elseif value == -1 then
		hingeFR.AngularVelocity = maxSpeed
		hingeBR.AngularVelocity = maxSpeed
		
		hingeFL.AngularVelocity = -maxSpeed
		hingeBL.AngularVelocity = -maxSpeed
	else
		hingeFR.AngularVelocity = 0
		hingeBR.AngularVelocity = 0
		
		hingeFL.AngularVelocity = 0
		hingeBL.AngularVelocity = 0
	end
end)

seat:GetPropertyChangedSignal("Steer"):Connect(function()
	local value = seat.Steer
	
	if value == 1 then
		--cylinFL.TargetAngle = turnAngle
		--cylinFR.TargetAngle = turnAngle
		cylinFL.LowerAngle = turnAngle
		cylinFL.UpperAngle = turnAngle
		cylinFR.LowerAngle = turnAngle
		cylinFR.UpperAngle = turnAngle
	elseif value == -1 then
		--cylinFL.TargetAngle = -turnAngle
		--cylinFR.TargetAngle = -turnAngle
		cylinFL.LowerAngle = -turnAngle
		cylinFL.UpperAngle = -turnAngle
		cylinFR.LowerAngle = -turnAngle
		cylinFR.UpperAngle = -turnAngle
	else
		--cylinFL.TargetAngle = 0
		--cylinFR.TargetAngle = 0
		cylinFL.LowerAngle = 0
		cylinFL.UpperAngle = 0
		cylinFR.LowerAngle = 0
		cylinFR.UpperAngle = 0
	end
end)