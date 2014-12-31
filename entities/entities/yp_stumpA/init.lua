AddCSLuaFile ("cl_init.lua") // Use some functions from the Client file
AddCSLuaFile ("shared.lua")  // Use some functions from the Shared file
include('shared.lua')
function ENT:Initialize( )
	self.Entity:SetModel("models/props_foliage/driftwood_01a.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self.Entity:SetAngles(Angle(90, 0, 0))
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
	end
 
end

function ENT:AcceptInput( Name, Activator, Caller)	
	if Name == "Use" and Caller:IsPlayer() then
		Msg("Looks like a tree stump")
	end
end