TOOL.Category = "Construction"
TOOL.Name = "#Sails"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["windmulti"] = "2"
TOOL.ClientConVar[ "model" ] = "models/props_phx/construct/wood/wood_panel1x2.mdl"
TOOL.ClientConVar[ "useweight" ] = "1"
TOOL.ClientConVar[ "lightweight" ] = "0"
TOOL.ClientConVar[ "offset" ] = "20"

cleanup.Register( "Sails" )
if (SERVER) then
CreateConVar( "sbox_maxsails", 5 )
end

if ( CLIENT ) then

	language.Add( "Tool_sail_name", "Sailing" )
	language.Add( "Tool_sail_desc", "Made by elevator13/<MoP> Elevator" )
	language.Add( "Tool_sail_0", "Click to spawn a sail; Right click to set the sail model" )

	language.Add( "Undone_sail", "Sail Undone" )
	language.Add( "Cleanup_sail", "Sail" )
	language.Add( "Cleaned_sail", "Cleaned up all Sails" )

end

function TOOL:LeftClick( trace )

	local ply = self:GetOwner()
	
	local windmulti = self:GetClientNumber( 'windmulti' )
	local model	= self:GetClientInfo("model")
	local useweight = self:GetClientNumber( 'useweight' )
	local lightweight = self:GetClientNumber( 'lightweight' )
	local heightoffset = self:GetClientNumber( 'offset' )
	
	local Pos = trace.HitPos + Vector(0, 0, heightoffset)
	
	if ( trace.Entity:IsValid() and trace.Entity:GetClass() == "gmod_sail" ) then
	local sail = trace.Entity:GetTable()
	
	sail:Setup(windmulti, model, useweight, lightweight)
	else
	
	
	local sail = MakeSail(ply, Pos, windmulti, model, useweight, lightweight)
	
	// Undo console shizzle...
	undo.Create('Sail')
		undo.AddEntity(sail)
		undo.SetPlayer( ply )
	undo.Finish()

	// Cleanup Entry for nukebomb
	ply:AddCount('sail', sail)
	
	// THAT'S IT, WE'RE DONE!
	return true
	end
end
//*******************************************************************************
// End STOOL LeftClick Function                                                 *
//***********************************************

function TOOL:RightClick( trace )
	--set the model to be the model gained by the trace
 	if (!trace.HitPos) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if ( CLIENT ) then return true end
	
	
	if(trace.Entity:IsValid() && trace.Entity:GetClass() == "prop_physics") then

		local model=trace.Entity:GetModel()
		if(util.IsValidModel(model)) then
			Msg("Selecting sail model: "..model)
			self:GetOwner():ConCommand("sail_model "..model.."\n")
		 	self:GetOwner():PrintMessage(HUD_PRINTCENTER,"Sail model set.")
			--Msg("Using ammo: "..model)
		end

	end
	
end

function TOOL.BuildCPanel( cp )

	cp:AddControl( "Header", { Text = "#Tool_sail_name", Description = "#Tool_sail_desc" }  )
	
	local Combo = {}
	Combo["Label"] = "#Presets"
	Combo["MenuButton"] = "1"
	Combo["Folder"] = "sail"
	Combo["Options"] = {}
	Combo["Options"]["Default"] = {}
	Combo["Options"]["Default"]["sail_windmulti"] = "2"
	Combo["Options"]["Default"]["sail_model"] = ""
	Combo["Options"]["Default"]["sail_useweight"] = "1"
	Combo["Options"]["Default"]["sail_lightweight"] = "0"
	Combo["Options"]["Default"]["sail_offset"] = 20
	Combo["CVars"] = {}
	Combo["CVars"]["0"] = "sail_windmulti"
	Combo["CVars"]["1"] = "sail_model"
	Combo["CVars"]["2"] = "sail_useweight"
	Combo["CVars"]["3"] = "sail_lightweight"
	Combo["CVars"]["4"] = "sail_offset"
	
	cp:AddControl("ComboBox", Combo )
	
	cp:AddControl( 'Slider', { Label = 'Wind Multiplier', Type = "Float", Min = 1, Max = 10, Command = 'sail_windmulti' } )
	
	cp:AddControl( "Checkbox", { Label = "Use Weight", 
	Description = "Use the prop's mass or the wind multiplier", Command = "sail_useweight" } )

	cp:AddControl( 'Checkbox', { Label = 'Lightweight', Command = 'sail_lightweight' } )
	
		cp:AddControl( 'Slider', { Label = 'Height Offset', Type = "Float", Min = 10, Max = 200, Command = 'sail_offset' } )
end 

if SERVER then

	--local Cannons = {}

	function MakeSail(ply, Pos, windmulti, model, useweight, lightweight, Vel, aVel, frozen)
	
	
	local sail = ents.Create( "gmod_sail" )	
			sail:SetPos(Pos)
			sail:GetTable():Setup( windmulti, model, useweight, lightweight )
			sail:Spawn()
			
			local sailtable =
			{
				windmulti = windmulti,
				model = model,
				useweight = useweight,
				lightweight = lightweight
			}
			
			table.Merge( sail:GetTable(), sailtable )
			
			ply:AddCount( "sail", sail )
		--pl:AddCleanup( "propcannons", cannon )
		return sail
		
		
	end
	
	duplicator.RegisterEntityClass( "gmod_sail", MakeSail, "Pos", "windmulti", "model", "useweight", "lightweight", "Vel", "aVel", "frozen" )
end
	
	function TOOL:UpdateGhost( ent, player )

	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() )
	local trace 	= util.TraceLine( tr )
	
	if (!trace.Hit || trace.Entity:IsPlayer()||(trace.Entity && trace.Entity:GetClass() == "gmod_sail") ) then
		ent:SetNoDraw( true )
		return
	end	
	ent:SetPos( trace.HitPos + Vector(0, 0, self:GetClientNumber( 'offset' )) )

	
	ent:SetNoDraw( false )

end

function TOOL:Think()

	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" ) ) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,self:GetClientNumber( 'offset' )), Angle(0,0,0) )
	end
	
	self:UpdateGhost( self.GhostEntity, self:GetOwner() )
	
end
	
	
	
//end 