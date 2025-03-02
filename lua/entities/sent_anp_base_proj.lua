
AddCSLuaFile()

if (CLIENT) then
	--killicon.Add( "sent_anp_base_proj", "HUD/killicons/sparbine_missile", Color ( 255, 80, 0, 255 ) )
	language.Add( "sent_anp_base_proj", "ANPlus Base Proj" )
end

ENT.Type 					= "anim"
ENT.Base 					= "base_anim"
ENT.PrintName				= "sent_anp_base_proj"
ENT.Author					= "filz0"

ENT.Spawnable				= false
ENT.AdminSpawnable			= false
ENT.CurTurnSpeed			= 0
ENT.CurSpeed				= 0

--SETTINGS
ENT.Model 					= "models/hunter/plates/plate.mdl"
ENT.PhysicsInitType 		= SOLID_VPHYSICS
ENT.MoveType 				= MOVETYPE_VPHYSICS
ENT.MoveCollideType 		= MOVECOLLIDE_FLY_BOUNCE
ENT.CollisionGroupType 		= COLLISION_GROUP_PROJECTILE
ENT.SolidType 				= SOLID_VPHYSICS

ENT.RunCollideOnDeath		= false
ENT.UsePhysCollide			= true
ENT.Bounces					= 0
ENT.SoftBounceSND			= false
ENT.HardBounceSND			= false
ENT.TouchDelay 				= 0

ENT.ProjHealth				= false

ENT.EjectForce				= false
ENT.Thrust 					= true
ENT.ThrustTime 				= 120
ENT.Speed 					= 900
ENT.SpeedAcceleration		= 100
ENT.SpeedDeceleration		= 100
ENT.Target					= false
ENT.TurnSpeed 				= 50
ENT.TurnAcceleration		= 4

ENT.LifeTime 				= 20

ENT.CollideDecal			= false
ENT.StartSND 				= false
ENT.LoopSND 				= false
--SETTINGS

if (SERVER) then
	
	function ENT:ANPlusOnInitialize()	
	end
	function ENT:ANPlusPreInitialize()	
	end
	function ENT:ANPlusOnPhysicsObj(physObj)	
	end
	function ENT:ANPlusOnThink()	
	end
	function ENT:ANPlusOnRemove()	
	end
	function ENT:ANPlusOnDestroyed(dmg)	
	end
	function ENT:ANPlusOnCollide(data, physobj)	
	end
	
	function ENT:Initialize()
		
		self:SetModel( self.Model )
		
		self:ANPlusPreInitialize()
		
		self:PhysicsInit( self.PhysicsInitType )
		self:SetMoveType( self.MoveType )
		self:SetMoveCollide( self.MoveCollideType )
		self:SetCollisionGroup( self.CollisionGroupType )
		self:SetSolid( self.SolidType )
		--if self.ProjHealth && self.ProjHealth > 0 then self:SetHealth( self.ProjHealth ) end

		local physObj = self:GetPhysicsObject()
		if IsValid(physObj) then	
			self:ANPlusOnPhysicsObj(physObj)
		end

		local mins, maxs = self:GetCollisionBounds()
		self.m_vecCollBMins = mins
		self.m_vecCollBMaxs = maxs
		
		self:ANPlusOnInitialize()

		--phys:SetBuoyancyRatio( number buoyancy )
		self.ai_sound = ents.Create( "ai_sound" )
		self.ai_sound:SetPos( self:GetPos() )
		self.ai_sound:SetKeyValue( "volume", "100" )
		self.ai_sound:SetKeyValue( "duration", "8" )
		self.ai_sound:SetKeyValue( "soundtype", "8" )
		self.ai_sound:SetParent( self )
		self.ai_sound:Spawn()
		self.ai_sound:Activate()
		self.ai_sound:Fire( "EmitAISound", "", 1 )
		self:DeleteOnRemove( self.ai_sound )

		if self.StartSND then self:EmitSound( self.StartSND ) end
		if self.LoopSND then self:EmitSound( self.LoopSND ) end				

		timer.Simple( self.LifeTime, function()
			if !IsValid(self) then return end
			if self.Dead then SafeRemoveEntity(self) return end
			if self.RunCollideOnDeath then
				self:ANPlusOnCollide()
			else
				SafeRemoveEntity(self)
			end
		end )
		 
		local phys = self:GetMoveType() != 4 && self:GetPhysicsObject() || self
		if self.EjectForce && IsValid(phys) then			
			phys:SetVelocity( self:GetForward() * self.EjectForce )
		end
		
		timer.Simple( self.ThrustTime, function()
			if !IsValid(self) then return end
			self.Decelerate = true
		end )

		self.TouchDelay = CurTime() + self.TouchDelay
		
	end

	function ENT:OnRemove()		
		if self.StartSND then self:StopSound( self.StartSND ) end
		if self.LoopSND then self:StopSound( self.LoopSND ) end	
		self:ANPlusOnRemove()
	end

	function ENT:OnTakeDamage(dmg)
		local att = dmg:GetAttacker()
		local inf = dmg:GetAttacker()
		if IsValid(att) && att:GetClass() == self:GetClass() || IsValid(inf) && inf:GetClass() == self:GetClass() then return end
		self:ANPlusRemoveHealth( dmg:GetDamage(), 0 )
		if self.ProjHealth && self.ProjHealth > 0 && self:Health() <= 0 && !self.Dead then	
			if self.StartSND then self:StopSound( self.StartSND ) end
			if self.LoopSND then self:StopSound( self.LoopSND ) end
			self:ANPlusOnDestroyed(dmg)		
			self.Dead = true
		end
	end

	function ENT:ANPlusTouch(ent)
	end

	function ENT:Touch(ent)
		if self.TouchDelay > CurTime() then return end

		self:ANPlusTouch(ent)
	end

	function ENT:TouchCheck(ent, filter, mask, sizeMul) -- Make the projecticle use tracer detection instead of trigger so it will do stuff when it will actually touch an entity and not just it's collision bounds or any of that noise.
		
		local sizeMul = sizeMul || 1.1

		local tr = util.TraceHull( {
			start = self:GetPos(),
			endpos = self:GetPos(),
			filter = filter,
			mins = self.m_vecCollBMins * sizeMul,
			maxs = self.m_vecCollBMaxs * sizeMul,
			mask = mask
		} )
		
		return !ent:IsWorld() && tr.Hit || ent:IsWorld(), tr.Entity
	end

	function ENT:Think()
		if self.Dead then return end
		
		local phys = self:GetMoveType() != 4 && self:GetPhysicsObject() || self
		
		if self.Thrust then
				
			if IsValid(self.Target) && self.Target:ANPlusAlive() then				
				self.CurTurnSpeed = math.Approach( self.CurTurnSpeed, self.TurnSpeed, self.TurnAcceleration )
				local x = math.ApproachAngle( self:GetAngles().x, self:Point(self.Target).x, self.CurTurnSpeed )
				local y = math.ApproachAngle( self:GetAngles().y, self:Point(self.Target).y, self.CurTurnSpeed )
				local z = math.ApproachAngle( self:GetAngles().z, self:Point(self.Target).z, self.CurTurnSpeed )
				local angleApproach = Angle( x, y, z )
				--local angleLerp = LerpAngle( FrameTime() * self.CurTurnSpeed, self:GetAngles(), self:Point(self.Target) )	
				self:SetAngles( angleApproach )	
			end

			if self.Speed && self.Speed > 0 && phys:IsValid() then		
				self.CurSpeed = self.Decelerate && math.Approach( self.CurSpeed, 0, self.SpeedDeceleration ) || math.Approach( self.CurSpeed, self.Speed, self.SpeedAcceleration )
				if phys == self then
					phys:SetVelocity( self:GetForward() * self.CurSpeed )
				else
					phys:AddVelocity( self:GetForward() * self.CurSpeed )
				end								
			end			
			
		end
		
		self:ANPlusOnThink()
		
	end

	function ENT:Point(target)
		if !IsValid(target) then return end		
		local var = self:Visible( target ) && target:GetPos() + target:OBBCenter() || self:GetPos()
		local newAng = ( var - self:GetPos() ):Angle()	
		return newAng	
	end
	
	function ENT:PhysicsCollide(data, physobj)
		if self.UsePhysCollide && self.TouchDelay <= CurTime() then
			if !self.Dead then			
									
				if !self.m_bDecalPainted && self.CollideDecal then util.Decal( self.CollideDecal, data.HitPos + data.HitNormal, data.HitPos - data.HitNormal ); self.m_bDecalPainted = true end
				
				local SurTab = util.GetSurfaceData(util.GetSurfaceIndex(physobj:GetMaterial())) 
				if ( data.Speed > 40 and data.Speed <= 250 and data.DeltaTime > 0.1 ) and SurTab.impactSoftSound then
					self:EmitSound( self.SoftBounceSND || SurTab.impactSoftSound )	
				elseif ( data.Speed > 250 and data.DeltaTime > 0.1 ) and SurTab.impactHardSound then	
					self:EmitSound( self.HardBounceSND || SurTab.impactHardSound )		
				end	
					
				if self.Bounces > 0 then self.Bounces = self.Bounces - 1 end
				if self.Bounces == 0 then self:ANPlusOnCollide(data, physobj); self.Dead = true end
			end	
		end
	end

end
