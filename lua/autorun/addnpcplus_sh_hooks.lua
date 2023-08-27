------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

--[[////////////////////////
||||| Here We are checking spawned entities if they are a part of this base. If so, apply valid data table.
]]--\\\\\\\\\\\\\\\\\\\\\\\\
hook.Add( "OnEntityCreated", "ANPlusLoad_OnEntityCreated", function(ent)

	timer.Simple( 0, function() 
		if !IsValid(ent) then return end 
		
		timer.Simple( 0, function()
		
			if !IsValid(ent) then return end	
			
			if IsValid(ent:GetOwner()) && ent:GetOwner():IsANPlus(true) then		
				local npc = ent:GetOwner()		
				if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCCreateEntity'] != nil then
					npc:ANPlusGetDataTab()['Functions']['OnNPCCreateEntity'](npc, ent)		
				end				
			end
			
			if (SERVER) && !ent:IsANPlus(true) then

				for i = 1, #ANPlusDangerStuffGlobalNameOrClass do
					local danger = ANPlusDangerStuffGlobalNameOrClass[ i ]
					if danger && !ent:IsWeapon() && ( string.find( string.lower( ent:ANPlusGetName() ), danger ) || string.find( string.lower( ent:GetClass() ), danger ) ) && !table.HasValue( ANPlusDangerStuffGlobal, ent ) then
						table.insert( ANPlusDangerStuffGlobal, ent )
					end			
				end

				ent:ANPlusIgnoreTillSet()
				ent:ANPlusNPCApply( ent:GetKeyValues()['parentname'] )		
				ent.m_pMyPlayer = nil	
				
			end	
		end )	
	end )	
end )

--[[////////////////////////
||||| If any KeyValues are getting applied to our Entity, We want access to them. It won't run on KeyValues applied by the spawn menu on spawn.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

hook.Add( "EntityKeyValue", "ANPlusLoad_EntityKeyValue", function(ent, key, val)
	if IsValid(ent) && ent:IsANPlus(true) then		
		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCKeyValue'] != nil then
			ent:ANPlusGetDataTab()['Functions']['OnNPCKeyValue'](ent, key, val)		
		end					
	end	
end )

--[[////////////////////////
]]--\\\\\\\\\\\\\\\\\\\\\\\\

hook.Add( "EntityFireBullets", "ANPlusLoad_EntityFireBullets", function(npc, data)	
	if IsValid(npc) && npc:IsANPlus(true) && npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCFireBullets'] != nil then
		
		--npc:ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc, npc:IsNPC() && npc:GetActiveWeapon() || nil, data)	
		local allow = npc:ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc, npc:IsNPC() && npc:GetActiveWeapon() || nil, data) 

		return allow
		
	end		
	if IsValid(npc) && IsValid(npc:GetOwner()) && npc:GetOwner():IsANPlus(true) && npc:GetOwner():ANPlusGetDataTab()['Functions'] && npc:GetOwner():ANPlusGetDataTab()['Functions']['OnNPCFireBullets'] != nil then
		
		--npc:GetOwner():ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc:GetOwner(), npc, data)	
		local allow = npc:GetOwner():ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc:GetOwner(), npc, data) 

		return allow		
	end
	npc.m_tLastFiredBullet = data
end )

--[[////////////////////////
||||| Thanks to this hook, We can replace NPC' sounds. We can also simlate NPC hearing stuff. This hook doesn't work with scripted sentences (facepunch pls fix).
]]--\\\\\\\\\\\\\\\\\\\\\\\\

local sndChars = {
	['*'] = true,
	['#'] = true,
	['@'] = true,
	['>'] = true,
	['<'] = true,
	['^'] = true,
	[')'] = true,
	['}'] = true,
	['$'] = true,
	['!'] = true,
	['?'] = true,
	['&'] = true,
	['~'] = true,
	['`'] = true,
	['+'] = true,
	['('] = true,
	['%'] = true,
}

hook.Add( "EntityEmitSound", "ANPlusLoad_EntityEmitSound", function(data)	
	local ent = data.Entity	
	local pos = data.Pos || IsValid(ent) && ent:GetPos()
	
	if IsValid(ent) && ( ent:IsNPC() || ent:IsWeapon() || ( ent:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) ) && !GetConVar("ai_disabled"):GetBool() then
		for k, v in ipairs( ents.GetAll() ) do
			if IsValid(v) && v != ent && v:IsANPlus(true) && v:ANPlusGetDataTab()['Functions'] && v:ANPlusGetDataTab()['Functions']['HearDistance'] && v:ANPlusGetDataTab()['Functions']['OnNPCHearSound'] != nil then						
				local distSqr, dist = ANPlusGetRangeVector(v:GetPos(), pos)
				local formula = v:ANPlusGetDataTab()['Functions']['HearDistance'] * 5 * ( data.SoundLevel * data.Volume ) / dist
				--print("formula ", formula, data.SoundLevel * data.Volume, v:ANPlusGetDataTab()['Functions']['HearDistance'])
				--if formula >= v:ANPlusGetDataTab()['Functions']['HearDistance'] then			
					v:ANPlusGetDataTab()['Functions']['OnNPCHearSound'](v, ent, formula, data)
				--end
			end
		end
	end
	
	if ent:IsANPlus(true) then	
		if ent:GetNWBool( "ANP_IsMuted" ) then return false end		
		ent.m_tLastSoundEmitted = data			
		if ent:ANPlusGetDataTab()['SoundModification'] && ent:ANPlusGetDataTab()['SoundModification']['SoundList'] then	
			local sndTab = ent:ANPlusGetDataTab()['SoundModification']['SoundList']		
			for _, v in ipairs( sndTab ) do		
				--if( ( sndTab['Folder'] && string.find( string.lower( data.SoundName ), sndTab['Folder'] ) ) || ( sndTab['SoundList'] && sndTab['SoundList'][ data.SoundName ] && sndTab['SoundList'][ data.SoundName ][ 1 ] ) ) then
				if v && string.find( string.lower( data.SoundName ), v[ 1 ] ) then				
					if v['Play'] != nil && v['Play'] == false then return false end			
					local sndReplace = v['Replacement'] && istable( v['Replacement'] ) && v['Replacement'][ math.random( 1, #v['Replacement'] ) ] || v['Replacement'] || data.SoundName
					sndReplace = !v['SoundCharacter'] && sndReplace || v['SoundCharacter'] == true && ( sndChars[ string.Left( data.SoundName, 1 ) ] && string.Left( data.SoundName, 1 ) .. sndReplace || sndReplace ) || isstring( v['SoundCharacter'] ) && v['SoundCharacter'] .. sndReplace 
					local sndLVL = v['SoundLevel'] && istable( v['SoundLevel'] ) && math.random( v['SoundLevel'][ 1 ], ( v['SoundLevel'][ 2 ] || v['SoundLevel'][ 1 ] ) ) || v['SoundLevel'] || data.SoundLevel
					local sndPitch = ent.ANPlusOverPitch || v['Pitch'] && istable( v['Pitch'] ) && math.random( v['Pitch'][ 1 ], ( v['Pitch'][ 2 ] || v['Pitch'][ 1 ] ) ) || v['Pitch'] || data.Pitch
					local sndChannel = v['Channel'] || data.Channel
					local sndVolume = v['Volume'] && istable( v['Volume'] ) && math.random( v['Volume'][ 1 ], ( v['Volume'][ 2 ] || v['Volume'][ 1 ] ) ) || v['Volume'] || data.Volume
					local sndFlags = v['Flags'] || data.Flags
					local sndDSP = v['DSP'] || data.DSP
					data.SoundName	= sndReplace
					data.SoundLevel = sndLVL
					data.Pitch 		= sndPitch 
					data.Channel 	= sndChannel
					data.Volume 	= sndVolume
					data.Flags		= sndFlags
					data.DSP 		= sndDSP	
					return true			
				end			
			end			
		end
		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'] != nil then
			--ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)		
			local bool = ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)
			return bool
		end	
	end	
end )

hook.Add( "EntityRemoved", "ANPlusLoad_EntityRemoved", function(ent)	
	if IsValid(ent) then
		if (SERVER) then
			if !ent:IsWeapon() && table.HasValue( ANPlusDangerStuffGlobal, ent ) then
				table.RemoveByValue( ANPlusDangerStuffGlobal, ent )
				--ANPlusTableDeNull( ANPlusDangerStuffGlobal ) -- Just in case.
			end
			if ent:IsANPlus(true) then
				if ent:IsNPC() && ent:ANPlusGetDataTab()['UseANPSquadSystem'] then 
					ent:ANPlusRemoveFromCSquad( ent:ANPlusGetSquadName() )
				end
				if ent:ANPlusIsWiremodCompEnt() then
					WireLib.Remove( ent )
				end
			end
		--elseif (CLIENT) then		
		end
		
		if ent:IsANPlus(true) then
			if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCRemove'] != nil then
				ent:ANPlusGetDataTab()['Functions']['OnNPCRemove'](ent)	
			end			
		end
		
	end	
end )
--[[
hook.Add( "CalcView", "ANPlus_CalcView", function(ply, pos, angle, fov)	
	
	if ply:GetViewEntity() == ply && ply.m_pANPControlledENT && IsValid(ply.m_pANPControlledENT) && ply.m_pANPControlledENT:ANPlusAlive() then
		local ent = ply.m_pANPControlledENT		
		local bone = ent:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			local bonePos, boneAng = ent:GetBonePosition( bone )				
			pos = bonePos + ent:GetForward() * -100	 + ent:GetUp() * 20
			
			--local hp = Angle( ent:EyeAngles()
			--angle = hp	
		end
	
		local view = {
		origin = pos,
		angles = angles,
		fov = fov,
		drawviewer = false
		}

		return view
	end	
		
end )
]]--
hook.Add( "CalcView", "ANPlus_CalcView", function(ply, pos, angle, fov)	
	
	if ply:GetViewEntity() == ply && ply.m_pANPControlledENT && IsValid(ply.m_pANPControlledENT) && ply.m_pANPControlledENT:ANPlusAlive() then
		local ent = ply.m_pANPControlledENT		

		local bonePos, boneAng = ent:GetPos() + ent:OBBCenter()	+ ent:GetUp() * 30			
		pos = bonePos + ent:GetForward() * -100	 + ent:GetUp() * 20
	
		local view = {
		origin = pos,
		angles = angles,
		fov = fov,
		drawviewer = false
		}

		return view
	end	
		
end )
local function ControllerRemove(ply)
	--ent:SetMaxLookDistance( ent.m_fDefaultLookDistance || 2048 )	
	
	if IsValid(ply.m_pANPlusNPCTarget) then ply.m_pANPlusNPCTarget:Remove() end
	
	if (CLIENT) then 
		ply:DrawViewModel( true )
	elseif (SERVER) then
		ply:UnSpectate()
		ply:KillSilent()
		ply:Spawn()
		if IsValid(ply:ANPlusControlled()) then 
			ply:SetPos( ply:ANPlusControlled():GetPos() ) 
			local entAng = ply:ANPlusControlled():GetAngles()
			local ang = Angle( ply:GetAngles().x, entAng.y, ply:GetAngles().z )
			ply:SetAngles( ang )
		end
		ply:SetNoDraw( false )
		ply:DrawShadow( true )
		ply:SetNoTarget( false )
		ply:DrawViewModel( true )
		ply:DrawWorldModel( true )
		net.Start("anplus_controller")
		net.Send( ply )
	end
	
	ply:ANPlusControlled( false )
end

net.Receive("anplus_controller", function()
	local ply = LocalPlayer()
	ControllerRemove(ply)
end)

local dist = 100
local function QTrace(spos, epos, filterTab)
	local tr = util.TraceLine( {
		start = spos,
		endpos = epos,
		filter = filterTab,
		--ignoreworld = ignoreworld,
		mask = MASK_NPCSOLID_BRUSHONLY
		} 		
	)
	return tr
end

hook.Add( "SetupMove", "ANPlusLoad_SetupMove", function(ply, mvd, cmd)
	if ply.m_pANPControlledENT && IsValid(ply.m_pANPControlledENT) && ply.m_pANPControlledENT:ANPlusAlive() then
		local ent = ply:ANPlusControlled()	
		ply.m_bANPControlling = true
		--[[
		if !IsValid(ply.m_pANPlusNPCTarget) then
			ply.m_pANPlusNPCTarget = ents.Create( "npc_bullseye" ) 
			ply.m_pANPlusNPCTarget:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
			ply.m_pANPlusNPCTarget:SetSolid( SOLID_NONE )
			ply.m_pANPlusNPCTarget:SetMoveType( MOVETYPE_NONE )
			ent:AddEntityRelationship( ply.m_pANPlusNPCTarget, D_HT, 0 )
		else
			local tr = util.TraceLine({
				start = ent:EyePos(),
				endpos = ent:EyePos() + ( ply:GetAimVector() * 1e8 ),
				filter = { ent, ent:GetActiveWeapon(), ply.m_pANPlusNPCTarget },
				mask = MASK_SHOT_HULL
			})
			ply.m_pANPlusNPCTarget:SetPos( tr.HitPos )			
			ent:SetEnemy( ply.m_pANPlusNPCTarget )
			ent:UpdateEnemyMemory( ply.m_pANPlusNPCTarget, ply.m_pANPlusNPCTarget:GetPos() )
		end
		]]--
		ent:SetAngles( Angle( ent:GetAngles().x, ply:LocalEyeAngles().y, ent:GetAngles().z ) )
		--ent:SetPoseParameter( "aim_pitch", ply:LocalEyeAngles().x )
		--ent:SetPoseParameter( "aim_yaw", 0 )
		--ent:SetKeyValue( "sleepstate", 3 )
		if mvd:KeyDown( IN_ATTACK ) then

		end	
		
		if mvd:KeyDown( IN_RELOAD ) && !ent:IsCurrentSchedule( SCHED_RELOAD ) then
			ent:SetSchedule( SCHED_RELOAD )
		end
		
		if mvd:KeyDown( IN_JUMP ) && ent:OnGround() then
			local mvVelo = ent:GetGroundSpeedVelocity()
			ent:MoveJumpStart( mvVelo + ent:GetUp() * 300 )
		end
		
		if mvd:KeyDown( IN_DUCK ) && ent:OnGround() then
			ent:SetSaveValue( "m_bIsCrouching", true )
			ent:SetSaveValue( "m_bForceCrouch", true )
			ent:SetSaveValue( "m_bCrouchDesired", true )
		else
			ent:SetSaveValue( "m_bIsCrouching", false )
			ent:SetSaveValue( "m_bForceCrouch", false )
			ent:SetSaveValue( "m_bCrouchDesired", false )
		end
		
		if ent:OnGround() then
			if mvd:KeyDown( IN_SPEED ) then
				--if ent:GetCurrentSchedule() != SCHED_FORCED_GO_RUN then
					if mvd:KeyDown( IN_FORWARD ) && !mvd:KeyDown( IN_MOVERIGHT ) && !mvd:KeyDown( IN_MOVELEFT ) then						
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() * -30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif mvd:KeyDown( IN_MOVERIGHT ) && !mvd:KeyDown( IN_FORWARD ) && !mvd:KeyDown( IN_BACK ) then
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetRight() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetRight() * -30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )

					elseif mvd:KeyDown( IN_MOVERIGHT ) && mvd:KeyDown( IN_FORWARD ) then				
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * dist + ent:GetRight() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * -30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif mvd:KeyDown( IN_MOVELEFT ) && !mvd:KeyDown( IN_FORWARD ) && !mvd:KeyDown( IN_BACK )  then			
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetRight() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif mvd:KeyDown( IN_MOVELEFT ) && mvd:KeyDown( IN_FORWARD ) then
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * dist + ent:GetRight() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif mvd:KeyDown( IN_BACK ) && !mvd:KeyDown( IN_MOVERIGHT ) && !mvd:KeyDown( IN_MOVELEFT ) then	
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif mvd:KeyDown( IN_MOVERIGHT ) && mvd:KeyDown( IN_BACK ) then
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * -dist + ent:GetRight() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif mvd:KeyDown( IN_MOVELEFT ) && mvd:KeyDown( IN_BACK ) then						
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * -dist + ent:GetRight() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO_RUN )
						
					elseif ent:IsMoving() then
						ent:StopMoving()
					end
				--end
			else
				--if ent:GetCurrentSchedule() != SCHED_FORCED_GO then
					if mvd:KeyDown( IN_FORWARD ) && !mvd:KeyDown( IN_MOVERIGHT ) && !mvd:KeyDown( IN_MOVELEFT ) then						
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() * -30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						ent:SetCondition(21)
					elseif mvd:KeyDown( IN_MOVERIGHT ) && !mvd:KeyDown( IN_FORWARD ) && !mvd:KeyDown( IN_BACK ) then
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetRight() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetRight() * -30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )

					elseif mvd:KeyDown( IN_MOVERIGHT ) && mvd:KeyDown( IN_FORWARD ) then				
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * dist + ent:GetRight() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * -30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						
					elseif mvd:KeyDown( IN_MOVELEFT ) && !mvd:KeyDown( IN_FORWARD ) && !mvd:KeyDown( IN_BACK )  then			
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetRight() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						
					elseif mvd:KeyDown( IN_MOVELEFT ) && mvd:KeyDown( IN_FORWARD ) then
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * dist + ent:GetRight() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						
					elseif mvd:KeyDown( IN_BACK ) && !mvd:KeyDown( IN_MOVERIGHT ) && !mvd:KeyDown( IN_MOVELEFT ) then	
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						
					elseif mvd:KeyDown( IN_MOVERIGHT ) && mvd:KeyDown( IN_BACK ) then
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * -dist + ent:GetRight() * dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						
					elseif mvd:KeyDown( IN_MOVELEFT ) && mvd:KeyDown( IN_BACK ) then						
						local spos = ent:GetPos() + ent:OBBCenter() 
						local filter = { ply, ply:GetActiveWeapon(), ent, ent:GetActiveWeapon() }
						local tr = QTrace( spos, spos + ent:GetForward() * -dist + ent:GetRight() * -dist, filter )
						local pos = tr.Hit && tr.HitPos + ent:GetForward() + ent:GetRight() * 30 || tr.HitPos
						ent:SetLastPosition( pos )
						ent:SetSchedule( SCHED_FORCED_GO )
						
					elseif ent:IsMoving() then
						ent:StopMoving()
					end			
				end
			--end
		end		
		
		-- STOP --
		if mvd:KeyDown( IN_SCORE ) then
			ControllerRemove(ply)
		end
	elseif ply.m_bANPControlling then
		ply.m_bANPControlling = false
		ControllerRemove(ply)
	end
	
end)