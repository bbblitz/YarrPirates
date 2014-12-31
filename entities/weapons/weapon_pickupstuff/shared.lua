
SWEP.Author             = "Blueball Blitz"
SWEP.Contact            = "LEAVE ME ALONE!"
SWEP.Purpose            = "Dunno"
SWEP.Instructions       = "Dunno"
/////////////////////////////////////////////////
 
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/weapons/w_hands.mdl"

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

ShootSound = Sound ("Metal.SawbladeStick")
 
 
SWEP.upright = nil
function SWEP:Reload()
	if (upright == false) then
		upright = true
	else
		if (upright == true) then
			upright = false
		end
	end
end
 
 
SWEP.target = nil
SWEP.held = nil
SWEP.phys = nil
SWEP.invisEnt = nil
SWEP.origAngle = nil
SWEP.eyeAngle = nil
SWEP.isSwinging = nil
 
 
//--------------------------------------------
// Called when the player Uses secondary attack
//--------------------------------------------
function SWEP:SecondaryAttack()
	if (!held) then
		//Finds out if the player wants to pick something up
		pos = self.Owner:GetShootPos()
		ang = self.Owner:GetAimVector()
		tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*80)
		tracedata.filter = self.Owner
		trace = self.Owner:GetEyeTrace()
		target = trace.Entity
		/////////////////////////////////////////////////////
		if(target:GetPhysicsObject():IsValid() && !(target:IsPlayer())) then
			//Make sure that it's something we're allowed to pick up (weight must be under 125)
		   if(target:GetPhysicsObject():GetMass() < 125  && self.Owner:GetPos():Distance(target:GetPos()) < 100 && !held) then
			   held = true
			   target:SetColor(Color(200,200,200,255))
			   self.Owner:SetRunSpeed(500 - (target:GetPhysicsObject():GetMass() * 4))
			   self.Owner:SetWalkSpeed(250 - (target:GetPhysicsObject():GetMass() * 2))
			   phys = target:GetPhysicsObject()
	--		   target:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*75)
				target:SetGravity(0)
			    //Use an invisible entity to hold on to whatever it is
				invisEnt = ents.Create("prop_physics")
				--invisEnt:SetPos(target:GetPos())
				invisEnt:SetPos(trace.HitPos)
				invisEnt:SetModel("models/props_borealis/door_wheel001a.mdl")
				invisEnt:PhysicsInit(SOLID_VPHYSICS)
				invisEnt:SetMoveType( MOVETYPE_VPHYSICS )
				invisEnt:Spawn()
				invisEnt:GetPhysicsObject():SetMass(target:GetPhysicsObject():GetMass())
				invisEnt:SetColor(Color(10,10,10,10))
				local bone = math.Clamp(trace.PhysicsBone,0,1)
				//If the force is greater than 10000, your grip on the item breaks
				weldC = constraint.Weld(target,invisEnt,0,0,10000,true)
			end
		end
		Msg(self.Owner:GetPos():Length(target:GetPos()))
	else //If we're already holding something
		//Drop it if we don't want to do anything else with it
		if(held && target != nil && phys != nil && target:IsValid()) then
			phys = target:GetPhysicsObject()
			phys:EnableMotion(true)
			invisEnt:Remove()
			target:SetColor(Color(255,255,255,255))
			target:SetGravity(600)
		end
		//If we've reloaded a cannon or something and the entit isn't there anymore, reset everything
		if(held && target == nil) then
			self.SecondaryAttack()
		end
		held = false
		target = nil
		upright = false
		self:EmitSound(ShootSound)
		self.Owner:SetRunSpeed(500)
		self.Owner:SetWalkSpeed(250)
		phys = nil
		origAngle = nil
		eyeAngle = nil
		percisionMode=0
	end
	
 
	// Any Code you want to my executed when the player uses secondary attack goes in here
	self:EmitSound(ShootSound)
end

local oldAng = nil
function SWEP:Think()
	if held and target != nil and target:IsValid() then
		invisEnt:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*75)
	else
		//Reset if the entity we're holding no longer exists
		if (held and target != nil) then
			self:SecondaryAttack()
			self:PrimaryAttack()
		end
	end
	if (upright == true && held) then
		//target:PointAtEntity(self)
		invisEnt:GetPhysicsObject():SetMass(target:GetPhysicsObject():GetMass())
		invisEnt:PointAtEntity(self.Owner)
		Msg(self.Owner:GetAimVector())
	end
	if(!self.Owner:Alive() or ((weldC) and !weldC:IsValid())) then
		target = nil
		upright = false
		held = nil
		if(invisEnt != nil && invisEnt:IsValid()) then
			invisEnt:Remove()
			self.Owner:SetRunSpeed(500)
			self.Owner:SetWalkSpeed(250)
			target = nil
			upright = false
			held = nil
			percisionMode=0
		end
	end
	if(held && target != nil && percisionMode==1) then
		phys = target:GetPhysicsObject()
		ang = phys:GetAngles()
		--self.Owner:Freeze(true) //Make sure the player dosen't move
		eyeAngle = self.Owner:EyeAngles()
		if(origAngle == nil)then
			oldAng = self.Owner:EyeAngles()
			origAngle = self.Owner:EyeAngles()
		end
		origAngle = origAngle + (oldAng - self.Owner:EyeAngles())*6
		target:GetPhysicsObject():SetAngles(origAngle)
		oldAng = self.Owner:GetAngles()
		self.Owner:SetRunSpeed(0.000001)
		self.Owner:SetWalkSpeed(0.000001)
	else
		if(target != nil) then
			self.Owner:SetRunSpeed(500 - (target:GetPhysicsObject():GetMass() * 4))
			self.Owner:SetWalkSpeed(250 - (target:GetPhysicsObject():GetMass() * 2))
		end
	end
end

//Allow the player to throw what he is looking at.
function SWEP:PrimaryAttack()
	Msg("Primary attack detected")
	if(self.Owner:KeyPressed(MOUSE_LEFT)) then
		//Change percision mode, if the player dosen't want to throw something
		if(percisionMode==1) then
			percisionMode=0
			Msg("Percision Mode Off")
		else
			percisionMode=1
			Msg("Percision Mode on")
		end
		
		//Do the throwing if they're still looking at the same place
		startAng = self.Owner:EyeAngles()
		timer.Create("throwtimer",0.5,1,function()
			if(self.Owner:EyeAngles() == startAng && target != nil && held) then //If the mouse was held for a half-second, and the view angle didn't change, throw
				target:GetPhysicsObject():ApplyForceCenter(self.Owner:EyeAngles():Forward()*600*target:GetPhysicsObject():GetMass())
				invisEnt:Remove()
				self.Owner:SetRunSpeed(500)
				self.Owner:SetWalkSpeed(250)
				target = nil
				upright = false
				held = nil
		end
	end)
	end
end
 
 function SWEP:ShouldDropOnDie()
	return false
end

	

function SWEP:DrawHUD()
	draw.SimpleText("<>","Default",ScrW() / 2, ScrH() / 2,Color(255,0,0,255))
end