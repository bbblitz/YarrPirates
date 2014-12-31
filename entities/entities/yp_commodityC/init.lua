AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local woodModels = {}
woodModels[1] = "models/dys_bike/dys_bike.mdl"
woodModels[2] = "models/vehicles/brute.mdl"
woodModels[3] = "models/warby/dys_prop_warby_spider_tank_01.mdl"

ENT.number = nil

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
		phys:SetBuoyancyRatio(0.05)
	end
	
	
end

function ENT:SetNumber(number)
	ENT.number = number
end