if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )	
end
   
SWEP.Base 					= "weapon_base"
SWEP.m_bPlayPickupSound		= false
SWEP.Spawnable 				= false
SWEP.AdminSpawnable 		= false
SWEP.WorldModel				= "models/weapons/shell.mdl"
SWEP.HoldType				= "normal"
SWEP.ActivityTranslateAI 	= {}

function SWEP:Initialize()
	self:SetNoDraw( true )
	self:DrawShadow( false )
	hook.Add( "Think", self, self.Think )
	if (SERVER) then
		local owner = self:GetOwner()
		if IsValid(owner) then
			self:GetOwner():Fire( "EnableWeaponPickup" )
			timer.Simple( 0, function() if !IsValid(owner) then return end self:GetOwner():EmitSound( "npc/combine_soldier/vo/_comma.wav", 1, 100, 0.1, CHAN_ITEM ) end ) -- Mute pickup sound.
		end
	end
end

function SWEP:TranslateActivityThink()
end

function SWEP:Think()
	self:TranslateActivityThink()
end

function SWEP:TranslateActivity( act )
	local owner = self:GetOwner()	
	if ( self.ActivityTranslateAI[ act ] ) then
		return owner:ANPlusTranslateSequence( self.ActivityTranslateAI[ act ] )
	end
	return -1
end

function SWEP:GetCapabilities()
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:ShouldDropOnDie()
	return false
end