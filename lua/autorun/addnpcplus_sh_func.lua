local ENT = FindMetaTable("Entity")

function ENT:ANPlusNPCApply(name, override, transition, preCallback, postCallback)
	
	if ANPlusLoadGlobal && IsValid(self) then
			
		name = tostring( name )
		local dataTab = ANPlusLoadGlobal[ name ]
		
		local cVar = GetConVar( "anplus_replacer_enabled" ):GetBool()
		if cVar && !dataTab && !self:IsANPlus(true) then
			for _, repData in pairs( ANPlusENTReplacerData ) do				
				if repData && !override then
					local modelCheck = self:GetModel() && string.find( string.lower( self:GetModel() ), string.lower( repData['Model'] ) ) || repData['Model'] == "No Model" || false	
					local mapCheck = repData['Map'] == "No Map" || game.GetMap() == repData['Map'] || false	
					--print(repData['Replacement'] , repData['Class'] == self:GetClass() , modelCheck , tonumber( repData['Skin'] ) == self:GetSkin() , mapCheck , ANPlusPercentageChance( tonumber( repData['Chance'] ) ))
					if repData['Replacement'] && repData['Class'] == self:GetClass() && modelCheck && tonumber( repData['Skin'] ) == self:GetSkin() && mapCheck && ANPlusPercentageChance( tonumber( repData['Chance'] ) ) then 					
						name = repData['Replacement'] 
						override = true
					end
				end
			end
		end 

		if name && isstring( name ) then	
			
			local dataTab = ANPlusLoadGlobal[ name ]
			
			if ( dataTab ) then

				if (SERVER) then

					if ( !override && dataTab['Class'] && dataTab['Class'] != self:GetClass() ) then 
						return	
					elseif ( override && dataTab['Class'] != self:GetClass() ) then				
						local newSelf = ents.Create( dataTab['Class'] )	
						newSelf:SetPos( self:GetPos() )
						newSelf:SetAngles( self:GetAngles() )
						newSelf:Spawn()
						newSelf:Activate()
						
						newSelf.m_sNewWeapon = IsValid(self:GetActiveWeapon()) && self:GetActiveWeapon():GetClass()
						
						if isfunction( preCallback ) then
							preCallback( newSelf )
						end
						
						if IsValid(self.m_pMyPlayer) then
							--gamemode.Call( "PlayerSpawnedNPC", self.m_pMyPlayer, newSelf )
							self.m_pMyPlayer:AddCleanup( "npcs", newSelf )
							undo.Create( name )
							undo.AddEntity( newSelf )
							undo.SetPlayer( self.m_pMyPlayer )
							undo.Finish()
						end
						
						self:Remove()
						self = newSelf
					end
					
					net.Start( "anplus_net_entity" )
					net.WriteEntity( self )
					net.WriteString( name )
					net.Broadcast()

				end
				
				local data = table.Copy( dataTab )
				
				local colBoundsMin, colBoundsMax = self:GetCollisionBounds()
				local hull = (SERVER) && self:IsNPC() && self:GetHullType()	|| "Not NPC"	

				--local min2, max2 = self:GetSurroundingBounds()
				if (SERVER) then
					ANPdevMsg( "Collision Bounds: Min[" .. tostring(colBoundsMin) .. "] Max[" .. tostring(colBoundsMax) .. "] | Hull: " .. tostring(hull), 1 )
					ANPdevMsg( "SolidType: " .. self:GetSolid() .. " CollisionGroup: " .. self:GetCollisionGroup() .. " MoveCollide: " .. self:GetMoveCollide() .. " MoveType: " .. self:GetMoveType(), 1 )
				end
				--ANPdevMsg( "Surrounding Bounds: Min[" .. tostring(min2) .. "] Max[" .. tostring(max2), 1 )
				
				local addTab = { ['CurName'] = data['Name'] }
				table.Merge( data, addTab )	
				
				if data['Models'] then

					if (SERVER) then

						local modelTab = self.m_tANPModelTab || ANPlusRandTab( data['Models'] )			
						local CurModel = self.m_sANPCurModel || ( modelTab && util.IsValidModel( modelTab[ 1 ] ) && modelTab[ 1 ] ) || self:GetModel() || "models/weapons/shell.mdl"
						local CurSkin = self.m_fANPCurSkin || ( modelTab && modelTab['Skin'] && istable( modelTab['Skin'] ) && math.random( modelTab['Skin'][ 1 ], modelTab['Skin'][ 2 ] ) ) || modelTab['Skin'] || 0						
						local CurColor = ( modelTab && modelTab['Color'] ) || Color( 255, 255, 255, 255 )
						local CurMaterial = self.m_sANPCurMaterial || ( modelTab && modelTab['Material'] && istable( modelTab['Material'] ) && math.random( modelTab['Material'][ 1 ], #modelTab['Material'], CurTime() ) ) || modelTab['Material'] || ""					
						local CurBoneEdit = ( modelTab && modelTab['BoneEdit'] ) || nil
						local CurScale, CurScaleDelta = modelTab['Scale'] && modelTab['Scale'][ 1 ] / 100 || 1, modelTab['scale'] && modelTab['scale'][ 2 ] || 0		
						
						local sColMin, sColMax, sHull = self['m_tColTab'] && self['m_tColTab'][ 1 ], self['m_tColTab'] && self['m_tColTab'][ 2 ], self['m_tColTab'] && self['m_tColTab'][ 3 ]
						local CurColBoundsMin, CurColBoundsMax = ( sColMin || modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['Min'] || colBoundsMin ), ( sColMax || modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['Max'] || colBoundsMax )								
						local CurHull = sHull || modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['HullType'] || hull
						self:ANPlusAddSaveData( "m_tColTab", { CurColBoundsMin, CurColBoundsMax, hull } )
						self:ANPlusAddSaveData( "m_tANPModelTab", modelTab )					
						for i = 1, #data['Models'] do
							if self:GetModel() != data['Models'][ i ][ 1 ] then										
								self:SetModel( CurModel )
								timer.Simple( 0, function()
									if IsValid(self) && self:GetModel() != CurModel then
										self:SetPos( self:GetPos() + Vector( 0, 0, 5 ) )
										self:SetModel( CurModel )
									end
								end )
							end
						end
						
						self:SetSkin( CurSkin )
						self:SetColor( CurColor )
						self:SetMaterial( CurMaterial )
						self:SetBloodColor( modelTab['BloodColor'] || self:GetBloodColor() )
						self:ANPlusEditBone( CurBoneEdit )										
						if modelTab['Scale'] then self:SetModelScale( CurScale, CurScaleDelta ) end
						
						self:SetCollisionBounds( CurColBoundsMin, CurColBoundsMax )
						--self:SetSurroundingBounds( data['SurroundingBounds'] && data['SurroundingBounds']['Min'] || min2, data['SurroundingBounds'] && data['SurroundingBounds']['Max'] || max2 )
						--if data['SurroundingBounds'] && data['SurroundingBounds']['BoundsType'] then self:SetSurroundingBoundsType( data['SurroundingBounds']['BoundsType'] ) end
						
						if modelTab['PhysicsInit'] then self:PhysicsInit( modelTab['PhysicsInit'] ) end

						if modelTab['PhysicsInitBox'] then self:PhysicsInitBox( modelTab['PhysicsInitBox']['Min'], modelTab['PhysicsInitBox']['Max'], modelTab['PhysicsInitBox']['SurfaceProp'] || "default" ) end
						if modelTab['PhysicsInitSphere'] then self:PhysicsInitSphere( modelTab['PhysicsInitSphere']['Radius'], modelTab['PhysicsInitSphere']['SurfaceProp'] || "default" ) end

						self:SetMoveType( modelTab['SetMoveType'] || self:GetMoveType() )
						self:SetMoveCollide( modelTab['SetMoveCollide'] || self:GetMoveCollide() )
						self:SetCollisionGroup( modelTab['SetCollisionGroup'] || self:GetCollisionGroup() )
						self:SetSolid( modelTab['SetSolid'] || self:GetSolid() )
						
						if self:IsNPC() then
							self:SetHullType( CurHull )
							self:SetHullSizeNormal()
						end
						
						local physCheck = self:GetPhysicsObject()
						if !self.m_bANPVisualSet && IsValid(physCheck) && IsValid(self.m_pMyPlayer) then
							physCheck:Wake()
						end
						
						if !self.m_bANPVisualSet then
						
							if modelTab['BodyGroups'] then
					
								for i = 1, #modelTab['BodyGroups'] do
					
									local curBG = modelTab['BodyGroups'][ i ]					
									local curBGR = curBG && istable( curBG ) && curBG[ 1 ] && math.random( curBG[ 1 ], curBG[ 2 ] ) || curBG || self:GetBodygroup( i )					
									self:SetBodygroup( i, curBGR )
						
								end
								
							end
					
							if modelTab['SubMaterials'] then
							
								for i = 1, #modelTab['SubMaterials'] do

									local curSM = modelTab['SubMaterials'][ i ]
									local curSMR = curSM && istable( curSM ) && curSM[ 1 ] && ANPlusRandTab( curSM ) || curSM || self:GetMaterials()[ i ]	
									self:SetSubMaterial( i - 1, curSMR )
						
								end

							end
							self:ANPlusAddSaveData( "m_bANPVisualSet", true )
						end
						
					end					

				end
				
				if (SERVER) then

					if self:IsNPC() then	
						
						if data['RemoveCapabilities'] then self:CapabilitiesRemove( data['RemoveCapabilities'] ) end
						if data['AddCapabilities'] then self:CapabilitiesAdd( data['AddCapabilities'] ) end														
						if !data['ForceDefaultWeapons'] && !IsValid(self:GetActiveWeapon()) && self:GetKeyValues() && self:GetKeyValues()['additionalequipment'] != "" && self:ANPlusCapabilitiesHas( 2097152 ) then
							if !self.m_bANPlusEntity then
								if self.m_sNewWeapon then
									self:Give( self.m_sNewWeapon ) 
								elseif data['DefaultWeapons'] then		
									local rngW = math.random( 1, #data['DefaultWeapons'] )
									rngW = data['DefaultWeapons'][ rngW ]
									self:Give( rngW ) 	
								end
							end
						end
						if data['ForceDefaultWeapons'] && data['DefaultWeapons'] then self:ANPlusForceDefaultWeapons( data['DefaultWeapons'] ) end
						self:ANPlusUpdateWeaponProficency( self:GetActiveWeapon(), data['WeaponProficiencyTab'] )						
						self:SetMaxLookDistance( data['LookDistance'] || GetConVar( "anplus_look_distance_override" ):GetFloat() ) 
						--if data['LookDistance'] then self:Fire( "SetMaxLookDistance", data['LookDistance'], 0.1 ) end	
			
						--if data['AllowActivityTranslation'] && !IsValid(self:GetWeapon( "ai_translate_act" )) then self:Give( "ai_translate_act" ) end									
						self.m_tbANPlusRelationsMem = {}				
						self.m_fANPlusCurMemoryLast = 0
						self.m_fANPlusCurMemoryDelay = 1
						self.m_fANPlusDangerDetectLast = 0						
						self.m_fANPlusDangerDetectDelay = data['Functions'] && data['Functions']['DetectionDelay'] || 1
						self.m_tbANPlusACTOther = data['ActivityOther']
						self.m_tbANPlusACTMovement = data['ActivityMovement']	
						self.m_fCurNPCState = self:GetNPCState()
						self.m_fCurSchedule = self:GetCurrentSchedule()
						self.m_tTACTData = {}
						if data['UseANPSquadSystem'] then self:ANPlusAddToCSquad( self:ANPlusGetSquadName() ) end

						local class = data['Relations'] && data['Relations']['MyClass']
						local vjClass = data['Relations'] && data['Relations']['MyVJClass']
						self:SetNPCClass( class, vjClass )

					end

					self.m_fANPUseLast = 0
					self.m_fANPlusVelLast = 0
					
					if self:GetSequenceList() then
						self.m_tbAnimationFrames = {}
						for _, v in pairs( self:GetSequenceList() ) do
							local seqID = self:LookupSequence( v )
							local seqFrames = self:SequenceGetFrames( seqID, 1 )
							self.m_tbAnimationFrames[v] = seqFrames
						end
						--
						ANPdevMsg( "A table with all animations of this Entity with their frames:", 1 )
						ANPdevMsg( self.m_tbAnimationFrames, 1 )
						self.m_tbAnimEvents = {}
						self.m_frameLast = -1
						self.m_seqLast = -1		
					end
					
					local hpMul = GetConVar( "anplus_hp_mul" ):GetFloat()
					local hp = ( self.m_tANPHealth && self.m_tANPHealth[ 1 ] || data['Health'] || self:Health() )
					local hpMax = ( self.m_tANPHealth && self.m_tANPHealth[ 2 ] || data['Health'] || self:Health() )
					self:SetHealth( hp * hpMul ) 
					self:SetMaxHealth( hpMax * hpMul )	
					
					if data['InputsAndOutputs'] then
						for i = 1, #data['InputsAndOutputs'] do
							local fireTab = data['InputsAndOutputs'][ i ]
							self:Fire( fireTab[ 1 ] || "", fireTab[ 2 ] || nil, fireTab[ 3 ] || 0, fireTab[ 4 ] || NULL, fireTab[ 5 ] || NULL )	
						end		
					end	
					
					for _, v in pairs( data['KeyValues'] ) do
					
						local filter = _ == "squadname" && self:GetKeyValues()['squadname'] && self:GetKeyValues()['squadname'] != "" && "" || _
	
						self:SetKeyValue( tostring( _ ), v )							
					end
					
					self:SetKeyValue( "spawnflags", data['SpawnFlags'] || self:GetSpawnFlags() )	

				end

				self.m_fANPlusBossMusicLast = 0					
				
				self.ANPlusOverPitch = self.ANPlusOverPitch || sndTab && sndTab['OverPitch'] && math.random( sndTab['OverPitch'][ 1 ], sndTab['OverPitch'][ 2 ] ) || nil				
				self['ANPlusData'] = data
				--self:ANPlusApplyDataTab( data )					
		
				if isfunction( postCallback ) then
					postCallback( self )
				end
				
				if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCSpawn'] != nil then
					self:ANPlusGetDataTab()['Functions']['OnNPCSpawn'](self, self.m_pMyPlayer)		
				end	
				
				if self:ANPlusGetDataTab()['HealthBar'] then
					self:SetNW2Float( "m_fANPBossHP", self:Health() )
					--self:SetNWFloat( "m_fANPBossHPMax", self:GetMaxHealth() )
				end
				
				if (SERVER) then				
	
					self:AddCallback( "PhysicsCollide", self.ANPlusPhysicsCollide ) 					
					---------WIREMOD--------------
					if WireLib && ( self.Inputs || self.Outputs ) then				
						self.IsWire = true						
					end
					---------WIREMOD--------------
	
					function self:PreEntityCopy()
					
						if self:ANPlusIsWiremodCompEnt() then
							duplicator.ClearEntityModifier( self, "WireDupeInfo" )
							-- build the DupeInfo table and save it as an entity mod
							local DupeInfo = WireLib.BuildDupeInfo( self )
							if DupeInfo then
								duplicator.StoreEntityModifier( self, "WireDupeInfo", DupeInfo )
							end
						end
						
						if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPreSave'] != nil then
							self:ANPlusGetDataTab()['Functions']['OnNPCPreSave'](self)
						end
					end
					
					function self:PostEntityCopy()
						self:ANPlusAddSaveData( "m_tANPHealth", { self:Health(), self:GetMaxHealth() } )
						self:ANPlusAddSaveData( "m_sANPCurModel", self:GetModel() )
						self:ANPlusAddSaveData( "m_fANPCurSkin", self:GetSkin() )
						self:ANPlusAddSaveData( "m_sANPCurMaterial", self:GetMaterial() )
						if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPostSave'] != nil then
							self:ANPlusGetDataTab()['Functions']['OnNPCPostSave'](self)
						end
					end
					
					function self:OnEntityCopyTableFinish(dupeData)
						if self:ANPlusIsWiremodCompEnt() then
							-- Called by Garry's duplicator, to modify the table that will be saved about an ent
							-- Remove anything with non-string keys, or util.TableToJSON will crash the game
							dupeData.OverlayData = nil
							dupeData.lastWireOverlayUpdate = nil
							dupeData.WireDebugName = nil
						end
						if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCSaveTableFinish'] != nil then
							self:ANPlusGetDataTab()['Functions']['OnNPCSaveTableFinish'](self, dupeData)
						end
					end
					
					function self:PostEntityPaste(ply, ent, createdEntities)
						if self:ANPlusIsWiremodCompEnt() then						
							local function EntityLookup(createdEntities)
								return function(id, default)
									if id == nil then return default end
									if id == 0 then return game.GetWorld() end
									local wireEnt = createdEntities[id]
									if IsValid(wireEnt) then return wireEnt else return default end
								end
							end

							if self.EntityMods and self.EntityMods.WireDupeInfo then								
								WireLib.ApplyDupeInfo( ply, self, self.EntityMods.WireDupeInfo, EntityLookup(createdEntities) )
							end						
						end
						
						if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPostLoad'] != nil then
							self:ANPlusGetDataTab()['Functions']['OnNPCPostLoad'](ply, self, createdEntities)
						end					
					end
					
					if transition then -- Let's try it this way. Lol idk.	
						
						for i = 1, #self:GetChildren() do
							local child = self:GetChildren()[ i ]
							if IsValid(child) then
								SafeRemoveEntity( child )
							end
						end

						if self:ANPlusIsWiremodCompEnt() then
							WireLib.Restored( self )
						end

						if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCRestore'] != nil then -- Does it work?
							self:ANPlusGetDataTab()['Functions']['OnNPCRestore'](self)
						end		

					end
					
					
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCUserButtonUp'] != nil then
						hook.Add( "PlayerButtonUp", self, self.ANPlusNPCUserButtonUp )
					end
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCUserButtonDown'] != nil then
						hook.Add( "PlayerButtonDown", self, self.ANPlusNPCUserButtonDown )
					end
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPlayerSetupMove'] != nil then
						hook.Add( "SetupMove", self, self.ANPlusNPCPlayerSetupMove )
					end
					
					self:ANPlusAddSaveData( "m_bANPlusEntity", true )
					self:ANPlusAddSaveData( "m_sANPlusName", self:ANPlusGetDataTab()['Name'] )
				end	
				
				hook.Add( "Think", self, self.ANPlusNPCThink )		
				
				if (CLIENT) then -- 
					if data['EnableInverseKinematic'] then self:SetIK( data['EnableInverseKinematic'] ) end	
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCHUDPaint'] != nil then
						hook.Add( "HUDPaint", self, self.ANPlusNPCHUDPaint )
					end
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCRenderOverride'] != nil then
						function self:RenderOverride(flags)
							self:ANPlusGetDataTab()['Functions']['OnNPCRenderOverride'](self, flags)	
						end
					end
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPreDrawEffects'] != nil then
						hook.Add( "PreDrawEffects", self, self.ANPlusNPCPreDrawEffects )
					end
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPostDrawEffects'] != nil then
						hook.Add( "PostDrawEffects", self, self.ANPlusNPCPostDrawEffects )
					end
				end
				
				if self:ANPlusGetDataTab()['Functions'] then
					for key, func in pairs( self:ANPlusGetDataTab()['Functions'] ) do	
						if key && func then
							if isfunction( func ) then
								if (CLIENT) then
									if string.find( key, "CL_Hook_" ) then
										key = string.gsub( key, "CL_Hook_", "" )
										hook.Add( key, self, func )
									elseif string.find( key, "CL_Function_" ) then
										key = string.gsub( key, "CL_Function_", "" )
										self[ key ] = func
									elseif string.find( key, "SH_Hook_" ) then
										key = string.gsub( key, "SH_Hook_", "" )
										hook.Add( key, self, func )
									elseif string.find( key, "SH_Function_" ) then
										key = string.gsub( key, "SH_Function_", "" )
										self[ key ] = func									
									end
								elseif (SERVER) then
									if string.find( key, "SV_Hook_" ) then
										key = string.gsub( key, "SV_Hook_", "" )
										hook.Add( key, self, func )
									elseif string.find( key, "SV_Function_" ) then
										key = string.gsub( key, "SV_Function_", "" )
										self[ key ] = func
									elseif string.find( key, "SH_Hook_" ) then
										key = string.gsub( key, "SH_Hook_", "" )
										hook.Add( key, self, func )
									elseif string.find( key, "SH_Function_" ) then
										key = string.gsub( key, "SH_Function_", "" )
										self[ key ] = func									
									end
								end
							end
						end
					end		
				end

			end
		
		else
			return false
		end
	else 
		return false
	end	
end	 

function ENT:ANPlusApplyDataTab(tab)	
	if !self:ANPlusGetDataTab() then return end
	table.Merge( self:ANPlusGetDataTab(), tab )
	--[[
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
	]]
end

local anplus_bm_volume = GetConVar( "anplus_bm_volume" )

local function CheckDaThing(ent, stop)	-- 1 = always, 2 = when in combat, 3 = when alerted, 4 = when in combat and alerted, 5 = when in combat and only if the player is the enemy.
	if stop || !IsValid(ent) || !ent:ANPlusAlive() || !ent:IsANPlus() then return false end 	
	
	local tab = ent:ANPlusGetDataTab()['BossMusic']

	if !tab && !ent.m_ANPlusBossMusicMode then return false end 

	local ply = LocalPlayer()	
	local state = ent:GetNW2Float( "m_fANPlusNPCState" )
	local enemy = ent:GetNW2Entity( "m_pEnemyShared" )
	local mode = ent.m_ANPlusBossMusicMode || tab['Mode']

	ent.m_bSeenPlayer = ent.m_bSeenPlayer || IsValid(enemy) && enemy == ply

	if ( isfunction( mode ) ) then return mode( ent, state, enemy ) end
	if ( mode == 5 && !ent.m_bSeenPlayer ) then return false end
	if ( mode == 2 && state != 3 ) then return false end	
	if ( mode == 3 && state != 2 ) then return false end
	if ( mode == 4 && state != 2 && state != 3 ) then return false end 

	return true
end

local function CurMusic() -- CSoundPatch [music/hl2_song20_submix4.mp3]
	local ply = LocalPlayer()
	if !IsValid(ply) then return false end
	if !ply.m_sndANPlusBossMusic  then return false end
	snd = tostring( ply.m_sndANPlusBossMusic )
	local cs = string.Replace( snd, "CSoundPatch ", "" )
	cs = string.Replace( cs, "[", "" )
	cs = string.Replace( cs, "]", "" )
	return cs
end

local function SameMusic(string) -- CSoundPatch [music/hl2_song20_submix4.mp3]
	local ply = LocalPlayer()
	if !IsValid(ply) then return false end
	return CurMusic() == string
end

function ENT:ANPlusBossMusic(stop)

	local ply = LocalPlayer()
	local stop = stop

	if !IsValid(ply) then return end

	local bmTab = self:ANPlusGetDataTab()['BossMusic']
	local state = self:GetNW2Float( "m_fANPlusNPCState" )
	local enemy = self:GetNW2Entity( "m_pEnemyShared" )
	local modeFunc = isfunction( bmTab['Mode'] ) && bmTab['Mode']( self, state, enemy )

	local MUSIC 				= self.m_ANPlusBossMusic || modeFunc || bmTab['Music']
	local MUSIC_REPEAT			= self.m_ANPlusBossMusicRepeat || bmTab['Repeat']
	local MUSIC_VOLUME 			= self.m_ANPlusBossMusicVolume || bmTab['Volume']
	local MUSIC_MAX_DISTANCE 	= self.m_ANPlusBossMusicRange || bmTab['Range'] == "Auto" && self:GetNW2Float( "m_fANPlusLookDistance" ) || bmTab['Range']
	local MUSIC_CUTOFF_DISTANCE = self.m_ANPlusBossMusicFRange || bmTab['FadeRange'] <= 1 && bmTab['FadeRange'] > 0 && MUSIC_MAX_DISTANCE * bmTab['FadeRange'] || bmTab['FadeRange']
	local MUSIC_RESTART_DELAY	= self.m_ANPlusBossMusicRDelay || bmTab['ResetDelay']
	local MUSIC_STOP_FADE_DELAY	= self.m_ANPlusBossMusicSDelay || bmTab['StopDelay']

	local totalDistanceScore = 0
	local nearEntities = ents.FindInSphere( ply:GetPos(), MUSIC_MAX_DISTANCE )
	
	local ent, distSqr, dist = ANPlusFindClosestEntity( ply:GetPos(), nearEntities, function(ent) if ent:ANPlusGetName() == self:ANPlusGetName() then return true end end ) 
	if IsValid(ent) then
		local dstSqr, dist = ply:ANPlusGetRange( ent )
		local distanceScore = math.max( 0, MUSIC_MAX_DISTANCE - dist ) 
		totalDistanceScore = totalDistanceScore + distanceScore
		if ent != self then
			stop = false 
			timer.Remove( "ANP_PLAYER_BOSS_MUSIC_FADE" )
		end
	end
	
	if !ply.m_sndANPlusBossMusic && anplus_bm_volume:GetFloat() > 0 then

		if CheckDaThing( self ) then			
			ply.m_sANPlusBossMusicCur		= ply.m_sANPlusBossMusicCur || istable( MUSIC ) && MUSIC[ math.random( 1, #MUSIC ) ] || MUSIC
			ply.m_sndANPlusBossMusic 		= CreateSound( ply, ply.m_sANPlusBossMusicCur )
			ply.m_sndANPlusBossMusic:Stop()
			ply.m_fANPlusBossMusicDur 		= ANPlusSoundDuration( ply.m_sANPlusBossMusicCur )
			ply.m_fANPlusBossMusicDurLast 	= CurTime()
			timer.Remove( "ANP_PLAYER_BOSS_MUSIC_FADE" )
		else

			return
		end
	
	elseif ply.m_sndANPlusBossMusic && ( SameMusic( ply.m_sANPlusBossMusicCur ) && !CheckDaThing( self, stop ) || anplus_bm_volume:GetFloat() <= 0 ) then
		
		if MUSIC_STOP_FADE_DELAY > 0 then ply.m_sndANPlusBossMusic:FadeOut( MUSIC_STOP_FADE_DELAY ) end
		
		timer.Create( "ANP_PLAYER_BOSS_MUSIC_FADE", MUSIC_STOP_FADE_DELAY, 1, function()
			if !IsValid(ply) then return end
			ply.m_sndANPlusBossMusic:Stop()
			ply.m_sANPlusBossMusicCur = nil
			ply.m_sndANPlusBossMusic = nil
		end )

		return
	elseif !SameMusic( ply.m_sANPlusBossMusicCur ) then

		return
	end
	
	local musicVolume = math.min( 1, totalDistanceScore / MUSIC_CUTOFF_DISTANCE )

	local shouldRestartMusic = ( CurTime() - self.m_fANPlusBossMusicLast >= MUSIC_RESTART_DELAY )
	local musicEnded = ( CurTime() - ply.m_fANPlusBossMusicDurLast >= ply.m_fANPlusBossMusicDur )

	if musicVolume > 0 then

		if shouldRestartMusic then
			ply.m_sndANPlusBossMusic:Play()			
		end

		if !ply:Alive() then
			musicVolume = musicVolume * 0.2
		end

		if MUSIC_REPEAT && musicEnded then
			ply.m_sndANPlusBossMusic:Stop()	
			ply.m_sndANPlusBossMusic:Play()
			ply.m_fANPlusBossMusicDurLast = CurTime()
		end

		self.m_fANPlusBossMusicLast = CurTime()

	elseif shouldRestartMusic then

		ply.m_sndANPlusBossMusic:Stop()
		ply.m_sANPlusBossMusicCur = nil	
		ply.m_sndANPlusBossMusic = nil

		return
	else
		musicVolume = 0
	end	

	musicVolume = math.max( 0.01, musicVolume * math.Clamp( MUSIC_VOLUME * anplus_bm_volume:GetFloat(), 0, 1 ) )
	
	ply.m_sndANPlusBossMusic:Play()
	ply.m_sndANPlusBossMusic:ChangePitch( math.Clamp( game.GetTimeScale() * 100, 50, 255 ), 0 ) -- Just for kicks.
	ply.m_sndANPlusBossMusic:ChangeVolume( musicVolume, 0 ) 

end	

function ENT:ANPlusNPCThink()
			
	if ( self:IsANPlus() && !GetConVar("ai_disabled"):GetBool() ) || !self:IsNPC() && self:IsANPlus(true) then
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
					local data = 
					sound.GetLoudestSoundHint( 0, self:GetPos() )
					|| sound.GetLoudestSoundHint( 1, self:GetPos() )
					|| sound.GetLoudestSoundHint( 2, self:GetPos() )
					|| sound.GetLoudestSoundHint( 4, self:GetPos() )
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
					if data then
						if IsValid(data.owner) && data.owner:IsPlayer() && GetConVar("ai_ignoreplayers"):GetBool() then return end
						self:ANPlusGetDataTab()['Functions']['OnNPCSoundHint'](self, data)	
					end
				--end
			end

			if self:ANPlusGetDataTab() && self:ANPlusGetDataTab()['BossMusic'] && self:ANPlusGetDataTab()['BossMusic']['Range'] == "Auto" then self:SetNW2Float( "m_fANPlusLookDistance", self:GetMaxLookDistance() ) end

		end
		
		if (SERVER) && self:ANPlusGetDataTab()['HealthBar'] then
			if self:GetNW2Float( "m_fANPBossHP" ) < self:Health() then
				self:SetNW2Float( "m_fANPBossHP", self:Health() )
			end 
		end
		
		if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCThink'] != nil then
			self:ANPlusGetDataTab()['Functions']['OnNPCThink'](self)	
		end

		if (CLIENT) then
			if self:ANPlusGetDataTab()['BossMusic'] then			
				self:ANPlusBossMusic()
			end
		end
	
	elseif !IsValid(self) || !self:ANPlusAlive() then	
		return false	
	end

end

local function ANPlusOnLoad(ply, ent, data)

	if IsValid(ent) && istable( data ) then -- Adv. Duplicator 2 Support!	
		
		--duplicator.DoGeneric( ent, data )
		
		if data['m_tSaveData'] then

			for var, val in pairs( data['m_tSaveData'] ) do 

				if val then	
					local fixBool = val == "true" && true || val == "false" && false
					val = val != "true" && val != "false" && val || fixBool	
					ent[ var ] = val	

					if data['m_tSaveDataUpdateFuncs'] && isfunction( data['m_tSaveDataUpdateFuncs'][ var ] ) then
						data['m_tSaveDataUpdateFuncs'][ var ](ent, val)
					end
					
					data['m_tSaveData'][ var ] = val
				end

			end
			
			net.Start( "anplus_savedata_net" )
			net.WriteEntity( ent )
			net.WriteTable( data['m_tSaveData'] )
			net.Broadcast()
			
		end
		
		if data['CurName'] then
			
			ent:Spawn()
			
			ent:ANPlusIgnoreTillSet()
			ent:ANPlusNPCApply( data['CurName'] )

			if ent:ANPlusIsWiremodCompEnt() then
				ent.IsWire = true
			end

			if ent:IsANPlus(true) && ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCLoad'] != nil then		
				ent:ANPlusGetDataTab()['Functions']['OnNPCLoad'](ply, ent, data)		
			end	
			
		end
		
	end
	
end
duplicator.RegisterEntityModifier( "anp_duplicator_data", ANPlusOnLoad )

function ENT:ANPlusStoreEntityModifier(data)
	if !data then return end
	duplicator.StoreEntityModifier( self, "anp_duplicator_data", data )
end
