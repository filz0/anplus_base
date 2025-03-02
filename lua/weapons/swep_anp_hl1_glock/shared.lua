sound.Add( {
	name = "ANP.WEAPON.HL1.GLOCK.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "weapons/anp/hl1_glock/fire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.GLOCK.Reload",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 100, 
	sound = "weapons/anp/hl1_glock/reload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/weapons/w_9mmhandgun.mdl"
SWEP.WorldModelCustomiseTab			= nil
SWEP.HoldType						= "pistol"
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
SWEP.NPCCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1 + CAP_INNATE_RANGE_ATTACK1
SWEP.WeaponCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1 + CAP_INNATE_RANGE_ATTACK1
SWEP.NPCWeaponProficiencyTab 		= {
	[WEAPON_PROFICIENCY_POOR] 		= {
		['Spread']			= 0.04,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.08,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['RangeMin2']		= 512,
		['RangeMax2']		= 1800,
		['BurstRestMin']	= 0.06,
		['BurstRestMax']	= 0.09,
		['BurstMin']		= 3,
		['BurstMax']		= 5,
		['HeadshotChance']	= 5,
	},
	[WEAPON_PROFICIENCY_AVERAGE] 	= {
		['Spread']			= 0.035,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.07,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['RangeMin2']		= 512,
		['RangeMax2']		= 1800,
		['BurstRestMin']	= 0.06,
		['BurstRestMax']	= 0.09,
		['BurstMin']		= 3,
		['BurstMax']		= 5,
		['HeadshotChance']	= 20,
	},
	[WEAPON_PROFICIENCY_GOOD] 		= {
		['Spread']			= 0.03,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.06,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['RangeMin2']		= 512,
		['RangeMax2']		= 1800,
		['BurstRestMin']	= 0.06,
		['BurstRestMax']	= 0.09,
		['BurstMin']		= 3,
		['BurstMax']		= 5,
		['HeadshotChance']	= 30,
	},
	[WEAPON_PROFICIENCY_VERY_GOOD] 	= {
		['Spread']			= 0.027,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.055,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['RangeMin2']		= 512,
		['RangeMax2']		= 1800,
		['BurstRestMin']	= 0.06,
		['BurstRestMax']	= 0.09,
		['BurstMin']		= 3,
		['BurstMax']		= 5,
		['HeadshotChance']	= 40,
	},
	[WEAPON_PROFICIENCY_PERFECT] 	= {
		['Spread']			= 0.022,
		['SpreadMoveMult']	= 1.3,
		['Spread2']			= 0.04,
		['SpreadMoveMult2']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['RangeMin2']		= 512,
		['RangeMax2']		= 1800,
		['BurstRestMin']	= 0.06,
		['BurstRestMax']	= 0.09,
		['BurstMin']		= 3,
		['BurstMax']		= 5,
		['HeadshotChance']	= 50,
	},
}

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.HL1.GLOCK.Fire"
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= "ANP.WEAPON.HL1.GLOCK.Reload"
SWEP.Primary.DSound					= "Auto"

SWEP.Primary.Damage					= 8
SWEP.Primary.Force					= 1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Delay					= 1 / ( 200 / 60 ) -- Where 450 is the RPM


SWEP.Primary.SecondaryCooldown		= 1

SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "anp_tracer_3d"
SWEP.ANPTracerSettingTab			= {	
	['TracerMat']				= nil,
	['TracerLength']			= 60,	
	['TracerScale']				= 8,
	['TracerColor']				= Color( 255, 255, 0 ),
	
	['TrailMat']				= false,
}
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "9mmRound"
SWEP.Primary.ClipSize				= 17
SWEP.Primary.DefaultClip			= 17

-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire(hShot)

	self:ANPlusWeaponFireBullet( hShot, function(attacker, tr, dmg)			
	end,

	function( origin, vector, att )
								
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 11, nil, "MuzzleFlash", 1 )
		
		local bone = self:LookupBone( "sides01" )
		local bPos, bAng = self:GetBonePosition( bone )

		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetOrigin( bPos )
		fx:SetStart( self:GetRight() * math.random( 50, 140 ) + self:GetForward() * math.random( -25, 25 ) )
		fx:SetAngles( self:GetAngles() + Angle( 0, 90, 0 ) )
		fx:SetFlags( 0 )
		util.Effect( "HL1ShellEject", fx )
		
	end)
	
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