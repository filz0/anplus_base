sound.Add( {
	name = "ANP.WEAPON.HL1.CROSSBOW.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "weapons/anp/hl1_crossbow/fire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.CROSSBOW.Reload",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 100, 
	sound = "weapons/anp/hl1_crossbow/reload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/weapons/w_crossbow_hls.mdl"
SWEP.WorldModelCustomiseTab			= nil
SWEP.HoldType						= "smg"
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
		['Spread']			= 0.02,
		['SpreadMoveMult']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.02,
		['BurstRestMax']	= 0.04,
		['BurstMin']		= 1,
		['BurstMax']		= 1,
		['HeadshotChance']	= 5,
	},
	[WEAPON_PROFICIENCY_AVERAGE] 	= {
		['Spread']			= 0.018,
		['SpreadMoveMult']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.02,
		['BurstRestMax']	= 0.03,
		['BurstMin']		= 1,
		['BurstMax']		= 1,
		['HeadshotChance']	= 20,
	},
	[WEAPON_PROFICIENCY_GOOD] 		= {
		['Spread']			= 0.015,
		['SpreadMoveMult']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.01,
		['BurstRestMax']	= 0.03,
		['BurstMin']		= 1,
		['BurstMax']		= 1,
		['HeadshotChance']	= 30,
	},
	[WEAPON_PROFICIENCY_VERY_GOOD] 	= {
		['Spread']			= 0.013,
		['SpreadMoveMult']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.01,
		['BurstRestMax']	= 0.02,
		['BurstMin']		= 1,
		['BurstMax']		= 1,
		['HeadshotChance']	= 50,
	},
	[WEAPON_PROFICIENCY_PERFECT] 	= {
		['Spread']			= 0.01,
		['SpreadMoveMult']	= 1.3,
		['RangeMin']		= nil,
		['RangeMax']		= nil,
		['BurstRestMin']	= 0.01,
		['BurstRestMax']	= 0.015,
		['BurstMin']		= 1,
		['BurstMax']		= 1,
		['HeadshotChance']	= 70,
	},
}

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.HL1.CROSSBOW.Fire"
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= "ANP.WEAPON.HL1.CROSSBOW.Reload"
SWEP.Primary.DSound					= "Auto"

SWEP.Primary.Damage					= 50
SWEP.Primary.DamageBlast			= 40
SWEP.Primary.Force					= 1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Delay					= 1 / ( 80 / 60 ) -- Where 450 is the RPM
SWEP.Primary.EntitySpeed			= 2500

SWEP.Primary.SecondaryCooldown		= 1

SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= ""
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "XBowBoltHL1"
SWEP.Primary.ClipSize				= 5
SWEP.Primary.DefaultClip			= 5

-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire(hShot)

	local owner = self:GetOwner()
	local enemy = owner:GetEnemy()
	local dmg = self.Primary.Damage
	local dmgB = self.Primary.DamageBlast
	local boneID = self:LookupBone( "Line01" )
	local Pos, Ang = self:GetBonePosition( boneID )
	local bone = { ['Pos'] = Pos, ['Ang'] = Ang }
	local addVel
	
	if IsValid(enemy) then

		local distSqr, dist = owner:ANPlusGetRange( enemy )
		addVel = Vector( 0, 0, dist / 20 )

	end
	
	self:ANPlusWeaponFireEntity( "sent_anp_hl1_crossbow_bolt", bone.Ang:Forward() * 20 + addVel, hShotChan, nil, function(ent) 

		ent.Damage = self.Primary.Damage
		ent.BlastDamage = self.Primary.DamageBlast
		ent.Radius = 100

	end, nil, bone ) 
	
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