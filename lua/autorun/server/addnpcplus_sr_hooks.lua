------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

util.AddNetworkString("anplus_data_tab")
util.AddNetworkString("anplus_net_name")
util.AddNetworkString("anplus_fix_bones")
util.AddNetworkString("anplus_controller")
util.AddNetworkString("anplus_holo_eff")
util.AddNetworkString("anplus_client_particle_start")
util.AddNetworkString("anplus_client_particle_stop")
util.AddNetworkString("anplus_play_ui_snd")
util.AddNetworkString("anplus_chatmsg_ply")
util.AddNetworkString("anplus_screenmsg_ply")
util.AddNetworkString("anplus_savedata_tocl")
util.AddNetworkString("anplus_savedata_tosv")
util.AddNetworkString("anplus_notify")
util.AddNetworkString("anplus_paint_decal")
util.AddNetworkString("anplus_net_entity")
util.AddNetworkString("anplus_propmenu")
util.AddNetworkString("anplus_savedata_net")
util.AddNetworkString("anplus_ply_spawnmenu") 

net.Receive("anplus_ply_spawnmenu", function(len, ply)	
	local b = net.ReadBool()
	ply.m_bSpawnMenuOpen = b
end)

--[[////////////////////////
||||| This command can be used to freeze NPCs in place. Why for? IDK. It looks cool.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

concommand.Add( "anplus_sleep_npcs", function(ply, cmd, args, argStr)
	if !ply:IsAdmin() then	
		ply:ChatPrint( "Sorry but this command is reserved for Admins only." )		
	else		
		for _, npc in pairs( ents.GetAll() ) do		
			if !IsValid(npc) || !npc:IsNPC() then continue end
			npc:SetKeyValue( "sleepstate", "3" )
		end		
	end	
end)

--[[////////////////////////
||||| Unfreeze NPCs
]]--\\\\\\\\\\\\\\\\\\\\\\\\

concommand.Add( "anplus_wake_npcs", function(ply, cmd, args, argStr)
	if !ply:IsAdmin() then	
		ply:ChatPrint( "Sorry but this command is reserved for Admins only." )		
	else		
		for _, npc in pairs( ents.GetAll() ) do		
			if !IsValid(npc) || !npc:IsNPC() then continue end
			npc:SetKeyValue( "sleepstate", "0" )
		end		
	end	
end)

--[[////////////////////////
||||| This command can be used to add ANPlus ID to an already spawned NPCs/Entities. It will be transformed on map load or by using the command from below.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

concommand.Add( "anplus_set_ent", function(ply, cmd, args, argStr)
	if !ply:IsAdmin() then	
		ply:ChatPrint( "Sorry but this command is reserved for Admins only." )		
	else		
		local tr = ply:GetEyeTrace()		
		if tr.Hit && IsValid(tr.Entity) && argStr && !tr.Entity:IsANPlus(true) then
			--npc:ANPlusIgnoreTillSet()		
			tr.Entity:ANPlusNPCApply( argStr, true )	
		end		
	end	
end)

--[[////////////////////////
||||| Loads ANPlus Data tables on valid ANPlus NPCs/Entities.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

concommand.Add( "anplus_reload_ents", function(ply)
	if !ply:IsAdmin() then
		ply:ChatPrint( "Sorry but this command is reserved for Admins only." )	
	else		
		for _, npc in pairs( ents.GetAll() ) do		
			if !IsValid(npc) || npc:IsANPlus(true) then continue end
			--npc:ANPlusIgnoreTillSet()		
			npc:ANPlusNPCApply( npc:ANPlusGetDataTab()['Name'], true )	
		end		
	end	
end)

hook.Add( "PlayerSpawnedNPC", "ANPlusLoad_PlayerSpawnedNPC", function(ply, npc)		
	local dataTab = ANPlusLoadGlobal[ npc:GetKeyValues()['parentname'] ]	
	if dataTab then
		npc.m_pMyPlayer = ply
		if GetConVar( "anplus_random_placement" ):GetBool() then
			npc:ANPlusRandomTeleport( false, 2, Vector( 0, 0, 1 ), function()
				npc:SetAngles( npc:GetAngles() + Angle( 0, math.random( 0, 360 ), 0 ) )
			end )
		end
	end
end)

hook.Add( "PlayerSpawnedSENT", "ANPlusLoad_PlayerSpawnedSENT", function(ply, ent)		
	local dataTab = ANPlusLoadGlobal[ ent:GetKeyValues()['parentname'] ]
	if dataTab then ent.m_pMyPlayer = ply end
end)

hook.Add( "PlayerDeath", "ANPlusLoad_PlayerDeath", function(ply, inf, att)
	if IsValid(ply) then
		if IsValid(att) && att:IsANPlus(true) then		
			if att:ANPlusGetDataTab()['Functions'] && att:ANPlusGetDataTab()['Functions']['OnNPCKilledPlayer'] != nil then	
				att:ANPlusGetDataTab()['Functions']['OnNPCKilledPlayer'](ply, inf, att)			
			end		
		end
		if ply.ANPlusPlayerDeath != nil then ply:ANPlusPlayerDeath(ply, inf, att) end
	end
end)

hook.Add( "CreateEntityRagdoll", "ANPlusLoad_CreateEntityRagdoll", function(npc, rag)
	
	if IsValid(npc) && npc:IsNPC() && IsValid(rag) then
		
		npc.m_pSRagdollEntity = rag

		if npc:IsANPlus() then
		
			if npc:ANPlusGetDataTab() then
			
				if npc:ANPlusGetDataTab()['CurFakeModel'] then rag:ANPlusFakeModel( npc:ANPlusGetDataTab()['CurFakeModel']['Model'], npc:ANPlusGetDataTab()['CurFakeModel']['VisualTab'] ) end
				
				for i = 1, #npc:GetBodyGroups() do		
					rag:SetBodygroup( i, npc:GetBodygroup( i ) )
				end
				
				for i = 0, #npc:GetMaterials() do				
					rag:SetSubMaterial( i, npc:GetSubMaterial( i ) || npc:GetMaterials()[ i ] )
				end
				
				if npc:ANPlusGetDataTab()['CurBones'] then
					for i = 1, #npc:ANPlusGetDataTab()['CurBones'] do		
						local bone = rag:GetPhysicsObjectNum( i )					
						if IsValid( bone ) then
							bone:SetPos( npc:ANPlusGetDataTab()['CurBones'][ i ][ 1 ] )
							bone:SetAngles( npc:ANPlusGetDataTab()['CurBones'][ i ][ 2 ] )
							bone:EnableMotion( true )				
						end			
					end
				end
			
			end
			
			if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'] != nil then				
				npc:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'](npc, rag)			
			end
			
		end
		
		if IsValid(npc) && IsValid(npc:GetOwner()) && npc:GetOwner():IsANPlus() then
		
			local raggibOwner = npc:GetOwner()
		
			if raggibOwner:ANPlusGetDataTab()['Functions'] && raggibOwner:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'] != nil then			
				raggibOwner:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'](raggibOwner, rag)		
			end
		
		end
		
	end
	
end)

hook.Add( "OnNPCKilled", "ANPlusLoad_OnNPCKilled", function(npc, att, inf)
	if IsValid(npc) then
		if npc:IsANPlus() then
			if npc:ANPlusGetDataTab() && npc:ANPlusGetDataTab()['CurModel'] then
				
				local CurBones = {}			
				for i = 0, npc:GetBoneCount() do
					
					local bone = npc:LookupBone( npc:GetBoneName( i ) )
					
					if bone then
						
						local bonepos, boneang = npc:GetBonePosition( npc:TranslatePhysBoneToBone( i ) )
						
						CurBones[ i ] = { bonepos, boneang }
					
					end
				
				end
				
				local addTab = { ['CurBones'] = CurBones }
				table.Merge( npc:ANPlusGetDataTab(), addTab )
				
				if npc:ANPlusFakeModel() then
					local addTab = { ['CurFakeModel'] = { ['Model'] = npc:ANPlusFakeModel() && npc:ANPlusFakeModel():GetModel() || "", ['VisualTab'] = npc:ANPlusGetVisual() } }			
					table.Merge( npc:ANPlusGetDataTab(), addTab )
				end
				
				npc:ANPlusApplyDataTab( npc:ANPlusGetDataTab() )
				
				npc:SetModel( npc:ANPlusGetDataTab()['CurModel'] )
				
			end
			
			if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCDeath'] != nil then				
				npc:ANPlusGetDataTab()['Functions']['OnNPCDeath'](npc, att, inf)			
			end
			
			if IsValid( npc:ANPlusGetFollowTarget() ) && npc:ANPlusGetFollowTarget():IsPlayer() then ANPlusMSGPlayer( npc:ANPlusGetFollowTarget(), "Following you " .. npc:ANPlusGetName() .. " has died.", Color( 255, 50, 0 ), "ANP.UI.Error" ) end
			
			if npc:ANPlusGetDataTab()['UseANPSquadSystem'] then 
				npc:ANPlusRemoveFromCSquad( npc:ANPlusGetSquadName() )
			end
			
			if IsValid(npc:ANPlusFakeModel()) then npc:ANPlusFakeModel():Remove() end
			
		end
	
		if IsValid(att) && att:IsANPlus(true) then
			if att:ANPlusGetDataTab()['Functions'] && att:ANPlusGetDataTab()['Functions']['OnNPCKilledNPC'] != nil then			
				att:ANPlusGetDataTab()['Functions']['OnNPCKilledNPC'](att, npc, inf)			
			end	
		end
	
		if npc.ANPlusNPCDeath != nil then npc:ANPlusNPCDeath(npc, att, inf) end
	end
end)

hook.Add( "AcceptInput", "ANPlusLoad_AcceptInput", function(ent, input, activator, caller, data)
	if ( ent && ent:IsANPlus(true) && ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCInput'] != nil ) then
		ent:ANPlusGetDataTab()['Functions']['OnNPCInput'](ent, input, activator, caller, data)					
	end
	if ( ent:IsANPlus(true) && string.Left( input, 6 ) == "event_" ) then
		ent:ANPlusEvent( string.sub( input, 7 ) )
		return true
	end	
end)

hook.Add( "AllowPlayerPickup", "ANPlusLoad_AllowPlayerPickup", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then		
		if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCAllowPlayerPickup'] != nil then
			npc:ANPlusGetDataTab()['Functions']['OnNPCAllowPlayerPickup'](ply, npc)		
		end	
		return npc:ANPlusGetDataTab()['AllowPlayerPickUp']	
	end	
end)


hook.Add( "OnPlayerPhysicsPickup", "ANPlusLoad_OnPlayerPhysicsPickup", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then		
		if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCOnPlayerPickup'] != nil then
			npc:ANPlusGetDataTab()['Functions']['OnNPCOnPlayerPickup'](ply, npc)		
		end	
	end	
end)

hook.Add( "OnPlayerPhysicsDrop", "ANPlusLoad_OnPlayerPhysicsDrop", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then		
		if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCOnPlayerDrop'] != nil then
			npc:ANPlusGetDataTab()['Functions']['OnNPCOnPlayerDrop'](ply, npc, thrown)		
		end	
	end	
end)

hook.Add( "PhysgunPickup", "ANPlusLoad_PhysgunPickup", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then			
		return npc:ANPlusGetDataTab()['AllowPhysgunPickup']		
	end	
end)

hook.Add( "OnPhysgunPickup", "ANPlusLoad_OnPhysgunPickup", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then		
		if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCOnPhysgunPickup'] != nil then
			npc:ANPlusGetDataTab()['Functions']['OnNPCOnPhysgunPickup'](ply, npc)		
		end	
	end	
end)

hook.Add( "OnPhysgunFreeze", "ANPlusLoad_OnPhysgunFreeze", function(wep, physObj, ent, ply)
	if IsValid(ply) && IsValid(ent) && ent:IsANPlus(true) then		
		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCOnPhysgunFreeze'] != nil then
			ent:ANPlusGetDataTab()['Functions']['OnNPCOnPhysgunFreeze'](ply, ent, wep, physObj)		
		end	
	end	
end)

hook.Add( "GravGunPickupAllowed", "ANPlusLoad_GravGunPickupAllowed", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then			
		return npc:ANPlusGetDataTab()['AllowGravGunPickUp']		
	end	
end)

hook.Add( "GravGunOnPickedUp", "ANPlusLoad_GravGunOnPickedUp", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then	
		if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCGravGunOnPickedUp'] != nil then
			npc:ANPlusGetDataTab()['Functions']['OnNPCGravGunOnPickedUp'](ply, npc)		
		end	
	end	
end)

hook.Add( "GravGunOnDropped", "ANPlusLoad_GravGunOnDropped", function(ply, npc)
	if IsValid(ply) && IsValid(npc) && npc:IsANPlus(true) then	
		if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCGravGunOnDropped'] != nil then
			npc:ANPlusGetDataTab()['Functions']['OnNPCGravGunOnDropped'](ply, npc)		
		end	
	end	
end)

hook.Add( "ScalePlayerDamage", "ANPlusLoad_ScalePlayerDamage", function(ply, hg, dmginfo)
	local att = dmginfo:GetAttacker()	
	if IsValid(att) && att:IsANPlus(true) then	
		if att:ANPlusGetDataTab()['Functions'] && att:ANPlusGetDataTab()['Functions']['OnNPCScaleDamageOnPlayer'] != nil then
			att:ANPlusGetDataTab()['Functions']['OnNPCScaleDamageOnPlayer'](att, ply, hg, dmginfo)		
		end	
	end
end)

hook.Add( "ScaleNPCDamage", "ANPlusLoad_EntityTakeDamage", function(npc, hg, dmginfo)
	
	local att = dmginfo:GetAttacker()
	
	if IsValid(npc) then
		
		npc.m_fHitGroupLast = hg
		
		if npc:IsANPlus() then
		
			if npc:ANPlusGetDataTab()['DamageTakenScale'] then
			
				local dmgScaleTab = npc:ANPlusGetDataTab()['DamageTakenScale']
			
				if dmgScaleTab['Body'] && hg == HITGROUP_GENERIC then

					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['Body'] / 100 ) >= -1 && dmgScaleTab['Body'] / 100 || -1 ) )
		
				elseif dmgScaleTab['Head'] && hg == HITGROUP_HEAD then
			
					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['Head'] / 100 ) >= -1 && dmgScaleTab['Head'] / 100 || -1 ) )

				elseif dmgScaleTab['Chest'] && hg == HITGROUP_CHEST then

					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['Chest'] / 100 ) >= -1 && dmgScaleTab['Chest'] / 100 || -1 ) )

				elseif dmgScaleTab['Stomach'] && hg == HITGROUP_STOMACH then
			
					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['Stomach'] / 100 ) >= -1 && dmgScaleTab['Stomach'] / 100 || -1 ) )

				elseif dmgScaleTab['LeftArm'] && hg == HITGROUP_LEFTARM then
				
					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['LeftArm'] / 100 ) >= -1 && dmgScaleTab['LeftArm'] / 100 || -1 ) )

				elseif dmgScaleTab['RightArm'] && hg == HITGROUP_RIGHTARM then
			
					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['RightArm'] / 100 ) >= -1 && dmgScaleTab['RightArm'] / 100 || -1 ) )

				elseif dmgScaleTab['LeftLeg'] && hg == HITGROUP_LEFTLEG then
			
					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['LeftLeg'] / 100 ) >= -1 && dmgScaleTab['LeftLeg'] / 100 || -1 ) )

				elseif dmgScaleTab['RightLeg'] && hg == HITGROUP_RIGHTLEG then
			
					dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgScaleTab['RightLeg'] / 100 ) >= -1 && dmgScaleTab['RightLeg'] / 100 || -1 ) )

				end
			
			end
			
			if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCScaleDamage'] != nil then

				npc:ANPlusGetDataTab()['Functions']['OnNPCScaleDamage'](npc, hg, dmginfo)
	
			end
			
		end
	
	end
	
	if IsValid(att) && att:IsANPlus(true) then
	
		if att:ANPlusGetDataTab()['Functions'] && att:ANPlusGetDataTab()['Functions']['OnNPCScaleDamageOnNPC'] != nil then
			att:ANPlusGetDataTab()['Functions']['OnNPCScaleDamageOnNPC'](att, npc, hg, dmginfo)	
		end
	
	end
	
end)

hook.Add( "ANPOnStartScriptedSequence", "ANPlusLoad_SS_Start", function()
	local activator, caller = ACTIVATOR, CALLER
	if IsValid(caller) && IsValid(caller:GetInternalVariable( "m_hOwnerEntity" )) && caller:GetInternalVariable( "m_hOwnerEntity" ):IsANPlus() then
		local ent = caller:GetInternalVariable( "m_hOwnerEntity" )
		local seq = isstring( caller:GetKeyValues().m_iszPlay ) && caller:GetKeyValues().m_iszPlay || ent:GetSequenceName( ent:SelectWeightedSequence( caller:GetKeyValues().m_iszPlay ) )
		local seqID, seqDur = ent:LookupSequence( seq )
		seqDur = seqDur / caller.Speed
		if isfunction( caller.callback ) then caller:callback(seqID, seqDur, ent, caller) end	
	end
end)

hook.Add( "ANPOnEndScriptedSequence", "ANPlusLoad_SS_End", function()
	local activator, caller = ACTIVATOR, CALLER
	if IsValid(caller) && IsValid(caller:GetInternalVariable( "m_hOwnerEntity" )) && caller:GetInternalVariable( "m_hOwnerEntity" ):IsANPlus() then
		local ent = caller:GetInternalVariable( "m_hOwnerEntity" )
		local seq = isstring( caller:GetKeyValues().m_iszPlay ) && caller:GetKeyValues().m_iszPlay || ent:GetSequenceName( ent:SelectWeightedSequence( caller:GetKeyValues().m_iszPlay ) )
		local seqID, seqDur = ent:LookupSequence( seq )
		seqDur = seqDur / caller.Speed
		if isfunction( caller.postCallback ) then caller:postCallback(seqID, seqDur, ent, caller) end	
	end
end)

hook.Add( "GravGunPunt", "ANPlusLoad_GravGunPunt", function(ply, npc)
	if npc:IsANPlus(true) && npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCGravGunPunt'] != nil then	
		npc:ANPlusGetDataTab()['Functions']['OnNPCGravGunPunt'](ply, npc)		
	end
end)

hook.Add( "OnEntityWaterLevelChanged", "ANPlusLoad_OnEntityWaterLevelChanged", function(npc, old, new)
	if npc:IsANPlus(true) && npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCWaterLevelChanged'] != nil then		
		npc:ANPlusGetDataTab()['Functions']['OnNPCWaterLevelChanged'](npc, old, new)		
	end
end)	

hook.Add( "EntityTakeDamage", "ANPlusLoad_EntityTakeDamage", function(ent, dmginfo) 

	local att = dmginfo:GetAttacker()
	local inf = dmginfo:GetInflictor()
	local dmginfot = dmginfo:GetDamageType()	

	if ent.m_bNPCNoDamage then dmginfo:SetDamage( 0 ) end
	
	if !GetConVar( "anplus_ff_disabled" ):GetBool() && ent:IsANPlus() && IsValid(att) && ( att:IsNPC() || att:IsPlayer() ) && ent != att && ent:Disposition( att ) == D_LI then
	
		dmginfo:SetDamage( 0 )
		
	elseif ent:IsANPlus() && ent:ANPlusGetDataTab()['DamageSelfScale'] && IsValid(att) && ent == att then
	
		dmginfo:AddDamage( dmginfo:GetDamage() * ( ( ent:ANPlusGetDataTab()['DamageSelfScale'] / 100 ) >= -1 && ent:ANPlusGetDataTab()['DamageSelfScale'] / 100 || -1 ) )
		
	elseif !GetConVar( "anplus_ff_disabled" ):GetBool() && IsValid(att) && att:IsPlayer() && ent:IsANPlus() && ent:Disposition( att ) == D_LI then	
	
		dmginfo:SetDamage( 0 )
		
	end
	
	if IsValid(inf) && inf != ent && inf.ANPlusQuickDamageDealtOverride then
		
		inf.ANPlusQuickDamageDealtOverride( inf, ent, dmginfo )

	end
	if IsValid(att) && att != ent && att.ANPlusQuickDamageDealtOverride then
		
		att.ANPlusQuickDamageDealtOverride( att, ent, dmginfo )

	end
	if ent.ANPlusQuickDamageTakenOverride then
		
		ent.ANPlusQuickDamageTakenOverride( ent, dmginfo )

	end
	
	if IsValid(att) && att:IsANPlus(true) then
	
		if att:ANPlusGetDataTab()['DamageDealtScale'] then dmginfo:AddDamage( dmginfo:GetDamage() * ( ( att:ANPlusGetDataTab()['DamageDealtScale'] / 100 ) >= -1 && att:ANPlusGetDataTab()['DamageDealtScale'] / 100 || -1 ) ) end
		
		if att:ANPlusGetDataTab()['Functions'] && att:ANPlusGetDataTab()['Functions']['OnNPCDamageOnEntity'] != nil then
			att:ANPlusGetDataTab()['Functions']['OnNPCDamageOnEntity'](att, ent, dmginfo)	
		end
	
	end
	
	if IsValid(ent) && ent:IsANPlus(true) then
		
		local dmg = dmginfo:GetDamage()
		
		if ent:ANPlusGetDataTab()['DamageTakenScale'] then
		
			local dmgTab = ent:ANPlusGetDataTab()['DamageTakenScale']
			local dmgT = dmginfo:GetDamageType()
			
			if dmgTab[ dmgT ] then	
				dmginfo:AddDamage( dmginfo:GetDamage() * ( ( dmgTab[ dmgT ] / 100 ) >= -1 && dmgTab[ dmgT ] / 100 || -1 ) )			
			end			
		end

		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCTakeDamage'] != nil then
			ent:ANPlusGetDataTab()['Functions']['OnNPCTakeDamage'](ent, dmginfo)			
		end
	
	end

end)

hook.Add( "PostEntityTakeDamage", "ANPlusLoad_PostEntityTakeDamage", function(ent, dmginfo, tookDMG) 

	local att = dmginfo:GetAttacker()	
	
	if IsValid(att) && att:IsANPlus(true) then

		if att:ANPlusGetDataTab()['Functions'] && att:ANPlusGetDataTab()['Functions']['OnNPCPostDamageOnEntity'] != nil then
			att:ANPlusGetDataTab()['Functions']['OnNPCPostDamageOnEntity'](att, ent, dmginfo, tookDMG)	
		end
	
	end
	
	if IsValid(ent) && ent:IsANPlus(true) then

		if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCPostTakeDamage'] != nil then
			ent:ANPlusGetDataTab()['Functions']['OnNPCPostTakeDamage'](ent, dmginfo, tookDMG)			
		end
		
		if ent:ANPlusGetDataTab()['HealthBar'] then
			ent:SetNWFloat( "m_fANPBossHP", ent:Health() )
			--ent:SetNWFloat( "m_fANPBossHPMax", ent:GetMaxHealth() )
		end
	
	end

end)

hook.Add( "PlayerUse", "ANPlusLoad_PlayerUse", function(activator, caller, useType, value)
	if IsValid(caller) && caller:IsANPlus(true) then
		useType = useType || caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['SetUseType'] || 3
		caller:ANPlusOnUse(activator, caller, useType)
	end
end)

hook.Add( "PlayerCanPickupWeapon", "ANPlusLoad_PlayerCanPickupWeapon", function(ply, wep)
	if wep.Base == "swep_anp_base" then
		if wep.Primary.AmmoType && wep:Clip1() > 0 then ply:GiveAmmo( wep:Clip1(), wep.Primary.AmmoType, false ) end
		wep:Remove()
		return false 
	end		
end)

hook.Add( "PlayerEnteredVehicle", "ANPlusLoad_PlayerEnteredVehicle", function(ply, veh, role)
	if veh:IsANPlus(true) && veh:ANPlusGetDataTab()['Functions'] && veh:ANPlusGetDataTab()['Functions']['OnNPCPlayerEnter'] != nil then
		veh:ANPlusGetDataTab()['Functions']['OnNPCPlayerEnter'](ply, veh, role)			
	end
end)

hook.Add( "PlayerLeaveVehicle", "ANPlusLoad_PlayerLeaveVehicle", function(ply, veh)
	if veh:IsANPlus(true) && veh:ANPlusGetDataTab()['Functions'] && veh:ANPlusGetDataTab()['Functions']['OnNPCPlayerLeave'] != nil then
		veh:ANPlusGetDataTab()['Functions']['OnNPCPlayerLeave'](ply, veh)			
	end
end)

hook.Add( "OnNPCFoundEnemy", "ANPlusLoad_OnNPCFoundEnemy", function()
	local activator, caller = ACTIVATOR, CALLER
	if caller:IsANPlus() && caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['OnNPCFoundEnemy'] != nil then
		local enemy = caller:GetEnemy()
		caller.m_pLastEnemy = enemy
		caller:ANPlusGetDataTab()['Functions']['OnNPCFoundEnemy'](caller, enemy)			
	end
end )

hook.Add( "OnNPCLostEnemy", "ANPlusLoad_OnNPCLostEnemy", function()
	local activator, caller = ACTIVATOR, CALLER
	if caller:IsANPlus() && caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['OnNPCLostEnemy'] != nil then
		caller:ANPlusGetDataTab()['Functions']['OnNPCLostEnemy'](caller, caller.m_pLastEnemy)			
	end
end )

hook.Add( "OnNPCLostEnemyLOS", "ANPlusLoad_OnNPCLostEnemyLOS", function()
	local activator, caller = ACTIVATOR, CALLER
	if caller:IsANPlus() && caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['OnNPCLostEnemyLOS'] != nil then
		caller:ANPlusGetDataTab()['Functions']['OnNPCLostEnemyLOS'](caller, caller.m_pLastEnemy)			
	end
end )

hook.Add( "OnNPCTurretDeploy", "ANPlusLoad_OnNPCTurretDeploy", function()
	local activator, caller = ACTIVATOR, CALLER
	if caller:IsANPlus() && caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['OnNPCTurretDeploy'] != nil then
		caller:ANPlusGetDataTab()['Functions']['OnNPCTurretDeploy'](caller, caller.m_pLastEnemy)			
	end
end )

hook.Add( "OnNPCTurretRetire", "ANPlusLoad_OnNPCTurretRetire", function()
	local activator, caller = ACTIVATOR, CALLER
	if caller:IsANPlus() && caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['OnNPCTurretRetire'] != nil then
		caller:ANPlusGetDataTab()['Functions']['OnNPCTurretRetire'](caller, caller.m_pLastEnemy)			
	end
end )

hook.Add( "OnNPCTurretTipped", "ANPlusLoad_OnNPCTurretTipped", function()
	local activator, caller = ACTIVATOR, CALLER
	if caller:IsANPlus() && caller:ANPlusGetDataTab()['Functions'] && caller:ANPlusGetDataTab()['Functions']['OnNPCTurretTipped'] != nil then
		caller:ANPlusGetDataTab()['Functions']['OnNPCTurretTipped'](caller, caller.m_pLastEnemy)			
	end
end )