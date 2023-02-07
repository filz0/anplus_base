sound.Add( {
	name = "ANP.WEAPON.SynthRifle.Fire",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = SNDLVL_GUNFIRE,
	pitch = { 88, 90 },
	sound = "npc/ministrider/ministrider_fire1.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.SynthRifle.DistantFire",
	channel = CHAN_WEAPON,
	volume = 0.4,
	level = 140,
	pitch = { 75, 85 },
	sound = "npc/ministrider/ministrider_fire1.wav"
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

SWEP.WorldModel						= "models/weapons/w_striderg.mdl"
SWEP.HoldType						= "ar2"

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
SWEP.NPCRestMin						= 0.2
SWEP.NPCRestMax						= 0.4
SWEP.NPCBurstMin					= 3
SWEP.NPCBurstMax					= 5

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.SynthRifle.Fire"
SWEP.Primary.ReloadSound			= "ANP.WEAPON.SynthRifle.Reload"
SWEP.Primary.DSound					= "ANP.WEAPON.SynthRifle.DistantFire"

SWEP.Primary.Damage					= 0
SWEP.Primary.EntitySpeed			= 3000
SWEP.Primary.NumShots				= 1
SWEP.Primary.Spread					= 0.1 -- Spread
SWEP.Primary.MoveSpreadMult			= 2 -- Movement spread multiplier.
SWEP.Primary.Delay					= 1 / ( 250 / 60 ) -- Where 450 is the RPM
SWEP.Primary.ClipSize				= 15
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= nil
SWEP.Primary.Force					= 3
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 15
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire()

	self:ANPlusWeaponFireEntity( "hunter_flechette", nil, 

	function( ent )
		
		ent:SetModelScale( 0.5 )
		ent.ANPlusQuickDamageDealtOverride = function( ent, victim, dmg )
			if ent:GetMoveType() == 5 then
				dmg:AddDamage( dmg:GetDamage() * 3 )
			else
				dmg:AddDamage( dmg:GetDamage() * 2.2 )
			end
			dmg:SetInflictor( IsValid(self) && self || ent )
		end
		
	end,

	function( origin, vector, att )
								
		--ParticleEffectAttach( "hunter_muzzle_flash", 1, self.Weapon, self.MuzzleAttachment )
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