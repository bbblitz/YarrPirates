AddCSLuaFile ("cl_init.lua") // Use some functions from the Client file
AddCSLuaFile ("shared.lua")  // Use some functions from the Shared file
include('shared.lua')

local item = {}
local description = {}
local cost = {}

description["1.00"] = "A cannon"
description["2.00"] = "A cannonball"
description["3.00"] = "Some cannon stuffing"
description["4.00"] = "Some cannon explosive"

item["1.00"] = "yp_smallcannon"
item["2.00"] = "yp_cannonballsmall"
item["3.00"] = "yp_cannonstuffing"
item["4.00"] = "yp_cannonexplosive"

cost["1.00"] = 20
cost["2.00"] = 2
cost["3.00"] = 1
cost["4.00"] = 3
ENT.selfPos = nil
function ENT:Initialize( )
	
	self.Entity:SetModel("models/medieval/manvil.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
	end
	self.selfPos = self.Entity
	umsg.Start("changeMetal")
	umsg.Short(self:EntIndex())
	umsg.Short(0)
	umsg.End()
end

function ENT:Use(Activator, Caller)	
	Activator:ConCommand("weaponFactoryUsed " .. Activator:EntIndex())
end

function ENT:StartTouch( hitEnt )
	if (hitEnt:GetClass() == "yp_metal" and self.metal < 20) then
		hitEnt:Remove()
		self.metal = self.metal + 1
		Msg("Added one metal, metal is now " .. self.wood)
		umsg.Start("changeMetal")
		umsg.Short(self.Entity:EntIndex())
		umsg.Short(self.metal)
		umsg.End()
	end
end

function makeItem (ply, cmd, args)
--	if(ply:GetPos():Distance(ENT:GetPos()) < 100) then
	weaponFactory_ents = ents.FindInSphere(ply:GetPos(),128)
	if(table.Count(weaponFactory_ents) > 0) then
	for k,v in pairs(weaponFactory_ents) do
		if(v:GetClass() == "yp_weaponfactory") then
			local weaponFactory = v
			local metal = weaponFactory.metal
				if(weaponFactory.metal >= cost[args[1]]) then
					local thing = ents.Create(item[args[1]])
					thing:SetPos(v:GetPos() + Vector(0,0,50))
					thing:Spawn()
					thing:GetPhysicsObject():SetMass(100)
					thing:Activate()
					weaponFactory.metal = weaponFactory.metal - cost[args[1]]
					umsg.Start("changeWood")
					umsg.Short(weaponFactory:EntIndex())
					umsg.Short(weaponFactory.metal)
					umsg.End()
					return thing
				else
					local metalString = "Not enough metal, " .. description[args[1]] .. " requires " .. cost[args[1]] .. " metal, I'm holding " .. metal .. " metal."
					ply:PrintMessage(HUD_PRINTTALK,metalString)
				end
			end
		end
	end
end

concommand.Add( "MakeItem", makeItem )