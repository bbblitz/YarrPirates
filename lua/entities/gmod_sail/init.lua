AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
self.Entity:PhysicsInit( SOLID_VPHYSICS )      // Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   // after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )         // Toolbox                
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
		mass = phys:GetMass()
	else return end 
end  


function ENT:Setup(windmulti, model, useweight, lightweight)

if useweight == 1 then
self.WindVelConfig = mass
else
self.WindVelConfig = windmulti * 10
end
self.Lightweight = lightweight

self.Entity:SetModel(model)


timer.Simple(0.5 * 0.5, self.EntStuff, self)

self.Entity:SetColor(255,255,255,255)
self.Entity:SetMaterial("models/shiny")

end

function ENT:EntStuff() //F'ing physobjects! Must get rid of this soon...
if self.Lightweight == 1 then
local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
	phys:SetMass(1)
	end
end

end


function ENT:Think()
if self.Entity:WaterLevel() == 0 then
self.WindVelocity = self.WindVelConfig * Vector(xvar,yvar,0)
local phys = self.Entity:GetPhysicsObject()
if phys:IsValid() then phys:ApplyForceCenter(self.WindVelocity) end
end
end
