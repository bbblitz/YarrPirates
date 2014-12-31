AddCSLuaFile('init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
local self
function ENT:Initialize( )
	local models = {}
	models[1] = "models/props_foliage/tree_deciduous_01a.mdl"
	models[2] = "models/props_foliage/tree_deciduous_02a.mdl"
	models[3] = "models/props_foliage/tree_deciduous_01a-lod.mdl"
	models[4] = "models/props_foliage/tree_deciduous_03a.mdl"
	models[5] = "models/props_foliage/tree_deciduous_03b.mdl"
	
	self.Entity:SetModel(models[math.Round(math.Rand(1,5))], "GAME")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,100))
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(1000)
	end
end

function ENT:AcceptInput( Name, Activator, Caller)	
	if Name == "Use" and Caller:IsPlayer() then
		Msg("Looks like a tree")
	end
end

	local slept = true

function ENT:StartTouch( hitEnt )

	if hitEnt:GetClass() == "yp_axe" && /*hitEnt:GetHealth() > 0 && woodLeft > 0 &&*/ math.Rand(0,10) >= 1  && slept == true then
		local woodChunck = ents.Create("yp_wood")
		woodChunck:SetPos(hitEnt:GetPos())
		woodChunck:Spawn()
		woodChunck:Activate()
		slept = false
		timer.Create( "my_timer", 1, 0, function()
			slept = true
		end)
--		self:GetPhysicsObject():Sleep()
		Msg(hitEnt:GetPos())
		Msg("\n")
		--woodLeft = woodLeft -1
		
		if math.Rand(0,100) < 1 && hitEnt:GetClass() == "yp_axe" then
		local stump = ents.Create("yp_stumpA")
		stump:SetPos(self:GetPos() - Vector(0,0,150))
		stump:Spawn()
		stump:Activate()
		self:Remove()
	end
	end
	Msg(hitEnt:GetClass() .. " touched me!")
end