AddCSLuaFile('init.lua')
AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.AutomaticFrameAdvance = true

 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end

ENT.Spawnable = true
ENT.AdminSpawnable = true

