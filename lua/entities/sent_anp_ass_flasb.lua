AddCSLuaFile()
DEFINE_BASECLASS("sent_anp_base_proj")

if (CLIENT) then
	--killicon.Add( "sent_anp_base_proj", "HUD/killicons/sparbine_missile", Color ( 255, 80, 0, 255 ) )
	language.Add( "sent_anp_ass_flasb", "FA FBang" )
end

ENT.Author				= "filz0"

sound.Add( {
	name = "CUP.AssassinFlashB.Pin",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 85,
	pitch = 100,
	sound = { "weapons/cup_flash/grenade_pin_flash_fire_01.wav", "weapons/cup_flash/grenade_pin_flash_fire_02.wav" }
} )

sound.Add( {
	name = "CUP.AssassinFlashB.Explode",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = { 95, 110 },
	sound = { "weapons/cup_flash/flash1.wav", "weapons/cup_flash/flash2.wav", "weapons/cup_flash/flash3.wav", "weapons/cup_flash/flash4.wav" }
} )

sound.Add( {
	name = "CUP.AssassinFlashB.Bounce",
	channel = CHAN_VOICE,
	volume = 0.9,
	level = 75,
	pitch = { 99, 101 },
	sound = { "weapons/cup_flash/phy_flash_bounce_concrete_hard_01_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_02_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_03_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_04_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_05_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_06_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_07_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_08_ext.wav", "weapons/cup_flash/phy_flash_bounce_concrete_hard_09_ext.wav" }
} )

--SETTINGS
ENT.Model 				= "models/cup/assassin_fb/w_grenade.mdl"
ENT.PhysicsInitType 	= SOLID_VPHYSICS
ENT.MoveType 			= MOVETYPE_VPHYSICS
ENT.MoveCollideType 	= MOVECOLLIDE_DEFAULT
ENT.CollisionGroupType 	= COLLISION_GROUP_PROJECTILE
ENT.SolidType 			= SOLID_VPHYSICS

ENT.RunCollideOnDeath	= false
ENT.Bounces				= -1
ENT.SoftBounceSND		= "CUP.AssassinFlashB.Bounce"
ENT.HardBounceSND		= "CUP.AssassinFlashB.Bounce"

ENT.ProjHealth			= nil

ENT.Speed 				= false
ENT.SpeedAcceleration	= false
ENT.Target				= false
ENT.TurnSpeed 			= false
ENT.TurnAcceleration	= false

ENT.Fuse 				= 3
ENT.LifeTime 			= 20

ENT.CollideDecal		= nil
ENT.StartSND 			= "CUP.AssassinFlashB.Pin"
ENT.LoopSND 			= nil
--SETTINGS

local FLASH_INTENSITY = 3000
local FLASHTIMER = 5 --time in seconds, for the grenade to transition from full white to clear
local EFFECT_DELAY = 2 --time, in seconds when the effects still are going on, even when the whiteness of the flash is gone (set to -1 for no effects at all =]).
local Endflash, Endflash2

if (SERVER) then
	
	function ENT:ANPlusOnInitialize()	
		self.sprite = ANPlusCreateSprite( "sprites/glow01.spr", Color( 200, 200, 200 ), 0.3, 1, { rendermode = 3, renderfx = 11 } )
		self.sprite:ANPlusParent( self, "fuse" )
		self:DeleteOnRemove( self.sprite )
		self.ThingsToFlashTab = self:GetOwner():ANPlusGetEnemies()
		self:SetMaterial( "models/weapons/v_combinehe/combine_he1" )
		util.SpriteTrail( self, 1, Color( 200, 200, 200 ), false, 2, 0, 0.5, 1 / ( 10 + 0 ) * 0.5, "effects/anp/generic_trail" )
		timer.Simple( self.Fuse, function()
			if !IsValid(self) then return end
			self:Explode()
		end)
	end
	
	function ENT:ANPlusOnPhysicsObj(physObj)	
		physObj:Wake()
	end
	
	function ENT:Explode()

	self:EmitSound( "CUP.AssassinFlashB.Explode" );

	for _, v in pairs( self.ThingsToFlashTab ) do
		
		if v:ANPlusVisibleInFOV( self, nil, 130 ) then
			
			local dist = v:GetShootPos():Distance( self:GetPos() )  
			local endtime = FLASH_INTENSITY / ( dist * 2 )
					
			if ( endtime > 6 ) then
				endtime = 6
			elseif ( endtime < 1 ) then
				endtime = 0
			end
			
			if v:IsPlayer() then		
				v:SetNWFloat( "FLASHED_END", endtime + CurTime() )	
				v:SetNWFloat( "FLASHED_END_START", CurTime() )			
			elseif v:IsNPC() then			
				v:ClearCondition( 68 )
				v:SetCondition( 67 )			
				timer.Create( "ANPlusMEEYESHURT" .. v:EntIndex(), endtime, 1, function()				
					if !IsValid(v) then return end				
					v:ClearCondition( 67 )
					v:SetCondition( 68 )					
				end)			
			end		
		end	
	end
	self:Remove()
	end
	
	function ENT:ANPlusOnThink()	
	end
	function ENT:ANPlusOnRemove()	
	end
	function ENT:ANPlusOnDestroyed(dmg)	
	end
	function ENT:ANPlusOnCollide()	
	end

end

if (CLIENT) then

	function ENT:Initialize()

		timer.Simple( 2.9, function()
		
			local dynamicflash = DynamicLight( self:EntIndex() )

			if dynamicflash && IsValid(self) then
				dynamicflash.Pos = self:GetPos()
				dynamicflash.r = 255
				dynamicflash.g = 255
				dynamicflash.b = 255
				dynamicflash.Brightness = 1.5
				dynamicflash.Size = 512
				dynamicflash.Decay = 1000
				dynamicflash.DieTime = CurTime() + 5
			end 
			
		end)
		
	end

	function ENT:Think()
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:IsTranslucent()
		return true
	end
	
	function FlashEffect() 
	
		if LocalPlayer():GetNWFloat( "FLASHED_END" ) > CurTime() then

		local ply 			= LocalPlayer()
		local FlashedEnd 	= ply:GetNWFloat( "FLASHED_END" )
		local FlashedStart 	= ply:GetNWFloat( "FLASHED_START" )
		
		local Alpha

		if FlashedEnd - CurTime() > FLASHTIMER then
			Alpha = 150
		else
			local FlashAlpha = 1 - ( CurTime() - ( FlashedEnd - FLASHTIMER ) ) / ( FlashedEnd - ( FlashedEnd - FLASHTIMER ) )
			Alpha = FlashAlpha * 150
		end
		
			surface.SetDrawColor(255, 255, 255, math.Round( Alpha ) )
			surface.DrawRect( 0, 0, surface.ScreenWidth(), surface.ScreenHeight() )
			
		end 
		
	end
	
	hook.Add( "HUDPaint", "ANP_FlashEffect", FlashEffect );
	
		local function StunEffect()
		local ply 			= LocalPlayer()
		local FlashedEnd 	= ply:GetNWFloat( "FLASHED_END" )
		local FlashedStart 	= ply:GetNWFloat( "FLASHED_START" )
	
		if ( FlashedEnd > CurTime() && FlashedEnd - EFFECT_DELAY - CurTime() <= FLASHTIMER ) then
			local FlashAlpha = 1 - ( CurTime() - (FlashedEnd - FLASHTIMER ) ) / ( FLASHTIMER )
			DrawMotionBlur( 0, FlashAlpha / ( ( FLASHTIMER + EFFECT_DELAY ) / ( FLASHTIMER * 4 ) ), 0 )

		elseif FlashedEnd > CurTime() then
			DrawMotionBlur( 0, 0.01, 0 )
		else
			DrawMotionBlur( 0, 0, 0 )
		end
	end
	
	hook.Add( "RenderScreenspaceEffects", "ANP_StunEffect", StunEffect )
	
end
