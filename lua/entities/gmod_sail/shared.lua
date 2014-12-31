ENT.Type 		= "anim"
ENT.PrintName		= "Sail"
ENT.Author			= "elevator13"
ENT.Base = "base_gmodentity"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false 

function ENT:WindForce(x,y) //Get our wind vars from the autorun... something wrong with this? :/

xvar = x
yvar = y

//local physobj = self.Entity:GetPhysicsObject()
//physobj:ApplyForceCenter(self.Entity:LocalToWorld(windvec))
end
