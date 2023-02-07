sound.Add( {
	name = "ANP.WEAPON.Sterilizer.FireStart",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = SNDLVL_GUNFIRE,
	pitch = 90,
	sound = "weapons/sterilizer/flame_thrower_start.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.Sterilizer.FireEnd",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = SNDLVL_GUNFIRE,
	pitch = 90,
	sound = "weapons/sterilizer/flame_thrower_end.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.SynthRifle.FireLoop",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = SNDLVL_GUNFIRE,
	pitch = 80,
	sound = "weapons/sterilizer/flame_thrower_loop.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.SynthRifle.Reload",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 50, 
	sound = "npc/ministrider/hunter_flechette_preexplode3.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/cup/sterilizator/c_flaregun_pyro.mdl"
SWEP.WorldModelCustomiseTab	= {
	['Bone'] 	= "ValveBiped.Bip01_R_Hand",
	['Scale']	= {
		['weapon_bone'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 0.7, 0.7, 0.7 ), jiggle = 0  },
		['weapon_bone_2'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, -0.5, -2 ), scl = Vector( 0.7, 0.7, 1 ), jiggle = 0  },
		['weapon_bone_3'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, -1.2 ), scl = Vector( 0.7, 0.7, 0.7 ), jiggle = 0  },
		},
	['Ang']		= Angle( -105, 180, 0 ),
	['Pos'] 	= Vector( -1, 0.5, 2.5 ),
}
SWEP.HoldType						= "ar2"
SWEP.DropOnDeath					= true

-- SWEP aesthetics
SWEP.MuzzleAttachment				= "1"
SWEP.ShellAttachment				= "2"
SWEP.EventDisable = { -- Lets get rid of default effects on this model
	[3007] = true,
	[22] = true,
}
SWEP.Muzzle 						= "anp_muzzle_rifle"
SWEP.MuzzleSmoke 					= "anp_gunsmoke"

-- SWEP NPC settings
SWEP.NPCRestMin						= 0
SWEP.NPCRestMax						= 0
SWEP.NPCBurstMin					= 150
SWEP.NPCBurstMax					= 150

SWEP.NPCWeaponMaxRange				= 800
SWEP.NPCWeaponMinRange				= 200

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= nil--"ANP.WEAPON.Sterilizer.FireStart"
SWEP.Primary.PreFireSound			= "ANP.WEAPON.Sterilizer.FireStart"
SWEP.Primary.FireLoopSound			= "ANP.WEAPON.SynthRifle.FireLoop"
SWEP.Primary.PostFireSound			= "ANP.WEAPON.Sterilizer.FireEnd"
SWEP.Primary.ReloadSound			= "ANP.WEAPON.SynthRifle.Reload"
SWEP.Primary.DSound					= nil

SWEP.Primary.Damage					= 3
SWEP.Radius							= 10
SWEP.Life							= 2
SWEP.Primary.EntitySpeed			= 2500
SWEP.Primary.NumShots				= 1
SWEP.Primary.Spread					= 2 -- Spread
SWEP.Primary.MoveSpreadMult			= 2 -- Movement spread multiplier.
SWEP.Primary.Delay					= 1 / ( 1300 / 60 ) -- Where 450 is the RPM
SWEP.Primary.PreFireDelay			= 0.1
SWEP.Primary.PreFireReset			= nil  
SWEP.Primary.ClipSize				= 150
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= nil
SWEP.Primary.Force					= 3
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 150
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire()

	self:ANPlusWeaponFireEntity( "sent_anp_flame_proj", 

	function( ent )

		ent.Damage = self.Primary.Damage
		ent.Radius = self.Radius
		ent.Life = self.Life
		
	end,
	nil,
	function( origin, vector, att )
								
		--ParticleEffect( "steampuff", att.Pos, att.Ang, self )
		--ParticleEffect( "explosion_turret_fizzle", att.Pos, att.Ang, self )
		--local fx = EffectData()
		--fx:SetEntity( self )
		--fx:SetOrigin( att.Pos )
		--fx:SetAngles( att.Ang )
		--util.Effect( "anp_cup_flame_proj", fx )
		--self:ANPlusWeaponShootEffect( self.MuzzleAttachment, nil, 7, "MuzzleFlash", nil, nil )
	
	end)
	
end

function SWEP:ANPlusReload()
end

function SWEP:ANPlusThink()
end

function SWEP:ANPlusOnDrop()
end

function SWEP:ANPlusOnRemove()
end