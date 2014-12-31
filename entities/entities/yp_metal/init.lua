AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local woodModels = {}
woodModels[1] = "models/props_debris/metal_panelshard01a.mdl"
woodModels[2] = "models/props_debris/metal_panelshard01b.mdl"
woodModels[3] = "models/props_debris/metal_panelshard01c.mdl"
woodModels[4] = "models/props_debris/metal_panelshard01d.mdl"

function ENT:Initialize()
	self.Entity:SetModel(woodModels[math.Round(math.Rand(1,4))])
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(5)
	end
	
	
end