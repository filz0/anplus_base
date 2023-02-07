sound.Add( {
	name = "ANP.WEAPON.Juggergun.Fire",
	channel = CHAN_WEAPON,
	volume = 1.5,
	level = SNDLVL_GUNFIRE,
	pitch = 100,
	sound = "npc/attack_helicopter/aheli_weapon_fire_loop3.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.Juggergun.PreFireDelay",
	channel = CHAN_WEAPON,
	volume = 0.9,
	level = SNDLVL_GUNFIRE,
	pitch = 90,
	sound = "npc/attack_helicopter/aheli_charge_up.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.Juggergun.PostFireDelay",
	channel = CHAN_WEAPON,
	volume = 0.9,
	level = SNDLVL_GUNFIRE,
	pitch = 90,
	sound = "weapons/juggergun/jugger_chargedown.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.Juggergun.DistantFire",
	channel = CHAN_WEAPON,
	volume = 0.4,
	level = 140,
	pitch = { 75, 85 },
	sound = "weapons/airboat/airboat_gun_lastshot2.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.Juggergun.Reload",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100, 
	sound = "weapons/juggergun/jugger_reload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.WorldModel						= "models/cup/juggergun/juggergun.mdl"
SWEP.HoldType						= "shotgun"
SWEP.DropOnDeath					= false

-- SWEP aesthetics
SWEP.MuzzleAttachment				= "1"
SWEP.ShellAttachment				= "2"
SWEP.EventDisable = { -- Lets get rid of default effects on this model
	[3007] = true,
	[22] = true,
}
SWEP.Muzzle 						= nil
SWEP.MuzzleSmoke 					= nil

-- SWEP NPC settings
SWEP.NPCRestMin						= 0
SWEP.NPCRestMax						= 0
SWEP.NPCBurstMin					= 100
SWEP.NPCBurstMax					= 100

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= nil--"ANP.WEAPON.Juggergun.Fire"
SWEP.Primary.FireLoopSound			= "ANP.WEAPON.Juggergun.Fire"
SWEP.Primary.ReloadSound			= "ANP.WEAPON.Juggergun.Reload"
SWEP.Primary.DSound					= "ANP.WEAPON.Juggergun.DistantFire"
SWEP.Primary.PreFireDelay			= 1.5
SWEP.Primary.PreFireReset			= nil
SWEP.Primary.PreFireSound			= "ANP.WEAPON.Juggergun.PreFireDelay"
SWEP.Primary.PostFireSound			= "ANP.WEAPON.Juggergun.PostFireDelay"
SWEP.Primary.Damage					= 4
SWEP.Primary.Speed					= nil
SWEP.Primary.NumShots				= 4
SWEP.Primary.Spread					= 0.05 -- Spread
SWEP.Primary.Delay					= 1 / ( 900 / 60 )
SWEP.Primary.ClipSize				= 100
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "HelicopterTracer"
SWEP.Primary.Force					= 3
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 100
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCTriggerPull( shootPos, shootDir )
	if self:GetOwner():GetMovementActivity() != ACT_WALK && self:Clip1() > 0 then
		self:GetOwner():SetMovementActivity( ACT_WALK )
	end
end

function SWEP:ANPlusNPCFire()

	self:ANPlusWeaponFireBullet( false, function(att, tr, dmg)
		
		if tr && tr.Hit && !tr.HitSky then 
		
			ParticleEffect( "hunter_shield_impact2", tr.HitPos, tr.HitNormal:Angle(), nil )
			ParticleEffect( "hunter_shield_impactglow", tr.HitPos, tr.HitNormal:Angle(), nil )
			
		end
		
	end,

	function( origin, vector, att )
								
		--ParticleEffect( "explosion_turret_break_fire", att.Pos, att.Ang, self )
		ParticleEffect( "hunter_muzzle_flash", att.Pos, att.Ang, self )
	
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