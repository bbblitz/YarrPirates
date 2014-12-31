AddCSLuaFile ("cl_init.lua") // Use some functions from the Client file
AddCSLuaFile ("shared.lua")  // Use some functions from the Shared file
include('shared.lua')

local item = {}
local description = {}
local cost = {}

description["1.00"] = "A short board"
description["2.00"] = "A longer board"
description["3.00"] = "A pallet"
description["4.00"] = "A large flat peice of wood"
description["5.00"] = "A small flat peice of wood"
description["6.00"] = "A very strong, boyent fence"
description["7.00"] = "A round table"
description["8.00"] = "A rectangle table"
description["9.00"] = "A tall pole"

item["1.00"] = "models/props_debris/wood_board06a.mdl"
item["2.00"] = "models/props_debris/wood_board07a.mdl"
item["3.00"] = "models/props_junk/wood_pallet001a.mdl"
item["4.00"] = "models/props_wasteland/wood_fence01a.mdl"
item["5.00"] = "models/props_wasteland/wood_fence02a.mdl"
item["6.00"] = "models/props_c17/FurnitureShelf001a.mdl"
item["7.00"] = "models/props_c17/FurnitureTable001a.mdl"
item["8.00"] = "models/props_c17/FurnitureTable002a.mdl"
item["9.00"] = "models/props_docks/dock01_pole01a_128.mdl"

cost["1.00"] = 1
cost["2.00"] = 2
cost["3.00"] = 4
cost["4.00"] = 10
cost["5.00"] = 5
cost["6.00"] = 15
cost["7.00"] = 6
cost["8.00"] = 7
cost["9.00"] = 9
ENT.selfPos = nil
function ENT:Initialize( )
	
	self.Entity:SetModel("models/medieval/items/workbench.mdl")
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
	umsg.Start("changeWood")
	umsg.Short(self:EntIndex())
	umsg.Short(0)
	umsg.End()
end

function ENT:Use(Activator, Caller)	
	Activator:ConCommand("sawhorseUsed " .. Activator:EntIndex())
end

function ENT:StartTouch( hitEnt )
	if (hitEnt:GetClass() == "yp_wood" and self.wood < 20) then
		hitEnt:Remove()
		self.wood = self.wood + 1
		Msg("Added one wood, wood is now " .. self.wood)
		umsg.Start("changeWood")
		umsg.Short(self.Entity:EntIndex())
		umsg.Short(self.wood)
		umsg.End()
	end
end

function makeWood (ply, cmd, args)
--	if(ply:GetPos():Distance(ENT:GetPos()) < 100) then
	sawHorse_ents = ents.FindInSphere(ply:GetPos(),128)
	if(table.Count(sawHorse_ents) > 0) then
	for k,v in pairs(sawHorse_ents) do
		if(v:GetClass() == "yp_sawhorse") then
			local sawHorse = v
			local wood = sawHorse.wood
				if(sawHorse.wood >= cost[args[1]]) then
					local board = ents.Create("prop_physics")
					board:SetPos(v:GetPos() + Vector(0,0,50))
					board:SetModel(item[args[1]])
					board:Spawn()
					//board:Wake()
					board:GetPhysicsObject():SetMass(100)
					board:Activate()
					sawHorse.wood = sawHorse.wood - cost[args[1]]
					umsg.Start("changeWood")
					umsg.Short(sawHorse:EntIndex())
					umsg.Short(sawHorse.wood)
					umsg.End()
					return board
				else
					local woodString = "Not enough wood, " .. description[args[1]] .. " requires " .. cost[args[1]] .. " wood, I'm holding " .. wood .. " wood."
					ply:PrintMessage(HUD_PRINTTALK,woodString)
				end
			end
		end
	end
end

concommand.Add( "MakeWood", makeWood )