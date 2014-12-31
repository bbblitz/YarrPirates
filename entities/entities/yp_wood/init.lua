AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local woodModels = {}
woodModels[1] = "models/props_junk/wood_crate001a_Chunk05.mdl"
woodModels[2] = "models/props_wasteland/wood_fence02a_shard01a.mdl"
woodModels[3] = "models/props_junk/wood_pallet001a_chunkb3.mdl"

function ENT:Initialize()
	self.Entity:SetModel(woodModels[math.Round(math.Rand(1,3))])
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