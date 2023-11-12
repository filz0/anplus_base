------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local metaENT = FindMetaTable("Entity")

function metaENT:ANPlusSetKillfeedName(name)
	if !name || name == "" then name = nil end
	if self:ANPlusGetDataTab() then
		self:ANPlusGetDataTab()['KillfeedName'] = name		
	--[[
		if !name then return end
		net.Start( "anplus_add_fakename_language" )
		net.WriteString( name )
		net.Broadcast()
	]]--
	end
end

function metaENT:ANPlusGetKillfeedName()
	return self:ANPlusGetDataTab() && self:ANPlusGetDataTab()['KillfeedName'] || self:ANPlusGetName()
end

function metaENT:ANPlusIsLookingAtPos( pos )
	
	local dirv = pos - ( self:GetPos() + Vector( 0, 0, 50 ) )	
	local norm = dirv:GetNormalized()
	
	return ( !( self:GetAimVector():Dot( norm ) < 0.90 ) ) || ( !( self:GetAimVector():Dot( ( dirv + Vector( 70 ) ):GetNormalized() ) < 0.95 ) )
	
end

function ANPIsAnyoneLookingAtPos( ent, entTab, pos )
	
	local seen = false
	
	for k,v in pairs( entTab ) do
	
		if v:IsNPC() || ( v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) then
			
			if IsValid(ent) && v == ent then return false end
			
			seen = v:ANPlusIsLookingAtPos( pos )
			
			if seen then return true end
		
		end
	
	end
	
	return false
	
end

function metaENT:ANPlusRandomTeleport( entTab, iType, poscorrection, callback )	
	local v = ANPlusAIGetNodes( iType ) && ANPlusAIGetNodes( iType )[ math.random( 1, #ANPlusAIGetNodes( iType ) ) ] || false	
	if v && v['type'] == iType && !ANPlusAINodeOccupied( v['pos'] ) && ( ( !entTab && v['pos'] != self:GetPos() ) || ( entTab && v['pos'] != self:GetPos() && !ANPIsAnyoneLookingAtPos( self, entTab, v['pos'] ) ) ) then

		self:SetPos( v['pos'] + ( poscorrection || Vector( 0, 0, 0 ) ) )
			
		if isfunction( callback ) then	
			callback( self, v['pos'] )
		end				
	end
end

function metaENT:ANPlusAddHealth(val, max)
	local hpAdd = math.min( max - self:Health(), val )-- Dont overheal	
	self:SetHealth( math.Approach( self:Health(), max, hpAdd ))
end

function metaENT:ANPlusRemoveHealth(val, max)
	local hpAdd = math.min( self:Health() - max, val )-- Dont overheal	
	self:SetHealth( math.Approach( self:Health(), max, hpAdd ))
end

function metaENT:MyVJClass()

	if !IsValid(self) || !self.IsVJBaseSNPC then return false end
	
	for i = 1, #self.VJ_NPC_Class do
	
		return self.VJ_NPC_Class[ i ]
	
	end

end

function metaENT:ANPlusCapabilitiesHas(cap) 
	if bit.band( self:CapabilitiesGet(), cap ) == cap then	
		return true		
	else	
		return false		
	end
end

function metaENT:ANPlusDisableCollisions(ent)	
	self.m_tANPCollisionTab = self.m_tANPCollisionTab || {}
	if !IsValid(ent) then return end -- self.m_tANPCollisionTab end	
	if !table.HasValue( self.m_tANPCollisionTab, ent ) then		
		constraint.NoCollide( self, ent, 0, 0 )		
		table.insert( self.m_tANPCollisionTab, ent )		
	end		
end

--[[
function ANPlusPlayerKillFeed( ply, inf, npc ) -- Yoink https://github.com/Facepunch/garrysmod/tree/451b4ff5d1aea7b9b06a8024ef706c248a79647e/garrysmod/gamemodes/base/gamemode

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right || wrong with NPCs since combine can be holding a
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inf ) && inf == npc && ( inf:IsNPC() ) ) then

		inf = inf:GetActiveWeapon()
		if ( !IsValid( inf ) ) then inf = npc end

	end

	net.Start( "PlayerKilled" )

		net.WriteEntity( ply )
		net.WriteString( inf:GetClass() )
		net.WriteString( npc:ANPlusGetDataTab()['Name'] )

	net.Broadcast()

end

function ANPlusNPCKillFeed( npc, att, inf ) -- Yoink https://github.com/Facepunch/garrysmod/tree/451b4ff5d1aea7b9b06a8024ef706c248a79647e/garrysmod/gamemodes/base/gamemode

	-- Don't spam the killfeed with scripted stuff
	if ( npc:GetClass() == "npc_bullseye" || npc:GetClass() == "npc_launcher" ) then return end

	if ( IsValid( att ) && att:GetClass() == "trigger_hurt" ) then att = npc end

	if ( IsValid( att ) && att:IsVehicle() && IsValid( att:GetDriver() ) ) then
	att = att:GetDriver()
	end

	if ( !IsValid( inf ) && IsValid( att ) ) then
	inf = att
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	if ( IsValid( inf ) && att == inf && ( inf:IsPlayer() || inf:IsNPC() ) ) then

		inf = inf:GetActiveWeapon()
		if ( !IsValid( att ) ) then inf = att end

	end
	
	local vicClass = npc:ANPlusGetDataTab() && npc:ANPlusGetDataTab()['Name'] || npc:GetClass()
	local infClass = "worldspawn"
	local attClass = "worldspawn"

	if ( IsValid( inf ) ) then infClass = inf:GetClass() end
	if ( IsValid( att ) ) then

		attClass = att:ANPlusGetDataTab() && att:ANPlusGetDataTab()['Name'] || att:GetClass()

		if ( att:IsPlayer() ) then

			net.Start( "PlayerKilledNPC" )
	
				net.WriteString( vicClass )
				net.WriteString( infClass )
				net.WriteEntity( att )
	
			net.Broadcast()

			return
			
		end

	end

	if ( npc:GetClass() == "npc_turret_floor" ) then attClass = npc:GetClass() end

	net.Start( "NPCKilledNPC" )

		net.WriteString( vicClass )
		net.WriteString( infClass )
		net.WriteString( attClass )

	net.Broadcast()

end
]]--

function metaENT:ANPlusLastHitGroup()
	return self.m_fHitGroupLast || -1
end

function metaENT:ANPlusIsOnGround(dist)

	local min, max = self:GetCollisionBounds()
	local tr = util.TraceHull( {
		start = self:GetPos(),
		endpos = self:GetPos(),
		mins = Vector( min.x, min.y, -dist ),
		maxs = Vector( max.x, max.y, 0 ),
		filter = self
	})

	if tr.Hit then
		return true
	else
		return false
	end

end

function metaENT:ANPlusUnParentFromBone(ent, bone, solid, collisiongroup, physinit, movetype, dontDel)

	local boneid = ent:LookupBone( bone )
	
	if !boneid then return end	
	
	local matrix = ent:GetBoneMatrix( boneid )
			
	if !matrix then return end
			
	local newPos, newAng = LocalToWorld( self:GetPos(), self:GetAngles(), matrix:GetTranslation(), matrix:GetAngles() )	
	
	self:FollowBone( nil, boneid || 0 )
	self:SetParent()	
	self:SetPos( newPos )
	self:SetAngles( newAng )
	if solid then self:SetSolid( solid ) end
	if collisiongroup then self:SetCollisionGroup( collisiongroup ) end
	if physinit then self:PhysicsInit( physinit ) end
	if movetype then self:SetMoveType( movetype ) end
	if !dontDel then ent:DeleteOnRemove( self ) end
	
end

function metaENT:ANPlusParent(ent, att, pos, ang, dontDel)
	
	local oldPI = self:GetSolid()
	local oldMT = self:GetMoveType()
	local oldS = self:GetSolid()
	
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	
	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )
	
	local att = att && isstring( att ) && ent:LookupAttachment( att ) || att || -1
	local attTab = ent:GetAttachment( att ) || { Pos = nil, Ang = nil }
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, attTab.Pos || ent:GetPos(), attTab.Ang || ent:GetAngles() )	

	self:SetParent( ent, att || nil )	
	self:SetPos( newPos )
	self:SetAngles( newAng )	
	
	self:PhysicsInit( oldPI )
	self:SetMoveType( oldMT )
	self:SetSolid( oldS )
	
	if !dontDel then ent:DeleteOnRemove( self ) end

end

function metaENT:ANPlusParentToBone(ent, bone, pos, ang, dontDel)
	
	local boneid = ent:LookupBone( bone )

	if !boneid then return end	
	
	local oldPI = self:GetSolid()
	local oldMT = self:GetMoveType()
	local oldS = self:GetSolid()
	
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	
	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )
	
	local matrix = ent:GetBoneMatrix( boneid )
			
	if !matrix then return end
			
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )	

	self:FollowBone( ent, boneid )	
	self:SetPos( newPos )
	self:SetAngles( newAng )	
	
	self:PhysicsInit( oldPI )
	self:SetMoveType( oldMT )
	self:SetSolid( oldS )
	
	if !dontDel then ent:DeleteOnRemove( self ) end

end

function metaENT:ANPlusBoneMerge(ent)	
	--self:SetSolid( SOLID_NONE )
	--self:SetMoveType( MOVETYPE_NONE )
	--self:SetNotSolid( true )
	self:SetParent( ent )
	self:AddEffects( EF_BONEMERGE )
	self:SetOwner( ent )
	ent:DeleteOnRemove( self )
	
	ent:DeleteOnRemove( self )
end

function metaENT:ANPlusSetToBonePosAndAng(ent, bone, pos, ang)
	
	local boneid = ent:LookupBone( bone )
	
	if !boneid then return end	
	
	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )
	
	local matrix = ent:GetBoneMatrix( boneid )	
	
	if !matrix then return end	
	
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )	
		
	self:SetPos( newPos )
	self:SetAngles( newAng )	
end

function metaENT:ANPlusGetBonePosAndAng(bone, pos, ang)
	
	local boneid = self:LookupBone( bone )
	
	if !boneid then return end	
	
	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )
	
	local matrix = self:GetBoneMatrix( boneid )	
	
	if !matrix then return end	
	
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )		
	return newPos, newAng
end

function metaENT:ANPlusSetParentAttachment(ent, att)	
	if !att then return end
	
	att = isstring( att ) && att || ent:ANPlusGetAttachmentName( att )

	self:SetPos( ent:GetPos() )
	self:SetParent( ent )
	self:Fire( "SetParentAttachment", att, 0 )
end

function metaENT:ANPlusGetAttachmentPosAndAng(att, pos, ang)
	
	att = isstring( att ) && att || ent:ANPlusGetAttachmentName( att )
	
	if !att then return end	
	
	local attID = self:LookupAttachment( att )
	local attTab = self:GetAttachment( attID )
	
	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )

	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, attTab.Pos, attTab.Ang )		
	return newPos, newAng
end

function ANPlusCreateSprite(model, color, scale, sfs, kvs)
	ent = ents.Create( "env_sprite" )
	ent:SetKeyValue( "model", model ) 
	ent:SetKeyValue( "rendercolor", "" .. color.r .. " " .. color.g .. " " .. color.b .. "" ) 
	ent:SetKeyValue( "scale", scale ) 
	ent:SetKeyValue( "spawnflags", sfs || 0 ) 
	if kvs then
		for _, v in pairs( kvs ) do	
			ent:SetKeyValue( tostring( _ ), v )				
		end	
	end
	ent:Spawn()
	ent:Activate()
	return ent
end

function ANPlusCreateParticle(particle, startDelay, killDelay, entParent, attachment)
	local ent = ents.Create( "sent_anp_particlebase" )
	ent.Particle = particle
	ent.StartDelay = startDelay || 0
	ent.KillDelay = killDelay || 0
	ent.Parent = entParent
	ent.Attachment = attachment
	ent:Spawn()
	ent:Activate()
	return ent
end

function ANPlusCreateParticleSystem(particle, startDelay, killDelay)
	local ent = ents.Create( "info_particle_system" )
	ent:SetKeyValue( "effect_name", particle )
	ent:Fire( "Start", "", startDelay || 0 )
	if killDelay then ent:Fire( "Kill", "", killDelay ) end
	ent:Spawn()
	ent:Activate()
	return ent
end

function ANPlusCreateSpotlight(color, width, length, sfs, kvs)
	local ent = ents.Create( "beam_spotlight" )
	ent:SetKeyValue( "spawnflags", sfs || 0 )
	ent:SetKeyValue( "spotlightwidth", width )
	ent:SetKeyValue( "spotlightlength", length )
	if kvs then
		for _, v in pairs( kvs ) do	
			ent:SetKeyValue( tostring( _ ), v )				
		end	
	end
	ent:SetColor( color )
	ent:Spawn()
	ent:Activate()
	return ent
end

function metaENT:ANPlusRemoveSpotlight()
	if !IsValid(self) then return end
	self:Fire( "KillHierarchy" ) -- Never use anything else to remove "beam_spotlight"!
end

function metaENT:ANPlusToggleSpotlight(bool)
	if !IsValid(self) then return end
	if bool then
		self:Fire( "LightOn" )
	elseif !bool then
		self:Fire( "LightOff")
	end
end

function ANPlusCreateProjectedTexture(color, texture, fov, nearZ, farZ, lightWorld, sfs, kvs)
	local ent = ents.Create( "env_projectedtexture" )
	ent:SetKeyValue( "spawnflags", sfs || "0" )
	ent:SetKeyValue( 'lightcolor', tostring( color ) )
	ent:SetKeyValue( "texturename", texture || "effects/flashlight001" )
	ent:SetKeyValue( "lightfov", fov || "90" )
	ent:SetKeyValue( "nearz", nearZ || 1 )
	ent:SetKeyValue( "farz", farZ || 500 )
	ent:SetKeyValue( "lightworld", lightWorld || 1 )	

	if kvs then
		for _, v in pairs( kvs ) do	
			ent:SetKeyValue( tostring( _ ), v )				
		end	
	end
	ent:Spawn()
	ent:Activate()
	return ent
end

function metaENT:ANPlusToggleEntity(bool)
	if !IsValid(self) then return end
	if bool then
		self:Fire( "TurnOn" )
	elseif !bool then
		self:Fire( "TurnOff")
	end
end

--[[
function ANPlusCreateLightPoint(color, innerCone, cone, exponent, distance, sfs, kvs)
	local ent = ents.Create( "light_spot" )
	ent:SetKeyValue( "spawnflags", sfs || 0 )
	ent:SetKeyValue( "_inner_cone", innerCone )
	ent:SetKeyValue( "_cone", cone )
	ent:SetKeyValue( "_exponent", exponent )
	ent:SetKeyValue( "_distance", distance )
	--ent:SetKeyValue( "_hardfalloff", "1" )
	ent:SetKeyValue( "_light", "255 255 255 4000" )
	ent:SetKeyValue( "style", 0 )
	--ent:SetName( "anp_lightspot" .. ent:EntIndex() )
	ent:SetName( "dsadsaadssad" )
	if kvs then
		for _, v in pairs( kvs ) do	
			ent:SetKeyValue( tostring( _ ), v )				
		end	
	end
	--ent:SetColor( color )
	ent:Spawn()
	ent:Activate()
	return ent
end
]]--

function ANPlusCreateSporeExplosion(spawnRate, startDisabled)
	startDisabled = startDisabled || false
	local ent = ents.Create( "env_sporeexplosion" )
	ent:SetKeyValue( "spawnrate", spawnRate )
	ent:SetKeyValue( "StartDisabled", tostring( startDisabled ) )
	return ent
end

function metaENT:ANPlusNPCGetImprovedAiming(shootPos, target, aimpos)
	local newPos = IsValid(target) && self:ANPlusInRange( target, 16384 ) && shootPos || self:WorldSpaceCenter()	
	local targetPos = ( aimpos || target:BodyTarget( newPos ) || target:WorldSpaceCenter() || target:GetPos() )
	local dir = targetPos && ( targetPos - newPos ):GetNormalized() || self:GetAimVector()
	return newPos, dir
end

function ANPlusCreateLaser(texture, spawnEnd, color, width, sfs, kvs)
	ent = ents.Create( "env_laser" )
	ent:SetKeyValue( "texture", texture || "sprites/laserbeam.spr" )
	ent:SetKeyValue( "width", width || 1 )
	ent:SetColor( color || Color( 255, 255, 255 ) )
	ent:SetKeyValue( "renderamt", color.a || 255 )
	ent:SetKeyValue( "spawnflags", sfs )
	local name = "anp_Laser" .. ent:EntIndex()
	ent:SetName( name )
	if istable( kvs ) then
		for _, v in pairs( kvs ) do	
			ent:SetKeyValue( tostring( _ ), v )				
		end	
	end
	if spawnEnd then
		ent.m_pLaserTarget = ents.Create( "info_target" )
		ent.m_pLaserTarget:SetPos( ent:GetPos() )
		ent.m_pLaserTarget:SetAngles( ent:GetAngles() )
		ent.m_pLaserTarget:SetOwner( ent )
		ent.m_pLaserTarget:SetParent( ent )
		local nameT = "anp_LaserTarget" .. ent:EntIndex()
		ent.m_pLaserTarget:SetName( nameT )
		if IsValid(ent.m_pLaserTarget) then ent:SetKeyValue( "LaserTarget", nameT ) end
		ent:DeleteOnRemove( ent.m_pLaserTarget )
	end
	
	ent:Spawn()
	ent:Activate()
	
	return ent, ent.m_pLaserTarget
end

function ANPlusCreateLaserSENT(laserMat, laserWidth, laserMatStart, laserMatEnd, laserFPS, laserColor, startDotMat, startDotWidth, startDotHeight, startDotColor, endDotMat, endDotWidth, endDotHeight, endDotColor, dist, laserHitDelay, entFilter, ignoreWorld, killTime, hitCallBack)
	ent = ents.Create( "sent_anp_laser_proto" )

	ent.m_sLaserMat = laserMat
	ent.m_fLaserWidth = laserWidth
	ent.m_fLaserMatStart = laserMatStart
	ent.m_fLaserMatEnd = laserMatEnd
	ent.m_fLaserFPS = laserFPS
	ent.m_sLaserColor = laserColor
	
	ent.m_sStartDotMat = startDotMat
	ent.m_fStartDotWidth = startDotWidth
	ent.m_fStartDotHeight = startDotHeight
	ent.m_sStartDotColor = startDotColor
		
	ent.m_sEndDotMat = endDotMat
	ent.m_fEndDotWidth = endDotWidth
	ent.m_fEndDotHeight = endDotHeight
	ent.m_sEndDotColor = endDotColor
	
	ent.m_fDistance = dist
	ent.m_fNextThink = laserHitDelay
	ent.m_tEntFilter = entFilter
	ent.m_fIgnoreWorld = ignoreWorld
	ent.m_fKillDelay = killTime
	ent.m_funHitCallBack = hitCallBack
	
	ent:Spawn()
	ent:Activate()
	
	return ent
end
--[[
function ANPlusCreateLaser(texture, spawnEnd, color, width, sfs, kvs)
	local ent = ents.Create( "sent_anp_envlaser" )
	ent.m_flLaserTexture = texture
	ent.m_flLaserTargetEnable = spawnEnd
	ent.m_flLaserSpawnFlags = sfs
	ent.m_flLaserWidth = width
	ent.m_flLaserKeyValuesTab = kvs
	ent.m_flLaserColor = color
	ent:Spawn()
	ent:Activate()
	return ent, ent.m_pLaser, ent.m_pLaserTarget
end
]]--
function ANPlusCreateBeam(texture, spawnStart, spawnEnd, color, width, sfs, kvs)
	ent = ents.Create( "env_beam" )
	ent:SetKeyValue( "texture", texture )
	ent:SetKeyValue( "BoltWidth", width || 1 )
	ent:SetColor( color || Color( 255, 255, 255 ) )
	ent:SetKeyValue( "renderamt", color.a || 255 )
	ent:SetKeyValue( "spawnflags", sfs )
	local name = "anp_Beam" .. ent:EntIndex()
	ent:SetName( name )
	if spawnStart then ent:SetKeyValue( "LightningStart", name ) end
	if istable( kvs ) then
		for _, v in pairs( kvs ) do	
			ent:SetKeyValue( tostring( _ ), v )				
		end	
	end	 
	if spawnEnd then
		ent.m_pBeamTarget = ents.Create( "info_target" )
		ent.m_pBeamTarget:SetPos( ent:GetPos() )
		ent.m_pBeamTarget:SetAngles( ent:GetAngles() )
		ent.m_pBeamTarget:SetOwner( ent )
		ent.m_pBeamTarget:SetParent( ent )
		local nameT = "anp_BeamTarget" .. ent:EntIndex()
		ent.m_pBeamTarget:SetName( nameT )
		if IsValid(ent.m_pBeamTarget) then ent:SetKeyValue( "LightningEnd", nameT ) end
		ent:DeleteOnRemove( ent.m_pBeamTarget )
	end	
	ent:Spawn()
	ent:Activate()
	
	return ent, ent.m_pBeamTarget
end

function metaENT:ANPlusDissolve(attacker, inflictor, dealDMG, dtype)
	
	attacker = attacker || self
	inflictor = inflictor || self
	
	if self:IsPlayer() then
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage( self:Health() )
		dmgInfo:SetAttacker( attacker )
		dmgInfo:SetInflictor( inflictor )
		dmgInfo:SetDamageType( DMG_DISSOLVE )
		dmgInfo:SetDamagePosition( self:GetPos() )
		self:TakeDamageInfo( dmgInfo )
		return
	end

	local _sName = self:ANPlusGetName()
	local sName = "entDissolve" .. self:EntIndex() .. "_entTarget"
	
	--if string.len( sName ) == 0 then
	--	sName = "entDissolve" .. self:EntIndex() .. "_entTarget"
	--	self:SetName( sName )
	--end
	
	local entDissolver = ents.Create( "env_entity_dissolver" )
	entDissolver:SetKeyValue( "dissolvetype", dtype || 2 )
	entDissolver:Spawn()
	entDissolver:Activate()
	entDissolver:SetOwner( attacker )
	self:SetName( sName )
	entDissolver:Fire( "Dissolve", sName, 0 )
	self:TakeDamage( dealDMG && self:Health() || 0, attacker, inflictor )
	
	timer.Simple( 0.01, function()	
		if IsValid( entDissolver ) then entDissolver:Remove() end	
		if IsValid( self ) then self:SetName( _sName ) end		
	end)
	
end

function metaENT:ANPlusIsDoor()	
	local doorClass = self:GetClass()	
	if ( doorClass == "func_door" || doorClass == "func_door_rotating" || doorClass == "prop_door" || doorClass == "prop_door_rotating" ) then
		return true		
	else	
		return false		
	end	
end

function metaENT:ANPlusIsDoorOpen()	
	local doorClass = self:GetClass()
	if ( doorClass == "func_door" || doorClass == "func_door_rotating" ) then
		return self:GetInternalVariable( "m_toggle_state" ) == 0
	elseif ( doorClass == "prop_door_rotating" ) then
		return self:GetInternalVariable( "m_eDoorState" ) != 0
	else
		return false
	end
end

function metaENT:ANPlusHasSpawnFlag(sf)
	return bit.band( self:GetSpawnFlags(), sf ) == sf
end

function ANPlusIsNPCWeapon(wep)
	wep = isstring(wep) && wep || wep:IsWeapon() && wep:GetClass()
	for i = 1, #list.GetForEdit( "NPCUsableWeapons" ) do
		local wepTab = list.GetForEdit( "NPCUsableWeapons" )[ i ]
		if wepTab && wepTab['class'] == wep then return true end
	end
	return false
end

function metaENT:ANPlusPaintDecal(ply, decal, start, endPos, color, w, h)	
	if !ply then return end	
	net.Start( "anplus_paint_decal" )
	net.WriteEntity( self )
	net.WriteString( decal )
	net.WriteVector( start )
	net.WriteVector( endPos )
	net.WriteColor( color || Color( 255, 255, 255 ) )
	net.WriteFloat( w )
	net.WriteFloat( h )
	if isbool( ply ) then
		net.Broadcast()
	elseif ply:IsPlayer() then
		net.Send( ply )
	end
end

function metaENT:ANPlusEmitNPCSound(hint, radius, duration, soundName, soundLevel, pitchPercent, volume, channel, soundFlags, dsp)
	self:EmitSound( soundName, soundLevel, pitchPercent, volume, channel, soundFlags, dsp )
	sound.EmitHint( hint, self:GetPos(), radius, duration, self )
end

function metaENT:ANPlusIsMoveSpeed( hORlORe, speed )
	local gS = self:GetGroundSpeedVelocity():Length()
	if hORlORe == 1 then
		return gS >= speed
	elseif hORlORe == 2 then
		return gS <= speed
	elseif hORlORe == 3 then
		return gS == speed
	end
	return false
end

function metaENT:ANPlusAddAnimationEvent(seq, frame, ev, animFrames) -- Sequence, target frame && animation event ID
	if(!self.m_tbAnimationFrames[seq]) then return end	
	self.m_tbAnimEvents[seq] = self.m_tbAnimEvents[seq] || {}
	self.m_tbAnimEvents[seq][frame] = self.m_tbAnimEvents[seq][frame] || {}
	
	table.insert( self.m_tbAnimEvents[seq][frame], ev )	
	if animFrames then self.m_tbAnimationFrames[seq] = animFrames end
end

function metaENT:ANPlusAddGesture(act, autoKill)
	if act == nil then return end
	local checkACT = self:SelectWeightedSequence( act )
	if checkACT then
		self:RemoveGesture( act )
		self:AddGesture( act, autoKill )
	end
end

function metaENT:ANPlusAddGestureSequence(sequence, autoKill)
	if sequence == nil then return end
	sequence = isstring( sequence ) && self:LookupSequence( sequence ) || self:LookupSequence( self:GetSequenceName( sequence ) )
	if sequence then
		local seqACT = self:GetSequenceActivity( sequence )
		if seqACT then self:RemoveGesture( seqACT ) end
		self:AddGestureSequence( sequence, autoKill )
	end
end

function metaENT:ANPlusRestartGesture(act, addIfMissing, autoKill)
	if act == nil then return end
	local checkACT = self:SelectWeightedSequence( act )
	if checkACT then
		self:RemoveGesture( act )
		self:RestartGesture( act, addIfMissing, autoKill )
	end
end

function metaENT:ANPlusDealDamage(target, dmginfo, cooldown, callback)
	
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

function metaENT:ANPlusDealBlastDamage(target, dmginfo, pos, radius, cooldown, callback) -- Kinda stupid.
	
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

function metaENT:ANPlusCreateOutputHook(entOutput, eventName)
	if !IsValid(ANP_LUA_RUN_ENT) then ANPMapLuaCreate() end
	self:Fire( "AddOutput", entOutput .. " anp_lua_run:RunPassedCode:hook.Run( '" .. eventName .. "' ):0:-1" )
end

function metaENT:ANPlusAddSaveData(key, val, func)
	if key then
		val = isbool(val) && tostring(val) || val -- False valuse do not save, idk either...
		duplicator.StoreEntityModifier( self, "anp_duplicator_data", { ['m_tSaveData'] = { [ key ] = val } } )
		if isfunction(func) then
			duplicator.StoreEntityModifier( self, "anp_duplicator_data", { ['m_tSaveDataUpdateFuncs'] = { [ key ] = func } } )
		end
	end
end

function metaENT:ANPlusWiremodSetInputs(add, inputs, descs, funcs) -- each input should have a function.
	if WireLib then
		if self.Inputs && add then
			WireLib.AdjustInputs( self, inputs, descs )
		else
			WireLib.CreateInputs( self, inputs, descs )
		end
		self.InputFuncs = self.InputFuncs || {}
		for i = 1, #inputs do
			local input = inputs[ i ]
			local func = funcs[ i ]
			local addTab = { [input] = func }
			table.Merge( self.InputFuncs, addTab )
		end
		function self:TriggerInput(key, val)	
			for funcName, FireInputFunc in pairs( self.InputFuncs ) do	
				if FireInputFunc && key == funcName then
					FireInputFunc(self, key, val)
				end
			end			
		end
	end
end

function metaENT:ANPlusWiremodSetOutputs(add, outputs, descs)
	if WireLib then
		if self.Outputs && add then
			WireLib.AdjustOutputs( self, outputs, descs )
		else
			WireLib.CreateOutputs( self, outputs, descs )
		end
	end
end