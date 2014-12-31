AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local oreModels = {}
oreModels[1] = "models/pg_props/pg_obj/pg_ore_piece.mdl"
oreModels[2] = "models/midage/items/ore/ore.mdl"

function ENT:Initialize()
	self.Entity:SetModel(oreModels[math.Round(math.Rand(1,2))])
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