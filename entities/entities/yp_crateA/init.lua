AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')



function ENT:Initialize()
	self.Entity:SetModel("models/hunter/plates/plate05x075.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
		local view = ents.Create("prop_dynamic")
		view:SetModel("models/props_phx/empty_barrel.mdl")
		view:Spawn()
		view:Activate()
		--view:SetAngle(Angle(90,0,90))
		constraint.Weld(self.Entity,view,0,0,0,true)
	end
	self.Entity:SetColor(Color(255,255,255,255))
	--self.Entity:SetNoDraw(true)
end

function ENT:StartTouch( hitent )

	if !(hitent:IsPlayer()) && hitent:GetPhysicsObject():GetMass() < 10 then
		constraint.Weld(self.Entity, hitent, 0, 0, 1000, true)
		--hitent:GetPhysicsObject():SetMass(1)
	end

end