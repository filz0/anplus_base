------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

--[[////////////////////////
||||| SANDBOX functions override. 
]]--\\\\\\\\\\\\\\\\\\\\\\\\

hook.Add( "InitPostEntity", "ANPlusLoad_GamemodeInitPostEntity", function()

	DEATH_NOTICE_FRIENDLY_VICTIM = 1
	DEATH_NOTICE_FRIENDLY_ATTACKER = 2

	if (CLIENT) then

		timer.Simple( 1, function()

			net.Receive( "DeathNoticeEvent", function()

				local attacker = nil
				local attackerType = net.ReadUInt( 2 )
				if ( attackerType == 1 ) then
					attacker = net.ReadString()
				elseif ( attackerType == 2 ) then
					attacker = net.ReadEntity()
				end

				local inflictor	= net.ReadString()

				local victim = nil
				local victimType = net.ReadUInt( 2 )
				if ( victimType == 1 ) then
					victim = net.ReadString()
				elseif ( victimType == 2 ) then
					victim = net.ReadEntity()
				end

				local flags = net.ReadUInt( 8 )

				local team_a = -1
				local team_v = -1
				if ( bit.band( flags, DEATH_NOTICE_FRIENDLY_VICTIM ) != 0 ) then team_v = -2 end
				if ( bit.band( flags, DEATH_NOTICE_FRIENDLY_ATTACKER ) != 0 ) then team_a = -2 end
				if ( isentity( attacker ) ) then team_a = attacker:Team() attacker = attacker:Name() end
				if ( isentity( victim ) ) then team_v = victim:Team() victim = victim:Name()  end

				hook.Run( "AddDeathNotice", attacker, team_a, inflictor, victim, team_v, flags )

			end )

		end )

	end

	if (SERVER) then

		timer.Simple( 1, function()

			util.AddNetworkString( "DeathNoticeEvent" )

			function GAMEMODE:SendDeathNotice( attacker, inflictor, victim, flags )

				net.Start( "DeathNoticeEvent" )
			
					if ( !attacker ) then
						net.WriteUInt( 0, 2 )
					elseif ( isstring( attacker ) ) then
						net.WriteUInt( 1, 2 )
						net.WriteString( attacker )
					elseif ( IsValid( attacker ) ) then
						net.WriteUInt( 2, 2 )
						net.WriteEntity( attacker )
					end
			
					net.WriteString( inflictor )
			
					if ( !victim ) then
						net.WriteUInt( 0, 2 )
					elseif ( isstring( victim ) ) then
						net.WriteUInt( 1, 2 )
						net.WriteString( victim )
					elseif ( IsValid( victim ) ) then
						net.WriteUInt( 2, 2 )
						net.WriteEntity( victim )
					end
			
					net.WriteUInt( flags, 8 )
			
				net.Broadcast()
			
			end

			function GAMEMODE:GetDeathNoticeEntityName( ent )
				
				if ent:IsANPlus( true ) then 
					return ent:ANPlusGetKillfeedName()
				end

				-- Some specific HL2 NPCs, just for fun
				-- TODO: Localization strings?
				if ( ent:GetClass() == "npc_citizen" ) then
					if ( ent:GetName() == "griggs" ) then return "Griggs" end
					if ( ent:GetName() == "sheckley" ) then return "Sheckley" end
					if ( ent:GetName() == "tobias" ) then return "Laszlo" end
					if ( ent:GetName() == "stanley" ) then return "Sandy" end

					if ( ent:GetModel() == "models/odessa.mdl" ) then return "Odessa Cubbage" end
				end

				-- Custom vehicle and NPC names
				if ( ent:IsVehicle() and ent.VehicleTable and ent.VehicleTable.Name ) then
					return ent.VehicleTable.Name
				end
				if ( ent:IsNPC() and ent.NPCTable and ent.NPCTable.Name ) then
					return ent.NPCTable.Name
				end

				-- Fallback to old behavior
				return "#" .. ent:GetClass()

			end

			function GAMEMODE:OnNPCKilled( ent, attacker, inflictor )

				-- Don't spam the killfeed with scripted stuff
				if ( ent:GetClass() == "npc_bullseye" || ent:GetClass() == "npc_launcher" ) then return end
			
				-- If killed by trigger_hurt, act as if NPC killed itself
				if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ent end
			
				-- NPC got run over..
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
				local AttackerClass = game.GetWorld()
			
				if ( IsValid( inflictor ) ) then InflictorClass = inflictor:GetClass() end
				if ( IsValid( attacker ) ) then
			
					AttackerClass = attacker
			
					-- If there is no valid inflictor, use the attacker (i.e. manhacks)
					if ( !IsValid( inflictor ) ) then InflictorClass = attacker:GetClass() end
			
					if ( attacker:IsPlayer() ) then
			
						local flags = 0
						if ( ent:IsNPC() and ent:Disposition( attacker ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_VICTIM end
			
						self:SendDeathNotice( attacker, InflictorClass, self:GetDeathNoticeEntityName( ent ), flags )
			
						return
					end
			
				end
			
				-- Floor turret got knocked over
				if ( ent:GetClass() == "npc_turret_floor" ) then AttackerClass = ent end
			
				-- It was NPC suicide..
				if ( ent == AttackerClass ) then InflictorClass = "suicide" end
			
				local flags = 0
				if ( IsValid( Entity( 1 ) ) and ent:IsNPC() and ent:Disposition( Entity( 1 ) ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_VICTIM end
				if ( IsValid( Entity( 1 ) ) and AttackerClass:IsNPC() and AttackerClass:Disposition( Entity( 1 ) ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_ATTACKER end
			
				self:SendDeathNotice( self:GetDeathNoticeEntityName( AttackerClass ), InflictorClass, self:GetDeathNoticeEntityName( ent ), flags )
			
			end
		end )
		
		local function MakeVehicle( ply, Pos, Ang, model, Class, VName, VTable, data )

			if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnVehicle", ply, model, VName, VTable ) ) then return end

			local veh = ents.Create( Class )
			if ( !IsValid( veh ) ) then return NULL end

			duplicator.DoGeneric( veh, data )

			veh:SetModel( model )

			-- Fallback vehiclescripts for HL2 maps ( dupe support )
			if ( model == "models/buggy.mdl" ) then veh:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" ) end
			if ( model == "models/vehicle.mdl" ) then veh:SetKeyValue( "vehiclescript", "scripts/vehicles/jalopy.txt" ) end

			-- Fill in the keyvalues if we have them
			if ( VTable && VTable.KeyValues ) then
				for k, v in pairs( VTable.KeyValues ) do

					local kLower = string.lower( k )

					veh:SetKeyValue( k, v )

				end
			end

			veh:SetAngles( Ang )
			veh:SetPos( Pos )

			DoPropSpawnedEffect( veh )

			veh:Spawn()
			veh:Activate()

			-- Some vehicles reset this in Spawn()
			if ( data && data.ColGroup ) then veh:SetCollisionGroup( data.ColGroup ) end

			-- Store spawnmenu data for addons and stuff
			if ( veh.SetVehicleClass && VName ) then veh:SetVehicleClass( VName ) end
			veh.VehicleName = VName
			veh.VehicleTable = VTable

			-- We need to override the class in the case of the Jeep, because it
			-- actually uses a different class than is reported by GetClass
			veh.ClassOverride = Class

			if ( IsValid( ply ) ) then
				gamemode.Call( "PlayerSpawnedVehicle", ply, veh )
			end

			return veh

		end

		duplicator.RegisterEntityClass( "prop_vehicle_jeep_old", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )
		duplicator.RegisterEntityClass( "prop_vehicle_jeep", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" ) 
		duplicator.RegisterEntityClass( "prop_vehicle_airboat", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )
		duplicator.RegisterEntityClass( "prop_vehicle_prisoner_pod", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )
		
		function Spawn_Vehicle( ply, vname, tr )

			-- We don't support this command from dedicated server console
			if ( !IsValid( ply ) ) then return end

			if ( !vname ) then return end

			local VehicleList = list.Get( "Vehicles" )
			local vehicle = VehicleList[ vname ]

			-- Not a valid vehicle to be spawning..
			if ( !vehicle ) then return end

			if ( !tr ) then
				tr = ply:GetEyeTraceNoCursor()
			end

			local Angles = ply:GetAngles()
			Angles.pitch = 0
			Angles.roll = 0
			Angles.yaw = Angles.yaw + 180

			local pos = tr.HitPos
			if ( vehicle.Offset ) then
				pos = pos + tr.HitNormal * vehicle.Offset
			end

			local Ent = MakeVehicle( ply, pos, Angles, vehicle.Model, vehicle.Class, vname, vehicle )
			if ( !IsValid( Ent ) ) then return end

			-- Unstable for Jeeps
			-- TryFixPropPosition( ply, Ent, tr.HitPos )

			if ( vehicle.Members ) then
				table.Merge( Ent, vehicle.Members )
				duplicator.StoreEntityModifier( Ent, "VehicleMemDupe", vehicle.Members )
			end

			undo.Create( "Vehicle" )
				undo.SetPlayer( ply )
				undo.AddEntity( Ent )
				undo.SetCustomUndoText( "Undone " .. vehicle.Name )
			undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )

			ply:AddCleanup( "vehicles", Ent )

		end
		
		concommand.Remove( "gm_spawnvehicle" )
		concommand.Add( "gm_spawnvehicle", function( ply, cmd, args ) Spawn_Vehicle( ply, args[1] ) end )

	end
end)

--[[////////////////////////
||||| Here We are checking spawned entities if they are a part of this base. If so, apply a valid data table.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

ANPDefaultOutputs = {
	['BaseNPC'] = {
		{ "OnFoundEnemy" , "OnNPCFoundEnemy" },
		{ "OnLostEnemy" , "OnNPCLostEnemy" },
		{ "OnLostEnemyLOS" , "OnNPCLostEnemyLOS" },
		{ "OnDeploy" , "OnNPCTurretDeploy" },
		{ "OnRetire" , "OnNPCTurretRetire" },
		{ "OnTipped" , "OnNPCTurretTipped" },
	}
}

hook.Add( "OnEntityCreated", "ANPlusLoad_OnEntityCreated", function(ent)

	timer.Simple( 0, function()

		if !IsValid(ent) then return end	

		if IsValid(ent:GetOwner()) && ent:GetOwner():IsANPlus(true) then		
			local npc = ent:GetOwner()		
			if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCCreateEntity'] != nil then
				npc:ANPlusGetDataTab()['Functions']['OnNPCCreateEntity'](npc, ent)		
			end				
		end
		
		if (SERVER) then
			ANPlusFilterInternal( ent, ent:GetKeyValues()['parentname'] )
			ent.m_pMyPlayer = nil
		end	
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
		local bool = npc:ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc, npc:IsNPC() && npc:GetActiveWeapon() || nil, data) 
		npc.m_tLastFiredBullet = data
		return bool == nil && true || bool
		
	end		
	if IsValid(npc) && IsValid(npc:GetOwner()) && npc:GetOwner():IsANPlus(true) && npc:GetOwner():ANPlusGetDataTab()['Functions'] && npc:GetOwner():ANPlusGetDataTab()['Functions']['OnNPCFireBullets'] != nil then
		
		--npc:GetOwner():ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc:GetOwner(), npc, data)	
		local bool = npc:GetOwner():ANPlusGetDataTab()['Functions']['OnNPCFireBullets'](npc:GetOwner(), npc, data) 
		npc.m_tLastFiredBullet = data
		return bool == nil && true || bool	
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
		
		if ent:GetNW2Bool( "m_bANPMuted" ) then return false end				

		if ent:ANPlusGetDataTab()['SoundModification'] && ent:ANPlusGetDataTab()['SoundModification']['SoundList'] then	
			
			local sndTab = ent:ANPlusGetDataTab()['SoundModification']['SoundList']		
			local delDigits = string.gsub( data.OriginalSoundName, "%d", "" )
			
			for _, v in ipairs( sndTab ) do		
				
				if v then

					if string.find( string.lower( data.SoundName ), v[ 1 ] ) || !data.SentenceIndex && string.find( data.OriginalSoundName, v[ 1 ] ) || data.SentenceIndex && delDigits == v[ 1 ] then 	
						
						if v['Play'] != nil && v['Play'] == false then return false end			
						
						local sndRNG = v['Replacement'] && istable( v['Replacement'] ) && v['Replacement'][ math.random( 1, #v['Replacement'] ) ] || v['Replacement'] || data.SoundName
						
						local sndScript = sound.GetProperties( sndRNG ) || false
						
						local sndSentence = ANPlusScriptedSentences[ sndRNG ] && sndRNG || false	
							
						local sndReplace = sndScript && ( istable( sndScript['sound'] ) && sndScript['sound'][ math.random( 1, #sndScript['sound'] ) ] || sndScript['sound'] ) || sndSentence || sndRNG
							
						sndReplace = !v['SoundCharacter'] && sndReplace || v['SoundCharacter'] == true && ( sndChars[ string.Left( data.SoundName, 1 ) ] && string.Left( data.SoundName, 1 ) .. sndReplace || sndReplace ) || isstring( v['SoundCharacter'] ) && v['SoundCharacter'] .. sndReplace 
						
						
						local sndLVL = v['SoundLevel'] && istable( v['SoundLevel'] ) && math.random( v['SoundLevel'][ 1 ], ( v['SoundLevel'][ 2 ] || v['SoundLevel'][ 1 ] ) ) || v['SoundLevel'] || sndScript && sndScript['level'] && istable( sndScript['level'] ) && math.random( sndScript['level'][ 1 ], ( sndScript['level'][ 2 ] || sndScript['level'][ 1 ] ) ) || sndScript && sndScript['level'] || data.SoundLevel
						
						local sndPitch = ent.ANPlusOverPitch || v['Pitch'] && istable( v['Pitch'] ) && math.random( v['Pitch'][ 1 ], ( v['Pitch'][ 2 ] || v['Pitch'][ 1 ] ) ) || v['Pitch'] || sndScript && sndScript['pitch'] && istable( sndScript['pitch'] ) && math.random( sndScript['pitch'][ 1 ], ( sndScript['pitch'][ 2 ] || sndScript['pitch'][ 1 ] ) ) || sndScript && sndScript['pitch']
						
						sndPitch = sndPitch && ( sndPitch < 1 && data.Pitch * sndPitch || sndPitch ) || data.Pitch
						local sndChannel = v['Channel'] || sndScript && sndScript['channel'] || data.Channel
						local sndVolume = v['Volume'] && istable( v['Volume'] ) && math.random( v['Volume'][ 1 ], ( v['Volume'][ 2 ] || v['Volume'][ 1 ] ) ) || v['Volume'] || sndScript && sndScript['volume']
						sndVolume = sndVolume && ( sndVolume < 1 && data.Volume * sndVolume || sndVolume ) || data.Volume
						local sndFlags = v['Flags'] || data.Flags
						local sndDSP = v['DSP'] || data.DSP

						data.SoundName			= !data.SentenceIndex && sndReplace || data.SoundName
						data.SoundLevel 		= sndLVL
						data.Pitch 				= sndPitch 
						data.Channel 			= sndChannel
						data.Volume 			= sndVolume
						data.Flags				= sndFlags
						data.DSP 				= sndDSP
						
						if data.SentenceIndex && sndRNG != data.OriginalSoundName then
							
							if sndScript || string.find( string.lower( sndRNG ), "/" ) then	
								ent:EmitSound( sndReplace, data.SoundLevel, data.Pitch, data.Volume, data.Channel, data.Flags, data.DSP )
							elseif sndSentence then
								
								ent:ANPlusEmitSoundSentence( sndReplace )
							else	
								ent:PlaySentence( sndReplace, 0, data.Volume )
							end
							
							if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'] != nil then
								--ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)		
								local bool = ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)
								ent.m_tLastSoundEmitted = data
								return bool == nil && false || bool
							end	

							return false
						end
						
						if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'] != nil then
							--ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)		
							local bool = ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)
							ent.m_tLastSoundEmitted = data
							return bool == nil && true || bool
						end	

						return true						
					end	
					
				end
				
			end			
		end
		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'] != nil then
			--ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)		
			local bool = ent:ANPlusGetDataTab()['Functions']['OnNPCEmitSound'](ent, data)
			ent.m_tLastSoundEmitted = data
			return bool == nil && true || bool
		end	
		ent.m_tLastSoundEmitted = data
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
		
		end
		if (CLIENT) then
			if ( ent:IsANPlus() && ent:ANPlusGetDataTab()['BossMusic'] ) || ent.m_ANPlusBossMusic then	
				ent:ANPlusBossMusic( true )	
			end
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

hook.Add( "InitPostEntity", "ANPlus_InitPostEntity", function() 

	if (CLIENT) then
		net.Start( "anplus_sharebranch" )
		net.WriteString( BRANCH )
		net.SendToServer() 
	end
	
end )

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

gameevent.Listen( "break_prop" )
hook.Add( "break_prop", "ANPlusLoad_BreakProp", function( data )
	local entindex = data.entindex	
	local userid = data.userid		
	local ent = ents.GetByIndex( entindex )
	local attacker = ents.GetByIndex( userid )
	if IsValid(ent) && ent:IsANPlus(true) then		
		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCBreak'] != nil then
			ent:ANPlusGetDataTab()['Functions']['OnNPCBreak'](ent, attacker)		
		end					
	end
end )
