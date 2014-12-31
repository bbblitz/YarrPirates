include('shared.lua')

local lwood = 0
local entid = nil
local sawTrack = {}
function ENT:Draw()
    self:DrawModel()
		for a,b in pairs (sawTrack) do
			for k,v in pairs (ents.GetAll()) do
				if(v:EntIndex() == a) then
					cam.Start3D2D(v:GetPos()+Vector(0,0,50), (v:GetAngles()*-1) + Angle(0,90,90), 1)
					draw.DrawText("Wood: " .. b, "Default", 0.5, 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					cam.End3D2D()
					cam.Start3D2D(v:GetPos()+Vector(0,0,50),(v:GetAngles()*-1) + Angle(0,-90,90),1)
					draw.DrawText("Wood: " .. b, "Default", 0.5, 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					cam.End3D2D()				
				end
			end
		end
end
frame = nil

function changeWood(mess)
	entid = mess:ReadShort()
	lwood = mess:ReadShort()
	sawTrack[entid] = lwood
	Msg("changeWood called, set to " .. lwood)
	Msg("and entid set to " .. entid)

end

usermessage.Hook("changeWood",changeWood)

function sawhorseMenu (ply,cmd,args)
	if(frame) then
		if(frame:IsVisible()) then
			frame:Remove()
		end
	end
	
    frame = vgui.Create("DFrame")
	local Scroll = vgui.Create( "DScrollPanel", frame )//Create the Scroll panel
	local IconList = vgui.Create( "DIconLayout", Scroll) 
	 
	Scroll:SetSize( 220,175 )
	Scroll:SetPos(0,25)

	
	local item = {}
	local description = {}
	local cost = {}
	
	description[1] = "A short board"
	description[2] = "A longer board"
	description[3] = "A pallet"
	description[4] = "A large flat peice of wood"
	description[5] = "A small flat peice of wood"
	description[6] = "A very strong, boyent fence"
	description[7] = "A round table"
	description[8] = "A rectangle table"
	description[9] = "A tall pole"
	
    item[1] = "models/props_debris/wood_board06a.mdl"
	item[2] = "models/props_debris/wood_board07a.mdl"
	item[3] = "models/props_junk/wood_pallet001a.mdl"
	item[4] = "models/props_wasteland/wood_fence01a.mdl"
	item[5] = "models/props_wasteland/wood_fence02a.mdl"
	item[6] = "models/props_c17/FurnitureShelf001a.mdl"
	item[7] = "models/props_c17/FurnitureTable001a.mdl"
	item[8] = "models/props_c17/FurnitureTable002a.mdl"
	item[9] = "models/props_docks/dock01_pole01a_128.mdl"
	
	cost[1] = 1
	cost[2] = 2
	cost[3] = 4
	cost[4] = 10
	cost[5] = 5
	cost[6] = 15
	cost[7] = 6
	cost[8] = 7
	cost[9] = 9
 
	frame:Center()
	frame:SetSize(220,200)
	frame:SetTitle("Sawhorse")
	frame:MakePopup()
 
 	IconList:SetSpaceX(5)
	IconList:SetSpaceY(5)
	IconList:SetPos(5,5)
	IconList:SetSize(220,200)
 
	Msg("My lwood is " .. lwood)
	for k,v in pairs(item) do
		local icon = vgui.Create( "SpawnIcon", IconList ) 
		icon:SetModel( v )
		Msg("Makeing an icon with model " .. v)
		icon:SetSize(64,64)
		icon:SetToolTip("Cost: " .. cost[k])
		icon:SetPos(75,75)
		if(cost[k] < lwood) then
			icon.DoClick = function( icon )
					surface.PlaySound( "ui/buttonclickrelease.wav" )
					RunConsoleCommand("MakeWood", k)
			end
		else
			icon.PaintOver = function()
				surface.SetDrawColor(255,0,0,100)
				surface.DrawRect(0,0,60,60,100)
			end
		end
		IconList:Add( icon )
		Msg("Icon added to Iconlist")
	end
end
concommand.Add("sawhorseUsed", sawhorseMenu)