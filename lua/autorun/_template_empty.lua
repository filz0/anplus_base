/*

local ANPlusLoaded = file.Exists("lua/autorun/addnpcplus_base.lua","GAME") 
if !ANPlusLoaded then return end

----------------------------------------------------------- Precache Section
--WARNING!
--Modelprecache is limited to 4096 unique models. When it reaches the limit the game will crash.
--Soundcache is limited to 16384 unique sounds on the server.
----------------------------------------------------------]] 

--util.PrecacheModel( "models/odessa.mdl" ) -- There is no need to precache this model

--util.PrecacheSound( string soundName )
------------------------------------------------------------

--[[
ANPlus.AddNPCWeapon( basefile, name, class, killicon, killiconcolor )
> basefile - A name of a lua file from autorun folder from chosen weapon base. This is required so if the base is not installed, weapon will not be added to the NPC weapon list.
> name - Name of a weapon,
> class - Entity class name,
> killicon - File path to the kill icon,
> killiconcolor - Color of said kill icon.

example:
ANPlus.AddNPCWeapon( "sh_npcweapons_weaponlist", "[NPCW] Sparbine M6D", "swep_ai_sp_magnum", nil, nil )
--]]

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "My ANP",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Cool Name",   
----------------------------------------------------------------- If set, this name will be used in the killfeed instead keeping the Name/ID alone.
	['KillfeedName'] 			= "New Cool Name",
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
--[[
	['Models'] 					= {
		--- 
		{ "models/mymodel.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomized between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
				[5] = 3,
			}, 
			['Skin'] 		 = { 0, 0 },			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{""}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR
			['BoneEdit']	 = { -- Here you can edit the bones of your NPC. You can change position, angles, and scale.
				['ValveBiped.Bip01_Spine'] = { ang = Angle( 70, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 1, 1 ), jiggle = 0 },
			},
			['Scale']					= { 100, 0 }, --% model scale and delta time.
			['SurroundingBounds']		= { -- Sets the axis-aligned bounding box (AABB) for an entity's hitbox detection.	
				['Min']				= nil, -- Vector.
				['Max']				= nil,  -- Vector.
				['BoundsType']		= nil,  -- https://wiki.facepunch.com/gmod/Enums/BOUNDS
			},
			['CollisionBounds']			= {
	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL          
   
			},
			['GibReplacement'] = { -- RagGib replacement table (best for zombies). 
				['ORIGINAL MODEL'] = { "REPLACEMENT MODEL" or false, "REPLACEMENT MATERIAL" or { [1] = "REPLACEMENT_SUBMATERIAL" } or false },
			},
		},
		---   
	},
--]]
	['Models'] 					= nil,
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after the spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not possess any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= 50,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, and the third variable represents the health of each gain.	
--[[ EXAMPLE
	['HealthRegen'] 		= { true, 1, 10 }, 
--]]
	['HealthRegen'] 			= nil, 
----------------------------------------------------------------- Will display NPC's name and health in the middle of the screen. 
--[[
	['HealthBar']			= { 
	['Mode'] 			 = 1, -- Start when: 1 = always, 2 = when in combat, 3 = when alerted, 4 = when in combat or alerted.
	['StyleOverride'] 	 = false -- Enforce a health bar style. 
	},	
]]--
----EXAMPLE /\
	['HealthBar']				= false,
----------------------------------------------------------------- Will play a battle/boss/chase music when conditions set by "Mode" are meet. 
--[[ EXAMPLE
	['BossMusic']				= { 
		['Music']		= "music/hl2_song12.mp3",	-- Sound file that will be played. Can be a table with multiple sounds. 
		['Mode']		= 5,						-- 1 = always, 2 = when in combat, 3 = when alerted, 4 = when in combat and alerted, 5 = when seen the player atleast once.
		['Repeat']		= false,					-- Repeat the music after it stops. Ment for non-looped wav files. Doesn't work with mp3s.
		['Volume']		= 0.5,						-- Music's volume.
		['Range'] 		= "Auto",					-- Music's range, maps have size limit of around 32000. If set to "Auto", NPC's LookDistance will be used instead.
		['FadeRange'] 	= 0,  						-- Fade distance where ( Range - Fade ) = FadeStart OR Values between 0-1 ( Range * Fade ) = FadeStart.
		['ResetDelay']	= 20,						-- When the Player's out of the range music will reset and stop after this time, otherwise it will resume.
		['StopDelay']	= 2, 						-- When killed, music will fade and stop after this time.
	}, 
]]--
	['BossMusic']				= nil,
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
--[[ EXAMPLE
	['KeyValues'] 				= { citizentype = CT_REBEL, SquadName = "resistance" },
--]]
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
--[[ EXAMPLE
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
		{ "kill", "", 1 }, -- I'll kill*myself within 1 second after spawn.
	},  
--]]
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 			= { "weapon_smg1" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']		= false,
----------------------------------------------------------------- If a weapon from the ['DefaultWeapons'] is not valid, a weapon from this table will be issued instead (mind the order and make sure that amount of values in both tables is equal).
	['ReplacementWeapons'] 		= nil, 
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 			= nil,    
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType https://wiki.facepunch.com/gmod/Hold_Types . Default refers to weapons that do not meet the Class or HoldType requirement.	 
--[[ EXAMPLE
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { 
			['Proficiency'] = 1, -- Weapon accuracy https://wiki.facepunch.com/gmod/Enums/WEAPON_PROFICIENCY
			['PrimaryMinRange'] = nil,  -- Minimum range at which our NPC can use this weapon's primary fire. Set to "nil" to keep the weapon's default values.
			['SecondaryMinRange'] = nil,  -- Minimum range at which our NPC can use this weapon's secondary fire. Set to "nil" to keep the weapon's default values. (Usually, NPCs don't use secondary fire modes)
			['PrimaryMaxRange'] = nil,  -- Maximum range at which our NPC can use this weapon's primary fire. Set to "nil" to keep the weapon's default values.
			['SecondaryMaxRange'] = nil  -- Maximum range at which our NPC can use this weapon's secondary fire. Set to "nil" to keep the weapon's default values. (Usually, NPCs don't use secondary fire modes)
		},
		
		['weapon_rpg'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = 20000 },
		['weapon_crossbow'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = nil },
		
	},
--]]
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil, ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },

	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
--[[ EXAMPLE
	['AddCapabilities'] 	= 2 + 8 + 67108864,
--]]
	['AddCapabilities'] 		= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
--[[ EXAMPLE
	['RemoveCapabilities'] 	= 2 + 8 + 67108864,
--]]
	['RemoveCapabilities'] 		= nil,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Enable or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Enable or disable GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Enable or disable Player pickup on your Entity. Might not work on all Entities. If set to false, it will disable all PlayerPickUp-related functions!	
	['AllowPlayerPickUp'] 		= true,
----------------------------------------------------------------- Increase or decrease NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- Increase or decrease NPC's self damage. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageSelfScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
--[[ EXAMPLE
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. The lowest value is -100% (no damage) and it can go as high as you wish (be reasonable).
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default. 
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= 0, --%,
		[DMG_POISON]	= -30, --%,
		
	},
--]]
	['DamageTakenScale'] 		= nil, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. Val1 = OffCombat walk distance, Val2 = OffCombat run distance, Val3 = InCombat walk distance, Val4 = InCombat run distance.
	['CanFollowPlayers'] 		= { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {

		--['npc_combine_s'] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		--[9] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, -- Where 9 represents NPC:Classify() of CLASS_COMBINE
		--['Other ANPlus NPC ID/Name'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Like", 0 } },

		['MyClass'] = CLASS_PLAYER_ALLY,
		['MyVJClass'] = "CLASS_PLAYER_ALLY",											-- My new NPC CLASS,
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } },	-- Default relations to NPCs/CLASSes not mention below.
		[1] = { ['MeToNPC'] = { "Like", 0 } }, 										-- CLASS_PLAYER -- Players.
		[2] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_PLAYER_ALLY -- HL2 player allies - monster_barney, npc_citizen, hacked npc_manhack, and friendly npc_turret_floor.
		[3] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_PLAYER_ALLY_VITAL -- HL2 vital player allies - npc_magnusson, npc_gman, npc_fisherman, npc_eli, npc_barney, npc_kleiner, npc_mossman, npc_alyx, npc_monk, npc_dog, and npc_vortigaunt at the end of EP2 (controlled by "MakeGameEndAlly" input).
		[4] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ANTLION -- HL2 antlions - npc_antlion, npc_antlionguard, and npc_ichthyosaur.
		[5] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_BARNACLE -- HL2 barnacles - npc_barnacle.
		--[6] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Fear", 0 } }, 		-- CLASS_BULLSEYE -- HL2 bullseyes - npc_bullseye. THIS CLASS IS DISABLED.
		[7] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_CITIZEN_PASSIVE -- HL2 passive/non-rebel citizens - npc_citizen in the beginning of HL2.
		[8] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_CITIZEN_REBEL -- HL2 unused.
		[9] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_COMBINE -- HL2 combine troops - npc_combine, npc_advisor, apc_missile, npc_apcdriver, hostile npc_turret_floor, hostile npc_rollermine, npc_turret_ground when active, npc_turret_ceiling when active, and npc_strider when active (not being carried by the gunship).
		[10] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_COMBINE_GUNSHIP -- HL2 combine aircrafts - npc_combinegunship, npc_combinedropship, and npc_helicopter.
		[11] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_CONSCRIPT -- HL2 unused.
		[12] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_HEADCRAB -- HL2 headcrabs - visible npc_headcrab.
		[13] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_MANHACK -- HL2 manhacks - hostile npc_manhack not held by the gravity gun.
		[14] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_METROPOLICE -- HL2 metro police - npc_metropolice and npc_vehicledriver.
		[15] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_MILITARY -- HL2 combine military objects - func_guntarget, npc_spotlight, and active npc_combine_camera.
		[16] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_SCANNER -- HL2 combine scanners - npc_cscanner and npc_clawscanner.
		[17] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_STALKER -- HL2 stalkers - npc_stalker.
		[18] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_VORTIGAUNT -- HL2 vortigaunts - npc_vortigaunt before the end of EP2 (controlled by "MakeGameEndAlly" input).
		[19] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ZOMBIE -- HL2 zombies - unslumped npc_zombie, npc_poisonzombie, npc_fastzombie, npc_fastzombie_torso, and npc_zombine.
		[20] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_PROTOSNIPER -- HL2 snipers - npc_sniper and proto_sniper.
		[21] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_MISSILE -- HL2 missiles - rpg_missile, apc_missile, and grenade_pathfollower.
		[22] = { ['MeToNPC'] = { "Neutral", 0 }, ['NPCToMe'] = { "Neutral", 0 } }, 	-- CLASS_FLARE -- HL2 flares - env_flare.
		[23] = { ['MeToNPC'] = { "Neutral", 0 }, ['NPCToMe'] = { "Fear", 0 } }, 	-- CLASS_EARTH_FAUNA -- HL2 animals - npc_crow, npc_seagull, and npc_pigeon.
		[24] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_HACKED_ROLLERMINE -- HL2 friendly rollermines - hacked npc_rollermine.
		[25] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_COMBINE_HUNTER -- HL2 hunters - npc_hunter.
		[26] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_MACHINE -- HL:S turrets - monster_turret, monster_miniturret, monster_sentry.
		[27] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_HUMAN_PASSIVE -- HL:S friendly humans - monster_scientist.
		[28] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_HUMAN_MILITARY --	HL:S human military - monster_human_grunt and monster_apache.
		[29] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ALIEN_MILITARY --	HL:S alien military - monster_alien_controller, monster_vortigaunt, monster_alien_grunt, monster_nihilanth, and monster_snark if it has an enemy of class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.
		[30] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ALIEN_MONSTER -- HL:S monsters - monster_tentacle, monster_barnacle, monster_zombie, monster_gargantua, monster_houndeye, monster_ichthyosaur, and monster_bigmomma.
		[31] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ALIEN_PREY -- HL:S headcrabs - monster_headcrab.
		[32] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ALIEN_PREDATOR -- HL:S alien predators - monster_bullsquid, xen_tree, and xen_hull.
		[33] = { ['MeToNPC'] = { "Neutral", 0 }, ['NPCToMe'] = { "Fear", 0 } }, 	-- CLASS_INSECT -- HL:S insects - montser_roach and monster_leech.
		[34] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, 		-- CLASS_PLAYER_BIOWEAPON -- HL:S player bioweapons - hornet fired by a player.
		[35] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, 		-- CLASS_ALIEN_BIOWEAPON -- HL:S enemy bioweapons - hornet fired by anyone but a player, or monster_snark with no enemy or an enemy without the class CLASS_PLAYER, CLASS_HUMAN_PASSIVE, or CLASS_HUMAN_MILITARY.

	}, 
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[ EXAMPLE
	['ActivityOther'] = {
	
		[ACT_RELOAD] = { 100, { 49, 50 } }, -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
	['ActivityOther'] 			= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities. You can also change the movement speed at specified activities.
--[[ EXAMPLE
	['ActivityMovement'] = {
	
		[ACT_RUN] = { 100, 100, { 49, 50 } }, -- The first value (100) represents the animation speed in %, the second value (100) represents the movement speed in %, and the third value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
	['ActivityMovement'] 		= nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
--[[ EXAMPLE
	['SoundModification'] = {
	
		['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			['Play'] = true, -- Should We even play this sound?
			['SoundCharacter'] = true, --Sound characters. Set to true to keep the original, set to false to remove or set to your own sound character (eg. ['SoundCharacter'] = "^"). https://developer.valvesoftware.com/wiki/Soundscripts
			['SoundLevel'] = 100, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			['Pitch'] = { 70, 100 }, -- Also can be randomised,
			['Channel'] = CHAN_VOICE, 
			['Volume'] = 0.3, -- Same.
			['Flags'] = 1024, 
			['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" } }, 

		},
		
	}, 
--]]
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks. Remember to remove unused functions for the performance's sake.
	['Functions'] = {
		
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- ( CLIENT & SERVER ) -- ply is valid only when PlayerSpawnedNPC gets called.
		end,

		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = SIMPLE_USE,
		['OnNPCUse'] = function(self, activator, caller, type)		
		end,

		------------------------------------------------------------ OnNPCUserButtonUp - Called when the user/driver/leader releases a button.
		['OnNPCUserButtonUp'] = function(self, ply, button)	
		end,
		
		------------------------------------------------------------ OnNPCUserButtonDown - Called when the user/driver/leader presses a button.
		['OnNPCUserButtonDown'] = function(self, ply, button)	
		end,

		------------------------------------------------------------ OnNPCPlayerSetupMove - SetupMove is called before the engine process movements. This allows us to override the players movement.
		['OnNPCPlayerSetupMove'] = function(self, ply, mv, cmd)	
		end,
		
		------------------------------------------------------------ OnNPCThink - Called every frame on the client. Called about 5-6 times per second on the server.
		['OnNPCThink'] = function(self) -- ( CLIENT & SERVER )    	
		end,
		
		------------------------------------------------------------ OnNPCFoundEnemy - Called when NPC establishes line of sight to its enemy.
		['OnNPCFoundEnemy'] = function(self, enemy)	
		end,
		
		------------------------------------------------------------ OnNPCLostEnemy - Called when NPC loses its enemy. Usually due to the enemy being killed/removed, or because NPC has selected a newer, more dangerous enemy.
		['OnNPCLostEnemy'] = function(self, lastEnemy) -- lastEnemy might not always be valid. Always use IsValid().
		end,
		
		------------------------------------------------------------ OnNPCLostEnemyLOS - Called when NPC loses line of sight to its enemy.
		['OnNPCLostEnemyLOS'] = function(self, lastEnemy) -- lastEnemy might not always be valid. Always use IsValid().	
		end,
		
		------------------------------------------------------------ OnNPCTurretDeploy - Called when NPC(Turret) has become active and dangerous.
		['OnNPCTurretDeploy'] = function(self)
		end,
		
		------------------------------------------------------------ OnNPCTurretRetire - Called when NPC(Turret) has become inactive and harmless.
		['OnNPCTurretRetire'] = function(self)
		end,
		
		------------------------------------------------------------ OnNPCTurretTipped - Called when NPC(Turret) has been tipped over and is inactive.
		['OnNPCTurretTipped'] = function(self)
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(self, npc, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnPlayer - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(self, ply, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCPostDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities) and after damage calcualtions are done. You can't define hit groups through it.
		['OnNPCPostDamageOnEntity'] = function(self, ent, dmginfo, tookDMG)	
		end,
		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,
		
		------------------------------------------------------------ OnNPCFollow - It is called whenever NPC follows/unfollows something. Follow/unfollow can be determined by the "state" value.
		['OnNPCFollow'] = function(self, ent, state)
		end, 
		
		------------------------------------------------------------ OnNPCPreSave - Called before the duplicator copies the NPC.
		['OnNPCPreSave'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCPostSave - Called after the duplicator finished copying the NPC.
		['OnNPCPostSave'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCSaveTableFinish - Called after duplicator finishes saving the NPC, allowing you to modify the save data.
		['OnNPCSaveTableFinish'] = function(self, dupeData)	
		end,
		--[[
		------------------------------------------------------------ OnNPCRestore - Called when the NPC is reloaded from a Source Engine save (not the Sandbox saves or dupes) or on a changelevel (for example Half-Life 2 campaign level transitions).
		['OnNPCRestore'] = function(self)	
		end,
		]]--
		------------------------------------------------------------ OnNPCLoad - This function is called when NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCLoad'] = function(ply, self, dataTab)	
		end,
		
		------------------------------------------------------------ OnNPCPostLoad - This function is called after NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCPostLoad'] = function(ply, self, createdEntities)	
		end,
		
		------------------------------------------------------------ OnNPCStateChange - This function runs once, every time NPC's state changes.
		['OnNPCStateChange'] = function(self, newState, oldState)
		end,
		
		------------------------------------------------------------ OnNPCDoingSchedule - This function runs once, every time NPC's starts a new schedule.
		['OnNPCDoingSchedule'] = function(self, newSchedule, oldSchedule)
		end,
		
		------------------------------------------------------------ OnNPCDetectDanger - It is called whenever NPC gets near anything from the ANPlusDangerStuffGlobal table.
		['DetectionRange']    = 200,
		['DetectionDelay']    = 0.15,
		['OnNPCDetectDanger'] = function(self, ent, dist)
		end,
		
		------------------------------------------------------------ OnNPCTranslateActivity - Can be used to replace activites based on your own conditions. It's not 1:1 with a normal TranslateActivity but close enough.
		['OnNPCTranslateActivity'] = function(self, act) -- return newAct, reset, rate, speed	
		end,
		
		------------------------------------------------------------ OnNPCHandleAnimationEvent - This function can utilize lua animation events. You can set what happens at the specified animation frame. Originally created by Silverlan. ENT:ANPlusAddAnimationEvent(seq, frame, ev) -- Sequence, target frame and animation event ID
		['OnNPCHandleAnimationEvent'] = function(self, seq, ev)
		end, 
		
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
		end,
		
		------------------------------------------------------------ OnNPCInput - Almost anything that happens to this NPC/Entity will go through here. Great for detecting inputs.
		['OnNPCInput'] = function(input, activator, self, data)			
		end,
		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like the Combine Soldier throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- ( CLIENT & SERVER )					
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)					
		end,
		
		------------------------------------------------------------ OnNPCWeaponSwitch - This function runs whenever this NPC equips a new weapon.
		['OnNPCWeaponSwitch'] = function(self, oldWep, newWep) 	
		end,
		
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, weapon, data) -- ( CLIENT & SERVER )		
			return true
		end,
		
		------------------------------------------------------------ OnNPCKeyValue - This function runs whenever keyvalues/inputs/outpust run, are called or whatever.
		['OnNPCKeyValue'] = function(self, key, value) -- ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
		end,
		
		------------------------------------------------------------ OnPlayerPickup - Called when a player tries to pick up this Entity using the "use" key, return to override.
		['OnNPCPlayerPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnPhysgunPickup - This function runs when NPC gets picked up by the Player PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCOnPhysgunFreeze - This function runs when Player is trying to freeze this NPC with the PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunFreeze'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnPickedUp - This function runs when NPC gets picked up by the Player GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnPickedUp'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnDropped - This function runs when NPC gets dropped by the Player GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnDropped'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnGravGunPunt - This function runs when NPC gets punted (GravGun primary attack) by a Player.
		['OnNPCGravGunPunt'] = function(ply, self)		
		end,
			
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
		end,
		
		------------------------------------------------------------ OnNPCPostTakeDamage - This function runs whenever NPC gets damaged and after all of the damage calcualtions are done.
		['OnNPCPostTakeDamage'] = function(self, dmginfo, tookDMG)
		end,
		
		------------------------------------------------------------ OnNPCScaleDamage - This function runs whenever NPC gets damaged. Can also be used to detect which body part was hit.
		['OnNPCScaleDamage'] = function(self, hitgroup, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCDeath - This function runs whenever NPC dies.
		['OnNPCDeath'] = function(self, attacker, inflictor)
		end,
		
		------------------------------------------------------------ OnNPCHearSound - This function runs whenever NPC hears any sounds (no scripted sequences and affected by ['HearDistance']).
		['HearDistance']   = 200, 
		['OnNPCHearSound'] = function(self, ent, dist, data) -- ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnNPCSoundHint - Called whenever NPC gets a new SoundHint. https://wiki.facepunch.com/gmod/Structures/SoundHintData
		['OnNPCSoundHint'] = function(self, data)
		end,
		
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data) -- ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnRagdollCreated - This function runs when the ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll)	-- ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCRenderOverride - This function runs when NPC is drawn.
		['OnNPCRenderOverride'] = function(self, flags)	-- ( CLIENT )	
			self:DrawModel()
		end,
		
		------------------------------------------------------------ OnNPCPreDrawEffects - Similar to OnNPCPreDrawEffects but way better for drawing things like sprites and beams.
		['OnNPCPreDrawEffects'] = function(self) -- ( CLIENT )	
		end,
		
		------------------------------------------------------------ OnNPCPostDrawEffects - Similar to OnNPCPostDrawEffects but way better for drawing things like sprites and beams.
		['OnNPCPostDrawEffects'] = function(self) -- ( CLIENT )	
		end,
		
		------------------------------------------------------------ OnNPCHUDPaint - This function can be used to display stuff on Player's screen.
		['OnNPCHUDPaint'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self) -- ( CLIENT & SERVER )
		end,
		
	},
	
} ) 

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "My ANP",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Cool Name", 
----------------------------------------------------------------- If set, this name will be used in the killfeed instead keeping the Name/ID alone.
	['KillfeedName'] 			= "New Cool Name",	
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "ent_class",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
--[[
	['Models'] 					= {
		--- 
		{ "models/mymodel.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomized between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
				[5] = 3,
			}, 
			['Skin'] 		 = { 0, 0 },			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{""}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR
			['BoneEdit']	 = { -- Here you can edit the bones of your NPC. You can change position, angles, and scale.
				['ValveBiped.Bip01_Spine'] = { ang = Angle( 70, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 1, 1 ), jiggle = 0 },
			},
			['Scale']					= { 100, 0 }, --% model scale and delta time.
			['SurroundingBounds']		= { -- Sets the axis-aligned bounding box (AABB) for an entity's hitbox detection.	
				['Min']				= nil, -- Vector.
				['Max']				= nil,  -- Vector.
				['BoundsType']		= nil,  -- https://wiki.facepunch.com/gmod/Enums/BOUNDS
			},
			['CollisionBounds']			= {
	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL          
   
			},
			['PhysicsInitBox']	= { 
				['Min']				= Vector( -5, -5, -5 ), 
				['Max']				= Vector( 5, 5, 5 ), 
				['SurfaceProp']		= "default",
			},
			['PhysicsInitSphere']	= { 
				['Radius']			= 10, 
				['SurfaceProp']		= "default",
			},
		},
			---   
	},
--]]
	['Models'] 					= nil,
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Displays author of this Entity.
	['Author']					= "Your name or something",
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after the spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not possess any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= false,
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
--[[ EXAMPLE
	['KeyValues'] 				= { citizentype = CT_REBEL, SquadName = "resistance" },
--]]
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
--[[ EXAMPLE
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
		{ "kill", "", 1 }, -- I'll kill*myself within 1 second after spawn.
	},  
--]]
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Enable or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Enable or disable GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Enable or disable Player pickup on your Entity. Might not work on all Entities. If set to false, it will disable all PlayerPickUp-related functions!	
	['AllowPlayerPickUp'] 		= true,
----------------------------------------------------------------- Increase or decrease NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[ EXAMPLE
	['ActivityOther'] = {
	
		[ACT_RELOAD] = { 100, { 49, 50 } }, -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
	['ActivityOther'] 			= false,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
--[[ EXAMPLE
	['SoundModification'] = {
	
		['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			['Play'] = true, -- Should We even play this sound?
			['SoundCharacter'] = true, Sound characters. Set to true to keep the original, set to false to remove or set to your own sound character (eg. ['SoundCharacter'] = "^"). https://developer.valvesoftware.com/wiki/Soundscripts
			['SoundLevel'] = 100, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			['Pitch'] = { 70, 100 }, -- Also can be randomised,
			['Channel'] = CHAN_VOICE, 
			['Volume'] = 0.3, -- Same.
			['Flags'] = 1024, 
			['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" } }, 

		},
		
	}, 
--]]
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks. Remember to remove unused functions for the performance's sake.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- ( CLIENT & SERVER ) -- Player is valid only when PlayerSpawnedNPC gets called.
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = SIMPLE_USE,
		['OnNPCUse'] = function(self, activator, caller, type)		
		end,
		
		------------------------------------------------------------ OnNPCUserButtonUp - Called when the user/driver/leader releases a button.
		['OnNPCUserButtonUp'] = function(self, ply, button)	
		end,
		
		------------------------------------------------------------ OnNPCUserButtonDown - Called when the user/driver/leader presses a button.
		['OnNPCUserButtonDown'] = function(self, ply, button)	
		end,

		------------------------------------------------------------ OnNPCPlayerSetupMove - SetupMove is called before the engine process movements. This allows us to override the players movement.
		['OnNPCPlayerSetupMove'] = function(self, ply, mv, cmd)	
		end,
		
		------------------------------------------------------------ OnNPCThink - Called every frame on the client. Called about 5-6 times per second on the server.
		['OnNPCThink'] = function(self) -- ( CLIENT & SERVER )   	
		end, 
		
		------------------------------------------------------------ OnNPCPreSave - Called before the duplicator copies the NPC.
		['OnNPCPreSave'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCPostSave - Called after the duplicator finished copying the NPC.
		['OnNPCPostSave'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCSaveTableFinish - Called after duplicator finishes saving the NPC, allowing you to modify the save data.
		['OnNPCSaveTableFinish'] = function(self, dupeData)	
		end,
		
		------------------------------------------------------------ OnNPCRestore - Called when the NPC is reloaded from a Source Engine save (not the Sandbox saves or dupes) or on a changelevel (for example Half-Life 2 campaign level transitions).
		['OnNPCRestore'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCLoad - This function is called when NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCLoad'] = function(ply, self, dataTab)	
		end,
		
		------------------------------------------------------------ OnNPCPostLoad - This function is called after NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCPostLoad'] = function(ply, self, createdEntities)	
		end,
		
		------------------------------------------------------------ OnNPCHandleAnimationEvent - This function can utilize lua animation events. You can set what happens at the specified animation frame. Originally created by Silverlan. ENT:ANPlusAddAnimationEvent(seq, frame, ev) -- Sequence, target frame and animation event ID
		['OnNPCHandleAnimationEvent'] = function(self, seq, ev)
		end, 
		
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
		end,
		
		------------------------------------------------------------ OnNPCInput - Almost anything that happens to this NPC/Entity will go through here. Great for detecting inputs.
		['OnNPCInput'] = function(self, input, activator, caller, data)			
		end,
		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like the Combine Soldier throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- ( CLIENT & SERVER )					
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)					
		end,
		
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, weapon, data) -- ( CLIENT & SERVER )		
			return true
		end,
		
		------------------------------------------------------------ OnNPCKeyValue - This function runs whenever keyvalues/inputs/outpust run, are called or whatever.
		['OnNPCKeyValue'] = function(self, key, value) -- ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
		end,
		
		------------------------------------------------------------ OnAllowPlayerPickup - Called when a player tries to pick up this Entity using the "use" key, return to override.
		['OnNPCAllowPlayerPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCOnPlayerPickup - Called when a player +use pickups this Entity. This will be called after the Entity passes though GM:AllowPlayerPickup.
		['OnNPCOnPlayerPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCOnPlayerDrop - Called when a player +use drops or throws this Entity.
		['OnNPCOnPlayerDrop'] = function(ply, self, thrown)
		end,
		
		------------------------------------------------------------ OnPhysgunPickup - This function runs when NPC gets picked up by the Player PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCOnPhysgunFreeze - This function runs when Player is trying to freeze this NPC with the PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunFreeze'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnPickedUp - This function runs when NPC gets picked up by the Player GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnPickedUp'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnDropped - This function runs when NPC gets dropped by the Player GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnDropped'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnGravGunPunt - This function runs when NPC gets punted (GravGun primary attack) by a Player.
		['OnNPCGravGunPunt'] = function(ply, self)		
		end,
			
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
		end,
		
		------------------------------------------------------------ OnNPCPostTakeDamage - This function runs whenever NPC gets damaged and after all of the damage calcualtions are done.
		['OnNPCPostTakeDamage'] = function(self, dmginfo, tookDMG)
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(self, npc, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnPlayer - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(self, ply, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCPostDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities) and after damage calcualtions are done. You can't define hit groups through it.
		['OnNPCPostDamageOnEntity'] = function(self, ent, dmginfo, tookDMG)	
		end,
		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,
		
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data) -- ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnNPCRenderOverride - This function runs when NPC is drawn.
		['OnNPCRenderOverride'] = function(self, flags)	-- ( CLIENT )	
			self:DrawModel()
		end,
					
		------------------------------------------------------------ OnNPCPreDrawEffects - Similar to OnNPCPreDrawEffects but way better for drawing things like sprites and beams.
		['OnNPCPreDrawEffects'] = function(self) -- ( CLIENT )	
		end,
		
		------------------------------------------------------------ OnNPCPostDrawEffects - Similar to OnNPCPostDrawEffects but way better for drawing things like sprites and beams.
		['OnNPCPostDrawEffects'] = function(self) -- ( CLIENT )	
		end,
		
		------------------------------------------------------------ OnNPCHUDPaint - This function can be used to display stuff on Player's screen.
		['OnNPCHUDPaint'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCBreak - Called when entity breaks. Used for non-NPC entities.
		['OnNPCBreak'] = function(self, attacker) -- ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self) -- ( CLIENT & SERVER )
		end,
		
	},
	
}, "SpawnableEntities" )

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "My ANP",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Cool Name", 
----------------------------------------------------------------- If set, this name will be used in the killfeed instead keeping the Name/ID alone.
	['KillfeedName'] 			= "New Cool Name",	
----------------------------------------------------------------- Entity class of your Vehicle aka base Vehicle (ex. prop_vehicle_jeep).       
	['Class'] 					= "ent_class",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
--[[
	['Models'] 					= {
		--- 
		{ "models/mymodel.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomized between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
				[5] = 3,
			}, 
			['Skin'] 		 = { 0, 0 },			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{""}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BoneEdit']	 = { -- Here you can edit the bones of your NPC. You can change position, angles, and scale.
				['ValveBiped.Bip01_Spine'] = { ang = Angle( 70, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 1, 1 ), jiggle = 0 },
			},
			['Scale']					= { 100, 0 }, --% model scale and delta time.
			['SurroundingBounds']		= { -- Sets the axis-aligned bounding box (AABB) for an entity's hitbox detection.	
				['Min']				= nil, -- Vector.
				['Max']				= nil,  -- Vector.
				['BoundsType']		= nil,  -- https://wiki.facepunch.com/gmod/Enums/BOUNDS
			},
			['CollisionBounds']			= {
	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL          
   
			},
			['PhysicsInitBox']	= { 
				['Min']				= Vector( -5, -5, -5 ), 
				['Max']				= Vector( 5, 5, 5 ), 
				['SurfaceProp']		= "default",
			},
			['PhysicsInitSphere']	= { 
				['Radius']			= 10, 
				['SurfaceProp']		= "default",
			},
		},
			---   
	},
--]]
	['Models'] 					= nil,
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Displays author of this Entity.
	['Author']					= "Your name or something",
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after the spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not possess any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= false,
----------------------------------------------------------------- Script of your vehicle.	
	['VehicleScript'] 			= "scripts/vehicles/jeep_test.txt",
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
--[[ EXAMPLE
	['KeyValues'] 				= { citizentype = CT_REBEL, SquadName = "resistance" },
--]]
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
--[[ EXAMPLE
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
		{ "kill", "", 1 }, -- I'll kill*myself within 1 second after spawn.
	},  
--]]
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Enable or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Enable or disable GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Enable or disable Player pickup on your Entity. Might not work on all Entities. If set to false, it will disable all PlayerPickUp-related functions!	
	['AllowPlayerPickUp'] 		= true,
----------------------------------------------------------------- Increase or decrease NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[ EXAMPLE
	['ActivityOther'] = {
	
		[ACT_RELOAD] = { 100, { 49, 50 } }, -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
	['ActivityOther'] 			= false,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
--[[ EXAMPLE
	['SoundModification'] = {
	
		['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			['Play'] = true, -- Should We even play this sound?
			['SoundCharacter'] = true, Sound characters. Set to true to keep the original, set to false to remove or set to your own sound character (eg. ['SoundCharacter'] = "^"). https://developer.valvesoftware.com/wiki/Soundscripts
			['SoundLevel'] = 100, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			['Pitch'] = { 70, 100 }, -- Also can be randomised,
			['Channel'] = CHAN_VOICE, 
			['Volume'] = 0.3, -- Same.
			['Flags'] = 1024, 
			['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" } }, 

		},
		
	}, 
--]]
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks. Remember to remove unused functions for the performance's sake.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- ( CLIENT & SERVER ) -- Player is valid only when PlayerSpawnedNPC gets called.
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = SIMPLE_USE,
		['OnNPCUse'] = function(self, activator, caller, type)		
		end,
		
		------------------------------------------------------------ OnNPCUserButtonUp - Called when the user/driver releases a button.
		['OnNPCUserButtonUp'] = function(self, ply, button)	
		end,
		
		------------------------------------------------------------ OnNPCUserButtonDown - Called when the user/driver presses a button.
		['OnNPCUserButtonDown'] = function(self, ply, button)	
		end,
		
		------------------------------------------------------------ OnNPCPlayerSetupMove - SetupMove is called before the engine process movements. This allows us to override the players movement.
		['OnNPCPlayerSetupMove'] = function(self, ply, mv, cmd)	
		end,

		------------------------------------------------------------ OnNPCPrePlayerEnter - Called when the player tries to enter the vehicle.
		['OnNPCPrePlayerEnter'] = function(ply, self, seat)	
		end,

		------------------------------------------------------------ OnNPCPlayerEnter - Called when the player enters the vehicle.
		['OnNPCPlayerEnter'] = function(ply, self, seat)	
		end,
		
		------------------------------------------------------------ OnNPCPlayerLeave - Called when the player leaves the vehicle.
		['OnNPCPlayerLeave'] = function(ply, self)	
		end,
		
		------------------------------------------------------------ OnNPCThink - Called every frame on the client. Called about 5-6 times per second on the server.
		['OnNPCThink'] = function(self) -- ( CLIENT & SERVER )   	
		end, 
		
		------------------------------------------------------------ OnNPCPreSave - Called before the duplicator copies the NPC.
		['OnNPCPreSave'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCPostSave - Called after the duplicator finished copying the NPC.
		['OnNPCPostSave'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCSaveTableFinish - Called after duplicator finishes saving the NPC, allowing you to modify the save data.
		['OnNPCSaveTableFinish'] = function(self, dupeData)	
		end,
		--[[
		------------------------------------------------------------ OnNPCRestore - Called when the NPC is reloaded from a Source Engine save (not the Sandbox saves or dupes) or on a changelevel (for example Half-Life 2 campaign level transitions).
		['OnNPCRestore'] = function(self)	
		end,
		]]--
		------------------------------------------------------------ OnNPCLoad - This function is called when NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCLoad'] = function(ply, self, dataTab)	
		end,
		
		------------------------------------------------------------ OnNPCPostLoad - This function is called after NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCPostLoad'] = function(ply, self, createdEntities)	
		end,
		
		------------------------------------------------------------ OnNPCHandleAnimationEvent - This function can utilize lua animation events. You can set what happens at the specified animation frame. Originally created by Silverlan. ENT:ANPlusAddAnimationEvent(seq, frame, ev) -- Sequence, target frame and animation event ID
		['OnNPCHandleAnimationEvent'] = function(self, seq, ev)
		end, 
		
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
		end,
		
		------------------------------------------------------------ OnNPCInput - Almost anything that happens to this NPC/Entity will go through here. Great for detecting inputs.
		['OnNPCInput'] = function(self, input, activator, caller, data)			
		end,
		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like the Combine Soldier throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- ( CLIENT & SERVER )					
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)					
		end,
		
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, weapon, data) -- ( CLIENT & SERVER )		
			return true
		end,
		
		------------------------------------------------------------ OnNPCKeyValue - This function runs whenever keyvalues/inputs/outpust run, are called or whatever.
		['OnNPCKeyValue'] = function(self, key, value) -- ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
		end,
		
		------------------------------------------------------------ OnPlayerPickup - Called when a player tries to pick up this Entity using the "use" key, return to override.
		['OnNPCPlayerPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnPhysgunPickup - This function runs when NPC gets picked up by the Player PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCOnPhysgunFreeze - This function runs when Player is trying to freeze this NPC with the PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunFreeze'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnPickedUp - This function runs when NPC gets picked up by the Player GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnPickedUp'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnDropped - This function runs when NPC gets dropped by the Player GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnDropped'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnGravGunPunt - This function runs when NPC gets punted (GravGun primary attack) by a Player.
		['OnNPCGravGunPunt'] = function(ply, self)		
		end,
			
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
		end,
		
		------------------------------------------------------------ OnNPCPostTakeDamage - This function runs whenever NPC gets damaged and after all of the damage calcualtions are done.
		['OnNPCPostTakeDamage'] = function(self, dmginfo, tookDMG)
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(self, npc, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnPlayer - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(self, ply, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCPostDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities) and after damage calcualtions are done. You can't define hit groups through it.
		['OnNPCPostDamageOnEntity'] = function(self, ent, dmginfo, tookDMG)	
		end,
		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,
		
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data) -- ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnNPCRenderOverride - This function runs when NPC is drawn.
		['OnNPCRenderOverride'] = function(self, flags)	-- ( CLIENT )	
			self:DrawModel()
		end,
					
		------------------------------------------------------------ OnNPCPreDrawEffects - Similar to OnNPCPreDrawEffects but way better for drawing things like sprites and beams.
		['OnNPCPreDrawEffects'] = function(self) -- ( CLIENT )	
		end,
		
		------------------------------------------------------------ OnNPCPostDrawEffects - Similar to OnNPCPostDrawEffects but way better for drawing things like sprites and beams.
		['OnNPCPostDrawEffects'] = function(self) -- ( CLIENT )	
		end,
		
		------------------------------------------------------------ OnNPCHUDPaint - This function can be used to display stuff on Player's screen.
		['OnNPCHUDPaint'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self) -- ( CLIENT & SERVER )
		end,
		
	},
	
}, "Vehicles" )

*/