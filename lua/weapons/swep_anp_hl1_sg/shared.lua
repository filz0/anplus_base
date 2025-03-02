sound.Add( {
	name = "ANP.WEAPON.HL1.SG.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "weapons/anp/hl1_sg/fire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.SG.Alt",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 85,
	pitch = 80,
	sound = "weapons/anp/hl1_sg/fire_alt.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.SG.Pump",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 100, 
	sound = "weapons/anp/hl1_sg/pump.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.SG.Reload",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 100, 
	sound = "weapons/anp/hl1_mp5/reload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/weapons/w_shotgun_hls.mdl"
SWEP.WorldModelCustomiseTab			= nil
SWEP.HoldType						= "shotgun"
SWEP.DropOnDeath					= true

-- SWEP aesthetics
SWEP.MuzzleAttachment				= "1"
SWEP.ShellEject						= "2"
SWEP.ShellAttachment				= nil
SWEP.EventDisable = { -- Lets get rid of default effects on this model
	[3007] = true,
	[22] = true,
	[6001] = true,
}
SWEP.Muzzle 						= nil
SWEP.MuzzleSmoke 					= nil

-- SWEP NPC Settings
SWEP.NPCCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1 + CAP_INNATE_RANGE_ATTACK1 + CAP_WEAPON_RANGE_ATTACK2 + CAP_INNATE_RANGE_ATTACK2
SWEP.WeaponCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1 + CAP_INNATE_RANGE_ATTACK1 + CAP_WEAPON_RANGE_ATTACK2 + CAP_INNATE_RANGE_ATTACK2
SWEP.NPCWeaponProficiencyTab 		= {
	[WEAPON_PROFICIENCY_POOR] 		= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.1,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= 200,
		['RangeMax']		= 700,
		['RangeMin2']		= 200,
		['RangeMax2']		= 500,
		['BurstRestMin']	= 0,
		['BurstRestMax']	= 0,
		['BurstMin']		= 0,
		['BurstMax']		= 0,
		['HeadshotChance']	= 5,
	},
	[WEAPON_PROFICIENCY_AVERAGE] 	= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.1,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= 200,
		['RangeMax']		= 700,
		['RangeMin2']		= 200,
		['RangeMax2']		= 500,
		['BurstRestMin']	= 0,
		['BurstRestMax']	= 0,
		['BurstMin']		= 0,
		['BurstMax']		= 0,
		['HeadshotChance']	= 20,
	},
	[WEAPON_PROFICIENCY_GOOD] 		= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.1,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= 200,
		['RangeMax']		= 700,
		['RangeMin2']		= 200,
		['RangeMax2']		= 500,
		['BurstRestMin']	= 0,
		['BurstRestMax']	= 0,
		['BurstMin']		= 0,
		['BurstMax']		= 0,
		['HeadshotChance']	= 30,
	},
	[WEAPON_PROFICIENCY_VERY_GOOD] 	= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.1,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= 200,
		['RangeMax']		= 700,
		['RangeMin2']		= 200,
		['RangeMax2']		= 500,
		['BurstRestMin']	= 0,
		['BurstRestMax']	= 0,
		['BurstMin']		= 0,
		['BurstMax']		= 0,
		['HeadshotChance']	= 40,
	},
	[WEAPON_PROFICIENCY_PERFECT] 	= {
		['Spread']			= 0.1,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.1,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= 200,
		['RangeMax']		= 700,
		['RangeMin2']		= 200,
		['RangeMax2']		= 500,
		['BurstRestMin']	= 0,
		['BurstRestMax']	= 0,
		['BurstMin']		= 0,
		['BurstMax']		= 0,
		['HeadshotChance']	= 50,
	},
}

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.HL1.SG.Fire"
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= "ANP.WEAPON.HL1.SG.Reload"
SWEP.Primary.DSound					= "Auto"

SWEP.Primary.Damage					= 5
SWEP.Primary.Force					= 2
SWEP.Primary.NumShots				= 6
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.Delay					= 1 / ( 80 / 60 ) -- Where 450 is the RPM


SWEP.Primary.SecondaryCooldown		= 1 / ( 40 / 60 )

SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "anp_tracer_3d"
SWEP.ANPTracerSettingTab			= {	
	['TracerMat']				= nil,
	['TracerLength']			= 40,	
	['TracerScale']				= 6,
	['TracerColor']				= Color( 255, 255, 0 ),
	
	['TrailMat']				= false,
}

SWEP.Primary.AmmoType				= "BuckshotHL1"
SWEP.Primary.ClipSize				= 8
SWEP.Primary.DefaultClip			= 8

SWEP.Secondary.FireSound			= "ANP.WEAPON.HL1.SG.Alt"
SWEP.Secondary.FireLoopSound		= nil
SWEP.Secondary.PreFireSound			= nil
SWEP.Secondary.PostFireSound		= nil
SWEP.Secondary.ReloadSound			= nil
SWEP.Secondary.DistantSound			= nil
SWEP.Secondary.Attack				= ACT_RANGE_ATTACK_SHOTGUN
SWEP.Secondary.AttackGesture		= ACT_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.Secondary.Damage				= 5
SWEP.Secondary.Force				= 3
SWEP.Secondary.EntitySpeed			= 0
SWEP.Secondary.NumShots				= 12
SWEP.Secondary.AmmoPerShot			= 2

SWEP.Secondary.Delay				= 5
SWEP.Secondary.PreFireDelay			= 0.5
SWEP.Secondary.PreFireReset			= 0
SWEP.Secondary.PrimaryCooldown		= 1 / ( 40 / 60 )

SWEP.Secondary.Tracer				= 1
SWEP.Secondary.TracerName			= "anp_tracer_3d"

-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire(hShot)

	local owner = self:GetOwner()

	self:ANPlusWeaponFireBullet( hShot, function(attacker, tr, dmg)			
	end,

	function( origin, vector, att )
								
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 31, nil, "MuzzleFlash", 1.5 )
		
	end)

	timer.Simple( 0.3, function()

		if !IsValid(self) || !IsValid(owner) then return end

		self:EmitSound( "ANP.WEAPON.HL1.SG.Pump" )
		
		local bone = self:LookupBone( "Box01" )
		local bPos, bAng = self:GetBonePosition( bone )

		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetOrigin( bPos )
		fx:SetStart( self:GetRight() * math.random( 50, 140 ) + self:GetForward() * math.random( -25, 25 ) )
		fx:SetAngles( self:GetAngles() + Angle( 0, 90, 0 ) )
		fx:SetFlags( 1 )
		util.Effect( "HL1ShellEject", fx )

	end )
	
end


function SWEP:ANPlusCanSecondaryFire()	
	
	return self:Clip1() >= 2
end

function SWEP:ANPlusNPCFire2(hShot)
	
	local owner = self:GetOwner()

	self:ANPlusWeaponFireBullet2( hShot, function(attacker, tr, dmg)			
	end,

	function( origin, vector, att )
								
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 41, nil, "MuzzleFlash", 1.5 )
		
	end)

	timer.Simple( 0.5, function()
		
		if !IsValid(self) || !IsValid(owner) then return end
		self:EmitSound( "ANP.WEAPON.HL1.SG.Pump" )
		
		local bone = self:LookupBone( "Box01" )
		local bPos, bAng = self:GetBonePosition( bone )

		for i = 1, 2 do

			local fx = EffectData()
			fx:SetEntity( self )
			fx:SetOrigin( bPos )
			fx:SetStart( self:GetRight() * math.random( 50, 140 ) + self:GetForward() * math.random( -25, 25 ) )
			fx:SetAngles( self:GetAngles() + Angle( 0, 90, 0 ) )
			fx:SetFlags( 1 )
			util.Effect( "HL1ShellEject", fx )

		end

	end )

	self:SetClip1( self:Clip1() - self.Secondary.AmmoPerShot )

end

function SWEP:ANPlusReload()
end

function SWEP:ANPlusThink()
end

function SWEP:ANPlusEquip(ent)
end

function SWEP:ANPlusOnDrop()
end

function SWEP:ANPlusOnRemove()	
end