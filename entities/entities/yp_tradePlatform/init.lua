AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/TrashDumpster02b.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:GetPhysicsObject():EnableMotion(false)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(5)
	end
	
	
end

function ENT:SetWinePrice(num)
	self.winePrice = num
	return num
end

function ENT:SetOrangePrice(num)
	self.orangePrice = num
	return num
end

function ENT:SetTechPrice(num)
	self.techPrice = num
	return num
end

function ENT:Payout(num, pos)
	local coin = ents.Create("yp_PoE")
	Msg("\nAttempting to set gold to " .. tostring(num))
	coin:setAmmount(num)
	coin:SetPos(pos+Vector(0,0,5))
	coin:Spawn()
end

function ENT:PhysicsCollide(dataTable,physobj)
	local ent = dataTable["HitEntity"]
	Msg("\nPlayer attempting to sell!")
	local class = ent:GetClass()
	local pos =  ent:GetPos()
	if(class == "yp_commoditya") then
		ent:Remove()
		self:Payout(self.winePrice-10, pos)
	elseif(class == "yp_commodityb") then
		ent:Remove()
		self:Payout(self.orangePrice-30, pos)
	elseif(class == "yp_commodityc") then
		ent:Remove()
		self:Payout(self.techPrice-50, pos)
	else
		Msg("\nFailed to sell a " .. tostring(class))
	end
end
