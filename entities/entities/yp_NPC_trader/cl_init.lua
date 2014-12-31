include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end
frame = nil

function label(str, parrent)
	lab = vgui.Create("DLabel",parrent)
	lab:SetPos(1,1)
	lab:SetFont("default")
	lab:SetText(str)
	lab:SizeToContents()
	return lab
end


function traderMenu (ply,cmd,args)
	if(frame) then
		if(frame:IsVisible()) then
			frame:Remove()
		end
	end
	if(costframe) then
		if(costframe:IsVisible()) then
			costframe:Remove()
		end
	end
	
    frame = vgui.Create("DFrame")
	local IconList = vgui.Create( "DPanelList", frame )
	costframe = vgui.Create("DFrame")
	local priceTable = vgui.Create("DGrid",costframe)
	
	
	local item = {}
	local description = {}
	local cost = {}
	
	description[1] = "Barrel of wine or some shit"
	description[2] = "Crate of oranges"
	description[3] = "Something advanced-looking"
	
    item[1] = "models/props/de_inferno/wine_barrel.mdl"
	item[2] = "models/props/de_inferno/crate_fruit_break.mdl"
	item[3] = "models/dys_bike/dys_bike.mdl"
	
	cost[1] = tonumber(args[2])
	cost[2] = tonumber(args[3])
	cost[3] = tonumber(args[4])

	Msg("\nLooks like costs are:\nWine: " .. cost[1] .. "\nOranges" .. cost[2] .. "\nTech" .. cost[3])
	
	costframe:SetPos(320,370)
	costframe:SetSize(300,200)
	costframe:SetTitle("Buy/Sell prices")
	costframe:MakePopup()
	
	priceTable:SetPos(10,30)
	priceTable:SetCols(3)
	priceTable:SetColWide(100)
	
	priceTable:AddItem(label("Commodity"))
	priceTable:AddItem(label("Buy"))
	priceTable:AddItem(label("Sell"))
	
	priceTable:AddItem(label("Wine"))
	priceTable:AddItem(label(tostring(cost[1])))
	priceTable:AddItem(label(tostring(cost[1]-10)))
	
	priceTable:AddItem(label("Oranges"))
	priceTable:AddItem(label(tostring(cost[2])))
	priceTable:AddItem(label(tostring(cost[2]-30)))
	
	priceTable:AddItem(label("Tech"))
	priceTable:AddItem(label(tostring(cost[3])))
	priceTable:AddItem(label(tostring(cost[3]-50)))
 
	frame:Center()
	frame:SetSize(220,200)
	frame:SetTitle("Trader")
	frame:MakePopup()
 
 	IconList:EnableVerticalScrollbar( true ) 
 	IconList:EnableHorizontal( true ) 
 	IconList:SetPadding( 4 ) 
	IconList:SetPos(10,30)
	IconList:SetSize(200, 160)
 
	for k,v in pairs(item) do
			local icon = vgui.Create( "SpawnIcon", IconList ) 
			icon:SetModel( v )
			IconList:AddItem( icon )
			icon.DoClick = function( icon )
					surface.PlaySound( "ui/buttonclickrelease.wav" )
					RunConsoleCommand("MakeCommodity", k)
				end 
		end
	end
concommand.Add("traderUsed", traderMenu)