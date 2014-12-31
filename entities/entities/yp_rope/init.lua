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
end

ENT.targ1 = nil
ENT.targ2 = nil
ENT.targ1Pos = nil
ENT.targ2Pos = nil
function ENT:StartTouch( hitent )
	local level = 2
	if math.Round(math.Rand(0,100)) > 1 then
		local pos = self.Entity:GetPos() + Vector(0,0,50)
		local ang = self.Entity:GetAngles()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*80)
		tracedata.filter = self.Owner
		local trace = util.TraceLine(tracedata)
		local target = hitent
		if self.targ1 == nil && !target:IsPlayer() then
			self.targ1 = target
			self.targ1Pos = self.Entity:GetPos()
			self.targ1:SetColor(Color(0,61,0, 255))
			
		else
			if self.targ2 != nil && !target:IsPlayer() then
				self.targ2:SetColor(Color(255,255,255, 255))
			end
			self.targ2 = target
			self.targ2Pos = self.Entity:GetPos()
			self.targ2:SetColor(Color(0,0,61, 255))
		end
	else
		self.Entity:Remove()
	end
end

function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" && self.targ1 != nil && self.targ2 !=nil && self.targ1Pos != nil && self.targ2Pos != nil then
		constraint.Weld(self.targ1, self.targ2, 0, 0, 10000)
		local length = self.targ1Pos:Distance(self.targ2Pos) + 20
		local constraint, rope = constraint.Rope( self.targ1, self.targ2, 0, 0,self.targ1Pos, self.targ2Pos, length, 0, 5000, 2, "cable/rope", false )
		self.targ1:SetColor(Color(255,255,255, 255))
		self.targ2:SetColor(Color(255,255,255, 255))
		self.targ1 = nil
		self.targ2 = nil
		self.targ1Pos = nil
		self.targ2Pos = nil
	end
end
	