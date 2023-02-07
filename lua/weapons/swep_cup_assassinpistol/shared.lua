sound.Add( {
	name = "ANP.WEAPON.AsssassinPistol.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = SNDLVL_GUNFIRE,
	pitch = { 95, 105 },
	sound = { "weapons/assassin_gun/pl_gun1.wav", "weapons/assassin_gun/pl_gun2.wav" }
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )	
end

SWEP.WorldModel						= "models/weapons/w_pistol.mdl"
SWEP.WorldModelDraw					= false
SWEP.WorldModelDrawShadow			= false
SWEP.HoldType						= "pistol"
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
SWEP.NPCBurstMin					= 15
SWEP.NPCBurstMax					= 15

SWEP.NPCWeaponMaxRange				= nil
SWEP.NPCWeaponMinRange				= 120

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= nil--"ANP.WEAPON.AsssassinPistol.Fire"
SWEP.Primary.ReloadSound			= nil
SWEP.Primary.DSound					= nil
SWEP.Primary.PreFireDelay			= nil
SWEP.Primary.PreFireReset			= nil
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.Damage					= 0
SWEP.Primary.NumShots				= 1
SWEP.Primary.Spread					= 0.03 -- Spread
SWEP.Primary.MoveSpreadMult			= 5 -- Movement spread multiplier.
SWEP.Primary.Delay					= 1 / ( 450 / 60 )
SWEP.Primary.ClipSize				= 990
SWEP.Primary.InfiniteAmmo			= true
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "Tracer" 
SWEP.Primary.Force					= 10
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 990
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCPreFire()
end

function SWEP:ANPlusNPCPostFire()
end

function SWEP:ANPlusNPCFire()
end

function SWEP:ANPlusNPCFire()
--[[
	self:ANPlusWeaponFireBullet( true, nil,

	function( origin, vector, att )
	
	end)
]]--
	--print(self:GetNPCCurRestTime(), self:GetNPCCurBurst())
end

function SWEP:ANPlusReload()
end

function SWEP:ANPlusThink()
end

function SWEP:ANPlusOnDrop()
end

function SWEP:ANPlusOnRemove()
end

function SWEP:ANPlusDrawWorldModel()	
	return true	
end

function SWEP:ANPlusEquip(ent)
	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI[ACT_IDLE]							= ACT_IDLE
	self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= ACT_IDLE
	self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= ACT_IDLE_ANGRY
	self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= ACT_IDLE_ANGRY

	self.ActivityTranslateAI[ACT_WALK]							= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_RELAXED]					= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_AGITATED]					= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_STEALTH]					= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_AIM]						= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= ACT_RUN

	self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_RUN
	self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_RUN

	self.ActivityTranslateAI[ACT_RUN]							= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_RELAXED]					= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_AGITATED]					= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_STEALTH]					= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_AIM]						= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= ACT_RUN

	self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN
	self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN

	self.ActivityTranslateAI[ACT_RELOAD]						= ACT_RANGE_ATTACK1
	self.ActivityTranslateAI[ACT_RELOAD_LOW]					= ACT_RANGE_ATTACK1

	self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= ACT_RANGE_ATTACK1
	self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= ACT_RANGE_ATTACK1

	self.ActivityTranslateAI[ACT_COVER_LOW]						= ACT_CROUCHIDLE
	self.ActivityTranslateAI[ACT_IDLE_ANGRY_PISTOL]				= ACT_CROUCHIDLE 

	self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= ACT_CROUCHIDLE
	self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= ACT_CROUCHIDLE
	self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= ACT_CROUCHIDLE
end