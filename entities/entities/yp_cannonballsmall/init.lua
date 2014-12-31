AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local health = 0
cannonHitSounds = {}
cannonHitSounds[1] = "CannonHit1.wav"
cannonHitSounds[2] = "CannonHit2.wav"
cannonHitSounds[3] = "CannonHit3.wav"

function ENT:Initialize()
	self.Entity:SetModel("models/props/de_inferno/crate_fruit_break_gib2.mdl")
	self.Entity:SetColor(Color(0,0,0,255))
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	self.Entity:SetMaterial("phoenix_storms/cube")
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
	end
	
	health = math.Round(math.Rand(80, 100))
end

function ENT:StartTouch( hitent )
	if(self.Entity:GetVelocity():Length() > 100 && self.Entity:GetColor() != Color(0,0,0,0)) then
		if (!hitent:IsPlayer() && hitent != nil) then
			hitent:Ignite(3, 20)
			self.Entity:SetColor(Color(0,0,0,0))
			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart( vPoint ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 1 )
			util.Effect( "HelicopterMegaBomb", effectdata )
			self:EmitSound(cannonHitSounds[math.Round(math.Rand(1,3))], 150, 50)
			timer.Create( "my_timer", 3, 1, function()
				hitent:Remove()
				self:Remove()
			end)
		else
			hitent:TakeDamage(100,nil)
		end 
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart( vPoint ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
		effectdata:SetOrigin( vPoint )
		effectdata:SetScale( 1 )
		
					end
end

function ENT:AcceptInput( Name, Activator, Caller )

end

function GetHealth()
	return health
end