------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local metaENT = FindMetaTable("Entity")
local metaDMG = FindMetaTable("CTakeDamageInfo")

local vector_zero = Vector( 0, 0, 0 )
local anplus_follower_collisions = GetConVar( "anplus_follower_collisions" )

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

function metaENT:ANPlusRandomTeleport( entTab, iType, posCorrection, callback )	
	local v = ANPlusAIGetNodes( iType ) && ANPlusAIGetNodes( iType )[ math.random( 1, #ANPlusAIGetNodes( iType ) ) ] || false	
	if IsValid(self) && v && v['type'] == iType && !ANPlusAINodeOccupied( v['pos'] ) && ( ( !entTab && v['pos'] != self:GetPos() ) || ( entTab && v['pos'] != self:GetPos() && !ANPIsAnyoneLookingAtPos( self, entTab, v['pos'] ) ) ) then

		self:SetPos( v['pos'] + ( posCorrection || Vector( 0, 0, 0 ) ) )
			
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

function metaENT:ANPlusCapabilitiesHas(cap) 
	if bit.band( self:IsWeapon() && self:GetCapabilities() || self:CapabilitiesGet(), cap ) == cap then	
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
	
	if !IsValid(self) || !IsValid(ent) then return end

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
	
	if !IsValid(self) || !IsValid(ent) then return end

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
	
	--ent:DeleteOnRemove( self )
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

function ANPlusCreateParticle(effect, startDelay, killDelay, entParent, attachment)
	local ent = ents.Create( "sent_anp_particlebase" )
	ent.Particle = effect
	ent.StartDelay = startDelay || 0
	ent.KillDelay = killDelay || 0
	ent.Parent = entParent
	ent.Attachment = attachment
	ent:Spawn()
	ent:Activate()
	return ent
end

function ANPlusCreateParticleSystem(name, effect, startActive, isWeather, parent)
	local ent = ents.Create( "info_particle_system" )
	ent:SetKeyValue( "targetname", name || "" )
	ent:SetKeyValue( "effect_name", effect )
	ent:SetKeyValue( "start_active", tostring( startActive ) || "0" )
	ent:SetKeyValue( "flag_as_weather", tostring( isWeather ) || "0" )
	if IsValid(parent) then 
		if !parent:GetName() || parent:GetName() == "" then parent:SetName( parent:GetClass() .. parent:EntIndex() ) end
		local name = parent:GetName()
		ent:SetKeyValue( "cpoint1", name ) 
		if parent:GetName() == parent:GetClass() .. parent:EntIndex() then parent:SetName( "" ) end
	end
	--ent:Fire( "Start", "", startDelay || 0 )
	--if killDelay then ent:Fire( "Kill", "", killDelay ) end
	ent:Spawn()
	ent:Activate()
	return ent
end

function metaENT:ANPlusParticleSystemStart(val)
	self:Fire( "Start", "", val || 0 )
end

function metaENT:ANPlusParticleSystemStop(val)
	self:Fire( "Stop", "", val || 0 )
end

function metaENT:ANPlusParticleSystemDestroy(val)
	self:Fire( "DestroyImmediately", "", val || 0 )
end

function metaENT:ANPlusParticleSystemEndCap(val)
	self:Fire( "StopPlayEndCap", "", val || 0 )
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

	ent:SetLaserDistance( dist )

	ent:SetLaserMat( laserMat )
	ent:SetStartDotMat( startDotMat )
	ent:SetEndDotMat( endDotMat )

	ent:SetLaserWidthMin( istable( laserWidth ) && laserWidth[ 1 ] || laserWidth )
	ent:SetLaserWidthMax( istable( laserWidth ) && laserWidth[ 2 ] || laserWidth )
	ent:SetLaserMatStart( laserMatStart )
	ent:SetLaserMatEnd( laserMatEnd )
	ent:SetLaserFPS( laserFPS )

	ent:SetStartDotWidthMin( istable( startDotWidth ) && startDotWidth[ 1 ] || startDotWidth )
	ent:SetStartDotWidthMax( istable( startDotWidth ) && startDotWidth[ 2 ] || startDotWidth )
	ent:SetStartDotHeightMin( istable( startDotHeight ) && startDotHeight[ 1 ] || startDotHeight )
	ent:SetStartDotHeightMax( istable( startDotHeight ) && startDotHeight[ 2 ] || startDotHeight )

	ent:SetEndDotWidthMin( istable( endDotWidth ) && endDotWidth[ 1 ] || endDotWidth )
	ent:SetEndDotWidthMax( istable( endDotWidth ) && endDotWidth[ 2 ] || endDotWidth )
	ent:SetEndDotHeightMin( istable( endDotHeight ) && endDotHeight[ 1 ] || endDotHeight )
	ent:SetEndDotHeightMax( istable( endDotHeight ) && endDotHeight[ 2 ] || endDotHeight )

	ent:SetLaserColor( laserColor:ToVector() )
	ent:SetStartDotColor( startDotColor:ToVector() )
	ent:SetEndDotColor( endDotColor:ToVector() )

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

function metaENT:ANPlusAddAnimationEvent(seq, frame, ev) -- Sequence, target frame && animation event ID
	if(!self.m_tbAnimationFrames[seq]) then return end
	if frame <= self.m_tbAnimationFrames[seq] then
		ANPdev( function()
			print( "LUA animation event created:", "[ SEQUENCE: " .. seq .. " FRAMES: " .. self.m_tbAnimationFrames[seq] .. " ] AT" .. " [ FRAME: " .. frame, "EVENT_ID: " .. ev .. " ]" )
		end, 1 )
	else
		ANPdev( function()
			print( "LUA animation event ERROR!", "You've tried to create an animation event at frame [" .. frame .. "] while sequence [" .. seq .. "] has only [" .. self.m_tbAnimationFrames[seq] .. "] frame/s." )
		end, 1 )
		return false
	end
	self.m_tbAnimEvents[seq] = self.m_tbAnimEvents[seq] || {}
	self.m_tbAnimEvents[seq][frame] = self.m_tbAnimEvents[seq][frame] || {}
	
	table.insert( self.m_tbAnimEvents[seq][frame], ev )	
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

function metaENT:ANPlusCreateOutputFunction(entOutput, func)

	if !self || !IsValid(self) then return end
	if !IsValid(ANP_LUA_RUN_ENT) then ANPMapLuaCreate() end

	local hookID = entOutput .. self:GetClass() .. self:EntIndex()

	hook.Add(hookID, self, function() 

		local activator, caller = ACTIVATOR, CALLER
		func(self, activator, caller)

	end)

	self:Fire( "AddOutput", entOutput .. " anp_lua_run:RunPassedCode:hook.Run( '" .. hookID .. "' ):0:-1" )

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

function metaDMG:ANPlusDontGib()
	local dmgT = self:GetDamageType()

	dmgT = bit.band( dmgT, DMG_NEVERGIB ) != DMG_NEVERGIB && dmgT + DMG_NEVERGIB || dmgT
	dmgT = bit.band( dmgT, DMG_ALWAYSGIB ) == DMG_ALWAYSGIB && dmgT - DMG_ALWAYSGIB || dmgT
	self:SetDamageType( dmgT )	
end

function metaDMG:ANPlusDontRagdoll()
	local dmgT = self:GetDamageType()

	dmgT = bit.band( dmgT, DMG_REMOVENORAGDOLL ) != DMG_REMOVENORAGDOLL && dmgT + DMG_REMOVENORAGDOLL || dmgT
	self:SetDamageType( dmgT )	
end

function metaENT:ANPlusNeverGib(bool)
	self.m_bANPlusNeverGib = bool
end

function metaENT:ANPlusNeverRagdoll(bool)
	self.m_bANPlusNeverRagdoll = bool
end

function metaENT:ANPlusGetNextAttack()
	return self:GetInternalVariable( "m_flNextAttack" )
end

function metaENT:ANPlusGetAttackDelay()
	return self:GetInternalVariable( "m_flShotDelay" )
end

function metaENT:ANPlusSetNextAttack(val)
	return self:SetSaveValue( "m_flNextAttack", val )
end

function metaENT:ANPlusSetAttackDelay(val)
	return self:SetSaveValue( "m_flShotDelay", val )
end

function metaENT:ANPlusUpdateWeaponProficency( wep, dataTab )
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

function metaENT:ANPlusDealMeleeDamage(dist, dmg, dmgt, viewpunch, force, full360, sndhit, sndmiss, callbackHit, callbackMiss)

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
				local posDmg = ent:NearestPoint( center )
				local dmginfo = DamageInfo()
				dmginfo:SetDamageType( dmgt )
				dmginfo:SetDamage( dmg )
				dmginfo:SetAttacker( self )
				dmginfo:SetInflictor( IsValid( self:GetActiveWeapon()) && self:GetActiveWeapon() || self )
				dmginfo:SetDamagePosition( posDmg )
				
				if force then dmginfo:SetDamageForce( force ) end
				
				if isfunction( callbackHit ) then
					callbackHit( ent, dmginfo )
				end
				
				ent:TakeDamageInfo( dmginfo )
				
				if viewpunch && ent:IsPlayer() then
				
					ent:ViewPunch(viewpunch)
					
				elseif ent:GetClass() == "npc_turret_floor" && ( ent:GetNPCState() != 7 || ent:GetNPCState() != 5 ) then
				
					ent:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 10000 ) 
					
				end

			end

		else

			if isfunction( callbackMiss ) then
				callbackMiss()
			end

		end
	end
	if bHit && sndhit then
		self:EmitSound(sndhit)
	elseif !bHit && sndmiss then
		self:EmitSound(sndmiss)
	end
end

function metaENT:ANPlusMeleeAct(target, act, speed, movementVel, rspeed, dist, full360, cooldown, callback)
	
	if !IsValid(self) || !IsValid(target) || self:Health() <= 0 then return end	
	self.m_fANPMeleeLast = self.m_fANPMeleeLast || 0	
	self.m_fANPMeleeDelay = self.m_fANPMeleeDelay || cooldown || 0	
	
	if IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetHoldType() != "" && ANPlusNoMeleeWithThese[ self:GetActiveWeapon():GetHoldType() ] then return end

	local posTarget = target:GetPos()
	local validAng = isbool( full360 ) || self:ANPlusValidAnglesNormal( posTarget, full360 )
	
	if self:Visible( target ) && self:ANPlusInRange( target, dist ) then

		if target:ANPlusAlive() && validAng && CurTime() - self.m_fANPMeleeLast > self.m_fANPMeleeDelay then		
			self:ANPlusPlayActivity( act, speed, movementVel, target, rspeed, function(seqID, seqDur)
				self.m_fANPMeleeDelay = self.m_fANPMeleeDelay == 0 && seqDur || self.m_fANPMeleeDelay
				if isfunction( callback ) then
					callback(seqID, seqDur)
				end	
				self.m_fANPMeleeLast = CurTime()
			end)
		end
	end
end

function metaENT:ANPlusRangeAct(target, act, speed, movementVel, rspeed, distMax, distMin, full360, cooldown, callback) -- angMax/angMin if full360 is false or nil
	
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

function metaENT:ANPlusRangeAttack(target, distMax, distMin, full360, cooldown, callback) -- angMax/angMin if full360 is false or nil
	
	if !IsValid(self) || !IsValid(target) || self:Health() <= 0 then return end	
	self.m_fANPRangeAttLast = self.m_fANPRangeAttLast || 0	
	self.m_fANPRangeAttDelay = self.m_fANPRangeAttDelay || cooldown || 0	
	local posTarget = target:GetPos()
	local validAng = isbool( full360 ) || self:ANPlusValidAnglesNormal( posTarget, full360 )

	if self:Visible( target ) && self:ANPlusInRange( target, distMax ) && ( distMin && !self:ANPlusInRange( target, distMin ) ) && target:ANPlusAlive() && validAng && CurTime() - self.m_fANPRangeAttLast > self.m_fANPRangeAttDelay then
		callback()
	end
end

function metaENT:ANPlusFireEntity(entity, marksmanAiming, pos, ang, count, force, spread, delay, burstCount, burstReset, fireSND, distFireSND, entPreCallback, entPostCallback, callback)
	
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

function metaENT:ANPlusGrenadeThrow(target, entity, act, speed, movementVel, bonename, throwdelay, forcemul, distmin, distmax, maxlastseen, cooldown, callback) -- Broken AF. Fix it you dummy.

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

function metaENT:ANPlusPlayScriptedSequence(delay)	
	local delay = delay || 0
	local ss = self:GetInternalVariable( "m_hCine" ) || IsValid(self.m_pScriptedSequence) && self.m_pScriptedSequence || nil
	if ss then ss:Fire( "BeginSequence", "", delay ) end		
end

function metaENT:ANPlusCancelScriptedSequence(delay)	
	local delay = delay || 0
	local ss = self:GetInternalVariable( "m_hCine" ) || IsValid(self.m_pScriptedSequence) && self.m_pScriptedSequence || nil
	if ss then self:GetInternalVariable( "m_hCine" ):Fire( "CancelSequence", "", delay ) end		
end

function metaENT:ANPlusGetScriptedSequence()	
	return self:GetInternalVariable( "m_hCine" ) || IsValid(self.m_pScriptedSequence) && self.m_pScriptedSequence || false
end

function metaENT:ANPlusIsScripting()
	if self:GetInternalVariable( "m_hCine" ) == "scripted_sequence" || self:GetInternalVariable("m_hGoalEnt") == "scripted_sequence" || self:GetInternalVariable("m_vecCommandGoal") == "scripted_sequence" || self:GetInternalVariable("m_bInAScript") == true then	
		return true		
	else	
		return false			
	end	
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

function metaENT:ANPlusCreateScriptedSequence(seqDataTab, faceEnt, faceSpeed)
	
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

function metaENT:ANPlusGetFollowTarget()
	return self.m_pFollowTarget
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

local illegalACTs = {
	[30] = true,
	[31] = true,
	[32] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
}

function metaENT:ANPlusFollowTarget(target, followDist, followRunDist, followCombatDist, followCombatRunDist)
	
	local timerName = "ANP_NPC_FollowBeh" .. self:EntIndex()

	if !IsValid(target) then 
	
		if self:IsANPlus() && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCFollow'] != nil then
			self:ANPlusGetDataTab()['Functions']['OnNPCFollow'](self, self.m_pFollowTarget, false)	
		end

		timer.Remove( timerName )
		self.m_pFollowTarget = nil 
		self:SetOwner()

		return 
	end	
	
	if ( ( target:IsNPC() || target:IsPlayer() ) && self:Disposition( target ) != D_LI ) then print(self, " doesn't like ", target, " therefore it won't follow it." ) return end
	
	local followDist = followDist || 200
	local followCombatDist = followCombatDist || 400
	
	if self:GetClass() == "npc_citizen" then self:Fire( "RemoveFromPlayerSquad", "", 0.1 ) end
	
	self.m_pFollowTarget = target
	self:SetTarget( target )

	if self:IsANPlus() && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCFollow'] != nil then
		self:ANPlusGetDataTab()['Functions']['OnNPCFollow'](self, self.m_pFollowTarget, true)	
	end
	
	timer.Create( timerName, 0.5, 0, function()

		if !IsValid(self) || !IsValid(self.m_pFollowTarget) || !self.m_pFollowTarget:ANPlusAlive() || ( ( self.m_pFollowTarget:IsNPC() || self.m_pFollowTarget:IsPlayer() ) && self:Disposition( self.m_pFollowTarget ) != D_LI ) then 
			
			if IsValid(self) then			

				if IsValid(self.m_pFollowTarget) then

					if self.m_pFollowTarget:IsPlayer() && self:Disposition( self.m_pFollowTarget ) != D_LI then ANPlusMSGPlayer( self.m_pFollowTarget, self:ANPlusGetKillfeedName() .. " is no longer following you because it doens't like you anymore.", Color( 255, 200, 0 ), "ANP.UI.Error" ) end			
					
					if self:IsANPlus() && self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCFollow'] != nil then
						self:ANPlusGetDataTab()['Functions']['OnNPCFollow'](self, self.m_pFollowTarget, false)	
					end	
					
				end

				self.m_pFollowTarget = nil 
				self:SetOwner()

			end

			timer.Remove( timerName )
			return 
		end
		
		if ( self.m_pFollowTarget:IsPlayer() && GetConVar( "ai_ignoreplayers" ):GetBool() ) || GetConVar( "ai_disabled" ):GetBool() || !self.m_pFollowTarget:OnGround() || illegalACTs[ self:GetActivity() ] then return end
		local posSelf = self:GetPos()
		local posTarget = self.m_pFollowTarget:GetPos()
		local schChase = SCHED_TARGET_CHASE
		local curSchChase = self:IsCurrentSchedule( schChase )
		local curDist = math.max( posSelf:Distance( posTarget ) - ( self:OBBMaxs().x + self.m_pFollowTarget:OBBMaxs().x ), 0 )
		local collVar = anplus_follower_collisions:GetBool()

		if !collVar then self:SetOwner( self.m_pFollowTarget ) else self:SetOwner() end

		if !IsValid(self:GetEnemy()) then

			if curDist > followDist then

				self:NavSetGoalTarget( self.m_pFollowTarget, Vector( 0, 0, 0 ) )

				timer.Simple( 0.5, function() 

					if !IsValid(self) || !IsValid(self.m_pFollowTarget) then return end

					if self.m_pFollowTarget:IsPlayer() then

						if !self:HasCondition( 49 ) && ( self:GetNavType() != 2 && !self:IsGoalActive() ) then

							if !self.m_pFollowTarget:Visible( self ) && !self:Visible( self.m_pFollowTarget ) then -- && ( self:HasCondition( 35 ) || !self:HasCondition( 49 ) )

								local getNodeType = self:GetNavType() == 2 && #ANPlusAIGetAirNodes() > 0 && 3 || 2
								local node, dist = ANPlusAIFindClosestNode( posTarget, getNodeType )

								if node && !ANPlusAINodeOccupied( node['pos'] ) && dist <= 512 then
									self:SetPos( node['pos'] + Vector( 0, 0, 10 ) )
								elseif ( !node || dist > 512 ) && IsValid(self:GetOwner()) && self:GetOwner() == self.m_pFollowTarget then
									self:SetPos( posTarget + Vector( 0, 0, 10 )  )
								end

							end

						end
						
					end

				end )

			end	
			if curDist < followDist && curSchChase then
				self:ClearSchedule()
				self:ClearGoal()
				self:StopMoving()		
			elseif curDist >= followDist && curDist < followRunDist then
				if !curSchChase then	
					self:SetLastPosition( posTarget )
					self:SetSchedule( schChase )
				end
				if self:ANPlusSequenceExists( 6 ) then self:SetMovementActivity( 6 ) end
			elseif curDist >= followRunDist then
				if !curSchChase then	
					self:SetLastPosition( posTarget )
					self:SetSchedule( schChase )
				end
				if self:ANPlusSequenceExists( 10 ) then self:SetMovementActivity( 10 ) end
			end	

		elseif IsValid(self:GetEnemy()) && IsValid(self:GetActiveWeapon()) && !ANPlusNoMeleeWithThese[ self:GetActiveWeapon():GetHoldType() ] then	
			
			if curDist < followCombatDist && curSchChase then
				self:ClearSchedule()
				self:ClearGoal()
				self:StopMoving()
			elseif curDist >= followCombatDist && curDist < followCombatRunDist then
				if !curSchChase then	
					self:SetLastPosition( posTarget )
					self:SetSchedule( schChase )
				end				
				if self:ANPlusSequenceExists( 6 ) then self:SetMovementActivity( 6 ) end
			elseif curDist >= followCombatRunDist then
				if !curSchChase then	
					self:SetLastPosition( posTarget )
					self:SetSchedule( schChase )
				end
				if self:ANPlusSequenceExists( 10 ) then self:SetMovementActivity( 10 ) end
			end	

		end	
		
		NPCGiveWay( self )
		
	end)
end

function metaENT:ANPlusNPCGo( vecORent, walkORrun, vecOffset )
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

function metaENT:ANPlusCreateGoalFollow(target, formation)
	if !self:IsNPC() then return end
	local followGoal = ents.Create( "ai_goal_follow" )
	if self:GetChildren() && table.HasValue( self:GetChildren(), followGoal ) then followGoal:Remove() end
	followGoal:SetPos( self:GetPos() )
	followGoal:SetParent( self )
	followGoal:SetOwner( self )
	--followGoal:Spawn()

	followGoal:SetKeyValue( "SearchType", 0 )
	followGoal:SetKeyValue( "goal", target:GetName() )
	followGoal:SetKeyValue( "Formation", formation || 0 )

	local aName = !self:GetName() || self:GetName() == "" && self:GetClass() .. self:EntIndex() || self:GetName()
	self:SetName( aName )
	
	followGoal:SetKeyValue( "actor", self:GetName() )
	--followGoal:Fire( "UpdateActors", "", 1 )
	followGoal:Fire( "Activate", "", 0.1 )
	--followGoal:SetKeyValue( "StartActive", 1 )

	self:DeleteOnRemove( followGoal )
	return followGoal, followGoal:GetInternalVariable( "m_hFollowGoal" )
end

function metaENT:ANPlusFollowPlayer(ply, followDist, followRunDist, followCombatDist, followCombatRunDist)
	if self:Disposition( ply ) != D_LI then
		ANPlusMSGPlayer( ply, self:ANPlusGetName() .. " doesn't like you, therefore it won't follow you.", Color( 255, 50, 0 ), "ANP.UI.Error" )
	elseif !IsValid(self:ANPlusGetFollowTarget()) || ( IsValid(self:ANPlusGetFollowTarget()) && !self:ANPlusGetFollowTarget():IsPlayer() ) || self:ANPlusGetFollowTarget() != ply then
		self:ANPlusFollowTarget( ply, followDist, followRunDist, followCombatDist, followCombatRunDist )
		ANPlusMSGPlayer( ply, self:ANPlusGetKillfeedName() .. " is following you now.", Color( 50, 255, 0 ), "ANP.UI.Click" )
	elseif IsValid(self:ANPlusGetFollowTarget()) && self:ANPlusGetFollowTarget() == ply then
		self:ANPlusFollowTarget()
		ANPlusMSGPlayer( ply, self:ANPlusGetKillfeedName() .. " is no longer following you.", Color( 255, 200, 0 ), "ANP.UI.Error" )
	else
		ANPlusMSGPlayer( ply, self:ANPlusGetKillfeedName() .. " is following someone else.", Color( 255, 50, 0 ), "ANP.UI.Error" )
	end	
end

function metaENT:ANPlusFaceEntity( ent, speed )
	if !IsValid(ent) then return end
		local angleFace = Angle( 0, ( ent:GetPos() - self:GetPos() ):Angle().y, 0 )
	if !speed || speed == 0 then
		self:SetAngles( angleFace )
	else
		self:SetAngles( LerpAngle( FrameTime() * speed, self:GetAngles(), angleFace ) )
	end
end

function metaENT:ANPlusNPCSetRagdollState(bool, wakePos)
	if bool then
		if !IsValid(self:GetNW2Entity( "m_pRagdollStateEnt" )) then 		
			self:SetNW2Entity( "m_pRagdollStateEnt", ents.Create( "prop_ragdoll" ) )
			self:GetNW2Entity( "m_pRagdollStateEnt" ):ANPlusCopyVisualFrom( self )			
			self:GetNW2Entity( "m_pRagdollStateEnt" ):SetPos( self:GetPos() )
			self:GetNW2Entity( "m_pRagdollStateEnt" ):Spawn()
			self:GetNW2Entity( "m_pRagdollStateEnt" ):SetOwner( self )
			self:GetNW2Entity( "m_pRagdollStateEnt" ):SetModelScale( 0.5 )
			self:AddEFlags( 4194304 )
			self:GetNW2Entity( "m_pRagdollStateEnt" ).m_fOwnerS = self:GetSolid()
			self:GetNW2Entity( "m_pRagdollStateEnt" ).m_fOwnerMT = self:GetMoveType()
			self:SetSolid( SOLID_NONE )
			self:SetMoveType( MOVETYPE_NONE )

			for i = 1, 128 do
				local bone = self:GetNW2Entity( "m_pRagdollStateEnt" ):GetPhysicsObjectNum( i )
				if IsValid( bone ) then
					local bonepos, boneang = self:GetBonePosition( self:GetNW2Entity( "m_pRagdollStateEnt" ):TranslatePhysBoneToBone( i ) )
					bone:SetPos( bonepos )
					bone:SetAngles( boneang )
				end
			end
			
			self:SetParent( self:GetNW2Entity( "m_pRagdollStateEnt" ) )
			self:AddEffects( EF_BONEMERGE )
			self:DeleteOnRemove( self:GetNW2Entity( "m_pRagdollStateEnt" ) )
			self:GetNW2Entity( "m_pRagdollStateEnt" ):CallOnRemove( "ANPlus_OnRemove_RagdollState_Free", function( ent )
				if IsValid(ent:GetOwner()) then
					local owner = ent:GetOwner()
					owner:SetParent( nil )
					owner:SetSolid( self:GetNW2Entity( "m_pRagdollStateEnt" ).m_fOwnerS || 2 )
					owner:SetMoveType( self:GetNW2Entity( "m_pRagdollStateEnt" ).m_fOwnerMT || 2 )
					owner:SetPos( ent:GetPos() )
					owner:RemoveEFlags( 4194304 )
				end
			end )
		end
	else
		if IsValid(self:GetNW2Entity( "m_pRagdollStateEnt" )) then 		
			SafeRemoveEntity( self:GetNW2Entity( "m_pRagdollStateEnt" ) )
		end
	end
end

function metaENT:MyVJClass(key)

	if !IsValid(self) || !self.VJ_NPC_Class then return false end

	if key then
		return self.VJ_NPC_Class[ key ]
	else
		for i = 1, #self.VJ_NPC_Class do		
			return self.VJ_NPC_Class[ i ]	
		end
	end

end

function metaENT:SetNPCClass(class, vjClass)
	if isnumber( class ) then self.m_iClass = class end
	if vjClass then
		self.VJ_IsBeingControlled = true -- Fixes relations. 1524 if !entFri && vNPC /*&& MyVisibleTov*/ && !self.DisableMakingSelfEnemyToNPCs && (v.VJ_IsBeingControlled != true) then v:AddEntityRelationship(self, D_HT, 0) end
		self.VJ_NPC_Class = { vjClass }
	end
	--self:SetSaveValue( "m_iClass", class )	
end

function metaENT:ANPlusClassify()
	if !self:IsNPC() && !self:IsPlayer() then return false end
	return self.m_iClass != 0 && self.m_iClass || self:MyVJClass( 1 ) || self:IsPlayer() && ( self.m_iClass != 0 && self.m_iClass || CLASS_PLAYER ) || self:Classify()
end

local iCond = {
	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,69
}

function metaENT:ANPlusPlayActivity(act, speed, movementVel, faceEnt, faceSpeed, callback, postCallback)
	if !act || self:IsNPC() && ( self:GetNPCState() == 6 || self:GetNPCState() == 7 || !self:ANPlusAlive() || self:ANPlusPlayingDeathAnim() ) then return end
	local actSeq = isstring( act ) && self:LookupSequence( act ) || self:SelectWeightedSequence( act )
	local actName = tostring( util.GetActivityNameByID( act ) )
	local actSeqName = self:GetSequenceName( actSeq )
	local gestCheck = string.find( actSeqName, "gesture_" ) || string.find( actSeqName, "g_" ) || string.find( actSeqName, "gest" ) || string.find( string.lower( actName ), "gesture_" ) || string.find( string.lower( actName ), "g_" ) || string.find( string.lower( actName ), "gest" )
	
	local speed = speed || 1
	local facespeed = facespeed || 0
	
	if gestCheck then
		self:SetLayerCycle( 0, 0 )
		self:RestartGesture( act, true, true )
		--self:AddGestureSequence( actSeq, true )
		--self:SetLayerCycle( 0, 0 )
		self:SetLayerWeight( 0, 10 )
	else
		self:SetCycle( 0 )
		self:TaskComplete()
		self:ClearGoal()
		self:ClearSchedule()		
		self:ClearCondition( 68 )
		self:SetCondition( 67 )
		self:SetCondition( 70 )
		--self:SetIgnoreConditions( iCond, 67 )
		
		self.m_flDefCaps = self.m_flDefCaps || self:CapabilitiesGet()
		self:CapabilitiesClear()
		if movementVel && self:GetMoveType() == 3 then 
			self.m_fIdealMoveType = self.m_fIdealMoveType || self:GetMoveType()
			self:SetMoveType( 5 ) 
		end
		
		self:ResetSequence( actSeq )
		self:SetIdealActivity( ACT_DO_NOT_DISTURB )
	end
	
	self.m_bANPlusPlayingActivity = true
	
	local seqName = self:GetSequenceName( gestCheck && actSeq || self:GetSequence() )
	local seqID, seqDur = self:LookupSequence( seqName )	
	--self:SetKeyValue( "sequence", seqID )
	local seqSpeed = self:GetSequenceGroundSpeed( seqID )
	seqDur = ( seqDur / speed )

	self:ANPlusSetNextFlinch( seqDur )

	if isfunction( callback ) then
		callback( seqID, seqDur, seqSpeed )
	end

	timer.Create( "ANP_ACT_RESET" .. self:EntIndex(), seqDur, 1, function() 
		if !IsValid(self) then return end			
		self.m_bANPlusPlayingActivity = false

		if !gestCheck then
		
			self:ClearCondition( 67 )
			self:ClearCondition( 70 )
			self:SetCondition( 68 )
			--self:SetActivity( 0 )
			self:SetIdealActivity( 0 )
			--self:RemoveIgnoreConditions()

			self:CapabilitiesAdd( self.m_flDefCaps || 0 )
			if movementVel && self.m_fIdealMoveType then 
				self:SetMoveType( self.m_fIdealMoveType )
			end
			
		end
		
		if isfunction( postCallback ) then
			postCallback( seqID, seqDur )
		end
		
	end)

	timer.Create( "ANP_ACT_THINK" .. self:EntIndex(), 0, 0, function() 
		if !IsValid(self) || !self:ANPlusPlayingAnim() then return end
		
		--self:SetCondition( 70 )
		self:SetIdealActivity( ACT_DO_NOT_DISTURB )

		if !gestCheck then

			local gravFix = self.m_fIdealMoveType == 3 && !self:OnGround() && Vector( 0, 0, -500 ) || vector_zero
			
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
		if IsValid(faceEnt) && faceSpeed && faceSpeed >= 0 then 
			self:ANPlusFaceEntity( faceEnt, faceSpeed )
		end
	end)
	
end
 
function metaENT:ANPlusPlayScene(scene, speed, stopMoving, faceEnt, faceSpeed, callback, postCallback)
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

function metaENT:ANPlusPlaySequence(seq, speed, stopMoving, faceEnt, faceSpeed, callback, postCallback)
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

function metaENT:ANPlusDoDeathAnim(dmginfo, act, speed, movementVel, atHPLevel, dmgMin, dmgMax, chance, interruptible, preCallback, postCallback)
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

function metaENT:ANPlusGetSquadMembers(callback)

	if self:GetSquad() == nil || self:GetSquad() == "" then return false end

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

function metaENT:ANPlusGetSquadSlot()
	return self:GetInternalVariable( "m_iMySquadSlot" )
end
-- Half-Life:Source squad system is busted af, need to make my own.
function metaENT:ANPlusAddToCSquad(squad)
	if !ANPlusCustomSquads[squad] then ANPlusCustomSquads[squad] = {} end
	ANPlusTableDeNull( ANPlusCustomSquads[squad] ) -- Remove NULL NPCs
	if !table.HasValue( ANPlusCustomSquads[squad], self ) then
		table.insert( ANPlusCustomSquads[squad], self )
		if !ANPlusCustomSquads[squad]['leader'] then ANPlusCustomSquads[squad]['leader'] = self end
		self.m_tbANPCSquad = ANPlusCustomSquads[squad] 
	end
end

function metaENT:ANPlusCSquadGetLeader(squad)
	if squad && ANPlusCustomSquads[squad] then
		return ANPlusCustomSquads[squad]['leader']
	elseif !squad then	
		if self:ANPlusGetCSquad() then return self:ANPlusGetCSquad()['leader'] end
	end
end

function metaENT:ANPlusGetCSquad()
	for k, v in pairs( ANPlusCustomSquads ) do
		if v && table.HasValue( v, self ) then return v end
	end
end

function metaENT:ANPlusGetCSquadMembers(callback)
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

function metaENT:ANPlusRemoveFromCSquad(squad)
	if ANPlusCustomSquads[squad] && table.HasValue( ANPlusCustomSquads[squad], self ) then table.RemoveByValue( ANPlusCustomSquads[squad], self ) end
end			

function metaENT:ANPlusOverrideMoveSpeed(speed, rate, respectGoal)
	if speed != 1 && ( !respectGoal || ( respectGoal && self:IsGoalActive() && self:GetPathDistanceToGoal() > 10 * speed ) ) && ( ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 1 ) && self:OnGround() ) || ( self:GetMoveType() == 3 && self:ANPlusCapabilitiesHas( 4 ) ) || ( self:GetMoveType() == 6 ) ) && self:ANPlusIsMoveSpeed( 1, 1 ) then			
		
		local lastMovTime = self:GetInternalVariable( "m_flTimeLastMovement" )
		self:SetSaveValue( "m_flTimeLastMovement", lastMovTime * speed )	
				
	end	
	if rate != 1 then self:SetPlaybackRate( rate ) end
end

function metaENT:ANPlusReplaceActOther(act, speed, actRep)	
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

function metaENT:ANPlusGetEnemies()

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

function metaENT:ANPlusGetGestureSequence()	-- Seq and Layer
	local gest
	local lay
	for i = 0, 5 do
		if self:GetLayerSequence( i ) && self:GetLayerSequence( i ) > 0 then
			gest = self:GetLayerSequence( i )
			lay = i
			break
		end
	end
	return gest, lay || false
end

function metaENT:ANPlusGetGestureActivity()	-- ACT and Layer
	local gest
	local lay
	for i = 0, 5 do
		if self:GetLayerSequence( i ) && self:GetLayerSequence( i ) > 0 then
			gest = self:GetLayerSequence( i )
			lay = i
			break
		end
	end
	return gest && self:GetSequenceActivity( gest ), lay || false
end

function metaENT:ANPlusGetIdealSequence()
	if !self:GetInternalVariable( "m_nIdealSequence" ) then return nil end
	return self:GetInternalVariable( "m_nIdealSequence" )
end

function metaENT:ANPlusSetIdealSequence(seq)
	if !self:GetInternalVariable( "m_nIdealSequence" ) then return nil end
	seq = isstring( seq ) && self:LookupSequence( seq ) || seq
	self:SetSaveValue( "m_nIdealSequence", seq )
end

function metaENT:ANPlusGetIdealWeaponActivity()
	if !self:GetInternalVariable( "m_IdealWeaponActivity" ) then return nil end
	return self:GetInternalVariable( "m_IdealWeaponActivity" )
end

function metaENT:ANPlusSetIdealWeaponActivity(act)
	if !self:GetInternalVariable( "m_IdealWeaponActivity" ) then return nil end
	self:SetSaveValue( "m_IdealWeaponActivity", act )
end

function metaENT:ANPlusSetIdealTranslatedActivity(act)
	if !self:GetInternalVariable( "m_IdealTranslatedActivity" ) then return nil end
	self:SetSaveValue( "m_IdealTranslatedActivity", act )
end

function metaENT:ANPlusGetTranslatedActivity()
	if !self:GetInternalVariable( "m_translatedActivity" ) then return nil end
	return self:GetInternalVariable( "m_translatedActivity" )
end

function metaENT:ANPlusSetTranslatedActivity(act)
	if !self:GetInternalVariable( "m_translatedActivity" ) then return nil end
	self:SetSaveValue( "m_translatedActivity", act )
end

function metaENT:ANPlusGetNextFlinch()
	if !self:GetInternalVariable( "m_flNextFlinchTime" ) then return nil end
	return self:GetInternalVariable( "m_flNextFlinchTime" )
end

function metaENT:ANPlusSetNextFlinch(value)
	if !self:GetInternalVariable( "m_flNextFlinchTime" ) then return nil end
	self:SetSaveValue( "m_flNextFlinchTime", value )
end

function metaENT:SetIdealMoveSpeed(val)
	self:SetSaveValue( "m_flGroundSpeed", val )
end

function metaENT:ANPlusClearTarget()
	self:SetSaveValue( "m_hTargetEnt", NULL )
end

function metaENT:ANPlusIsNPCCrouching()
	local actName = self:GetSequenceActivityName( self:GetSequence() )
	local check1 = string.find( actName:lower(), "_crouch" )
	local check2 = string.find( actName:lower(), "_low" )
	if check1 || check2 then return true end
	return false
end

function metaENT:ANPlusGetSquadName()
	return self:GetKeyValues().squadname || false
end

function metaENT:ANPlusPlayingDeathAnim()
	return self.m_bDeathAnimPlay
end

function metaENT:ANPlusPlayingAnim()
	return self.m_bANPlusPlayingActivity
end

function metaENT:ANPlusBlockSchedule(sched)
	if self:IsCurrentSchedule( sched ) then self:TaskComplete(); self:SetCycle( 1 ); self:ClearSchedule() end
end

function metaENT:ANPlusReplaceSchedule(oldSched, newSched)
	if self:IsCurrentSchedule( oldSched ) then
		if !newSched then
			self:TaskComplete(); self:ClearSchedule(); self:SetCycle( 1 ) 
		else
			self:SetSchedule( newSched )
		end
	end
end

function metaENT:ANPlusGetLastPosition()
	return self:GetInternalVariable( "m_vecLastPosition" )
end