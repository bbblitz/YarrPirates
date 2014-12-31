local thingsToHide = {}
thingsToHide[0] = "CHudHealth"
thingsToHide[1] = "CHudBattery"
thingsToHide[2] = "CHudAmmo"
thingsToHide[3] = "CHudSecondaryAmmo"
thingsToHide[4] = "CHudChat"
thingsToHide[5] = "CHudWeaponSelection"

	

local function HideThings( name )
	for k,v in pairs(thingsToHide) do
	print("successful call to HideThings")
		if(name == v) then 
			print(v .. " has been hidden!")
			return false
		end
	end
        -- We don't return anything here otherwise it will overwrite all other 
        -- HUDShouldDraw hooks.
end
hook.Add( "HUDShouldDraw", "HideThings", HideThings )