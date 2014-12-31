AddCSLuaFile ("cl_init.lua") // Use some functions from the Client file
AddCSLuaFile ("shared.lua")  // Use some functions from the Shared file
include('shared.lua')

local item = {}
local description = {}
local cost = {}
local iconModel = {}
description["1.00"] = "An axe for gathering wood"
description["2.00"] = "A hammer for putting stuff togeather"
description["3.00"] = "A crate for holding stuff"

iconModel["1.00"] = "models/weapons/w_axe.mdl"
iconModel["2.00"] = "models/weapons/w_sledgehammer.mdl"
iconModel["3.00"] = "models/props_forest/milk_crate.mdl"

item["1.00"] = "yp_axe"
item["2.00"] = "yp_nailer"
item["3.00"] = "yp_crateA"

cost["1.00"] = 1
cost["2.00"] = 2
cost["3.00"] = 4
ENT.selfPos = nil
function ENT:Initialize( )
	
	self.Entity:SetModel("models/nayrbarr/anvil/anvil.mdl")
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
end

function ENT:Use(Activator, Caller)	
	Activator:ConCommand("factoryUsed " .. Activator:EntIndex())
end

function ENT:StartTouch( hitEnt )
	if hitEnt:GetClass() == "yp_wood" then
		hitEnt:Remove()
		self.wood = self.wood + 1
		Msg("Added one wood, wood is now " .. self.wood)
	end
end

function makeItem (ply, cmd, args)
--	if(ply:GetPos():Distance(ENT:GetPos()) < 100) then
	workBench_ents = ents.FindInSphere(ply:GetPos(),128)
	if(table.Count(workBench_ents) > 0) then
	for k,v in pairs(workBench_ents) do
		if(v:GetClass() == "yp_workbench") then
			local workBench = v
			local wood = workBench.wood
				if(workBench.wood >= cost[args[1]]) then
					local ent = ents.Create(item[args[1]])
					ent:Spawn()
					ent:SetPos(v:GetPos() + Vector(0,0,50))

					//board:Wake()
					ent:GetPhysicsObject():SetMass(100)
					ent:Activate()
					workBench.wood = workBench.wood - cost[args[1]]
					return ent
				else
					local woodString = "Not enough wood, " .. description[args[1]] .. " requires " .. cost[args[1]] .. " wood, I'm holding " .. wood .. " wood."
					ply:PrintMessage(HUD_PRINTTALK,woodString)
				end
			end
		end
	end
end

concommand.Add( "MakeItem", makeItem )