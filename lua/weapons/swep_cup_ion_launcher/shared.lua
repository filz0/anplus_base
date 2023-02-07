sound.Add( {
	name = "ANP.WEAPON.IONLauncher.Charge",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = 80,
	pitch = 100,
	sound = "weapons/ion_launcher/ion_charge.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.IONLauncher.DisCharge",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = 80,
	pitch = 100,
	sound = "weapons/ion_launcher/ion_discharge.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.IONLauncher.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 130,
	pitch = 100,
	sound = "weapons/ion_launcher/ion_fire.wav"--{ "weapons/ion_launcher/turret_alt1.wav", "weapons/ion_launcher/turret_alt2.wav", "weapons/ion_launcher/turret_alt3.wav" }
} )

sound.Add( {
	name = "ANP.WEAPON.IONLauncher.Reload",
	channel = CHAN_ITEM,
	volume = 0.9,
	level = 70,
	pitch = 100, 
	sound = "weapons/ion_launcher/ion_reload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.Author							= "FiLzO"
SWEP.PrintName						= "[CUP] ION MK.I"
SWEP.WorldModel						= "models/cup/cup_weapons/w_rocket_launcher.mdl"
SWEP.WorldModelCustomiseTab			= nil
SWEP.HoldType						= "ar2"
SWEP.Weight							= 30
SWEP.DropOnDeath					= true

-- SWEP aesthetics
SWEP.MuzzleAttachment				= "1"
SWEP.Exhaust						= "3"
SWEP.ShellAttachment				= nil
SWEP.EventDisable = { -- Lets get rid of default effects on this model
	[3007] = true,
	[22] = true,
}
SWEP.Muzzle 						= nil
SWEP.MuzzleSmoke 					= nil

-- SWEP NPC settings
SWEP.NPCRestMin						= 0
SWEP.NPCRestMax						= 0
SWEP.NPCBurstMin					= 0
SWEP.NPCBurstMax					= 0

SWEP.NPCWeaponMaxRange				= nil
SWEP.NPCWeaponMinRange				= 200

SWEP.NPCWepProfSpreadAt0 			= 6 -- Angle of a bullet spread based on NPCs weapon proficiency where 0 is poor and 4 is Soldier 76's ult in Overwatch. Cone is added on top of that.
SWEP.NPCWepProfSpreadAt1 			= 5
SWEP.NPCWepProfSpreadAt2 			= 3
SWEP.NPCWepProfSpreadAt3 			= 2
SWEP.NPCWepProfSpreadAt4 			= 0

-- Primary fire settings
SWEP.Primary.FireSound				= "ANP.WEAPON.IONLauncher.Fire"
SWEP.Primary.PreFireSound			= "ANP.WEAPON.IONLauncher.Charge"
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= "ANP.WEAPON.IONLauncher.DisCharge"
SWEP.Primary.ReloadSound			= "ANP.WEAPON.IONLauncher.Reload"
SWEP.Primary.DSound					= nil

SWEP.Primary.Damage					= 0
SWEP.Primary.DamageBlast			= 200
SWEP.Primary.Radius					= 250
SWEP.Primary.NumShots				= 1
SWEP.Primary.Spread					= 0.01 -- Spread
SWEP.Primary.MoveSpreadMult			= 1.3 -- Movement spread multiplier.
SWEP.Primary.Delay					= 1 / ( 10 / 60 ) -- Where 450 is the RPM
SWEP.Primary.PreFireDelay			= 1.4
SWEP.Primary.PreFireReset			= 0.2
SWEP.Primary.ClipSize				= 1
SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= false
SWEP.Primary.Force					= 3
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "AR2"
SWEP.Primary.DefaultClip			= 1
-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusCanPrimaryFire()
	if !IsValid(self:GetOwner()) || !IsValid(self:GetOwner():GetEnemy()) then return false end
	if !self:GetOwner():ANPlusInRange( self:GetOwner():GetEnemy(), 200 ) then
		return true
	elseif !self:GetOwner():IsCurrentSchedule( SCHED_BACK_AWAY_FROM_ENEMY ) then
		self:GetOwner():SetSchedule( SCHED_BACK_AWAY_FROM_ENEMY )
	end
	return false
end

function SWEP:ANPlusNPCFire()

	self:ANPlusWeaponFireBullet( false, function(attacker, tr, dmg)
		
		if tr && tr.Hit then 
		
			--ParticleEffect( "hunter_shield_impactglow", tr.HitPos, tr.HitNormal:Angle(), nil )
			local att1 = self:GetAttachment( self.MuzzleAttachment )
			local att2 = self:GetAttachment( self.Exhaust )
			local hitPos = tr.HitPos
			local hitPosN = tr.HitNormal
								
			util.ParticleTracerEx( "Weapon_Combine_Ion_Cannon", att1.Pos, hitPos, true, self:EntIndex(), 1 )	
			ParticleEffect( "citadel_shockwave_b", hitPos, hitPosN:Angle(), nil )
			--ParticleEffect( "citadel_shockwave__", hitPos, hitPosN:Angle(), nil )
			ParticleEffect( "Weapon_Combine_Ion_Cannon_d", att1.Pos, att1.Ang + Angle( 0, 90, 0 ), nil )	
			ParticleEffectAttach( "hunter_shield_impact", 4, self, self.MuzzleAttachment )			
			ParticleEffectAttach( "hunter_shield_impact", 4, self, self.Exhaust )		
			--dmg:SetDamageType( bit.bor( DMG_BLAST, DMG_DISSOLVE, DMG_AIRBOAT ) )	
			timer.Simple( 0.4, function()
				if !IsValid(self) then return end
				local dmgb = DamageInfo()
					dmgb:SetDamageType( bit.bor( DMG_BLAST, DMG_DISSOLVE, DMG_AIRBOAT ) )
					dmgb:SetDamage( self.Primary.DamageBlast )
					dmgb:SetAttacker( self:GetOwner() )
					dmgb:SetInflictor( self )
				util.BlastDamageInfo( dmgb, hitPos, self.Primary.Radius )		
				ParticleEffect( "Weapon_Combine_Ion_Cannon_Explosion", hitPos, hitPosN:Angle(), nil )
				sound.Play( "weapons/mortar/mortar_explode"..math.random(1,3)..".wav", hitPos, 150, 100 )
			end)
		end
		
	end,

	function( origin, vector, att )
								
		--ParticleEffect( "explosion_turret_break_fire", att.Pos, att.Ang, self )
		--ParticleEffect( "hunter_muzzle_flash", att.Pos, att.Ang, self )
	
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