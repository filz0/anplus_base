local metaENT = FindMetaTable("Entity")

hook.Add( "Initialize", "ANPlusLoad_GamemodeInitialize", function()
	function GAMEMODE:PlayerDeath( ply, inflictor, attacker ) -- If you know a better way of doing this, please tell me :(

		-- Don't spawn for at least 2 seconds
		ply.NextSpawnTime = CurTime() + 2
		ply.DeathTime = CurTime()

		if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end

		if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
			attacker = attacker:GetDriver()
		end

		if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
			inflictor = attacker
		end

		-- Convert the inflictor to the weapon that they're holding if we can.
		-- This can be right or wrong with NPCs since combine can be holding a
		-- pistol but kill you by hitting you with their arm.
		if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then

			inflictor = inflictor:GetActiveWeapon()
			if ( !IsValid( inflictor ) ) then inflictor = attacker end

		end

		player_manager.RunClass( ply, "Death", inflictor, attacker )

		if ( attacker == ply ) then

			net.Start( "PlayerKilledSelf" )
				net.WriteEntity( ply )
			net.Broadcast()

			MsgAll( attacker:Nick() .. " suicided!\n" )

		return end

		if ( attacker:IsPlayer() ) then
			
			local anpInf = inflictor:IsANPlus(true) && inflictor:ANPlusGetDataTab()['Name'] || inflictor:GetClass()
			
			net.Start( "PlayerKilledByPlayer" )

				net.WriteEntity( ply )
				net.WriteString( anpInf )
				net.WriteEntity( attacker )

			net.Broadcast()

			MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )

		return end

		net.Start( "PlayerKilled" )
			
			local anpInf = inflictor:IsANPlus(true) && inflictor:ANPlusGetDataTab()['Name'] || inflictor:GetClass()
			local anpAtt = attacker:IsANPlus(true) && attacker:ANPlusGetDataTab()['Name'] || attacker:GetClass()
			
			net.WriteEntity( ply )
			net.WriteString( anpInf )
			net.WriteString( anpAtt )

		net.Broadcast()

		MsgAll( ply:Nick() .. " was killed by " .. anpAtt .. "\n" )

	end

	function GAMEMODE:OnNPCKilled( ent, attacker, inflictor )

		-- Don't spam the killfeed with scripted stuff
		if ( ent:GetClass() == "npc_bullseye" || ent:GetClass() == "npc_launcher" ) then return end

		if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ent end
		
		if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
			attacker = attacker:GetDriver()
		end

		if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
			inflictor = attacker
		end
		
		-- Convert the inflictor to the weapon that they're holding if we can.
		if ( IsValid( inflictor ) && attacker == inflictor && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then
		
			inflictor = inflictor:GetActiveWeapon()
			if ( !IsValid( attacker ) ) then inflictor = attacker end
		
		end
		
		local InflictorClass = "worldspawn"
		local AttackerClass = "worldspawn"
		
		if ( IsValid( inflictor ) ) then InflictorClass = inflictor:GetClass() end
		if ( IsValid( attacker ) ) then

			AttackerClass = attacker:GetClass()

			-- If there is no valid inflictor, use the attacker (i.e. manhacks)
			if ( !IsValid( inflictor ) ) then InflictorClass = attacker:GetClass() end

			if ( attacker:IsPlayer() ) then
				
				local anpVic = ent:IsANPlus() && ent:ANPlusGetDataTab()['Name'] || ent:GetClass()
				
				net.Start( "PlayerKilledNPC" )
			
					net.WriteString( anpVic )
					net.WriteString( InflictorClass )
					net.WriteEntity( attacker )
			
				net.Broadcast()

				return
			end

		end

		if ( ent:GetClass() == "npc_turret_floor" ) then AttackerClass = ent:GetClass() end
		
			local anpVic = ent:IsANPlus() && ent:ANPlusGetDataTab()['Name'] || ent:GetClass()
			local anpInf = inflictor:IsANPlus(true) && inflictor:ANPlusGetDataTab()['Name'] || InflictorClass
			local anpAtt = attacker:IsANPlus(true) && attacker:ANPlusGetDataTab()['Name'] || AttackerClass
			
		net.Start( "NPCKilledNPC" )
		
			net.WriteString( anpVic )
			net.WriteString( anpInf )
			net.WriteString( anpAtt )
		
		net.Broadcast()

	end
end)

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
	
	local v = ANPlusAIGetNodes( iType )[ math.random( 1, #ANPlusAIGetNodes( iType ) ) ]
	
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

function metaENT:ANPlusHasEntLOS(ent) -- Big credit to the Captain Applesauce for this piece of work https://steamcommunity.com/profiles/76561198070248149

	if !IsValid(self) then return end
	
	local currENT = self

	if ( ( !IsValid(currENT) ) || ( ( !currENT:IsPlayer() ) && ( !currENT:IsNPC() ) ) ) then
	
		return false
		
	end

	local posOffset = ent:GetAngles():Up() * ent:BoundingRadius()

	local traceBlocked = false

	local exclusions = { ent }

	if ( currENT && IsValid(currENT) ) then
	
		table.insert( exclusions, currENT )
		
	end

		local tr = util.TraceLine(
		{
			start     = currENT:EyePos(),
			endpos     = ent:GetPos() + posOffset,
			filter     = exclusions,
			mask     = MASK_OPAQUE
		})
	
		traceBlocked = tr.Hit

	return ( !traceBlocked )

end

function metaENT:ANPlusVisibleInFOV(ent, fovmul, npcfov) -- Big credit to the Captain Applesauce for this piece of work https://steamcommunity.com/profiles/76561198070248149

	if !IsValid(self) then return end
	
	local function crossDist( vec1, vec2 )
	
		return math.sqrt( vec1:LengthSqr() * vec2:LengthSqr() - vec1:Dot( vec2 )^2 )
		
	end

	local function arctan2( y, x )
	
		if ( ( x != 0 ) || ( y != 0 ) ) then
		
			if ( math.abs( x ) >= math.abs( y ) ) then
			
				if ( x >= 0 ) then
				
					return math.atan( y / x )
					
				elseif ( y >= 0 ) then
				
					return math.atan( y / x ) + math.pi
					
				else
				
					return math.atan( y / x ) - math.pi
					
				end
				
			elseif ( y >= 0 ) then
			
				return math.pi / 2 - math.atan( x / y )
				
			else
			
				return -math.pi / 2 - math.atan( x / y )
				
			end
			
		else
		
			return 0.0
			
		end
		
	end

	local currENT = self

	if ( ( !currENT:IsValid() ) || ( ( !currENT:IsPlayer() ) && ( !currENT:IsNPC() ) ) ) then
	
		return false
		
	end
	
		if self:ANPlusHasEntLOS( ent ) then
		
			local posOffset = ent:GetAngles():Up() * ent:BoundingRadius()
		
			if currENT:IsPlayer() && currENT:ANPlusAlive() then
				
				local disp = ent:GetPos() + posOffset - currENT:EyePos()
					
				local radius = ent:BoundingRadius()
				
				if ( ( disp:LengthSqr() > ( radius^2 ) ) && ( disp:LengthSqr() > 0 ) ) then
					
					local fov = currENT:GetFOV() * ( fovmul || 1.5 )

				
					local distSqr = disp:LengthSqr()
					local aimVec = currENT:GetEyeTraceNoCursor().Normal
					
					local dir = disp:GetNormalized()
					local viewRadius = arctan2( radius / math.sqrt( distSqr ), math.sqrt( 1 - radius^2 / distSqr ) ) * 180 / math.pi
					local viewOffset = arctan2( crossDist( dir, aimVec ), dir:Dot( aimVec ) ) * 180 / math.pi
					
					if ( viewOffset <= ( fov / 2 + viewRadius ) ) then
						
						return true
							
					end
						
				else
					
					return true
						
				end
				
			elseif currENT:IsNPC() && currENT:ANPlusAlive() then
			
				local disp = ent:GetPos() + posOffset - currENT:EyePos()
				
				local radius = ent:BoundingRadius()
			
				if ( ( disp:LengthSqr() > ( radius^2 ) ) && ( disp:LengthSqr() > 0 ) ) then
				
					local fov = npcfov || 90
					local distSqr = disp:LengthSqr()
					local aimVec = currENT:GetAimVector()
					local dir = disp:GetNormalized()
					local viewRadius = arctan2( radius / math.sqrt( distSqr ), math.sqrt( 1 - radius^2 / distSqr ) ) * 180 / math.pi
					local viewOffset = arctan2( crossDist( dir, aimVec ), dir:Dot( aimVec) ) * 180 / math.pi
				
					if ( viewOffset <= ( fov / 2 + viewRadius ) ) then
					
						return true
						
					end
					
				else
				
					return true
					
				end
				
			end
			
		end

	return false

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

function ANPlusEmitUISound( ply, snd, vol )	
	if !ply then return end	
	ANPlusSoundDuration(snd)
	net.Start( "anplus_play_ui_snd" )
	net.WriteString( snd || "" )
	net.WriteFloat( vol || 100 )
	if isbool( ply ) then
		net.Broadcast()
	elseif ply:IsPlayer() then
		net.Send( ply )
	end	
end

function ANPlusScreenMsg(ply, x, y, size, dur, text, font, color)	
	net.Start("anplus_screenmsg_ply")
	net.WriteFloat( dur || 0 )
	net.WriteFloat( x || 0 )
	net.WriteFloat( y || 0 )
	net.WriteFloat( size || 10 )
	net.WriteString( font || "DermaDefault" )
	net.WriteColor( color || Color( 255, 255, 255 ) )
	net.WriteString( text || "" )
	if isbool( ply ) then
		net.Broadcast()
	elseif ply:IsPlayer() then
		net.Send( ply )
	end			
end

function ANPlusMSGPlayer( ply, text, color, snd )	
	if !ply || !text then return end	
	net.Start( "anplus_chatmsg_ply" )
	net.WriteString( snd || "" )
	net.WriteColor( color || Color( 255, 255, 255 ) )
	net.WriteString( text )
	if isbool( ply ) then
		net.Broadcast()
	elseif ply:IsPlayer() then
		net.Send( ply )
	end
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

function metaENT:ANPlusUnParentFromBone(ent, bone, solid, collisiongroup, physinit, movetype)

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
	ent:DontDeleteOnRemove( self )
	
end

function metaENT:ANPlusParent(ent, att, pos, ang)
	
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
	
	ent:DeleteOnRemove( self )

end

function metaENT:ANPlusParentToBone(ent, bone, pos, ang)
	
	local oldPI = self:GetSolid()
	local oldMT = self:GetMoveType()
	local oldS = self:GetSolid()
	
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	
	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )

	local boneid = ent:LookupBone( bone )

	if !boneid then return end	
	
	local matrix = ent:GetBoneMatrix( boneid )
			
	if !matrix then return end
			
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )	

	self:FollowBone( ent, boneid )	
	self:SetPos( newPos )
	self:SetAngles( newAng )	
	
	self:PhysicsInit( oldPI )
	self:SetMoveType( oldMT )
	self:SetSolid( oldS )
	
	ent:DeleteOnRemove( self )

end

function metaENT:ANPlusSetToBonePosAndAng(ent, bone, pos, ang)

	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )
	local boneid = ent:LookupBone( bone )
	
	if !boneid then return end	
	
	local matrix = ent:GetBoneMatrix( boneid )	
	
	if !matrix then return end	
	
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )	
		
	self:SetPos( newPos )
	self:SetAngles( newAng )	
end

function metaENT:ANPlusGetBonePosAndAng(bone, pos, ang)

	local offsetPos = pos || Vector( 0, 0, 0 )
	local offsetAng = ang || Angle( 0, 0, 0 )
	local boneid = self:LookupBone( bone )
	
	if !boneid then return end	
	
	local matrix = self:GetBoneMatrix( boneid )	
	
	if !matrix then return end	
	
	local newPos, newAng = LocalToWorld( offsetPos, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )		
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

function ANPlusCreateParticle(particle, startDelay, killDelay)
	local ent = ents.Create( "sent_anp_particlebase" )
	ent.Particle = particle
	ent.StartDelay = startDelay || 0
	ent.KillDelay = killDelay || 0
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

function metaENT:ANPlusNPCGetImprovedAiming(pos, target, aimpos)
	local newPos = IsValid(target) && self:ANPlusInRange( target, 16384 ) && pos || self:WorldSpaceCenter()	
	local targetPos = ( aimpos || target:BodyTarget( newPos ) || target:WorldSpaceCenter() || target:GetPos() )
	local dir = targetPos && ( targetPos - newPos ):GetNormalized() || self:GetAimVector()
	return newPos, dir
end

function metaENT:ANPlusRemoveSpotlight()
	if !IsValid(self) then return end
	self:Fire("KillHierarchy") -- Never use anything else to remove "beam_spotlight"!
end

function metaENT:ANPlusDissolve(attacker, inflictor, dtype)

	if self:IsPlayer() then
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage(self:Health())
		dmgInfo:SetAttacker(attacker)
		dmgInfo:SetInflictor(inflictor)
		dmgInfo:SetDamageType(DMG_DISSOLVE)
		dmgInfo:SetDamagePosition(self:GetPos())
		self:TakeDamageInfo(dmgInfo)
		return
	end
	
	attacker = attacker || self
	inflictor = inflictor || self
	local _sName = self:GetName()
	local sName = _sName
	
	if string.len(sName) == 0 then
		sName = "entDissolve" .. self:EntIndex() .. "_entTarget"
		self:SetName(sName)
	end
	
	local entDissolver = ents.Create("env_entity_dissolver")
	entDissolver:SetKeyValue("dissolvetype", dtype || 2)
	entDissolver:Spawn()
	entDissolver:Activate()
	entDissolver:SetOwner(attacker)
	entDissolver:Fire("Dissolve", sName, 0)
	self:TakeDamage(self:Health(), attacker, inflictor)
	
	timer.Simple(0, function()
	
		if IsValid(entDissolver) then entDissolver:Remove() end
		if IsValid(self) then self:SetName(_sName) end
		
	end)
	
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

function metaENT:ANPlusGetSquadName()
	return self:GetKeyValues().squadname || false
end