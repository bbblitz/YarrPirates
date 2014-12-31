AddCSLuaFile( "cl_init.lua" ) --Tell the server that the client needs to download cl_init.lua
AddCSLuaFile( "shared.lua" ) --Tell the server that the client needs to download shared.lua
AddCSLuaFile( "sh_player.lua" )
AddCSLuaFile( "cl_hud.lua")

include( 'sh_player.lua' )
include( 'shared.lua' ) --Tell the server to load shared.lua
include( 'cl_hud.lua' )
--AddCSLuaFile( "init_nav.lua")
--include( 'init_nav.lua' )
function GM:PlayerInitialSpawn( ply ) --"When the player first joins the server and spawns" function
    ply:SetTeam( 1 ) --Add the player to team 1
	
	local gold = ply:GetPData("gold")
	local noto = ply:GetPData("notority")
	if(gold == nil) then
		ply:SetPData("gold", 50)
		ply:SetGold(50)
		ply:SetNotority(0)
	else
		ply:SetGold(gold)
		ply:SetNotority(noto)
	end
	
end --End the "when player first joins server and spawns" function

function GM:PlayerSpawn( ply )
	ply:SetGold(50)
	ply:SetNotority(1)
	ply:Give( "weapon_pickupstuff")
end

function GM:PlayerLoadout( ply ) --Weapon/ammo/item function
    ply:Give( "weapon_physcannon" )--Give them the Gravity Gun
	ply:Give( "weapon_pickupstuff")
end --Here we end the Loadout function

function printGold(ply)
	ply:ChatPrint("Gold: " .. ply:GetGold())
end

function fPlayerDisconnect( ply )
	print("Player Disconnect: Gold saved to SQLLite and TXT")
	ply:SaveGold()
	ply:SaveGoldTXT()
	ply:SaveNotority()
	ply:SaveNotorityTXT()
end

concommand.Add("gold_get", printGold)