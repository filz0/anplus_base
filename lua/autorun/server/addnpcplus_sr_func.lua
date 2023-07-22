------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local ENT = FindMetaTable("Entity")
local ZERO_VEC = Vector( 0, 0, 0 )

function ENT:ANPlusNPCHealthRegen()

	if self:ANPlusGetDataTab()['HealthRegen'] then
	
		self:ANPlusGetDataTab()['HealthRegen'][ 4 ] = self:ANPlusGetDataTab()['HealthRegen'][ 4 ] || 0
	
		if ( self:ANPlusGetDataTab()['HealthRegen'][ 1 ] || ( !self:ANPlusGetDataTab()['HealthRegen'][ 1 ] && !self:GetEnemy() ) ) && CurTime() - self:ANPlusGetDataTab()['HealthRegen'][ 4 ] >= self:ANPlusGetDataTab()['HealthRegen'][ 2 ] then

			local hpAdd = math.min( self:GetMaxHealth() - self:Health(), self:ANPlusGetDataTab()['HealthRegen'][ 3 ] )-- Dont overheal	
			self:SetHealth(math.Approach( self:Health(), self:GetMaxHealth(), hpAdd ))
			
			self:ANPlusGetDataTab()['HealthRegen'][ 4 ] = CurTime()
		
		end
	
	end
	
end

function ENT:ANPlusPhysicsCollide(data, physobj)
	if self:IsANPlus(true) && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPhysicsCollide'] != nil then			
		self:ANPlusGetDataTab()['Functions']['OnNPCPhysicsCollide'](self, data, physobj)
	end
end

function ENT:ANPlusGetAll()

	local entsAround = ents.GetAll()
	local entsSelected = {}
	local count = 1

	for i = 1, #entsAround do
	
		if !entsAround[ i ]:IsNPC() && !entsAround[ i ]:IsPlayer() then continue end
		
		local v = entsAround[ i ]
		
		if ( v:IsNPC() && v != self && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && v:ANPlusAlive() ) || ( v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) then
			
			entsSelected[count] = v
			count = count + 1

		end
		
	end

	return entsSelected
	
end

function ENT:ANPlusIgnoreTillSet()
	
	if !self:IsNPC() then return end
	local entsAround = ents.GetAll()
	local count = 1

	for i = 1, #entsAround do
	
		if !entsAround[ i ]:IsNPC() && !entsAround[ i ]:IsPlayer() then continue end
		
		local v = entsAround[ i ]
			
		if v:IsANPlus() && v:ANPlusGetDataTab()['Relations'] && v:ANPlusGetDataTab()['Relations']['Default'] && !table.HasValue( v.m_tbANPlusRelationsMem, self )  then

			if v:ANPlusGetDataTab()['Relations']['Default']['NPCToMe'][ 1 ] != "Default" then self:AddEntityRelationship( v, D_NU, 0 ) end
			if v:ANPlusGetDataTab()['Relations']['Default']['MeToNPC'][ 1 ] != "Default" then v:AddEntityRelationship( self, D_NU, 0 ) end
		 
		end
		
	end
	
end

local RelationsTranslate = {
	['Like'] = D_LI,
	['Hate'] = D_HT,
	['Neutral'] = D_NU,
	['Fear'] = D_FR,
}

function ENT:ANPlusNPCRelations()
	
	if !self:IsANPlus() || !self:ANPlusGetDataTab()['Relations'] || CurTime() - self.m_fANPlusCurMemoryLast < self.m_fANPlusCurMemoryDelay then return end
	
	local posEnemies = self:ANPlusGetAll()
	local it = 1
	
	for _, memEnt in pairs( self.m_tbANPlusRelationsMem ) do -- We want to make sure that memory isn't flooded with NULL entities. Possible memory leak?
		if !IsValid(memEnt) || ( IsValid(memEnt) && !memEnt:ANPlusAlive() ) then table.remove( self.m_tbANPlusRelationsMem, _ ) end
	end
	
	while it <= #posEnemies do

	local ent = posEnemies[ it ]
	
		if !IsValid(ent) then
			
			table.remove( posEnemies, it )
		
		else

			it = it + 1
		
			if ent != self then 

				local dispTab = ent:ANPlusGetDataTab() && self:ANPlusGetDataTab()['Relations'][ ent:ANPlusGetDataTab()['Name'] ] || self:ANPlusGetDataTab()['Relations'][ ent:GetInternalVariable( "m_iName" ) ] || self:ANPlusGetDataTab()['Relations'][ ent:ANPlusGetName() ] || self:ANPlusGetDataTab()['Relations'][ ent:GetClass() ] || self:ANPlusGetDataTab()['Relations'][ ent:MyVJClass() ] || self:ANPlusGetDataTab()['Relations'][ ent:IsNPC() && ent:Classify() ] || self:ANPlusGetDataTab()['Relations'][ "Default" ]

				if dispTab then
					
					if !table.HasValue( self.m_tbANPlusRelationsMem, ent ) then
					
						if dispTab['MeToNPC'][ 1 ] != "Default" && self:Disposition( ent ) != RelationsTranslate[ dispTab['MeToNPC'][ 1 ] ] then
							
							self:AddEntityRelationship( ent, RelationsTranslate[ dispTab['MeToNPC'][ 1 ] ], dispTab['MeToNPC'][ 2 ] )
							
						end
			
						if ent:IsNPC() && dispTab['NPCToMe'][ 1 ] != "Default" && ent:Disposition( self ) != RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ] then

							ent:AddEntityRelationship( self, RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ], dispTab['NPCToMe'][ 2 ] )
							
							if ent.IsVJBaseSNPC == true && ( RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ] == D_LI || RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ] == D_NU ) then
							
								ent.VJ_AddCertainEntityAsFriendly[ #ent.VJ_AddCertainEntityAsFriendly + 1 ] = self
								
							elseif ent.IsVJBaseSNPC == true && ( RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ] == D_HT || RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ] == D_FR ) then
							
								ent.VJ_AddCertainEntityAsEnemy[ #ent.VJ_AddCertainEntityAsEnemy + 1 ] = self
								
							end
				
						end
					
						table.insert( self.m_tbANPlusRelationsMem, ent )
						
					end
					
				end
			
			end
			--[[
			if ent:IsPlayer() && self:Disposition(ent) != D_LI && self:IsANPlus() && self:ANPlusGetDataTab()['PlayerAlly'] == true && !self.ANPlusFPlyTab[ ent:Nick() ] then

				self:AddEntityRelationship( ent, D_LI, 0 )
			
				for k, v in pairs( self.ANPlusEPlyTab ) do
	
					if self.ANPlusEPlyTab[k] && k == ent:Nick() then
			
						self.ANPlusEPlyTab[k] = nil

					end
			
				end
			
				local addTab = { [''.. tostring( ent:Nick() ) ..''] = true }
				table.Merge(self.ANPlusFPlyTab, addTab)

			end
		
			if ent:IsPlayer() && self:Disposition(ent) != D_HT && self:IsANPlus() && self:ANPlusGetDataTab()['PlayerAlly'] == false && !self.ANPlusEPlyTab[ ent:Nick() ] then

				self:AddEntityRelationship( ent, D_HT, 0 )
			
				for k, v in pairs( self.ANPlusFPlyTab ) do
	
					if self.ANPlusFPlyTab[k] && k == ent:Nick() then
		
						self.ANPlusFPlyTab[k] = nil

					end
		
				end
				
				local addTab = { [''.. tostring( ent:Nick() ) ..''] = true }
				table.Merge( self.ANPlusEPlyTab, addTab )

			end
		]]--
		end

	end
	
	self.m_fANPlusCurMemoryLast = CurTime() + self.m_fANPlusCurMemoryDelay

end

function ENT:ANPlusCantThrowHere() -- Check why aren't they throwing.
	
	local cbX, cbY = self:GetCollisionBounds()
	local tr = util.TraceHull( {
		start = self:GetPos() + Vector( 0, 0, cbY.z / 2 ),
		endpos = self:GetPos() + Vector( 0, 0, cbY.z / 2 ),
		mins = Vector( cbX.x - 8, cbX.y - 8, cbX.z ),
		maxs = Vector( cbY.x + 8, cbY.y + 8, cbY.z ),
		filter = { self, self:GetActiveWeapon() }
	})
	
	if tr.Hit then
	
		return false
		
	else
	
		return true
		
	end
	
end

function ENT:ANPlusNPCAnimSpeed() 
		
	if self.m_tbANPlusACTOther && ( self.m_tbANPlusACTOther[ self:GetIdealActivity() ] || self.m_tbANPlusACTOther[ self:GetSequenceName( self:GetSequence() ) ] ) then
		
		local aTab1 = self.m_tbANPlusACTOther[ self:GetIdealActivity() ] || self.m_tbANPlusACTOther[ self:GetSequenceName( self:GetSequence() ) ]
		local aTab2 = istable( aTab1[ 2 ] ) && aTab1[ 2 ][ math.random( 1, #aTab1[ 2 ] ) ] || aTab1[ 2 ] 
		aTab2 = self:ANPlusTranslateSequence( aTab2 )
		
		if aTab1[ 2 ] then self:ResetIdealActivity( aTab2 ); self:SetActivity( aTab2 ) end

		self:SetPlaybackRate( ( istable( aTab1 ) && aTab1[ 1 ] || aTab1 ) / 100 )
		
	end

	if self.m_tbANPlusACTMovement && ( self.m_tbANPlusACTMovement[ self:GetMovementActivity() ] || self.m_tbANPlusACTMovement[ self:GetSequenceName( self:GetSequence() ) ] ) then
		
		local aTab1 = self.m_tbANPlusACTMovement[ self:GetMovementActivity() ] || self.m_tbANPlusACTMovement[ self:GetSequenceName( self:GetSequence() ) ]
		local aTab2 = istable( aTab1[ 3 ] ) && aTab1[ 3 ][ math.random( 1, #aTab1[ 3 ] ) ] || aTab1[ 3 ]
		aTab2 = self:ANPlusTranslateSequence( aTab2 )
		
		if aTab1[ 3 ] && self:GetMovementActivity() != aTab2 then self:SetMovementActivity( aTab2 ) end
		
		--if CurTime() - self.m_fANPlusVelLast >= 0.01 then
		
		local speed = ( istable( aTab1 ) && aTab1[ 2 ] && aTab1[ 2 ] || 100 ) / 100
		
		if speed != 1 && self:IsGoalActive() && self:GetPathDistanceToGoal() > 10 * speed && ( ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 1 ) && self:OnGround() ) || ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 4 ) ) || ( self:GetMoveType() == 6 ) ) && self:IsMoving() then--&& self:GetMinMoveStopDist() > 10 then
			
			self:SetMoveVelocity( self:GetGroundSpeedVelocity() * speed ) 
			local seqName = self:GetSequenceName( self:GetSequence() )
			local seqID, seqDur = self:LookupSequence( seqName )
			local seqVel = self:GetSequenceVelocity( seqID, self:GetCycle() )
			seqVel:Rotate( self:GetAngles() )
			self:SetLocalVelocity( seqVel * speed )
		--end
				--print( self:GetVelocity():Length() )
		local rate = ( istable( aTab1 ) && aTab1[ 1 ] || aTab1 ) / 100

		self:SetPlaybackRate( rate )

		--self.m_fANPlusVelLast = CurTime()
				
		end
		 
	end

end

function ENT:ANPlusNPCWeaponSwitch()

	if self:IsANPlus() && IsValid(self:GetActiveWeapon()) then  
		
		local wep = self:GetActiveWeapon()
		
		self.anp_GetLastWeapon = self.anp_GetLastWeapon || wep
		
		if wep != self.anp_GetLastWeapon then
			
			self:ANPlusUpdateWeaponProficency( self:GetActiveWeapon() )
			
			if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCWeaponSwitch'] != nil then
			
				self:ANPlusGetDataTab()['Functions']['OnNPCWeaponSwitch'](self, self.anp_GetLastWeapon, wep)
			
			end
			
			self.anp_GetLastWeapon = wep
		
		end
	
	end

end

--[[
function ENT:ANPlusApplyDataTab( tab )	
	if !self.ANPlusData then self.ANPlusData = {}; self.ANPlusData[''..self.ANPlusIDName..self:EntIndex()..''] = tab end
	timer.Simple(0.1, function() -- God I hate networking....
		if !IsValid(self) then return end
		net.Start("anplus_data_tab")
		net.WriteEntity( self )
		net.WriteTable( self.ANPlusData[''..self.ANPlusIDName..self:EntIndex()..''] )
		net.Broadcast()
	end)
end
]]--

function ENT:ANPlusAnimationEventInternal() -- Credit to almighty Silverlan for this glorius thing.
	if self.m_tbAnimEvents then
		local seq = self:GetSequenceName( self:GetSequence() )
		if ( self.m_tbAnimEvents[ seq ] ) then			
			if ( self.m_seqLast != seq ) then self.m_seqLast = seq; self.m_frameLast = -1 end				
			local frameNew = math.floor( self:GetCycle() * self.m_tbAnimationFrames[ seq ] )	-- Despite what the wiki says, GetCycle doesn't return the frame, but a float between 0 and 1
			for frame = self.m_frameLast + 1, frameNew do	-- a loop, just in case the think function is too slow to catch all frame changes						
				if ( self.m_tbAnimEvents[ seq ][ frame ] ) then					
					for _, ev in ipairs(self.m_tbAnimEvents[ seq ][ frame ]) do
						self:ANPlusHandleAnimationEvent( seq, ev )
					end
				end
			end
			self.m_frameLast = frameNew
		end
	end
end
--[[
function ENT:ANPlusAnimationEventInternal() -- Credit to almighty Silverlan for this glorius thing.
	local seq = self:GetSequenceName( self:GetSequence() )
	if(self.m_tbAnimEvents[seq]) then
		if(self.m_seqLast != seq) then self.m_seqLast = seq; self.m_frameLast = -1 end
		local frameNew = math.floor(self:GetCycle() *self.m_tbAnimationFrames[seq])	-- Despite what the wiki says, GetCycle doesn't return the frame, but a float between 0 and 1
		for frame = self.m_frameLast +1,frameNew do	-- a loop, just in case the think function is too slow to catch all frame changes
			if(self.m_tbAnimEvents[seq][frame]) then
				for _, ev in ipairs(self.m_tbAnimEvents[seq][frame]) do
					self:ANPlusHandleAnimationEvent(seq, ev)
				end
			end
		end
		self.m_frameLast = frameNew
	end
end
]]--
function ENT:ANPlusHandleAnimationEvent(seq, ev)
	if self:IsANPlus(true) && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCHandleAnimationEvent'] != nil then
		self:ANPlusGetDataTab()['Functions']['OnNPCHandleAnimationEvent'](self, seq, ev)	
	end
end

function ENT:ANPlusDetectDanger()
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCDetectDanger'] != nil && CurTime() - self.m_fANPlusDangerDetectLast >= self.m_fANPlusDangerDetectDelay then
		for k, v in ipairs( ANPlusDangerStuffGlobal ) do
			if IsValid(v) && self:ANPlusInRange( v, self:ANPlusGetDataTab()['Functions']['DetectionRange'] ) then
				local distTSqr, dist = self:ANPlusGetRange( v )				
				self:ANPlusGetDataTab()['Functions']['OnNPCDetectDanger'](self, v, dist)
				self.m_fANPlusDangerDetectLast = CurTime()
			end
		end
	end
end

function ENT:ANPlusNPCStateChange()
	if self.m_fCurNPCState && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCStateChange'] != nil then		
		local newState = self:GetNPCState()
		if self.m_fCurNPCState != newState then
			self:ANPlusGetDataTab()['Functions']['OnNPCStateChange'](self, newState, self.m_fCurNPCState)	
		end
		self.m_fCurNPCState = newState		
	end
end

function ENT:ANPlusDoingSchedule()
	if self.m_fCurSchedule && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCDoingSchedule'] != nil then		
		local newSchedule = self:GetCurrentSchedule()
		if self.m_fCurSchedule != newSchedule then
			self:ANPlusGetDataTab()['Functions']['OnNPCDoingSchedule'](self, newSchedule, self.m_fCurSchedule)	
		end
		self.m_fCurSchedule = newSchedule		
	end
end

function ENT:ANPlusNPCTranslateActivity()
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCTranslateActivity'] != nil then
		local act = self:GetIdealActivity()
		local actCur = self:GetActivity()
		--self:ANPlusGetDataTab()['Functions']['OnNPCTranslateActivity'](self, act) 
		local newAct, reset, rate, speed = self:ANPlusGetDataTab()['Functions']['OnNPCTranslateActivity'](self, act) 
		if newAct != nil && act != newAct then	
			self.m_tTACTData = {newAct, rate, speed, respectGoal}
		end

		if newAct then
			local actSeq = self:SelectWeightedSequence( newAct )
			local seqID, seqDur = self:LookupSequence( self:GetSequenceName( actSeq ) )	
			local bool, vel, ang = self:GetSequenceMovement( seqID )
			vel = vel || ZERO_VEC
			local statAct = vel:IsEqualTol( ZERO_VEC, 0 )

			if reset then 
				if statAct then
					self:ResetIdealActivity( newAct )
					self:SetCycle( 0 )				
				elseif !statAct && self:GetMovementActivity() != newAct then
					self:SetMovementActivity( newAct )
				end
			elseif !reset then 
				if statAct then
					self:SetIdealActivity( newAct ) 
					--self:SetCycle( 0 )
				elseif !statAct && self:GetMovementActivity() != newAct then
					self:SetMovementActivity( newAct )
				end
			end
			self:SetActivity( newAct )
			self:ANPlusSetIdealSequence( seqID )
		end
		if self.m_tTACTData && act == self.m_tTACTData[1] then
			if self.m_tTACTData[ 2 ] && self.m_tTACTData[ 2 ] != 1 then self:SetPlaybackRate( self.m_tTACTData[ 2 ] ) end
			if self.m_tTACTData[ 3 ] && self.m_tTACTData[ 3 ] != 1 then self:ANPlusOverrideMoveSpeed( self.m_tTACTData[ 3 ], 1, isbool( self.m_tTACTData[ 4 ] ) ) end
		end
		--self:MaintainActivity()
	end
end

function ENT:ANPlusOnUse(activator, caller, type)
	if IsValid(activator) && ( type == 3 && CurTime() - self.m_fANPUseLast >= 0.05 || type != 3 ) then 
		if self:ANPlusGetDataTab()['CanFollowPlayers'] && self:ANPlusGetDataTab()['CanFollowPlayers'][ 1 ] && self:ANPlusGetDataTab()['CanFollowPlayers'][ 2 ] && self:ANPlusGetDataTab()['CanFollowPlayers'][ 3 ] && self:ANPlusGetDataTab()['CanFollowPlayers'][ 4 ] then self:ANPlusFollowPlayer( activator, self:ANPlusGetDataTab()['CanFollowPlayers'][ 1 ], self:ANPlusGetDataTab()['CanFollowPlayers'][ 2 ], self:ANPlusGetDataTab()['CanFollowPlayers'][ 3 ], self:ANPlusGetDataTab()['CanFollowPlayers'][ 4 ] ) end
		if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCUse'] != nil then
			self:ANPlusGetDataTab()['Functions']['OnNPCUse'](self, activator, caller, type)					
		end		
		if activator:IsPlayer() && type == 3 then activator:ConCommand( "-use" ) end
		self.m_fANPUseLast = CurTime()
	end
end

local argsDef = {}
function ENT:ANPlusEvent(strEv)
	local sp = string.find( strEv, "%s" )
	local evEnd = sp || string.find( strEv, "$" )
	local event = string.Left( strEv, evEnd -1 )
	local args
	if(sp) then
		args = string.sub( strEv, sp + 1 )
		args = string.Explode( ",", args )
	else 
		args = argsDef 
	end
	if !self:ANPlusEventHandle( event, unpack( args ) ) then
		ANPdevMsg( "WARNING: Unhandled animation event '" .. event .. "'" .. (args && ("('" .. table.concat(args,"','") .. "')") || "") .. " for " .. tostring(self), 2 )
	end
end

function ENT:ANPlusEventHandle(...)
	if self:IsANPlus(true) && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCEventHandle'] != nil then		
		self:ANPlusGetDataTab()['Functions']['OnNPCEventHandle'](self, ...)		
	end
end

function ENT:ANPlusForceDefaultWeapons(weaponData)
	if !IsValid(self:GetActiveWeapon()) || !table.HasValue( weaponData, self:GetActiveWeapon():GetClass() ) then	
		if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
		local rngWep = weaponData[ math.random( 1, #weaponData ) ]
		if rngWep then self:Give( rngWep ) end
	end		
end

function ANPlusSameType(ent1, ent2)
	if ent1:ANPlusGetDataTab() && ent2:ANPlusGetDataTab() && ent1:ANPlusGetDataTab()['Name'] == ent2:ANPlusGetDataTab()['Name'] then	
		return true		
	end	
	return false		
end

net.Receive("anplus_propmenu", function(_, ply)
	local ent = net.ReadEntity()		
	local tab = net.ReadTable()		
	
	ent:ANPlusHaloEffect( Color( 0, 255, 255 ), 5, 1 )
	
	if IsValid(ent) && tab then
		for _, var in pairs( tab ) do 
			if var && var['ValueNew'] then
				ent[ var['Variable'] ] = var['ValueNew'] || ent[ var['Variable'] ]
				ent:ANPlusAddSaveData( var['Variable'], var['ValueNew'] || ent[ var['Variable'] ] )

				if ent['m_tSaveDataUpdateFuncs'] && isfunction( ent['m_tSaveDataUpdateFuncs'][ var['Variable'] ] ) then
					ent['m_tSaveDataUpdateFuncs'][ var['Variable'] ](ent, var['ValueNew'])
				end
				
				if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'] != nil then	
					ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'](ent, var['Variable'], var['ValueNew'], ply)			
				end
			end
		end
	end
	
end)