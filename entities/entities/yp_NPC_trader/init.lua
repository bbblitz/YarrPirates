AddCSLuaFile ("cl_init.lua") // Use some functions from the Client file
AddCSLuaFile ("shared.lua")  // Use some functions from the Shared file
include('shared.lua')

local item = {}
local description = {}

	description["1.00"] = "Barrel of wine or some shit"
	description["2.00"] = "Crate of oranges"
	description["3.00"] = "Something advanced-looking"
	
    item["1.00"] = "yp_commodityA"
	item["2.00"] = "yp_commodityB"
	item["3.00"] = "yp_commodityC"

local traderModels = {}
traderModels[1] = "models/Humans/Group01/male_02.mdl"
traderModels[2] = "models/Humans/Group01/Male_04.mdl"
traderModels[3] = "models/Humans/Group01/Male_05.mdl"
traderModels[4] = "models/Humans/Group01/male_06.mdl"
traderModels[5] = "models/Humans/Group01/male_07.mdl"
traderModels[6] = "models/Humans/Group01/male_08.mdl"
traderModels[7] = "models/Humans/Group01/male_09.mdl"
x = 0
function ENT:Initialize( )
	self.Entity:SetModel(traderModels[math.random(1,7)])
	self.Entity:SetSolid(SOLID_BBOX)
	self.Entity:SetNPCState(NPC_STATE_SCRIPT)
	self.Entity:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self.Entity:CapabilitiesAdd(CAP_TURN_HEAD)
	self.Entity:SetHullType(HULL_HUMAN)
	self.Entity:SetHullSizeNormal()
	self.Entity:DropToFloor()
	self.Entity:Activate()
	self.winePrice = math.random(50,200)
	self.orangePrice = math.random(300,500)
	self.techPrice = math.random(600,1000)
	timer.Create( "trader" .. x .. "timer", 1000, 0, function()
		Msg("\nPrices changed!")
		self.winePrice = math.random(50,200)
		self.orangePrice = math.random(300,500)
		self.techPrice = math.random(600,1000)
		x = x+1
	end)
end
	
function ENT:Use(Activator, Caller)
	local send = "traderUsed " .. Activator:EntIndex() .. " " .. tostring(self.winePrice) .. " " .. tostring(self.orangePrice) .. " " .. tostring(self.techPrice)
	Msg("\nAttempting to send:" .. send)
	Activator:ConCommand(send)
end

function ENT:AcceptInput( Name, Activator, Caller )	
	local send = "traderUsed " .. Activator:EntIndex() .. " " .. tostring(self.winePrice) .. " " .. tostring(self.orangePrice) .. " " .. tostring(self.techPrice)
	Msg("\nAttempting to send:" .. send)
	Activator:ConCommand(send)
	if(self.TradePlatform == nil) then
		self.TradePlatform = ents.Create("yp_tradePlatform")
		self.TradePlatform:SetPos(self:GetPos() + Vector(0,0,5))
		self.TradePlatform:Activate()
		self.TradePlatform:Spawn()
		Msg("\nTrade platform is valid: " ..  tostring(self.TradePlatform:IsValid()))
		self.TradePlatform:SetWinePrice(self.winePrice)
		self.TradePlatform:SetOrangePrice(self.orangePrice)
		self.TradePlatform:SetTechPrice(self.techPrice)
	end
end

function makeCommodity (ply, cmd, args)
	Msg("\nAttempting to make a commodity")
	trader_ents = ents.FindInSphere(ply:GetPos(),128)
	if(table.Count(trader_ents) > 0) then
		Msg("\nI found some ents!")
		for k,v in pairs(trader_ents) do
			if(v:GetClass() == "yp_npc_trader") then
				Msg("\nTrader found")
				local trader = v
				local Gold = ply:GetGold()
				Msg("\nGold is" .. Gold)
				Msg("\nPrices:")
				Msg("\nWine: " .. v.winePrice)
				Msg("\nOrange: " .. v.orangePrice)
				Msg("\nTech: " .. v.techPrice)
				local cost = {}
				cost["1.00"] = v.winePrice
				cost["2.00"] = v.orangePrice
				cost["3.00"] = v.techPrice
				Msg("\nAttempting to take " .. cost[args[1]])
				if(ply:GetGold() >= tonumber(cost[args[1]])) then
					ply:SetGold(ply:GetGold() - tonumber(cost[args[1]]))
					Msg("\nI managed to take it!")
					local commodity = ents.Create(item[args[1]])
					commodity:SetModel(item[args[1]])
					commodity:Spawn()
					//board:Wake()
					commodity:GetPhysicsObject():SetMass(100)
					commodity:Activate()
					local spawnpos = ply:GetPos() + (ply:GetRight()*50) + Vector(0,0,10)
					Msg("Setting commodity pos to " .. tostring(spawnpos))
					commodity:SetPos(spawnpos)
					Msg("\nI spawned it n' stuff!")
					return commodity
				else
					local woodString = "You don't have enough money for that!"
					Msg(woodString)
				end
			else
				Msg("\nThat wasn't a trader, it was a " .. v:GetClass())
			end
		end
		Msg("\nI didn't fide a trader! D:")
	end
end

concommand.Add( "MakeCommodity", makeCommodity )