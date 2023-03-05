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
]]--

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "My ANP",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Cool Name",   
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
--[[
	['Models'] = {
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
			['CollisionBounds']			= { -- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.
	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL          
   
			},
		},
			---   
	},
--]]
	['Models'] = nil,
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
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
--[[ EXAMPLE
	['KeyValues'] 			= { citizentype = CT_REBEL, SquadName = "resistance" },
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
----------------------------------------------------------------- Set a distance at which your NPC will be able to hear things (doesn't literally set NPCs' hearing distance but rather affects ['OnNPCHearSound'] function).	
	['HearDistance'] 			= nil,   
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
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
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
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		--['npc_combine_s'] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		--[9] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, -- Where 9 represents NPC:Classify() of CLASS_COMBINE
		--['Other ANPlus NPC ID/Name'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Like", 0 } },
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
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = SIMPLE_USE,
		['OnNPCUse'] = function(self, activator, caller, type)		
		end,
		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)     	
		end,
		
		------------------------------------------------------------ OnNPCFollow - It is called whenever NPC follows/unfollows something. Follow/unfollow can be determined by the "state" value.
		['OnNPCFollow'] = function(self, ent, state)
		end, 
		
		------------------------------------------------------------ OnNPCLoad - This function is called when NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCLoad'] = function(ply, self, dataTab)	
		end,
		
		------------------------------------------------------------ OnNPCStateChange - This function runs onece, every time NPC's state changes.
		['OnNPCStateChange'] = function(self, newState, oldState)
		end,
		
		------------------------------------------------------------ OnNPCTranslateActivity - Can be used to replace activites based on your own conditions. It's not 1:1 with a normal TranslateActivity but close enough.
		['OnNPCTranslateActivity'] = function(self, act) -- return newAct, speed	
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
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)					
		end,
		
		------------------------------------------------------------ OnNPCWeaponSwitch - This function runs whenever this NPC equips a new weapon.
		['OnNPCWeaponSwitch'] = function(self, oldWep, newWep) 	
		end,
		
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, weapon, data) -- SHARED ( CLIENT & SERVER )		
			return true
		end,
		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,
		
		------------------------------------------------------------ OnNPCKeyValue - This function runs whenever keyvalues/inputs/outpust run, are called or whatever.
		['OnNPCKeyValue'] = function(self, key, value) -- SHARED ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
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
		
		------------------------------------------------------------ OnNPCScaleDamage - This function runs whenever NPC gets damaged. Can also be used to detect which body part was hit.
		['OnNPCScaleDamage'] = function(self, hitgroup, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(npc, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(ply, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCDeath - This function runs whenever NPC dies.
		['OnNPCDeath'] = function(self, attacker, inflictor)
		end,
		
		------------------------------------------------------------ OnNPCHearSound - This function runs whenever NPC hears any sounds (no scripted sequences and affected by ['HearDistance']).
		['OnNPCHearSound'] = function(self, ent, dist, data) -- SHARED ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data) -- SHARED ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnRagdollCreated - This function runs when the ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll)	-- SHARED ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,
		
		},
	
	}  
 
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local ENTTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "My ANP",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Cool Name",   
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "ent_class",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
--[[
	['Models'] = {
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
			['CollisionBounds']			= { -- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.
	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human-sized NPC (npc_citizen or npc_combine_s for example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL          
   
			},
		},
			---   
	},
--]]
	['Models'] = nil,
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
	['KeyValues'] 			= { citizentype = CT_REBEL, SquadName = "resistance" },
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
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
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
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = SIMPLE_USE,
		['OnNPCUse'] = function(self, activator, caller, type)		
		end,
		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)     	
		end, 
		
		------------------------------------------------------------ OnNPCLoad - This function is called when NPC gets loaded via GMod Save system or the Duplicator tool and has some save data using ENT:ANPlusStoreEntityModifier(dataTab).
		['OnNPCLoad'] = function(ply, self, dataTab)	
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
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)					
		end,
		
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, weapon, data) -- SHARED ( CLIENT & SERVER )		
			return true
		end,
		
		------------------------------------------------------------ OnNPCKeyValue - This function runs whenever keyvalues/inputs/outpust run, are called or whatever.
		['OnNPCKeyValue'] = function(self, key, value) -- SHARED ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
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
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(npc, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(ply, hitgroup, dmginfo)		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data) -- SHARED ( CLIENT & SERVER )
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,
		
		},
	
	}   
 
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( ENTTab, "SpawnableEntities" )

*/