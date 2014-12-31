AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local health = 0

function ENT:Initialize()
	self.Entity:SetModel("models/nayrbarr/pickaxe/pickaxe.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(20)
	end
	
	health = math.Round(math.Rand(80, 100))
end

function ENT:StartTouch( hitent )
	local level = 2
	if(health > 0) then
		health = health - level
	else
		self.Entity:Remove()
	end
end

function GetHealth()
	return health
end