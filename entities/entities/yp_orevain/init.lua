AddCSLuaFile('init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
local self
function ENT:Initialize( )
	local models = {}
	
	self.Entity:SetModel("models/midage/objects/vein/vein.mdl", "GAME")
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
		Msg("Looks like you could mine this")
	end
end

	local slept = true

function ENT:StartTouch( hitEnt )

	if hitEnt:GetClass() == "yp_pickeaxe" && /*hitEnt:GetHealth() > 0 && woodLeft > 0 &&*/ math.Rand(0,10) >= 1  && slept == true then
		local woodChunck = ents.Create("yp_ore")
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
		
		if math.Rand(0,100) < 1 && hitEnt:GetClass() == "yp_pickaxe" then
			stump:SetPos(self:GetPos() - Vector(0,0,150))
			stump:Spawn()
			stump:Activate()
			self:Remove()
		end
	end
	Msg(hitEnt:GetClass() .. " touched me!")
end