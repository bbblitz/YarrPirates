include('shared.lua')
local self
function ENT:Initialize( )
	local models = {}
	models[1] = "models/props_foliage/tree_slice_chunk03.mdl"
	
	self.Entity:SetModel(models[math.Round(math.Rand(1,1))])
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
--	self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,100))
	local phys = self:GetPhysicsObject()
--	phys:EnableMotion(false)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(100)
		self.Entity:Activate()
	end
end

function ENT:AcceptInput( Name, Activator, Caller)	
	if Name == "Use" and Caller:IsPlayer() then
		Msg("Looks like a tree")
	end
end

function ENT:StartTouch( hitEnt )
	if (hitEnt:GetClass() == "yp_axe") then
		for i=1,5 do
			local woodChunck = ents.Create("yp_wood")
			woodChunck:SetPos(hitEnt:GetPos())
			woodChunck:Spawn()
			woodChunck:Activate()
			Msg(hitEnt:GetPos())
			Msg("\n")
		end
		self.Entity:Remove()
	end
	Msg(hitEnt:GetClass() .. " touched me!")
end