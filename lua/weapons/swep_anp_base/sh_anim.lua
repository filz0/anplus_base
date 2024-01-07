local ActIndex = {
	['custom']		= true,
	['pistol']		= true,
	['smg']			= true,
	['grenade']		= true,
	['ar2']			= true,
	['shotgun']		= true,
	['rpg']			= true,
	['physgun']		= true,
	['crossbow']	= true,
	['melee']		= true,
	['slam']		= true,
	['normal']		= true,
	['fist']		= true,
	['melee2']		= true,
	['passive']		= true,
	['knife']		= true,
	['duel']		= true,
	['camera']		= true,
	['magic']		= true,
	['revolver']	= true
}

--[[---------------------------------------------------------
	Name: SetWeaponHoldType
	Desc: Sets up the translation table, to translate from normal
			standing idle pose, to holding weapon pose.
-----------------------------------------------------------]]
function SWEP:SetWeaponHoldType( t )

	t = string.lower( t )
	local index = ActIndex[ t ]

	if ( !index ) then
		Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
		t = "normal"
		index = ActIndex[ t ]
	end

	timer.Simple( 0, function() 
		if !IsValid(self) then return end
		self:SetupWeaponHoldTypeForAI( t ) 
	end )

end

function SWEP:TranslateActivity( act )
	
	if self:ANPlusTranslateActivity( act ) then
		return self:ANPlusTranslateActivity( act )
	end
	
	local nAct = self.ActivityTranslateAI[ act ]

	if nAct && self:GetOwner():ANPlusSequenceExists( nAct ) then
		return nAct
	end
	return -1
	
end
