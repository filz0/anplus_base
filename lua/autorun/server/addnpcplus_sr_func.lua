------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local ENT = FindMetaTable("Entity")
local ZERO_VEC = Vector( 0, 0, 0 )


function ANPlusFilterInternal(ent, pn, transition)

	if ANPDefaultOutputs then

		local hookTab = ent:IsNPC() && ANPDefaultOutputs['BaseNPC']

		if hookTab then
			for i = 1, #hookTab do
				local hookData = hookTab[ i ]
				if hookData then
					ent:ANPlusCreateOutputHook( hookData[ 1 ], hookData[ 2 ] )
				end
			end
		end

	end

	for i = 1, #ANPlusDangerStuffGlobalNameOrClass do
		local danger = ANPlusDangerStuffGlobalNameOrClass[ i ]
		if danger && !ent:IsWeapon() && ( string.find( string.lower( ent:ANPlusGetName() ), danger ) || string.find( string.lower( ent:GetClass() ), danger ) ) && !table.HasValue( ANPlusDangerStuffGlobal, ent ) then
			table.insert( ANPlusDangerStuffGlobal, ent )
		end			
	end

	if !ent:IsANPlus(true) || transition then

		if !transition then ent:ANPlusIgnoreTillSet() end
		ent:ANPlusNPCApply( pn, false, transition )					
		
	end
	
	if ent:IsNPC() then
		
		ent:ANPlusCreateVar( "DefaultVariables", "Category", "[ Default Variables ]-----------------", nil ) 
		
		ent:ANPlusCreateVar( "kv_targetname", ent:GetInternalVariable( "m_iName" ), "Target Name", "The name that other entities use to refer to this entity.", nil, nil, nil, 				
		function(ent, nVar) 
			ent:SetSaveValue( "m_iName", nVar )
		end )
		
		ent:ANPlusCreateVar( "kv_squadname", ent:GetInternalVariable( "m_SquadName" ), "Squad Name", "NPCs that are in the same squad (i.e., have matching squad names) will share information about enemies and will take turns attacking and covering each other.", nil, nil, nil, 				
		function(ent, nVar) 
			ent:SetSaveValue( "m_SquadName", nVar )
		end )
		
		
		local val = ent:GetInternalVariable( "m_bShouldPatrol" )
		if val != nil then											
			ent:ANPlusCreateVar( "kv_shouldpatrol", tobool(val), "Should Patrol", "Patrol whenever I'm idle or alert.", nil, nil, nil, 				
			function(ent, nVar) 
				timer.Simple( 0.5, function() if !IsValid(ent) then return end ent:SetSaveValue( "m_bShouldPatrol", nVar ) end )
			end )
		end
		
		ent:ANPlusCreateVar( "kv_ignoreunseenenemies", tobool( ent:GetInternalVariable( "m_bIgnoreUnseenEnemies" ) ), "Ignore Unseen Enemies", "Prefers visible enemies, regardless of distance or relationship priority.", nil, nil, nil, 				
		function(ent, nVar) 
			ent:SetSaveValue( "m_bIgnoreUnseenEnemies", nVar )
		end )
		
		local sleepList = 
					"\n Choices:" ..
					"\n 0: None" ..
					"\n 1: Waiting for threat" ..
					"\n 2: Waiting for PVS" ..
					"\n 3: Waiting for input, ignore PVS" ..
					"\n 4: Auto PVS" ..
					"\n 5: Auto PVS after PVS" 
		
		ent:ANPlusCreateVar( "kv_sleepstate", ent:GetInternalVariable( "m_SleepState" ), "Sleep State", "Holds the NPC in stasis until specified condition. See also Wake Radius and Wake Squad." .. sleepList, 0, 5, 0, 				
		function(ent, nVar) 				
			ent:SetSaveValue( "m_SleepState", nVar )
		end )
		
		ent:ANPlusCreateVar( "kv_wakeradius", ent:GetInternalVariable( "m_flWakeRadius" ), "Wake Radius", "Auto-wake if player comes within this distance.", 0, 30000, 0, 				
		function(ent, nVar) 
			ent:SetSaveValue( "m_flWakeRadius", nVar )
		end )
		
		ent:ANPlusCreateVar( "kv_wakesquad", tobool( ent:GetInternalVariable( "m_bWakeSquad" ) ), "Wake Squad", "Wake all of the NPCs squadmates if the NPC is woken.", nil, nil, nil, 				
		function(ent, nVar) 
			ent:SetSaveValue( "m_bWakeSquad", nVar )
		end )
		
		ent:ANPlusCreateVar( "kv_fireinput", "", "Fire Input", "Fires an entity's input, conforming to the map IO event queue system. You can find inputs for most entities on the Valve Developer Wiki.", nil, nil, nil, 				
		function(ent, nVar) 
			if nVar != "" then
				nVar = string.Split( nVar, " " )
				ent:Fire( nVar[ 1 ], nVar[ 2 ] || ( !nVar[ 2 ] || nVar[ 2 ] == "nil" ) && nil, nVar[ 3 ] || 0 )
			end
		end )

	end

end

function ENT:ANPlusNPCHealthRegen()

	if self:ANPlusGetDataTab()['HealthRegen'] then
	
		self:ANPlusGetDataTab()['HealthRegen'][ 4 ] = self:ANPlusGetDataTab()['HealthRegen'][ 4 ] || 0
	
		if ( self:ANPlusGetDataTab()['HealthRegen'][ 1 ] || ( self:IsNPC() && !self:ANPlusGetDataTab()['HealthRegen'][ 1 ] && !self:GetEnemy() ) ) && CurTime() - self:ANPlusGetDataTab()['HealthRegen'][ 4 ] >= self:ANPlusGetDataTab()['HealthRegen'][ 2 ] then

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

function ANPlusGetAll()

	local entsAround = ents.GetAll()
	local entsSelected = {}
	local count = 1

	for i = 1, #entsAround do
	
		if !entsAround[ i ]:IsNPC() && !entsAround[ i ]:IsPlayer() then continue end
		
		local v = entsAround[ i ]
		-- && v:GetKeyValues()['sleepstate'] == 0 && !IsValid(v:GetInternalVariable( "m_hCine" ))
		if ( v:IsNPC() && v:ANPlusClassify() != 0 && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "generic_actor" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && v:ANPlusAlive() ) || ( v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) then
			
			entsSelected[count] = v
			count = count + 1

		end
		
	end

	return entsSelected
	
end

function ENT:ANPlusIgnoreTillSet()
	
	if !self:IsNPC() then return end
	local entsAround = ents.GetAll()
	--local count = 1

	for i = 1, #entsAround do
	
		if !entsAround[ i ]:IsNPC() && !entsAround[ i ]:IsPlayer() then continue end
		
		local v = entsAround[ i ]
			
		if v:IsANPlus() && v:ANPlusGetDataTab()['Relations'] && v:ANPlusGetDataTab()['Relations']['Default'] && !table.HasValue( v.m_tbANPlusRelationsMem, self )  then

			if v:ANPlusGetDataTab()['Relations']['Default']['NPCToMe'][ 1 ] != "Default" then self:AddEntityRelationship( v, D_NU, 99 ) end
			if v:ANPlusGetDataTab()['Relations']['Default']['MeToNPC'][ 1 ] != "Default" then v:AddEntityRelationship( self, D_NU, 99 ) end
			v.m_tbANPlusRelationsMem = {}
		 
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
	
	local posEnemies = ANPlusGetAll()
	local it = 1
	
	for memEnt, disp in pairs( self.m_tbANPlusRelationsMem ) do -- We want to make sure that memory isn't flooded with NULLs. A possible memory leak?
		if !IsValid(memEnt) || ( IsValid(memEnt) && !memEnt:ANPlusAlive() ) then self.m_tbANPlusRelationsMem[ memEnt ] = nil end
	end
	
	while it <= #posEnemies do

	local ent = posEnemies[ it ]
	
		if !IsValid(ent) then
			
			table.remove( posEnemies, it )
		
		else

			it = it + 1
		
			if ent != self then 
				
				local dispTab = self:ANPlusGetDataTab()['Relations'][ ent:GetColor() ] || self:ANPlusGetDataTab()['Relations'][ ent:ANPlusGetName() ] || self:ANPlusGetDataTab()['Relations'][ ent:GetClass() ] || self:ANPlusGetDataTab()['Relations'][ ent:ANPlusClassify() ] || self:ANPlusGetDataTab()['Relations'][ "Default" ]
				
				if dispTab then
	
					local addTab = { [ ent ] = { ['NPCToMeOld'] = ent:IsNPC() && ent:Disposition( self ) || true } }
					
					if !self.m_tbANPlusRelationsMem[ ent ] then

						local meToNPC = dispTab['MeToNPC'] && dispTab['MeToNPC'][ 1 ] || "Default"
						local meToNPC1 = dispTab['MeToNPC'] && RelationsTranslate[ dispTab['MeToNPC'][ 1 ] ]
						local meToNPC2 = dispTab['MeToNPC'] && dispTab['MeToNPC'][ 2 ]

						local npcToMe = dispTab['NPCToMe'] && dispTab['NPCToMe'][ 1 ] || "Default"
						local npcToMe1 = dispTab['NPCToMe'] && RelationsTranslate[ dispTab['NPCToMe'][ 1 ] ]
						local npcToMe2 = dispTab['NPCToMe'] && dispTab['NPCToMe'][ 2 ]

						--print( ent, ent:ANPlusClassify(), ent:IsNPC() && ent:Disposition( self ), npcStr, meToNPC2, npcToMe2 )
						
						if ent:MyVJClass( 1 ) && self:MyVJClass( 1 ) && self:MyVJClass( 1 ) == ent:MyVJClass( 1 ) then
							self:AddEntityRelationship( ent, D_LI, 99 )
							addTab[ ent ]['MeToNPC'] = D_LI

							if ent:IsNPC() then
								ent:AddEntityRelationship( self, D_LI, 0 )
								addTab[ ent ]['NPCToMe'] = D_LI

								ent.VJ_AddCertainEntityAsFriendly = ent.VJ_AddCertainEntityAsFriendly || {}
								ent.VJ_AddCertainEntityAsFriendly[ #ent.VJ_AddCertainEntityAsFriendly + 1 ] = self
							end

						elseif ent:MyVJClass( 1 ) && self:MyVJClass( 1 ) && self:MyVJClass( 1 ) != ent:MyVJClass( 1 ) then
							self:AddEntityRelationship( ent, D_HT, 99 )
							addTab[ ent ]['MeToNPC'] = D_HT

							if ent:IsNPC() then						
								ent:AddEntityRelationship( self, D_HT, 0 )
								addTab[ ent ]['NPCToMe'] = D_HT

								ent.VJ_AddCertainEntityAsEnemy = ent.VJ_AddCertainEntityAsEnemy || {}
								ent.VJ_AddCertainEntityAsEnemy[ #ent.VJ_AddCertainEntityAsEnemy + 1 ] = self
							end
							
						elseif ent:ANPlusClassify() == self:ANPlusClassify() || ent:ANPlusGetName() == self:ANPlusGetName() then
							self:AddEntityRelationship( ent, D_LI, 0 )
							addTab[ ent ]['MeToNPC'] = D_LI

							if ent:IsNPC() then
								ent:AddEntityRelationship( self, D_LI, 0 )
								addTab[ ent ]['NPCToMe'] = D_LI
							end

						else
							
							if meToNPC != "Default" then

								self:AddEntityRelationship( ent, meToNPC1, meToNPC2 )
								addTab[ ent ]['MeToNPC'] = meToNPC1

							end

							if ent:IsNPC() && !ent:MyVJClass() then

								if npcToMe != "Default" then

									ent:AddEntityRelationship( self, npcToMe1, npcToMe2 )
									addTab[ ent ]['NPCToMe'] = npcToMe1

								end
					
							end

						end
						
						table.Merge( self.m_tbANPlusRelationsMem, addTab )

					end
					
				end
			
			end
			
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
			
			local lastMovTime = self:GetInternalVariable( "m_flTimeLastMovement" )
			self:SetSaveValue( "m_flTimeLastMovement", lastMovTime * speed )
				
		end

		local rate = ( istable( aTab1 ) && aTab1[ 1 ] || aTab1 ) / 100
		self:SetPlaybackRate( rate )
		 
	end

	--[[
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
	]]

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
					for _, ev in ipairs( self.m_tbAnimEvents[ seq ][ frame ] ) do
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
	if self:IsNPC() then
		local newState = self:GetNPCState()
		if self.m_fCurNPCState != newState then			
			if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCStateChange'] != nil then
				self:ANPlusGetDataTab()['Functions']['OnNPCStateChange'](self, newState, self.m_fCurNPCState)			
			end	
			self:SetNW2Float( "m_fANPlusNPCState", newState )
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
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCTranslateActivity'] != nil && !self:ANPlusPlayingDeathAnim() && !self:ANPlusPlayingAnim() then
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
		
		if self:ANPlusGetDataTab()['CanFollowPlayers'] then
			
			local fTab = self:ANPlusGetDataTab()['CanFollowPlayers']
			
			if fTab[ 1 ] && fTab[ 2 ] && fTab[ 3 ] && fTab[ 4 ] then
				self:ANPlusFollowPlayer( activator, fTab[ 1 ], fTab[ 2 ], fTab[ 3 ], fTab[ 4 ] ) 
			end

		end

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

function ENT:ANPlusNPCUserButtonUp(ply, button)
	if ( ( self:IsVehicle() && IsValid(self:GetDriver()) && ply == self:GetDriver() ) || ( IsValid(ply:GetEntityInUse()) && ply:GetEntityInUse() == self ) || ( IsValid(self:ANPlusGetFollowTarget()) && self:ANPlusGetFollowTarget() == ply ) ) && !ply:IsWorldClicking() && !ply:ANPlusIsSpawnMenuOpen() then	
		self:ANPlusGetDataTab()['Functions']['OnNPCUserButtonUp'](self, ply, button)	
	end
end

function ENT:ANPlusNPCUserButtonDown(ply, button)
	if ( ( self:IsVehicle() && IsValid(self:GetDriver()) && ply == self:GetDriver() ) || ( IsValid(ply:GetEntityInUse()) && ply:GetEntityInUse() == self ) || ( IsValid(self:ANPlusGetFollowTarget()) && self:ANPlusGetFollowTarget() == ply ) ) && !ply:IsWorldClicking() && !ply:ANPlusIsSpawnMenuOpen() then	
		self:ANPlusGetDataTab()['Functions']['OnNPCUserButtonDown'](self, ply, button)	
	end
end

function ENT:ANPlusNPCPlayerSetupMove(ply, mv, cmd)	
	self:ANPlusGetDataTab()['Functions']['OnNPCPlayerSetupMove'](self, ply, mv, cmd)	
end

net.Receive("anplus_propmenu", function(_, ply)
	local ent = net.ReadEntity()		
	local tab = net.ReadTable()		
	
	ent:ANPlusHaloEffect( Color( 0, 255, 255 ), 5, 1 )
	
	if IsValid(ent) && tab then

		for _, var in pairs( tab ) do 
			if var && var['ValueNew'] != nil then				
				ent[ var['Variable'] ] = var['ValueNew'] || var['ValueNew'] != false && ent[ var['Variable'] ]			

				if ent['m_tSaveDataUpdateFuncs'] && isfunction( ent['m_tSaveDataUpdateFuncs'][ var['Variable'] ] ) then
					ent['m_tSaveDataUpdateFuncs'][ var['Variable'] ](ent, var['ValueNew'])
				end
				
				ent:ANPlusAddSaveData( var['Variable'], ent[ var['Variable'] ], ent['m_tSaveDataUpdateFuncs'] && ent['m_tSaveDataUpdateFuncs'][ var['Variable'] ] || nil )
				
				if ent:IsANPlus(true) && ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'] != nil then	
					ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'](ent, var['Variable'], var['ValueNew'], ply)			
				end
			end
		end
	end
	
end)