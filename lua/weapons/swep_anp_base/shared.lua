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
	util.AddNetworkString( "anplus_swep_base_tracer" )	
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

SWEP.HoldType						= "ar2" -- If You wish to utilize SWEP:ANPlusSetupWeaponHoldTypeForAI( hType, owner ), set it to 'custom'. SWEP:ANPlusSetupWeaponHoldTypeForAI( hType, owner ) should be used in the shared.lua.
SWEP.ActivityTranslateAIOverride	= nil
SWEP.Weight							= 30
SWEP.DropOnDeath					= true
SWEP.PickableByNPCs					= true
SWEP.EventDisable					= {}

SWEP.FlashlightTab 					= false
--[[
SWEP.FlashlightTab 		= {
	['Attachment']		= "1",
	['Pos'] 			= Vector( 1, -1.2, 0 ),
	['Ang']				= Angle( 0, 0, 0 ),
	['Color']			= Color( 170, 255, 255, 255 ),
	
	['FlashLightMat'] 	= "effects/flashlight001",	
	['FlashLightFarZ']	= 1024,								-- Sets the distance at which the projected texture ends.
	['FlashLightNearZ']	= 1, 								-- Sets the distance at which the projected texture begins its projection.
	['FlashLightFOV']	= 40, 								-- Sets the angle of projection.
	['SpriteMat'] 		= Material( "sprites/light_glow03_fix" ),
	['SpriteMins']		= { 5, 5 },							-- { width, height } at min distance.
	['SpriteMaxs']		= { 120, 120 },						-- { width, height } at max distance.
}
SWEP.LaserTab 			= {
	['Attachment']		= "1",
	['Pos'] 			= Vector( -4, 0.8, 0 ),
	['Ang']				= Angle( 0, 0, 0 ),	
	['Color']			= Color( 0, 220, 255, 255 ),
	
	['LaserMat'] 		= Material( "sprites/rollermine_shock" ),	
	['LaserSize']		= { 2048, 2 }, 						-- { length, width }
	['LaserNoFade'] 	= false,							-- If true, the laser of this weapon won't fade with distance. It's meant to be used with weapons like sniper rifles. Lasers fade for performance reasons. Use it smart.
	['StartDotMat'] 	= Material( "particle/particle_glow_02" ),
	['StartDotSize']	= { 1, 1 }, 						-- { width, height }
	['EndDotMat'] 		= Material( "particle/particle_glow_02" ),
	['EndDotSize']		= { 1, 1 }, 						-- { width, height }
}
]]--
-- SWEP NPC Settings
SWEP.WeaponCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1
SWEP.NPCCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1
SWEP.NPCWeaponProficiencyTab 		= {
	[WEAPON_PROFICIENCY_POOR] 		= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.1,
		['Spread2']			= 0.1,
		['SpreadMoveMult2']	= 1.1,
		['RangeMin']		= 0,
		['RangeMax']		= nil,
		['RangeMin2']		= 0,
		['RangeMax2']		= nil,
		['BurstRestMin']	= 0.8,
		['BurstRestMax']	= 1.2,
		['BurstMin']		= 1,
		['BurstMax']		= 3,
		['HeadshotChance']	= 5,
	},
	[WEAPON_PROFICIENCY_AVERAGE] 	= {
		['Spread']			= 0.06,
		['SpreadMoveMult']	= 1.1,
		['Spread2']			= 0.06,
		['SpreadMoveMult2']	= 1.1,
		['RangeMin']		= 0,
		['RangeMax']		= nil,
		['RangeMin2']		= 0,
		['RangeMax2']		= nil,
		['BurstRestMin']	= 0.5,
		['BurstRestMax']	= 0.8,
		['BurstMin']		= 2,
		['BurstMax']		= 4,
		['HeadshotChance']	= 20,
	},
	[WEAPON_PROFICIENCY_GOOD] 		= {
		['Spread']			= 0.04,
		['SpreadMoveMult']	= 1.1,
		['Spread2']			= 0.04,
		['SpreadMoveMult2']	= 1.1,
		['RangeMin']		= 0,
		['RangeMax']		= nil,
		['RangeMin2']		= 0,
		['RangeMax2']		= nil,
		['BurstRestMin']	= 0.3,
		['BurstRestMax']	= 0.6,
		['BurstMin']		= 4,
		['BurstMax']		= 6,
		['HeadshotChance']	= 40,
	},
	[WEAPON_PROFICIENCY_VERY_GOOD] 	= {
		['Spread']			= 0.02,
		['SpreadMoveMult']	= 1.1,
		['Spread2']			= 0.02,
		['SpreadMoveMult2']	= 1.1,
		['RangeMin']		= 0,
		['RangeMax']		= nil,
		['RangeMin2']		= 0,
		['RangeMax2']		= nil,
		['BurstRestMin']	= 0.2,
		['BurstRestMax']	= 0.3,
		['BurstMin']		= 6,
		['BurstMax']		= 8,
		['HeadshotChance']	= 60,
	},
	[WEAPON_PROFICIENCY_PERFECT] 	= {
		['Spread']			= 0.01,
		['SpreadMoveMult']	= 1.1,
		['Spread2']			= 0.01,
		['SpreadMoveMult2']	= 1.1,
		['RangeMin']		= 0,
		['RangeMax']		= nil,
		['RangeMin2']		= 0,
		['RangeMax2']		= nil,
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
SWEP.Primary.DSound					= nil -- Can be set to "Auto". Base will generate a distant sound using the SWEP.Primary.FireSound.
SWEP.Primary.AttackGesture			= nil

SWEP.Primary.Damage					= 5
SWEP.Primary.Force					= 1
SWEP.Primary.EntitySpeed			= 3000
SWEP.Primary.NumShots				= 1
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.ClipSize				= 30
SWEP.Primary.DefaultClip			= 30
SWEP.Primary.AmmoType				= "Pistol"
SWEP.Primary.Ammo					= SWEP.Primary.AmmoType
SWEP.Primary.InfiniteAmmo			= false
SWEP.Primary.Delay					= 0.05
SWEP.Primary.PreFireDelay			= 0
SWEP.Primary.PreFireReset			= 0.1
SWEP.Primary.SecondaryCooldown		= 0

SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerEffect			= { 
	['Effect'] = false, 
	['DoWhiz'] = true, 
	['AttachmentIndex'] = -1 
}
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


SWEP.Secondary.FireSound			= nil
SWEP.Secondary.FireLoopSound		= nil
SWEP.Secondary.PreFireSound			= nil
SWEP.Secondary.PostFireSound		= nil
SWEP.Secondary.ReloadSound			= nil
SWEP.Secondary.DSound				= nil
SWEP.Secondary.Attack				= nil
SWEP.Secondary.AttackGesture		= nil

SWEP.Secondary.Damage				= 30
SWEP.Secondary.Force				= 1
SWEP.Secondary.EntitySpeed			= 3000
SWEP.Secondary.NumShots				= 1
SWEP.Secondary.AmmoType				= "Pistol"
SWEP.Secondary.Ammo					= SWEP.Secondary.AmmoType
SWEP.Secondary.Delay				= 5
SWEP.Secondary.PreFireDelay			= 0.5
SWEP.Secondary.PreFireReset			= 0.1
SWEP.Secondary.PrimaryCooldown		= 0

SWEP.Secondary.Tracer				= 1
SWEP.Secondary.TracerName			= "ToolTracer"
SWEP.Secondary.TracerEffect			= { 
	['Effect'] = false, 
	['DoWhiz'] = true, 
	['AttachmentIndex'] = -1 
}

-- Don't touch
SWEP.m_bWeaponReady = false
SWEP.m_bClipReloaded = false
SWEP.m_fCurBurstCount = 1
SWEP.m_fCurRestCalc = 0
SWEP.m_fCurBurstCalc = 0
SWEP.m_fPreFireLast = 0
SWEP.m_fPreFireLast2 = 0
SWEP.m_bPFDSoundPlayed = false
SWEP.m_bPFDSoundPlayed2 = false
SWEP.NPCFireRate = SWEP.Primary.Delay
SWEP.m_fProfScale = 1
SWEP.m_fHChance = 50
SWEP.m_fPrimarySpread = 0.02
SWEP.m_fPrimarySpreadMMult = 1.1
SWEP.m_fSecondarySpread = 0.02
SWEP.m_fSecondarySpreadMMult = 1.1
SWEP.m_fCheckLightLast = 0
SWEP.m_fCheckLightDelay = 1.5
SWEP.m_fAttachmentFlickerLast = 0
SWEP.m_fAttachmentFlicker = 1
SWEP.m_fLightLevel = 1
SWEP.NPCRestMin	= 1
SWEP.NPCRestMax	= 2
SWEP.NPCBurstMin = 4
SWEP.NPCBurstMax = 8

local fLightSmartMode = GetConVar( "anplus_swep_flight_smartmode" )
local vector_zero = Vector( 0, 0, 0 )

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

		if self.Primary.FireLoopSound then self.FireLoopSound = CreateSound( self, self.Primary.FireLoopSound ); self.FireLoopSound:Stop() end
		self:GenerateBurst()	

	elseif (CLIENT) then

		hook.Add( "PreDrawEffects", self, self.SWEPPreDrawEffects )
		hook.Add( "PostDrawEffects", self, self.SWEPPostDrawEffects )

		if self.FlashlightTab && self.FlashlightTab['Attachment'] then			
			
			local tab = self.FlashlightTab
			local bone = self:LookupBone( tab['Attachment'] )
			local matrix
			if bone then
				matrix = bone && self:GetBoneMatrix( bone )
				local pos = matrix:GetTranslation()
				local ang = matrix:GetAngles()
				matrix = { Pos = pos, Ang = ang }
			end		
			local attTab = matrix || self:GetAttachment( tab['Attachment'] )

			self.m_pFLProjText = ProjectedTexture()
			self.m_pFLProjText:SetTexture( tab['FlashLightMat'] )
			self.m_pFLProjText:SetFOV( tab['FlashLightFOV'] )
			self.m_pFLProjText:SetFarZ( tab['FlashLightFarZ'] )
			self.m_pFLProjText:SetColor( tab['Color'] )
			self.m_pFLProjText:SetNearZ( fLightSmartMode:GetBool() && 0 || tab['FlashLightNearZ'] )
			
			local newPos, newAng = LocalToWorld( tab['Pos'], tab['Ang'], attTab.Pos, attTab.Ang )	
			
			self.m_pFLProjText:SetPos( newPos ) -- Initial position and angles
			self.m_pFLProjText:SetAngles( newAng )
			self.m_pFLProjText:Update()
			
		end

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
function SWEP:ANPlusResetFire()
	self.m_bPFDSoundPlayed = false	
	if self.Primary.PreFireSound then self:StopSound( self.Primary.PreFireSound ) end
	if self.FireLoopSound then self.FireLoopSound:Stop() end
	self.m_fPreFireLast = CurTime() + self.Primary.PreFireDelay
end

function SWEP:ANPlusNPCPreAttack()
	return true
end

function SWEP:ANPlusNPCPreFire()
end

function SWEP:ANPlusNPCPostFire()
end

function SWEP:ANPlusCanPrimaryFire()
	return true
end

function SWEP:ANPlusNPCFire(hShot)
end

function SWEP:PrimaryAttack()

	local owner = self:GetOwner()

	if !IsValid(self) || !IsValid(owner) || !self:CanPrimaryAttack() || !self:ANPlusNPCPreAttack() then return false end	

	timer.Create( "ANPlusPreFireReset" .. self:EntIndex(), self.Primary.PreFireReset || self.Primary.Delay, 1, function() -- NPCs can't fire faster that 0.01 using this function?	
		if !IsValid(self) then return end
		if self.Primary.PostFireSound && (SERVER) then
			if ( IsValid(owner) && !owner:IsCurrentSchedule( SCHED_RELOAD ) ) && !self.m_bClipReloaded then
				self:EmitSound( self.Primary.PostFireSound ) 
				owner:ClearSchedule()
			end
		end
		self:ANPlusNPCPostFire()
		self:ANPlusResetFire()	
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

	--if self.Primary.DSound && (SERVER) then sound.Play( self.Primary.DSound, self:GetPos() ) end
	if self.Primary.DSound && (SERVER) then
		if self.Primary.DSound == "Auto" then
			EmitSound( self.Primary.FireSound, self:GetPos(), -3, nil, 0.2, 140, nil, nil, 31 )
		else
			EmitSound( self.Primary.DSound, self:GetPos(), self:EntIndex() )
		end
	end

	if self.Primary.FireSound && (SERVER) then self:EmitSound( self.Primary.FireSound ) end		

	if (SERVER) && self.FireLoopSound && !self.FireLoopSound:IsPlaying() then self.FireLoopSound:Play() end
	
	if self.Primary.AttackGesture != false then owner:ANPlusRestartGesture( self.Primary.AttackGesture || self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1], true, true ) end
	--self:ANPlusRemoveMuzzleSmoke()
	local hShot = ANPlusPercentageChance( self.m_fHChance )
	
	self:ANPlusNPCFire(hShot)

	self.m_bClipReloaded = false

	timer.Simple( self.Primary.Delay, function() if !IsValid(self) || !IsValid(owner) then return end self:SetClip1( !self.Primary.InfiniteAmmo && self:Clip1() - self.Primary.AmmoPerShot || self:Clip1() ) end ) -- Making sure that fire animation will play on last bullet.
	
	self.m_fCurBurstCount = self.NPCBurstMax > 0 && self.NPCRestMax > 0 && self.m_fCurBurstCount - 1 || 99

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	if CurTime() >= self:GetNextSecondaryFire() then self:SetNextSecondaryFire( CurTime() + self.Primary.SecondaryCooldown ) end

end

function SWEP:ANPlusResetFire2()
	self.m_bPFDSoundPlayed2 = false	
	if self.Secondary.PreFireSound then self:StopSound( self.Secondary.PreFireSound ) end
	self.m_fPreFireLast2 = CurTime() + self.Secondary.PreFireDelay
end

function SWEP:ANPlusNPCPreAttack2()
	return true
end

function SWEP:ANPlusNPCPreFire2()
end

function SWEP:ANPlusNPCPostFire2()
end

function SWEP:ANPlusCanSecondaryFire()
	return false
end

function SWEP:ANPlusNPCFire2(hShot)
end

function SWEP:SecondaryAttack()

	local owner = self:GetOwner()

	if !IsValid(self) || !IsValid(owner) || !self:CanSecondaryAttack() || !self:ANPlusNPCPreAttack2() then return false end	
	
	timer.Create( "ANPlusPreFireReset2" .. self:EntIndex(), self.Secondary.PreFireReset || self.Secondary.Delay, 1, function() -- NPCs can't fire faster that 0.01 using this function?	
		if !IsValid(self) then return end
		if self.Secondary.PostFireSound && (SERVER) then
			if ( IsValid(owner) && !owner:IsCurrentSchedule( SCHED_RELOAD ) ) && !self.m_bClipReloaded then
				self:EmitSound( self.Secondary.PostFireSound ) 
				owner:ClearSchedule()
			end
		end
		self:ANPlusNPCPostFire2()
	end)
	
	if self.Secondary.PreFireDelay && self.Secondary.PreFireDelay > 0 && !self.m_bPFDSoundPlayed2 then
		--self:SetNextPrimaryFire( CurTime() + self.Primary.PreFireDelay )
		if self.Secondary.PreFireSound && (SERVER) then self:EmitSound( self.Secondary.PreFireSound ) end
		self:ANPlusNPCPreFire2()
		self.m_bPFDSoundPlayed2 = true
		self.m_fPreFireLast2 = CurTime() + self.Secondary.PreFireDelay
		return 
	end
	
	if self.m_fPreFireLast2 > CurTime() then return end

	if self.Secondary.DSound && (SERVER) then
		if self.Secondary.DSound == "Auto" then
			EmitSound( self.Secondary.FireSound, self:GetPos(), -3, nil, 0.2, 140, nil, nil, 31 )
		else
			EmitSound( self.Secondary.DSound, self:GetPos(), self:EntIndex() )
		end
	end

	if self.Secondary.FireSound && (SERVER) then self:EmitSound( self.Secondary.FireSound ) end		
	
	owner:SetSchedule( SCHED_RANGE_ATTACK1 )

	if owner:ANPlusIsNPCCrouching() then
		owner:ResetIdealActivity( 450 )
		owner:SetActivity( 450 )
	else
		owner:ResetIdealActivity( 449 )
		owner:SetActivity( 449 )
	end

	if self.Secondary.AttackGesture != false then owner:ANPlusRestartGesture( self.Secondary.AttackGesture || self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2], true, true ) end
	
	local hShot = ANPlusPercentageChance( self.m_fHChance )
	
	self:ANPlusNPCFire2(hShot)

	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextPrimaryFire( CurTime() + self.Secondary.PrimaryCooldown )

	owner:ANPlusGetSquadMembers( function( npc )
		local wep = npc:GetActiveWeapon()
		if IsValid(wep) && wep.Base == "swep_anp_base" then
			if wep.Secondary.Delay then
				wep:SetNextSecondaryFire( CurTime() + wep.Secondary.Delay )
			end
		end
	end )

end

SWEP.BlackListACTs = { -- What are these I have no f*** idea.
	[2] = true,
	[66] = true,
	[67] = true,
	[68] = true,
	[69] = true,
}

SWEP.BlackListSchedules = { -- What are these I have no f*** idea.
	[41] = true,
	[42] = true,
	[44] = true,
	[50] = true,
	[51] = true,
}

local angCheck = {
	['Pitch'] 	= { 180, -180 },
	['Yaw'] 	= { 45, -45 },
	['Roll'] 	= { 180, -180 },
}

function SWEP:CanPrimaryAttack()	
	if !self.m_bWeaponReady then return false end

	if !IsValid(self:GetOwner()) || !IsValid(self:GetOwner():GetEnemy()) then return false end
		
	local owner = self:GetOwner()
	local enemy = owner:GetEnemy()

	if owner:IsMoving() && !owner:ANPlusCapabilitiesHas( 64 ) || ( self:ANPlusCapabilitiesHas( 8192 ) && !owner:ANPlusCapabilitiesHas( 8192 ) ) || ( self:ANPlusCapabilitiesHas( 32768 ) && !owner:ANPlusCapabilitiesHas( 32768 ) ) then return false end
	
	if !self:ANPlusCanPrimaryFire() || self:CanSecondaryAttack() || CurTime() < self:GetNextPrimaryFire() || ( ( self:Clip1() <= 0 || ( self:Clip1() - self.Primary.AmmoPerShot ) < 0 ) && !self.Primary.InfiniteAmmo ) || self.m_fCurBurstCount <= 0 then	
		return false
	end	
	
	if self.BlackListSchedules[ owner:GetCurrentSchedule() ] || self.BlackListACTs[ owner:GetActivity() ] || owner:IsPlayingGesture( 70 ) || owner:IsPlayingGesture( 71 ) || owner:HasCondition( 42 ) || !owner:HasCondition( 21 ) || !owner:ANPlusAlive() || ( !enemy:ANPlusAlive() ) then
		return false
	end

	local posTarget = enemy:GetPos()
	if !self:ANPlusValidAnglesNormal( posTarget, angCheck ) || owner:ANPlusInRange( enemy, self:GetOwnerProfTab()['RangeMin'] ) || !owner:ANPlusInRange( enemy, self:GetInternalVariable( "m_fMaxRange1" ) ) || ( !owner:Visible( enemy ) && !owner:IsCurrentSchedule( 39 ) ) then			
		if owner:ANPlusInRange( enemy, self:GetOwnerProfTab()['RangeMin'] ) && !owner:IsCurrentSchedule( SCHED_MOVE_AWAY ) then
			owner:SetSchedule( SCHED_MOVE_AWAY )
		end
		return false
	end

	return true  		
end

function SWEP:CanSecondaryAttack()

	if !self.m_bWeaponReady then return false end

	if !IsValid(self:GetOwner()) || !IsValid(self:GetOwner():GetEnemy()) then return false end
		
	local owner = self:GetOwner()
	local enemy = owner:GetEnemy()

	if owner:IsMoving() && !owner:ANPlusCapabilitiesHas( 64 ) || ( self:ANPlusCapabilitiesHas( 16384 ) && !owner:ANPlusCapabilitiesHas( 16384 ) ) || ( self:ANPlusCapabilitiesHas( 65536 ) && !owner:ANPlusCapabilitiesHas( 65536 ) ) then return false end

	if !self:ANPlusCanSecondaryFire() || CurTime() < self:GetNextSecondaryFire() then	
		return false
	end	
	
	if self.BlackListSchedules[ owner:GetCurrentSchedule() ] || self.BlackListACTs[ owner:GetActivity() ] || owner:IsPlayingGesture( 70 ) || owner:IsPlayingGesture( 71 ) || owner:HasCondition( 21 ) || owner:HasCondition( 42 ) || !owner:ANPlusAlive() || ( !enemy:ANPlusAlive() ) then
		return false
	end

	local posTarget = enemy:GetPos()
	if !self:ANPlusValidAnglesNormal( posTarget, angCheck ) || owner:ANPlusInRange( enemy, self:GetOwnerProfTab()['RangeMin2'] ) || !owner:ANPlusInRange( enemy, self:GetInternalVariable( "m_fMaxRange2" ) ) || ( !owner:Visible( enemy ) && !owner:IsCurrentSchedule( 39 ) ) then		
		if owner:ANPlusInRange( enemy, self:GetOwnerProfTab()['RangeMin2'] ) && !owner:IsCurrentSchedule( SCHED_MOVE_AWAY ) then
			owner:SetSchedule( SCHED_MOVE_AWAY )
		end
		return false
	end

	return true 
end

function SWEP:ANPlusWeaponShell(att, bone, type, scale, angVec)

	local boneid = isnumber( bone ) && bone || self:LookupBone( bone || "" )

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

function SWEP:ANPlusWeaponShootEffect2(att, flags, scale, effect, muzzleSmokeDelay, muzzleSmokeDur)	-- flags for default hl2 muzzle = type. For ANP muzzles = boneID (instead of the attachment).
	
	if effect then
		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetAttachment( att || -1 )
		fx:SetFlags( flags || -1 )
		fx:SetScale( scale || 1 )
		util.Effect( effect, fx )	
	end
	
	if muzzleSmokeDelay then
		if IsValid(self.m_pMuzzleSmoke2) then self.m_pMuzzleSmoke2:Remove() end
		muzzleSmokeDelay = muzzleSmokeDelay == -1 && ( self.Secondary.PreFireReset || self.Secondary.Delay * 2 + self:GetNPCCurRestTime() ) || muzzleSmokeDelay
		muzzleSmokeDur = muzzleSmokeDur || 1
		timer.Create( "ANPlusSmokeEffectTimer" .. self:EntIndex(), muzzleSmokeDelay, 1, function()			
			if !IsValid(self) || IsValid(self.m_pMuzzleSmoke2) then return end			
			--ParticleEffectAttach( "weapon_muzzle_smoke_b", 4, self, att )  	
			self.m_pMuzzleSmoke2 = ANPlusCreateParticle( "weapon_muzzle_smoke_b", nil, muzzleSmokeDur, self, att )
		end )		
	end	
end

--function SWEP:ANPlusRemoveMuzzleSmoke()
--	if IsValid(self.m_pMuzzleSmoke) then self.m_pMuzzleSmoke:Remove() end
--end

function SWEP:ANPlusWeaponFireEntity(entity, addVel, hShotChan, entPreCallback, entPostCallback, callback, att)
	
	local att = att || self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	addVel = addVel || Vector( 0, 0, 0 )
	local projectiles = {}	
	spread = owner:IsMoving() && self.m_fPrimarySpread * self.m_fPrimarySpreadMMult || self.m_fPrimarySpread
	local muzzlePos = IsValid(enemy) && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	--local targetPos = ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || enemy:ANPlusGetHitGroupBone( 2 ) || enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || 
	enemy:ANPlusGetHitGroupBone( 2 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 2 ) ) && enemy:ANPlusGetHitGroupBone( 2 ) || 
	enemy:ANPlusGetHitGroupBone( 3 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 3 ) ) && enemy:ANPlusGetHitGroupBone( 3 ) || 
	enemy:ANPlusGetHitGroupBone( 4 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 4 ) ) && enemy:ANPlusGetHitGroupBone( 4 ) || 
	enemy:ANPlusGetHitGroupBone( 5 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 5 ) ) && enemy:ANPlusGetHitGroupBone( 5 ) || 
	enemy:ANPlusGetHitGroupBone( 6 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 6 ) ) && enemy:ANPlusGetHitGroupBone( 6 ) || 
	enemy:ANPlusGetHitGroupBone( 7 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 7 ) ) && enemy:ANPlusGetHitGroupBone( 7 ) || 
	enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	local eneVel = enemy:IsNPC() && enemy:GetMoveType() == 3 && enemy:GetGroundSpeedVelocity() || enemy:GetVelocity()	
	local dstSqr, dist = self:ANPlusGetRange( enemy )
	local dirCorrect = math.max( self.Primary.EntitySpeed, 1 )
	dirCorrect = dist / dirCorrect
	local shootAng = targetPos && ( ( targetPos + ( ( eneVel + addVel ) * dirCorrect ) - muzzlePos ):GetNormalized() ):Angle() || owner:GetAimVector():Angle()
	local dir = shootAng:Forward()
	--local shootAng = owner:GetAimVector():Angle()
    shootAng.p = shootAng.p + math.Rand( -spread, spread )
    shootAng.y = shootAng.y + math.Rand( -spread, spread )
	
	for i = 1, self.Primary.NumShots do

		local ent = ents.Create( entity )	
		ent:SetPos( muzzlePos + att.Ang:Forward() * 20 )
		ent:SetAngles( shootAng )
		ent:SetOwner( owner )
		if isfunction( entPreCallback ) then			
			ent.m_cPreSpawnCB = entPreCallback
			ent:m_cPreSpawnCB( ent )			
		end
		ent:Spawn()
		
		local phys = IsValid(ent:GetPhysicsObject()) && ent:GetMoveType() != 4 && ent:GetPhysicsObject() || ent
		
		if self.Primary.EntitySpeed > 0 then
			if phys:IsValid() then
				phys:SetVelocity( ( ent:GetForward() * self.Primary.EntitySpeed ) + addVel )
			else
				ent:SetVelocity( ( ent:GetForward() * self.Primary.EntitySpeed ) + addVel )
			end
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
		
		callback( muzzlePos, shootAng, dir, att )
			
	end
	
end

function SWEP:ANPlusWeaponFireEntity2(entity, addVel, hShotChan, entPreCallback, entPostCallback, callback, att)
	
	local att = att || self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	addVel = addVel || Vector( 0, 0, 0 )
	local projectiles = {}	
	spread = owner:IsMoving() && self.m_fSecondarySpread * self.m_fSecondarySpreadMMult || self.m_fSecondarySpread
	local muzzlePos = IsValid(enemy) && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	--local targetPos = ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || enemy:ANPlusGetHitGroupBone( 2 ) || enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || 
	enemy:ANPlusGetHitGroupBone( 2 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 2 ) ) && enemy:ANPlusGetHitGroupBone( 2 ) || 
	enemy:ANPlusGetHitGroupBone( 3 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 3 ) ) && enemy:ANPlusGetHitGroupBone( 3 ) || 
	enemy:ANPlusGetHitGroupBone( 4 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 4 ) ) && enemy:ANPlusGetHitGroupBone( 4 ) || 
	enemy:ANPlusGetHitGroupBone( 5 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 5 ) ) && enemy:ANPlusGetHitGroupBone( 5 ) || 
	enemy:ANPlusGetHitGroupBone( 6 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 6 ) ) && enemy:ANPlusGetHitGroupBone( 6 ) || 
	enemy:ANPlusGetHitGroupBone( 7 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 7 ) ) && enemy:ANPlusGetHitGroupBone( 7 ) || 
	enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	local eneVel = enemy:IsNPC() && enemy:GetMoveType() == 3 && enemy:GetGroundSpeedVelocity() || enemy:GetVelocity()	
	local dstSqr, dist = self:ANPlusGetRange( enemy )
	local dirCorrect = math.max( self.Secondary.EntitySpeed, 1 )
	dirCorrect = dist / dirCorrect
	local shootAng = targetPos && ( ( targetPos + ( ( eneVel + addVel ) * dirCorrect ) - muzzlePos ):GetNormalized() ):Angle() || owner:GetAimVector():Angle()
	local dir = shootAng:Forward()
	--local shootAng = owner:GetAimVector():Angle()
    shootAng.p = shootAng.p + math.Rand( -spread, spread )
    shootAng.y = shootAng.y + math.Rand( -spread, spread )
	
	for i = 1, self.Secondary.NumShots do

		local ent = ents.Create( entity )	
		ent:SetPos( muzzlePos + att.Ang:Forward() * 20 )
		ent:SetAngles( shootAng )
		ent:SetOwner( owner )
		if isfunction( entPreCallback ) then			
			ent.m_cPreSpawnCB = entPreCallback
			ent:m_cPreSpawnCB( ent )			
		end
		ent:Spawn()
		
		local phys = IsValid(ent:GetPhysicsObject()) && ent:GetMoveType() != 4 && ent:GetPhysicsObject() || ent
		
		if self.Secondary.EntitySpeed > 0 then
			if phys:IsValid() then
				phys:SetVelocity( ( ent:GetForward() * self.Secondary.EntitySpeed ) + addVel )
			else
				ent:SetVelocity( ( ent:GetForward() * self.Secondary.EntitySpeed ) + addVel )
			end
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
		
		callback( muzzlePos, shootAng, dir, att )
			
	end
	
end

function SWEP:ANPlusWeaponFireBullet(hShotChan, bulletcallback, callback, att) -- bulletcallback = function(att, tr, dmginfo) | callback = function( origin, vector )
	local att = att || self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	local muzzlePos = enemy && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || 
	enemy:ANPlusGetHitGroupBone( 2 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 2 ) ) && enemy:ANPlusGetHitGroupBone( 2 ) || 
	enemy:ANPlusGetHitGroupBone( 3 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 3 ) ) && enemy:ANPlusGetHitGroupBone( 3 ) || 
	enemy:ANPlusGetHitGroupBone( 4 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 4 ) ) && enemy:ANPlusGetHitGroupBone( 4 ) || 
	enemy:ANPlusGetHitGroupBone( 5 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 5 ) ) && enemy:ANPlusGetHitGroupBone( 5 ) || 
	enemy:ANPlusGetHitGroupBone( 6 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 6 ) ) && enemy:ANPlusGetHitGroupBone( 6 ) || 
	enemy:ANPlusGetHitGroupBone( 7 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 7 ) ) && enemy:ANPlusGetHitGroupBone( 7 ) || 
	enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
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
		bullet.AmmoType 	= self.Primary.Ammo
		bullet.Callback 	= function(att, tr, dmginfo)

			if self.Primary.TracerEffect && self.Primary.TracerEffect['Effect'] then	
				local toN = tonumber( self.Primary.TracerEffect['AttachmentIndex'] )	
				net.Start( "anplus_swep_base_tracer" )
					net.WriteEntity( self )
					net.WriteVector( muzzlePos )
					net.WriteVector( tr.HitPos )
					net.WriteString( self.Primary.TracerEffect['Effect'] )
					net.WriteBool( self.Primary.TracerEffect['DoWhiz'] )
					net.WriteFloat( toN || -1 )
				net.Broadcast()
			end

			if isfunction( bulletcallback ) then bulletcallback(att, tr, dmginfo) end
			
		end

	self:FireBullets( bullet )
	
	if isfunction( callback ) then
		
		callback( muzzlePos, dir, att )
			
	end 
	
end

function SWEP:ANPlusWeaponFireBullet2(hShotChan, bulletcallback, callback, att) -- bulletcallback = function(att, tr, dmginfo) | callback = function( origin, vector )
	local att = att || self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	local muzzlePos = enemy && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || 
	enemy:ANPlusGetHitGroupBone( 2 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 2 ) ) && enemy:ANPlusGetHitGroupBone( 2 ) || 
	enemy:ANPlusGetHitGroupBone( 3 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 3 ) ) && enemy:ANPlusGetHitGroupBone( 3 ) || 
	enemy:ANPlusGetHitGroupBone( 4 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 4 ) ) && enemy:ANPlusGetHitGroupBone( 4 ) || 
	enemy:ANPlusGetHitGroupBone( 5 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 5 ) ) && enemy:ANPlusGetHitGroupBone( 5 ) || 
	enemy:ANPlusGetHitGroupBone( 6 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 6 ) ) && enemy:ANPlusGetHitGroupBone( 6 ) || 
	enemy:ANPlusGetHitGroupBone( 7 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 7 ) ) && enemy:ANPlusGetHitGroupBone( 7 ) || 
	enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	spread = self:GetOwner():IsMoving() && self.m_fSecondarySpread * self.m_fSecondarySpreadMMult || self.m_fSecondarySpread	
	local direction = targetPos && ( targetPos - muzzlePos ):GetNormalized() || owner:GetAimVector()
	
	local bullet = {}
		bullet.Attacker 	= self:GetOwner()
		bullet.Num 			= self.Secondary.NumShots
		bullet.Src 			= muzzlePos
		bullet.Dir 			= direction
		bullet.Tracer 		= self.Secondary.Tracer
		bullet.TracerName 	= self.Secondary.TracerName
		bullet.Spread 		= Vector( spread, spread, 0 )
		bullet.Damage 		= self.Secondary.Damage
		bullet.Force 		= self.Secondary.Force
		bullet.AmmoType 	= self.Secondary.Ammo
		bullet.Callback 	= function(att, tr, dmginfo)

			if self.Secondary.TracerEffect && self.Secondary.TracerEffect['Effect'] then	
				local toN = tonumber( self.Secondary.TracerEffect['AttachmentIndex'] )	
				net.Start( "anplus_swep_base_tracer" )
					net.WriteEntity( self )
					net.WriteVector( muzzlePos )
					net.WriteVector( tr.HitPos )
					net.WriteString( self.Secondary.TracerEffect['Effect'] )
					net.WriteBool( self.Secondary.TracerEffect['DoWhiz'] )
					net.WriteFloat( toN || -1 )
				net.Broadcast()
			end

			if isfunction( bulletcallback ) then bulletcallback(att, tr, dmginfo) end
			
		end

	self:FireBullets( bullet )
	
	if isfunction( callback ) then
		
		callback( muzzlePos, dir, att )
			
	end
	
end

function SWEP:ANPlusWeaponFireCustom(hShotChan, callback, att) -- callback( muzzlePos, dirSprd, dir, att )
	local att = att || self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	local muzzlePos = enemy && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || 
	enemy:ANPlusGetHitGroupBone( 2 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 2 ) ) && enemy:ANPlusGetHitGroupBone( 2 ) || 
	enemy:ANPlusGetHitGroupBone( 3 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 3 ) ) && enemy:ANPlusGetHitGroupBone( 3 ) || 
	enemy:ANPlusGetHitGroupBone( 4 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 4 ) ) && enemy:ANPlusGetHitGroupBone( 4 ) || 
	enemy:ANPlusGetHitGroupBone( 5 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 5 ) ) && enemy:ANPlusGetHitGroupBone( 5 ) || 
	enemy:ANPlusGetHitGroupBone( 6 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 6 ) ) && enemy:ANPlusGetHitGroupBone( 6 ) || 
	enemy:ANPlusGetHitGroupBone( 7 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 7 ) ) && enemy:ANPlusGetHitGroupBone( 7 ) || 
	enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	
	spread = self:GetOwner():IsMoving() && self.m_fPrimarySpread * self.m_fPrimarySpreadMMult || self.m_fPrimarySpread	
	local dirSprd = targetPos && ( targetPos - muzzlePos ):GetNormalized() || owner:GetAimVector()
	local dir = dirSprd
	--local shootAngle = owner:GetAimVector():Angle()
    dirSprd.x = dirSprd.x + math.Rand( -spread, spread )
    dirSprd.y = dirSprd.y + math.Rand( -spread, spread )
	
	if isfunction( callback ) then
		
		callback( muzzlePos, dirSprd, dir, att )
			
	end
	
end

function SWEP:ANPlusWeaponFireCustom2(hShotChan, callback, att) -- callback( muzzlePos, dirSprd, dir, att )
	local att = att || self:GetAttachment( self.MuzzleAttachment )
	local owner = self:GetOwner()
    local enemy = owner:GetEnemy()
	local muzzlePos = enemy && owner:ANPlusInRange( enemy, 16384 ) && att.Pos || owner:WorldSpaceCenter()	
	local targetPos = enemy && ( ( ( isbool( hShotChan ) && hShotChan == true && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && enemy:ANPlusGetHitGroupBone( 1 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 1 ) ) && enemy:ANPlusGetHitGroupBone( 1 ) ) || 
	enemy:ANPlusGetHitGroupBone( 2 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 2 ) ) && enemy:ANPlusGetHitGroupBone( 2 ) || 
	enemy:ANPlusGetHitGroupBone( 3 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 3 ) ) && enemy:ANPlusGetHitGroupBone( 3 ) || 
	enemy:ANPlusGetHitGroupBone( 4 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 4 ) ) && enemy:ANPlusGetHitGroupBone( 4 ) || 
	enemy:ANPlusGetHitGroupBone( 5 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 5 ) ) && enemy:ANPlusGetHitGroupBone( 5 ) || 
	enemy:ANPlusGetHitGroupBone( 6 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 6 ) ) && enemy:ANPlusGetHitGroupBone( 6 ) || 
	enemy:ANPlusGetHitGroupBone( 7 ) && self:VisibleVec( enemy:ANPlusGetHitGroupBone( 7 ) ) && enemy:ANPlusGetHitGroupBone( 7 ) || 
	enemy:BodyTarget( muzzlePos ) || enemy:WorldSpaceCenter() || enemy:GetPos() )
	
	spread = self:GetOwner():IsMoving() && self.m_fSecondarySpread * self.m_fSecondarySpreadMMult || self.m_fSecondarySpread	
	local dirSprd = targetPos && ( targetPos - muzzlePos ):GetNormalized() || owner:GetAimVector()
	local dir = dirSprd
	--local shootAngle = owner:GetAimVector():Angle()
    dirSprd.x = dirSprd.x + math.Rand( -spread, spread )
    dirSprd.y = dirSprd.y + math.Rand( -spread, spread )
	
	if isfunction( callback ) then
		
		callback( muzzlePos, dirSprd, dir, att )
			
	end
	
end

function SWEP:ANPlusReload()
end

function SWEP:Reload(owner)

	if self:Clip1() >= self:GetMaxClip1() || self.Primary.InfiniteAmmo || self.m_bClipReloaded then return end

	self:ANPlusResetFire()
	self:GenerateBurst()
	self:ANPlusReload()
	owner:ClearCondition( COND.NO_PRIMARY_AMMO )
	owner:ClearCondition( COND.LOW_PRIMARY_AMMO )

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

		local enemy = owner:GetEnemy()

		local oACT = owner:GetActivity()	
		if oACT == ACT_RELOAD || oACT == ACT_RELOAD_LOW || owner:IsPlayingGesture( ACT_GESTURE_RELOAD ) then
			self:Reload(owner)
		end		
		
		if self:Clip1() <= self:GetMaxClip1() * 0.3 && self:Clip1() > 0 && ( !IsValid(enemy) || IsValid(enemy) && !owner:Visible(enemy) ) then  
			owner:SetCondition( COND.LOW_PRIMARY_AMMO )
		elseif self:Clip1() <= 0 then 
			owner:SetCondition( COND.NO_PRIMARY_AMMO )	
        end
		
		if IsValid(enemy) && owner:Visible( enemy ) && ( owner:HasCondition( 21 ) || owner:HasCondition( 22 ) ) then

			self:SetNW2Vector( "m_vecANPSWEPEnemyPos", enemy:ANPlusGetHitGroupBone( 1 ) || enemy:ANPlusGetHitGroupBone( 2 ) || enemy:GetPos() + enemy:OBBCenter() ) 

		elseif ( !IsValid(owner:GetInternalVariable( "m_hLookTarget" )) || !owner:Visible( owner:GetInternalVariable( "m_hLookTarget" ) ) ) || ( !owner:HasCondition( 21 ) && !owner:HasCondition( 22 ) ) then

			self:SetNW2Vector( "m_vecANPSWEPEnemyPos", vector_zero ) 

		end
		
		if self:CanSecondaryAttack() then
			self:SecondaryAttack()
		end
		
	end
	
	self:ANPlusWorldModelUpdate()
	
end

function SWEP:ANPlusTranslateActivity( act )
end

function SWEP:ANPlusNPCTriggerPull( shootPos, shootDir )
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )

	if !self:ANPlusCanPrimaryFire() then return end
	
	local owner = self:GetOwner()
	
	self:ANPlusNPCTriggerPull( shootPos, shootDir )
	
	if self.m_fCurBurstCount <= 0 then 
	
		timer.Create( "ANPlusCancelFire" .. self:EntIndex(), self:GetNPCCurRestTime(), 1, function() -- NPCs can't fire faster that 0.01 using this function?	
			
			if !IsValid(self) || !IsValid(self:GetOwner()) then timer.Remove( "ANPlusFire" .. self:EntIndex() ) return end	

			timer.Remove( "ANPlusFire" .. self:EntIndex() )

			self:GenerateBurst() -- Prepare new current burst count for our new burst.

		end)	
		
		return false 	

	end
	
	timer.Create( "ANPlusFire" .. self:EntIndex(), 0, 0, function()

		if !IsValid(self) || !IsValid(owner) || !self:CanPrimaryAttack() then	
			--timer.Remove( "ANPlusFire" .. self:EntIndex() )	
			return false 
		end	
		
		self:PrimaryAttack()

	end)
end

function SWEP:GenerateBurst() -- Cuz I can't get the current burst count && rest time, I have to calculate it myself... >:(	
	self.m_fCurRestCalc = math.Round( math.Rand( self.NPCRestMin, self.NPCRestMax ), 2 )
	self.m_fCurBurstCalc = self.NPCBurstMax > 0 && math.random( self.NPCBurstMin, self.NPCBurstMax ) || 99 -- Let's check if our max burst count is higher than 0. If not, screw the burst mechanic && just go brrrrrr.
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
	return self.WeaponCapabilities
end

function SWEP:GetOwnerProfTab(wp)
	if !IsValid(self:GetOwner()) then return end
	return self.NPCWeaponProficiencyTab[ wp || self:GetOwner():GetCurrentWeaponProficiency() ] || self.NPCWeaponProficiencyTab[ 4 ]
end

function SWEP:GetNPCBulletSpread(wp)
	-- Handles the bullet spread based on the given proficiency (wp)
	-- return value is in degrees

	local profNPC = self:GetOwnerProfTab( wp )

	if profNPC then
		self.m_fPrimarySpread 			= profNPC['Spread'] || 0.01
		self.m_fPrimarySpreadMMult  	= profNPC['SpreadMoveMult'] || 1
		self.m_fSecondarySpread 		= profNPC['Spread2'] || profNPC['Spread']
		self.m_fSecondarySpreadMMult	= profNPC['SpreadMoveMult2'] || profNPC['SpreadMoveMult']
		self.NPCRestMin					= profNPC['BurstRestMin'] || 0.1
		self.NPCRestMax					= profNPC['BurstRestMax'] || 0.1
		self.NPCBurstMin				= profNPC['BurstMin'] || 3
		self.NPCBurstMax				= profNPC['BurstMax'] || 3
		self.m_fHChance					= profNPC['HeadshotChance'] || 20

		self:SetSaveValue( "m_fMinRange1", 0 )
		self:SetSaveValue( "m_fMaxRange1", profNPC['RangeMax'] || self:GetInternalVariable( "m_fMaxRange1" ) )
		self:SetSaveValue( "m_fMinRange2", 0 )
		self:SetSaveValue( "m_fMaxRange2", profNPC['RangeMax2'] || self:GetInternalVariable( "m_fMaxRange2" ) )

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

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:FireAnimationEvent( pos, ang, event, options )
	
	-- Disables animation based muzzle event
	-- print(event)
	if self.EventDisable && self.EventDisable[ event ] then return true end

end

function SWEP:ANPlusDeploy()
	return true
end

function SWEP:Deploy()
	return self:ANPlusDeploy()
end

function SWEP:ANPlusHolster(ent)
	return true
end

function SWEP:Holster(ent)
	self:StopParticles()
	if self.Primary.PreFireSound then self:StopSound( self.Primary.PreFireSound ) end
	if self.Primary.PostFireSound then self:StopSound( self.Primary.PostFireSound ) end
	if self.FireLoopSound then self.FireLoopSound:Stop() end	
	self.m_bWeaponReady = false

	return self:ANPlusHolster( ent )
end

function SWEP:ANPlusEquip(ent)
end

function SWEP:Equip(ent)

	if ent:IsPlayer() then self:Remove() return false end	
	if ent:GetClass() == "npc_citizen" then ent:Fire("DisableWeaponPickup") end
	if self.NPCCapabilities then ent:CapabilitiesAdd( self.NPCCapabilities ) end

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
	if (CLIENT) then if IsValid(self.m_pFLProjText) then self.m_pFLProjText:Remove() end end
end

if (CLIENT) then

	net.Receive( "anplus_swep_base_tracer", function()	
		local ent = net.ReadEntity()
		local muzzleP = net.ReadVector()
		local hitP = net.ReadVector()
		local effect = net.ReadString()
		local whiz = net.ReadBool()
		local att = net.ReadFloat()
		util.ParticleTracerEx( effect, muzzleP, hitP, whiz, ent:EntIndex(), att )
	end )

	local defFov = GetConVar( "fov_desired" )
	
	local fLightDistStart = GetConVar( "anplus_swep_flight_fade_distance_start" )
	local fLightDist = GetConVar( "anplus_swep_flight_fade_distance" )
	
	local lStart = GetConVar( "anplus_swep_laser_fade_distance_start" )
	local lDist = GetConVar( "anplus_swep_laser_fade_distance" )
	
	function SWEP:ANPlusPreDrawEffects()
	end
	
	function SWEP:SWEPPreDrawEffects()

		local owner = self:GetOwner()
		
		if self.FlashlightTab then
				
			if IsValid(self.m_pFLProjText) then
			
				local tab = self.FlashlightTab
				
				if fLightSmartMode:GetBool() && CurTime() - self.m_fCheckLightLast >= self.m_fCheckLightDelay then
					local col = render.GetLightColor( self:GetPos() )
					self.m_fLightLevel = ( col.x * 0.299 ) + ( col.y * 0.587 ) + ( col.z * 0.114 )
					
					if IsValid(owner) then

						if self.m_fLightLevel < 0.0055 && !self:GetNoDraw() then

							if !self:ANPlusIsWepFLightEnabled() then
								self.m_pFLProjText:SetNearZ( tab['FlashLightNearZ'] )
								self.m_pFLProjText:SetBrightness( 1 )
							end
							
						else

							if self:ANPlusIsWepFLightEnabled() then
								self.m_pFLProjText:SetNearZ( 0 )
								self.m_pFLProjText:SetBrightness( 0 )							
							end

						end

					end
					
					self.m_fCheckLightLast = CurTime() + self.m_fCheckLightDelay
				end
				
				if self:ANPlusIsWepFLightEnabled() then	
					
					local bone = self:LookupBone( tab['Attachment'] )
					local matrix
					if bone then
						matrix = bone && self:GetBoneMatrix( bone )
						local pos = matrix:GetTranslation()
						local ang = matrix:GetAngles()
						matrix = { Pos = pos, Ang = ang }
					end		
					local attTab = matrix || self:GetAttachment( tab['Attachment'] )
					local col = tab['Color']
					
					local ply = LocalPlayer()					
					local viewEnt = ply:GetViewEntity()	
					local dSqr, d = ANPlusGetRangeVector( viewEnt:GetPos(), attTab.Pos )	
					local transFov = math.Remap( ply:GetFOV(), 0, defFov:GetFloat(), 0, 1 )						
					local plyToLightAng = ( ply:GetPos() - self.m_pFLProjText:GetPos() ):Angle()
					plyToLightAng = ANPlusNormalizeAngle( plyToLightAng, attTab.Ang )	
					local p = math.Remap( plyToLightAng.p, -180, 180, 0, 255 )
					local y = math.Remap( plyToLightAng.y, -180, 180, 0, 255 )
					p = math.abs( plyToLightAng.p )
					y = math.abs( plyToLightAng.y )
					local ang = math.max( p , y ) * 3					
					local bright = math.Remap( math.min( d * transFov - fLightDistStart:GetFloat(), fLightDist:GetFloat() ), 1, fLightDist:GetFloat(), 1, 0 )	
					local alpha = math.Remap( math.min( d * transFov - fLightDistStart:GetFloat(), fLightDist:GetFloat() ), 1, fLightDist:GetFloat(), 255, 0 )	
					alpha = math.min( alpha, 255 )
					alpha = math.max( alpha - ang, 0 )
					
					
					if IsValid(owner) then
						self.m_pFLProjText:SetBrightness( bright )
						col = Color( col.r, col.g, col.b, alpha )
					else
						if CurTime() - self.m_fAttachmentFlickerLast >= 0.6 then
							self.m_fAttachmentFlicker = self.m_fAttachmentFlicker == 1 && 0 || 1

							self.m_fAttachmentFlickerLast = CurTime() + math.random( 0.01, 0.6 )
						end
						self.m_fAttachmentFlicker = self.m_fAttachmentFlicker == 1 && 1 || math.Approach( self.m_fAttachmentFlicker, 1, 0.06 )
						self.m_pFLProjText:SetBrightness( bright * self.m_fAttachmentFlicker )
						col = Color( col.r, col.g, col.b, alpha * self.m_fAttachmentFlicker )
					end
					
					local newPos, newAng = LocalToWorld( tab['Pos'], tab['Ang'], attTab.Pos, attTab.Ang )	
					
					self.m_pFLProjText:SetPos( newPos )
					self.m_pFLProjText:SetAngles( newAng )		
										
					render.SetMaterial( tab['SpriteMat'] )
					render.ANPlusDrawSpriteParallax( newPos, tab['SpriteMins'][ 1 ], tab['SpriteMins'][ 2 ], tab['SpriteMaxs'][ 1 ], tab['SpriteMaxs'][ 2 ], 2000, col )
					
				end
				self.m_pFLProjText:Update()
			end
			
		end
		
		if self.LaserTab && !self:GetNoDraw() then
		
			local tab = self.LaserTab
			local bone = self:LookupBone( tab['Attachment'] )
			local matrix
			if bone then
				matrix = bone && self:GetBoneMatrix( bone )
				local pos = matrix:GetTranslation()
				local ang = matrix:GetAngles()
				matrix = { Pos = pos, Ang = ang }
			end		
			local attTab = matrix || self:GetAttachment( tab['Attachment'] )

			local newPos, newAng = LocalToWorld( tab['Pos'], tab['Ang'], attTab.Pos, attTab.Ang )	
			local col = tab['Color']
			local ply = LocalPlayer()					
			local viewEnt = ply:GetViewEntity()	
			local dSqr, d = ANPlusGetRangeVector( viewEnt:GetPos(), attTab.Pos )	
			local transFov = math.Remap( ply:GetFOV(), 0, defFov:GetFloat(), 0, 1 )	
			local alpha = tab['LaserNoFade'] && 255 || math.Remap( math.min( d * transFov - lStart:GetFloat(), lDist:GetFloat() ), 1, lDist:GetFloat(), 255, 0 )
			if alpha > 0 then
				
				if IsValid(owner) then
					col = Color( col.r, col.g, col.b, alpha )
				else
					if CurTime() - self.m_fAttachmentFlickerLast >= 0.6 then
						self.m_fAttachmentFlicker = self.m_fAttachmentFlicker == 1 && 0 || 1

						self.m_fAttachmentFlickerLast = CurTime() + math.random( 0.01, 0.6 )
					end
					self.m_fAttachmentFlicker = self.m_fAttachmentFlicker == 1 && 1 || math.Approach( self.m_fAttachmentFlicker, 1, 0.06 )
					col = Color( col.r, col.g, col.b, alpha * self.m_fAttachmentFlicker )
				end
				
				local endPos = vector_zero != self:GetNW2Vector( "m_vecANPSWEPEnemyPos" ) && IsValid(owner) && d <= tab['LaserSize'][ 1 ] && self:ANPlusValidAnglesNormal( self:GetNW2Vector( "m_vecANPSWEPEnemyPos" ), angCheck ) && self:GetNW2Vector( "m_vecANPSWEPEnemyPos" ) || newPos + newAng:Forward() * tab['LaserSize'][ 1 ]
				
				local tr = util.TraceLine( {
					start = newPos,
					endpos = endPos,
					filter = { self, owner },
				} )
				
				if tab['StartDotMat'] then
					render.SetMaterial( tab['StartDotMat'] )
					render.DrawSprite( newPos, tab['StartDotSize'][ 1 ], tab['StartDotSize'][ 2 ], col )
				end
				
				if tab['LaserMat'] then
					render.SetMaterial( tab['LaserMat'] )
					render.DrawBeam( newPos, tr.HitPos, tab['LaserSize'][ 2 ], 0, 1, col )
				end
				
				if tab['EndDotMat'] && tr.Hit == true then
					render.SetMaterial( tab['EndDotMat'] )
					render.DrawSprite( tr.HitPos, tab['EndDotSize'][ 1 ], tab['EndDotSize'][ 2 ], col ) 
				end
			end
		end
		
		self:ANPlusPreDrawEffects()

	end
	
	function SWEP:ANPlusPostDrawEffects()
	end
	
	function SWEP:SWEPPostDrawEffects()
		self:ANPlusPostDrawEffects()
	end
	
	function SWEP:ANPlusDrawWorldModel()
		return true
	end
	
	function SWEP:ANPlusGetWepFLight()
		return self.m_pFLProjText
	end
	
	function SWEP:ANPlusIsWepFLightEnabled()
		if IsValid(self.m_pFLProjText) then
			return self.m_pFLProjText:GetNearZ() > 0 || self.m_pFLProjText:GetBrightness() <= 0
		else
			return false
		end
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