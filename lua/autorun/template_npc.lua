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

local ENTTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "Half-Life 2",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Suit Charger (Citadel)",   
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "item_suitcharger",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "", 
			['PhysicsInit'] = SOLID_VPHYSICS,
		},
		---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Displays author of this Entity.
	['Author']					= "filz0",
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
	['SpawnFlags'] 				= 8192, 
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
			self:SetSaveValue( "m_iMaxJuice", GetConVar( "sk_suitcharger_citadel" ):GetFloat() )
			self:SetSaveValue( "m_iJuice", GetConVar( "sk_suitcharger_citadel" ):GetFloat() )
			self.m_sBatteryModel = "models/items/battery.mdl"
			--PrintTable(self:GetTable())
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = CONTINUOUS_USE,
		['OnNPCUse'] = function(self, activator, caller, type)	
			timer.Create( "ANP_TEMP_SUITCHARGER_DRIPEEG_STOP" .. self:EntIndex(), 0.1, 1, function()
				if !IsValid(self) then return end
				self.m_bFireThatEgg = false
				self:StopSound( "anp/suitcharger_egg/suitchargeok1.wav" )
				self:StopSound( "anp/suitcharger_egg/suitcharge1.wav" )
			end)
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
		
		------------------------------------------------------------ OnNPCInput - Almost anything that happens to this NPC/Entity will go through here. Great for detecting inputs.
		['OnNPCInput'] = function(self, input, activator, caller, data)	
			if input == "Recharge" then
				self:ANPlusHaloEffect( Color( 255, 155, 0 ), 3, 1 )
			end
		end,
		
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)				
		end,
		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like the Combine Soldier throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)	
			local ent = data.HitEntity
			if IsValid(ent) && ent:GetModel() == self.m_sBatteryModel && IsValid(ent:GetPhysicsObject()) && self:GetInternalVariable( "m_iJuice" ) < GetConVar( "sk_suitcharger_citadel" ):GetFloat() then
				ent:Remove()
				self:Fire( "Recharge", "", 0 )
			end
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
			if data['SoundName'] == "items/suitchargeok1.wav" && ANPlusPercentageChance( 3 ) then
				self.m_bFireThatEgg = true
			end
			if self.m_bFireThatEgg then
				if data['SoundName'] == "items/suitchargeok1.wav" then data['SoundName'] = "anp/suitcharger_egg/suitchargeok1.wav" end			
				if data['SoundName'] == "items/suitcharge1.wav" then data['SoundName'] = "anp/suitcharger_egg/suitcharge1.wav" end
				return true
			end
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
			self:StopSound( "anp/suitcharger_egg/suitchargeok1.wav" )
			self:StopSound( "anp/suitcharger_egg/suitcharge1.wav" )
		end,
		
		},
	
	}  
 
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( ENTTab, "SpawnableEntities" )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "[ANP] Dev",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[ANP] Test Dummy",               
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 				= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/breen.mdl", 
			['BodyGroups'] = nil, 
			['Skin'] 		 = nil,			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "models/debug/debugwhite",				-- This value will set a new material for your NPC with this model applied. 
			['SubMaterials'] = nil,
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR
			['BoneEdit']	 = nil, 
			['Scale']					= { 100, 0 }, --% scale and delta time.
			['CollisionBounds']	= {	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL           
			},
		},
		---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= 999999999,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 			= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 			= {},
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']		= false, 
----------------------------------------------------------------- If a weapon from the ['DefaultWeapons'] is not valid, a weapon from this table will be issued instead (mind the order and make sure that amount of vaules in both tables are equal).
	['ReplacementWeapons'] 		= nil, 
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 			= 1,   
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType https://wiki.facepunch.com/gmod/Hold_Types . Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil, ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },

	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 		= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 		= 1,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
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
		
	}, 
----------------------------------------------------------------- Set if your NPC should be friendly to players. true = Yes / false = No / nil = default to the NPC
	['PlayerAlly'] 				= false,  
----------------------------------------------------------------- This table can be used to specify how our NPC should react to other NPCs and vice versa. ['MeToNPC'] sets how our NPC should react to the other NPC. ['NPCToMe'] sets how other NPC should react to ours. The first value sets the relation and the second one sets its strength. If you plan to use this table, make sure that ['Default'] is present inside as it will tell NPCs that are not present in here what to do. You can use NPC classes (npc_citizen) or ANP IDs/Names.
	['Relations'] = { 
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, -- "Hate" / "Like" / "Fear" / "Neutral"     
 
	},  	
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 			= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities. You can also change the movement speed at specified activities.
	['ActivityMovement'] 		= nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	-- SHARED ( CLIENT & SERVER )
		
			self:ANPMuteSound( true )   
			
		end,	
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)     	
			self:StopMoving()
		end,		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )		
		end,		
		------------------------------------------------------------ OnNPCWeaponSwitch - This function runs whenever this NPC equips a new weapon.
		['OnNPCWeaponSwitch'] = function(self, oldWep, newWep) 	
		end,		
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, data) -- SHARED ( CLIENT & SERVER )		
		end,		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
		end,		
		------------------------------------------------------------ OnPhysgunPickup - This function runs when NPC gets picked up by the Player's PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunPickup'] = function(ply, self)
		end,		
		------------------------------------------------------------ OnNPCGravGunOnPickedUp - This function runs when NPC gets picked up by the Player's GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnPickedUp'] = function(ply, self)		
		end,		
		------------------------------------------------------------ OnNPCGravGunOnDropped - This function runs when NPC gets dropped by the Player's GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnDropped'] = function(ply, self)		
		end,		
		------------------------------------------------------------ OnGravGunPunt - This function runs when NPC gets punted (GravGun primary attack) by a Player.
		['OnNPCGravGunPunt'] = function(ply, self)		
		end,			
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
			self:SetNWFloat( "ANP_TestDummyDamage", dmginfo:GetDamage() )  
		end,		
		------------------------------------------------------------ OnNPCScaleDamage - This function runs whenever NPC gets damaged. Can also be used to detect which body part was hit.
		['OnNPCScaleDamage'] = function(self, hitgroup, dmginfo)	
			self:SetNWFloat( "ANP_TestDummyHitBox", hitgroup )    
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

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Humans + Resistance",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "Mega Odessa Cubbage",   
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 				= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/odessa.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomised between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
			}, 
			['Skin'] 		 = { 0, 0 },			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha. 
			['Scale']					= { 100, 0 }, --% scale and delta time.
			['CollisionBounds']	= {	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL           
			},
		},
			---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false, 
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 400,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { true, 1, 10 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { citizentype = CT_REBEL, DontPickupWeapons = "true", SquadName = "resistance" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	},    
	--['InputsAndOutputs'] 	= { {"kill", "", 1} },  
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_crossbow" },
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 20000,   
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType https://wiki.facepunch.com/gmod/Hold_Types . Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { 
			['Proficiency'] = 1, -- Weapon accuracy https://wiki.facepunch.com/gmod/Enums/WEAPON_PROFICIENCY
			['PrimaryMinRange'] = nil,  -- Minimum range at which our NPC can use this weapon's primary fire. Set to "nil" to keep the weapon's default values.
			['SecondaryMinRange'] = nil,  -- Minimum range at which our NPC can use this weapon's secondary fire. Set to "nil" to keep the weapon's default values. (Usually NPCs don't use secondary fire modes)
			['PrimaryMaxRange'] = nil,  -- Maximum range at which our NPC can use this weapon's primary fire. Set to "nil" to keep the weapon's default values.
			['SecondaryMaxRange'] = nil  -- Maximum range at which our NPC can use this weapon's secondary fire. Set to "nil" to keep the weapon's default values. (Usually NPCs don't use secondary fire modes)
		},
		
		['weapon_rpg'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = 20000 },
		['weapon_crossbow'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 8 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 300, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. The lowest value is -100% (no damage) and it can go as high as you wish (be reasonable).
		['Head'] 	 = -50, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default. 
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= -100, --%,
		[DMG_POISON]	= -100, --%,
		[DMG_RADIATION]	= -30, --%,
		[DMG_ACID]		= -50, --%,
		[DMG_POISON]	= -50, --%, 
		
	}, 
----------------------------------------------------------------- Set if your NPC should be friendly to players. true = Yes / false = No / nil = default to the NPC
	['PlayerAlly'] 			= nil,
----------------------------------------------------------------- This table can be used to specify how our NPC should react to other NPCs and vice versa. ['MeToNPC'] sets how our NPC should react to the other NPC. ['NPCToMe'] sets how other NPC should react to ours. The first value sets the relation and the second one sets its strength. If you plan to use this table, make sure that ['Default'] is present inside as it will tell NPCs that are not present in here what to do. You can use NPC classes (npc_citizen) or ANP IDs/Names.
--[[
	['Relations'] = { 
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, -- "Hate" / "Like" / "Fear" / "Neutral"     
		
		['npc_combine_s'] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		
		['Other ANPlus NPC ID/Name'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Like", 0 } },
	},
--]]
	['Relations'] = nil, 	
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[	
	['ActivityOther'] = {
	
		[ACT_RELOAD] = { 100, { 49, 50 } }, -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
----EXAMPLE /\

	['ActivityOther'] = {
		 
		[ACT_RELOAD]		= { 800 },
		[ACT_RANGE_ATTACK1]	= { 3000 },
		[ACT_RANGE_ATTACK2]	= { 300 },
		
	},
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities. You can also change the movement speed at specified activities.
--[[	
	['ActivityMovement'] = {
	
		[ACT_RUN] = { 100, 100, { 49, 50 } }, -- The first value (100) represents the animation speed in %, the second value (100) represents the movement speed in %, and the third value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
----EXAMPLE /\
	['ActivityMovement'] = {
	
		[ACT_RUN]			= { 200, 900 },     
		[ACT_WALK]			= { 200, 900 },      
		
	},
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
	
		--['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			--['SoundLevel'] = nil, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			--['Pitch'] = nil, -- Also can be randomised,
			--['Channel'] = CHAN_VOICE, 
			--['Volume'] = { 0.3 }, -- Same.
			--['Flags'] = 1024, 
			--['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }
			}, 
			[2] = {"vo/npc/male01/ahgordon", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[3] = {"vo/npc/male01/docfreeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[4] = {"vo/npc/male01/freeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[5] = {"vo/npc/male01/hellodrfm", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[6] = {"vo/npc/male01/heydoc", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[7] = {"vo/npc/male01/hi", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			
			[8] = {"vo/npc/male01/evenodds", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[9] = {"vo/npc/male01/nice", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[10] = {"vo/npc/male01/oneforme", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[11] = {"vo/npc/male01/thislldonicely", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[12] = {"vo/npc/male01/yeah", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[13] = {"vo/npc/male01/finally", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[14] = {"vo/npc/male01/fantastic", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			
			[13] = {"vo/npc/male01/gotone", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[14] = {"vo/npc/male01/likethat", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[15] = {"vo/episode_1/npc/male01/cit_kill", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			
			[16] = {"vo/npc/male01/civilprotection", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[17] = {"vo/npc/male01/combine", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[18] = {"vo/npc/male01/cps", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[19] = {"vo/npc/male01/hacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[20] = {"vo/npc/male01/headcrabs", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[21] = {"vo/npc/male01/herecomehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[22] = {"vo/npc/male01/heretheycome", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[23] = {"vo/npc/male01/incoming", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[24] = {"vo/npc/male01/itsamanhack", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[25] = {"vo/npc/male01/scanners", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[26] = {"vo/npc/male01/strider", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[27] = {"vo/npc/male01/thehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[28] = {"vo/npc/male01/zombies", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 

		},
		
	}, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
--[[
	['RemoveOrReplaceOnDeath'] = {
		
		['SERVER'] = {
			[1] = {"raggib", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"}, -- The first vaule is for the entity class, the second is for it's default model, and the third one is for model the new model.
		},  
		['CLIENT'] = {
			[1] = {"class C_ClientRagdoll", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"},
		},  
        
	}, 
]]--
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
		
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	-- SHARED ( CLIENT & SERVER )
		
			if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():SetClip1( 9999 ) end
			
			self.anp_HealLast = 0
			self.anp_HealDelay = 3
		
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)

			activator:SetHealth( 200 )
			self:EmitSound( "vo/npc/male01/health05.wav", 75, 50, 1, CHAN_VOICE, 0, 0 )
			self:ANPlusPlayActivity( self:ANPlusTranslateSequence("heal"), 1, activator, 4 )   
		
		end,
		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)     	
		end,
		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )
		
			if (SERVER) && ent:GetClass() == "crossbow_bolt" then 
				
				ent:SetVelocity( ent:GetForward() * 1200 )
				ent.trail = ents.Create("env_rockettrail")
				ent.trail:SetPos( ent:GetPos() + ent:GetForward() * 16 )
				ent.trail:SetParent( ent )
				ent.trail:SetOwner( ent )
				ent.trail:SetLocalAngles( Angle( 0, 0, 0 ) )
				ent.trail:SetKeyValue( "scale", "1" )
				ent.trail:SetSaveValue( "m_SpawnRate", 100 )
				ent.trail:SetSaveValue( "m_ParticleLifetime", 1 )
				--ent.trail:SetSaveValue( "m_StartColor.Init( 0.65f, 0.65f , 0.65f );
				--ent.trail:SetSaveValue( "m_EndColor.Init( 0.0, 0.0, 0.0 );
				ent.trail:SetSaveValue( "m_StartSize", 6 )
				ent.trail:SetSaveValue( "m_EndSize", 32 )
				ent.trail:SetSaveValue( "m_SpawnRadius", 4 )
				ent.trail:SetSaveValue( "m_MinSpeed", 2 )
				ent.trail:SetSaveValue( "m_MaxSpeed", 16 )
				ent.trail:Spawn()
			
			end
		
		end,
		
		------------------------------------------------------------ OnNPCWeaponSwitch - This function runs whenever this NPC equips a new weapon.
		['OnNPCWeaponSwitch'] = function(self, oldWep, newWep) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
		end,
		
		------------------------------------------------------------ OnPhysgunPickup - This function runs when NPC gets picked up by the Player's PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnPickedUp - This function runs when NPC gets picked up by the Player's GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnPickedUp'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnDropped - This function runs when NPC gets dropped by the Player's GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnDropped'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnGravGunPunt - This function runs when NPC gets punted (GravGun primary attack) by a Player.
		['OnNPCGravGunPunt'] = function(ply, self)		
		end,
			
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
			
			local attacker = dmginfo:GetAttacker()
			
			if IsValid(attacker) and ( attacker:IsNPC() or attacker:IsPlayer() ) and attacker != self and self:Disposition( attacker ) != D_HT then   

				self:AddEntityRelationship( attacker, D_HT, 99 )
				self:SetEnemy( attacker )
			
			end
		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamage - This function runs whenever NPC gets damaged. Can also be used to detect which body part was hit.
		['OnNPCScaleDamage'] = function(self, hitgroup, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(npc, hitgroup, dmginfo)	
		
			npc:Ignite(2,2)
		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(ply, hitgroup, dmginfo)	
		
			ply:Ignite(2,2)
		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCDeath - This function runs when NPC dies.
		['OnNPCDeath'] = function(self, attacker, inflictor)
		end,
		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll)	-- SHARED ( CLIENT & SERVER )	
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,
		
		},
	
	}  
 
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Humans + Resistance",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "Mega Angry Odessa Cubbage",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/odessa.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomised between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
			}, 
			['Skin'] 		 = { 0, 0 },		-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { 				-- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 0, 0, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['Scale']					= { 100, 0 }, --% scale and delta time.
			['CollisionBounds']	= {	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL           
			},
		},
			---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= 0,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 400,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { true, 1, 10 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { citizentype = CT_REBEL, DontPickupWeapons = "true", SquadName = "omegadessa" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	},    
	--['InputsAndOutputs'] 	= {"kill", true}, 
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_crossbow" },
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 20000,   
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['weapon_crossbow'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = nil },
		['weapon_rpg'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = 20000 },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 8 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 300, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. The lowest value is -100% (no damage) and it can go as high as you wish (be reasonable).
		['Head'] 	 = -50, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= -100, --%,
		[DMG_POISON]	= -100, --%,
		[DMG_RADIATION]	= -30, --%,
		[DMG_ACID]		= -50, --%,
		[DMG_POISON]	= -50, --%,  
		
	}, 
----------------------------------------------------------------- Set if your NPC should be friendly to players. true = Yes / false = No / nil = default to the NPC
	['PlayerAlly'] 			= false,
----------------------------------------------------------------- This table can be used to specify how our NPC should react to other NPCs and vice versa. ['MeToNPC'] sets how our NPC should react to the other NPC. ['NPCToMe'] sets how other NPC should react to ours. First value sets the relation and the second one sets its strength. If you plan to use this table, make sure that ['Default'] is present inside as it will tell NPCs that are not present in here what to do.
	['Relations'] = { 
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, -- "Hate" / "Like" / "Fear" / "Neutral"     

	},    
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[	
	['ActivityOther'] = {
		[ACT_RELOAD]		= {
		
		{ 100, { 49, 50 } } -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
		
		}, 
	},
--]]
----EXAMPLE /\

	['ActivityOther'] = {
		 
		[ACT_RELOAD]		= { 800 },
		[ACT_RANGE_ATTACK1]	= { 3000 },
		[ACT_RANGE_ATTACK2]	= { 300 },
		
	},
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = {
	
		[ACT_RUN]			= { 200, 9000 },        
		[ACT_WALK]			= { 200, 9000 },  
		
	},
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
	
		--['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			--['SoundLevel'] = nil, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			--['Pitch'] = nil, -- Also can be randomised,
			--['Channel'] = CHAN_VOICE, 
			--['Volume'] = { 0.3 }, -- Same.
			--['Flags'] = 1024, 
			--['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" } 
			}, 
			[2] = {"vo/npc/male01/ahgordon", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[3] = {"vo/npc/male01/docfreeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[4] = {"vo/npc/male01/freeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[5] = {"vo/npc/male01/hellodrfm", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[6] = {"vo/npc/male01/heydoc", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[7] = {"vo/npc/male01/hi", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			
			[8] = {"vo/npc/male01/evenodds", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[9] = {"vo/npc/male01/nice", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[10] = {"vo/npc/male01/oneforme", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[11] = {"vo/npc/male01/thislldonicely", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[12] = {"vo/npc/male01/yeah", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[13] = {"vo/npc/male01/finally", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[14] = {"vo/npc/male01/fantastic", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			
			[13] = {"vo/npc/male01/gotone", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[14] = {"vo/npc/male01/likethat", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[15] = {"vo/episode_1/npc/male01/cit_kill", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			
			[16] = {"vo/npc/male01/civilprotection", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[17] = {"vo/npc/male01/combine", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[18] = {"vo/npc/male01/cps", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[19] = {"vo/npc/male01/hacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[20] = {"vo/npc/male01/headcrabs", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[21] = {"vo/npc/male01/herecomehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[22] = {"vo/npc/male01/heretheycome", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[23] = {"vo/npc/male01/incoming", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[24] = {"vo/npc/male01/itsamanhack", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[25] = {"vo/npc/male01/scanners", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[26] = {"vo/npc/male01/strider", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[27] = {"vo/npc/male01/thehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[28] = {"vo/npc/male01/zombies", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 

		},
		
	}, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
--[[
	['RemoveOrReplaceOnDeath'] = {
		
		['SERVER'] = {
			[1] = {"raggib", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"}, -- The first vaule is for the entity class, the second is for it's default model, and the third one is for model the new model.
		},  
		['CLIENT'] = {
			[1] = {"class C_ClientRagdoll", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"},
		},  
        
	}, 
]]--
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
		
			if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():SetClip1( 9999 ) end
			
			--self:Ignite( 9999, 0 )
			
			self.anp_HealLast = 0
			self.anp_HealDelay = 3   
			
			self:SetSaveValue( "m_bRPGAvoidPlayer", false )
		
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			activator:TakeDamage( 999, self, self )
			self:EmitSound( "vo/npc/male01/yeah02.wav", 75, 50, 1, CHAN_VOICE, 0, 0 )
			self:ANPlusPlayActivity( self:ANPlusTranslateSequence("heal"), 1, activator, 4 )   
		
		end,
		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		end, 
		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )
		
			if (SERVER) && ent:GetClass() == "crossbow_bolt" then
				
				ent:SetVelocity( ent:GetForward() * 1200 )
				ent.trail = ents.Create("env_rockettrail")
				ent.trail:SetPos( ent:GetPos() + ent:GetForward() * 16 )
				ent.trail:SetParent( ent )
				ent.trail:SetOwner( ent )
				ent.trail:SetLocalAngles( Angle( 0, 0, 0 ) )
				ent.trail:SetKeyValue( "scale", "1" )
				ent.trail:SetSaveValue( "m_SpawnRate", 100 )
				ent.trail:SetSaveValue( "m_ParticleLifetime", 1 )
				--ent.trail:SetSaveValue( "m_StartColor.Init( 0.65f, 0.65f , 0.65f );
				--ent.trail:SetSaveValue( "m_EndColor.Init( 0.0, 0.0, 0.0 );
				ent.trail:SetSaveValue( "m_StartSize", 6 )
				ent.trail:SetSaveValue( "m_EndSize", 32 )
				ent.trail:SetSaveValue( "m_SpawnRadius", 4 )
				ent.trail:SetSaveValue( "m_MinSpeed", 2 )
				ent.trail:SetSaveValue( "m_MaxSpeed", 16 )
				ent.trail:Spawn()
			
			end
		
		end,
		
		------------------------------------------------------------ OnNPCKilledPlayer - This function runs whenever this NPC kills a player.
		['OnNPCKilledPlayer'] = function(ply, inflictor, self) 	
		end,
		
		------------------------------------------------------------ OnNPCKilledNPC - This function runs whenever this NPC kills another NPC.
		['OnNPCKilledNPC'] = function(self, npc, inflictor)		
		end,
		
		------------------------------------------------------------ OnNPCWaterLevelChanged - This function runs when NPC gets submerged in water.
		['OnNPCWaterLevelChanged'] = function(self, old, new)
		end,
		
		------------------------------------------------------------ OnPhysgunPickup - This function runs when NPC gets picked up by Player's PhysGun. It won't work if ['AllowPhysgunPickup'] is set to false.
		['OnNPCOnPhysgunPickup'] = function(ply, self)
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnPickedUp - This function runs when NPC gets picked up by Player's GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
		['OnNPCGravGunOnPickedUp'] = function(ply, self)		
		end,
		
		------------------------------------------------------------ OnNPCGravGunOnDropped - This function runs when NPC gets dropped by Player's GravityGun. It won't work if ['AllowGravGunPickUp'] is set to false.
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
		
				npc:Ignite(2,2)
		
		end,
		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(ply, hitgroup, dmginfo)	
		
				ply:Ignite(2,2)
		
		end,
		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,
		
		------------------------------------------------------------ OnNPCDeath - This function runs whenever NPC dies.
		['OnNPCDeath'] = function(self, attacker, inflictor)
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,
		
		},
	
	}  
 
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 
