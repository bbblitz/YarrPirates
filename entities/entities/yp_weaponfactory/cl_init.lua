include('shared.lua')

local lmetal = 0
local entid = nil
local wFacTrack = {}
function ENT:Draw()
    self:DrawModel()
		for a,b in pairs (wFacTrack) do
			for k,v in pairs (ents.GetAll()) do
				if(v:EntIndex() == a) then
					cam.Start3D2D(v:GetPos()+Vector(0,0,50), (v:GetAngles()*-1) + Angle(0,90,90), 1)
					draw.DrawText("Metal: " .. b, "Default", 0.5, 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					cam.End3D2D()
					cam.Start3D2D(v:GetPos()+Vector(0,0,50),(v:GetAngles()*-1) + Angle(0,-90,90),1)
					draw.DrawText("Metal: " .. b, "Default", 0.5, 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					cam.End3D2D()				
				end
			end
		end
end
frame = nil

function changeMetal(mess)
	entid = mess:ReadShort()
	lmetal = mess:ReadShort()
	sawTrack[entid] = lwood
	Msg("changeMetal called, set to " .. lmetal)
	Msg("and entid set to " .. entid)

end

usermessage.Hook("changeMetal",changeMetal)

function weaponFactoryMenu (ply,cmd,args)
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
	
	description[1] = "A cannon"
	description[2] = "A cannonball"
	description[3] = "Some cannon stuffing"
	description[4] = "Some cannon explosive"
	
    item[1] = "models/props/de_inferno/cannon_gun.mdl"
	item[2] = "models/props_phx/misc/smallcannonball.mdl"
	item[3] = "models/props_c17/paper01.mdl"
	item[4] = "models/props_phx/misc/potato_launcher_explosive.mdl"
	
	cost[1] = 20
	cost[2] = 2
	cost[3] = 1
	cost[4] = 3
 
	frame:Center()
	frame:SetSize(220,200)
	frame:SetTitle("Weapon Factory")
	frame:MakePopup()
 
 	IconList:SetSpaceX(5)
	IconList:SetSpaceY(5)
	IconList:SetPos(5,5)
	IconList:SetSize(220,200)
 
	Msg("My lmetal is " .. lmetal)
	for k,v in pairs(item) do
		local icon = vgui.Create( "SpawnIcon", IconList ) 
		icon:SetModel( v )
		Msg("Makeing an icon with model " .. v)
		icon:SetSize(64,64)
		icon:SetToolTip("Cost: " .. cost[k])
		icon:SetPos(75,75)
		if(cost[k] < lmetal) then
			icon.DoClick = function( icon )
					surface.PlaySound( "ui/buttonclickrelease.wav" )
					RunConsoleCommand("MakeItem", k)
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
concommand.Add("weaponFactoryUsed", weaponFactoryMenu)