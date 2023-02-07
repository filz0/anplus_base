sound.Add( {
	name = "ANP.WEAPON.CSniperRifle.Fire",
	channel = CHAN_WEAPON,
	volume = 0.9,
	level = SNDLVL_GUNFIRE,
	pitch = { 95, 105 },
	sound = "weapons/csniperrifle/csnipnpcfire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.CSniperRifle.DistantFire",
	channel = CHAN_WEAPON,
	volume = 0.4,
	level = 140,
	pitch = { 75, 85 },
	sound = "weapons/csniperrifle/csnipnpcfire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.CSniperRifle.PreFireWarning",
	channel = CHAN_WEAPON,
	volume = 0.4,
	level = 140,
	pitch = 90,
	sound = "weapons/csniperrifle/pre_fire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.CSniperRifle.Reload",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100, 
	sound = "weapons/csniperrifle/csnipnpcreload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/cup/csniperrifle/w_combinesniper_e2.mdl"
SWEP.WorldModelDraw					= true
SWEP.WorldModelDrawShadow			= true
SWEP.HoldType						= "ar2"
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
SWEP.NPCBurstMin					= 1
SWEP.NPCBurstMax					= 1

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.CSniperRifle.Fire"
SWEP.Primary.ReloadSound			= "ANP.WEAPON.CSniperRifle.Reload"
SWEP.Primary.DSound					= "ANP.WEAPON.CSniperRifle.DistantFire"
SWEP.Primary.PreFireDelay			= 2
SWEP.Primary.PreFireReset			= 0.05
SWEP.Primary.PreFireSound			= "ANP.WEAPON.CSniperRifle.PreFireWarning"
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.Damage					= 80
SWEP.Primary.NumShots				= 1
SWEP.Primary.Spread					= 0.001 -- Spread
SWEP.Primary.MoveSpreadMult			= 5 -- Movement spread multiplier.
SWEP.Primary.Delay					= 1 / ( 25 / 60 )
SWEP.Primary.ClipSize				= 5
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "HelicopterTracer"
SWEP.Primary.Force					= 10
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 5
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCTriggerPull( shootPos, shootDir )
	self:GetOwner():StopMoving()
end

function SWEP:ANPlusNPCFire()

	self:ANPlusWeaponFireBullet( true, nil,

	function( origin, vector, att )
								
		ParticleEffect( "hunter_muzzle_flash", att.Pos, att.Ang, self )
	
	end)

end

function SWEP:ANPlusReload()
end

local vector_zero = Vector( 0, 0, 0 )
local velocity_zero = Vector( 0, 0, -0 )

function SWEP:ANPlusThink()
	if IsValid(self:GetOwner():GetEnemy()) && self:GetOwner():Visible( self:GetOwner():GetEnemy() ) then
		self:SetNW2Vector( "ANP_OwnerEnemyPos", self:GetOwner():GetEnemy():ANPlusGetHitGroupBone( 1 ) || self:GetOwner():GetEnemy():ANPlusGetHitGroupBone( 2 ) || self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter() ) 
	else
		self:SetNW2Vector( "ANP_OwnerEnemyPos", vector_zero ) 
	end
	self:SetNW2Vector( "ANP_OwnerMoveSpeed", self:GetOwner():GetGroundSpeedVelocity() )
end

function SWEP:ANPlusOnDrop()
end

function SWEP:ANPlusOnRemove()
end

local laserMat = Material( "sprites/rollermine_shock" )
local dotMat = Material("particle/particle_glow_02")
local color = Color( 0, 220, 255, 255 )

function SWEP:ANPlusDrawWorldModel()

	if IsValid(self:GetOwner()) then
		
		local att = self:GetAttachment( self:LookupAttachment( "laser" ) )
		local attPos = att.Pos
		local attAng = att.Ang
		local endPos = vector_zero != self:GetNW2Vector( "ANP_OwnerEnemyPos" ) && self:GetNW2Vector( "ANP_OwnerMoveSpeed" ):Length() <= 0 && self:GetNW2Vector( "ANP_OwnerEnemyPos" ) || nil
		
		if endPos then
			local tr = util.TraceLine({
				start = attPos,
				endpos = endPos,
				filter = self,
			})
		
			render.SetMaterial( laserMat )
			render.DrawBeam( attPos, tr.HitPos, 3, 0, 1, color )
			render.SetMaterial( dotMat )
			render.DrawSprite( attPos, 3, 3, color )
			
			if tr.Hit == true then
				render.SetMaterial( dotMat )
				render.DrawSprite( tr.HitPos, math.random( 2, 4 ), math.random( 2, 4 ), color )
			end
			
		end
		
	end
	
	return true
	
end
