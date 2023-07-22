------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local ENT = FindMetaTable("Entity")

function ENT:ANPlusNPCApply(name, override, preCallback, postCallback)
	
	if ANPlusLoadGlobal && IsValid(self) then

		local dataTab = ANPlusLoadGlobal[name]	
		local cVar = GetConVar( "anplus_replacer_enabled" ):GetBool()
		if cVar && !dataTab then
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

			local dataTab = ANPlusLoadGlobal[name]
			
			if ( dataTab ) then
				if (SERVER) then
					if ( !override && dataTab['Class'] != self:GetClass() ) then 
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

				--data = {}
				
				local addTab = { ['CurName'] = data['Name'] }
				table.Merge( data, addTab )	
				
				if data['Models'] then
									
					local modelTab = ANPlusRandTab( data['Models'] )
					local CurModel = ( modelTab && util.IsValidModel( modelTab[ 1 ] ) && modelTab[ 1 ] ) || self:GetModel() || "models/weapons/shell.mdl"
					local CurSkin = ( modelTab && modelTab['Skin'] && istable( modelTab['Skin'] ) && util.SharedRandom( "anp_skin_rng", modelTab['Skin'][ 1 ], modelTab['Skin'][ 2 ] ) ) || modelTab['Skin'] || 0
					local CurColor = ( modelTab && modelTab['Color'] ) || Color( 255, 255, 255, 255 )
					local CurMaterial = ( modelTab && modelTab['Material'] && istable( modelTab['Material'] ) && util.SharedRandom( "anp_mat_rng", modelTab['Material'][ 1 ], #modelTab['Material'] ) ) || modelTab['Material'] || ""
					local CurBoneEdit = ( modelTab && modelTab['BoneEdit'] ) || nil
					local CurColBoundsMin, CurColBoundsMax = ( modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['Min'] || colBoundsMin ), ( modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['Max'] || colBoundsMax )
					local CurHull = modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['HullType'] || hull
					local CurScale, CurScaleDelta = modelTab['Scale'] && modelTab['Scale'][ 1 ] / 100 || 1, modelTab['scale'] && modelTab['scale'][ 2 ] || 0				
					data['CurBGS'] = {}			
					local CurBGS = {}
					data['CurSMS'] = {}		
					local CurSMS = {}
					
					if (SERVER) then
					
						for i = 1, #data['Models'] do
							if self:GetModel() != data['Models'][ i ][ 1 ] then							
								self:SetModel( CurModel )
							end
						end
						
						self:SetSkin( CurSkin )
						self:SetColor( CurColor )
						self:SetMaterial( CurMaterial )
						self:SetBloodColor( modelTab['BloodColor'] || self:GetBloodColor() )
						self:ANPlusEditBone( CurBoneEdit )
						self:SetCollisionBounds( CurColBoundsMin, CurColBoundsMax )
						if modelTab['Scale'] then self:SetModelScale( CurScale, CurScaleDelta ) end
						--self:SetSurroundingBounds( data['SurroundingBounds'] && data['SurroundingBounds']['Min'] || min2, data['SurroundingBounds'] && data['SurroundingBounds']['Max'] || max2 )
						--if data['SurroundingBounds'] && data['SurroundingBounds']['BoundsType'] then self:SetSurroundingBoundsType( data['SurroundingBounds']['BoundsType'] ) end
						
						if modelTab['PhysicsInit'] then self:PhysicsInit( modelTab['PhysicsInit'] ) end
						self:SetMoveType( modelTab['SetMoveType'] || self:GetMoveType() )
						self:SetMoveCollide( modelTab['SetMoveCollide'] || self:GetMoveCollide() )
						self:SetCollisionGroup( modelTab['SetCollisionGroup'] || self:GetCollisionGroup() )
						self:SetSolid( modelTab['SetSolid'] || self:GetSolid() )
						
						if self:IsNPC() then
							self:SetHullType( CurHull )
							self:SetHullSizeNormal()
						end
						
						local physCheck = self:GetPhysicsObject()
						if !IsValid(physCheck) || self:GetSolid() != SOLID_VPHYSICS then
							--self:SetCycle( 0 )
							--self:ResetSequence( self:SelectWeightedSequence( ACT_IDLE ) )
						end
						
						if modelTab['BodyGroups'] then
				
							for i = 1, #modelTab['BodyGroups'] do
				
								local curBG = modelTab['BodyGroups'][ i ]
								--local curBGR = curBG && istable( curBG ) && curBG[ 1 ] && math.random( curBG[ 1 ], curBG[ 2 ] ) || curBG || self:GetBodygroup( i )					
								local curBGR = curBG && istable( curBG ) && curBG[ 1 ] && math.random( curBG[ 1 ], curBG[ 2 ] ) || curBG || self:GetBodygroup( i )					
								self:SetBodygroup( i, curBGR )
					
							end
							
						end
				
						if modelTab['SubMaterials'] then
						
							for i = 1, #modelTab['SubMaterials'] do

								local curSM = modelTab['SubMaterials'][ i ]
								--local curSMR = curSM && istable( curSM ) && curSM[ 1 ] && curSM[ math.random( 1, #curSM ) ] || curSM || self:GetMaterials()[ i ]	
								local curSMR = curSM && istable( curSM ) && curSM[ 1 ] && ANPlusRandTab( curSM ) || curSM || self:GetMaterials()[ i ]	
								self:SetSubMaterial( i - 1, curSMR )
					
							end
							--
							
						--
						end
						
					end
					
					if table.Count( data['CurBGS'] ) <= 0 then

						for i = 1, #self:GetBodyGroups() do		
							CurBGS[ i ] = self:GetBodygroup( i )	
						end
			 
						local addTab = { ['CurBGS'] = CurBGS }
						table.Merge( data, addTab )
				
					end
					if table.Count( data['CurSMS'] ) <= 0 then
				
						for i = 0, #self:GetMaterials() do			
							CurSMS[ i + 1 ] = self:GetSubMaterial( i ) || self:GetMaterials()[ i ]	
						end

						local addTab = { ['CurSMS'] = CurSMS }
						table.Merge( data, addTab )
		
					end
					local addTab = { ['CurModel'] = self:GetModel() }
					table.Merge( data, addTab )			
					local addTab = { ['CurSkin'] = self:GetSkin() }
					table.Merge( data, addTab )		
					local addTab = { ['CurColor'] = self:GetColor() }
					table.Merge( data, addTab )			
					local addTab = { ['CurMaterial'] = self:GetMaterial() }
					table.Merge( data, addTab )		
					

				end
				
				if (SERVER) then
					if self:IsNPC() then		
						if data['RemoveCapabilities'] then self:CapabilitiesRemove( data['RemoveCapabilities'] ) end
						if data['AddCapabilities'] then self:CapabilitiesAdd( data['AddCapabilities'] ) end														
						if !data['ForceDefaultWeapons'] && !IsValid(self:GetActiveWeapon()) && self:ANPlusCapabilitiesHas( 2097152 ) then
							if self.m_sNewWeapon then
								self:Give( self.m_sNewWeapon ) 
							elseif self:GetKeyValues() && self:GetKeyValues()['additionalequipment'] && self:GetKeyValues()['additionalequipment'] != "" then
								self:Give( self:GetKeyValues()['additionalequipment'] ) 	
							end
						end
						if data['ForceDefaultWeapons'] && data['DefaultWeapons'] then self:ANPlusForceDefaultWeapons( data['DefaultWeapons'] ) end
						self:ANPlusUpdateWeaponProficency( self:GetActiveWeapon(), data['WeaponProficiencyTab'] )						
						self:SetMaxLookDistance( data['LookDistance'] || GetConVar( "anplus_look_distance_override" ):GetFloat() ) 
						--if data['LookDistance'] then self:Fire( "SetMaxLookDistance", data['LookDistance'], 0.1 ) end	
						if data['EnableInverseKinematic'] then self:ANPlusSetIK( data['EnableInverseKinematic'] ) end	
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
					end
					self.m_fANPUseLast = 0
					self:SetUseType(SIMPLE_USE)
					
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
					self:SetHealth( ( data['Health'] || self:Health() ) * hpMul )				
					self:SetMaxHealth( ( data['Health'] || self:Health() ) * hpMul )
					
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

				--local sndTab = data['SoundModification']						
				--local addTab = { ['SoundModification'] = sndTab }
				--table.Merge( data, addTab )
				
				self.ANPlusOverPitch = self.ANPlusOverPitch || sndTab && sndTab['OverPitch'] && math.random( sndTab['OverPitch'][ 1 ], sndTab['OverPitch'][ 2 ] ) || nil				
				self:ANPlusApplyDataTab( data )					
				
				if (SERVER) then self:ANPlusSetKillfeedName( data['KillfeedName'] ) end
				
				self['m_tSaveDataMenu'] = self['m_tSaveDataMenu'] || {}
				self['m_tSaveDataUpdateFuncs'] = self['m_tSaveDataUpdateFuncs'] || {}
				
				if isfunction( postCallback ) then
					postCallback( self )
				end
				
				for _, v in pairs( self:GetTable() ) do 
					if v && IsEntity( v ) && IsValid(v) && IsValid(v:GetParent()) && v:GetParent() == self then
						SafeRemoveEntity( v )
					end
				end

				if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCSpawn'] != nil then
					self:ANPlusGetDataTab()['Functions']['OnNPCSpawn'](self, self.m_pMyPlayer)		
				end	
				
				hook.Add( "Think", self, self.ANPlusNPCThink )
				
				if (SERVER) then
					self:AddCallback( "PhysicsCollide", self.ANPlusPhysicsCollide ) 
				end				
				if (CLIENT) then
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCRenderOverride'] != nil then
						self.RenderOverride = function(flags)
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
				
				self.ANPlusEntity = true
			end
		
		else
			return false
		end
	else 
		return false
	end	
end	

function ENT:ANPlusGetDataTab()
	if self:GetTable() && self:GetTable()['ANPlusData'] then
		return self:GetTable()['ANPlusData']
	else
		return nil
	end
end

function ENT:ANPMuteSound(bool)
	self:SetNWBool( "ANP_IsMuted", bool )
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
	
	if muzzleSmokeDelay && !IsValid(self.m_pMuzzleSmoke) then
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
	util.Effect( "anp_shell", fx )	

end
  
function ENT:ANPlusFireBullet(bullet, hShotChan, pos, delay, burstCount, burstReset, fireSND, distFireSND, callback) -- bulletcallback = function(att, tr, dmginfo) | callback = function( origin, vector )

	if !bullet then return end
	
	self.m_fANPBulletLast = self.m_fANPBulletLast || 0
	self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst || burstCount
	if bullet && ( delay && CurTime() - self.m_fANPBulletLast >= delay ) && ( !burstCount || ( burstCount > 0 && self.m_fANPCurBulletBurst > 0 ) ) then

		local target = IsValid(self:GetEnemy()) && self:GetEnemy() || IsValid(self:GetTarget()) && self:GetTarget() || false
		local muzzlePos = target && self:ANPlusInRange( target, 16384 ) && pos || self:WorldSpaceCenter()	
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