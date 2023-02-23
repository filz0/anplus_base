SWEP.Spawnable = false
SWEP.AdminSpawnable = false

function SWEP:Initialize()
	print(self:GetOwner())
end

function SWEP:Think()

end

function SWEP:TranslateActivity( act )
	local owner = self:GetOwner()	
	if owner:ANPlusGetDataTab()['Functions'] && owner:ANPlusGetDataTab()['Functions']['OnNPCTranslateActivity'] != nil then
		owner:ANPlusGetDataTab()['Functions']['OnNPCTranslateActivity'](owner, act)
	end	
	return -1
end