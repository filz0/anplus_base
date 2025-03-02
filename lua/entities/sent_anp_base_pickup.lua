AddCSLuaFile()

if (CLIENT) then
	--killicon.Add( "sent_anp_base_proj", "HUD/killicons/sparbine_missile", Color ( 255, 80, 0, 255 ) )
	language.Add( "sent_anp_base_pickup", "ANPlus Base Pickup" )
end

ENT.Type 					= "anim"
ENT.Base 					= "base_anim"
ENT.PrintName				= "sent_anp_base_pickup"
ENT.Author					= "filz0"

ENT.Spawnable				= false
ENT.AdminSpawnable			= false

--SETTINGS
ENT.m_sModel 				= "models/hunter/plates/plate.mdl"
ENT.m_fPhysicsInitType 		= SOLID_VPHYSICS
ENT.m_fMoveType 			= MOVETYPE_VPHYSICS
ENT.m_fMoveCollideType 		= MOVECOLLIDE_DEFAULT
ENT.m_fCollisionGroupType 	= COLLISION_GROUP_WEAPON
ENT.m_fSolidType 			= SOLID_VPHYSICS

ENT.m_fLifeTime 			= 20
ENT.m_fTouchDelay 			= 0
ENT.m_fPickupRadius			= 1

--SETTINGS

if (SERVER) then
	
	function ENT:ANPlusPreInitialize()	
	end
	function ENT:ANPlusOnInitialize()	
	end
	function ENT:ANPlusOnPhysicsObj(physObj)	
	end
	function ENT:ANPlusOnThink()	
	end
	function ENT:ANPlusOnRemove()	
	end
	function ENT:ANPlusOnDestroyed(dmg)	
	end

	function ENT:ANPlusUpdateCBounds()
		local mins, maxs = self:GetCollisionBounds()
		self.m_vecCollBMins = mins
		self.m_vecCollBMaxs = maxs
	end
	
	function ENT:Initialize()
		
		self:SetModel( self.m_sModel )
		
		self:ANPlusPreInitialize()
		
		self:PhysicsInit( self.m_fPhysicsInitType )
		self:SetMoveType( self.m_fMoveType )
		self:SetMoveCollide( self.m_fMoveCollideType )
		self:SetCollisionGroup( self.m_fCollisionGroupType )
		self:SetSolid( self.m_fSolidType )

		self:SetTrigger( true )
		self:UseTriggerBounds( true, self.m_fPickupRadius )

		local physObj = self:GetPhysicsObject()
		if IsValid(physObj) then	
			self:ANPlusOnPhysicsObj(physObj)
		end

		self:ANPlusUpdateCBounds()		
		self:ANPlusOnInitialize()			

		if self.m_fLifeTime > 0 then
			timer.Simple( self.m_fLifeTime, function()
				if !IsValid(self) then return end
				SafeRemoveEntity(self)
			end )
		end

		self.m_fTouchDelay = CurTime() + self.m_fTouchDelay
		
	end

	function ENT:OnRemove()		
		self:ANPlusOnRemove()
	end

	function ENT:OnTakeDamage(dmg)

		local att = dmg:GetAttacker()
		local inf = dmg:GetAttacker()

		if IsValid(att) && att:GetClass() == self:GetClass() || IsValid(inf) && inf:GetClass() == self:GetClass() then return end

		self:ANPlusRemoveHealth( dmg:GetDamage(), 0 )

		if self.ProjHealth && self.ProjHealth > 0 && self:Health() <= 0 && !self.m_bDestroyed then	

			self:ANPlusOnDestroyed(dmg)		
			self.m_bDestroyed = true

		end

	end

	function ENT:ANPlusTouch(ent)
	end

	function ENT:Touch(ent)
		if self.m_fTouchDelay > CurTime() then return end

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

		if self.m_bDestroyed then return end
		
		self:ANPlusOnThink()
		
	end
	
	function ENT:PhysicsCollide(data, physobj)

		if self.UsePhysCollide && self.m_fTouchDelay <= CurTime() then

			if !self.m_bDestroyed then			
									
				if !self.m_bDecalPainted && self.CollideDecal then util.Decal( self.CollideDecal, data.HitPos + data.HitNormal, data.HitPos - data.HitNormal ); self.m_bDecalPainted = true end
				
				local SurTab = util.GetSurfaceData(util.GetSurfaceIndex(physobj:GetMaterial())) 

				if ( data.Speed > 40 and data.Speed <= 250 and data.DeltaTime > 0.1 ) and SurTab.impactSoftSound then

					self:EmitSound( self.SoftBounceSND || SurTab.impactSoftSound )	

				elseif ( data.Speed > 250 and data.DeltaTime > 0.1 ) and SurTab.impactHardSound then	

					self:EmitSound( self.HardBounceSND || SurTab.impactHardSound )		
				end	

			end	

		end

	end

end
