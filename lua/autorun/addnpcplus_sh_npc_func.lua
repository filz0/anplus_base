------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local ENT = FindMetaTable("Entity")

function ENT:ANPlusNPCApply(name, override, preCallback, postCallback)
	
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
					
					net.Start("anplus_net_entity")
					net.WriteEntity( self )
					net.WriteString( name )
					net.Broadcast()
				
					self:SetKeyValue( "parentname" , "" ) -- We don't need it anymore
					
				end
				
				--local baseTab = dataTab['Base'] && ANPlusLoadGlobal[ dataTab['Base'] ]
				--local base = baseTab && table.Copy( baseTab )
				local data = table.Copy( dataTab )
				--data = base && table.Merge( base, data ) || data
				
				local colBoundsMin, colBoundsMax = self:GetCollisionBounds()
				local hull = (SERVER) && self:IsNPC() && self:GetHullType()	|| "Not NPC"	

				--local min2, max2 = self:GetSurroundingBounds()
				if (SERVER) then
					ANPdevMsg( "Collision Bounds: Min[" .. tostring(colBoundsMin) .. "] Max[" .. tostring(colBoundsMax) .. "] | Hull: " .. tostring(hull), 1 )
					ANPdevMsg( "SolidType: " .. self:GetSolid() .. " CollisionGroup: " .. self:GetCollisionGroup() .. " MoveCollide: " .. self:GetMoveCollide() .. " MoveType: " .. self:GetMoveType(), 1 )
				end
				--ANPdevMsg( "Surrounding Bounds: Min[" .. tostring(min2) .. "] Max[" .. tostring(max2), 1 )

				--data = {}
				
				local addTab = { ['CurName'] = data['Name'] }
				table.Merge( data, addTab )	

				if data['Models'] then
									
					local modelTab = self.m_tANPModelTab || ANPlusRandTab( data['Models'] )			
					local CurModel = self.m_sANPCurModel || ( modelTab && util.IsValidModel( modelTab[ 1 ] ) && modelTab[ 1 ] ) || self:GetModel() || "models/weapons/shell.mdl"
					local CurSkin = self.m_fANPCurSkin || ( modelTab && modelTab['Skin'] && istable( modelTab['Skin'] ) && util.SharedRandom( "anp_skin_rng", modelTab['Skin'][ 1 ], modelTab['Skin'][ 2 ] ) ) || modelTab['Skin'] || 0							
					local CurColor = ( modelTab && modelTab['Color'] ) || Color( 255, 255, 255, 255 )
					local CurMaterial = self.m_sANPCurMaterial || ( modelTab && modelTab['Material'] && istable( modelTab['Material'] ) && util.SharedRandom( "anp_mat_rng", modelTab['Material'][ 1 ], #modelTab['Material'] ) ) || modelTab['Material'] || ""					
					local CurBoneEdit = ( modelTab && modelTab['BoneEdit'] ) || nil
					local CurScale, CurScaleDelta = modelTab['Scale'] && modelTab['Scale'][ 1 ] / 100 || 1, modelTab['scale'] && modelTab['scale'][ 2 ] || 0				

					if (SERVER) then
						
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
						--if (SERVER) then
						if modelTab['PhysicsInitBox'] then self:PhysicsInitBox( modelTab['PhysicsInitBox']['Min'], modelTab['PhysicsInitBox']['Max'], modelTab['PhysicsInitBox']['SurfaceProp'] || "default" ) end
						if modelTab['PhysicsInitSphere'] then self:PhysicsInitSphere( modelTab['PhysicsInitSphere']['Radius'], modelTab['PhysicsInitSphere']['SurfaceProp'] || "default" ) end
						--end
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
						if data['Relations'] && isnumber( data['Relations']['Class'] ) then
							local class = data['Relations']['Class']
							self:SetNPCClass(class)
						end
					end
					self.m_fANPUseLast = 0
					--self:SetUseType(SIMPLE_USE)
					
					if self:GetSequenceList() then
						self.m_tbAnimationFrames = {}
						for _, v in pairs( self:GetSequenceList() ) do
							local seqID = self:LookupSequence( v )
							local seqInfo = self:GetAnimInfo( seqID )
							self.m_tbAnimationFrames[v] = seqInfo.numframes
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
				end
				
				for _, v in pairs( data['KeyValues'] ) do
					if _ != "targetname" then -- We don't have to do that anymore.
						self:SetKeyValue( tostring( _ ), v )		
					end
				end
				
				self:SetKeyValue( "spawnflags", data['SpawnFlags'] || self:GetSpawnFlags() )			
				self.m_fANPlusVelLast = 0
				
				self.ANPlusOverPitch = self.ANPlusOverPitch || sndTab && sndTab['OverPitch'] && math.random( sndTab['OverPitch'][ 1 ], sndTab['OverPitch'][ 2 ] ) || nil				
				self:ANPlusApplyDataTab( data )					
		
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
					--[[
					function self:OnRestore()				
						if self:ANPlusIsWiremodCompEnt() then
							WireLib.Restored( self )
						end
						if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCRestore'] != nil then -- Does it work?
							self:ANPlusGetDataTab()['Functions']['OnNPCRestore'](self)
						end			
					end
					]]--
					
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

function ENT:ANPMuteSound(bool)
	self:SetNW2Bool( "m_bANPMuted", bool )
end

function ENT:ANPlusApplyFlexData(flexTab, scale)

	if !flexTab then return end
	
	self:SetFlexScale( scale || 1 )
	
	for i = 1, #flexTab do

		self:SetFlexWeight( i - 1, flexTab[ i ] )
		
	end

end

function ENT:ANPlusShootEffect(att, flags, scale, effect, muzzleSmokeDelay, muzzleSmokeDur)	-- flags for default hl2 muzzle = flags. For ANP muzzles = boneID (instead of the attachment).
	
	local att = isnumber(att) && att > 0 && att || isstring(att) && self:LookupAttachment( att ) || nil 
	
	if effect then		
		--local attTab = att && att > -1 && self:GetAttachment( att ) || nil 
		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetAttachment( att || -1 )
		fx:SetFlags( flags || 0 )
		fx:SetScale( scale || 1 )
		util.Effect( effect, fx )	
	end
	
	if muzzleSmokeDelay then
		if IsValid(self.m_pMuzzleSmoke) then self.m_pMuzzleSmoke:Remove() end
		muzzleSmokeDelay = muzzleSmokeDelay == -1 && ( self.Primary.PreFireReset || self.Primary.Delay * 2 + self:GetNPCCurRestTime() ) || muzzleSmokeDelay
		muzzleSmokeDur = muzzleSmokeDur || 1
		timer.Create( "ANPlusSmokeEffectTimer" .. self:EntIndex(), muzzleSmokeDelay, 1, function()			
			if !IsValid(self) || IsValid(self.m_pMuzzleSmoke) then return end			
			--ParticleEffectAttach( "weapon_muzzle_smoke_b", 4, self, att )  	
			self.m_pMuzzleSmoke = ANPlusCreateParticle( "weapon_muzzle_smoke_b", nil, muzzleSmokeDur, self, att )
		end )		
	end	
end

--[[
function ENT:ANPlusHitEffect( tr, scale )
	
	if tr && tr.Hit && !tr.HitSky then 
	
		local fx = EffectData()
		fx:SetOrigin( tr.HitPos )
		fx:SetNormal( tr.HitNormal )
		fx:SetScale( scale || 0 )
		util.Effect( "anp_hit_effect", fx )
	
	end

end
--]]  
--[[
1 = models/shells/shell_9mm.mdl
2 = models/shells/shell_57.mdl
3 = models/shells/shell_556.mdl
4 = models/shells/shell_762nato.mdl
5 = models/shells/shell_12gauge.mdl
6 = models/shells/shell_338mag.mdl
7 = models/weapons/rifleshell.mdl
--]]

function ENT:ANPlusShell( att, bone, type, scale, angVec )
	
	local boneid = isnumber(bone) && bone || isstring(bone) && self:LookupBone( bone || "" ) || nil 
	local att = isnumber(att) && att > -1 && att || isstring(att) && self:LookupAttachment( att ) || nil 

	local fx = EffectData()
	fx:SetEntity( self )
	fx:SetAttachment( att || -1 )
	fx:SetColor( boneid || -1 )
	fx:SetRadius( type || 1 ) 
	fx:SetScale( scale || 1 )
	fx:SetStart( angVec || Vector( 0, 0, 0 ) )
	util.Effect( "anp_npc_shell", fx )	

end

function ENT:ANPlusHitEffect(effect, tr, scale)	
	if tr && !tr.HitSky then 	
		local fx = EffectData()
		fx:SetOrigin( tr.HitPos )
		fx:SetNormal( tr.HitNormal )
		fx:SetScale( scale || 1 )
		util.Effect( effect, fx )	
	end
end

function ENT:ANPlusFireBullet(bullet, target, hShotChan, muzzlePos, delay, burstCount, burstReset, fireSND, distFireSND, callback) -- bulletcallback = function(att, tr, dmginfo) | callback = function( origin, vector )

	if !bullet then return end
	
	self.m_fANPBulletLast = self.m_fANPBulletLast || 0
	self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst || burstCount
	if bullet && ( delay && CurTime() - self.m_fANPBulletLast >= delay ) && ( !burstCount || ( burstCount > 0 && self.m_fANPCurBulletBurst > 0 ) ) then

		local target = self:IsNPC() && IsValid(self:GetEnemy()) && self:GetEnemy() || self:IsNPC() && IsValid(self:GetTarget()) && self:GetTarget() || target || false
		muzzlePos = target && self:ANPlusInRange( target, 16384 ) && muzzlePos || self:WorldSpaceCenter()	
		local targetPos = target && ( ( ( isbool( hShotChan ) && hShotChan == true && target:ANPlusGetHitGroupBone( 1 ) ) || isnumber( hShotChan ) && ANPlusPercentageChance( hShotChan ) && target:ANPlusGetHitGroupBone( 1 ) ) || target:ANPlusGetHitGroupBone( 2 ) || target:BodyTarget( muzzlePos ) || target:WorldSpaceCenter() || target:GetPos() )
		local direction = targetPos && ( targetPos - muzzlePos ):GetNormalized() || self:GetAimVector()
		
		bullet.Src 			= muzzlePos
		bullet.Dir 			= direction

		self:FireBullets( bullet )
		
		if IsValid(self.m_pMuzzleSmoke) then self.m_pMuzzleSmoke:Remove() end
		
		if isfunction( callback ) then
			
			callback( muzzlePos, direction, pos )
				
		end
		
		if burstCount && burstCount > 0 then		
			self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst - 1
			timer.Create( "ANP_BulletBurstReset" .. self:EntIndex(), burstReset, 1, function()	
				if IsValid(self) then				
					self.m_fANPCurBulletBurst = burstCount || 0							
				end		
			end)		
		end
		
		if (SERVER) then
			if distFireSND then sound.Play( distFireSND, self:GetPos() ) end
			if fireSND then self:EmitSound( fireSND ) end
		end
		
		self.m_fANPBulletLast = CurTime()
	end
	
end
--[[
function ENT:ANPlusFireBullet( bullet, marksmanAiming, pos, delay, burstCount, burstReset, fireSND, distFireSND, callback )
	
	if !bullet then return end
	
	self.m_fANPBulletLast = self.m_fANPBulletLast || 0
	self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst || burstCount
	if bullet && ( delay && CurTime() - self.m_fANPBulletLast >= delay ) && ( !burstCount || ( burstCount > 0 && self.m_fANPCurBulletBurst > 0 ) ) then
		
		local src, dir = nil
		if marksmanAiming && ( IsValid(self:GetEnemy()) || IsValid(self:GetTarget()) ) then
			target = self:GetEnemy() || self:GetTarget()
			aimPos = target:ANPlusGetHitGroupBone( 1 ) || target:ANPlusGetHitGroupBone( 2 ) || target:ANPlusGetHitGroupBone( 3 ) || target:ANPlusGetHitGroupBone( 4 ) || target:ANPlusGetHitGroupBone( 5 ) || target:ANPlusGetHitGroupBone( 6 ) || target:ANPlusGetHitGroupBone( 7 ) || target:WorldSpaceCenter() || target:GetPos() 
			src, dir = self:ANPlusNPCGetImprovedAiming( pos, target, aimPos )
		end

		bullet.Src = bullet.Src || src || self:GetShootPos()
		bullet.Dir = bullet.Dir || dir || self:GetAimVector()
		self:FireBullets( bullet )
		
		if isfunction( callback ) then	
			callback( self )
		end

		if burstCount && burstCount > 0 then		
			self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst - 1
			timer.Create( "ANP_BulletBurstReset" .. self:EntIndex(), burstReset, 1, function()	
				if IsValid(self) then				
					self.m_fANPCurBulletBurst = burstCount || 0							
				end		
			end)		
		end
	
		if (SERVER) then
			if distFireSND then sound.Play( distFireSND, self:GetPos() ) end
			if fireSND then self:EmitSound( fireSND ) end
		end
	
		self.m_fANPBulletLast = CurTime()
	
	end
	
end
]]--
/*
ENT:ANPlusGetEmittedLastSound().SoundName
ENT:ANPlusGetEmittedLastSound().SoundLevel
ENT:ANPlusGetEmittedLastSound().SoundTime
ENT:ANPlusGetEmittedLastSound().Pitch
ENT:ANPlusGetEmittedLastSound().Channel
ENT:ANPlusGetEmittedLastSound().Volume
ENT:ANPlusGetEmittedLastSound().Flags
ENT:ANPlusGetEmittedLastSound().Pos
ENT:ANPlusGetEmittedLastSound().DSP
*/

function ENT:ANPlusGetEmittedLastSound()
	return self.m_tLastSoundEmitted
end

function ENT:ANPlusGetHearDistance()
	return self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['HearDistance'] || nil
end

function ENT:ANPlusNPCGetEyeTrace(dist, mask) -- Almost certainly doens't work.	
	local tr = util.TraceLine( {
		start = self:EyePos(),
		endpos = self:EyePos() + self:EyeAngles():Forward() * ( dist || 2056 ),
		filter = { self, self:GetActiveWeapon() },
		mask = mask || MASK_VISIBLE_AND_NPCS
	})
	
	return tr	
end

function ENT:ANPlusFakeModel(model, visualTab)

	if (SERVER) then
	
		if model && !IsValid(self.m_pFakeModel) then
			self.m_pFakeModel = ents.Create( "prop_dynamic" )
			self.m_pFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
			self.m_pFakeModel:Spawn()
			self.m_pFakeModel:SetSolid( SOLID_NONE )
			self.m_pFakeModel:SetMoveType( MOVETYPE_NONE )
			self.m_pFakeModel:SetNotSolid( true )
			self.m_pFakeModel:SetParent( self )
			self.m_pFakeModel:AddEffects( EF_BONEMERGE )
			self.m_pFakeModel:SetOwner( self )
			self:SetNoDraw( true )
			self:DrawShadow( false )
			self:DeleteOnRemove( self.m_pFakeModel )
			
			if self:IsNPC() then
				local addTab = { ['CurFakeModel'] = { ['Model'] = model, ['VisualTab'] = self.m_pFakeModel:ANPlusGetVisual() } }
				table.Merge( self:ANPlusGetDataTab(), addTab )			
				self:ANPlusApplyDataTab( self:ANPlusGetDataTab() )
			end
			
		elseif model && IsValid(self.m_pFakeModel) then
		
			self.m_pFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
			if self:IsNPC() then
				local addTab = { ['CurFakeModel'] = { ['Model'] = model, ['VisualTab'] = self.m_pFakeModel:ANPlusGetVisual() } }
				table.Merge( self:ANPlusGetDataTab(), addTab )			
				self:ANPlusApplyDataTab( self:ANPlusGetDataTab() )
			end
		end
		
		return IsValid(self.m_pFakeModel) && self.m_pFakeModel || false
		
	elseif (CLIENT) then
	
		if model && !IsValid(self.m_pCFakeModel) then
			self.m_pCFakeModel = ents.CreateClientProp( model )
			self.m_pCFakeModel:ANPlusCopyVisualFrom( visualTab || self )
			self.m_pCFakeModel:Spawn()
			self.m_pCFakeModel:SetSolid( SOLID_NONE )
			self.m_pCFakeModel:SetMoveType( MOVETYPE_NONE )
			self.m_pCFakeModel:SetNotSolid( true )
			self.m_pCFakeModel:SetParent( self )
			self.m_pCFakeModel:AddEffects( EF_BONEMERGE )
			self.m_pCFakeModel:SetOwner( self )
			self:SetNoDraw( true )
			self:DrawShadow( false )
			
			function self.m_pCFakeModel:ANPlus_CheckCRemoval() -- Because C_Ragdolls return nothing in Remove hooks.
				if !IsValid(self:GetParent()) then self:Remove() end
			end
			
			hook.Add( "Think", self.m_pCFakeModel, self.m_pCFakeModel.ANPlus_CheckCRemoval )
			
		elseif model && IsValid(self.m_pCFakeModel) then
			self.m_pCFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
		end
		
		return IsValid(self.m_pCFakeModel) && self.m_pCFakeModel || false
		
	end
	
end

function ENT:ANPlusGetRagdollEntity()
	if (SERVER) then
		return self.m_pSRagdollEntity
	elseif (CLIENT) then
		return self.m_pCRagdollEntity
	end
end