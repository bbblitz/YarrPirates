AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_sledgehammer.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
	end
	
	health = math.Round(math.Rand(80, 100))
end
ENT.targ1 = nil
ENT.targ2 = nil
function ENT:StartTouch( hitent )
	local level = 2
	if math.Round(math.Rand(0,100)) > 1 then
		local pos = self.Entity:GetPos() + Vector(0,0,50)
		local ang = self.Entity:GetAngles()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+Vector(ang*80)
		tracedata.filter = self.Owner
		local trace = util.TraceLine(tracedata)
		local target = hitent
		if ((self.targ1 == nil or !self.targ1:IsValid()) and !target:IsPlayer() and target != self.targ2) then
			self.targ1 = target
			self.targ1:SetColor(Color(0,61,0, 255))
			Msg("Makeing the entity ent1 because targ1 is not equal to nil")
		else
			if((self.targ2 == nil or !self.targ2:IsValid()) and !target:IsPlayer() and target != self.targ1) then
				self.targ2 = target
				self.targ2:SetColor(Color(255,255,255, 255))
				Msg("Setting shit back to it's normal colors")
			else
				Msg("Failed both checks because targ1 and targ2 are nil")
			end
			Msg("Makeing the entity targ2")
			self.targ2 = target
			self.targ2:SetColor(Color(0,0,61, 255))
		end
	else
		self.targ1:SetColor(Color(255,255,255, 255))
		self.targ2:SetColor(Color(255,255,255, 255))
		self.Entity:Remove()
	end
end

function ENT:AcceptInput( Name, Activator, Caller )
	if (Name == "Use" and self.targ1 != nil and self.targ1:IsValid() and self.targ2 !=nil and self.targ2:IsValid()) then
		constraint.Weld(self.targ1, self.targ2, 0, 0, 10000)
		self.targ1:SetColor(Color(255,255,255, 255))
		self.targ2:SetColor(Color(255,255,255, 255))
		self.targ1 = nil
		self.targ2 = nil
	end
end