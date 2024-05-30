TOOL.Tab = "ANPlus"
TOOL.Category = "[BASE]"
TOOL.Name = "ANP Class Tool"
TOOL.UseDelay = CurTime()
TOOL.ClientConVar[ "class" ] = "CLASS_PLAYER"
TOOL.ConfigName = "" 

if (CLIENT) then

	TOOL.Information = {
		{ name = "info", stage = 1 },
		{ name = "left" },
        { name = "right" },
		{ name = "reload" },
	}

	language.Add( "tool.anp_class_tool.name", "ANP Class Tool" )
	language.Add( "tool.anp_class_tool.desc", "Allows you to set Player's class for relation purposes." )
	language.Add( "tool.anp_class_tool.left", "Set Player's Class" )
	language.Add( "tool.anp_class_tool.right", "" )
	language.Add( "tool.anp_class_tool.reload", "Restore Player's Class" )

end

function TOOL:LeftClick( trace, worldweld )

	if (SERVER) then

		local owner = self:GetOwner()
		local target = IsValid(trace.Entity) && trace.Entity:IsPlayer() && trace.Entity || owner
		local data = self:GetClientInfo( "class" )
		local class = GetGlobalValue( data )

		if !isnumber( class ) then 
		
			ANPlusSendNotify( owner, "buttons/button10.wav", "Invalid Class / Class Doesn't Exist", NOTIFY_ERROR, 4 )
			
			return false 
		end

		ANPlusSendNotify( owner, "buttons/button17.wav", "Class Set To: " .. data .. " (" ..class.. ")", NOTIFY_GENERIC, 4 )
		if target != owner then ANPlusSendNotify( target, "buttons/button17.wav", "Class Set To: " .. data .. " (" ..class.. ")", NOTIFY_GENERIC, 4 ) end
		target:SetNPCClass( class )
		
		owner.m_tbANPlusRelationsMem = {}
		owner.m_tANPPlayerRelations = ANPlusPlayerRelations[ class ]	
		owner.m_fANPlusCurMemoryDelay = 0
		owner.m_fANPlusCurMemoryLast = 0

		local timerN = "ANPCLASSTOOL" .. owner:GetName()
		timer.Create( timerN, 0, 0, function()
			if !IsValid(owner) || !owner.m_tANPPlayerRelations then timer.Remove( timerN ) return end
			owner:ANPlusNPCRelations()
		end )

		for _, ent in ents.Iterator() do
			if ent:IsValid() && ent:IsANPlus() then
				ent.m_iDefRelation = ent.m_iDefRelation || ent.m_tbANPlusRelationsMem[ target ] && ent.m_tbANPlusRelationsMem[ target ]['MeToNPCOld']
				ent.m_tbANPlusRelationsMem[ target ] = nil
			end
		end

	end

	return true
end

function TOOL:RightClick( trace )

	--local ent = trace.Entity
	return false
end

function  TOOL:Reload( trace )

	if (SERVER) then

		local owner = self:GetOwner()	
		local target = IsValid(trace.Entity) && trace.Entity:IsPlayer() && trace.Entity || owner	

		ANPlusSendNotify( owner, "buttons/button17.wav", "Class Restored", NOTIFY_GENERIC, 4 )
		if target != owner then ANPlusSendNotify( target, "buttons/button17.wav", "Class Restored", NOTIFY_GENERIC, 4 ) end
		
		local class = CLASS_PLAYER
		target:SetNPCClass( class )

		timer.Remove( "ANPCLASSTOOL" .. owner:GetName() )

		owner.m_tbANPlusRelationsMem = {}
		owner.m_fANPlusCurMemoryDelay = 0
		owner.m_fANPlusCurMemoryLast = 0
		owner.m_tANPPlayerRelations = ANPlusPlayerRelations[ class ]	

		owner:ANPlusNPCRelations()

		for _, ent in ents.Iterator() do

			if ent:IsValid() && ent:IsANPlus() then
				
				--ent.m_iDefRelation = ent.m_iDefRelation || ent.m_tbANPlusRelationsMem[ target ] && ent.m_tbANPlusRelationsMem[ target ]['MeToNPCOld']
				
				--if ent.m_iDefRelation then ent:AddEntityRelationship( target, ent.m_iDefRelation, 0 ) end
				ent.m_tbANPlusRelationsMem[ owner ] = nil

			end

		end

	end

	return true	
end

function TOOL.BuildCPanel( panel, ent )

	--[[local desc = " " ..
		"\n Choices:" ..
		"\n CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor." ..
		"\n CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by 'MakeGameEndAlly' input)." ..
		"\n CLASS_ANTLION -- HL2 antlions - npc_antlion, npc_antlionguard, and npc_ichthyosaur." ..
		"\n CLASS_BARNACLE -- HL2 barnacles - npc_barnacle." ..
		"\n CLASS_BULLSEYE -- HL2 bullseyes - npc_bullseye." ..
		"\n CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2." ..
		"\n CLASS_CITIZEN_REBEL -- HL2 unused." ..
		"\n CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship)." ..
		"\n CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter." ..
		"\n CLASS_CONSCRIPT -- HL2 unused." ..
		"\n CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab." ..
		"\n CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun." ..
		"\n CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver." ..
		"\n CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera." ..
		"\n CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner." ..
		"\n CLASS_STALKER -- HL2 stalkers - npc_stalker." ..
		"\n CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by 'MakeGameEndAlly' input)." ..
		"\n CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine." ..
		"\n CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper." ..
		"\n CLASS_MISSILE -- HL2 missiles - rpg_missile, apc_missile, and grenade_pathfollower." ..
		"\n CLASS_FLARE -- HL2 flares - env_flare." ..
		"\n CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon." ..
		"\n CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine." ..
		"\n CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter." ..
		"\n CLASS_MACHINE -- HL:S turrets - monster_turret, monster_miniturret, monster_sentry." ..
		"\n CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist." ..
		"\n CLASS_HUMAN_MILITARY --	HL:S human military - monster_human_grunt and monster_apache." ..
		"\n CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY." ..
		"\n CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma." ..
		"\n CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab." ..
		"\n CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull." ..
		"\n CLASS_INSECT -- HL:S insects - montser_roach and monster_leech." ..
		"\n CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player." ..
		"\n CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY."
	--]]
	panel:AddControl( "Header", { Text = "ANPlus Class Tool", Description = "Allows you to set Player's class for relation purposes." })

	panel:AddControl( "TextBox", {
         label = "Class",
         Command = "anp_class_tool_class" 
	})

	panel:ControlHelp("You can use any default or custom Class (Classify).")

	local class_list = vgui.Create( "DLabelURL", frame )
	class_list:SetColor( Color( 0, 161, 255, 255 ) ) 
	class_list:SetText( "List Of The Default Classes (GMod Wiki)" ) 
	class_list:SetURL( "https://wiki.facepunch.com/gmod/Enums/CLASS" )

	panel:AddItem( class_list )

end
 
