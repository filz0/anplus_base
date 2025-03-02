sound.Add( {
	name = "ANP.WEAPON.HL1.357.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 75,
	pitch = 100,
	sound = "weapons/anp/hl1_357/fire.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.357.Cock",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 100, 
	sound = "weapons/anp/hl1_357/cock.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.HL1.357.Reload",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 100, 
	sound = "weapons/anp/hl1_357/reload.wav"
} )

DEFINE_BASECLASS("swep_anp_base")

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

SWEP.WorldModel						= "models/weapons/w_357_hls.mdl"
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
SWEP.Primary.FireSound				= "ANP.WEAPON.HL1.357.Fire"
SWEP.Primary.PreFireSound			= nil
SWEP.Primary.FireLoopSound			= nil
SWEP.Primary.PostFireSound			= nil
SWEP.Primary.ReloadSound			= "ANP.WEAPON.HL1.357.Reload"
SWEP.Primary.DSound					= "Auto"

SWEP.Primary.Damage					= 40
SWEP.Primary.Force					= 1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Delay					= 1 / ( 80 / 60 ) -- Where 450 is the RPM


SWEP.Primary.SecondaryCooldown		= 1

SWEP.Primary.Tracer					= 1
SWEP.Primary.TracerName				= "anp_tracer_3d"
SWEP.ANPTracerSettingTab			= {	
	['TracerMat']				= nil,
	['TracerLength']			= 80,	
	['TracerScale']				= 8,
	['TracerColor']				= Color( 255, 255, 0 ),
	
	['TrailMat']				= false,
}
SWEP.Primary.AmmoPerShot			= 1
SWEP.Primary.AmmoType				= "357Round"
SWEP.Primary.ClipSize				= 6
SWEP.Primary.DefaultClip			= 6

-- Hooks

function SWEP:ANPlusInitialize()
end

function SWEP:ANPlusNPCFire(hShot)

	self:ANPlusWeaponFireBullet( hShot, function(attacker, tr, dmg)			
	end,

	function( origin, vector, att )
								
		self:ANPlusWeaponShootEffect( self.MuzzleAttachment, 31, nil, "MuzzleFlash", 1 )
		
		local owner = self:GetOwner()

		if self:Clip1() > 1 then

			timer.Simple( self.Primary.Delay - 0.1, function()
				
				if !IsValid(self) || !IsValid(owner) then return end
				
				self:EmitSound( "ANP.WEAPON.HL1.357.Cock" )

			end )

		end

	end )
	
end

function SWEP:ANPlusReload()

	local owner = self:GetOwner()

	timer.Simple( 0.15, function()

		if !IsValid(self) || !IsValid(owner) then return end

		for i = 1, 6 - self:Clip1() do

			local delay = i / 20

			timer.Simple( delay, function()
				
				if !IsValid(self) || !IsValid(owner) then return end

				local bone = self:LookupBone( "Cylinder01" )
				local bPos, bAng = self:GetBonePosition( bone )

				local fx = EffectData()
				fx:SetEntity( self )
				fx:SetOrigin( bPos )
				fx:SetStart( self:GetRight() * math.random( -20, -40 ) + self:GetForward() * math.random( -15, 15 ) )
				fx:SetAngles( self:GetAngles() + Angle( 0, -90, 0 ) )
				fx:SetFlags( 0 )
				util.Effect( "HL1ShellEject", fx )

			end )

		end

	end )

end

function SWEP:ANPlusThink()
end

function SWEP:ANPlusEquip(ent)
end

function SWEP:ANPlusOnDrop()
end

function SWEP:ANPlusOnRemove()	
end