------------------------------------------------------------------------------=#
--SHARED
AddCSLuaFile("autorun/addnpcplus_resources.lua")
AddCSLuaFile("autorun/addnpcplus_menus.lua")
AddCSLuaFile("autorun/addnpcplus_replacer.lua")
AddCSLuaFile("autorun/addnpcplus_sh_func.lua")
AddCSLuaFile("autorun/addnpcplus_sh_hooks.lua")
AddCSLuaFile("autorun/addnpcplus_sh_meta.lua")
--SERVER
AddCSLuaFile("autorun/server/addnpcplus_sr_func.lua")
AddCSLuaFile("autorun/server/addnpcplus_sr_hooks.lua")
AddCSLuaFile("autorun/server/addnpcplus_sr_meta.lua")
------------------------------------------------------------------------------=#

ANPlusLoadGlobal = {}
ANPlusLoadGlobalCount = 0

ANPlusDangerStuffGlobalNameOrClass = { "grenade", "missile", "rocket", "frag", "flashbang", "portal", "spore", "prop_combine_ball", "bolt" }
ANPlusDangerStuffGlobal = {}
ANPlusCustomSquads = { base_squad = {} }
ANPlusToolMenuGlobal = {}
ANPlusRemoveFromSpawnList = {}
ANPlusHealthBarStyles = { ['Disable All'] = true }
ANPlusScriptedSentences = {}
ANPlusCategoryIcons = ANPlusCategoryIcons || {}

if (SERVER) then
	ANPlusPlayerRelations = {
		[CLASS_PLAYER] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[4] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ANTLION -- HL2 antlions - npc_antlion, npc_antlionguard, and npc_ichthyosaur.
			[5] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_BARNACLE -- HL2 barnacles - npc_barnacle.
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[9] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[12] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[13] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[19] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[20] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[21] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_MISSILE -- HL2 missiles - rpg_missile, apc_missile, and grenade_pathfollower.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[25] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[26] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_MACHINE -- HL:S turrets - monster_turret, monster_miniturret, monster_sentry.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[28] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_HUMAN_MILITARY --	HL:S human military - monster_human_grunt and monster_apache.
			[29] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
			[30] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[32] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
			[35] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		}, 
		[CLASS_PLAYER_ALLY] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		}, 
		[CLASS_PLAYER_ALLY_VITAL] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		}, 
		[CLASS_ANTLION] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[4] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ANTLION -- HL2 antlions - npc_antlion, npc_antlionguard, and npc_ichthyosaur.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		}, 
		[CLASS_BARNACLE] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[5] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_BARNACLE -- HL2 barnacles - npc_barnacle.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_CITIZEN_PASSIVE] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[9] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[13] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[20] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[25] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[26] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_MACHINE -- HL:S turrets - monster_turret, monster_miniturret, monster_sentry.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_CITIZEN_REBEL] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_COMBINE] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		}, 
		[CLASS_COMBINE_GUNSHIP] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_CONSCRIPT] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_HEADCRAB] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_MANHACK] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_METROPOLICE] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_MILITARY] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_SCANNER] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_STALKER] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_VORTIGAUNT] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		}, 
		[CLASS_ZOMBIE] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_PROTOSNIPER] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_MISSILE] 		= {				
			['Default'] = { ['NPCToMe'] = { "Neutral", 99 } },			
			[21] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MISSILE -- HL2 missiles - rpg_missile, apc_missile, and grenade_pathfollower.
			[22] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_FLARE] 		= {				
			['Default'] = { ['NPCToMe'] = { "Neutral", 99 } },			
			[12] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[21] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MISSILE -- HL2 missiles - rpg_missile, apc_missile, and grenade_pathfollower.
			[22] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_EARTH_FAUNA] 		= {				
			['Default'] = { ['NPCToMe'] = { "Neutral", 99 } },			
			[12] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[23] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_HACKED_ROLLERMINE] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_COMBINE_HUNTER] 		= {				
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },	-- Anything else.	
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[9] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
			[10] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
			[13] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
			[14] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
			[15] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
			[16] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
			[17] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
			[20] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[25] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
			[33] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_MACHINE] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[26] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MACHINE -- HL:S turrets - monster_turret, monster_miniturret, monster_sentry.
			[28] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_MILITARY --	HL:S human military - monster_human_grunt and monster_apache.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		}, 
		[CLASS_HUMAN_PASSIVE] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_HUMAN_MILITARY] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[7] = { ['NPCToMe'] = { "Neutral", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[26] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_MACHINE -- HL:S turrets - monster_turret, monster_miniturret, monster_sentry.
			[28] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_MILITARY --	HL:S human military - monster_human_grunt and monster_apache.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_ALIEN_MILITARY] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[29] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[32] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
			[35] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		},
		[CLASS_ALIEN_MONSTER] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[29] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[32] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
			[35] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		},
		[CLASS_ALIEN_PREY] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[29] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[32] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
			[35] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		},
		[CLASS_ALIEN_PREDATOR] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[29] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[32] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
			[35] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		},
		[CLASS_INSECT] 				= {	
			['Default'] = { ['NPCToMe'] = { "Neutral", 99 } },			
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Hate", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[33] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_PLAYER_BIOWEAPON] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[2] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
			[3] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
			[7] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
			[8] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
			[11] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
			[18] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[24] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
			[27] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		},
		[CLASS_ALIEN_BIOWEAPON] 				= {	
			['Default'] = { ['NPCToMe'] = { "Hate", 99 } },			
			[12] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
			[19] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
			[22] = { ['NPCToMe'] = { "Neutral", 99 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
			[23] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
			[29] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
			[30] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
			[31] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
			[32] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
			[33] = { ['NPCToMe'] = { "Fear", 99 } }, 		-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
			[34] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
			[35] = { ['NPCToMe'] = { "Like", 99 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		},
	}
end

SV_BRANCH = ""

ANPDefaultGMODWeapons = {
['weapon_pistol'] 		= true,
['weapon_357'] 			= true,
['weapon_smg1'] 		= true,
['weapon_shotgun'] 		= true,
['weapon_ar2'] 			= true,
['weapon_rpg'] 			= true,
['weapon_alyxgun'] 		= true,
['weapon_annabelle'] 	= true,
['weapon_crossbow'] 	= true,
['weapon_stunstick'] 	= true,
['weapon_crowbar'] 		= true,
['weapon_glock_hl1'] 	= true
}

ANPlus = {
	--[[////////////////////////
	||||| Used to add ANPlus NPCs to the spawn menu and global table.
	]]--\\\\\\\\\\\\\\\\\\\\\\\\
	AddNPC = function( tab, listType )

		if ANPlusLoadGlobal then

			local id = tostring( tab['Name'] ) 	
			
			local base = tab['Base'] && ANPlusLoadGlobal[ tab['Base'] ]
			if base then tab = table.Merge( table.Copy( base ), tab ) end

			local addTab = { [ id ] = tab } 		

			local listType = listType || "NPC"
			tab['EntityType'] = listType

			table.Merge( ANPlusLoadGlobal, addTab )	

			ANPlusLoadGlobalCount = ANPlusLoadGlobalCount + 1
			
			if (CLIENT) then				
				print( "AddNPCPlus " .. ANPlusLoadGlobalCount .. " Loaded: " .. id )  				
				--language.Add( id, id )
				--language.Add( "#" .. id, id )
			end		
			--	
			if listType == "NPC" then -- Default stuff that We need for other stuff to not break.
				if tab['Relations'] then
					--if !tab['Relations'][ tab['Name'] ] then			
					--	local addTab = { [''.. tab['Name'] ..''] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, } 
					--	table.Merge( tab['Relations'], addTab )		
					--end
					if !tab['Relations']['Default'] then
						local addTab = { ['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, } 
						table.Merge( tab['Relations'], addTab )	
					end
				end
				if tab['WeaponProficiencyTab'] then
					if !tab['WeaponProficiencyTab']['Default'] then
						local addTab = { ['Default'] = { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil }, } 
						table.Merge( tab['WeaponProficiencyTab'], addTab )	
					end
				end
				if tab['SpawnFlags'] then
					local addSFs = 1024 --bit.bor( 512, 1024 )
					tab['SpawnFlags'] = tab['SpawnFlags'] + addSFs
				end
			elseif listType == "SpawnableEntities" then
				if tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] then
					local getModel = tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ]
					tab['KeyValues'] = tab['KeyValues'] || {}
					local addTab = { model = getModel }
					table.Merge( tab['KeyValues'], addTab )	
				end
			elseif listType == "Vehicles" then
				if tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] then
					local getModel = tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ]
					tab['KeyValues'] = tab['KeyValues'] || {}
					local addTab = { model = getModel }
					table.Merge( tab['KeyValues'], addTab )	
				end
				if tab['VehicleScript'] then
					local addTab = { vehiclescript = tab['VehicleScript'] }
					tab['KeyValues'] = tab['KeyValues'] || {}
					table.Merge( tab['KeyValues'], addTab )
				else 
					return
				end
			end
			
			tab['KeyValues'] = tab['KeyValues'] || {}
			local addTab = { parentname = id } -- This should help with all these NPC spawner tools :/
			table.Merge( tab['KeyValues'], addTab )		
			
			if tab['Spawnable'] != nil && tab['Spawnable'] == false then return end
			
			local category = tab['Category'] && string.Split( tab['Category'], " | " )
			category = istable( category ) && #category >= 2 && category[ 1 ] || tab['Category']
			
			if listType == "NPC" then
				list.Set( listType, id, {
					Name 			= tab['Name'], 
					Class 		 	= tab['Class'], 
					Model 		 	= tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] || false, 
					Health 		 	= tab['Health'], 
					Category 	 	= category, 
					KeyValues 	 	= tab['KeyValues'] || {}, 
					Weapons 	 	= tab['DefaultWeapons'] || false, 
					SpawnFlags 	 	= tab['SpawnFlags'],			
					AdminOnly 	 	= tab['AdminOnly'] || false,			
					OnCeiling 	 	= tab['OnCeiling'] || false,			
					OnFloor 	 	= tab['OnFloor'] || false,			
					Offset 		 	= tab['Offset'] || 10,
					--DropToFloor = tab['DropToFloor'] || false,
					Rotate 		 	= tab['Rotate'] || false,			
					NoDrop 			= tab['NoDrop'] || false,
					Author 		 	= tab['Author'] || false,	
					Information  	= tab['Information'] || false,					
				})
			elseif listType == "Vehicles" then
				list.Set( listType, id, {
					Name 		 	= tab['Name'], 
					Class 		 	= tab['Class'], 
					Model 		 	= tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] || false, 
					Health 		 	= tab['Health'], 
					Category 	 	= category, 
					KeyValues 	 	= tab['KeyValues'] || {}, 
					SpawnFlags 	 	= tab['SpawnFlags'],			
					AdminOnly 	 	= tab['AdminOnly'] || false,			
					OnCeiling 	 	= tab['OnCeiling'] || false,			
					OnFloor 	 	= tab['OnFloor'] || false,			
					Offset 		 	= tab['Offset'] || 10,
					--DropToFloor = tab['DropToFloor'] || false,
					Rotate 		 	= tab['Rotate'] || false,			
					NoDrop 		 	= tab['NoDrop'] || false,
					VC_ExtraSeats 	= tab['ExtraSeats'] || false,
					Author 		 	= tab['Author'] || false,	
					Information  	= tab['Information'] || false,					
				})
			elseif listType == "SpawnableEntities" then
				list.Set( listType, id, {
					PrintName 	 	= tab['Name'], 
					ClassName 	 	= tab['Class'], 					 
					Health 		 	= tab['Health'], 
					Category 	 	= category, 
					KeyValues 	 	= tab['KeyValues'] || {},  
					SpawnFlags 	 	= tab['SpawnFlags'],			
					AdminOnly 	 	= tab['AdminOnly'] || false,			
					OnCeiling 	 	= tab['OnCeiling'] || false,			
					OnFloor 	 	= tab['OnFloor'] || false,			
					NormalOffset 	= tab['Offset'] || 10,			
					Rotate 		 	= tab['Rotate'] || false,			
					NoDrop 		 	= tab['NoDrop'] || false,	
					Author 		 	= tab['Author'] || "Baka",	
					Information  	= tab['Information'] || "Amongus",	
				})
			end
		end		
	end,
	--[[////////////////////////
	||||| Used to add NPC weapons to the spawn menu while also checking if added weapon has its base installed. If not, it won't be added.
	]]--\\\\\\\\\\\\\\\\\\\\\\\\
	AddNPCWeapon = function( base, name, entclass, killcon, killconcolor, killconfont, killconscale )
		
		local checkIfBaseExists = base && file.Exists( "lua/weapons/" .. base, "GAME" ) || !base && true
		if !checkIfBaseExists then return end
		
		if !file.Exists( "lua/weapons/" .. entclass .. "", "GAME" ) || ( file.Exists( "lua/weapons/" .. entclass .. "", "GAME" ) && weapons.Get( entclass ) && weapons.Get( entclass )['Base'] && !file.Exists( "lua/weapons/" .. weapons.Get( entclass )['Base'] .. "", "GAME" ) ) then 
			print("ANPlus denied weapon [" .. name .. "]. Weapon is not valid or its BASE has not been installed/enabled.")
		return end
		
		local tab = { title = name, class = entclass }
		
		list.Set( "NPCUsableWeapons", tab.class, tab )
		
		if (CLIENT) && killcon then

			local isTexturePath = string.find( string.lower( killcon ), "hud/killicons/" )

			if isTexturePath then
				killicon.Add( tab.class, killcon || "HUD/killicons/default", killconcolor || Color( 255, 80, 0, 255 ) ) 
			else
				killicon.AddFont( tab.class, killconfont || "HL2MPTypeDeath", killcon || "-", killconcolor || Color( 255, 80, 0, 255 ), killconscal || 1 )
			end
			
		end
		
	end,  
	
	IsWeaponValid = function(wep)
			
		if ANPDefaultGMODWeapons[ wep ] then return true end
				
		timer.Simple(0, function() 
		
			if !file.Exists( "lua/weapons/" .. wep .. "", "GAME" ) || ( file.Exists( "lua/weapons/" .. wep .. "", "GAME" ) && weapons.Get( wep ) && weapons.Get( wep )['Base'] && !file.Exists( "lua/weapons/" .. weapons.Get( wep )['Base'] .. "", "GAME" ) ) then  
					
				--print("ANPlus removed weapon [" .. wep .. "] and replaced it with [" .. replacement .. "]. Weapon is not valid or its BASE has not been installed/enabled.")
				
				return false
				
			else
			
				return true
				
			end
			
		end)
	
	end,
	
	AddToolMenu = function(category, name, panel, tab)
		if ANPlusToolMenuGlobal then 
			local addTab = { [ #ANPlusToolMenuGlobal + 1 ] = { ['Category'] = category, ['Name'] = name, ['Panel'] = panel, ['Table'] = tab } } -- This should help with all these NPC spawner tools :/
			table.Merge( ANPlusToolMenuGlobal, addTab )				
		end
	end,
	
	--[[////////////////////////
	||||| Wanted to make a ANPC but model/s comes with its own NPC/s? Use this function to get rid of it/them.
	--]]
	RemoveFromSpawnList = function(name)	
		if !ANPlusRemoveFromSpawnList[ name ] then
			table.insert( ANPlusRemoveFromSpawnList, name )
		end
	end,

	AddConVar = function(command, defaultValue, flags, help, min, max)
		if !ConVarExists( command ) then
			CreateConVar( command, defaultValue, flags || FCVAR_NONE, help || "", min, max )
		end
	end,
	
	AddClientConVar = function(command, defaultValue, flags, help, min, max)
		if !ConVarExists( command ) && (CLIENT) then
			CreateClientConVar( command, defaultValue, flags || true, true, help || "", min, max )
		end
	end,
	
	AddParticle = function(fileName, particleList)
		game.AddParticles( fileName )
		for k, v in ipairs( particleList ) do
			PrecacheParticleSystem( v )
		end	
	end,
	
	AddHealthBarStyle = function(id, hpbarTab)
		if id && hpbarTab then
			ANPlusHealthBarStyles[ id ] = hpbarTab 
		end
	end,

	AddScriptedSentence = function(ssTab)
		if !istable(ssTab) || !ssTab['name'] then return end
		ANPlusScriptedSentences[ ssTab['name'] ] = ssTab
	end,

	AddNPCClass = function(className, relationTab)
		if !className || !relationTab then return end
		Add_NPC_Class( className )
		table.Merge( ANPlusPlayerRelations, relationTab )
	end,

	AddCategoryIcon = function(category, path)
		if SERVER then return end
		ANPlusCategoryIcons[category] = path
	end
	
} 

timer.ANPlusDelayed = function( id, delay, time, repeats, callback ) -- This is stupid and has to go... Far away... Pls don't use.	
	if id && delay == -1 then timer.Remove( id .. "ANPlusDelayed" ); timer.Remove( id ) return end	
	if !timer.Exists( id .. "ANPlusDelayed" ) then	
		timer.Create( id .. "ANPlusDelayed", delay, 1, function()		
			timer.Create( id, time, repeats, callback )		
		end)	
	end
end

ANPlus.AddConVar( "anplus_ff_disabled", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Allow friendly fire.", 0, 1 )
ANPlus.AddConVar( "anplus_force_swep_anims", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Force fixed swep animations.", 0, 1 )
ANPlus.AddConVar( "anplus_random_placement", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "If enabled and spawned by Players, ANPCs will be placed randomy around the map.", 0, 1 )
ANPlus.AddConVar( "anplus_hp_mul", 1, (FCVAR_GAMEDLL + FCVAR_ARCHIVE), "Multiply ANPC's health.", 0.1 )
ANPlus.AddConVar( "anplus_replacer_enabled", 1, (FCVAR_GAMEDLL + FCVAR_ARCHIVE), "Enable ANPlus Replacer.", 0, 1 )
ANPlus.AddConVar( "anplus_look_distance_override", 2048, (FCVAR_GAMEDLL + FCVAR_ARCHIVE), "Set NPC look/sight distance. This command only affect ANPCs that don't have thier look distance changed by thier code.", 0, 32000 )
ANPlus.AddConVar( "anplus_follower_collisions", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Enable collisions on following You ANPCs.", 0, 1 )
ANPlus.AddClientConVar( "anplus_hpbar_dist", 2048, false, "Enable light effect used by the muzzle effects from this base.", 0 )
ANPlus.AddClientConVar( "anplus_hpbar_def_style", "HL2 Retail", false, "Select a style of NPC's health bar if one has it enabled." )
ANPlus.AddClientConVar( "anplus_bm_volume", "1", false, "Volume of the boss music." )
ANPlus.AddClientConVar( "anplus_swep_muzzlelight", 1, false, "Enable light effect used by the muzzle effects from this base.", 0, 1 )
ANPlus.AddClientConVar( "anplus_swep_shell_smoke", 1, false, "Allow smoke effect to be emitted from fired bullet casings.", 0, 1 )
ANPlus.AddClientConVar( "anplus_swep_flight_fade_distance_start", 2048, false, "Distance at which SWEP's flashlight will start fading.", 512, 10240 )
ANPlus.AddClientConVar( "anplus_swep_flight_fade_distance", 1024, false, "SWEP's flashlight fade distance.", 512, 10240 )
ANPlus.AddClientConVar( "anplus_swep_flight_smartmode", 1, false, "NPCs will only use flashlights in dark places.", 0, 1 )
ANPlus.AddClientConVar( "anplus_swep_laser_fade_distance_start", 1024, false, "Distance at which SWEP's laser will start fading.", 512, 10240 )
ANPlus.AddClientConVar( "anplus_swep_laser_fade_distance", 512, false, "SWEP's laser fade distance.", 512, 10240 )
 
local invChars = {" ","{","}","[","]","(",")","!","+","=","?",".",",","/","-","`","~"}
function ANPlusIDCreate(name)
	for i = 1, #invChars do
		name = string.Replace( name, invChars[ i ], invChars[ i ] == " " && "_" || "" )	
	end	
	name = string.lower( name )	
	return name	
end

--[[
properties.Add( "anplus_controller", {
	MenuLabel = "ANP Controller", -- Name to display on the context menu
	Order = 60001, -- The order to display this property relative to other properties
	MenuIcon = "vgui/anp_ico.png", -- The icon to display next to the property

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		--if ( !ent:IsANPlus( true ) ) then return false end
		--if ( !ent['m_tSaveDataMenu'] || table.Count( ent['m_tSaveDataMenu'] ) == 0 ) then return false end
		if ( !GetConVar( "developer" ):GetBool() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "anplus_editmenu", ent ) ) then return false end
		
		return true
	end,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
		local ply = LocalPlayer()
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
		ply:DrawViewModel( false )
		ply.m_pANPControlledENT = ent

	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()

		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end
		ply:ANPlusControlled( ent )		
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity( ent )
		ply:SetNoTarget( true )
		ply:DrawShadow( false )
		ply:SetNoDraw( true )
		ply:SetMoveType( MOVETYPE_OBSERVER )
		ply:DrawViewModel( false )
		ply:DrawWorldModel( false )
		ply:StripWeapons()
		--ent:SetMaxLookDistance( 1 )
	end 
} )
]]--



