sound.Add( {
	name = "ANP.WEAPON.HL1.MP5.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "weapons/anp/hl1_mp5/fire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.MP5.Alt",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 85,
	pitch = 100,
	sound = "weapons/anp/hl1_mp5/fire_alt.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.MP5.Reload",
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

SWEP.WorldModel						= "models/weapons/w_9mmar.mdl"
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
SWEP.NPCCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1 + CAP_INNATE_RANGE_ATTACK1 + CAP_WEAPON_RANGE_ATTACK2 + CAP_INNATE_RANGE_ATTACK2
SWEP.WeaponCapabilities				= SERVER && CAP_WEAPON_RANGE_ATTACK1 + CAP_INNATE_RANGE_ATTACK1 + CAP_WEAPON_RANGE_ATTACK2 + CAP_INNATE_RANGE_ATTACK2
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
		['BurstRestMin']	= 0.1,
		['BurstRestMax']	= 0.1,
		['BurstMin']		= 3,
		['BurstMax']		= 3,
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
		['BurstRestMin']	= 0.1,
		['BurstRestMax']	= 0.1,
		['BurstMin']		= 3,
		['BurstMax']		= 3,
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
		['BurstRestMin']	= 0.1,
		['BurstRestMax']	= 0.1,
		['BurstMin']		= 3,
		['BurstMax']		= 3,
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
		['BurstRestMin']	= 0.1,
		['BurstRestMax']	= 0.1,
		['BurstMin']		= 3,
		['BurstMax']		= 3,
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
		['BurstRestMin']	= 0.1,
		['BurstRestMax']	= 0.1,
		['BurstMin']		= 3,
		['BurstMax']		= 3,
		['HeadshotChance']	= 50,
	},
}

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.HL1.MP5.Fire"
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= "ANP.WEAPON.HL1.MP5.Reload"
SWEP.Primary.DSound					= "Auto"

SWEP.Primary.Damage					= 8
SWEP.Primary.Force					= 1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Delay					= 1 / ( 600 / 60 ) -- Where 450 is the RPM


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
SWEP.Primary.ClipSize				= 50
SWEP.Primary.DefaultClip			= 50

SWEP.Secondary.FireSound			= "ANP.WEAPON.HL1.MP5.Alt"
SWEP.Secondary.FireLoopSound		= nil
SWEP.Secondary.PreFireSound			= nil
SWEP.Secondary.PostFireSound		= nil
SWEP.Secondary.ReloadSound			= nil
SWEP.Secondary.DistantSound			= nil
SWEP.Secondary.Attack				= ACT_RANGE_ATTACK_SHOTGUN
SWEP.Secondary.AttackGesture		= ACT_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.Secondary.Damage				= 100
SWEP.Secondary.Radius				= 150
SWEP.Secondary.EntitySpeed			= 1000
SWEP.Secondary.NumShots				= 1
SWEP.Secondary.AmmoPerShot			= 1
SWEP.Secondary.Grenades				= 2

SWEP.Secondary.Delay				= 15
SWEP.Secondary.PreFireDelay			= 0.5
SWEP.Secondary.PreFireReset			= 0.5
SWEP.Secondary.PrimaryCooldown		= 2

-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire(hShot)

	self:ANPlusWeaponFireBullet( hShot, function(attacker, tr, dmg)			
	end,

	function( origin, vector, att )
								
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 20, nil, "MuzzleFlash", 1 )
		
		local bone = self:LookupBone( "Line02" )
		local bPos, bAng = self:GetBonePosition( bone )

		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetOrigin( bPos )
		fx:SetStart( self:GetRight() * math.random( 50, 140 ) + self:GetForward() * math.random( -25, 25 )  )
		fx:SetAngles( self:GetAngles() + Angle( 0, 90, 0 ) )
		fx:SetFlags( 0 )
		util.Effect( "HL1ShellEject", fx )
		
	end)
	
end


function SWEP:ANPlusCanSecondaryFire()	
	return self.Secondary.Grenades > 0
end

function SWEP:ANPlusNPCFire2(hShot)

	local owner = self:GetOwner()
	local enemy = owner:GetEnemy()
	local addVel
	if IsValid(enemy) then
		--local eDir = ( enemy:GetPos() - owner:GetPos() )
		--addVel = Vector( 0, 0, eDir.z )
		local distSqr, dist = owner:ANPlusGetRange( enemy )
		addVel = Vector( 0, 0, dist / 12 )
	end

	self:ANPlusWeaponFireEntity2( "grenade_ar2", addVel, false, nil, function(ent) 
		ent:SetModel( "models/grenade.mdl" )
		ent:SetLocalAngularVelocity( Angle( 600, 0, 0) )
		ent:SetSaveValue( "m_flDamage", self.Secondary.Damage )
		ent:SetSaveValue( "m_DmgRadius", self.Secondary.Radius )
	end,

	function( origin, vector, att )
								
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 20, nil, "MuzzleFlash", 0 )
		
	end )

	self.Secondary.Grenades = self.Secondary.Grenades - self.Secondary.AmmoPerShot

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