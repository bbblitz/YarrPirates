AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props/de_inferno/crate_fruit_break_gib2.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:Activate()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(5)
	end
	local topEnt = ents.Create("Prop_physics")
	local bottemEnt = ents.Create("Prop_physics")
	
	topEnt:SetModel("models/props_phx/wheels/magnetic_small_base.mdl")
	bottemEnt:SetModel("models/props_phx/wheels/magnetic_small_base.mdl")
	
	topEnt:SetPos(self:GetPos() + Vector(0,0,5))
	bottemEnt:SetPos(self:GetPos())
	
	topEnt:Spawn()
	bottemEnt:Spawn()
	
	topEnt:PhysicsInit( SOLID_VPHYSICS )
	bottemEnt:PhysicsInit( SOLID_VPHYSICS )
	
	topEnt:GetPhysicsObject():SetMass(5)
	bottemEnt:GetPhysicsObject():SetMass(5)
	
	topEnt:Activate()
	bottemEnt:Activate()
	
	constraint.Axis(topEnt,bottemEnt,
	0,0,
	topEnt:GetPos(),bottemEnt:GetPos()
	,0,0,
	0.2,1,
	nil)
	
	
end