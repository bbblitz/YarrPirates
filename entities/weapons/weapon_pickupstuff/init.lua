AddCSLuaFile ("cl_init.lua") // Use some functions from the Client file
AddCSLuaFile ("shared.lua")  // Use some functions from the Shared file
 
include ("shared.lua")
 
SWEP.Weight = 5
SWEP.AutoSwitchTo = false  // Automatically switch to this SWep when picked up / walked over?
SWEP.AutoSwitchFrom = false
