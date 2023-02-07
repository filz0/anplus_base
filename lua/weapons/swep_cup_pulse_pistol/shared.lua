sound.Add( {
	name = "ANP.WEAPON.CUPPistol.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 75,
	pitch = 80,
	sound = { "weapons/cup_pistol/Gun3_1-2.wav", "weapons/cup_pistol/Gun3_2-2.wav", "weapons/cup_pistol/Gun3_3-2.wav", "weapons/cup_pistol/Gun3_4-2.wav" }
} )

sound.Add( {
	name = "ANP.WEAPON.CUPPistol.Reload",
	channel = CHAN_ITEM,
	volume = 0.9,
	level = 70,
	pitch = 100, 
	sound = "weapons/cup_pistol/Gun3_load-2.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/cup/cup_weapons/w_pistol.mdl"
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
SWEP.FlashlightTab = {
	['SmartMode'] 					= true, -- If true, flashlight will only activate if owner is in combat or alerted and deactivate if idle. If false, flashlight will activate on spawn.
	['SpotlightAttachment']			= "1",
	['SpotlightPos'] 				= Vector( -1, -1.2, -6 ),
	['SpotlightAng']				= Angle( 0, -90, 0 ),
	['SpotlightWidth']				= 5,
	['SpotlightLength']				= 20,
	['SpotlightColor']				= Color( 170, 255, 255, 255 ),
}
SWEP.Muzzle 						= nil
SWEP.MuzzleSmoke 					= nil

-- SWEP NPC settings
SWEP.NPCRestMin						= 0.5
SWEP.NPCRestMax						= 0.8
SWEP.NPCBurstMin					= 2
SWEP.NPCBurstMax					= 4

SWEP.NPCWeaponMaxRange				= nil
SWEP.NPCWeaponMinRange				= nil

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.CUPPistol.Fire"
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= "ANP.WEAPON.CUPPistol.Reload"
SWEP.Primary.DSound					= nil

SWEP.Primary.Damage					= 10
SWEP.Primary.NumShots				= 1
SWEP.Primary.Spread					= 0.01 -- Spread
SWEP.Primary.MoveSpreadMult			= 1.3 -- Movement spread multiplier.
SWEP.Primary.Delay					= 1 / ( 100 / 60 ) -- Where 450 is the RPM
SWEP.Primary.PreFireDelay			= nil
SWEP.Primary.PreFireReset			= nil
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "AirboatGunTracer"
SWEP.Primary.Force					= 3
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.ClipSize				= 10
SWEP.Primary.DefaultClip			= 10
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire()

	self:ANPlusWeaponFireBullet( false, function(attacker, tr, dmg)		
		if tr && tr.Hit then 		
			--ParticleEffect( "hunter_shield_impactglow", tr.HitPos, tr.HitNormal:Angle(), nil )
			--local att = self:GetAttachment( self.MuzzleAttachment )
			self:ANPlusWeaponHitEffect( "AR2Impact", tr, 1 )	
		end		
	end,

	function( origin, vector, att )
								
		--ParticleEffect( "explosion_turret_break_fire", att.Pos, att.Ang, self )
		--ParticleEffect( "weapon_muzzle_flash_assaultrifle", att.Pos, att.Ang, self )
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 5, nil, "MuzzleFlash", nil, nil )
		self:ANPlusWeaponShell( self.ShellEject, nil, 8, 0.4, nil )
		
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