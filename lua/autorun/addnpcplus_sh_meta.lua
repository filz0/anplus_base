------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local metaANG = FindMetaTable("Angle")
local metaVEC = FindMetaTable("Vector")
local metaENT = FindMetaTable("Entity")
local metaVEH = FindMetaTable("Vehicle")
local metaPLAYER = FindMetaTable("Player")
--

--[[////////////////////////
||||| Returns the current branch of your game, also server side.
||||| The possible outputs are: unknown (None), dev, prerelease and x86-64
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function ANPlusGMODBranch()
	return CLIENT && BRANCH || SERVER && SV_BRANCH
end

--[[////////////////////////
||||| Clamps the given angle...
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaANG:ANPlusClamp()
	while self.p < 0 do self.p = self.p +360 end
	while self.y < 0 do self.y = self.y +360 end
	while self.r < 0 do self.r = self.r +360 end
	
	while self.p > 360 do self.p = self.p -360 end
	while self.y > 360 do self.y = self.y -360 end
	while self.r > 360 do self.r = self.r -360 end
end

function metaANG:ANPlusIsEqualTol(ang)
	local angToVal1 = self.p + self.y + self.r
	local angToVal2 = ang.p + ang.y + ang.r
	angToVal1 = math.Round( angToVal1, 0 )
	angToVal2 = math.Round( angToVal2, 0 )
	return angToVal1 == angToVal2
end

--[[////////////////////////
||||| Can be used to display dev messages in the console (tables too) at set developer command levels.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function ANPdevMsg(arg, lvl)
	if GetConVar("developer"):GetFloat() != lvl then return end
	if istable(arg) then
		PrintTable(arg)
	else
		MsgN(arg)
	end
end

function ANPdev(func, lvl)
	if GetConVar("developer"):GetFloat() != lvl then return end
	if isfunction( func ) then func() end
end

--[[////////////////////////
||||| QOL function that runs only when rolled value is equal || lower than the given value.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function ANPlusPercentageChance(chance)
	local lucky = math.random( 1, 100 )
	return lucky <= chance
end

--[[////////////////////////
||||| Taken from SilverlanBase. Probably obsolite. Sill works.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusGetAngleToPos(pos, _ang, bDontClamp)
	local _pos
	if self:IsPlayer() then
		_ang = _ang || self:GetAimVector():Angle()
		_pos = self:GetShootPos()	
	else
		_ang = _ang || self:GetAngles()
		_pos = self:GetPos()
	end
	local ang = _ang -(pos -_pos):Angle()
	if !bDontClamp then ang:ANPlusClamp() end
	return ang	
end
--[[

function metaENT:ANPlusValidAngles(pos, angTab)
	local selfPos = self:GetPos()
	local aimDir = self:GetAngles()
	local pitch = self:ANPlusGetAngleToPos( pos, aimDir ).p
	local yaw = self:ANPlusGetAngleToPos( pos, aimDir ).y
	local roll = self:ANPlusGetAngleToPos( pos, aimDir ).r
	local validAng = ( ( ( pitch <= ( 0 + angTab.Pitch ) && pitch >= 0 ) || ( pitch <= 360 && pitch >= ( 360 - angTab.Pitch ) ) ) && ( ( yaw <= ( 0 + angTab.Yaw ) && yaw >= 0 ) || ( yaw <= 360 && yaw >= ( 360 - angTab.Yaw ) ) ) && ( ( roll <= ( 0 + angTab.Roll ) && roll >= 0 ) || ( roll <= 360 && roll >= ( 360 - angTab.Roll ) ) ) )
	print(pitch, yaw, roll)
	return validAng
end


function metaENT:ANPlusValidAngles(pos, angTab)
	local selfPos = self:GetPos()
	local aimDir = self:GetAngles()
	local tarDir = Vector( pos - selfPos ):Angle()
	local dirAng = Angle( math.abs( aimDir.p - tarDir.p ), math.abs( aimDir.y - tarDir.y ), math.abs( aimDir.r - tarDir.r ) )
	local validAng = ( ( ( dirAng.p <= ( 0 + angTab.Pitch ) && dirAng.p >= 0 ) || ( dirAng.p <= 360 && dirAng.p >= ( 360 - angTab.Pitch ) ) ) && ( ( dirAng.y <= ( 0 + angTab.Yaw ) && dirAng.y >= 0 ) || ( dirAng.y <= 360 && dirAng.y >= ( 360 - angTab.Yaw ) ) ) && ( ( dirAng.r <= ( 0 + angTab.Roll ) && dirAng.r >= 0 ) || ( dirAng.r <= 360 && dirAng.r >= ( 360 - angTab.Roll ) ) ) )
	print(dirAng)
	return validAng
end
]]--

--[[////////////////////////
||||| So... This function can be used to ensure... Uh... Okay. Let's say that We have a piece of code that We want to run only when something is on the right side of our NPC... Something like that. This is the thing You wanna use.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

/*
local angTab = {
	['Pitch'] 	= { 70, -70 },
	['Yaw'] 	= { 45, -45 },
	['Roll'] 	= { 180, -180 },
}
*/

function metaENT:ANPlusValidAnglesNormal(pos, full360)
	local sPos, sAng = self:GetPos(), self:GetAngles()	
	local aimDir = ( pos - sPos ):Angle()
	local pitch = math.Round( math.NormalizeAngle( sAng.p - aimDir.p ) * 1000 ) / 1000	
	local yaw = math.Round( math.NormalizeAngle( sAng.y - aimDir.y ) * 1000 ) / 1000	
	local roll = math.Round( math.NormalizeAngle( sAng.r - aimDir.r ) * 1000 ) / 1000	
	local validAng = ( ( ( pitch <= ( full360.Pitch[ 1 ] ) && pitch >= full360.Pitch[ 2 ] ) ) && ( ( yaw <= ( full360.Yaw[ 1 ] ) && yaw >= ( full360.Yaw[ 2 ] ) ) ) && ( ( roll <= ( full360.Roll[ 1 ] ) && roll >= full360.Roll[ 2 ] ) ) )
	ANPdevMsg( "ValidAnglesNormal: "..pitch.." "..yaw.." "..roll.." "..tostring(validAng), 2 )
	return validAng
end

function metaENT:ANPlusGetAngPosRelated(pos)
	local ang = self:GetAngles()
	local angCalc = ( pos - self:GetPos() ):Angle()
	local x = math.NormalizeAngle( ang.x - angCalc.x )
	local y = math.NormalizeAngle( ang.y - angCalc.y )
	local z = math.NormalizeAngle( ang.z - angCalc.z )
	return x, y, z
end

function ANPlusNormalizeAngle(ang1, ang2)
	local pitch = math.Round( math.NormalizeAngle( ang1.p - ang2.p ) * 1000 ) / 1000	
	local yaw = math.Round( math.NormalizeAngle( ang1.y - ang2.y ) * 1000 ) / 1000	
	local roll = math.Round( math.NormalizeAngle( ang1.r - ang2.r ) * 1000 ) / 1000
	return Angle( pitch, yaw, roll )
end

--[[////////////////////////
||||| Used to get Activities from Sequences.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusTranslateSequence(anim)
	if isstring( anim ) then
		local result = self:GetSequenceActivity( self:LookupSequence( anim ) )	
		if result == nil || result == -1 then	
			return false			
		else		
			return result			
		end		
	elseif isnumber( anim ) then 	
		return anim		
	else	
		return false		
	end	
end

function metaENT:ANPlusSequenceExists(anim)
	if anim == nil || isbool(anim) then return false end	
	if isnumber( anim ) then
		if ( self:SelectWeightedSequence( anim ) == -1 || self:SelectWeightedSequence( anim ) == 0 ) && ( self:GetSequenceName( self:SelectWeightedSequence( anim ) ) == "Not Found!" || self:GetSequenceName( self:SelectWeightedSequence( anim ) ) == "No model!" ) then
			return false
		end
	elseif isstring( anim ) then
		if self:LookupSequence( anim ) == -1 then return false end
	end
	return anim 
end

--[[////////////////////////
||||| Used to reset Entity's bones.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusResetBone()	
	local bonecount = self:GetBoneCount()	
	for i = 0, bonecount do	
		self:ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
		self:ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
		self:ManipulateBoneScale( i, Vector( 1, 1, 1 ) )
		self:ManipulateBoneJiggle( i, 0 )	
		if (SERVER) then
			net.Start("anplus_fix_bones")
			net.WriteEntity( self )
			net.Broadcast()	
		else	
			self:SetupBones()
		end		
	end
end

--[[////////////////////////
||||| Used to edit Entity's bones.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusEditBone(tab)	
	if !tab then return end	
	self:ANPlusResetBone()	
	timer.Simple(0, function()
		if !IsValid(self) then return end
		for bone, params in pairs(tab) do
		
			local boneid = isnumber( bone ) && bone || self:LookupBone( bone )	
			
			if boneid then	
				self:ManipulateBonePosition( boneid, params.pos || Vector( 0, 0, 0 ) )
				self:ManipulateBoneAngles( boneid, params.ang || Angle( 0, 0, 0 ) )
				self:ManipulateBoneScale( boneid, params.scl || Vector( 1, 1, 1 ) )
				self:ManipulateBoneJiggle( boneid, params.jiggle || 0 )					
			end		
		end		
		if (SERVER) then
			net.Start("anplus_fix_bones")
			net.WriteEntity( self )
			net.Broadcast()	
		else	
			self:SetupBones()
		end		
	end)	
end

--[[////////////////////////
||||| Used to get the pos, ang && bone of the given hitgroup.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusGetHitGroupBone( hg )	
	local numHitBoxSets = self:GetHitboxSetCount()
	if numHitBoxSets then
		for hboxset = 0, numHitBoxSets - 1 do	
			local numHitBoxes = self:GetHitBoxCount( hboxset )  
			for hitbox = 0, numHitBoxes - 1 do	
				if self:GetHitBoxHitGroup( hitbox, hboxset ) == hg then	
					local bone = self:GetHitBoxBone( hitbox, hboxset )			
					if ( !bone || bone < 0 ) then return false end			
					local pos, ang = self:GetBonePosition( bone )
					return pos, ang, bone			
				end			
			end		
		end	
	end
	return nil, -1	
end

--[[////////////////////////
||||| Used to get duration of sound files. (doesn't work well with .mp3)
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function ANPlusSoundDuration(strfile) -- We want to round the sound duration.
	local sounddur = SoundDuration( strfile )
	if sounddur then
		sounddur = math.Round( sounddur * 1000 ) / 1000	
	end	
	ANPdevMsg( "[" .. strfile .. "]" .. " duration: " .. sounddur, 1 )	
	return sounddur	
end

--[[////////////////////////
||||| QOL function to check if Entity is in given distance to our Entity
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusInRange(target, dist)
	local distSqr = dist * dist
	local distTSqr = self:GetPos():DistToSqr( target:GetPos() ) <= distSqr
	return distTSqr
end

function metaENT:ANPlusGetRange(target)
	local distTSqr = self:GetPos():DistToSqr( target:GetPos() )
	local dist = math.sqrt( distTSqr )
	dist = math.Round( dist )
	return distTSqr, dist
end

--[[////////////////////////
||||| Similar to ANPlusInRange but for Vectors (positions).
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function ANPlusInRangeVector(pos1, pos2, dist)
	local distSqr = dist * dist
	local distTSqr = pos1:DistToSqr( pos2 ) <= distSqr
	return distTSqr
end

function ANPlusGetRangeVector(pos1, pos2)
	local distTSqr = pos1:DistToSqr( pos2 )
	local dist = math.sqrt( distTSqr )
	dist = math.Round( dist )
	return distTSqr, dist
end

--[[////////////////////////
||||| Check if given Entity is from this base.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:IsANPlus(alsoENT)		
	if self:IsNPC() && self:ANPlusGetDataTab() then 	
		return true		
	elseif alsoENT && self:ANPlusGetDataTab() then 	
		return true		
	else		
		return false		
	end
end

function metaENT:ANPlusIsSpawned()
	if self:GetKeyValues() && self:GetKeyValues()['anpinitialspawn'] then return true end
	return false
end

--[[////////////////////////
||||| Used to check if Entity is alive.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function metaENT:ANPlusAlive()
	if IsValid(self) && !self.m_bDeathAnimPlay && ( ( ( self:IsNPC() && ( ( (SERVER) && !self:ANPlusPlayingDeathAnim() && self:GetNPCState() != 7 ) || ( (CLIENT) && self:Health() > 0 ) ) ) || ( self:IsPlayer() && self:Alive() ) ) || ( self:GetMaxHealth() >= 0 && self:Health() > 0 ) || ( !self:IsNPC() && !self:IsPlayer() && self:GetMaxHealth() == 0 && self:Health() == 0 ) ) then
		return true		
	else	
		return false		
	end
end

--[[////////////////////////
||||| Remove NULL Entities for a given table.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

function ANPlusTableDeNull(tab)
	for k, v in pairs( tab ) do
		if !IsValid(v) then 
			if isnumber( k ) then
				table.remove( tab, k ) 
			else
				table.RemoveByValue( tab, v ) 
			end
		end
	end
end

function metaENT:ANPlusGetDataTab()
	if self:GetTable() && self:GetTable()['ANPlusData'] then
		return self:GetTable()['ANPlusData']
	else
		return nil
	end
end

function metaENT:ANPlusGetSaveTab()
	if self:GetTable() && self:GetTable()['m_tSaveData'] then
		return self:GetTable()['m_tSaveData']
	else
		return nil
	end
end

local SIZEOF_INT = 4
local SIZEOF_SHORT = 2
local AINET_VERSION_NUMBER = 37
local NUM_HULLS = 10

local function toUShort(b)

	local i = { string.byte( b, 1, SIZEOF_SHORT ) }
	
	return i[1] + i[2] * 256
	
end

local function toInt(b)

	local i = { string.byte( b, 1, SIZEOF_INT) }
	
	i = i[1] + i[2] * 256 + i[3] * 65536 + i[4] * 16777216
	
	if ( i > 2147483647 ) then return i -4294967296 end
	
	return i
	
end

local function ReadInt(f) return toInt( f:Read( SIZEOF_INT ) ) end
local function ReadUShort(f) return toUShort( f:Read( SIZEOF_SHORT ) ) end

--Taken from nodegraph addon - thx
--Types:
-- 1 = ?
-- 2 = NODE_TYPE_GROUND 
-- 3 = NODE_TYPE_AIR
-- 4 = NODE_TYPE_CLIMB
-- 5 = NODE_TYPE_WATER

local nodesAll
local nodesGround
local nodesAir
local nodesClimb
local nodesWater

local found_ain = false

local function ParseFile()

	if found_ain then
	
		return
		
	end

	f = file.Open("maps/graphs/"..game.GetMap()..".ain","rb","GAME")
	
	if(!f) then
	
		return
		
	end

	found_ain = true
	
	nodesAll = {}
	nodesGround = {}
	nodesAir = {}
	nodesClimb = {}
	nodesWater = {}
	
	local ainet_ver = ReadInt(f)
	local map_ver = ReadInt(f)
	
	if ( ainet_ver != AINET_VERSION_NUMBER ) then
	
		MsgN("Unknown graph file")
		
		nodesAll = nil
		
		return
		
	end

	local numNodes = ReadInt(f)
	
	if ( numNodes < 0 ) then
	
		MsgN("Graph file has an unexpected amount of nodes")
		
		nodesAll = nil
		
		return
		
	end

	for i = 1, numNodes do
	
		local v = Vector( f:ReadFloat(), f:ReadFloat(), f:ReadFloat() )
		
		local yaw = f:ReadFloat()
		
		local flOffsets = {}
		
		for i = 1, NUM_HULLS do
		
			flOffsets[i] = f:ReadFloat()
			
		end
		
		local nodetype = f:ReadByte()
		local nodeinfo = ReadUShort(f)
		local zone = f:ReadShort()

		--if nodetype == 4 then
		
		--	continue
			
		--end
		
		local node = {
			['pos'] = v,
			['yaw'] = yaw,
			['offset'] = flOffsets,
			['type'] = nodetype,
			['info'] = nodeinfo,
			['zone'] = zone,
			['neighbor'] = {},
			['numneighbors'] = 0,
			['link'] = {},
			['numlinks'] = 0
		}

		table.insert( nodesAll, node )
		if nodetype == 2 then
			table.insert( nodesGround, node )
		elseif nodetype == 3 then
			table.insert( nodesAir, node )
		elseif nodetype == 4 then
			table.insert( nodesClimb, node )
		elseif nodetype == 5 then
			table.insert( nodesWater, node )
		end
		
	end
	
end

hook.Add( "Initialize", "ANPlus_InitializeShared", function()
	ParseFile()	
end)

ParseFile()	

function ANPlusAIGetNodes(iType)
	return !iType && nodesAll || iType == 2 && nodesGround || iType == 3 && nodesAir || iType == 4 && nodesClimb || iType == 5 && nodesWater
end

function ANPlusAIGetAllNodes() 
	return nodesAll
end

function ANPlusAIGetGroundNodes()
	return nodesGround
end

function ANPlusAIGetAirNodes()
	return nodesAir
end

function ANPlusAIGetClimbNodes()
	return nodesClimb
end

function ANPlusAIGetWaterNodes()
	return nodesWater
end

function ANPlusAINodeOccupied(pos)
	if !util.IsInWorld( pos ) then return true end	
	local tr, trace = nil	
	tr = {}
	tr.start = pos
	tr.endpos = pos
	trace = util.TraceLine( tr )
	if trace.Hit then return true end	
	local v1 = pos - Vector( 20, 20, 0 )
	local v2 = pos + Vector( 20, 20, 80 )
		tr = {}
		tr.start = v1
		tr.endpos = v2
		trace = util.TraceLine( tr )
		if trace.Hit then return true end

		tr = {}
		tr.start = v1 + Vector( 40, 0, 0 )
		tr.endpos = v2 - Vector( 40, 0, 0 )
		trace = util.TraceLine( tr )
		if trace.Hit then return true end
	return false	
end

function ANPlusAIFindNodesInSphere(pos, distMin, distMax, iType)
	local tbNodes = {}
	for _, node in pairs( ANPlusAIGetNodes( iType ) ) do		
		--if ANPlusInRangeVector( node['pos'], pos, dist ) then table.insert( tbNodes, node ) end
		local distSqr, dist = ANPlusGetRangeVector( node['pos'], pos ) 
		if dist >= distMin && dist <= distMax then table.insert( tbNodes, node ) end
	end
	return tbNodes
end

function ANPlusAIFindClosestNode(pos, iType, noOccupied)
	local iType = iType || 2
	local distClosest = math.huge
	local nodeClosest
	if !ANPlusAIGetNodes( iType ) then return end
	for _, node in pairs( ANPlusAIGetNodes( iType ) ) do		
		
		local dist = ( node['pos'] - pos ):LengthSqr()
		if dist < distClosest && ( !noOccupied || noOccupied && !ANPlusAINodeOccupied( node['pos'] ) ) then	
			distClosest = dist
			nodeClosest = node
		end
	end
	return nodeClosest, distClosest
end

function ANPlusAIFindFurthestNode(pos, iType, noOccupied)
	local iType = iType || 2
	local distFurthest = 0
	local nodeFurthest
	for _, node in pairs( ANPlusAIGetNodes( iType ) ) do		
		
		local dist = ( node['pos'] - pos ):LengthSqr()
		if dist > distFurthest && ( !noOccupied || noOccupied && !ANPlusAINodeOccupied( node['pos'] ) ) then	
			distFurthest = dist
			nodeFurthest = node
		end
	end
	return nodeFurthest, distFurthest
end

function ANPlusAIFindNodeAtRange(pos, iType, range, noOccupied)
	local iType = iType || 2
	local distFurthest = 0
	local nodeFurthest
	for _, node in pairs( ANPlusAIGetNodes( iType ) ) do		
		
		local dist = ( node['pos'] - pos ):LengthSqr()
		if dist > distFurthest && dist <= range && ( !noOccupied || noOccupied && !ANPlusAINodeOccupied( node['pos'] ) ) then	
			distFurthest = dist
			nodeFurthest = node
		end
	end
	return nodeFurthest, distFurthest
end

function ANPlusAIFindClosestVisibleNode(pos, iType, distMin, distMax, nodePosOffset) -- More expensive than FindClosestNode; Only use when neccessary
	local iType = iType || 2
	local distMin = distMin || 100
	local distMax = distMax || 200
	local nodesClose = ANPlusAIFindNodesInSphere( pos, distMin, distMax, iType )	-- Only checking nodes in a close proximity
	local nodeClosest
	local distClosest = math.huge
	local nodePosOffset = nodePosOffset || Vector( 0, 0, 3 )
	local pos = pos + nodePosOffset
	for _, node in ipairs( nodesClose ) do
		local dist = pos:Distance( node['pos'] )
		if nodeClosest then break end
		if ( dist < distClosest ) then
			local tr = util.TraceLine({
				start = pos,
				endpos = node['pos'] + nodePosOffset,
				mask = MASK_SOLID_BRUSHONLY
			})
			if !tr.HitWorld then
				dist = distClosest
				nodeClosest = node
			end
		end
	end
	--return ( nodeClosest || ANPlusAIFindClosestNode( pos, iType ) ) && dist
	return nodeClosest, dist
end

function ANPlusAIFindClosestNotVisibleNode(pos, iType, distMin, distMax, nodePosOffset) -- More expensive than FindClosestNode; Only use when neccessary
	local iType = iType || 2
	local distMin = distMin || 100
	local distMax = distMax || 200
	local nodesClose = ANPlusAIFindNodesInSphere( pos, distMin, distMax, iType )	-- Only checking nodes in a close proximity
	local nodeClosest
	local distClosest = math.huge
	local nodePosOffset = nodePosOffset || Vector( 0, 0, 3 )
	local pos = pos + nodePosOffset
	for _, node in ipairs( nodesClose ) do
		local dist = pos:Distance( node['pos'] )
		if nodeClosest then break end
		if ( dist < distClosest ) then
			local tr = util.TraceLine({
				start = pos,
				endpos = node['pos'] + nodePosOffset,
				mask = MASK_SOLID_BRUSHONLY
			})
			if tr.HitWorld then
				dist = distClosest
				nodeClosest = node
			end
		end
	end
	return nodeClosest, dist
end
---------------------GET RID OFF!
function metaENT:ANPlusCheckSpace(spos, epos, filterTab, ignoreworld, mask, vecmin, vecmax, callback) 
	local cbX, cbY = self:GetCollisionBounds()
	local tr = util.TraceHull( {
		start = spos,
		endpos = epos,
		mins = vecmin || cbX,
		maxs = vecmax || cbY,
		filter = filterTab,
		ignoreworld = ignoreworld,
		mask = mask || nil
	})	
	if tr.Hit then		
		if isfunction(callback) then				
			callback(self, tr)				
		end			
		return true									
	end	
	return false
end

function metaENT:ANPlusCheckWay(spos, epos, filterTab, ignoreworld, mask)	
	local tr = util.TraceEntity( {
		start = spos,
		endpos = epos,
		filter = filterTab,
		ignoreworld = ignoreworld,
		mask = mask || nil
		}, 
		self 		
	)
	
	if !tr.Hit then
		return true	
	elseif tr.Hit then	
		return false					
	end	
end

function metaENT:ANPlusCheckWayLine(spos, epos, filterTab, ignoreworld, mask)	
	local tr = util.TraceLine( {
		start = spos,
		endpos = epos,
		filter = filterTab,
		ignoreworld = ignoreworld,
		mask = mask || nil
		} 		
	)
	
	if !tr.Hit then
		return true	
	elseif tr.Hit then	
		return false					
	end	
end

function ANPlusIsEmptySpace(spos, epos, filterTab, vecmin, vecmax)	
	local tr = util.TraceHull( {
		start = spos,
		endpos = epos,
		mins = vecmin,
		maxs = vecmax,
		filter = filterTab
	})
	if tr.Hit then
		return false					
	end	
	return true	
end
---------------------GET RID OFF!

function metaENT:ANPlusIsLookingAtPos( pos )
	
	local dirv = pos - ( self:GetPos() + Vector( 0, 0, 50 ) )	
	local norm = dirv:GetNormalized()
	
	return ( !( self:GetAimVector():Dot( norm ) < 0.90 ) ) || ( !( self:GetAimVector():Dot( ( dirv + Vector( 70 ) ):GetNormalized() ) < 0.95 ) )
	
end

function ANPIsAnyoneLookingAtPos( ent, entTab, pos )
	
	local seen = false
	
	for _, v in pairs( entTab ) do
	
		if v:IsNPC() || ( v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) then
			
			if IsValid(ent) && v == ent then return false end
			
			seen = v:VisibleVec( pos )
			
			return seen
		
		end
	
	end
	
	return false
	
end

function metaENT:ANPlusGetKillfeedName()
	return self:ANPlusGetDataTab() && self:ANPlusGetDataTab()['KillfeedName'] || self:ANPlusGetName()
end

function metaENT:ANPlusGetName()
	return self:ANPlusGetDataTab() && self:ANPlusGetDataTab()['Name'] || (SERVER) && ( self:GetName() || self:GetClass() )
end

function ANPlusEmitUISound(ply, snd, vol)	
	if (SERVER) then
		if !ply then return end	
		--ANPlusSoundDuration(snd)
		net.Start( "anplus_play_ui_snd" )
		net.WriteString( snd || "" )
		net.WriteFloat( vol || 100 )
		if isbool( ply ) then
			net.Broadcast()
		elseif ply:IsPlayer() then
			net.Send( ply )
		end	
	elseif (CLIENT) then	
		local ply = LocalPlayer()
		ply.m_tANPlusClientSounds = ply.m_tANPlusClientSounds || {}
		if snd != "" then	
			ply:EmitSound( snd, nil, nil, vol / 100 )
			table.insert( ply.m_tANPlusClientSounds, snd )	
		elseif snd != "" && ply.m_tANPlusClientSounds && vol == 0 then
			for k, v in ipairs ( ply.m_tANPlusClientSounds ) do
				if v == snd then
					ply:StopSound( v ) 	
					table.remove( ply.m_tANPlusClientSounds, k ) 						
				end			
			end			
		elseif snd == "" && ply.m_tANPlusClientSounds then		
			for k, v in ipairs ( ply.m_tANPlusClientSounds ) do
				if v != nil then
					ply:StopSound( v ) 
					table.remove( ply.m_tANPlusClientSounds, k ) 						
				end			
			end
		end			
	end
end

function metaENT:ANPlusClientParticleSystem(stop, effect, partAttachment, entAttachment, offset)
	if (SERVER) then
		net.Start("anplus_client_particle_start")
		net.WriteEntity( self )
		net.WriteString( effect )
		net.WriteFloat( partAttachment )
		net.WriteFloat( entAttachment || 0 )
		net.WriteVector( offset || Vector( 0, 0, 0 ) )
		net.WriteBool( stop )
		net.Broadcast()	
	elseif (CLIENT) then
		if !stop then 
			local cps = CreateParticleSystem( self, effect, partAttachment, entAttachment, offset )
			return cps
		else
			if entAttachment == 0 || entAttachment == -1 then
				self:StopParticlesNamed( effect )
			else
				self:StopParticlesWithNameAndAttachment( effect, entAttachment )
			end
		end
	end
end

function metaENT:ANPlusHaloEffect(color, size, lenght)	
	if (SERVER)	then
		net.Start( "anplus_holo_eff" ) 
		net.WriteEntity( self )
		net.WriteColor( color )
		net.WriteFloat( size )
		net.WriteFloat( lenght )		
		net.Broadcast()
	elseif (CLIENT) then
		local fx = EffectData()
		fx:SetEntity( self )
		fx:SetStart( Vector( color.r, color.g, color.b ) ) -- color
		fx:SetScale( size ) -- color
		fx:SetMagnitude( lenght ) -- color
		util.Effect( "anp_holo_blip", fx, true )	
	end
end

function ANPlusSendNotify(ply, snd, text, type, length)	
	if (SERVER) then
		net.Start( "anplus_notify" )
		net.WriteString( snd || "" )
		net.WriteString( text || "" )
		net.WriteFloat( type )
		net.WriteFloat( length )
		if isbool( ply ) then
			net.Broadcast()
		elseif ply:IsPlayer() then
			net.Send( ply )
		end
	elseif (CLIENT) then
		local ply = LocalPlayer()
		notification.AddLegacy( text, type, length )
		EmitSound( snd, ply:GetPos(), -2 )		
	end
end

function ANPlusScreenMsg(ply, id, x, y, size, dur, text, font, color)	
	if (SERVER) then
		net.Start( "anplus_screenmsg_ply" )
		net.WriteFloat( dur || 0 )
		net.WriteFloat( x || 0 )
		net.WriteFloat( y || 0 )
		net.WriteFloat( size || 10 )
		net.WriteString( font || "DermaDefault" )
		net.WriteColor( color || Color( 255, 255, 255 ) )
		net.WriteString( text )
		net.WriteString( id || "defmsg" )
		if isbool( ply ) then
			net.Broadcast()
		elseif ply:IsPlayer() then
			net.Send( ply )
		end	
	elseif (CLIENT) then		
		local ply = LocalPlayer()
		if IsValid(ply[ 'm_msgSCRN_ANPid_' .. id ]) then ply[ 'm_msgSCRN_ANPid_' .. id ]:Remove() end
		if !text || text == "" then return end	
		ply[ 'm_msgSCRN_ANPid_' .. id ] = vgui.Create( "DLabel" )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:SetPos( x * ANPlusGetFixedScreenW(), y * ANPlusGetFixedScreenH() )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:SetSize( ScrW(), size * ANPlusGetFixedScreenH() )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:SetText( text )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:SetTextColor( color )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:SetFont( font )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:SetWrap( false )
		ply[ 'm_msgSCRN_ANPid_' .. id ]:ParentToHUD()	
		timer.Create( "ANP_SCRN_MSG_REM_ID" .. id .. ply:EntIndex(), dur, 1, function()	
			if IsValid(ply[ 'm_msgSCRN_ANPid_' .. id ]) then ply[ 'm_msgSCRN_ANPid_' .. id ]:Remove() end	
		end)		
	end
end

function ANPlusMSGPlayer(ply, text, color, snd)	
	if (SERVER) then
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
	elseif (CLIENT) then
		local ply = LocalPlayer()
		chat.AddText( color, text )
		if snd then EmitSound( snd, ply:GetPos(), -2 ) end	
	end
end

function metaPLAYER:ANPlusGetEyeTrace()	
	local tr = util.TraceLine({
	start = self:EyePos(),
	endpos = self:EyePos() + ( self:GetAimVector() * 1e8 ),
	filter = { self, self:GetActiveWeapon() },
	mask = MASK_SHOT_HULL
	})	
	return tr
end

ANPlusPlayerTools = {
	['gmod_tool'] = true,
	['weapon_physgun'] = true,
}

function metaPLAYER:ANPlusHasActiveTool()
	if IsValid(self:GetActiveWeapon()) && ANPlusPlayerTools[ self:GetActiveWeapon():GetClass() ] then return true end
	return false
end

function ANPlusOverrideSound(toReplace, data, sndReplace, play, sndLVL, sndPitch, sndChannel, sndVolume, sndFlags, sndDSP, sndTime) -- Men't to be used with EntityEmitSound hook
	if data && string.find( string.lower( data.SoundName ), toReplace ) then
		local sndReplace = istable( sndReplace ) && sndReplace[ math.random( 1, #sndReplace ) ] || sndReplace || data.SoundName
		local sndLVL = istable( sndLVL ) && math.random( sndLVL[ 1 ], sndLVL[ 2 ] ) || sndLVL || data.SoundLevel
		local sndPitch = istable( sndPitch ) && math.random( sndPitch[ 1 ], sndPitch[ 2 ] ) || sndPitch || data.Pitch
		local sndChannel = sndChannel || data.Channel
		local sndVolume = istable( sndVolume ) && math.random( sndVolume[ 1 ], sndVolume[ 2 ] ) || sndVolume || data.Volume
		local sndFlags = sndFlags || data.Flags
		local sndDSP = sndDSP || data.DSP
		local sndTime = sndTime || data.SoundTime
		data.SoundName	= sndReplace
		data.SoundLevel = sndLVL
		data.Pitch 		= sndPitch 
		data.Channel 	= sndChannel
		data.Volume 	= sndVolume
		data.Flags		= sndFlags
		data.DSP 		= sndDSP	
		data.SoundTime 	= sndTime
		return play
	end
	return nil
end

function ANPlusOverrideSoundDir(inDir, data, outDir, onFail) -- nil to play the original instead || false to mute.
	if string.find( string.lower( data.SoundName ), inDir ) then
		local newDir = string.Replace( data.SoundName, inDir, outDir )
		local newDirFix = string.Replace( newDir, "*", "" )	
		local newDirExists = file.Exists( "sound/" .. newDirFix, "GAME" ) -- Check if this sound actually exist && if not return the onFail choise.
		if newDirExists then
			data.SoundName = newDir
			return true
		else
			return onFail
		end
	end
	return nil
end

function ANPlusRandTab(tab)
	return tab[ math.random( 1, #tab ) ]
end

/*
local entORtab = {
	['Model'] = "model.mdl"
	['Skin'] = 3,
	['Color'] = Color( 255, 255, 255, 255 ),
	['Material'] = "some/main/material.vtf",
	['BodyGroups'] = {
		[1] = 3,
		[2] = 1,
	},
	['Materials'] = {
		[1] = "some/material/lol.vtf",
		[2] = "some/material/lol2.vtf",
		[3] = "some/material/lmao.vtf",
	},
}
*/

function metaENT:ANPlusCopyVisualFrom(entORtab)

	if isentity(entORtab) then

		self:SetModel( entORtab:GetModel() )
		self:SetSkin( entORtab:GetSkin() )
		self:SetColor( entORtab:GetColor() )
		self:SetMaterial( entORtab:GetMaterial() )
		
		for i = 1, #entORtab:GetBodyGroups() do				
			self:SetBodygroup( i, entORtab:GetBodygroup( i ) )
		end
		
		for i = 1, #entORtab:GetMaterials() do	
			self:SetSubMaterial( i - 1, entORtab:GetSubMaterial( i - 1 ) )
		end
		
	elseif istable(entORtab) then
	
		self:SetModel( entORtab['Model'] )
		self:SetSkin( entORtab['Skin'] )
		self:SetColor( entORtab['Color'] )
		self:SetMaterial( entORtab['Material'] )
		
		for i = 1, #entORtab['BodyGroups'] do				
			self:SetBodygroup( i, entORtab['BodyGroups'][ i ] )
		end
		
		for i = 1, #entORtab['Materials'] do	
			self:SetSubMaterial( i - 1, entORtab['Materials'][ i ] )
		end
		
	end	
	
end

function metaENT:ANPlusGetVisual()
	if !IsValid(self) then return end	
	local visualTab = {
	['Model'] = self:GetModel(),
	['Skin'] = self:GetSkin(),
	['Color'] = self:GetColor(),
	['Material'] = self:GetMaterial(),
	['BodyGroups'] = {},
	['Materials'] = {},
	}		
	for i = 1, #self:GetBodyGroups() do						
		local addTab = { [ i ] = self:GetBodygroup( i ) }
		table.Merge( visualTab['BodyGroups'], addTab )		
	end
	for i = 1, #self:GetMaterials() do	
		local addTab = { [ i ] = self:GetSubMaterial( i - 1 ) }
		table.Merge( visualTab['Materials'], addTab )		
	end
	return visualTab
end

function metaENT:ANPlusHasBones(boneTab)
	for i = 1, #boneTab do
		local bone = boneTab[ i ]
		if self:LookupBone( bone ) then return true end
	end
	return false
end

function metaENT:ANPlusGetAttachmentName(attachmentId)
	attachmentId = tonumber( attachmentId )
	return self:GetAttachments()[ attachmentId ].name
end

function ANPlusGetAllMaps()
	local maps, mapDirs = file.Find( "maps/*.bsp", "GAME", "nameasc" )
	return maps, mapDirs
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
ANPlus.AddScriptedSequence( {
	name	= "",
	channel = CHAN_AUTO,
	volume 	= VOL_NORM,
	level 	= 75,
	pitch 	= 100,
	flags 	= nil,
	dsp		= 0,
	sound 	= { sound1.wav, sound2.wav } one after another, OR sound = { {sound1b.wav sound1a.wav}, sound2.wav } first getting randomised, OR sound = { { sound1.wav, -5 }, sound2.wav } first's duration is reduced by 5 seconds (it wont stop but the second will play if their CHANNELs are not the same)
} )
]]--
function metaENT:ANPlusEmitSoundSentence(sentence, pos, overrideTab, CRecipientFilter, callback) -- overrideTab = { [snd] = sndOverride }
	
	if !sentence then return end
	if !IsValid(self) || ( !self:ANPlusAlive() ) then return end

	local sentTab = ANPlusScriptedSentences[ sentence ]
	if !sentTab then return end
	
	self:ANPlusStopSoundSentence( true )

	local stable = table.Copy( sentTab )
	local captions = stable.caption && stable.caption[ 1 ] || ""

	for _, snd in ipairs( stable.sound ) do

		local num = 1

		if istable( snd ) && isstring( snd[ 1 ] ) then
			num = math.random( 1, #snd ) 
			snd = snd[ num ]			
		end

		local nextSTable = stable.sound[ _ + 1 ]

		local capOver = overrideTab && overrideTab[ snd ] && overrideTab[ snd ][ 2 ] && overrideTab[ snd ][ 2 ].caption

		if nextSTable && istable( nextSTable ) && nextSTable.caption then
			if istable( nextSTable.caption ) then
				captions = captions .. ( capOver && capOver[ num ] || nextSTable.caption[ num ] || "" )
			else
				captions = captions .. ( capOver || nextSTable.caption || "" )
			end
		end

		local sndOver = overrideTab && overrideTab[ snd ] && overrideTab[ snd ][ 1 ]

		sndOver = sndOver && ( istable( sndOver ) && sndOver[ math.random( 1, #sndOver ) ] || sndOver )
		snd = sndOver || snd
		stable.sound[ _ ] = snd

	end
	
	local ANPlus_ASS_CurAudio = 1
	local ANPlus_ASS_SoundLast = 0
	local ANPlus_ASS_SoundDelay = 0
	
	local timerName = "ANPEmitSoundSentenceTimer" .. self:EntIndex()
	
	timer.Remove( timerName )

	if stable.caption then ANPlusAddCaption( true, captions, stable.caption[ 2 ] ) end
	
	timer.Create( timerName, 0, 0, function()	
		
		if !IsValid(self) || stable == nil || ( ANPlus_ASS_CurAudio > #stable.sound ) then
		
			timer.Remove(timerName)
			
			ANPlus_ASS_CurSound = 1			
			if isfunction( callback ) then			
				callback()				
			end
			
		return end
	
		if CurTime() - ANPlus_ASS_SoundLast >= ANPlus_ASS_SoundDelay then
			
			if ANPlus_ASS_CurAudio <= #stable.sound then
				
				local snd = stable.sound[ANPlus_ASS_CurAudio]

				if isnumber( snd ) || ( istable( snd ) && !isstring( snd[ 1 ] ) || snd[ 1 ] == "" ) || snd == "" then ANPlus_ASS_CurAudio = ANPlus_ASS_CurAudio + 1 return end 

				local sndNext = stable.sound[ANPlus_ASS_CurAudio + 1]
				local dur = nil				
				
				sndNext = overrideTab && overrideTab[ snd ] && overrideTab[ snd ][ 2 ] || sndNext
				
				--if istable( snd ) then PrintTable(snd) end
				if isnumber( sndNext ) then
					dur = ANPlusSoundDuration( snd ) + sndNext
				elseif istable( sndNext ) && sndNext.dur then
					dur = ANPlusSoundDuration( snd ) + sndNext.dur
				else
					dur = ANPlusSoundDuration( snd )
				end

				self.m_sASSCurSentence = snd
				
				--self:EmitSound( snd, stable.level, stable.pitch, stable.volume, stable.channel )
				local channel = istable( sndNext ) && sndNext.channel || stable.channel
				local volume = istable( sndNext ) && sndNext.volume || stable.volume
				local level = istable( sndNext ) && sndNext.level || stable.level
				local flags = istable( sndNext ) && sndNext.flags || stable.flags
				local pitch = istable( sndNext ) && sndNext.pitch || stable.pitch
				local dsp = istable( sndNext ) && sndNext.dsp || stable.dsp
				local durFix = dur * ( ( pitch || 100 ) / 100 )
				dur = durFix > dur && durFix || durFix < dur && dur + durFix || dur

				--EmitSound( snd, pos || self:GetPos(), self:EntIndex(), channel, volume, level, flags, pitch, dsp )
				self:EmitSound( snd, level, pitch, volume, channel, flags, dsp, CRecipientFilter )

				ANPlus_ASS_CurAudio = ANPlus_ASS_CurAudio + 1
				ANPlus_ASS_SoundDelay = dur
				ANPlus_ASS_SoundLast = CurTime()
				
			end
			
		end
		
	end)
	
end

function metaENT:ANPlusStopSoundSentence(fullstop)

	if timer.Exists( "ANPEmitSoundSentenceTimer" .. self:EntIndex() ) then 	
		timer.Remove( "ANPEmitSoundSentenceTimer" .. self:EntIndex() ) 	

		if fullstop == true && self.m_sASSCurSentence != nil then	
			self:StopSound( self.m_sASSCurSentence )
			self.m_sASSCurSentence = nil
			
		end	

	end	

end

local function applyVar(ent, varTab)
	if IsValid(ent) && varTab then
		
		local var = varTab['Variable'] 
		local val = varTab['Value'] 
		local label = varTab['Label'] 
		local desc = varTab['Description'] 
		local min = varTab['Min'] 
		local max = varTab['Max'] 
		local deci = varTab['Decimals']

		ent['m_tSaveDataMenu'] = ent['m_tSaveDataMenu'] || {}
		
		if var && label && label != "" then
			local tabCount = #ent['m_tSaveDataMenu']
			local exists

			for i = 0, tabCount do
			
				local tabVal = ent['m_tSaveDataMenu'][ i ]
				
				if tabVal && tabVal['Variable'] == var then exists = true end
				
				if i == tabCount && !exists then
					local addtab = { ['Variable'] = var, ['Label'] = label, ['Description'] = desc, ['Min'] = min, ['Max'] = max, ['Decimals'] = deci }
					table.insert( ent['m_tSaveDataMenu'], addtab )
				end
				
			end
			
		end
		
		ent[ var ] = ent[ var ] || ent[ var ] == nil && val
		
	end
end

local function createVar()
	local ent = net.ReadEntity()
	local varTab = net.ReadTable()
	
	if IsValid(ent) && varTab then applyVar( ent, varTab ) end
end

net.Receive("anplus_savedata_tosv", function(_, ply)
	createVar()
end)

net.Receive("anplus_savedata_tocl", function()	
	createVar()	
end)

function metaENT:ANPlusCreateVar(var, val, label, desc, min, max, deci, updateCallback)
	if val == nil then return end

	local varTab = { ['Variable'] = var, ['Value'] = val, ['Label'] = label, ['Description'] = desc, ['Min'] = min, ['Max'] = max, ['Decimals'] = deci }

	if (SERVER) then 
		net.Start( "anplus_savedata_tocl" )
		net.WriteEntity( self )
		net.WriteTable( varTab )
		net.Broadcast()		
	end	
	
	applyVar( self, varTab )
	
	if var && label then
		
		self['m_tSaveDataUpdateFuncs'] = self['m_tSaveDataUpdateFuncs'] || {}

		if updateCallback && !self['m_tSaveDataUpdateFuncs'][ var ] then
			local addTab = { [ var ] = updateCallback }
			table.Merge( self['m_tSaveDataUpdateFuncs'], addTab )
		end

	end
	
end

function metaENT:ANPlusSetVar(var, val, func)
	if self[var] == nil then return end
	self[var] = val
	if (SERVER) then self:ANPlusAddSaveData( var, val, func ) end
end

function metaENT:ANPlusGetRagdoll()
	return (SERVER) && self.m_pSRagdollEntity || (CLIENT) && self.m_pCRagdollEntity
end

function metaENT:ANPlusGetLastFiredBullet()
	return self.m_tLastFiredBullet
end

function ANPlusFindClosestEntity(pos, tab, filterFunc, filterEnts)
	local distClosestSqr = math.huge
	local distClosest
	local entClosest
	if !tab || !istable(tab) then return end
	for _, v in pairs( tab ) do	
		if v && IsValid(v) && ( !filterEnts || !filterEnts[ v ] ) then
			local filter = isfunction(filterFunc) && filterFunc(v) || !isfunction(filterFunc) && true
			local distSqr, dist = ANPlusGetRangeVector( v:GetPos(), pos )
				if distSqr < distClosestSqr && filter then	
					distClosestSqr = distSqr
					distClosest = dist
					entClosest = v
				end
			end
		end
	return entClosest, distClosestSqr, distClosest
end

function metaPLAYER:ANPlusControlled(ent)
	if ent == nil then
		return self.m_pANPControlledENT
	elseif IsValid(ent) then
		self.m_pANPControlledENT = ent
	elseif isbool( ent ) && ent == false then
		self.m_pANPControlledENT = nil
	end
end

function metaENT:ANPlusGetHeight()
	return math.abs( self:OBBMins().z ) + self:OBBMaxs().z
end

function metaENT:ANPlusIsRagdoll()
	local c = self:GetClass()
	return c == "prop_ragdoll"
end

function metaENT:ANPlusIsProp()
	local c = self:GetClass()
	return c == "prop_static" || c == "prop_physics" || c == "prop_dynamic"
end

function metaENT:ANPlusIsDoor()	
	local c = self:GetClass()	
	return c == "func_door" || c == "func_door_rotating" || c == "prop_door" || c == "prop_door_rotating"	
end

function metaENT:SequenceGetFrames(seqID, anim)
	local animID = anim && self:GetSequenceInfo( seqID ).anims[ anim ]
	return animID && self:GetAnimInfo( animID ).numframes || -1
end

function metaENT:ANPlusSetColorFade(color, delta)
	color = color || self:GetColor()
	local alpha = color.a	
	color = Vector( color.r, color.g, color.b )
	delta = delta || 1	
	local fx = EffectData()
	fx:SetEntity( self )
	fx:SetMagnitude( delta ) -- Delta
	fx:SetStart( color ) -- Color
	fx:SetColor( alpha || 255 ) -- Alpha
	util.Effect( "anp_fade", fx, true, true )
end

function metaENT:ANPlusIsWiremodCompEnt()
	if WireLib then
		if ( self.Inputs || self.Outputs ) && self.IsWire then
			return true
		end
	end
	return false
end

function metaPLAYER:ANPlusIsSpawnMenuOpen()
	return self.m_bSpawnMenuOpen
end

function string.ToVector(str)
	str = string.Split( str, " " )
	if #str < 3 then return nil end	
	str[ 1 ] = tonumber( str[ 1 ] )
	if !isnumber( str[ 1 ] ) then return nil end
	str[ 2 ] = tonumber( str[ 2 ] )
	if !isnumber( str[ 2 ] ) then return nil end
	str[ 3 ] = tonumber( str[ 3 ] )
	if !isnumber( str[ 3 ] ) then return nil end
	return Vector( str[ 1 ], str[ 2 ], str[ 3 ] )
end

function ANPlusStringToVector(str)
	if !isstring( str ) || !string.gsub( str, "vector ", "" ) then return nil end
	str = string.gsub( str, "vector ", "" )
	return string.ToVector(str)
end

function string.ToAngle(str)
	str = string.Split( str, " " )
	if #str < 3 then return nil end	
	str[ 1 ] = tonumber( str[ 1 ] )
	if !isnumber( str[ 1 ] ) then return nil end
	str[ 2 ] = tonumber( str[ 2 ] )
	if !isnumber( str[ 2 ] ) then return nil end
	str[ 3 ] = tonumber( str[ 3 ] )
	if !isnumber( str[ 3 ] ) then return nil end
	return Angle( str[ 1 ], str[ 2 ], str[ 3 ] )
end

function ANPlusStringToAngle(str)
	if !isstring( str ) || !string.gsub( str, "angle ", "" ) then return nil end
	str = string.gsub( str, "angle ", "" )
	return string.ToAngle(str)
end

function ANPlusAddCaption(ply, text, dur, fromPly)	
	if ( ANPlusGMODBranch() != "dev" && ANPlusGMODBranch() != "x86-64" ) then return end
	if (SERVER) then
		net.Start( "anplus_add_caption" )
		net.WriteString( text || "" )
		net.WriteFloat( dur || 1 )		
		net.WriteBool( fromPly || false )		
		if isbool( ply ) then
			net.Broadcast()
		elseif ply:IsPlayer() then
			net.Send( ply )
		end	
	elseif (CLIENT) then	
		gui.AddCaption( text, dur, fromPly )		
	end
end

function metaENT:ANPlusCallFunction( name, ... )
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions'][name] != nil then	
		self:ANPlusGetDataTab()['Functions'][name](...)
	end
end

function metaENT:ANPMuteSound(bool)
	self:SetNW2Bool( "m_bANPMuted", bool )
end

function metaENT:ANPlusApplyFlexData(flexTab, scale)

	if !flexTab then return end
	
	self:SetFlexScale( scale || 1 )
	
	for i = 1, #flexTab do

		self:SetFlexWeight( i - 1, flexTab[ i ] )
		
	end

end

function metaENT:ANPlusShootEffect(att, flags, scale, effect, muzzleSmokeDelay, muzzleSmokeDur)	-- flags for default hl2 muzzle = flags. For ANP muzzles = boneID (instead of the attachment).
	
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
function metaENT:ANPlusHitEffect( tr, scale )
	
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

function metaENT:ANPlusShell( att, bone, type, scale, angVec )
	
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

function metaENT:ANPlusHitEffect(effect, tr, scale)	
	if tr && !tr.HitSky then 	
		local fx = EffectData()
		fx:SetOrigin( tr.HitPos )
		fx:SetNormal( tr.HitNormal )
		fx:SetScale( scale || 1 )
		util.Effect( effect, fx )	
	end
end

function metaENT:ANPlusFireBullet(bullet, target, hShotChan, muzzlePos, delay, burstCount, burstReset, fireSND, distFireSND, callback) -- bulletcallback = function(att, tr, dmginfo) | callback = function( origin, vector )

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

function metaENT:ANPlusGetEmittedLastSound()
	return self.m_tLastSoundEmitted
end

function metaENT:ANPlusGetHearDistance()
	return self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['HearDistance'] || nil
end 
 
function metaENT:ANPlusFakeModel(model, visualTab)

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
				--table.Merge( self:ANPlusGetDataTab(), addTab )			
				self:ANPlusApplyDataTab( addTab )
			end
			
		elseif model && IsValid(self.m_pFakeModel) then
		
			self.m_pFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
			if self:IsNPC() then
				local addTab = { ['CurFakeModel'] = { ['Model'] = model, ['VisualTab'] = self.m_pFakeModel:ANPlusGetVisual() } }
				--table.Merge( self:ANPlusGetDataTab(), addTab )			
				self:ANPlusApplyDataTab( addTab )
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

function metaENT:ANPlusGetRagdollEntity()
	if (SERVER) then
		return self.m_pSRagdollEntity
	elseif (CLIENT) then
		return self.m_pCRagdollEntity
	end
end