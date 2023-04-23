local ENT = FindMetaTable("Entity")

function ENT:ANPlusApplyDataTab( tab )	
	self['ANPlusData'] = tab
	if (SERVER) then self:ANPlusStoreEntityModifier( tab ) end -- Adv. Duplicator 2 Support
	--timer.Simple(0.1, function() -- God I hate networking....
	--	if !IsValid(self) then return end
	--	net.Start( "anplus_data_tab" )
	--	net.WriteEntity( self )
	--	net.WriteTable( self['ANPlusData'] )
	--	net.Broadcast()
	--end)
end

function ENT:ANPlusNPCThink()

	if !IsValid(self) || !self:ANPlusAlive() then	
		
		return false			
	elseif ( self:IsANPlus() && !GetConVar("ai_disabled"):GetBool() ) || !self:IsNPC() && self:IsANPlus(true) then
		
		if (SERVER)	then	
			self:ANPlusNPCRelations()					
			self:ANPlusNPCHealthRegen()					
			self:ANPlusNPCWeaponSwitch()			
			self:ANPlusNPCStateChange()
			self:ANPlusAnimationEventInternal()
			self:ANPlusNPCAnimSpeed()
			self:ANPlusNPCTranslateActivity()
			self:ANPlusDetectDanger()
			
			if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCSoundHint'] != nil && self:GetBestSoundHint() then	
				if ( !GetConVar("ai_ignoreplayers"):GetBool() && self:GetBestSoundHint().type == 4 ) || ( GetConVar("ai_ignoreplayers"):GetBool() && self:GetBestSoundHint().type != 4 ) then
					self:ANPlusGetDataTab()['Functions']['OnNPCSoundHint'](self, self:GetBestSoundHint())	
				end
			end
		end
		
		if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCThink'] != nil then
			self:ANPlusGetDataTab()['Functions']['OnNPCThink'](self)	
		end
		
	end

end