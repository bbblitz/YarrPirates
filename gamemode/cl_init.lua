include( 'shared.lua' ) --Tell the client to load shared.lua
include( 'sh_player.lua' )

local thingsToHide = {}
thingsToHide[0] = "CHudHealth"
thingsToHide[1] = "CHudBattery"
thingsToHide[2] = "CHudAmmo"
thingsToHide[3] = "CHudSecondaryAmmo"
thingsToHide[4] = "CHudChat"
thingsToHide[5] = "CHudWeaponSelection"

local font = "Default"

local function HideThings( name )
	for k,v in pairs(thingsToHide) do
		if(name == v) then 
			return false
		end
	end
        -- We don't return anything here otherwise it will overwrite all other 
        -- HUDShouldDraw hooks.
end

local function pirateHUD()
	local client = LocalPlayer()
	if !(client:Alive()) then return end
	draw.RoundedBox(10,ScrW()/16,ScrH() - ScrH()/10, 320,50,Color(50,50,50,150))
	draw.RoundedBox(8,ScrW()/16 + 5,ScrH() - ScrH()/10 + 5, client:Health() * 3 + 10, 40, Color(200,0,0,255))
	
	draw.RoundedBox(0,0,0,100,200,Color(0,0,0,120))
	draw.TexturedQuad
	{
	texture = surface.GetTextureID "gui/gradient",
	color = Color(10, 10, 10, 120),
	x = 100,
	y = 00,
	w = 100,
	h = 200
	}
	draw.DrawText("Gold : " .. client:GetGold(),"Default",35,15,Color(200,200,0,255),TEXT_ALIGN_LEFT)
	draw.TexturedQuad
	{
	texture = surface.GetTextureID "gui/gradient",
	color = Color(10, 10, 10, 120),
	x = 10,
	y = 10,
	w = 20,
	h = 20
	}
	local  NColor = Color(0,0,0)
	local Alignment = ""
	local AColor = Color(0,0,0)
	if(client:GetNotority() > 0) then
		NColor = Color(50,250,50)
		AColor = Color(100,100,255)
		Alignment = "Lawfull"
	else
		if(client:GetNotority() < 0) then
			NColor = Color(250,50,50)
			AColor = Color(200,200,200)
			Alignment = "Pirate"
		else
			NColor = Color(155,155,155)
			AColor = Color(50,50,50)
			Alignment = "Citizen"
		end
	end	
	draw.DrawText("Notority : " .. client:GetNotority(), "Default", 35, 45,NColor,TEXT_ALIGN_LEFT)
	draw.TexturedQuad
	{
	texture = surface.GetTextureID "gui/gradient",
	color = Color(10, 10, 10, 120),
	x = 10,
	y = 40,
	w = 20,
	h = 20
	}
	draw.DrawText(Alignment, "Default", 35, 75, AColor,TEXT_ALIGN_LEFT)
	draw.TexturedQuad
	{
	texture = surface.GetTextureID "gui/gradient",
	color = Color(10, 10, 10, 120),
	x = 10,
	y = 70,
	w = 20,
	h = 20
	}
	local skill = client:GetSkill()
	draw.DrawText(skill, "Default", 35, 115, Color(0,0,0), TEXT_ALIGN_LEFT)
	draw.TexturedQuad
	{
	texture = surface.GetTextureID "gui/gradient",
	color = Color(10, 10, 10, 120),
	x = 10,
	y = 100,
	w = 20,
	h = 20
	}
	local CompanionStats = ""
	draw.DrawText(CompanionStats, "Default", 35, 135, Color(0,0,0), TEXT_ALIGN_LEFT)

end

hook.Add( "HUDShouldDraw", "HideThings", HideThings )
hook.Add("HUDPaint", "DrawBox", pirateHUD);
