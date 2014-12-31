AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
ENT.ammount = 0 //The ammount of gold this stack of coins is worth
function ENT:Initialize()
	self:SetModel("models/jakemodels/jk_coins.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:Activate()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
	end
	
	health = math.Round(math.Rand(80, 100))
end

function ENT:setAmmount(num)
	self.ammount = num
end

function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" && Caller:IsPlayer() then
		Caller:AddGold(self.ammount)
		self:Remove()
	end
end

function dropgold(ply,cmd,args)
	Msg("Attempted to drop " .. args[1])
	if(ply:GetGold()>tonumber(args[1]))then
		coin = ents.Create("yp_PoE")
		Msg("Dropping gold in front of " .. ply:GetName() .. " with coin is valid: ")
		Msg(coin:IsValid())
		Msg("\n player is at ")
		Msg(ply:EyePos())
		coin:SetPos(ply:EyePos() + Vector(0,0,20))
		coin:Spawn()
		coin:setAmmount(args[1])
		ply:AddGold(-args[1])
	else
		Msg("Coulden't drop " .. args[1] .. " gold, because you only have " .. ply:GetGold() .. " gold.")
	end
end

concommand.Add("dropgold",dropgold)