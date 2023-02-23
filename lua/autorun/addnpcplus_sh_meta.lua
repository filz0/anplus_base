local metaANG = FindMetaTable("Angle")
local metaENT = FindMetaTable("Entity")
local metaPLAYER = FindMetaTable("Player")

function metaANG:ANPlusClamp()
	while self.p < 0 do self.p = self.p +360 end
	while self.y < 0 do self.y = self.y +360 end
	while self.r < 0 do self.r = self.r +360 end
	
	while self.p > 360 do self.p = self.p -360 end
	while self.y > 360 do self.y = self.y -360 end
	while self.r > 360 do self.r = self.r -360 end
end

function ANPdevMsg(arg, lvl)
	if GetConVar("developer"):GetFloat() != lvl then return end
	if istable(arg) then
		PrintTable(arg)
	else
		MsgN(arg)
	end
end

function ANPlusPercentageChance(chance)
	local lucky = math.random( 1, 100 )
	if lucky <= chance then 
		return true
	else
		return false
	end
end

function metaENT:ANPlusGetAngleToPos(pos, _ang, bDontClamp)
	local _pos
	if self:IsPlayer() then
		_pos = self:GetShootPos()
		if !_ang then
			_ang = self:GetAimVector():Angle()
		end
	else
		_ang = _ang || self:GetAngles()
		_pos = self:GetPos()
	end
	local ang = _ang -(pos -_pos):Angle()
	if !bDontClamp then ang:ANPlusClamp() end
	return ang	
end
--[[
/*
local angTab = {
	['Pitch'] 	= 70,
	['Yaw'] 	= 45,
	['Roll'] 	= 360,
}
*/

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
function metaENT:ANPlusValidAngles(pos, full360)
	local sPos, sAng = self:GetPos(), self:GetAngles()	
	local aimDir = ( pos - sPos ):Angle()
	local pitch = math.Round( math.NormalizeAngle( sAng.p - aimDir.p ) * 1000 ) / 1000	
	local yaw = math.Round( math.NormalizeAngle( sAng.y - aimDir.y ) * 1000 ) / 1000	
	local roll = math.Round( math.NormalizeAngle( sAng.r - aimDir.r ) * 1000 ) / 1000	
	local validAng = ( ( ( pitch <= ( full360.Pitch ) && pitch >= 0 ) || ( pitch <= 0 && pitch >= ( -full360.Pitch ) ) ) && ( ( yaw <= ( full360.Yaw ) && yaw >= 0 ) || ( yaw <= 0 && yaw >= ( -full360.Yaw ) ) ) && ( ( roll <= ( full360.Roll ) && roll >= 0 ) || ( roll <= 0 && roll >= ( -full360.Roll ) ) ) )
	ANPdevMsg( "ValidAngles: "..pitch.." "..yaw.." "..roll.." "..tostring(validAng), 2 )
	return validAng
end


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

function metaENT:ANPlusResetBone()
	
	local bonecount = self:GetBoneCount()
	
	for i = 0, bonecount do
	
		self:ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
		self:ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
		self:ManipulateBoneScale( i, Vector( 1, 1, 1 ) )
		self:ManipulateBoneJiggle( i, self:GetManipulateBoneJiggle( i ) )
		
		if (SERVER) then
			net.Start("anplus_fix_bones")
			net.WriteEntity( self )
			net.Broadcast()	
		else	
			self:SetupBones()
		end
		
	end

end

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

function metaENT:ANPlusGetHitGroupBone( hg )	
	local numHitBoxSets = self:GetHitboxSetCount()
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
	return nil, -1	
end

function ANPlusSoundDuration(strfile) -- We want to round the sound duration.
	local sounddur = SoundDuration( strfile )
	if sounddur then
		sounddur = math.Round( sounddur * 1000 ) / 1000	
	end	
	ANPdevMsg( "[" .. strfile .. "]" .. " duration: " .. sounddur, 1 )	
	return sounddur	
end

function metaENT:ANPlusInRange(target, dist)
	local distSqr = dist * dist
	local distTSqr = self:GetPos():DistToSqr( target:GetPos() ) <= distSqr
	return distTSqr
end

function metaENT:ANPlusGetRange(target)
	local distTSqr = self:GetPos():DistToSqr( target:GetPos() )
	return distTSqr
end

function ANPlusInRangeVector(pos1, pos2, dist)
	local distSqr = dist * dist
	local distTSqr = pos1:DistToSqr( pos2 ) <= distSqr
	return distTSqr
end

function ANPlusGetRangeVector(pos1, pos2)
	local distTSqr = pos1:DistToSqr( pos2 )
	local dist = math.sqrt( distTSqr )
	return distTSqr, dist
end

function metaENT:IsANPlus(alsoENT)		
	if self:IsNPC() && self:ANPlusGetDataTab() then 	
		return true		
	elseif alsoENT && self:ANPlusGetDataTab() then 	
		return true		
	else		
		return false		
	end
end

function metaENT:ANPlusAlive()
	if IsValid(self) && ( ( self:IsNPC() && ( ( (SERVER) && self:GetNPCState() != 7 ) || ( (CLIENT) && self:Health() > 0 ) ) ) || ( !self:IsNPC() && self:Health() > 0 ) || ( self:IsPlayer() && self:Alive() ) ) then
		return true		
	else	
		return false		
	end
end

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
	local v1 = pos - Vector( 20, 20 ,0 )
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

function ANPlusAIFindNodesInSphere(pos, dist, iType)
	local tbNodes = {}
	for _, node in pairs( ANPlusAIGetNodes( iType ) ) do		
		if ANPlusInRangeVector( node['pos'], pos, dist ) then table.insert( tbNodes, node ) end
	end
	return tbNodes
end

function ANPlusAIFindClosestNode(pos, iType, noOccupied)
	local iType = iType || 2
	local distClosest = math.huge
	local nodeClosest
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

function ANPlusAIFindClosestVisibleNode(pos, iType) -- More expensive than FindClosestNode; Only use when neccessary
	local iType = iType || 2
	local nodesClose = ANPlusAIFindNodesInSphere( pos, 100, iType )	-- Only checking nodes in a close proximity
	local nodeClosest
	local distClosest = math.huge
	local offset = Vector( 0, 0, 3 )
	local pos = pos +offset
	for _, node in ipairs( nodesClose ) do
		local dist = pos:Distance( node['pos'] )
		if ( dist < distClosest ) then
			local tr = util.TraceLine({
				start = pos,
				endpos = node['pos'] + offset,
				mask = MASK_SOLID_BRUSHONLY
			})
			if !tr.HitWorld then
				dist = distClosest
				nodeClosest = node
			end
		end
	end
	return nodeClosest || ANPlusAIFindClosestNode( pos, iType )
end

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

function ANPlusIsEmptySpace(spos, epos, filterTab, vecmin, vecmax)	
	local tr = util.TraceHull( {
		start = spos,
		endpos = epos,
		mins = vecmin,
		maxs = vecmax,
		filter = entsTab
	})
	if tr.Hit then
		return false					
	end	
	return true	
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