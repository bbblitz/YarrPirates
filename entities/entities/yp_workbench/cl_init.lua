include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end
frame = nil

function factoryMenu (ply,cmd,args)
	if(frame) then
		if(frame:IsVisible()) then
			frame:Remove()
		end
	end
	
    frame = vgui.Create("DFrame")
	local IconList = vgui.Create( "DPanelList", frame ) 
	
	
	local item = {}
	local description = {}
	local cost = {}
	local iconModel = {}
	
	description[1] = "An axe for gathering wood"
	description[2] = "A hammer for putting stuff togeather"
	description[3] = "A crate for holding stuff"
	
	iconModel[1] = "models/weapons/w_axe.mdl"
	iconModel[2] = "models/weapons/w_sledgehammer.mdl"
	iconModel[3] = "models/props_forest/milk_crate.mdl"
	
    item[1] = "yp_axe"
	item[2] = "yp_nailer"
	item[3] = "yp_crateA"
	
	cost[1] = 1
	cost[2] = 2
	cost[3] = 4
 
	frame:Center()
	frame:SetSize(220,200)
	frame:SetTitle("Workbench")
	frame:MakePopup()
 
 	IconList:EnableVerticalScrollbar( true ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(10,30)
	IconList:SetSize(200, 160)
 
	for k,v in pairs(item) do
			local icon = vgui.Create( "SpawnIcon", IconList ) 
			icon:SetModel( iconModel[k] )
			IconList:AddItem( icon )
			icon.DoClick = function( icon )
					surface.PlaySound( "ui/buttonclickrelease.wav" )
					RunConsoleCommand("MakeItem", k)
				end 
		end
	end
concommand.Add("factoryUsed", factoryMenu)