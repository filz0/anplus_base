--[[
sound.Add( {
	name = "ANP.WEAPON.R700.Fire",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = { "weapons/r700/fire1.wav" }
} )

sound.Add( {
	name = "ANP.WEAPON.R700.DistantFire",
	channel = CHAN_WEAPON,
	volume = 0.4,
	level = 140,
	pitch = { 75, 85 },
	sound = { "weapons/ar1/ar1_dist1.wav" }
} )

sound.Add( {
	name = "ANP.WEAPON.R700.Reload",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 65,
	pitch = 100,
	sound = { "weapons/r700/reload1.wav" }
} )
--]]
SWEP.Base = "weapon_base"

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )	
end

SWEP.Author							= "FiLzO"
SWEP.PrintName						= "ANP SWEP BASE"
SWEP.WorldModel						= "models/weapons/w_irifle.mdl"
SWEP.WorldModelCustomiseTab			= nil
--[[
{
	['Scale'] 	= 1, -- Or a bone edit table to customize the weapon.
	['Bone'] 	= "ValveBiped.Bip01_R_Hand",
	['Ang']		= Angle( 0, 0, 0 ),
	['Pos'] 	= Vector( 0, 0, 0 ),
}
--]]
SWEP.WorldModelDraw					= true
SWEP.WorldModelDrawShadow			= true

SWEP.HoldType						= "ar2"
SWEP.ActivityTranslateAIOverride	= nil
SWEP.Weight							= 30
SWEP.DropOnDeath					= true
SWEP.PickableByNPCs					= true
SWEP.EventDisable					= {}

SWEP.FlashlightTab 					= false
--[[
SWEP.FlashlightTab = {
	['SmartMode'] 			= true, -- If true, flashlight will only activate if owner is in combat or alerted and deactivate if idle. If false, flashlight will activate on spawn.
	['SpotlightAttachment']	= "1",
	['SpotlightPos'] 		= Vector( -1, -1.2, -6 ),
	['SpotlightAng']		= Angle( 0, -90, 0 ),
	['SpotlightWidth']		= 5,
	['SpotlightLength']		= 20,
	['SpotlightColor']		= Color( 170, 255, 255, 255 ),
}
]]--
-- SWEP NPC Settings
SWEP.NPCWeaponProficiencyTab 	= {
	[WEAPON_PROFICIENCY_POOR] 		= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.1,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.8,
		['BurstRestMax']	= 1.2,
		['BurstMin']		= 1,
		['BurstMax']		= 3,
		['HeadshotChance']	= 5,
	},
	[WEAPON_PROFICIENCY_AVERAGE] 	= {
		['Spread']			= 0.06,
		['SpreadMoveMult']	= 1.1,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.5,
		['BurstRestMax']	= 0.8,
		['BurstMin']		= 2,
		['BurstMax']		= 4,
		['HeadshotChance']	= 20,
	},
	[WEAPON_PROFICIENCY_GOOD] 		= {
		['Spread']			= 0.04,
		['SpreadMoveMult']	= 1.1,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.3,
		['BurstRestMax']	= 0.6,
		['BurstMin']		= 4,
		['BurstMax']		= 6,
		['HeadshotChance']	= 40,
	},
	[WEAPON_PROFICIENCY_VERY_GOOD] 	= {
		['Spread']			= 0.02,
		['SpreadMoveMult']	= 1.1,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.2,
		['BurstRestMax']	= 0.3,
		['BurstMin']		= 6,
		['BurstMax']		= 8,
		['HeadshotChance']	= 60,
	},
	[WEAPON_PROFICIENCY_PERFECT] 	= {
		['Spread']			= 0.01,
		['SpreadMoveMult']	= 1.1,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.1,
		['BurstRestMax']	= 0.1,
		['BurstMin']		= 6,
		['BurstMax']		= 10,
		['HeadshotChance']	= 80,
	},
}

-- SWEP Settings
SWEP.Primary.FireSound				= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= nil
SWEP.Primary.DistantSound			= nil
SWEP.Primary.AttackGesture			= nil

SWEP.Primary.Damage					= 5
SWEP.Primary.EntitySpeed			= 3000
SWEP.Primary.NumShots				= 1
SWEP.Primary.Delay					= 0.05
SWEP.Primary.PreFireDelay			= 0
SWEP.Primary.PreFireReset			= 0.1
SWEP.Primary.ClipSize				= 30
SWEP.Primary.InfiniteAmmo			= false
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "ToolTracer"
--[[
SWEP.ANPTracerSettingTab			= { -- anp_tracer_3d
	['BulletModel']				= nil, -- 1 to 7 or model string or false.
	['BulletMat']				= nil,
	['BulletColor']				= nil,
	['BulletScale']				= nil,
	['BulletOffsetPos']			= nil,
	['BulletOffsetAng']			= nil,
	['BulletParticle']			= nil, if set, tracer won't be created.
	['BulletSpeedMul']			= 1.1,
	
	['TracerMat']				= nil,
	['TracerLength']			= 10,	
	['TracerScale']				= 1,
	['TracerColor']				= nil,
	
	['TrailMat']				= nil,
	['TrailScale']				= 3,
	['TrailDelay']				= nil,
	['TrailDuration']			= 1,
	['TrailColor']				= nil,
	
	['FunctionInit']			= nil --function(self, data) end,
	['FunctionThink']			= nil --function(self) end,
	['FunctionRender']			= nil --function(self, dir, trStartPos, trEndPos, startPos, endPos) end,
}
]]--
SWEP.Primary.Force					= 5
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 10

-- Don't touch
SWEP.m_bWeaponReady = false
SWEP.m_bClipReloaded = false
SWEP.m_fCurBurstCount = 1
SWEP.m_fCurRestCalc = 0
SWEP.m_fCurBurstCalc = 0
SWEP.m_fPreFireLast = 0
SWEP.m_bPFDSoundPlayed = false
SWEP.NPCFireRate = SWEP.Primary.Delay
SWEP.m_fProfScale = 1
SWEP.m_fHChance = 50
SWEP.m_fPrimarySpread = 0.02
SWEP.m_fPrimarySpreadMMult = 1.1
SWEP.NPCRestMin	= 1
SWEP.NPCRestMax	= 2
SWEP.NPCBurstMin = 4
SWEP.NPCBurstMax = 8

-- Hooks
function SWEP:ANPlusInitialize()
end
 
function SWEP:Initialize()
	
	self:ANPlusInitialize()

	if self.WorldModelCustomiseTab && self.WorldModelCustomiseTab['Scale'] then
		if istable( self.WorldModelCustomiseTab['Scale'] ) then			
			self:ANPlusEditBone( self.WorldModelCustomiseTab['Scale'] )		
		elseif isnumber( self.WorldModelCustomiseTab['Scale'] ) then	
			self:SetModelScale( self.WorldModelCustomiseTab['Scale'] )			
		end 		
	end
	
	self:SetHoldType( self.HoldType )
	
	if (SERVER) then	
		if self.FlashlightTab && self.FlashlightTab['SpotlightAttachment'] then self:ANPlusWeaponFlashlight() end
		if self.Primary.FireLoopSound then self.FireLoopSound = CreateSound( self, self.Primary.FireLoopSound ); self.FireLoopSound:Stop() end
		self:GenerateBurst()	
	elseif (CLIENT) then
		hook.Add( "PreDrawEffects", self, self.ANPlusPreDrawEffects )
		hook.Add( "PostDrawEffects", self, self.ANPlusPostDrawEffects )
	end

end
--[[
function SWEP:TranslateActivity(act)
	if !self.ActOverride then return end
	if ( self:GetOwner():IsNPC() ) then
		if ( self.ActOverride[ act ] ) then
			return self.ActOverride[ act ]
		end
		return -1
	end

	return -1

end
]]--
function SWEP:ANPlusResetPrimaryFire()
	self.m_bPFDSoundPlayed = false	
	if self.Primary.PreFireSound then self:StopSound( self.Primary.PreFireSound ) end
	if self.FireLoopSound then self.FireLoopSound:Stop() end
end

function SWEP:ANPlusNPCPreFire()
end

function SWEP:ANPlusNPCPostFire()
end

function SWEP:ANPlusNPCFire()
end

function SWEP:PrimaryAttack()
	if !IsValid(self) || !IsValid(self:GetOwner()) || !self:CanPrimaryAttack() then return end	
	timer.Create( "ANPlusPreFireReset" .. self:EntIndex(), self.Primary.PreFireReset || self.Primary.Delay, 1, function() -- NPCs can't fire faster that 0.01 using this function?	
		if !IsValid(self) then return end
		if self.Primary.PostFireSound && (SERVER) then
			if ( IsValid(self:GetOwner()) && !self:GetOwner():IsCurrentSchedule(SCHED_RELOAD) ) && !self.m_bClipReloaded then
				self:EmitSound( self.Primary.PostFireSound ) 
				self:GetOwner():ClearSchedule()
			end
		end
		self:ANPlusNPCPostFire()
		self:ANPlusResetPrimaryFire()	
	end)
	if self.Primary.PreFireDelay && self.Primary.PreFireDelay > 0 && !self.m_bPFDSoundPlayed then
		--self:SetNextPrimaryFire( CurTime() + self.Primary.PreFireDelay )
		if self.Primary.PreFireSound && (SERVER) then self:EmitSound( self.Primary.PreFireSound ) end
		self:ANPlusNPCPreFire()
		self.m_bPFDSoundPlayed = true
		self.m_fPreFireLast = CurTime() + self.Primary.PreFireDelay
		return 
	end
	if self.m_fPreFireLast > CurTime() then return end
	if self.Primary.DSound && (SERVER) then sound.Play( self.Primary.DSound, self:GetPos() ) end
	if self.Primary.FireSound && (SERVER) then self:EmitSound( self.Primary.FireSound ) end		
	if (SERVER) && self.FireLoopSound && !self.FireLoopSound:IsPlaying() then self.FireLoopSound:Play() end
	
	if IsValid(self:GetOwner()) then self:GetOwner():ANPlusRestartGesture( self.Primary.AttackGesture || self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1], true, true ) end
	--self:ANPlusRemoveMuzzleSmoke()
	local hShot = ANPlusPercentageChance( self.m_fHChance )
	
	self:ANPlusNPCFire(hShot)
	self.m_bClipReloaded = false
	timer.Simple( self.Primary.Delay, function() if !IsValid(self) || !IsValid(self:GetOwner()) then return end	self:SetClip1( !self.Primary.InfiniteAmmo && self:Clip1() - self.Primary.AmmoPerShot || self:Clip1() ) end ) -- Making sure that fire animation will play on last bullet.
	self.m_fCurBurstCount = self.NPCBurstMax > 0 && self.NPCRestMax > 0 && self.m_fCurBurstCount - 1 || 1
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

end

SWEP.BlackListACTs = { -- What are these I have no f*** idea.
	[66] = true,
	[67] = true,
	[68] = true,
	[69] = true,
}

SWEP.BlackListSchedules = { -- What are these I have no f*** idea.
	[44] = true,
	[41] = true,
	[42] = true,
	[50] = true,
	[51] = true,
}

function SWEP:ANPlusCanPrimaryFire()
	return true
end

local angCheck = {
	['Pitch'] 	= { 180, -180 },
	['Yaw'] 	= { 45, -45 },
	['Roll'] 	= { 180, -180 },
}

function SWEP:CanPrimaryAttack()	
	
	if !IsValid(self:GetOwner()) || !IsValid(self:GetOwner():GetEnemy()) || !self.m_bWeaponReady then return false end
	
	local owner = self:GetOwner()
	local enemy = owner:GetEnemy()
	
	if CurTime() < self:GetNextPrimaryFire() || !self:ANPlusCanPrimaryFire() || ( ( self:Clip1() <= 0 || ( self:Clip1() - self.Primary.AmmoPerShot ) < 0 ) && !self.Primary.InfiniteAmmo ) || self.m_fCurBurstCount <= 0 then	
		return false
	end	

	local posTarget = enemy:GetPos()
	if !self:ANPlusValidAnglesNormal( posTarget, angCheck ) || !owner:ANPlusInRange( enemy, self:GetInternalVariable( "m_fMaxRange1" ) ) || ( !owner:Visible( enemy ) && !owner:IsCurrentSchedule( 39 ) ) then		
		return false
	end
	
	if !self:ANPlusCanPrimaryFire() || self.BlackListSchedules[ owner:GetCurrentSchedule() ] || self.BlackListACTs[ owner:GetActivity() ] || !owner:ANPlusAlive() || ( !enemy:ANPlusAlive() ) then
		return false
	end
	return true  		
end

function SWEP:ANPlusWeaponShell(att, bone, type, scale, angVec)
	
	local boneid = self:LookupBone( bone || "" )

	local fx = EffectData()
	fx:SetEntity( self )
	fx:SetAttachment( att || -1 )
	fx:SetColor( boneid || -1 )
	fx:SetRadius( type || 1 )
	fx:SetScale( scale || 1 )
	fx:SetStart( angVec || Vector( 0, 0, 0 ) )
	util.Effect( "anp_npc_shell", fx )	

end

function SWEP:ANPlusWeaponHitEffect( effect, tr, scale )	
	if tr && tr.Hit && !tr.HitSky then 	
		local fx = EffectData()
		fx:SetOrigin( tr.HitPos )
		fx:SetNormal( tr.HitNormal )
		fx:SetScale( scale || 1 )
		util.Effect( effect, fx )	
	end
end

function SWEP:ANPlusWeaponShootEffect(att, flags, scale, effect, muzzleSmokeDelay, muzzleSmokeDur)	-- flags for default hl2 muzzle = type. For ANP muzzles = boneID (instead of the attachment).
	
	if effect then
		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetAttachment( att || -1 )
		fx:SetFlags( flags || -1 )
		fx:SetScale( scale || 1 )
		util.Effect( effect, fx )	
	end
	
	if muzzleSmokeDelay then
		if IsValid(self.m_pMuzzleSmoke) then self.m_pMuzzleSmoke:Remove() end
		muzzleSmokeDelay = muzzleSmokeDelay == -1 && ( self.Primary.PreFireReset || self.Primary.Delay * 2 + self:GetNPCCurRestTime() ) || muzzleSmokeDelay
		muzzleSmokeDur = muzzleSmokeDur || 1
		timer.Create( "ANPlusSmokeEffectTimer" .. self:EntIndex(), muzzleSmokeDelay, 1, function()			
			if !IsValid(self) || IsValid(self.m_pMuzzleSmoke) then return end			
			--ParticleEffectAttach( "weapon_muzzle_smoke_b", 4, self, att )  	
			self.m_pMuzzleSmoke = ANPlusCreateParticle( "weapon_muzzle_smoke_b", nil, muzzleSmokeDur, self, att )
		end )		
	end	
end

--function SWEP:ANPlusRemoveMuzzleSmoke()
--	if IsValid(self.m_pMuzzleSmoke) then self.m_pMuzzleSmoke:Remove() end
--end

function SWEP:ANPlusWeaponFireEntity(entity, hShotChan, entPreCallback, entPostCallback, callback)
	
	local att = self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	local projectiles = {}	
	spread = owner:IsMoving() && self.m_fPrimarySpread * self.m_fPrimarySpreadMMult || self.m_fPrimarySpread
	local muzzlePos = IsValid(enemy) && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	local targetPos = ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || enemy:ANPlusGetHitGroupBone( 2 ) || enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	local shootAngle = targetPos && ( ( targetPos - muzzlePos ):GetNormalized() ):Angle() || owner:GetAimVector():Angle()
	
	--local shootAngle = owner:GetAimVector():Angle()
    shootAngle.p = shootAngle.p + math.Rand( -spread, spread )
    shootAngle.y = shootAngle.y + math.Rand( -spread, spread )
	
	for i = 1, self.Primary.NumShots do

		local ent = ents.Create( entity )	
		ent:SetPos( att.Pos )
		ent:SetAngles( shootAngle )
		ent:SetOwner( owner )
		if isfunction( entPreCallback ) then			
			ent.m_cPreSpawnCB = entPreCallback
			ent:m_cPreSpawnCB( ent )			
		end
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:SetVelocity( ent:GetForward() * self.Primary.EntitySpeed || Vector( 0, 0, 0 ) )
		else
			ent:SetVelocity( ent:GetForward() * self.Primary.EntitySpeed || Vector( 0, 0, 0 ) )
		end
		
		if isfunction( entPostCallback ) then			
			ent.m_cPostSpawnCB = entPostCallback
			ent:m_cPostSpawnCB( ent )			
		end
		
		for _, proj in pairs( projectiles ) do

			constraint.NoCollide( ent, proj, 0, 0 )

        end

        table.insert( projectiles, ent )
		
	end
	
	if isfunction( callback ) then
		
		local origin = owner:GetShootPos()
		local vector = owner:GetAimVector()
		
		callback( origin, vector, att )
			
	end
	
end

function SWEP:ANPlusWeaponFireBullet(hShotChan, bulletcallback, callback) -- bulletcallback = function(att, tr, dmginfo) | callback = function( origin, vector )
	local att = self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	local muzzlePos = enemy && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || enemy:ANPlusGetHitGroupBone( 2 ) || enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	spread = self:GetOwner():IsMoving() && self.m_fPrimarySpread * self.m_fPrimarySpreadMMult || self.m_fPrimarySpread	
	local direction = targetPos && ( targetPos - muzzlePos ):GetNormalized() || owner:GetAimVector()
	
	local bullet = {}
		bullet.Attacker 	= self:GetOwner()
		bullet.Num 			= self.Primary.NumShots
		bullet.Src 			= muzzlePos
		bullet.Dir 			= direction
		bullet.Tracer 		= self.Primary.Tracer
		bullet.TracerName 	= self.Primary.TracerName
		bullet.Spread 		= Vector( spread, spread, 0 )
		bullet.Damage 		= self.Primary.Damage
		bullet.Force 		= self.Primary.Force
		bullet.AmmoType 	= self.Primary.AmmoType 
		bullet.Callback 	= bulletcallback || nil

	self:FireBullets( bullet )
	
	if isfunction( callback ) then
		
		callback( muzzlePos, direction, att )
			
	end
	
end

function SWEP:ANPlusWeaponFlashlight()
	self.flight = ANPlusCreateSpotlight( self.FlashlightTab['SpotlightColor'] || Color( 255, 255, 255, 255 ), self.FlashlightTab['SpotlightWidth'] || 5, self.FlashlightTab['SpotlightLength'] || 5, 2 )
	self.flight:ANPlusParent( self.Weapon, self.FlashlightTab['SpotlightAttachment'], self.FlashlightTab['SpotlightPos'] || nil, self.FlashlightTab['SpotlightAng'] || nil )
	if !self.FlashlightTab['SmartMode'] then self:ANPlusWeaponFlashlightToggle( true, 1 ) end
end

function SWEP:ANPlusGetWeaponFlashlight()
	return self.flight 
end

function SWEP:ANPlusWeaponFlashlightToggle(toggle, delay)
	if !IsValid(self.flight) then return end
	if toggle && !self.flight:GetInternalVariable( "m_bSpotlightOn" ) then
		if delay && delay > 0 then
			timer.Simple( delay, function()
				if !IsValid(self) || !IsValid(self.flight) then return end
				self.flight:Fire( "LightOn", nil, 0 )
				self:EmitSound( "ANP.WEAPON.Flashlight" )
			end)
		else
			self.flight:Fire( "LightOn", nil, 0 )
			self:EmitSound( "ANP.WEAPON.Flashlight" )
		end
	elseif !toggle && self.flight:GetInternalVariable( "m_bSpotlightOn" ) then
		if delay && delay > 0 then
			timer.Simple( delay, function()
				if !IsValid(self) || !IsValid(self.flight) then return end
				self.flight:Fire( "LightOff", nil, 0 )
				self:EmitSound( "ANP.WEAPON.Flashlight" )
			end)
		else
			self.flight:Fire( "LightOff", nil, 0 )
			self:EmitSound( "ANP.WEAPON.Flashlight" )
		end
	end
end

function SWEP:ANPlusReload()
end

function SWEP:Reload()

	if self:Clip1() >= self:GetMaxClip1() || self.Primary.InfiniteAmmo || self.m_bClipReloaded then return end
	
	self:ANPlusResetPrimaryFire()
	self:GenerateBurst()
	self:ANPlusReload()	

	if self.Primary.PostFireSound && (SERVER) then self:StopSound( self.Primary.PostFireSound ) end
	if self.Primary.ReloadSound && (SERVER) then self:EmitSound( self.Primary.ReloadSound ) end

	self.m_bClipReloaded = true
end

function SWEP:ANPlusThink()
end

function SWEP:ThinkServer()
	
	if (CLIENT) || !IsValid(self) then return end
	if !IsValid(self:GetOwner()) || self:GetOwner():GetActiveWeapon() != self then return end

	self:ANPlusThink()
	
	local owner = self:GetOwner()
	
	if IsValid(owner) then
		
		if IsValid(self.flight) && self.FlashlightTab && self.FlashlightTab['SmartMode'] then
			if owner:GetNPCState() == 2 || owner:GetNPCState() == 3 then 
				self:ANPlusWeaponFlashlightToggle( true )
			else
				self:ANPlusWeaponFlashlightToggle( false )
			end
		end

		local OwnerACT = owner:GetActivity()	
		if self.LastOwnerACT != OwnerACT && self.BlackListACTs[ OwnerACT ] && !self.BlackListACTs[ self.LastOwnerACT ] then
			self:Reload()
		end		
        self.LastOwnerACT = OwnerACT	
		
		if self:Clip1() <= 0 && !self.Primary.InfiniteAmmo && !owner:IsCurrentSchedule(SCHED_RELOAD) && !owner:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) then  
            owner:SetSchedule(SCHED_RELOAD)      
        end
		
	end
	
	self:ANPlusWorldModelUpdate()
	
end

function SWEP:ANPlusNPCTriggerPull( shootPos, shootDir )
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )

	if !self:ANPlusCanPrimaryFire() then return end
	
	local owner = self:GetOwner()
	
	self:ANPlusNPCTriggerPull( shootPos, shootDir )
	
	if self.m_fCurBurstCount <= 0 then 
	
		timer.Create( "ANPlusCancelFire" .. self:EntIndex(), self:GetNPCCurRestTime(), 1, function() -- NPCs can't fire faster that 0.01 using this function?	
			if !IsValid(self) || !IsValid(self:GetOwner()) then return end	
			timer.Remove( "ANPlusFire" .. self:EntIndex() )
			self:GenerateBurst() -- Prepare new current burst count for our new burst.
		end)	
		
		return false 
		
	end
	
	timer.Create( "ANPlusFire" .. self:EntIndex(), 0, 0, function()
		if !IsValid(self) || !IsValid(owner) || !self:CanPrimaryAttack() then		
			return false 
		end --!self.AllowedSchedules[ self:GetOwner():GetCurrentSchedule() ] then return false end		

		self:PrimaryAttack()
	end)
end

function SWEP:GenerateBurst() -- Cuz I can't get the current burst count && rest time, I have to calculate it myself... >:(	
	self.m_fCurRestCalc = math.Round( math.Rand( self.NPCRestMin, self.NPCRestMax ), 2 )
	self.m_fCurBurstCalc = self.NPCBurstMax > 0 && math.random( self.NPCBurstMin, self.NPCBurstMax ) || 1 -- Let's check if our max burst count is higher than 0. If not, screw the burst mechanic && just go brrrrrr.
	self.m_fCurBurstCount = self.m_fCurBurstCalc
end

function SWEP:GetNPCRestTimes()		
	return self.m_fCurRestCalc, self.m_fCurRestCalc
end

function SWEP:GetNPCCurRestTime()	
	return self.m_fCurRestCalc	
end

function SWEP:GetNPCBurstSettings() -- Maybe read from it?
	return self.m_fCurBurstCalc, self.m_fCurBurstCalc, 0--self.NPCFireRate
end

function SWEP:GetNPCCurBurst() -- Maybe read from it?	
	return self.m_fCurBurstCalc
end

function SWEP:GetCapabilities()
	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )
end

function SWEP:GetNPCBulletSpread( wp )

	-- Handles the bullet spread based on the given proficiency (wp)
	-- return value is in degrees
	local profNPC = self.NPCWeaponProficiencyTab[ wp ]
	if profNPC then
		self.m_fPrimarySpread 		= profNPC['Spread']
		self.m_fPrimarySpreadMMult  = profNPC['SpreadMoveMult']
		self.NPCRestMin				= profNPC['BurstRestMin']
		self.NPCRestMax				= profNPC['BurstRestMax']
		self.NPCBurstMin			= profNPC['BurstMin']
		self.NPCBurstMax			= profNPC['BurstMax']
		self.m_fHChance				= profNPC['HeadshotChance']

		self:SetSaveValue( "m_fMinRange1", profNPC['RangeMin'] || self:GetInternalVariable( "m_fMinRange1" ) )
		self:SetSaveValue( "m_fMaxRange1", profNPC['RangeMax'] || self:GetInternalVariable( "m_fMaxRange1" ) )
	
		local defDeg = 10
		local spread = self.m_fPrimarySpread * defDeg
		if !self.m_bWeaponReady then
			self:GenerateBurst()
			self.m_bWeaponReady = true
		end	

	return spread
	end	
end

function SWEP:ANPlusGetWeaponCustomPosition(owner)

	if !self.WorldModelCustomiseTab || !self.WorldModelCustomiseTab['Bone'] || owner:LookupBone( self.WorldModelCustomiseTab['Bone'] ) == nil then return nil end
	
	local pos, ang = owner:GetBonePosition( owner:LookupBone( self.WorldModelCustomiseTab['Bone'] ) )
	
	ang:RotateAroundAxis( ang:Right(), self.WorldModelCustomiseTab['Ang'].x )
	ang:RotateAroundAxis( ang:Up(), self.WorldModelCustomiseTab['Ang'].y )
	ang:RotateAroundAxis( ang:Forward(), self.WorldModelCustomiseTab['Ang'].z )
	
	pos = pos + self.WorldModelCustomiseTab['Pos'].x * ang:Right()
	pos = pos + self.WorldModelCustomiseTab['Pos'].y * ang:Forward()
	pos = pos + self.WorldModelCustomiseTab['Pos'].z * ang:Up()

	return { pos = pos, ang = ang }
	
end

function SWEP:ANPlusWorldModelUpdate()

	local owner = self:GetOwner()
	
	if IsValid(owner) && self.WorldModelCustomiseTab then
	
		local wepData = self:ANPlusGetWeaponCustomPosition( owner )
		if wepData == nil then return end
		
		self:SetPos( wepData.pos )
		self:SetAngles( wepData.ang )
		
	end
	
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:FireAnimationEvent( pos, ang, event, options )
	
	-- Disables animation based muzzle event
	-- print(event)
	if self.EventDisable && self.EventDisable[ event ] then return true end

end

function SWEP:ANPlusEquip(ent)
end

function SWEP:Equip(ent)
	if ent:IsPlayer() then self:Remove() return false end	
	if ent:GetClass() == "npc_citizen" then ent:Fire("DisableWeaponPickup") end
	timer.Remove( "ANPlusRemoveOnDrop" .. self:EntIndex() )
	hook.Add( "Think", self, self.ThinkServer )
	if self.ActivityTranslateAIOverride then
		timer.Simple( 0.1, function()
			if !IsValid(self) || !IsValid(ent) then return end
			self:SetupWeaponHoldTypeForAI( self:GetHoldType() )
		end )
	end
	self:ANPlusEquip( ent )
end

function SWEP:CanBePickedUpByNPCs()
    return self.PickableByNPCs
end

function SWEP:ANPlusOnDrop()
end

function SWEP:OnDrop()
	
	self:ANPlusOnDrop()
	
	self:StopParticles()
	if (SERVER) && IsValid(self.flight) then self:ANPlusWeaponFlashlightToggle(false, nil) end
	if self.Primary.PreFireSound then self:StopSound( self.Primary.PreFireSound ) end
	if self.Primary.PostFireSound then self:StopSound( self.Primary.PostFireSound ) end
	if self.FireLoopSound then self.FireLoopSound:Stop() end	
	if self.DropOnDeath == false then
		self:Remove()
	elseif self.DropOnDeath && isnumber(self.DropOnDeath) then
		SafeRemoveEntityDelayed( self, self.DropOnDeath )
	end
	self.m_bWeaponReady = false
	timer.Create( "ANPlusRemoveOnDrop" .. self:EntIndex(), 10, 1, function()
		if !IsValid(self) then return end
		if IsValid(self) && !IsValid(self:GetOwner()) then self:Remove() end
	end)
	
end

function SWEP:ANPlusOnRemove()
end

function SWEP:OnRemove()
	
	self:ANPlusOnRemove()
	
	self:StopParticles()
	if self.Primary.PreFireSound then self:StopSound( self.Primary.PreFireSound ) end
	if self.Primary.PostFireSound then self:StopSound( self.Primary.PostFireSound ) end
	if self.FireLoopSound then self.FireLoopSound:Stop() end

end

if (CLIENT) then
	
	function SWEP:ANPlusPreDrawEffects()
	end
	
	function SWEP:ANPlusPostDrawEffects()
	end
	
	function SWEP:ANPlusDrawWorldModel()
		return true
	end

	function SWEP:DrawWorldModel()
		
		if !IsValid(self) then return end
		
		local noDraw = false
		
		if !self:ANPlusDrawWorldModel() || !self.WorldModelDraw then noDraw = true end
		self:DrawShadow( self.WorldModelDrawShadow )
		
		if self.WorldModelCustomiseTab then
		
			local owner = self:GetOwner()
			
			if IsValid(owner) then
				
				local wepData = self:ANPlusGetWeaponCustomPosition( owner )
				if wepData == nil then return end
				self:SetRenderOrigin( wepData.pos )
				self:SetRenderAngles( wepData.ang )
				self:FrameAdvance( FrameTime() )
				self:SetupBones()
				if !noDraw then self:DrawModel() end

			else

				self:SetRenderOrigin(nil)
				self:SetRenderAngles(nil)
				
				if !noDraw then self:DrawModel() end
				
			end
			
		else
		
			if !noDraw then self:DrawModel() end
			
		end
	
	end
	
end