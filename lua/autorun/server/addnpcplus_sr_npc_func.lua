------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local ENT = FindMetaTable("Entity")
local ZERO_VEC = Vector( 0, 0, 0 )

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

function ENT:ANPlusUpdateWeaponProficency( wep, dataTab )
	dataTab = self:ANPlusGetDataTab() && self:ANPlusGetDataTab()['WeaponProficiencyTab'] || dataTab
	if IsValid(self) && IsValid(wep) && dataTab then
		local wepTab = dataTab[ wep:GetClass() ] || dataTab[ wep:GetHoldType() != "" && wep:GetHoldType() ] || dataTab['Default']
		if wepTab then
			if wepTab['Proficiency'] then self:SetCurrentWeaponProficiency( wepTab['Proficiency'] ) end
			if wep:GetInternalVariable( "m_fMaxRange1" ) && wepTab['PrimaryMaxRange'] then wep:SetSaveValue( "m_fMaxRange1", wepTab['PrimaryMaxRange'] ) end
			if wep:GetInternalVariable( "m_fMaxRange2" ) && wepTab['SecondaryMaxRange'] then wep:SetSaveValue( "m_fMaxRange2", wepTab['SecondaryMaxRange'] ) end
			if wep:GetInternalVariable( "m_fMinRange1" ) && wepTab['PrimaryMinRange'] then wep:SetSaveValue( "m_fMinRange1", wepTab['PrimaryMinRange'] ) end
			if wep:GetInternalVariable( "m_fMinRange2" ) && wepTab['SecondaryMinRange'] then wep:SetSaveValue( "m_fMinRange2", wepTab['SecondaryMinRange'] ) end		
		end	
	end
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
	['Pitch'] 	= { 70, -70 },
	['Yaw'] 	= { 45, -45 },
	['Roll'] 	= { 180, -180 },
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
	
	for _, ent in ipairs( ents.FindInSphere( pos, dist ) ) do
	
		if IsValid(ent) && IsValid(self:GetEnemy()) && self:GetEnemy() == ent && self:Visible(ent) && ent:ANPlusAlive() then
		
			local posTarget = ent:GetPos()
			local validAng = isbool( full360 ) || self:ANPlusValidAnglesNormal( posTarget, full360 )
			
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

function ENT:ANPlusMeleeAct(target, act, speed, movementVel, rspeed, dist, full360, cooldown, callback)
	
	if !IsValid(self) || !IsValid(target) || self:Health() <= 0 then return end	
	self.m_fANPMeleeLast = self.m_fANPMeleeLast || 0	
	self.m_fANPMeleeDelay = self.m_fANPMeleeDelay || cooldown || 0	
	
	if IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetHoldType() != "" && ANPlusNoMeleeWithThese[ self:GetActiveWeapon():GetHoldType() ] then return end

	local posTarget = target:GetPos()
	local validAng = isbool( full360 ) || self:ANPlusValidAnglesNormal( posTarget, full360 )
	
	if self:Visible( target ) && self:ANPlusInRange( target, dist ) && target:ANPlusAlive() && validAng && CurTime() - self.m_fANPMeleeLast > self.m_fANPMeleeDelay then
		
		self:ANPlusPlayActivity( act, speed, movementVel, target, rspeed, function(seqID, seqDur)
			self.m_fANPMeleeDelay = self.m_fANPMeleeDelay == 0 && seqDur || self.m_fANPMeleeDelay
			if isfunction( callback ) then
				callback(seqID, seqDur)
			end	
			self.m_fANPMeleeLast = CurTime()
		end)
	end
end

function ENT:ANPlusRangeAct(target, act, speed, movementVel, rspeed, distMax, distMin, full360, cooldown, callback) -- angMax/angMin if full360 is false or nil
	
	if !IsValid(self) || !IsValid(target) || self:Health() <= 0 then return end	
	self.m_fANPRangeLast = self.m_fANPRangeLast || 0	
	self.m_fANPRangeDelay = self.m_fANPRangeDelay || cooldown || 0	
	local posTarget = target:GetPos()
	local validAng = isbool( full360 ) || self:ANPlusValidAnglesNormal( posTarget, full360 )

	if self:Visible( target ) && self:ANPlusInRange( target, distMax ) && ( distMin && !self:ANPlusInRange( target, distMin ) ) && target:ANPlusAlive() && validAng && CurTime() - self.m_fANPRangeLast > self.m_fANPRangeDelay then
		
		self:ANPlusPlayActivity( act, speed, movementVel, target, rspeed, function(seqID, seqDur)
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

function ENT:ANPlusGrenadeThrow(target, entity, act, speed, movementVel, bonename, throwdelay, forcemul, distmin, distmax, maxlastseen, cooldown, callback) -- Broken AF. Fix it you dummy.

	if !IsValid(self) || !IsValid(target) then return end

	self.anp_grenadeLast = self.anp_grenadeLast || 0
	self.anpGrenades = self.anpGrenades || 3
	
	if !self:ANPlusInRange( target, distmin ) && self:ANPlusInRange( target, distmax ) && self:ANPlusCantThrowHere() && self.anpGrenades > 0 then 
		
		--if !ANPlusInRangeVector( target:GetPos(), self:GetEnemyLastSeenPos( target ), 256 ) || !self:HasCondition( 13 ) then return end
	
		if CurTime() - self.anp_grenadeLast >= cooldown && ANPlusInRangeVector( target:GetPos(), self:GetEnemyLastSeenPos( target ), 256 ) && CurTime() - self:GetEnemyLastTimeSeen( target ) < maxlastseen then
			
			if ( self:Visible( target ) && !ANPlusGrenadeScheduleBL[ self:GetCurrentSchedule() ] ) || ( !self:Visible( target ) && ANPlusGrenadeScheduleWL[ self:GetCurrentSchedule() ] ) then
			
				self:ANPlusPlayActivity( act, speed, movementVel, target, 3 )
					
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
	local ss = IsValid(self:GetInternalVariable( "m_hCine" )) && self:GetInternalVariable( "m_hCine" ) || IsValid(self.m_pScriptedSequence) && self.m_pScriptedSequence || nil
	if ss then ss:Fire( "BeginSequence", "", delay ) end		
end

function ENT:ANPlusCancelScriptedSequence(delay)	
	local delay = delay || 0
	local ss = IsValid(self:GetInternalVariable( "m_hCine" )) && self:GetInternalVariable( "m_hCine" ) || IsValid(self.m_pScriptedSequence) && self.m_pScriptedSequence || nil
	if ss then self:GetInternalVariable( "m_hCine" ):Fire( "CancelSequence", "", delay ) end		
end

function ENT:ANPlusGetScriptedSequence()	
	return IsValid(self:GetInternalVariable( "m_hCine" )) && self:GetInternalVariable( "m_hCine" ) || IsValid(self.m_pScriptedSequence) && self.m_pScriptedSequence || false
end

/*
local seqDataTab = {
	['Pos']				= nil, -- Will set self pos if nil
	['Ang']				= nil, -- Will set self angles if nil
	['Parent']			= false,
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

function ENT:ANPlusCreateScriptedSequence(seqDataTab, faceEnt, faceSpeed)
	
	if !IsValid(self) || !self:ANPlusAlive() then return end
	--if IsValid(self.m_pScriptedSequence) then self.m_pScriptedSequence:Remove() end
	if !seqDataTab then return end
	
	self.m_pScriptedSequence = ents.Create( "scripted_sequence" )	
	local ssName = self:ANPlusGetName() .. "_ScriptedSequence_" .. self.m_pScriptedSequence:EntIndex()	
	self.m_pScriptedSequence:SetName( ssName )
	self.m_pScriptedSequence:SetKeyValue( "spawnflags", ( seqDataTab['SpawnFlags'] || 0 ) )
		
	self.m_pScriptedSequence:SetSaveValue( "m_hForcedTarget", self ) -- No need for new names :D
	
	for _, v in pairs( seqDataTab['KeyValues'] ) do	
		if seqDataTab['KeyValues'].m_flRadius && seqDataTab['KeyValues'].m_flRadius < 1 then seqDataTab['KeyValues'].m_flRadius = 1 end
		self.m_pScriptedSequence:SetKeyValue( tostring( _ ), v )				
	end		
	
	self.m_pScriptedSequence:SetPos( seqDataTab['Pos'] || self:GetPos() )
	self.m_pScriptedSequence:SetAngles( seqDataTab['Ang'] || self:GetAngles() )
	if seqDataTab['Parent'] then self.m_pScriptedSequence:SetParent( self )	end
	self.m_pScriptedSequence:SetOwner( self )
	self.m_pScriptedSequence:Spawn()
	self.m_pScriptedSequence:Activate()
	self.m_pScriptedSequence:SetSaveValue( "m_interruptable", false )
	self.m_pScriptedSequence.Speed = seqDataTab['PlayBackRate']
	
	if seqDataTab['Delay'] then self.m_pScriptedSequence:Fire( "BeginSequence", "", seqDataTab['Delay'] ) end
	self:DeleteOnRemove( self.m_pScriptedSequence )
	
	self.m_pScriptedSequence:ANPlusCreateOutputHook( "OnBeginSequence", "ANPlusScriptedSequenceStart" )
	self.m_pScriptedSequence:ANPlusCreateOutputHook( "OnEndSequence", "ANPlusScriptedSequenceEnd" )
	--[[
	local callback = callback
	local postCallback = postCallback

	if isfunction( callback ) then hook.Add( "ANPlusScriptedSequenceStart", self.m_pScriptedSequence, callback() ) end
	if isfunction( postCallback ) then hook.Add( "ANPlusScriptedSequenceEnd", self.m_pScriptedSequence, postCallback() ) end
	]]--
	timer.Create( "ANP_SS_PLAYBACKRATE" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self:IsCurrentSchedule( SCHED_AISCRIPT ) then return end
		self:ANPlusSetNextFlinch( 1 ) -- Don't flinch during SS
		self:MaintainActivity()
		self:SetPlaybackRate( seqDataTab['PlayBackRate'] || 1 ) 
		if IsValid(faceEnt) && faceSpeed >= 0 then 
			self:ANPlusFaceEntity( faceEnt, faceSpeed )
		end
	end)
	
end

/*
local abTab = {
	['Name']				= "CoolName", -- Will set self pos if nil
	['KeyValues'] 		= {
		busysearchrange				= 100, -- Maximum distance between an actbusy hint and NPC for the NPC to consider it.
		visibleonly					= 1, -- If set, an NPC will only consider actbusy hints in view when deciding which to use. Once the choice has been made it will not change, even if new hints become visible.
		type						= 0, -- Is this Actbusy part of combat? For use with Combat Safe Zone. 0: Default (Standard) 1: Combat
		alllowteleport				= 0, -- Allow actor to teleport?
		seeentity					= nil, -- Optionally, if the Actor playing the ActBusy loses sight of this specified entity for an amount of time defined by Sight Entity Timeout, the specified entity will leave the ActBusy.  Note: 	Only targetnames are allowed, not classnames!
		seeentitytimeout			= 10, -- Time in seconds to wait for an Actor to see the Sight Entity again before the entity may leave the ActBusy.
		sightmethod					= 0, -- How to determine if the Actor sees the Sight Entity. 0: Default. LOS -and- Viewcone. 1: LOS Only. Disregard Viewcone.
		safezone					= nil, -- Specify a brush entity to act as a safe zone if Actbusy Type is set to Combat. If any enemies are in the safe zone, the actbusy will break. To do: Will actors go back to the actbusy once enemies are dead? What if they leave the safe zone but are still alive?
		actor						= nil, -- The targetname or classname of any NPCs that will be included in this goal. Wildcards are supported.
		SearchType					= 1, -- What the Actor(s) to affect keyvalue targets by. 0: Entity Name 1: Classname
		StartActive					= 1, -- Set if goal should be active immediately.
	}
}
ANPlusCreateActBusy(abTab)
*/

function ANPlusCreateActBusy(abTab)	
	local ent = ents.Create( "ai_goal_actbusy" )
	ent:SetName( abTab['Name'] )
	for _, v in pairs( abTab['KeyValues'] ) do	
		ent:SetKeyValue( tostring( _ ), v )				
	end	
	ent:Spawn()
	ent:Activate()
	return ent
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
					if self.anp_fTarget:IsPlayer() && self:Disposition( self.anp_fTarget ) != D_LI then ANPlusMSGPlayer( self.anp_fTarget, self:ANPlusGetName() .. " is no longer following you because it doens't like you anymore.", Color( 255, 200, 0 ), "ANP.UI.Error" ) end			
					
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
		ANPlusMSGPlayer( ply, self:ANPlusGetName() .. " doesn't like you, therefore it won't follow you.", Color( 255, 50, 0 ), "ANP.UI.Error" )
	elseif !IsValid(self:ANPlusGetFollowTarget()) || ( IsValid(self:ANPlusGetFollowTarget()) && !self:ANPlusGetFollowTarget():IsPlayer() ) || self:ANPlusGetFollowTarget() != ply then
		self:ANPlusFollowTarget( ply, followdist, followrundist, followcombatdist, followcombatrundist )
		ANPlusMSGPlayer( ply, self:ANPlusGetName() .. " is following you now.", Color( 50, 255, 0 ), "ANP.UI.Click" )
	elseif IsValid(self:ANPlusGetFollowTarget()) && self:ANPlusGetFollowTarget() == ply then
		self:ANPlusFollowTarget()
		ANPlusMSGPlayer( ply, self:ANPlusGetName() .. " is no longer following you.", Color( 255, 200, 0 ), "ANP.UI.Error" )
	else
		ANPlusMSGPlayer( ply, self:ANPlusGetName() .. " is following someone else.", Color( 255, 50, 0 ), "ANP.UI.Error" )
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

function ENT:ANPlusPlayActivity(act, speed, movementVel, faceEnt, faceSpeed, callback, postCallback)
	if self:IsNPC() && ( self:GetNPCState() == 6 || self:GetNPCState() == 7 || !self:ANPlusAlive() ) then return end
	local actSeq = self:SelectWeightedSequence( act )
	local actSeqName = self:GetSequenceName( actSeq )
	local gestCheck = string.find( string.lower( actSeqName ), "gesture_" ) || string.find( string.lower( actSeqName ), "g_" ) || string.find( string.lower( actSeqName ), "gest" )
	
	local speed = speed || 1
	local facespeed = facespeed || 0
	
	if gestCheck then
		self:AddGesture( act, true )
	else
		self:TaskComplete()
		self:ClearGoal()
		self:ClearSchedule()
		self:ClearCondition( 68 )
		self:SetCondition( 67 )	
		self.m_fDefCaps = self.m_fDefCaps || self:CapabilitiesGet()
		self:CapabilitiesClear()
		if movementVel && self:GetMoveType() == 3 then 
			self.m_fIdealMoveType = self.m_fIdealMoveType || self:GetMoveType()
			self:SetMoveType( 5 ) 
		end
		self:ResetSequenceInfo()
		self:SetIdealActivity( act )
		self:ResetIdealActivity( act )
		self:SetActivity( act )
	end
	
	self.m_bANPlusPlayingActivity = true
	
	local seqName = self:GetSequenceName( gestCheck && actSeq || self:GetSequence() )
	local seqID, seqDur = self:LookupSequence( seqName )	
	local seqSpeed = self:GetSequenceGroundSpeed( seqID )
	seqDur = seqDur / speed

	self:ANPlusSetNextFlinch( seqDur )

	if isfunction( callback ) then
		callback( seqID, seqDur, seqSpeed )
	end

	timer.Create( "ANP_ACT_RESET" .. self:EntIndex(), seqDur, 1, function() 
		if !IsValid(self) then return end			
		self.m_bANPlusPlayingActivity = false
		
		if !gestCheck then
			self:ClearCondition( 67 )
			self:SetCondition( 68 )
			self:CapabilitiesAdd( self.m_fDefCaps || 0 )
			if movementVel && self.m_fIdealMoveType then 
				self:SetMoveType( self.m_fIdealMoveType )
			end
			self:StartEngineTask( ai.GetTaskID( "TASK_RESET_ACTIVITY" ), 0 )
		end
		
		if isfunction( postCallback ) then
			postCallback( seqID, seqDur )
		end
		
	end)

	timer.Create( "ANP_ACT_THINK" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self:ANPlusPlayingAnim() then return end
		self:MaintainActivity()
		
		if !gestCheck then
			local gravFix = self.m_fIdealMoveType == 3 && !self:OnGround() && Vector( 0, 0, -500 ) || ZERO_VEC
			if isbool( movementVel ) && movementVel == true then
				local seqVel = self:GetSequenceVelocity( seqID, self:GetCycle() )
				seqVel:Rotate( self:GetAngles() )
				self:SetLocalVelocity( seqVel + gravFix )
			elseif isnumber( movementVel ) then
				local seqVel = self:GetSequenceVelocity( seqID, self:GetCycle() )
				seqVel:Rotate( self:GetAngles() )
				self:SetLocalVelocity( seqVel * movementVel + gravFix )
				self:SetVelocity( self:GetVelocity() )
			elseif isvector( movementVel ) then
				self:SetLocalVelocity( movementVel )
			end
		end
		
		self:SetPlaybackRate( speed ) 
		if IsValid(faceEnt) && faceSpeed >= 0 then 
			self:ANPlusFaceEntity( faceEnt, faceSpeed )
		end
	end)
	
end

function ENT:ANPlusPlayScene(scene, speed, stopMoving, faceEnt, faceSpeed, callback, postCallback)
	if self:IsNPC() && ( self:GetNPCState() == 6 || self:GetNPCState() == 7 || !self:ANPlusAlive() ) then return end
	local speed = speed || 1
	local facespeed = facespeed || 0
	
	self.m_fLastState = self:GetNPCState()
	self:TaskComplete()
	self:ClearGoal()
	
	local scnDur, scnEnt = self:PlayScene( scene, 0 )
	self.m_bANPlusPlayingActivity = true		
	scnDur = scnDur / speed
	 
	if isfunction( callback ) then
		callback( scnEnt, scnDur )
	end
	
	timer.Create( "ANP_SCENE_RESET" .. self:EntIndex(), scnDur, 1, function() 
		if !IsValid(self) then return end	
		
		self.m_bANPlusPlayingActivity = false
		self:StartEngineTask( ai.GetTaskID( "TASK_RESET_ACTIVITY" ), 0 )
		
		if isfunction( postCallback ) then
			postCallback( scnEnt, scnDur )
		end
		
	end)

	timer.Create( "ANP_SCENE_PLAYBACKRATE" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self:ANPlusPlayingAnim() then return end
		if stopMoving then self:StopMoving() end
		self:MaintainActivity()
		self:SetPlaybackRate( speed ) 
		if IsValid(faceEnt) && faceSpeed >= 0 then 
			self:ANPlusFaceEntity( faceEnt, faceSpeed )
		end
	end)	
end

function ENT:ANPlusPlaySequence(seq, speed, stopMoving, faceEnt, faceSpeed, callback, postCallback)
	if self:IsNPC() && ( self:GetNPCState() == 6 || self:GetNPCState() == 7 || !self:ANPlusAlive() ) then return end
	local speed = speed || 1
	local facespeed = facespeed || 0
	 
	self.m_fLastState = self:GetNPCState()
	self:SetNPCState( 4 )
	self:TaskComplete()
	self:ClearGoal()
	
	local seqID, seqDur = self:LookupSequence( seq )
	self.m_bANPlusPlayingActivity = true		
	seqDur = seqDur / speed
	--self:SetSchedule( SCHED_NPC_FREEZE )
	--self:NextThink( CurTime() + 2 )
	--self:SetSaveValue( "m_flAnimTime", 1 )
	--self:SetSaveValue( "m_flNextDecisionTime", seqDur )
	self:SetMoveType( 3 )
	self:SetArrivalSequence( seqID )
	--self:StartEngineTask( ai.GetTaskID( "TASK_PLAY_SEQUENCE" ), seqID )
	 
	if isfunction( callback ) then
		callback( seqID, seqDur )
	end
	
	timer.Create( "ANP_SCENE_RESET" .. self:EntIndex(), seqDur, 1, function() 
		if !IsValid(self) then return end	
		
		self.m_bANPlusPlayingActivity = false
		self:SetCondition( 68 )
		self:SetNPCState( self.m_fLastState || 1 )
		self:StartEngineTask( ai.GetTaskID( "TASK_RESET_ACTIVITY" ), 0 )
		
		if isfunction( postCallback ) then
			postCallback( seqID, seqDur )
		end
		
	end)

	timer.Create( "ANP_SCENE_PLAYBACKRATE" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self:ANPlusPlayingAnim() then return end
		if stopMoving then self:StopMoving() end
		self:MaintainActivity()
		self:SetPlaybackRate( speed ) 
		if IsValid(faceEnt) && faceSpeed >= 0 then 
			self:ANPlusFaceEntity( faceEnt, faceSpeed )
		end
	end)	
end

function ENT:ANPlusDoDeathAnim(dmginfo, act, speed, movementVel, atHPLevel, dmgMin, dmgMax, chance, interruptible, preCallback, postCallback)
	local att = dmginfo:GetAttacker()
	local inf = dmginfo:GetInflictor()
	local dmg = dmginfo:GetDamage()
	local dmgt = dmginfo:GetDamageType()
	local atHPLevel = atHPLevel || 1
	local targethp = math.Approach( self:Health(), atHPLevel, dmg ) == atHPLevel
	if act && ( !dmgMin || dmgMin == 0 || ( dmgMin && dmg >= dmgMin ) ) && ( !dmgMax || dmgMax == 0 || ( dmgMax && dmg <= dmgMax ) ) && targethp && !self.m_bDeathAnimPlay && ANPlusPercentageChance( chance ) then
		if isfunction( preCallback ) then
			preCallback( self )
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
		self:ANPlusPlayActivity( act, speed, movementVel, nil, nil, nil, function()
			self.m_bNPCNoDamage = false
			if isfunction( postCallback ) then
				postCallback( self, lastDMGinfo )
			end
			--self:SetSchedule( SCHED_IDLE_STAND )
			local newDMGinfo = DamageInfo()
			newDMGinfo:SetAttacker( IsValid(lastDMGinfo.att) && lastDMGinfo.att || self )
			newDMGinfo:SetInflictor( IsValid(lastDMGinfo.inf) && lastDMGinfo.inf || self )
			newDMGinfo:SetDamage( 1 )
			self:TakeDamageInfo( newDMGinfo )
		end)
		self.m_bDeathAnimPlay = true
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

function ENT:ANPlusOverrideMoveSpeed(speed, rate, respectGoal)
	if speed != 1 && ( !respectGoal || ( respectGoal && self:IsGoalActive() && self:GetPathDistanceToGoal() > 10 * speed ) ) && ( ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 1 ) && self:OnGround() ) || ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 4 ) ) || ( self:GetMoveType() == 6 ) ) && self:ANPlusIsMoveSpeed( 1, 1 ) then			
		self:SetMoveVelocity( self:GetGroundSpeedVelocity() * speed ) 
		local seqName = self:GetSequenceName( self:GetSequence() )
		local seqID, seqDur = self:LookupSequence( seqName )
		local seqVel = self:GetSequenceVelocity( seqID, self:GetCycle() )
		seqVel:Rotate( self:GetAngles() )
		self:SetLocalVelocity( seqVel * speed )				
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

function ENT:ANPlusGetIdealSequence()
	if !self:GetInternalVariable( "m_nIdealSequence" ) then return nil end
	return self:GetInternalVariable( "m_nIdealSequence" )
end

function ENT:ANPlusSetIdealSequence(seq)
	if !self:GetInternalVariable( "m_nIdealSequence" ) then return nil end
	seq = isstring( seq ) && self:LookupSequence( seq ) || seq
	self:SetSaveValue( "m_nIdealSequence", seq )
end

function ENT:ANPlusGetIdealWeaponActivity()
	if !self:GetInternalVariable( "m_IdealWeaponActivity" ) then return nil end
	return self:GetInternalVariable( "m_IdealWeaponActivity" )
end

function ENT:ANPlusSetIdealWeaponActivity(act)
	if !self:GetInternalVariable( "m_IdealWeaponActivity" ) then return nil end
	self:SetSaveValue( "m_IdealWeaponActivity", act )
end

function ENT:ANPlusSetIdealTranslatedActivity(act)
	if !self:GetInternalVariable( "m_IdealTranslatedActivity" ) then return nil end
	self:SetSaveValue( "m_IdealTranslatedActivity", act )
end

function ENT:ANPlusGetTranslatedActivity()
	if !self:GetInternalVariable( "m_translatedActivity" ) then return nil end
	return self:GetInternalVariable( "m_translatedActivity" )
end

function ENT:ANPlusSetTranslatedActivity(act)
	if !self:GetInternalVariable( "m_translatedActivity" ) then return nil end
	self:SetSaveValue( "m_translatedActivity", act )
end

function ENT:ANPlusGetNextFlinch()
	if !self:GetInternalVariable( "m_flNextFlinchTime" ) then return nil end
	return self:GetInternalVariable( "m_flNextFlinchTime" )
end

function ENT:ANPlusSetNextFlinch(value)
	if !self:GetInternalVariable( "m_flNextFlinchTime" ) then return nil end
	self:SetSaveValue( "m_flNextFlinchTime", value )
end

function ENT:SetIdealMoveSpeed(val)
	self:SetSaveValue( "m_flGroundSpeed", val )
end

function ENT:ANPlusClearTarget()
	self:SetSaveValue( "m_hTargetEnt", NULL )
end

function ENT:ANPlusIsNPCCrouching()
	local actName = self:GetSequenceActivityName( self:GetSequence() )
	local check1 = string.find( actName:lower(), "_crouch" )
	local check2 = string.find( actName:lower(), "_low" )
	if check1 || check2 then return true end
	return false
end

function ENT:ANPlusGetSquadName()
	return self:GetKeyValues().squadname || false
end

function ENT:ANPlusPlayingDeathAnim()
	return self.m_bDeathAnimPlay
end

function ENT:ANPlusPlayingAnim()
	return self.m_bANPlusPlayingActivity
end

function ENT:ANPlusBlockSchedule(sched)
	if self:IsCurrentSchedule( sched ) then self:TaskComplete(); self:SetCycle( 1 ); self:ClearSchedule() end
end

function ENT:ANPlusReplaceSchedule(oldSched, newSched)
	if self:IsCurrentSchedule( oldSched ) then
		if !newSched then
			self:TaskComplete(); self:ClearSchedule(); self:SetCycle( 1 ) 
		else
			self:SetSchedule( newSched )
		end
	end
end

function ENT:ANPlusGetLastPosition()
	return self:GetInternalVariable( "m_vecLastPosition" )
end