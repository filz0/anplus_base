------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

--[[////////////////////////
||||| Here We are checking spawned entities if they are a part of this base. If so, apply valid data table.
]]--\\\\\\\\\\\\\\\\\\\\\\\\
hook.Add( "OnEntityCreated", "ANPlusLoad_OnEntityCreated", function(ent)
	timer.Simple( 0, function() if !IsValid(ent) then return end ent:SetNWString( "ANPlusNWName", ent:GetInternalVariable( "m_iName" ) ) end )	
	timer.Simple( 0.1, function()		
		if !IsValid(ent) then return end				
		if IsValid(ent:GetOwner()) && ent:GetOwner():IsANPlus(true) then		
			local npc = ent:GetOwner()		
			if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCCreateEntity'] != nil then
				npc:ANPlusGetDataTab()['Functions']['OnNPCCreateEntity'](npc, ent)		
			end				
		end
		if ( SERVER ) then
			for i = 1, #ANPlusDangerStuffGlobalNameOrClass do
				local danger = ANPlusDangerStuffGlobalNameOrClass[ i ]
				if danger && !ent:IsWeapon() && ( string.find( string.lower( ent:ANPlusGetName() ), danger ) || string.find( string.lower( ent:GetClass() ), danger ) ) && !table.HasValue( ANPlusDangerStuffGlobal, ent ) then
					table.insert( ANPlusDangerStuffGlobal, ent )
				end			
			end
			ent:ANPlusIgnoreTillSet()
		end		

		ent:ANPlusNPCApply( ent:GetNWString( "ANPlusNWName" ) )		
		ent.m_pMyPlayer = nil	
		
	end)	
end)

--[[////////////////////////
||||| If any KeyValues are getting applied to our Entity, We want access to them. It won't run on KeyValues applied by the spawn menu on spawn.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

hook.Add( "EntityKeyValue", "ANPlusLoad_EntityKeyValue", function(ent, key, val)
	if IsValid(ent) && ent:IsANPlus(true) then		
		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCKeyValue'] != nil then
			ent:ANPlusGetDataTab()['Functions']['OnNPCKeyValue'](ent, key, val)		
		end					
	end	
end)

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
end)

--[[////////////////////////
||||| Thanks to this hook, We can replace NPC' sounds. We can also simlate NPC hearing stuff. This hook doesn't work with scripted sentences (facepunch pls fix).
]]--\\\\\\\\\\\\\\\\\\\\\\\\

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
end)

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
				if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCRemove'] != nil then
					ent:ANPlusGetDataTab()['Functions']['OnNPCRemove'](ent)	
				end
			end
		elseif (CLIENT) then
		end
	end	
end)