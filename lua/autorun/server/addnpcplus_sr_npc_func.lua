local ENT = FindMetaTable("Entity")

function ENT:ANPlusNPCApply(name)

	if IsValid(self) && name && isstring( name ) && ANPlusLoadGlobal then

		for i = 1, #ANPlusLoadGlobal do
		
			local dataTab = ANPlusLoadGlobal[ i ]

			if ( dataTab && dataTab['Name'] == name && dataTab['Class'] == self:GetClass() ) then
				
				local data = table.Copy( dataTab )
				
				local colBoundsMin, colBoundsMax = self:GetCollisionBounds()
				--local min2, max2 = self:GetSurroundingBounds()
				local hull = self:IsNPC() && self:GetHullType()	|| "Not NPC"			
				ANPdevMsg( "Collision Bounds: Min[" .. tostring(min) .. "] Max[" .. tostring(max) .. "] | Hull: " .. tostring(hull), 1 )
				ANPdevMsg( "SolidType: " .. self:GetSolid() .. " CollisionGroup: " .. self:GetCollisionGroup() .. " MoveCollide: " .. self:GetMoveCollide() .. " MoveType: " .. self:GetMoveType(), 1 )
				--ANPdevMsg( "Surrounding Bounds: Min[" .. tostring(min2) .. "] Max[" .. tostring(max2), 1 )
	
				data['CurData'] = {}
	
				if data['Models'] then
					
					local modelTab = data['Models'][ math.random( 1, #data['Models'] ) ]		
					local CurModel = ( modelTab && util.IsValidModel( modelTab[ 1 ] ) && modelTab[ 1 ] ) || self:GetModel() || "models/weapons/shell.mdl"
					local CurSkin = ( modelTab && modelTab['Skin'] && istable( modelTab['Skin'] ) && math.random( modelTab['Skin'][ 1 ], modelTab['Skin'][ 2 ] ) ) || modelTab['Skin'] || 0
					local CurColor = ( modelTab && modelTab['Color'] ) || Color( 255, 255, 255, 255 )
					--local CurMaterial = ( modelTab && modelTab['Material'] ) || ""
					local CurMaterial = ( modelTab && modelTab['Material'] && istable( modelTab['Material'] ) && math.random( modelTab['Material'][ 1 ], #modelTab['Material'] ) ) || modelTab['Material'] || ""
					local CurBoneEdit = ( modelTab && modelTab['BoneEdit'] ) || nil
					local CurColBoundsMin, CurColBoundsMax = ( modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['Min'] || colBoundsMin ), ( modelTab && modelTab['CollisionBounds'] && modelTab['CollisionBounds']['Max'] || colBoundsMax )
					local CurScale, CurScaleDelta = modelTab['Scale'] && modelTab['Scale'][ 1 ] / 100 || 1, modelTab['scale'] && modelTab['scale'][ 2 ] || 0
					
					for i = 1, #data['Models'] do
						if self:GetModel() != data['Models'][ i ][ 1 ] then
							self:SetModel( CurModel )
							--self:SetKeyValue( "model", CurModel )
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
					
					local addTab = { ['CurName'] = data['Name'] }
					table.Merge( data['CurData'], addTab )		
					local addTab = { ['CurModel'] = CurModel }
					table.Merge( data['CurData'], addTab )			
					local addTab = { ['CurSkin'] = CurSkin }
					table.Merge( data['CurData'], addTab )		
					local addTab = { ['CurColor'] = CurColor }
					table.Merge( data['CurData'], addTab )			
					local addTab = { ['CurMaterial'] = CurMaterial }
					table.Merge( data['CurData'], addTab )
		
					if modelTab['BodyGroups'] then
		
						data['CurData']['CurBGS'] = {}			
						local CurBGS = {}
			
						for i = 1, #modelTab['BodyGroups'] do
			
							local curBG = modelTab['BodyGroups'][ i ]
							local curBGR = curBG && istable( curBG ) && curBG[ 1 ] && math.random( curBG[ 1 ], curBG[ 2 ] ) || curBG || self:GetBodygroup( i )					
							self:SetBodygroup( i, curBGR )
				
						end
						--
						if table.Count( data['CurData']['CurBGS'] ) <= 0 then
			
							for i = 1, self:GetNumBodyGroups() do		
								if !table.HasValue( CurBGS, i ) then table.insert( CurBGS, i ) end		
							end
	
							for i = 1, #CurBGS do		
								CurBGS[ i ] = self:GetBodygroup( i )	
							end
				 
							local addTab = { ['CurBGS'] = CurBGS }
							table.Merge( data['CurData'], addTab )
			
						end
						--
					end
			
					if modelTab['SubMaterials'] then
		
						data['CurData']['CurSMS'] = {}		
						local CurSMS = {}
			
						for i = 1, #modelTab['SubMaterials'] do

							local curSM = modelTab['SubMaterials'][ i ]
							local curSMR = curSM && istable( curSM ) && curSM[ 1 ] && curSM[ math.random( 1, #curSM ) ] || curSM || self:GetMaterials()[ i ]	
							self:SetSubMaterial( i - 1, curSMR )
				
						end
						--
						if table.Count( data['CurData']['CurSMS'] ) <= 0 then
			
							for i = 0, #self:GetMaterials() do			
								CurSMS[ i + 1 ] = self:GetSubMaterial( i ) || self:GetMaterials()[ i ]	
							end

							local addTab = { ['CurSMS'] = CurSMS }
							table.Merge( data['CurData'], addTab )
			
						end
					--
					end
	
				end
				
				--[[
				local physCheck = self:GetPhysicsObject()
				if IsValid(physCheck) && self:GetSolid() == SOLID_VPHYSICS then
					self:PhysicsInit( SOLID_VPHYSICS )
				else
					self:SetSequence( self:SelectWeightedSequence( ACT_IDLE ) )
				end
				]]--
				self:SetSolid( SOLID_BBOX )
				if self:IsNPC() then				
					self:SetHullType( data['CollisionBounds'] && data['CollisionBounds']['HullType'] || hull )
					self:SetHullSizeNormal()	
					if data['WeaponProficiency'] then self:SetCurrentWeaponProficiency( data['WeaponProficiency'] ) end	
					if data['AddCapabilities'] then self:CapabilitiesAdd( data['AddCapabilities'] ) end
					if data['RemoveCapabilities'] then self:CapabilitiesRemove( data['RemoveCapabilities'] ) end
					--if data['LookDistance'] then self:SetMaxLookDistance( data['LookDistance'] ) end -- How tf it doesn't work for some people is beyond me. 
					if data['LookDistance'] then self:Fire( "SetMaxLookDistance", data['LookDistance'], 0.1 ) end	
					if data['EnableInverseKinematic'] then self:ANPlusSetIK( data['EnableInverseKinematic'] ) end	
					if data['ForceDefaultWeapons'] && data['DefaultWeapons'] then self:ANPlusForceDefaultWeapons( data['DefaultWeapons'] ) end
					--if data['AllowActivityTranslation'] && !IsValid(self:GetWeapon( "ai_translate_act" )) then self:Give( "ai_translate_act" ) end									
					self.m_tbANPlusRelationsMem = {}				
					self.m_fANPlusCurMemoryLast = 0
					self.m_fANPlusCurMemoryDelay = 1
					--self.m_bDeathAnim = { ACT_DIESIMPLE, 0, 0, true }
					self.m_tbANPlusACTOther = data['ActivityOther']
					self.m_tbANPlusACTMovement = data['ActivityMovement']	
					self.m_fCurNPCState = self:GetNPCState()
					self.m_tTACTData = {}
					if data['UseANPSquadSystem'] then self:ANPlusAddToCSquad( self:ANPlusGetSquadName() ) end
				end
				self:SetUseType(SIMPLE_USE)
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
				self:SetHealth( data['Health'] || self:Health() )				
				self:SetMaxHealth( data['Health'] || self:Health() )
				
				for _, v in pairs( data['KeyValues'] ) do
					self:SetKeyValue( tostring( _ ), v )			
				end
			
				self:SetKeyValue( "spawnflags", data['SpawnFlags'] || self:GetSpawnFlags() )		
				
				if data['InputsAndOutputs'] then
					for i = 1, #data['InputsAndOutputs'] do
						local fireTab = data['InputsAndOutputs'][ i ]
						self:Fire( fireTab[ 1 ] || "", fireTab[ 2 ] || nil, fireTab[ 3 ] || 0, fireTab[ 4 ] || NULL, fireTab[ 5 ] || NULL )	
					end		
				end		

				self.m_fANPlusDmgDealt = data['DamageDealtScale'] || 0
				self.m_fANPlusDmgSelf = data['DamageSelfScale'] || 0
				self.m_fANPlusVelLast = 0
	
				local sndTab = data['SoundModification']						
				local addTab = { ['SoundModification'] = sndTab }
				table.Merge( data['CurData'], addTab )
				
				self.ANPlusOverPitch = self.ANPlusOverPitch || sndTab && sndTab['OverPitch'] && math.random( sndTab['OverPitch'][ 1 ], sndTab['OverPitch'][ 2 ] ) || nil
				self:SetSaveValue( "m_iName", data['Name'] )
				
				self.ANPlusIDName = IDCreate( data['Name'] )
				self:ANPlusApplyDataTab( data )					
				self:ANPlusUpdateWeaponProficency( self:IsNPC() && self:GetActiveWeapon() ) 

				timer.Simple( 0, function()
					if !IsValid(self) then return end
					if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCSpawn'] != nil then
						self:ANPlusGetDataTab()['Functions']['OnNPCSpawn'](self)		
					end	
				end)
				
				hook.Add( "Think", self, self.ANPlusNPCThink )
				hook.Add( "AcceptInput", self, self.ANPlusAcceptInput )
				self:AddCallback( "PhysicsCollide", self.ANPlusPhysicsCollide )

			end
	
		end
	
	else 
		return false
	end	
end	

function ENT:ANPlusAddAnimationEvent(seq, frame, ev) -- Sequence, target frame and animation event ID
	if(!self.m_tbAnimationFrames[seq]) then return end
	self.m_tbAnimEvents[seq] = self.m_tbAnimEvents[seq] || {}
	self.m_tbAnimEvents[seq][frame] = self.m_tbAnimEvents[seq][frame] || {}
	table.insert(self.m_tbAnimEvents[seq][frame],ev)
end

function ENT:ANPlusGetNextAttack()
	return self:GetInternalVariable( "m_flNextAttack" )
end

function ENT:ANPlusGetAttackDelay()
	return self:GetInternalVariable( "m_flShotDelay" )
end

function ENT:ANPlusSetNextAttack(val)
	return self:SetSaveValue( "m_flNextAttack", val )
end

function ENT:ANPlusSetAttackDelay(val)
	return self:SetSaveValue( "m_flShotDelay", val )
end

function ENT:ANPlusSetIK(bool)
	
	if IsValid(self) then
	
		net.Start("anplus_set_ik")
		net.WriteEntity(self)
		net.WriteBool(bool)
		net.Broadcast()
	
	end
	
end

function ENT:ANPlusUpdateWeaponProficency( wep )
	if IsValid(self) && IsValid(wep) && self:IsANPlus() && self:ANPlusGetDataTab()['WeaponProficiencyTab'] then
		local wepTab = self:ANPlusGetDataTab()['WeaponProficiencyTab'][ wep:GetClass() ] || self:ANPlusGetDataTab()['WeaponProficiencyTab'][ wep:GetHoldType() != "" && wep:GetHoldType() ] || self:ANPlusGetDataTab()['WeaponProficiencyTab'][ "Default" ]
		if wepTab then
			if wepTab['Proficiency'] then self:SetCurrentWeaponProficiency( wepTab['Proficiency'] ) end
			if wep:GetInternalVariable( "m_fMaxRange1" ) && wepTab['PrimaryMaxRange'] then wep:SetSaveValue( "m_fMaxRange1", wepTab['PrimaryMaxRange'] ) end
			if wep:GetInternalVariable( "m_fMaxRange2" ) && wepTab['SecondaryMaxRange'] then wep:SetSaveValue( "m_fMaxRange2", wepTab['SecondaryMaxRange'] ) end
			if wep:GetInternalVariable( "m_fMinRange1" ) && wepTab['PrimaryMinRange'] then wep:SetSaveValue( "m_fMinRange1", wepTab['PrimaryMinRange'] ) end
			if wep:GetInternalVariable( "m_fMinRange2" ) && wepTab['SecondaryMinRange'] then wep:SetSaveValue( "m_fMinRange2", wepTab['SecondaryMinRange'] ) end		
		end	
	end
end

function ENT:ANPlusDealDamage(target, dmginfo, cooldown, callback)
	
	if !IsValid(self) || !dmginfo then return end
	
	self.m_fANPDealtDamageLast = self.m_fANPDealtDamageLast || 0

	if cooldown && CurTime() - self.m_fANPDealtDamageLast < cooldown then return end
		
	if target:IsPlayer() && target:InVehicle() && IsValid(target:GetVehicle()) then
		target:GetVehicle():TakeDamageInfo( dmginfo )
	else
		target:TakeDamageInfo( dmginfo )
	end
	
	if isfunction( callback ) then
		callback(self, dmginfo)
	end
		
	self.m_fANPDealtDamageLast = CurTime()

end

function ENT:ANPlusDealBlastDamage(target, dmginfo, pos, radius, cooldown, callback) -- Kinda stupid.
	
	if !IsValid(self) || !dmginfo then return end
	
	self.anpdamage_DMGBlastLast = self.anpdamage_DMGBlastLast || 0

	if cooldown && CurTime() - self.anpdamage_DMGBlastLast < cooldown then return end
		
	util.BlastDamageInfo( dmginfo, pos, radius )
	local stuffIHit = ents.FindInSphere( pos, radius )
		
	for _, victim in pairs( stuffIHit ) do			
		if IsValid(victim) && self:Visible( victim ) && isfunction( callback ) then
			callback( self, victim, dmginfo )
		end			
	end
		
	self.anpdamage_DMGBlastLast = CurTime()

end

ANPlusNoMeleeWithThese = {
	['melee'] = true,
	['melee2'] = true,
	['fist'] = true,
	['knife'] = true
}
--[[
local posTarget = target:GetPos()
	local ang = self:GetAngles()	
	local aimDir = ( posTarget - self:GetPos() ):Angle()
	local pitch = math.Round( math.NormalizeAngle( ang.p - aimDir.p ) * 1000 ) / 1000	
	local yaw = math.Round( math.NormalizeAngle( ang.y - aimDir.y ) * 1000 ) / 1000	
	local roll = math.Round( math.NormalizeAngle( ang.r - aimDir.r ) * 1000 ) / 1000	
	local validAng = ( ( ( pitch <= ( full360.Pitch ) && pitch >= 0 ) || ( pitch <= 0 && pitch >= ( -full360.Pitch ) ) ) && ( ( yaw <= ( full360.Yaw ) && yaw >= 0 ) || ( yaw <= 0 && yaw >= ( -full360.Yaw ) ) ) && ( ( roll <= ( full360.Roll ) && roll >= 0 ) || ( roll <= 0 && roll >= ( -full360.Roll ) ) ) )
	
]]--
--[[
local full360 = {
	['Pitch'] 	= 70,
	['Yaw'] 	= 45,
	['Roll'] 	= 360,
}

--OR--

true for 360
]]--

function ENT:ANPlusDealMeleeDamage(dist, dmg, dmgt, viewpunch, force, full360, sndhit, sndmiss, callback)

	--local pos = self:ANPlusGetMeleePos( self )
	local pos = self:GetPos() + self:OBBCenter()
	local posSelf = self:GetPos()
	local center = posSelf + self:OBBCenter()
	local bHit
	
	if force then
		local forward,right,up = self:GetForward(),self:GetRight(),self:GetUp()
		force = forward * force.x + right * force.y + up * force.z
	end
	
	for _, ent in ipairs(ents.FindInSphere( pos, dist ) ) do
	
		if IsValid(ent) && IsValid(self:GetEnemy()) && self:GetEnemy() == ent && self:Visible(ent) && ent:ANPlusAlive() then
		
			local posTarget = ent:GetPos()
			local validAng = isbool( full360 ) || self:ANPlusValidAngles( posTarget, full360 )
			
			if validAng then
			
				bHit = true
				local posDmg = ent:NearestPoint(center)
				local dmginfo = DamageInfo()
				dmginfo:SetDamageType( dmgt )
				dmginfo:SetDamage( dmg )
				dmginfo:SetAttacker( self )
				dmginfo:SetInflictor( IsValid(self:GetActiveWeapon()) && self:GetActiveWeapon() || self )
				dmginfo:SetDamagePosition( posDmg )
				
				if force then dmginfo:SetDamageForce( force ) end
				
				if isfunction( callback ) then
					callback( ent, dmginfo )
				end
				
				ent:TakeDamageInfo( dmginfo )
				
				if viewpunch && ent:IsPlayer() then
				
					ent:ViewPunch(viewpunch)
					
				elseif ent:GetClass() == "npc_turret_floor" && ( ent:GetNPCState() != 7 || ent:GetNPCState() != 5 ) then
				
					ent:GetPhysicsObject():ApplyForceCenter(self:GetForward() * 10000 ) 
					
				end
			end
		end
	end
	if bHit && sndhit then
		self:EmitSound(sndhit)
	elseif !bHit && sndmiss then
		self:EmitSound(sndmiss)
	end
end

function ENT:ANPlusMeleeAct(target, act, speed, rspeed, dist, full360, cooldown, callback)
	
	if !IsValid(self) || !IsValid(target) || self:Health() <= 0 then return end	
	self.m_fANPMeleeLast = self.m_fANPMeleeLast || 0	
	self.m_fANPMeleeDelay = self.m_fANPMeleeDelay || cooldown || 0	
	
	if IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetHoldType() != "" && ANPlusNoMeleeWithThese[ self:GetActiveWeapon():GetHoldType() ] then return end

	local posTarget = target:GetPos()
	local validAng = isbool( full360 ) || self:ANPlusValidAngles( posTarget, full360 )
	
	if self:Visible( target ) && self:ANPlusInRange( target, dist ) && target:ANPlusAlive() && validAng && CurTime() - self.m_fANPMeleeLast > self.m_fANPMeleeDelay then
		
		self:ANPlusPlayActivity( act, speed, target, rspeed, function(seqID, seqDur)
			self.m_fANPMeleeDelay = self.m_fANPMeleeDelay == 0 && seqDur || self.m_fANPMeleeDelay
			if isfunction( callback ) then
				callback(seqID, seqDur)
			end	
			self.m_fANPMeleeLast = CurTime()
		end)
	end
end

function ENT:ANPlusRangeAct(target, act, speed, rspeed, distMax, distMin, full360, cooldown, callback) -- angMax/angMin if full360 is false or nil
	
	if !IsValid(self) || !IsValid(target) || self:Health() <= 0 then return end	
	self.m_fANPRangeLast = self.m_fANPRangeLast || 0	
	self.m_fANPRangeDelay = self.m_fANPRangeDelay || cooldown || 0	
	local posTarget = target:GetPos()
	local validAng = isbool( full360 ) || self:ANPlusValidAngles( posTarget, full360 )

	if self:Visible( target ) && self:ANPlusInRange( target, distMax ) && ( distMin && !self:ANPlusInRange( target, distMin ) ) && target:ANPlusAlive() && validAng && CurTime() - self.m_fANPRangeLast > self.m_fANPRangeDelay then
		
		self:ANPlusPlayActivity( act, speed, target, rspeed, function(seqID, seqDur)
			self.m_fANPRangeDelay = self.m_fANPRangeDelay == 0 && seqDur || self.m_fANPRangeDelay
			if isfunction( callback ) then
				callback(seqID, seqDur)
			end	
			self.m_fANPRangeLast = CurTime()
		end)
	end
end

function ENT:ANPlusFireEntity(entity, marksmanAiming, pos, ang, count, force, spread, delay, burstCount, burstReset, fireSND, distFireSND, entPreCallback, entPostCallback, callback)
	
	if !entity then return end

	self.m_fANPEntityLast = self.m_fANPEntityLast || 0
	self.m_fANPCurEntityBurst = self.m_fANPCurEntityBurst || burstCount
	if ( delay && CurTime() - self.m_fANPEntityLast >= delay ) && ( !burstCount || ( burstCount > 0 && self.m_fANPCurEntityBurst > 0 ) ) then
		local src, dir = nil
		if marksmanAiming && ( IsValid(self:GetEnemy()) || IsValid(self:GetTarget()) ) then			
			target = self:GetEnemy() || self:GetTarget()
			aimPos = target:ANPlusGetHitGroupBone( 1 ) || target:ANPlusGetHitGroupBone( 2 ) || target:ANPlusGetHitGroupBone( 3 ) || target:ANPlusGetHitGroupBone( 4 ) || target:ANPlusGetHitGroupBone( 5 ) || target:ANPlusGetHitGroupBone( 6 ) || target:ANPlusGetHitGroupBone( 7 ) || target:WorldSpaceCenter() || target:GetPos() 
			src, dir = self:ANPlusNPCGetImprovedAiming( pos, target, aimPos )
		end
		
		local projectiles = {}	

		local shootAngle = ( dir || self:GetAimVector() ):Angle()
		
		shootAngle.p = shootAngle.p + math.Rand( -spread, spread )
		shootAngle.y = shootAngle.y + math.Rand( -spread, spread )

		for i = 1, count do
			local ent = ents.Create( entity )	
			ent:SetPos( src || pos )
			ent:SetAngles( shootAngle + ( ang || Angle( 0, 0, 0 ) ) )
			ent:SetOwner( self )
			if isfunction( entPreCallback ) then			
				ent.m_cPreSpawnCB = entPreCallback
				ent:m_cPreSpawnCB( ent )			
			end
			ent:Spawn()		
			
			local phys = ent:GetPhysicsObject()				
			if phys:IsValid() then
				phys:SetVelocity( force && ent:GetForward() * force || Vector( 0, 0, 0 ) )
			else
				ent:SetVelocity( force && ent:GetForward() * force || Vector( 0, 0, 0 ) )
			end
			
			if isfunction( entPostCallback ) then			
				ent.m_cPostSpawnCB = entPostCallback
				ent:m_cPostSpawnCB( ent )			
			end
			
			for _, proj in pairs( projectiles ) do
				constraint.NoCollide( ent, proj, 0, 0 )
			end
			table.insert( projectiles, ent )		
		end
		
		if burstCount && burstCount > 0 then		
			self.m_fANPCurEntityBurst = self.m_fANPCurEntityBurst - 1
			timer.Create( "ANP_EntityBurstReset" .. self:EntIndex(), burstReset, 1, function()	
				if IsValid(self) then				
					self.m_fANPCurEntityBurst = burstCount || 0							
				end		
			end)		
		end
		
		if isfunction( callback ) then		
			local origin = self:GetOwner():GetShootPos()
			local vector = self:GetOwner():GetAimVector()		
			callback( origin, vector )			
		end
		
		if (SERVER) then
			if distFireSND then sound.Play( distFireSND, self:GetPos() ) end
			if fireSND then self:EmitSound( fireSND ) end
		end
		
		self.m_fANPEntityLast = CurTime()
	end
end

local ANPlusGrenadeScheduleBL = {
	[SCHED_RUN_FROM_ENEMY] = true,
	[SCHED_RUN_FROM_ENEMY_FALLBACK] = true,
	[SCHED_RUN_FROM_ENEMY_MOB] = true,
	[SCHED_TAKE_COVER_FROM_ENEMY] = true,
	[SCHED_TAKE_COVER_FROM_ORIGIN] = true,
	[SCHED_HIDE_AND_RELOAD] = true,
}

local ANPlusGrenadeScheduleWL = {
	[SCHED_TARGET_CHASE] = true,
	[SCHED_CHASE_ENEMY] = true,
	[SCHED_RANGE_ATTACK1] = true,
	[SCHED_RANGE_ATTACK2] = true,
}

function ENT:ANPlusGrenadeThrow(target, entity, anim, speed, bonename, throwdelay, forcemul, distmin, distmax, maxlastseen, cooldown, callback) -- Broken AF. Fix it you dummy.

	if !IsValid(self) || !IsValid(target) then return end

	self.anp_grenadeLast = self.anp_grenadeLast || 0
	self.anpGrenades = self.anpGrenades || 3
	
	if !self:ANPlusInRange( target, distmin ) && self:ANPlusInRange( target, distmax ) && self:ANPlusCantThrowHere() && self.anpGrenades > 0 then 
		
		--if !ANPlusInRangeVector( target:GetPos(), self:GetEnemyLastSeenPos( target ), 256 ) || !self:HasCondition( 13 ) then return end
	
		if CurTime() - self.anp_grenadeLast >= cooldown && ANPlusInRangeVector( target:GetPos(), self:GetEnemyLastSeenPos( target ), 256 ) && CurTime() - self:GetEnemyLastTimeSeen( target ) < maxlastseen then
			
			if ( self:Visible( target ) && !ANPlusGrenadeScheduleBL[ self:GetCurrentSchedule() ] ) || ( !self:Visible( target ) && ANPlusGrenadeScheduleWL[ self:GetCurrentSchedule() ] ) then
			
				self:ANPlusPlayActivity( anim, speed, target, 3 )
					
				timer.Simple( throwdelay, function()
				
					if !IsValid(self) || !IsValid(target) then return end
				
					if target:ANPlusAlive() then
				
						local targetPos = self:Visible( target ) && !ANPlusGrenadeScheduleBL[ self:GetCurrentSchedule() ] && self:GetEnemyLastSeenPos( target ) || target:OBBCenter()		
						local dist = ( targetPos - self:GetPos() ):Length()
						local distZ = ( targetPos - self:GetPos() ).z > 0 && ( targetPos - self:GetPos() ).z || 0
						local grenade = ents.Create( entity )
						local bone = self:LookupBone( bonename )
						local pos, ang = self:GetBonePosition( bone )

						if IsValid(grenade) then	
							grenade:SetPos( pos )
							grenade:SetAngles( self:GetAngles() )
							grenade:Spawn()
							grenade:Activate()
							grenade:SetOwner( self )
							
							if isfunction( callback ) then
								--[[
								grenade.anp_callbackgrenade = callback
								grenade:anp_callbackgrenade(grenade)
								]]--
								callback(grenade)
							end

							self.anpGrenades = self.anpGrenades - 1
							
							--local vel = ( targetPos - grenade:GetPos() ) + ( self:GetUp() * 300 + self:GetForward() * dist * 0.25 + self:GetRight() * math.Rand( -20, 20 ) )
							local vel = ( ( self:GetAimVector() * ( dist * 0.88 ) * ( forcemul || 1 ) ) + self:GetUp() * ( 250 + ( distZ * 0.80 ) ) * ( forcemul || 1 ) )
							local phys = grenade:GetPhysicsObject()

							if IsValid(phys) then
								
								phys:SetVelocity( vel )
								phys:AddAngleVelocity( Vector( math.random( -200, 200 ), math.random( -200, 200 ), math.random( -200, 200 ) ) )
	
							end

						end
				
					end
				
				end)
			
				self.anp_grenadeLast = CurTime()
			
				if self:GetSquad() != nil && self:GetSquad() != "" && ai.GetSquadMembers( self:GetSquad() ) then -- We don't want the enitre squad to throw grenades at once so we reset everyone else.
				
					for _, npc in ipairs( ai.GetSquadMembers( self:GetSquad() ) ) do
				
						if IsValid(npc) && npc:ANPlusAlive() then
					
							npc.anp_grenadeLast = CurTime()
					
						end
				
					end
		
				end
		
			end

		end

	end

end

function ENT:ANPlusPlayScriptedSequence(delay)	
	local delay = delay || 0
	if IsValid(self.anp_seq) then self.anp_seq:Fire( "BeginSequence", "", delay ) end		
end

function ENT:ANPlusCancelScriptedSequence(delay)	
	local delay = delay || 0
	if IsValid(self.anp_seq) then self.anp_seq:Fire( "CancelSequence", "", delay ) end		
end

function ENT:ANPlusGetScriptedSequence()	
	if IsValid(self.anp_seq) then 
		return self.anp_seq
	else
		return false
	end		
end

/*
local seqDataTab = {
	['Pos']				= nil, -- Will set self pos if nil
	['Ang']				= nil, -- Will set self angles if nil
	['Delay']			= 0, -- Delay before startrting scripted sequence, set to nil to spawn it but not start it and use ANPlusPlayScriptedSequence to do so.
	['PlayBackRate']	= 1, -- Animation playback rate.
	['SpawnFlags'] 		= 32 + 64, -- Spawnflags. https://developer.valvesoftware.com/wiki/Scripted_sequence  
	['KeyValues'] 		= {
		m_flRadius				= 1,
		m_iszIdle 				= nil, -- Pre Action Idle Animation -- The name of the sequence (such as "idle01") or activity (such as 'ACT_IDLE') to play before the action animation if the NPC must wait for the script to be triggered. Use "Start on Spawn" flag or "MoveToPosition" input to play this idle animation.
		m_iszEntry 				= nil, -- Entry Animation -- The name of the sequence (such as 'reload02') or activity (such as 'ACT_RELOAD') to play when the sequence starts, before transitioning to play the main action sequence.
		m_iszPlay				= nil, -- Action Animation -- The name of the main sequence (such as 'reload02') or activity (such as 'ACT_RELOAD') to play.
		m_iszPostIdle 			= nil, -- Post Action Idle Animation -- The name of the sequence (such as 'idle01') or activity (such as 'ACT_IDLE') to play after the action animation.
		m_iszCustomMove 		= "", -- Custom Move Animation -- Used in conjunction with the 'Custom movement' setting for the 'Move to Position' property, specifies the sequence (such as 'crouch_run01') or activity (such as 'ACT_RUN') to use while moving to the scripted position.
		m_bSynchPostIdles 		= 1, -- Synch Post Idles 
		m_bLoopActionSequence	= 0, -- Loop Action Animation
		m_flRepeat				= 0, -- Repeat Rate ms -- How long NPC will repeat "Action Animation". See "Action Animation". Useless with "Loop Action Animation?"
		m_fMoveTo				= 4, -- Move to Position -- How the NPC will walk to this scripted_sequence.
		m_bIgnoreGravity 		= 0, -- Ignore Gravity on NPC during Script -- If this is set to 'Yes', the NPC will not be subject to gravity while playing this script.
		m_bDisableNPCCollisions = 0, -- Disable NPC collisions during Script -- Useful for when NPCs playing scripts must interpenetrate while riding on trains, elevators, etc. This only disables collisions between the NPCs in the script and must be enabled on BOTH scripted_sequences.
		onplayerdeath 			= 0, -- On Player death -- If set, NPC will cancel script and return to AI.
	}
}
self:ANPlusCreateScriptedSequence(seqDataTab)
*/

function ENT:ANPlusCreateScriptedSequence(seqDataTab)
	
	if !IsValid(self) || !self:ANPlusAlive() then return end
	if IsValid(self.anp_seq) then self.anp_seq:Remove() end
	if !seqDataTab then return end
	self:SetNPCState(4)
	self.anp_seq = ents.Create( "scripted_sequence" )
	self.anp_seq:SetName( self:GetInternalVariable( "m_iName" ) .. self.anp_seq:EntIndex() )
	self.anp_seq:SetKeyValue( "spawnflags", ( seqDataTab['SpawnFlags'] || 0 ) )
	self.anp_seq:SetKeyValue( "m_iszEntity", self:GetInternalVariable( "m_iName" ) )		
	for _, v in pairs( seqDataTab['KeyValues'] ) do	
		if seqDataTab['KeyValues'].m_flRadius && seqDataTab['KeyValues'].m_flRadius < 1 then seqDataTab['KeyValues'].m_flRadius = 1 end
		self.anp_seq:SetKeyValue( tostring( _ ), v )				
	end		
	self.anp_seq:SetPos( seqDataTab['Pos'] || self:GetPos() )
	self.anp_seq:SetAngles( seqDataTab['Ang'] || self:GetAngles() )
	self.anp_seq:SetOwner( self )
	self.anp_seq:Spawn()
	self.anp_seq:Activate()
	self.anp_seq:SetSaveValue( "m_interruptable", false )
	if seqDataTab['Delay'] then self.anp_seq:Fire( "BeginSequence", "", seqDataTab['Delay'] ) end
	--self.anp_seq:Fire( "AddOutput", "OnEndSequence "..self:GetInternalVariable( "m_iName" ) .. self.anp_seq:EntIndex()..":Kill", 0 )
	self:DeleteOnRemove( self.anp_seq )
	
	timer.Create( "ANP_ACT_SS_PLAYBACKRATE" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || self:GetNPCState() != 4 then return false end
		self:SetPlaybackRate( seqDataTab['PlayBackRate'] || 1 ) 
	end)
	
end

function ENT:ANPlusGetFollowTarget()
	return self.anp_fTarget
end

local function NPCGiveWay(ent)	
	if !IsValid(ent) then return end
	local colBmin, colBmax = ent:GetCollisionBounds()
	local tr = util.TraceHull{
	start = ent:GetPos(),
	endpos = ent:GetPos(),
	filter = {ent, ent:GetActiveWeapon()},
	mins = colBmin * 1.05,
	maxs = colBmax * 1.05
	}
	local target = tr.Entity
	
	if tr.Hit && IsValid(target) && target == ent:ANPlusGetFollowTarget() && ent:GetCurrentSchedule() != SCHED_MOVE_AWAY then 
		ent:SetSchedule(SCHED_MOVE_AWAY)
	end
end

function ENT:ANPlusFollowTarget(target, followdist, followrundist, followcombatdist, followcombatrundist)
	
	local timerName = "ANP_NPC_FollowBeh" .. self:EntIndex()
	if !IsValid(target) then 
	
		if self:IsANPlus() && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCFollow'] != nil then
			self:ANPlusGetDataTab()['Functions']['OnNPCFollow'](self, self.anp_fTarget, false)	
		end
		timer.Remove( timerName )
		self.anp_fTarget = nil 
		return 
	end	
	
	if ( ( target:IsNPC() || target:IsPlayer() ) && self:Disposition( target ) != D_LI ) then print(self, " doesn't like ", target, " therefore it won't follow it." ) return end
	local followdist = followdist || 200
	local followcombatdist = followcombatdist || 400
	if self:GetClass() == "npc_citizen" then self:Fire( "RemoveFromPlayerSquad", "", 0.1 ) end
	self.anp_fTarget = target
	self:SetTarget(target)
	if self:IsANPlus() && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCFollow'] != nil then
		self:ANPlusGetDataTab()['Functions']['OnNPCFollow'](self, self.anp_fTarget, true)	
	end
	
	timer.Create( timerName, 0.5, 0, function()
		if !IsValid(self) || !IsValid(self.anp_fTarget) || !self.anp_fTarget:ANPlusAlive() || ( ( self.anp_fTarget:IsNPC() || self.anp_fTarget:IsPlayer() ) && self:Disposition( self.anp_fTarget ) != D_LI ) then 
			if IsValid(self) then			
				if IsValid(self.anp_fTarget) then
					if self.anp_fTarget:IsPlayer() && self:Disposition( self.anp_fTarget ) != D_LI then ANPlusMSGPlayer( self.anp_fTarget, self:GetName() .. " is no longer following you because it doens't like you anymore.", Color( 255, 200, 0 ), "ANP.UI.Error" ) end			
					
					if self:IsANPlus() && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCFollow'] != nil then
						self:ANPlusGetDataTab()['Functions']['OnNPCFollow'](self, self.anp_fTarget, false)	
					end	
					
				end
				self.anp_fTarget = nil 
			end
			timer.Remove( timerName )
			return 
		end
		
		if ( self.anp_fTarget:IsPlayer() && GetConVar( "ai_ignoreplayers" ):GetBool() ) || GetConVar( "ai_disabled" ):GetBool() || !self.anp_fTarget:OnGround() then return end
		local posSelf = self:GetPos()
		local posTarget = self.anp_fTarget:GetPos()
		local schWalk = SCHED_FORCED_GO
		local schRun = SCHED_FORCED_GO_RUN
		local curSchWalk = self:IsCurrentSchedule( schWalk )
		local curSchRun = self:IsCurrentSchedule( schRun )
		local curDist = math.max( posSelf:Distance( posTarget ) - ( self:OBBMaxs().x + self.anp_fTarget:OBBMaxs().x ), 0 )
		if !IsValid(self:GetEnemy()) then		
			if curDist > followdist then self:NavSetGoalTarget( self.anp_fTarget, Vector( 0, 0, 0 ) ) end	
			if curDist < followdist && ( curSchWalk || curSchRun ) then
				self:ClearSchedule()
				self:ClearGoal()
				self:StopMoving()		
			elseif curDist >= followdist && curDist < followrundist && !curSchWalk then	
				self:SetLastPosition( posTarget )
				self:SetSchedule( schWalk )
				--self:RunEngineTask( ai.GetTaskID( "TASK_GET_PATH_TO_GOAL" ), 0 )
				--self:RunEngineTask( ai.GetTaskID( "TASK_WAIT_FOR_MOVEMENT" ), 0 )
				--self:RunEngineTask( ai.GetTaskID( "TASK_FACE_TARGET" ), 1 )
				--self:RunEngineTask( ai.GetTaskID( "TASK_WALK_PATH" ), 0 )	
			elseif curDist >= followrundist && !curSchRun then	
				self:SetLastPosition( posTarget )
				self:SetSchedule( schRun )
				--self:RunEngineTask( ai.GetTaskID( "TASK_GET_PATH_TO_GOAL" ), 0 )
				--self:RunEngineTask( ai.GetTaskID( "TASK_WAIT_FOR_MOVEMENT" ), 0 )
				--self:RunEngineTask( ai.GetTaskID( "TASK_FACE_TARGET" ), 1 )
				---self:RunEngineTask( ai.GetTaskID( "TASK_RUN_PATH" ), 0 )
			end			
		elseif IsValid(self:GetEnemy()) && IsValid(self:GetActiveWeapon()) && !ANPlusNoMeleeWithThese[ self:GetActiveWeapon():GetHoldType() ] then	
			if curDist < followcombatdist && ( curSchWalk || curSchRun ) then
				self:ClearSchedule()
				self:ClearGoal()
				self:StopMoving()
			elseif curDist >= followcombatdist && curDist < followcombatrundist && !curSchWalk then
				self:SetLastPosition( posTarget )
				self:SetSchedule( schWalk )				
			elseif curDist >= followcombatrundist && !curSchRun then
				self:SetLastPosition( posTarget )
				self:SetSchedule( schRun )
			end		
		end	
		
		NPCGiveWay( self )
		
		if self.anp_fTarget:IsPlayer() && ( self:HasCondition( 35 ) || !self:HasCondition( 49 ) ) && !self.anp_fTarget:Visible( self ) && !self:Visible( self.anp_fTarget ) then
			local getNodeType = self:GetNavType() == 2 && #ANPlusAIGetAirNodes() > 0 && 3 || 2
			local node, dist = ANPlusAIFindClosestNode( posTarget, getNodeType )
			if node && !ANPlusAINodeOccupied( node['pos'] ) && !ANPIsAnyoneLookingAtPos( self, {self.anp_fTarget}, node['pos'] ) then
				self:SetPos( node['pos'] + Vector( 0, 0, 10 ) )
			end
		end
		
	end)
end

function ENT:ANPlusNPCGo( vecORent, walkORrun, vecOffset )
	local posTarget = IsEntity( vecORent ) && vecORent:GetPos() || vecORent
	local schWalk = SCHED_FORCED_GO
	local schRun = SCHED_FORCED_GO_RUN
	local curSchWalk = self:IsCurrentSchedule( schWalk )
	local curSchRun = self:IsCurrentSchedule( schRun )
	if IsEntity( vecORent ) then
		self:NavSetGoalTarget( vecORent, vecOffset || Vector( 0, 0, 0 ) )
	else
		self:NavSetGoalPos( posTarget )
	end
	
	if walkORrun == 1 && !curSchWalk then
		self:SetLastPosition( posTarget )
		self:SetSchedule( schWalk )	
	elseif walkORrun == 2 && !curSchRun then
		self:SetLastPosition( posTarget )
		self:SetSchedule( schRun )	
	end
end

function ENT:ANPlusFollowPlayer(ply, followdist, followrundist, followcombatdist, followcombatrundist)
	if self:Disposition( ply ) != D_LI then
		ANPlusMSGPlayer( ply, self:GetName() .. " doesn't like you, therefore it won't follow you.", Color( 255, 50, 0 ), "ANP.UI.Error" )
	elseif !IsValid(self:ANPlusGetFollowTarget()) || ( IsValid(self:ANPlusGetFollowTarget()) && !self:ANPlusGetFollowTarget():IsPlayer() ) || self:ANPlusGetFollowTarget() != ply then
		self:ANPlusFollowTarget( ply, followdist, followrundist, followcombatdist, followcombatrundist )
		ANPlusMSGPlayer( ply, self:GetName() .. " is following you now.", Color( 50, 255, 0 ), "ANP.UI.Click" )
	elseif IsValid(self:ANPlusGetFollowTarget()) && self:ANPlusGetFollowTarget() == ply then
		self:ANPlusFollowTarget()
		ANPlusMSGPlayer( ply, self:GetName() .. " is no longer following you.", Color( 255, 200, 0 ), "ANP.UI.Error" )
	else
		ANPlusMSGPlayer( ply, self:GetName() .. " is following someone else.", Color( 255, 50, 0 ), "ANP.UI.Error" )
	end	
end

function ENT:ANPlusFaceEntity( ent, speed )
	if !IsValid(ent) then return end
		local angleFace = Angle( 0, ( ent:GetPos() - self:GetPos() ):Angle().y, 0 )
	if !speed || speed == 0 then
		self:SetAngles( angleFace )
	else
		self:SetAngles( LerpAngle( FrameTime() * speed, self:GetAngles(), angleFace ) )
	end
end

function ENT:ANPlusPlayActivity(act, speed, faceent, facespeed, callback, postcallback)
	if self:IsNPC() && ( self:GetNPCState() == 6 || self:GetNPCState() == 7 ) then return end
	local actSeq = self:SelectWeightedSequence( act )
	local speed = speed || 1
	local facespeed = facespeed || 0
	self:StopMoving()
	self:SetCondition( 67 )
	self:ClearCondition( 68 )
	self:SetKeyValue( "sleepstate", 2 )
	self:ResetSequenceInfo()
	self:ResetSequence( actSeq )	
	self:ResetIdealActivity( act )
	self:SetIdealActivity( act )
	--self:StartEngineTask( ai.GetTaskID( "TASK_PLAY_SCRIPT" ), act )
	self.m_bANPlusPlayingActivity = true
	local seqID, seqDur = self:LookupSequence( self:GetSequenceName( actSeq ) )	
	seqDur = seqDur / speed
	if isfunction( callback ) then
		callback( seqID, seqDur )
	end
self.m_fLastCycle = 0
	timer.Create( "ANP_ACT_RESET" .. self:EntIndex(), seqDur, 1, function() 
		if !IsValid(self) then return end	
		self.m_bANPlusPlayingActivity = false
		self:SetCondition( 68 )
		self:ClearCondition( 67 )
		self:SetKeyValue( "sleepstate", 0 )
		self:StartEngineTask( ai.GetTaskID( "TASK_RESET_ACTIVITY" ), 0 )
		if isfunction( postcallback ) then
			postcallback( seqID, seqDur )
		end
	end)

	timer.Create( "ANP_ACT_PLAYBACKRATE" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self.m_bANPlusPlayingActivity then return end
		self:MaintainActivity()
		self:SetPlaybackRate( speed ) 
		if IsValid(faceent) && facespeed >= 0 then 
			self:ANPlusFaceEntity( faceent, facespeed )
		end
	end)
	
end
--[[
function ENT:ANPlusPlaySequence(seq, speed, faceent, facespeed, callback, postcallback)

	self:StartEngineTask( ai.GetTaskID( "TASK_RESET_ACTIVITY" ), 0 )
	local seqID, seqDur = self:LookupSequence( isnumber( seq ) && self:GetSequenceName( seq ) || seq )
	local speed = speed || 1
	local facespeed = facespeed || 0
	self:StopMoving()
	self:SetCondition( 67 )
	self:ClearCondition( 68 )
	self:ResetSequenceInfo()
	self:ResetSequence( seqID )	
	self:SetCycle( 0 )	
	self:ANPlusSetIdealSequence( seqID )
	--self:StartEngineTask( ai.GetTaskID( "TASK_PLAY_SCRIPT" ), act )
	self.m_bANPlusPlayingActivity = true
		
	seqDur = seqDur / speed
	if isfunction( callback ) then
		callback( seqID, seqDur )
	end
self.m_fLastCycle = 0
	timer.Create( "ANP_SEQ_RESET" .. self:EntIndex(), seqDur, 1, function() 
		if !IsValid(self) then return end	
		self.m_bANPlusPlayingActivity = false
		self:SetCondition( 68 )
		self:ClearCondition( 67 )
		self:StartEngineTask( ai.GetTaskID( "TASK_RESET_ACTIVITY" ), 0 )
		if isfunction( postcallback ) then
			postcallback( seqID, seqDur )
		end
	end)

	timer.Create( "ANP_SEQ_PLAYBACKRATE" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self.m_bANPlusPlayingActivity then return end
		--local lastCycle = self:GetCycle()
		--if !self:IsCurrentSchedule( SCHED_NPC_FREEZE ) then self:SetSchedule( SCHED_NPC_FREEZE ); self:SetIdealActivity( act ); self:SetCycle(self.m_fLastCycle) end
		--self.m_fLastCycle = lastCycle
		self:MaintainActivity()
		self:SetPlaybackRate( speed ) 
		if IsValid(faceent) && facespeed >= 0 then 
			self:ANPlusFaceEntity( faceent, facespeed )
		end
	end)
	
end
]]--
function ENT:ANPlusDoDeathAnim(dmginfo, act, speed, atHPLevel, dmgMin, dmgMax, chance, interruptible, precallback, postcallback)
	local att = dmginfo:GetAttacker()
	local inf = dmginfo:GetInflictor()
	local dmg = dmginfo:GetDamage()
	local dmgt = dmginfo:GetDamageType()
	local atHPLevel = atHPLevel || 1
	local targethp = math.Approach( self:Health(), atHPLevel, dmg ) == atHPLevel
	if act && ( !dmgMin || ( dmgMin && dmg >= dmgMin ) ) && ( !dmgMax || ( dmgMax && dmg <= dmgMax ) ) && targethp && !self.m_bDeathAnimPlay && ANPlusPercentageChance( chance ) then
		self.m_bDeathAnimPlay = true
		if isfunction( precallback ) then
			precallback( self )
		end
		local lastDMGinfo = {
			['att'] = att,
			['inf'] = inf,
			['dmg'] = dmg,
			['dmgt'] = dmgt,
		}
		if !interruptible then self.m_bNPCNoDamage = true end
		self:CapabilitiesClear() -- We don't care if NPC turns into a vegetable, it will die anyways.
		self:TaskComplete()
		self:ClearGoal()
		dmginfo:SetDamage( 0 )
		self:SetHealth( 1 )
		--self:SetNPCState( 6 )
		self:ANPlusPlayActivity( act, speed, nil, nil, nil, function()
			self.m_bNPCNoDamage = false
			if isfunction( postcallback ) then
				postcallback( self, lastDMGinfo )
			end
			--self:SetSchedule( SCHED_IDLE_STAND )
			local newDMGinfo = DamageInfo()
			newDMGinfo:SetAttacker( IsValid(lastDMGinfo.att) && lastDMGinfo.att || self )
			newDMGinfo:SetInflictor( IsValid(lastDMGinfo.inf) && lastDMGinfo.inf || self )
			newDMGinfo:SetDamage( 1 )
			self:TakeDamageInfo( newDMGinfo )
			self:SetHealth( 0 )
		end)
	end
end

function ENT:ANPlusGetSquadMembers(callback)
	if self:GetSquad() != nil && self:GetSquad() != "" then 		
		for i = 1, #ai.GetSquadMembers( self:GetSquad() ) do				
			local npc = ai.GetSquadMembers( self:GetSquad() )[ i ]				
			if IsValid(npc) && npc:ANPlusAlive() && npc != self then					
				if isfunction( callback ) then
					callback( npc )
				end
			end			
		end	
		return ai.GetSquadMembers( self:GetSquad() )		
	end
end
-- Half-Life:Source squad system is busted af, need to make my own.
function ENT:ANPlusAddToCSquad(squad)
	if !ANPCustomSquads[squad] then ANPCustomSquads[squad] = {} end
	ANPlusTableDeNull( ANPCustomSquads[squad] ) -- Remove NULL NPCs
	if !table.HasValue( ANPCustomSquads[squad], self ) then
		table.insert( ANPCustomSquads[squad], self )
		if !ANPCustomSquads[squad]['leader'] then ANPCustomSquads[squad]['leader'] = self end
		self.m_tbANPCSquad = ANPCustomSquads[squad] 
	end
end

function ENT:ANPlusCSquadGetLeader(squad)
	if squad && ANPCustomSquads[squad] then
		return ANPCustomSquads[squad]['leader']
	elseif !squad then	
		if self:ANPlusGetCSquad() then return self:ANPlusGetCSquad()['leader'] end
	end
end

function ENT:ANPlusGetCSquad()
	for k, v in pairs( ANPCustomSquads ) do
		if v && table.HasValue( v, self ) then return v end
	end
end

function ENT:ANPlusGetCSquadMembers(callback)
	if self.m_tbANPCSquad != nil then 		
		for i = 1, self:ANPlusGetCSquad() && #self:ANPlusGetCSquad() || 0 do				
			local npc = self:ANPlusGetCSquad()[ i ]				
			if IsValid(npc) && npc:ANPlusAlive() && npc != self then					
				if isfunction( callback ) then
					callback( npc, i )
				end
			end			
		end		
		return self:ANPlusGetCSquad()		
	end
end

function ENT:ANPlusRemoveFromCSquad(squad)
	if ANPCustomSquads[squad] && table.HasValue( ANPCustomSquads[squad], self ) then table.RemoveByValue( ANPCustomSquads[squad], self ) end
end

function ENT:SetIdealMoveSpeed(val)
	self:SetSaveValue( "m_flGroundSpeed", val )
end

function ENT:ANPlusClearTarget()
	self:SetSaveValue( "m_hTargetEnt", NULL )
end

function ENT:ANPlusOverrideMoveSpeed(speed, rate)	
	if speed != 1 && ( ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 1 ) && self:OnGround() ) || ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 4 ) ) || ( self:GetMoveType() == 6 ) ) && self:IsMoving() && self:GetMinMoveStopDist() > 10 then			
		if speed > 1 && ( self:GetVelocity():Length() <= self:GetIdealMoveSpeed() * speed ) then
			self:SetVelocity( self:GetGroundSpeedVelocity() * speed ) 		
		elseif speed < 1 then		
			self:SetMoveVelocity( self:GetGroundSpeedVelocity() * speed ) 
		end					
	end	
	if rate != 1 then self:SetPlaybackRate( rate ) end
end

function ENT:ANPlusReplaceActOther(act, speed, actRep)	
	if actRep && self:GetActivity() == act then
		
		local newACT = ( istable(actRep) && actRep[ 1 ] && actRep[ math.random( 1, #actRep ) ] ) || actRep
		local aTab2 = 
			
		self:ResetIdealActivity( newACT )

		timer.Create( "ANP_ACT_OTHER_REPLACE" .. self:EntIndex(), 0, 0, function() 
			if !IsValid(self) || self:GetActivity() != act then return end
			self:SetPlaybackRate( speed || 1 ) 
		end)
		
	end
end

function ENT:ANPlusGetEnemies()

	local entsAround = ents.GetAll()
	local entsSelected = {}
	local count = 1

	for i = 1, #entsAround do
	
		if !entsAround[ i ]:IsNPC() && !entsAround[ i ]:IsPlayer() then continue end
		
		local v = entsAround[ i ]
		
		if ( v:IsNPC() && v != self && v:Disposition( self ) != D_LI && v:Disposition( self ) != D_NU && v:ANPlusAlive() ) || ( v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) then
			
			entsSelected[count] = v
			count = count + 1

		end
		
	end

	return entsSelected
	
end