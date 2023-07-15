local ENT = FindMetaTable("Entity")

function ENT:ANPlusApplyDataTab( tab )	
	self['ANPlusData'] = tab
	if (SERVER) then 
		self:ANPlusStoreEntityModifier( tab )
		--timer.Simple( 0.1, function()
			if !IsValid(self) then return end
			local tabNoFunc = table.Copy( tab )
			tabNoFunc['Functions'] = {}
			net.Start( "anplus_data_tab" )
			net.WriteEntity( self )
			net.WriteTable( tabNoFunc )
			net.Broadcast()
		--end )
	end
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
			self:ANPlusDoingSchedule()
			
			if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCSoundHint'] != nil then	
				--if ( !GetConVar("ai_ignoreplayers"):GetBool() && sound.GetLoudestSoundHint( 0, self:GetPos() ).type == 4 ) || ( GetConVar("ai_ignoreplayers"):GetBool() && sound.GetLoudestSoundHint( 0, self:GetPos() ).type != 4 ) then
					local sndHintTab = 
					sound.GetLoudestSoundHint( 0, self:GetPos() )
					|| sound.GetLoudestSoundHint( 1, self:GetPos() )
					|| sound.GetLoudestSoundHint( 2, self:GetPos() )
					|| !GetConVar("ai_ignoreplayers"):GetBool() && sound.GetLoudestSoundHint( 4, self:GetPos() )
					|| sound.GetLoudestSoundHint( 8, self:GetPos() )
					|| sound.GetLoudestSoundHint( 16, self:GetPos() )
					|| sound.GetLoudestSoundHint( 32, self:GetPos() )
					|| sound.GetLoudestSoundHint( 64, self:GetPos() )
					|| sound.GetLoudestSoundHint( 128, self:GetPos() )
					|| sound.GetLoudestSoundHint( 256, self:GetPos() )
					|| sound.GetLoudestSoundHint( 512, self:GetPos() )
					|| sound.GetLoudestSoundHint( 1024, self:GetPos() )
					|| sound.GetLoudestSoundHint( 2048, self:GetPos() )
					|| sound.GetLoudestSoundHint( 4096, self:GetPos() )
					|| sound.GetLoudestSoundHint( 8192, self:GetPos() )
					|| sound.GetLoudestSoundHint( 16384, self:GetPos() )
					|| sound.GetLoudestSoundHint( 32768, self:GetPos() )
					|| sound.GetLoudestSoundHint( 65536, self:GetPos() )
					|| sound.GetLoudestSoundHint( 1048576, self:GetPos() )
					|| sound.GetLoudestSoundHint( 2097152, self:GetPos() )
					|| sound.GetLoudestSoundHint( 4194304, self:GetPos() )
					|| sound.GetLoudestSoundHint( 8388608, self:GetPos() )
					|| sound.GetLoudestSoundHint( 16777216, self:GetPos() )
					|| sound.GetLoudestSoundHint( 33554432, self:GetPos() )
					|| sound.GetLoudestSoundHint( 67108864, self:GetPos() )
					|| sound.GetLoudestSoundHint( 134217728, self:GetPos() )
					|| sound.GetLoudestSoundHint( 268435456, self:GetPos() )
					|| sound.GetLoudestSoundHint( 536870912, self:GetPos() )
					if sndHintTab then
						self:ANPlusGetDataTab()['Functions']['OnNPCSoundHint'](self, sndHintTab)	
					end
				--end
			end
		end
		
		if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCThink'] != nil then
			self:ANPlusGetDataTab()['Functions']['OnNPCThink'](self)	
		end
		
	end

end

local function ANPlusOnLoad(ply, ent, data)
	if IsValid(ent) && istable( data ) && data['CurName'] then -- Adv. Duplicator 2 Support!		
		ent:ANPlusIgnoreTillSet()
		ent:ANPlusNPCApply(data['CurName'])
	end
	timer.Simple( 0, function()
		if !IsValid(ent) || !istable( data ) then return end
		if ent:IsANPlus(true) && ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCLoad'] != nil then		
			ent:ANPlusGetDataTab()['Functions']['OnNPCLoad'](ply, ent, data)		
		end	

		if data['m_tSaveData'] then

			for _, var in pairs( data['m_tSaveData'] ) do 
				if var && ent:GetTable()[ _ ] then			
					ent:GetTable()[ _ ] = var	
				end
			end

			net.Start("anplus_entmod_net")
			net.WriteEntity( ent )
			net.WriteTable( data['m_tSaveData'] )
			net.Broadcast()
			
		end

	end )
end
duplicator.RegisterEntityModifier( "anp_duplicator_data", ANPlusOnLoad )

function ENT:ANPlusStoreEntityModifier(data)
	if !data then return end
	duplicator.StoreEntityModifier( self, "anp_duplicator_data", data )
end
