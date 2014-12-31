AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

cannonSounds = {}
cannonSounds[1] = "CannonShoot1.wav"
cannonSounds[2] = "CannonShoot2.wav"
cannonSounds[3] = "CannonShoot3.wav"

local health = 0
loaded = false
function ENT:Initialize()
	self.Entity:SetModel("models/hunter/plates/plate075x3.mdl")
	
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
		local view = ents.Create("prop_physics")
		view:SetModel("models/props/de_inferno/cannon_gun.mdl")
		view:SetPos(self:GetPos() + Vector(-5,35,-40))
		view:Spawn()
		view:SetAngles(Angle(0,0,8))
		view:SetParent(self)
		view:GetPhysicsObject():SetMass(1)
	end
	self:SetColor(Color(0,0,0,0))
	health = math.Round(math.Rand(80, 100))
	self.Entity:SetNoDraw( true )
end

explosives = false
cannonball = false
stuffing = false

function ENT:StartTouch( hitent )
	if hitent:GetClass() == "yp_cannonexplosive" && explosives == false then
		explosives = true
		hitent:Remove()
		hitent:EmitSound( "npc/roller/mine/rmine_reprogram.wav", 150, 50 )
	end
	if hitent:GetClass() == "yp_cannonball" && cannonball == false then
		cannonball = true
		hitent:Remove()
		hitent:EmitSound( "npc/roller/mine/rmine_reprogram.wav", 150, 50 )
	end
	if hitent:GetClass() == "yp_cannonstuffing" && stuffing == false then
		stuffing = true
		hitent:Remove()
		hitent:EmitSound("npc/roller/mine/rmine_reprogram.wav", 150, 50 )
	end
end

function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" && explosives && cannonball && stuffing then
	local ent = ents.Create("yp_cannonballsmall")
		ent:SetPos(self:GetPos() + Vector(0,0,32))
		ent:Spawn()
		local sideways = self:GetForward()
		ent:GetPhysicsObject():ApplyForceCenter(100000 * Vector(sideways.y, -sideways.x, -sideways.z * -self:GetAngles().r))
		explosives = false
		cannonball = false
		stuffing = false
		if(self.Entity != nil) then
			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart( vPoint ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 1 )
			util.Effect( "HelicopterMegaBomb", effectdata )	
			self.Entity:EmitSound(cannonSounds[math.Round(math.Rand(1,3))])
		end
	end
end

function GetHealth()
	return health
end