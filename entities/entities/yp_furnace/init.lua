AddCSLuaFile('init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
local self
function ENT:Initialize( )
	
	self.Entity:SetModel("models/nayrbarr/smelter/smelter.mdl", "GAME")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,100))
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(1000)
	end
end

function ENT:AcceptInput( Name, Activator, Caller)	
	if Name == "Use" and Caller:IsPlayer() then
		Msg("Looks like a tree")
	end
end

local slept = true
local hasFule = false
local fireEnt = nil
function ENT:StartTouch( hitEnt )
	Msg("\na" .. tostring(hitEnt:GetClass()) .. " hit me!")
	
	if hitEnt:GetClass() == "yp_wood" && hasFule == false then
		hitEnt:Remove()
		self.fireEnt = ents.Create("prop_physics")
		self.fireEnt:SetModel("models/props_junk/sawblade001a.mdl")
		self.fireEnt:SetPos(self:GetPos() + Vector(0,0,0))
		self.fireEnt:Activate()
		self.fireEnt:Spawn()
		--self.fireEnt:SetColor(Color(0,0,0,0))
		self.fireEnt:Ignite(9999999)
		self.fireEnt:GetPhysicsObject():EnableMotion(false)
		self.fireEnt:DrawShadow(false)
		hasFule = true
	end
	
	if hitEnt:GetClass() == "yp_ore" && hasFule == true && slept == true then
		Msg("Loading an ore")
		slept = false
		hasFule = false
		local oreEnt = ents.Create("prop_physics")
		oreEnt:SetModel("models/midage/items/ore/ore.mdl")
		local orePos = self:GetPos() + Vector(0,0,40)
		Msg("Ore position is  " .. tostring(orePos))
		oreEnt:SetPos(orePos)
		oreEnt:Activate()
		oreEnt:Spawn()
		oreEnt:GetPhysicsObject():EnableMotion(false)
		hitEnt:Remove()
		timer.Create( "my_timer", 3, 1, function()
			slept = true
			local scrap = ents.Create("yp_metal")
			scrap:SetPos(self:GetPos() + Vector(40,0,100))
			scrap:Spawn()
			scrap:Activate()
			oreEnt:Remove()
			self.fireEnt:Remove()
		end)
		Msg(hitEnt:GetPos())
		Msg("\n")
	end
	self:UpdateGraphic()
end
local oreModel
local woodModel
function ENT:UpdateGraphic()
	if(hasFule==true && slept==true) then --There is wood, and it's ready to go
	
	end
	if(hasFule==true && slept==false) then -- Got more wood, but not ready to smelt yet
	
	end
	if(hasFule == false && slept == true) then -- It's got wood, but no ore to smelt
	
	end
	if(hasFule == false && slept == false) then --It's burning some ore
	
	end
end