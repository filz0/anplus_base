
util.AddNetworkString("anplus_data_tab")
--util.AddNetworkString("anplus_gmodsave_load_from_the_menu")
util.AddNetworkString("anplus_fix_bones")
util.AddNetworkString("anplus_set_ik")
util.AddNetworkString("anplus_holo_eff")
util.AddNetworkString("anplus_client_effect")
util.AddNetworkString("anplus_dev_isemptyspace")
util.AddNetworkString("anplus_play_ui_snd")
util.AddNetworkString("anplus_chatmsg_ply")
util.AddNetworkString("anplus_screenmsg_ply")
util.AddNetworkString("anplus_add_fakename_language")
util.AddNetworkString("anplus_notify")

net.Receive("anplus_gmodsave_load_from_the_menu", function(len, ply)	
	--ANPlusNPCPreApply()	
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
			npc:ANPlusNPCApply( npc:GetInternalVariable( "m_iName" ), true )	
		end		
	end	
end)
hook.Add( "PlayerSpawnedNPC", "ANPlusLoad_PlayerSpawnedNPC", function(ply, npc)		
	local dataTab = ANPlusLoadGlobal[npc:GetInternalVariable( "m_iName" )]
	if dataTab then
		npc.m_pMyPlayer = ply
		if GetConVar( "anplus_random_placement" ):GetBool() then
			npc:ANPlusRandomTeleport( false, 2, Vector( 0, 0, 1 ), function()
				npc:SetAngles( npc:GetAngles() + Angle( 0, math.random( 0, 360 ), 0 ) )
			end )
		end
	end
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

	if IsValid(npc) && IsValid(rag) && npc:IsANPlus() then
		
		if npc:ANPlusGetDataTab()['CurData'] then
		
			if npc:ANPlusGetDataTab()['CurData']['CurFakeModel'] then rag:ANPlusFakeModel( npc:ANPlusGetDataTab()['CurData']['CurFakeModel']['Model'], npc:ANPlusGetDataTab()['CurData']['CurFakeModel']['VisualTab'] ) end
			
			if npc:ANPlusGetDataTab()['CurData']['CurBGS'] then			
				for i = 1, #npc:ANPlusGetDataTab()['CurData']['CurBGS'] do
					rag:SetBodygroup( i, npc:ANPlusGetDataTab()['CurData']['CurBGS'][ i ] )		
				end				
			end
				
			if npc:ANPlusGetDataTab()['CurData']['CurSMS'] then
				for i = 0, #npc:ANPlusGetDataTab()['CurData']['CurSMS'] do
					rag:SetSubMaterial( i, npc:ANPlusGetDataTab()['CurData']['CurSMS'][ i + 1 ] )					
				end					
			end
			
			if npc:ANPlusGetDataTab()['CurData']['CurBones'] then
				for i = 1, #npc:ANPlusGetDataTab()['CurData']['CurBones'] do		
					local bone = rag:GetPhysicsObjectNum( i )					
					if IsValid( bone ) then
						bone:SetPos( npc:ANPlusGetDataTab()['CurData']['CurBones'][ i ][ 1 ] )
						bone:SetAngles( npc:ANPlusGetDataTab()['CurData']['CurBones'][ i ][ 2 ] )
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

end)

hook.Add( "OnNPCKilled", "ANPlusLoad_OnNPCKilled", function(npc, att, inf)
	if IsValid(npc) then
		if npc:IsANPlus() then
			if npc:ANPlusGetDataTab()['CurData'] && npc:ANPlusGetDataTab()['CurData']['CurModel'] then
				
				local CurBGS = {}				
				for i = 1, #npc:GetBodyGroups() do		
					CurBGS[ i ] = npc:GetBodygroup( i )	
				end
					
				local addTab = { ['CurBGS'] = CurBGS }
				table.Merge( npc:ANPlusGetDataTab()['CurData'], addTab )
				
				local CurSMS = {}			
				for i = 0, #npc:GetMaterials() do		
					CurSMS[ i + 1 ] = npc:GetSubMaterial( i ) || npc:GetMaterials()[ i ]
				end
					
				local addTab = { ['CurSMS'] = CurSMS }
				table.Merge( npc:ANPlusGetDataTab()['CurData'], addTab )
				
				local CurBones = {}			
				for i = 0, npc:GetBoneCount() do
					
					local bone = npc:LookupBone( npc:GetBoneName( i ) )
					
					if bone then
						
						local bonepos, boneang = npc:GetBonePosition( npc:TranslatePhysBoneToBone( i ) )
						
						CurBones[ i ] = { bonepos, boneang }
					
					end
				
				end
				
				local addTab = { ['CurBones'] = CurBones }
				table.Merge( npc:ANPlusGetDataTab()['CurData'], addTab )
				
				if npc:ANPlusFakeModel() then
					local addTab = { ['CurFakeModel'] = { ['Model'] = npc:ANPlusFakeModel() && npc:ANPlusFakeModel():GetModel() || "", ['VisualTab'] = npc:ANPlusGetVisual() } }			
					table.Merge( npc:ANPlusGetDataTab()['CurData'], addTab )
				end
				
				npc:ANPlusApplyDataTab( npc:ANPlusGetDataTab() )
				
				npc:SetModel( npc:ANPlusGetDataTab()['CurData']['CurModel'] )
				
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
			att:ANPlusGetDataTab()['Functions']['OnNPCScaleDamageOnPlayer'](ply, hg, dmginfo)		
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
			att:ANPlusGetDataTab()['Functions']['OnNPCScaleDamageOnNPC'](npc, hg, dmginfo)	
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
		
	elseif ent:IsANPlus() && IsValid(att) && ent == att then
	
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
	
		dmginfo:AddDamage( dmginfo:GetDamage() * ( ( att:ANPlusGetDataTab()['DamageDealtScale'] / 100 ) >= -1 && att:ANPlusGetDataTab()['DamageDealtScale'] / 100 || -1 ) )
		
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