----------------------------------------------------------- Precache Section
--WARNING!
--Modelprecache is limited to 4096 unique models. When it reaches the limit the game will crash.
--Soundcache is limited to 16384 unique sounds on the server.
----------------------------------------------------------]]

--util.PrecacheModel( "models/odessa.mdl" ) -- There is no need to precache this model

--util.PrecacheSound( string soundName )
------------------------------------------------------------

local ANPlusLoaded = file.Exists("lua/autorun/addnpcplus_base.lua","GAME") 
if !ANPlusLoaded then return end

ANPlus.AddNPCWeapon( "swep_anp_base", "[CUP] Synth Rifle", "swep_cup_synthrifle", "HUD/killicons/synth_rifle", nil )  
ANPlus.AddNPCWeapon( "swep_anp_base", "[CUP] Juggergun", "swep_cup_juggernaut", "HUD/killicons/juggergun", nil )  
ANPlus.AddNPCWeapon( "swep_anp_base", "[CUP] Combine Sniper", "swep_cup_combinesniper", "HUD/killicons/csniperrifle", nil )  
ANPlus.AddNPCWeapon( "swep_anp_base", "[CUP] Sterilizer", "swep_cup_sterilizator", "HUD/killicons/sterilizer", nil )  
ANPlus.AddNPCWeapon( "swep_anp_base", "[CUP] ION MK.I", "swep_cup_ion_launcher", "HUD/killicons/ion_launcher", nil )  
ANPlus.AddNPCWeapon( "swep_anp_base", "[CUP] Pulse Pistol", "swep_cup_pulse_pistol", "HUD/killicons/cup_pistol", nil )  

sound.Add( {
	name = "ANP.CombineMedicHeal.Ply", 
	channel = CHAN_VOICE,
	volume = 0.65,
	level = SNDLVL_NORM,
	pitch = PITCH_NORM,
	sound = { "npc/combine_medic/administer_stimdose.wav", "npc/combine_medic/delivered_medical.wav" }
} )

sound.Add( {
	name = "ANP.CombineMedicHeal.Passive",
	channel = CHAN_AUTO,
	volume = 0.05,
	level = 80,
	pitch = 40,
	sound = { "items/medshot4.wav" }
} )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Medic",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cup/npc/combine_medic.mdl", 
			['BodyGroups'] 	 = nil, 					-- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "models/combine_soldier/combinemedicsheet",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 45,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the amount of health of each gain.	
	['HealthRegen'] 		= { false, 2, 2 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 3, tacticalvariant = 0, SquadName = "overwatch" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= SF_NPC_DROP_HEALTHKIT, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_smg1" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= nil, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['smg'] = { ['Proficiency'] = 3, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 100 is default.
		['Chest'] 	 = 0, --%, 100 is default.
		['Stomach']  = 0, --%, 100 is default.
		['LeftArm']  = 0, --%, 100 is default.
		['RightArm'] = 0, --%, 100 is default.
		['LeftLeg']  = 0, --%, 100 is default.
		['RightLeg'] = 0, --%, 100 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= 50, --%,
		[DMG_POISON]	= 50, --%,
		[DMG_ACID]		= 50, --%,
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 200, 400, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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
		 
		[17]		= { 100, 108 },
		
	},
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	  
		
			self.m_fHealLast = 0
			self.m_fHealDelay = 2
			self.m_fEHealLast = 0
			self.m_fEHealDelay = 10
		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI || activator:Health() >= activator:GetMaxHealth() then return end
			
			local need = math.min( activator:GetMaxHealth() - activator:Health(), 25 )-- Dont overheal
			activator:SetHealth( math.min( activator:GetMaxHealth(), activator:Health() + need ) )
			
			self:EmitSound( "ANP.CombineMedicHeal.Ply" )
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		
			local allyTab = ents.FindInSphere( self:GetPos(), 150 )
			
			if CurTime() - self.m_fHealLast >= self.m_fHealDelay then
			
				for _, ally in pairs( allyTab ) do
				
					if IsValid(ally) && ( ally:IsNPC() || ( ally:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) ) && ally != self && self:Visible( ally ) && ally:ANPlusAlive() && ally:GetMaxHealth() > 0 && ally:Health() < ally:GetMaxHealth() && ally:GetBloodColor() == 0 && self:Disposition( ally ) != D_HT then
						
						local need = math.min( ally:GetMaxHealth() - ally:Health(), IsValid(self:GetEnemy()) && 2 || !IsValid(self:GetEnemy()) && 4 )-- Dont overheal 
						ally:SetHealth( math.min( ally:GetMaxHealth(), ally:Health() + need ) )					 
						ally:ANPlusHaloEffect( Color( 0, 155, 255 ), 1, 2 ) 						
						ally:EmitSound( "ANP.CombineMedicHeal.Passive" )
						
						if CurTime() - self.m_fEHealLast >= self.m_fEHealDelay && ally:Health() <= ally:GetMaxHealth() * 0.4 && self:GetInternalVariable("NumGrenades") > 0 && !self:IsCurrentSchedule( SCHED_RANGE_ATTACK2 ) then					
							self:SetSchedule( SCHED_RANGE_ATTACK2 )						
							self.m_fEHealLast = CurTime()						
						end						
						self.m_fHealLast = CurTime()					
					end
				
				end
			
			end
		
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)
		
			if (SERVER) && ent:GetClass() == "npc_grenade_frag" then 
			
				if IsValid(self.thing) then self.thing:Remove() end
			
				ent:Remove()
				
				self.thing = ents.Create( "sent_anp_combine_medic_thing" )
				local newAng = Angle( 0, self:GetAngles().y, 0 )
				local offsetVec = Vector( 20, 0, 8 )
				local offsetAng = Angle( 0, 0, 0 )
				local newPos, newAng = LocalToWorld( offsetVec, offsetAng, self:GetPos(), newAng )
				self.thing:SetPos( newPos )
				self.thing:SetAngles( newAng )
				self.thing:Spawn()
				self.thing:Activate()
				self.thing:SetOwner( self )
				self:DeleteOnRemove( self.thing )			
			
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
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,	
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Medic Armored",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/armored_soldier.mdl", 
			['BodyGroups'] 	 = nil, 					-- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = {
				[1] = { "models/combine_soldier/combinemedicsheet" },
				[2] = { "models/combine_soldier/armor_chest_medic" },
				[3] = "",
				[4] = { "models/combine_soldier/armor_thigh_r_medic" },
				[5] = { "models/combine_soldier/armor_thigh_l_medic" },
				[6] = { "models/combine_soldier/armor_arm_medic" },
			}, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 45,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { false, 2, 2 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 3, tacticalvariant = 0, SquadName = "overwatch" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= SF_NPC_DROP_HEALTHKIT, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_smg1" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= nil, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['smg'] = { ['Proficiency'] = 3, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = -30, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 100 is default.
		['Chest'] 	 = -30, --%, 100 is default.
		['Stomach']  = -30, --%, 100 is default.
		['LeftArm']  = -30, --%, 100 is default.
		['RightArm'] = -30, --%, 100 is default.
		['LeftLeg']  = -30, --%, 100 is default.
		['RightLeg'] = -30, --%, 100 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= -50, --%,
		[DMG_POISON]	= -50, --%,
		[DMG_ACID]		= -50, --%,
		[DMG_BLAST]		= -10, --%,
		[DMG_BUCKSHOT]	= -25, --%,
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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
		 
		[17]		= { 100, 108 },
		
	},
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = {
	
		[10]		= { 80, 80 },                                                                      
		[362]		= { 80, 80 },                                                                
		[363]		= { 80, 80 },                                                                
		[358]		= { 80, 80 },                                                                
		[6]			= { 80, 80 },     
	
	},
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks. 
	['Functions'] = {	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
			
			self.m_fHealLast = 0
			self.m_fHealDelay = 2
			self.m_fEHealLast = 0
			self.m_fEHealDelay = 10  
		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI || activator:Health() >= activator:GetMaxHealth() then return end
			
			local need = math.min( activator:GetMaxHealth() - activator:Health(), 25 )-- Dont overheal
			activator:SetHealth( math.min( activator:GetMaxHealth(), activator:Health() + need ) )
			
			self:EmitSound( "ANP.CombineMedicHeal.Ply" )
		
		end,	
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)

			local allyTab = ents.FindInSphere( self:GetPos(), 150 )
			
			if CurTime() - self.m_fHealLast >= self.m_fHealDelay then
			
				for _, ally in pairs( allyTab ) do
				
					if IsValid(ally) && ( ally:IsNPC() || ( ally:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) ) && ally != self && self:Visible( ally ) && ally:ANPlusAlive() && ally:GetMaxHealth() > 0 && ally:Health() < ally:GetMaxHealth() && ally:GetBloodColor() == 0 && self:Disposition( ally ) != D_HT then
						
						local need = math.min( ally:GetMaxHealth() - ally:Health(), IsValid(self:GetEnemy()) && 2 || !IsValid(self:GetEnemy()) && 4 )-- Dont overheal 
						ally:SetHealth( math.min( ally:GetMaxHealth(), ally:Health() + need ) )					 
						ally:ANPlusHaloEffect( Color( 0, 155, 255 ), 1, 2 ) 					
						ally:EmitSound( "ANP.CombineMedicHeal.Passive" )
						
						if CurTime() - self.m_fEHealLast >= self.m_fEHealDelay && ally:Health() <= ally:GetMaxHealth() * 0.4 && self:GetInternalVariable("NumGrenades") > 0 && !self:IsCurrentSchedule( SCHED_RANGE_ATTACK2 ) then						
							self:SetSchedule( SCHED_RANGE_ATTACK2 )						
							self.m_fEHealLast = CurTime()					
						end						
						self.m_fHealLast = CurTime()					
					end				
				end			
			end		
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )
		
			if (SERVER) && ent:GetClass() == "npc_grenade_frag" then
			
				if IsValid(self.thing) then self.thing:Remove() end
			
				ent:Remove()
				
				self.thing = ents.Create( "sent_anp_combine_medic_thing" )
				local newAng = Angle( 0, self:GetAngles().y, 0 )
				local offsetVec = Vector( 20, 0, 8 )
				local offsetAng = Angle( 0, 0, 0 )
				local newPos, newAng = LocalToWorld( offsetVec, offsetAng, self:GetPos(), newAng )
				self.thing:SetPos( newPos )
				self.thing:SetAngles( newAng )
				self.thing:Spawn()
				self.thing:Activate()
				self.thing:SetOwner( self )
				self:DeleteOnRemove( self.thing )						
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
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,	
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local function SetPhysics(ent, bool)
	
	if bool then
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetSolid( SOLID_VPHYSICS )	
	else
		ent:PhysicsInit( SOLID_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent:SetSolid( SOLID_NONE )
	end
end

local riotMeleeAngs = {
	['Pitch'] 	= 70,
	['Yaw'] 	= 45,
	['Roll'] 	= 360,
}

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Riot Police",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_metropolice",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 45,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_smg1" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 6000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = 1000, ['SecondaryMaxRange'] = nil }, 
		
		['smg'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = 1000, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 100 is default.
		['Chest'] 	 = 0, --%, 100 is default.
		['Stomach']  = 0, --%, 100 is default.
		['LeftArm']  = 0, --%, 100 is default.
		['RightArm'] = 0, --%, 100 is default.
		['LeftLeg']  = 0, --%, 100 is default.
		['RightLeg'] = 0, --%, 100 is default.  
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	

			--self:ANPlusParentToBone( , "ValveBiped.Bip01_R_Hand", Vector( 25, -8, 28 ), Angle( -60, -95, 260 ) )
			--self:SetSequence( self:SelectWeightedSequence( 321 ) )	
			self.shield = ents.Create( "base_anim" )
			self.shield:SetModel( "models/cup/shield/ballisticshield_mod.mdl" )			   			
			SetPhysics( self.shield, true ) 
			self.shield:SetOwner( self )
			self.shield:Spawn()
			self.shield:Activate()
			self.shield:AddEFlags( EFL_DONTBLOCKLOS )
			self.shield:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			--self:ANPlusParentToBone( self.shield, "ValveBiped.Bip01_R_Hand", Vector( 25, -8, 28 ), Angle( -60, -95, 260 ) )			
			self.shield:ANPlusParentToBone( self, "ValveBiped.Bip01_L_Hand", Vector( -5, 9, -31 ), Angle( -35, -90, 80 ) )			
			self.m_bShieldOnBack = true
			self:ANPlusAddAnimationEvent("thrust", 19, 1)
			
		end,	
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		
			if IsValid(self:GetEnemy()) and self:GetEnemy():ANPlusAlive() then 
				
				local enemy = self:GetEnemy()
				local meleeAct = self:ANPlusTranslateSequence( "thrust" )
				self:ANPlusMeleeAct( enemy, meleeAct, 1, 2, 70, riotMeleeAngs, nil )
						
			end	
		end, 		
		------------------------------------------------------------ OnNPCHandleAnimationEvent - TEST.
		['OnNPCHandleAnimationEvent'] = function(self, seq, ev)
			if seq == "thrust" && ev == 1 then				
				self:ANPlusDealMeleeDamage( 70, 10, DMG_CLUB, nil, nil, riotMeleeAngs, "npc/fast_zombie/claw_strike1.wav", "npc/fast_zombie/claw_miss1.wav", function(ent, dmginfo)
					ent:SetVelocity( self:GetForward() * 300 + self:GetUp() * 100 )
				end)
			end
		end, 
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)
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
		end,	
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(ply, hitgroup, dmginfo)		
		end,	
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,	
		------------------------------------------------------------ OnNPCDeath - This function runs whenever NPC dies.
		['OnNPCDeath'] = function(self, attacker, inflictor)	

			if IsValid(self.shield) then 
				self.shield:ANPlusUnParentFromBone( self, "ValveBiped.Bip01_R_Hand", nil, COLLISION_GROUP_WEAPON ) 
				local physObj = self.shield:GetPhysicsObject()
				physObj:Wake()
				SafeRemoveEntityDelayed( self.shield, 5 ) 
			end
		end,	
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
			if IsValid(self.shield) then self.shield:Remove() end
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Synth Soldier",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cmb_synth_soldier.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 70,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { false, 1, 1 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 3, Tacticalvariant = 3, SquadName = "overwatch" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_synthrifle" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= nil, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_synthrifle'] = { ['Proficiency'] = 3, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = 2000, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = -20, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = -20, --%, 100 is default.
		['Chest'] 	 = -20, --%, 100 is default.
		['Stomach']  = -20, --%, 100 is default.
		['LeftArm']  = -20, --%, 100 is default.
		['RightArm'] = -20, --%, 100 is default.
		['LeftLeg']  = -20, --%, 100 is default.
		['RightLeg'] = -20, --%, 100 is default.  
		
	},
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self:SetSaveValue( "m_nKickDamage", 30 )		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )
			
			if (SERVER) && ent:GetClass() == "npc_grenade_frag" then

				local enemy = self:GetEnemy()			
				if IsValid(self) && IsValid(enemy) then
					
					if IsValid(self.tpnade) then self.tpnade:Remove() end
					
					self.tpnade = ents.Create( "sent_anp_tpnade" )
					self:ANPlusSetToBonePosAndAng( self.tpnade, "ValveBiped.Bip01_R_Hand", nil, Angle( 0, 0, 0 ) )
					self.tpnade:SetAngles( Angle(0,0,0) )
					self.tpnade:SetOwner( self )
					self.tpnade:Spawn()
					self.tpnade:Activate()
					self:DeleteOnRemove( self.tpnade )

					local phys1 = ent:GetPhysicsObject()   
					self.tpnade:SetVelocity( phys1:GetVelocity() )										
						
				end		
				
				ent:Remove()
				
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
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
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Synth Elite Soldier",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cmb_synth_elite.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 100,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { true, 1, 3 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 3, Tacticalvariant = 3, SquadName = "overwatch" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_synthrifle" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 6000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_synthrifle'] = { ['Proficiency'] = 3, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = 3000, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = -20, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = -20, --%, 100 is default.
		['Chest'] 	 = -20, --%, 100 is default.
		['Stomach']  = -20, --%, 100 is default.
		['LeftArm']  = -20, --%, 100 is default.
		['RightArm'] = -20, --%, 100 is default.
		['LeftLeg']  = -20, --%, 100 is default.
		['RightLeg'] = -20, --%, 100 is default.  
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
			self:SetSaveValue( "m_nKickDamage", 30 )
		end,	
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end
		
		end,	
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )
			
			if (SERVER) && ent:GetClass() == "npc_grenade_frag" then

				local enemy = self:GetEnemy()			
				if IsValid(self) && IsValid(enemy) then
					
					if IsValid(self.tpnade) then self.tpnade:Remove() end
					
					self.tpnade = ents.Create( "sent_anp_tpnade" )
					self:ANPlusSetToBonePosAndAng( self.tpnade, "ValveBiped.Bip01_R_Hand", nil, Angle( 0, 0, 0 ) )
					self.tpnade:SetAngles( Angle(0,0,0) )
					self.tpnade:SetOwner( self )
					self.tpnade:Spawn()
					self.tpnade:Activate()
					self:DeleteOnRemove( self.tpnade )

					local phys1 = ent:GetPhysicsObject()   
					self.tpnade:SetVelocity( phys1:GetVelocity() )										
						
				end		
				
				ent:Remove()
				
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
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
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Juggernaut",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cup/npc/juggernaut.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 300,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 0, Tacticalvariant = 3, SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_juggernaut" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= nil, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_juggernaut'] = { ['Proficiency'] = 3, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = -50, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = -50, --%, 100 is default.
		['Chest'] 	 = -50, --%, 100 is default.
		['Stomach']  = -50, --%, 100 is default.
		['LeftArm']  = -50, --%, 100 is default.
		['RightArm'] = -50, --%, 100 is default.
		['LeftLeg']  = -50, --%, 100 is default.
		['RightLeg'] = -50, --%, 100 is default.  
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self:SetSaveValue( "m_nKickDamage", 50 )
		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
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
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Sniper",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cup/npc/combine_sniper_2.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 40,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 0, Tacticalvariant = 1, SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_combinesniper" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 10000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_combinesniper'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = 10000, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= nil, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 100 is default.
		['Chest'] 	 = 0, --%, 100 is default.  
		['Stomach']  = 0, --%, 100 is default.
		['LeftArm']  = 0, --%, 100 is default.
		['RightArm'] = 0, --%, 100 is default.
		['LeftLeg']  = 0, --%, 100 is default.
		['RightLeg'] = 0, --%, 100 is default.  
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 300, 500, 800, 1400 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.        
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self:SetSaveValue( "m_nKickDamage", 10 )	
				
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
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
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Sterilizer",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cup/npc/combine_sterilizer2.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = {
				[1] = {"models/player/combine/soldier/combine_sterilizer"},
			}, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 120,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 0, Tacticalvariant = 2, SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_sterilizator" }, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 10000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_sterilizator'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 100 is default.
		['Chest'] 	 = 0, --%, 100 is default.
		['Stomach']  = 0, --%, 100 is default.
		['LeftArm']  = 0, --%, 100 is default.
		['RightArm'] = 0, --%, 100 is default.
		['LeftLeg']  = 0, --%, 100 is default.
		['RightLeg'] = 0, --%, 100 is default.  
		
		[DMG_BURN] 	 = 0,     
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 1000, 1600 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,	
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.        
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)
		
			self:SetSaveValue( "m_nKickDamage", 30 )
			self.Napalm = ents.Create( "sent_anp_napalmtank" )
			self.Napalm:ANPlusParentToBone( self, "ValveBiped.Bip01_Spine2", Vector( 4, -11, 0 ), Angle( 0, 0, 12 ) )
			self.Napalm:SetOwner( self )			
			self.Napalm:Spawn()
			self.Napalm:Activate()
		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end       
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			
			if self:IsOnFire() && IsValid(self.Napalm) && self.Napalm:Health() > self.Napalm:GetMaxHealth() * 0.5 then self:Extinguish() end           
			
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
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
		end,		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(ply, hitgroup, dmginfo)		
		end,		
		------------------------------------------------------------ OnNPCDamageOnEntity - This function runs whenever NPC damages anything (Players, NPCs, and other Entities). You can't define hit groups through it.
		['OnNPCDamageOnEntity'] = function(self, ent, dmginfo)	
		end,	
		------------------------------------------------------------ OnNPCDeath - This function runs whenever NPC dies.
		['OnNPCDeath'] = function(self, attacker, inflictor)
			if IsValid(self.Napalm) then self.Napalm:Remove() end
		end,		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			if IsValid(self.Napalm) then self.Napalm:Remove() end
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab )   

local icon = Material( "effects/overseer_buff.png" )
hook.Add( "PostDrawEffects", "ANPlus_OverseerBuffIcon", function()
	local ply = LocalPlayer()
	local radius = ents.FindInSphere( ply:GetPos(), 2000 )
	for k,v in pairs ( radius ) do				
		if v:GetNWBool( "ANP_OverseerBuffed" ) && v:ANPlusAlive() then  
			local bananalevitate = math.sin( CurTime() * 3 ) * ( 1 * 2 )		
			local offsetVec = Vector( 0, 0, 40 + bananalevitate )
			local offsetAng = Angle( 0, 0, 0 )
			local newPos, newAng = LocalToWorld( offsetVec, offsetAng, v:GetPos() + v:OBBCenter() * 1.15, Angle( 0, 0, 0 ) ) 
			cam.Start3D()
				render.SetMaterial( icon )
				render.DrawSprite( newPos, 12, 14, Color( 155, 155, 155, 200 ) )
			cam.End3D()
		end			
	end		
end)

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Overseer",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_metropolice",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		---            
		{ "models/cup/npc/police.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 70,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_pistol" }, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 10000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		 
		['Body'] 	 = 0, --%, 0 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.      
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
	}, 
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,	
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	

			self.m_fBuffLast = 0
			self.m_fBuffDelay = 0.9    
		    		 
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end    

		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			
			self.m_tbMyAllies = ents.FindInSphere( self:GetPos(), 512 )
			
			if CurTime() - self.m_fBuffLast <= self.m_fBuffDelay then return end
			
			for _, ent in pairs( self.m_tbMyAllies ) do
			
				if ( ent:IsPlayer() || ent:IsNPC() ) && ent != self && !ANPlusSameType(self, ent) && ( self:Disposition( ent ) == D_LI || self:Disposition( ent ) == D_NU ) then

					ent:SetNWBool( "ANP_OverseerBuffed", true )			
					ent.ANPlusQuickDamageDealtOverride = function( ent, victim, dmg )
						dmg:AddDamage( dmg:GetBaseDamage() * 0.5 ) 	
					end					
					ent.ANPlusQuickDamageTakenOverride = function( ent, dmg )						
						dmg:AddDamage( dmg:GetBaseDamage() * -0.5 ) 				
					end
					timer.Create( "ANPlusOverseer_ResetDMGBuff" .. ent:EntIndex(), 1, 1, function()
						if !IsValid(ent) then return end
						ent.ANPlusQuickDamageTakenOverride = nil
						ent.ANPlusQuickDamageDealtOverride = nil
						ent:SetNWBool( "ANP_OverseerBuffed", false )
					end)	
				
				end
			
			end
			
			self.m_fBuffLast = CurTime()
			
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
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
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Wasteland Mine",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_rollermine",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		---            
		{ "models/cup/npc/roller_spikes.mdl",  
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = {
				[1] = {"models/wmine/wasteland_mine_sheet"} 
			}, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -20, -20, -20 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 20, 20, 20 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 1,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= true,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= 10,  
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 5,  
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 65536, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc. 
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 10000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		 
		['Body'] 	 = 0, --%, 0 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.       
		
	}, 
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
	}, 
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	npc/roller/mine/rmine_moveslow_loop1.wav
	['SoundModification'] = {
	
	['SoundList'] = {
			[1] = {"npc/roller/mine/rmine_moveslow_loop1", ['SoundLevel'] = 65, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/wasteland_mine/rmine_movefast_loop2.wav" }, 
			[2] = {"npc/roller/mine/rmine_taunt", ['SoundLevel'] = 65, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0.8, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/wasteland_mine/rmine_seek_loop1.wav" }, 
		},
	},	
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)			
			
			function self:BuryMe(dist)
			if self:GetVelocity():Length() <= 0 && !self:GetInternalVariable( "m_bBuried" ) then
				self:StopSound( "npc/wasteland_mine/rmine_seek_loop1.wav" )
				self:EmitSound( "physics/concrete/boulder_impact_hard1.wav", 75, 130, 0.7, CHAN_ITEM, 0, 0 )
				local physObj = self:GetPhysicsObject()
				physObj:EnableMotion( false )
				self:SetPos( self:GetPos() + Vector( 0, 0, dist ) )
				self:SetSaveValue( "m_iSoundEvselfFlags", 0 )
				self:SetSaveValue( "m_bBuried", true )
				self:SetNPCState( 1 )
				self.anp_popoutSND = false
			end
		end
			
			self:BuryMe( -20 )			
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end       
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self) 

			if !IsValid(self:GetEnemy()) then self:BuryMe( -10 ) end

			if !self:GetInternalVariable( "m_bBuried" ) && !self.m_bpopoutSND then self.m_bpopoutSND = true; self:EmitSound( "weapons/smg1/smg1_glauncher.wav", 70, 80, 1, CHAN_AUTO, 0, 0 ) end
	
			self:ANPlusCheckSpace( self:GetPos(), self:GetPos(), function( ent ) return ( ent:GetClass() != "npc_rollermine" && ent != self ) end, true, MASK_SHOT_HULL, Vector( -30, -30, -30 ), Vector( 30, 30, 30 ), function(self, tr)			
				if IsValid(tr.Entity) && ( ( tr.Entity:IsPlayer() && !GetConVar( "ai_ignoreplayers" ):GetBool() ) || tr.Entity:IsNPC() ) && self:Visible(tr.Entity) && self:Disposition( tr.Entity ) == D_HT && !self.m_bdetonated then
					self.m_bdetonated = true
					local dmginfo = DamageInfo()
						dmginfo:SetDamageType( DMG_BLAST )
						dmginfo:SetDamage( 150 )
						dmginfo:SetAttacker( self )
						dmginfo:SetInflictor( self )
					ParticleEffect( "grenade_explosion_01", self:GetPos(), Angle( 0, 0, 0 ) )
					self:EmitSound( "ambient/explosions/explode_9.wav", 90, 100, 1, CHAN_WEAPON, 0, 0 )
					util.BlastDamageInfo( dmginfo, self:GetPos(), 400 )
					self:Remove()
				end			
			end)
			
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
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
			if ( dmginfo:GetDamageType() == DMG_BURN || dmginfo:GetDamageType() == DMG_BLAST ) && dmginfo:GetDamage() > 0 then self.m_bdetonated = true end
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
			self:StopSound( "npc/wasteland_mine/rmine_movefast_loop2.wav" )
			self:StopSound( "npc/wasteland_mine/rmine_seek_loop1.wav" )
		end,		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			self:StopSound( "npc/wasteland_mine/rmine_movefast_loop2.wav" )
			self:StopSound( "npc/wasteland_mine/rmine_seek_loop1.wav" )
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab )   

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Wasteland Roller",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_rollermine",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		---            
		{ "models/cup/npc/roller.mdl",  
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = {
				[1] = {"models/wmine/wasteland_mine_sheet"} 
			}, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR     
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -20, -20, -20 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 20, 20, 20 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 1,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 5,  
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 65536, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc. 
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 10000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		 
		['Body'] 	 = 0, --%, 0 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.       
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 800, 1200 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
	}, 
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	npc/roller/mine/rmine_moveslow_loop1.wav
	['SoundModification'] = {
	
	['SoundList'] = {
			[1] = {"npc/roller/mine/rmine_moveslow_loop1", ['SoundLevel'] = 65, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/wasteland_mine/rmine_movefast_loop2.wav" }, 
			[2] = {"npc/roller/mine/rmine_taunt", ['SoundLevel'] = 65, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0.8, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/wasteland_mine/rmine_seek_loop1.wav" }, 
		},
	},	
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)			
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end       
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self) 
		
			if !IsValid(self:GetEnemy()) && self:GetInternalVariable( "m_iSoundEventFlags" ) != 0 then
				self:StopSound( "npc/wasteland_mine/rmine_seek_loop1.wav" )
				self:SetSaveValue( "m_iSoundEventFlags", 0 )
			end
			self:ANPlusCheckSpace( self:GetPos(), self:GetPos(), function( ent ) return ( ent:GetClass() != "npc_rollermine" && ent != self ) end, true, MASK_SHOT_HULL, Vector( -80, -80, -80 ), Vector( 80, 80, 80 ), function(self, tr)			
				if self. IsValid(tr.Entity) && ( ( tr.Entity:IsPlayer() && !GetConVar( "ai_ignoreplayers" ):GetBool() ) || tr.Entity:IsNPC() ) && self:Visible(tr.Entity) && self:Disposition( tr.Entity ) == D_HT && !self.m_bdetonated then
					self.m_bdetonated = true
					self:EmitSound( "npc/wasteland_mine/oh_no3.wav", 75, 110, 1, CHAN_WEAPON, 0, 0 )
					timer.Simple( 1, function()
						if !IsValid(self) then return end
						local dmginfo = DamageInfo()
							dmginfo:SetDamageType( DMG_BLAST )
							dmginfo:SetDamage( 100 )
							dmginfo:SetAttacker( self )
							dmginfo:SetInflictor( self )
						ParticleEffect( "grenade_explosion_01", self:GetPos(), Angle( 0, 0, 0 ) )
						self:EmitSound( "ambient/explosions/explode_9.wav", 90, 100, 1, CHAN_WEAPON, 0, 0 )
						util.BlastDamageInfo( dmginfo, self:GetPos(), 300 )
						self:Remove()
					end)
				end			
			end)
			
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
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
			if ( dmginfo:GetDamageType() == DMG_BURN || dmginfo:GetDamageType() == DMG_BLAST ) && dmginfo:GetDamage() > 0 then self.m_bdetonated = true end
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
			self:StopSound( "npc/wasteland_mine/rmine_movefast_loop2.wav" )
			self:StopSound( "npc/wasteland_mine/rmine_seek_loop1.wav" )
		end,		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			self:StopSound( "npc/wasteland_mine/rmine_movefast_loop2.wav" )
			self:StopSound( "npc/wasteland_mine/rmine_seek_loop1.wav" )
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

sound.Add( {
	name = "ANP.WEAPON.AsssassinPistol.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 65,
	pitch = { 95, 105 },
	sound = { "weapons/assassin_gun/pl_gun1.wav", "weapons/assassin_gun/pl_gun2.wav" }
} )

local behToWatchFor = {
	[41] = true,
	[42] = true,
	[45] = true,
	[46] = true, 
	[44] = true
}

local actToWatchFor = {
	[64] = true,
	[65] = true,
	[139] = true,
	[140] = true
}

local stuffToWatchFor = {
	['grenade'] = true,
	['frag'] = true,
	['rocket'] = true,
	['missile'] = true, 
	['flechette'] = true
}

local FLIP_FORWARD = 1
local FLIP_LEFT = 2
local FLIP_BACKWARD = 3
local FLIP_RIGHT = 4

local tbFlipAct = { ACT_HL2MP_JUMP_AR2, ACT_HL2MP_JUMP_PISTOL, ACT_HL2MP_JUMP_SMG1, ACT_HL2MP_JUMP }

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Assassin",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cup/npc/fassassin.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 50,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 3, Tacticalvariant = 3, SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.   
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_assassinpistol" }, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 10000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_assassinpistol'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 8 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 64, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 100 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 100 is default.
		['Chest'] 	 = 0, --%, 100 is default.
		['Stomach']  = 0, --%, 100 is default.
		['LeftArm']  = 0, --%, 100 is default.
		['RightArm'] = 0, --%, 100 is default.
		['LeftLeg']  = 0, --%, 100 is default.
		['RightLeg'] = 0, --%, 100 is default.    
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 1000, 1400 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = false,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,	
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] 			= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.      
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)
			self.m_fjumpCount = 0
			self.m_fjumpLast = 0
			self.m_fjumpDelay = 1.5
			
			self.spriteEye = ANPlusCreateSprite( "sprites/glow01.spr", Color( 232, 85, 50 ), 0.1, 1, { rendermode = 5 } )
			self.spriteEye:ANPlusParent( self, "Eye" )
			self:DeleteOnRemove( self.spriteEye )	
			
			self.beamEye = ANPlusCreateSpotlight( Color( 232, 85, 50, 255 ), 10, 20, 1 + 2 )
			self.beamEye:ANPlusParent( self, "Eye", Vector( 0, 0, 0 ), Angle( -30, 40, 0 ) )
			
			util.SpriteTrail( self, self:LookupAttachment( "Eye" ), Color( 200, 47, 52 ), true, 8, 8, 0.8, 0.125, "models/fassassin/eyetrail.vmt" )

			function self:FlipDanger(vecPos)
				if !self:OnGround() || CurTime() - self.m_fjumpLast < self.m_fjumpDelay || !vecPos then return end
				local cbX, cbY = self:GetCollisionBounds()
				local ang = self:GetAngles()
				local angDanger = ( vecPos - self:GetPos() ):Angle()
				local y = math.NormalizeAngle( ang.y - angDanger.y )
				local forOk = self:ANPlusCheckWay( self:GetPos(), self:GetPos() + self:GetForward() * 110, { self, self:GetActiveWeapon() }, false, MASK_SHOT_HULL )	
				local lefOk = self:ANPlusCheckWay( self:GetPos(), self:GetPos() + self:GetRight() * 110, { self, self:GetActiveWeapon() }, false, MASK_SHOT_HULL )	
				local bacOk = self:ANPlusCheckWay( self:GetPos(), self:GetPos() + self:GetForward() * -110, { self, self:GetActiveWeapon() }, false, MASK_SHOT_HULL )
				local rigOk = self:ANPlusCheckWay( self:GetPos(), self:GetPos() + self:GetRight() * -110, { self, self:GetActiveWeapon() }, false, MASK_SHOT_HULL )
				local flip = 0
				if ( y <= 45 && y >= -45 && bacOk ) || ( !forOk || !lefOk || !rigOk ) && bacOk then
					self:SetVelocity( self:GetForward() * -1900 + self:GetUp() * 250 )
					flip = FLIP_BACKWARD
				elseif ( y <= 135 && y > 45 && rigOk ) || ( !forOk || !lefOk || !bacOk ) && rigOk then
					self:SetVelocity( self:GetRight() * -1900 + self:GetUp() * 250 )
					flip = FLIP_RIGHT
				elseif ( y >= -135 && y < -45 && lefOk ) || ( !forOk || !rigOk || !bacOk ) && lefOk then
					self:SetVelocity( self:GetRight() * 1900 + self:GetUp() * 250 )	
					flip = FLIP_LEFT
				elseif forOk then
					self:SetVelocity( self:GetForward() * 1900 + self:GetUp() * 250 )
					flip = FLIP_FORWARD
				else 
					return
				end
				self:ANPlusPlayActivity( tbFlipAct[flip], 1 )
				self.m_fjumpLast = CurTime() 
			end
			
			function self:DangerStuff(ent)
				if ent:IsWeapon() then return false end
				if (
					string.find( ent:GetClass(), "grenade" ) ||
					string.find( ent:GetClass(), "missile" ) ||
					string.find( ent:GetClass(), "rocket" ) ||
					string.find( ent:GetClass(), "frag" ) ||
					string.find( ent:GetClass(), "flashbang" ) ||
					string.find( ent:GetClass(), "flechette" ) ||
					string.find( ent:GetClass(), "portal" ) ||
					string.find( ent:GetClass(), "spore" ) ||
					string.find( ent:GetClass(), "prop_combine_ball" ) ||
					string.find( ent:GetClass(), "bolt" ) 
				) then
				return true 
				end
				return false
			end
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end       
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			if IsValid(self:GetEnemy()) then
				local enemy = self:GetEnemy()			
				if ( self:ANPlusInRange( enemy, 200 ) && ( ( enemy:IsNPC() && ( behToWatchFor[ enemy:GetCurrentSchedule() ] || actToWatchFor[ enemy:GetActivity() ] || ( IsValid(enemy:GetActiveWeapon()) && ANPlusNoMeleeWithThese[ enemy:GetActiveWeapon():GetHoldType() ] ) ) ) || ( enemy:IsPlayer() && ( IsValid(enemy:GetActiveWeapon()) && ANPlusNoMeleeWithThese[ enemy:GetActiveWeapon():GetHoldType() ] ) ) ) ) || ( self:ANPlusInRange( enemy, 1200 ) && enemy:IsPlayer() && IsValid(enemy:GetEyeTrace().Entity) && enemy:GetEyeTrace().Entity == self ) then
					self:FlipDanger( enemy:GetPos() )	
				end
			end
			
			local lookForDanger = ents.FindInSphere( self:GetPos(), 250 )
			for _, v in pairs( lookForDanger ) do
				if IsValid(v) && self:DangerStuff( v ) && ( IsValid(v:GetOwner()) && v:GetOwner() != self ) then
					self:FlipDanger( v:GetPos() )						
				end
			end
			
		end, 		 
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )	
			if (SERVER) && ent:GetClass() == "npc_grenade_frag" then

				local flashB = ents.Create( "sent_anp_ass_flasb" )	
				flashB:ANPlusSetToBonePosAndAng( self, "ValveBiped.Bip01_L_Hand", nil, Angle( 0, 0, 0 ) )
				flashB:SetOwner( self )
				flashB:Spawn()
				flashB:Activate()		
				
				local phys1 = ent:GetPhysicsObject()
				local phys2 = flashB:GetPhysicsObject()
				
				phys2:SetVelocity( phys1:GetVelocity() )
				phys2:SetAngleVelocity( phys1:GetAngleVelocity() )

				ent:Remove()				
			end
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)		
			local event = select(1,...)
			
			if(event == "emit") then
				local type = select(2,...)
				local foot = { "left1", "left2", "right1", "right2" }
				self:EmitSound( "npc/stalker/stalker_footstep_" .. foot[ math.random( 1, 4 ) ] .. ".wav", 70, 95, 0.7, CHAN_BODY, 0, 0 )
				return true
			end		
			if(event == "mattack") then
				self:ANPlusDealMeleeDamage( 60, 20, DMG_SLASH, Angle( 10, 0, 0 ), Vector( 60, 0, 0 ), riotMeleeAngs, "npc/fast_zombie/claw_strike1.wav", "npc/fast_zombie/claw_miss1.wav" )
				return true
			end			
			if(event == "rattack") then
				local type = select(2,...)
				local curAtt = type == "right" && "RightMuzzle" || "LeftMuzzle"
				local att = self:GetAttachment(self:LookupAttachment( curAtt ) )			
				local fSpread = 0.02
				local bullet = {}			
					bullet.Num = 1
					bullet.Attacker = self
					bullet.Spread = Vector(fSpread,fSpread,fSpread)
					bullet.Tracer = 1
					bullet.Force = 3
					bullet.Damage = 3
					bullet.Callback = function(attacker, tr, dmginfo)
						local ent = tr.Entity
						if tr.Hit && IsValid(ent) && ( ent:IsNPC() || ent:IsPlayer() ) && !ent:ANPlusVisibleInFOV( self, nil, 90 ) then
							dmginfo:ScaleDamage( 4 )
							--ent:EmitSound("physics/metal/metal_barrel_impact_hard1.wav")
						end						
					end
				
				self:ANPlusFireBullet( bullet, true, att.Pos, 0, false, false, "ANP.WEAPON.AsssassinPistol.Fire", false, function()
					local fx = EffectData()
					fx:SetStart( att.Pos )
					fx:SetOrigin( att.Pos )
					fx:SetScale( 1 )
					fx:SetAngles( att.Ang )
					util.Effect( "MuzzleEffect", fx )
				end)			
				return true
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
			local att = dmginfo:GetAttacker()
			local inf = dmginfo:GetInflictor()
			local dangPos = IsValid(att) && !att:IsPlayer() && att:GetPos() || IsValid(inf) && !inf:IsPlayer() && inf:GetPos()
			self:FlipDanger( dangPos )
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
			if IsValid(self.beamEye) then self.beamEye:ANPlusRemoveSpotlight() end
			if IsValid(self.spriteEye) then self.spriteEye:Remove() end
		end,		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			if IsValid(self.beamEye) then self.beamEye:ANPlusRemoveSpotlight() end
			if IsValid(self.spriteEye) then self.spriteEye:Remove() end
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab )  

sound.Add( {
	name = "ANP.CombineZerker.Melee.Sharp", 
	channel = CHAN_WEAPON,
	volume = 0.95,
	level = SNDLVL_NORM,
	pitch = 70,
	sound = { "physics/metal/sawblade_stick1.wav", "physics/metal/sawblade_stick2.wav", "physics/metal/sawblade_stick3.wav" }
} )

sound.Add( {
	name = "ANP.CombineZerker.Melee.Blunt", 
	channel = CHAN_WEAPON,
	volume = 0.95,
	level = SNDLVL_NORM,
	pitch = 70,
	sound = { "npc/zombie/claw_strike1.wav", "npc/zombie/claw_strike2.wav", "npc/zombie/claw_strike3.wav" }
} )

sound.Add( {
	name = "ANP.CombineZerker.Melee.Miss", 
	channel = CHAN_WEAPON,
	volume = 0.95,
	level = SNDLVL_NORM,
	pitch = 90,
	sound = { "npc/zombie/claw_miss1.wav", "npc/zombie/claw_miss2.wav" }
} )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Zerker",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_stalker",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		---            
		{ "models/cup/npc/zerker.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = {
				[1] = "",
				[2] = "",
				[3] = "",
				[4] = "",
				[5] = "",
				[6] = "models/stalkerbeta/s_head(cyl)dull_zerker",
			}, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 120, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 230,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 3000, 
----------------------------------------------------------------- Set a distance at which your NPC will be able to hear things (doesn't literally set NPCs' hearing distance but rather affects ['OnNPCHearSound'] function).	
	['HearDistance'] 		= 3000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 524288 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 131072, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 500, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		 
		['Body'] 	 = 0, --%, 0 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.      
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 1500, 2000 }, 
----------------------------------------------------------------- List of NPC that your NPC should be friends with. NPCs listed here will also be friends with your NPC. You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Fear", 0 } },		
		['player'] = { ['MeToNPC'] = { "Hate", 0 } },		
		[9] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[10] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[13] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[14] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[15] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[16] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[17] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[20] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[23] = { ['MeToNPC'] = { "Neutral", 0 }, ['NPCToMe'] = { "Fear", 0 } },
		[25] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		["npc_breen"] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		["CLASS_COMBINE"] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
	
	},  
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = {
		[10]		= { 150, 320 }, 
	},
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
		['OverPitch'] 			= nil, -- Pitch override for realistic random voices.
		['SoundList'] 			= {
			[1] = { "npc/stalker/breathing", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[2] = { "npc/stalker/go_alert", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = 60, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[3] = { "npc/stalker/stalker_alert", ['Play'] = false, ['SoundLevel'] = nil, ['Pitch'] = { 50, 60 }, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = 0, ['Replacement'] = nil }, 
			[4] = { "npc/stalker/stalker_ambient", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = { 60, 70 }, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/stalker/stalker_alert1b.wav", "npc/stalker/stalker_alert2b.wav", "npc/stalker/stalker_alert3b.wav", "npc/zerker/stalker_ambient01.wav", "npc/stalker/breathing3.wav" } },
			[5] = { "npc/stalker/stalker_die", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = 60, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[6] = { "npc/stalker/stalker_pain", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = 60, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[7] = { "npc/stalker/stalker_scream", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = 80, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[8] = { "npc/stalker/stalker_footstep_left", ['Play'] = true, ['SoundLevel'] = 70, ['Pitch'] = { 58, 60 }, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "physics/metal/metal_canister_impact_hard1.wav", "physics/metal/metal_canister_impact_hard2.wav", "physics/metal/metal_canister_impact_hard3.wav" } },
			[9] = { "npc/stalker/stalker_footstep_right", ['Play'] = true, ['SoundLevel'] = 70, ['Pitch'] = { 58, 60 }, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "physics/metal/metal_canister_impact_hard1.wav", "physics/metal/metal_canister_impact_hard2.wav", "physics/metal/metal_canister_impact_hard3.wav" } },
		},
	},
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = {
		['Bip01 Pelvis'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1.2, 1.2, 1.2 ), jiggle = 0 },
		['Bip01 L Thigh'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 2.4, 2.4 ), jiggle = 0 },
		['Bip01 L Calf'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 2.2, 2.2 ), jiggle = 0 },
		['Bip01 L Foot'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 2.3, 2.3, 2.3 ), jiggle = 0 },
		['Bip01 R Thigh'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 2.4, 2.4 ), jiggle = 0 },
		['Bip01 R Calf'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 2.2, 2.2 ), jiggle = 0 },
		['Bip01 R Foot'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 2.3, 2.3, 2.3 ), jiggle = 0 },
		['Bip01 Spine'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1, 1.1, 1.1 ), jiggle = 0 },
		['Bip01 Spine1'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 2, 2, 2 ), jiggle = 0 },
		['Bip01 Spine2'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 0.6, 1.5, 0.8 ), jiggle = 0 },
		['Bip01 Spine3'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1.15, 1.5, 1.7 ), jiggle = 0 },
		['Bip01 Neck'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1.5, 1.5, 1.5 ), jiggle = 0 },
		['Bip01 Head'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 1.1, 1.1, 1.1 ), jiggle = 0 },
		['Bip01 L Clavicle'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 0.6, 1.5, 1.5 ), jiggle = 0 },
		['Bip01 L UpperArm'] = { ang = Angle( -10, 0, 0 ), pos = Vector( 2.2, 0, 0 ), scl = Vector( 1, 3.3, 3.3 ), jiggle = 0 },
		['Bip01 L Forearm'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 2.0, 2.0, 2.0 ), jiggle = 0 },
		['Bip01 R Clavicle'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 0.6, 1.5, 1.5 ), jiggle = 0 },
		['Bip01 R UpperArm'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 2.2, 0, 0 ), scl = Vector( 1, 3.3, 3.3 ), jiggle = 0 },
		['Bip01 R Forearm'] = { ang = Angle( 0, 0, 0 ), pos = Vector( 0, 0, 0 ), scl = Vector( 2.7, 2.7, 2.7 ), jiggle = 1 },
	},
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.        
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
			self:SetSaveValue( "m_iPlayerAggression", 1 )
			self.m_fupdateRunLast = 0
			self.m_fupdateRunDelay = 0.3
			
			self.spriteEye = ANPlusCreateSprite( "sprites/glow01.spr", Color( 232, 85, 50 ), 0.1, 1, { rendermode = 5 } )
			self.spriteEye:ANPlusParentToBone( self, "Bip01 Head", Vector( 2, 2, 0 ), Angle( -90, 0, 0 ) )
			self:DeleteOnRemove( self.spriteEye )
			
			self.beamEye = ANPlusCreateSpotlight( Color( 232, 85, 50, 255 ), 30, 50, 1 )
			self.beamEye:ANPlusParentToBone( self, "Bip01 Head", Vector( 2, 2, 0 ), Angle( -90, 0, 0 ) )
			self:ANPlusAddAnimationEvent("attack1", 5, 1)
			self:ANPlusAddAnimationEvent("attack2", 5, 1)
			self:ANPlusAddAnimationEvent("attack3", 5, 1)
			
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end       
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			
			if IsValid(self:GetEnemy()) && self:GetEnemy():ANPlusAlive() then 
				
				local enemy = self:GetEnemy()

				if self:Visible( enemy ) then

					if !self.m_balerted then 
						self:EmitSound( "npc/stalker/go_alert2a.wav", 75, 70, 1, CHAN_AUTO, 0, 0 )
						self:ANPlusPlayActivity( self:ANPlusTranslateSequence( "work" ), 1, enemy, 4 )
						self:ANPlusGetSquadMembers( function(npc)
							if ANPlusSameType( self, npc ) then
								npc.anp_alerted = true 
							end
						end)
						self.m_balerted = true 
					end
					
					local seqBL = {
						['attack1'] = true,
						['attack2'] = true,
						['attack3'] = true,
						['work'] = true,
					}
					--self:GetCurrentSchedule() != SCHED_FORCED_GO_RUN
					if CurTime() - self.m_fupdateRunLast >= self.m_fupdateRunDelay && !self:ANPlusInRange( enemy, 70 ) && enemy:OnGround() && !seqBL[ self:GetSequenceName( self:GetSequence() ) ] then					
						self:NavSetGoalTarget( enemy, Vector( 0, 0, 0 ) )
						self:SetLastPosition( enemy:GetPos() )
						self:SetSchedule( SCHED_FORCED_GO_RUN ) 
						self.m_fupdateRunLast = CurTime()
					end					
				
					self:ANPlusMeleeAct( enemy, self:ANPlusTranslateSequence( "attack1" ), 1, 2, 70, riotMeleeAngs, nil ) -- I spent 4 f*** hours to make it work just to learn that his attack animations have working damage events. I want to die.
						
				end
			else
				self.m_balerted = false
			end
			
		end,
		------------------------------------------------------------ OnNPCHandleAnimationEvent - This function can utilize lua animation events. You can set what happens at specified animation frame. Originaly created by Silverlan.
		['OnNPCHandleAnimationEvent'] = function(self, seq, ev)
			if ( ( seq == "attack1" || seq == "attack2" || seq == "attack3" ) && ev == 1 && !self.m_bAttackMomentum ) then
				self:SetVelocity( self:GetForward() * 1000 + self:GetUp() * 50 )
				self.m_bAttackMomentum = true
			else
				self.m_bAttackMomentum = false
			end
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			local attacker = dmginfo:GetAttacker()
			if IsValid(attacker) && !IsValid(self:GetEnemy()) then
				self:SetEnemy( attacker )
				self:UpdateEnemyMemory( attacker, attacker:GetPos() )
			end
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
			if IsValid(self.beamEye) then self.beamEye:Fire("KillHierarchy") end
			if IsValid(self.spriteEye) then self.spriteEye:Remove() end
		end,	
		------------------------------------------------------------ OnNPCHearSound - This function runs whenever NPC hears any sounds (no scripted sequences and affected by ['HearDistance']).
		['OnNPCHearSound'] = function(self, ent, dist, data)
			if !IsValid(self:GetEnemy()) && self:Disposition( ent ) != D_LI && self:Disposition( ent ) != D_NU then
				if !self:Visible( ent ) then	
					if data.Channel == 1 || ( data.Channel == 2 && dist < self:ANPlusGetHearDistance() * 0.6 ) then
						if !self:IsCurrentSchedule( SCHED_FORCED_GO_RUN ) then
							--self:NavSetGoalTarget( ent, Vector( 0, 0, 0 ) )
							self:SetLastPosition( ent:GetPos() )
							self:SetSchedule( SCHED_FORCED_GO_RUN )
						end
					elseif ( data.Channel == 4 || data.Channel == 0 ) && dist < self:ANPlusGetHearDistance() * 0.3 then
						if !self:IsCurrentSchedule( SCHED_FORCED_GO ) then
							--self:NavSetGoalTarget( ent, Vector( 0, 0, 0 ) )
							self:SetLastPosition( ent:GetPos() )
							self:SetSchedule( SCHED_FORCED_GO ) 
						end
					end
				elseif self:Visible(ent) && ( self:IsCurrentSchedule( SCHED_FORCED_GO ) || self:IsCurrentSchedule( SCHED_FORCED_GO_RUN ) ) then
					self:ClearSchedule() 
				end	
			end
		end,
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data)
		end,
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			if IsValid(self.beamEye) then self.beamEye:Fire("KillHierarchy") end
			if IsValid(self.spriteEye) then self.spriteEye:Remove() end
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Grenadier",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_combine_s",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/cup/npc/grenadier.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = {
				[1] = "",
				[2] = "",
				[3] = "models/combinepilot/combinesoldiersheet_gren",
			}, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = nil,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
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
	['Health'] 				= 90,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health, the second variable sets if NPC should regenerate health only when out of combat, the third variable represents the delay between health gains, the fourth variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { Numgrenades = 3, Tacticalvariant = 3, SquadName = "overwatch" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "swep_cup_ion_launcher" },
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= true,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 4500, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['swep_cup_ion_launcher'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = 4500, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 100 is default.
----------------------------------------------------------------- Increase or decrease NPC's self damage. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageSelfScale'] 	= -80, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. 1:1 damage. Melee weapons and fall damage typically hit this hit group. This hit group is not present on default player models.
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		[DMG_BLAST] 	= -50, --%, 0 is default.  
		[DMG_DISSOLVE] 	= -30, --%, 0 is default.  
		
	},
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 100, 200, 400, 800 }, 
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
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

	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self:SetSaveValue( "m_nKickDamage", 10 )		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			if self:Disposition( activator ) != D_LI then return end
		
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
		end, 		
		------------------------------------------------------------ OnNPCHandleAnimationEvent - This function can utilize lua animation events. You can set what happens at specified animation frame. Originaly created by Silverlan.
		['OnNPCHandleAnimationEvent'] = function(self, seq, ev)
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )			
			if (SERVER) && ent:GetClass() == "npc_grenade_frag" then
				for i = 1, 1 do
					local flashB = ents.Create( "grenade_helicopter" )	
					flashB:SetModelScale( 0.2 )
					flashB:ANPlusSetToBonePosAndAng( self, "ValveBiped.Bip01_R_Hand", nil, Angle( 0, 0, 0 ) )
					flashB:SetOwner( self )
					flashB:Spawn()
					flashB:Activate()	
					flashB:StopSound("npc/attack_helicopter/aheli_mine_captured_loop1.wav")	
					flashB:StopSound("npc/attack_helicopter/aheli_mine_seek_loop1.wav")	
					flashB:Fire( "ExplodeIn", nil, 4 )	
					util.SpriteTrail( flashB, 0, Color( 200, 47, 52 ), false, 3, 0, 0.5, 1 / ( 10 + 0 ) * 0.5, "effects/anp/generic_trail" )
					local phys1 = ent:GetPhysicsObject()
					local phys2 = flashB:GetPhysicsObject()
					
					phys2:SetVelocity( phys1:GetVelocity() + VectorRand() * 50 )
					phys2:SetAngleVelocity( phys1:GetAngleVelocity() + VectorRand() * 50 )
				end
				ent:Remove()				
			end
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
		end,		
		},	
	}  
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

sound.Add( {
	name = "ANP.CHeavyTurret.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 80,
	pitch = 80,
	sound = "npc/proto_turret/shoot5.wav"
} )

sound.Add( {
	name = "ANP.CHeavyTurret.Jam",
	channel = CHAN_BODY,
	volume = 0.8,
	level = 80,
	pitch = 80,
	sound = { "physics/metal/metal_computer_impact_bullet1.wav" }
} )

sound.Add( {
	name = "ANP.CHeavyTurret.SevereDamage",
	channel = CHAN_BODY,
	volume = 1,
	level = 80,
	pitch = 130,
	sound = { "ambient/energy/zap1.wav", "ambient/energy/zap2.wav", "ambient/energy/zap3.wav", "ambient/energy/zap5.wav", "ambient/energy/zap6.wav", "ambient/energy/zap7.wav", "ambient/energy/zap8.wav", "ambient/energy/zap9.wav" }
} )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Heavy Turret",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_turret_floor",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = { 
		---            
		{ "models/cup/proto_turret/floor_turret.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = -1,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= false,
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -20.977320, -16.000000, -0.368380 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 24.140255, 16.000000, 64.000000 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= false,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']				= Angle( 0, -180, 0 ),
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 170,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= false, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 32, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 8000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= nil, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= false,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 20, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		 
		[DMG_POISON] 	 = -90,
		[DMG_NERVEGAS] 	 = -100,
		[DMG_PARALYZE] 	 = -100,
		
	}, 
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
	},
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 	= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
		['OverPitch'] 			= nil, -- Pitch override for realistic random voices.
		['SoundList'] 			= {
			[1] = { "npc/turret_floor/active", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/active.wav" },
			[2] = { "npc/turret_floor/alarm", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/alarm.wav" },
			[3] = { "npc/turret_floor/alert", ['Play'] = false, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/alert.wav" }, 
			[4] = { "npc/turret_floor/click1", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/click1.wav" },
			[5] = { "npc/turret_floor/deploy", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/deploy.wav" },
			[6] = { "npc/turret_floor/die", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/die.wav" },
			[7] = { "npc/turret_floor/ping", ['Play'] = true, ['SoundLevel'] = 70, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 1, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/ping.wav" },
			[8] = { "npc/turret_floor/retract", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/proto_turret/retract.wav" },
			[9] = { "npc/turret_floor/shoot", ['Play'] = false, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = 0, ['Replacement'] = nil }--{ "npc/proto_turret/shoot1.wav", "npc/proto_turret/shoot2.wav", "npc/proto_turret/shoot3.wav" } },
		},
	},
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
			if IsValid(self:GetInternalVariable( "m_hEyeGlow" )) then self:GetInternalVariable( "m_hEyeGlow" ):SetColor( Color( 0, 0, 0, 0 ) ) end
			if IsValid(self:GetInternalVariable( "m_hLaser" )) then self:GetInternalVariable( "m_hLaser" ):Fire( "KillHierarchy", nil, 0 ) end			
			self.m_fFireDelay = 0.3
			self.m_vecSpread = Vector( 0.01, 0.01, 0 )
			self.m_fJamLast = 0
			self.m_fJamDelay = 1
			self.m_fDamageThreshold = 0.2
			self.m_fMaxAmmo = -1 -- If set to a value higher than 0 after spawning, it will set the max ammo for the turret. If turret goes down to 0 it will explode.
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)

			if self:Health() <= self:GetMaxHealth() * self.m_fDamageThreshold && !self.m_bSeverelyDamaged then
				self.m_vecSpread = Vector( 0.05, 0.05, 0 )				 
				self.m_fFireDelay = 0.4
				self:EmitSound( "ANP.CHeavyTurret.SevereDamage" )
				self.dmgSmoke = ANPlusCreateParticle( "Skybox_Smoke_01" )
				self.dmgSmoke:ANPlusParentToBone( self, "Gun", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
				local pos, ang = self:ANPlusGetBonePosAndAng( "Gun" )
				local fx = EffectData()
					fx:SetStart( pos )
					fx:SetOrigin( pos )
					fx:SetScale( 1 )
					fx:SetAngles( ang )
				util.Effect( "cball_explode", fx )
				self.m_bSeverelyDamaged = true
			end
			--[[
			if IsValid(self:GetEnemy()) && self:GetEnemy():ANPlusAlive() then 
				
				local enemy = self:GetEnemy()

			end
			]]--
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, wep, data) -- SHARED ( CLIENT & SERVER )	
			local target = nil
			local aimPos = nil
			local src, dir = nil
			if IsValid(self:GetEnemy()) || IsValid(self:GetTarget()) then
				local att = self:GetAttachment( 1 )
				target = self:GetEnemy() || self:GetTarget()
				aimPos = target:ANPlusGetHitGroupBone( 1 ) || target:ANPlusGetHitGroupBone( 2 ) || target:ANPlusGetHitGroupBone( 3 ) || target:ANPlusGetHitGroupBone( 4 ) || target:ANPlusGetHitGroupBone( 5 ) || target:ANPlusGetHitGroupBone( 6 ) || target:ANPlusGetHitGroupBone( 7 )
				src, dir = self:ANPlusNPCGetImprovedAiming( att.Pos, target, aimPos )
			end
			self:EmitSound( "ANP.CHeavyTurret.Fire" )
			data.Src = src || data.Src
			data.Dir = dir || data.Dir
			data.TracerName = "AirboatGunHeavyTracer"
			data.Spread = self.m_vecSpread
			data.Callback = function(attacker, tr, dmg)		
				if tr && tr.Hit then 			
					local hitPos = tr.HitPos
					local hitPosN = tr.HitNormal	
					dmg:SetDamageType( bit.bor( DMG_BULLET, DMG_BLAST, DMG_AIRBOAT ) )	
					local dmgb = DamageInfo()
						dmgb:SetDamageType( bit.bor( DMG_BLAST, DMG_AIRBOAT ) )
						dmgb:SetDamage( 8 )
						dmgb:SetAttacker( self )
						dmgb:SetInflictor( self )
					util.BlastDamageInfo( dmgb, hitPos, 80 )							
					local fx = EffectData()
						fx:SetStart( hitPos )
						fx:SetOrigin( hitPos )
						fx:SetScale( 1 )
						fx:SetAngles( hitPosN:Angle() )
					util.Effect( "cball_bounce", fx )				
					sound.Play( "ambient/energy/newspark05.wav", hitPos, 70, 70 )
				end
			end
			if self.m_fMaxAmmo > -1 then self.m_fMaxAmmo = self.m_fMaxAmmo - 1 end
			if self.m_fMaxAmmo == 0 then self:Fire( "SelfDestruct", nil, 0 ) end
			local jamChance = math.random( 1, 10 )
			if self.m_bSeverelyDamaged && jamChance == 5 && self.m_fJamLast < CurTime() then
				local pos, ang = self:ANPlusGetBonePosAndAng( "Gun" )
				local fx = EffectData()
					fx:SetStart( pos )
					fx:SetOrigin( pos )
					fx:SetScale( 1 )
					fx:SetAngles( ang )
				util.Effect( "cball_bounce", fx )
				local jamTime = math.random( 1, 3 )
				self:Fire( "DepleteAmmo", nil, 0 )
				self:Fire( "RestoreAmmo", nil, jamTime )
				self.m_fJamLast = CurTime() + self.m_fJamDelay + jamTime	
			end		
			if (SERVER) then self:SetSaveValue( "m_flShotTime", self.m_fFireDelay ) end
			return true
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			self:ANPlusRemoveHealth( dmginfo:GetDamage(), 1 ) -- It should never reach 0, cuz then it breaks af.
			if self:Health() <= 1 && !self:GetInternalVariable( "m_bSelfDestructing" ) then
				self:Fire( "SelfDestruct", nil, 0 )
			end
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,	
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data)
		end,
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			if IsValid(self) && self.m_fMaxAmmo > 0 && self:GetInternalVariable( "m_bSelfDestructing" ) then
				local dmgb = DamageInfo()
					dmgb:SetDamageType( bit.bor( DMG_BLAST ) )
					dmgb:SetDamage( 60 )
					dmgb:SetAttacker( self )
					dmgb:SetInflictor( self )
				util.BlastDamageInfo( dmgb, self:GetPos(), 120 )
			end
		end,		
		},	
	}
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Turret",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_turret_floor",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = { 
		---            
		{ "", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = -1,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= false,
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -20.977320, -16.000000, -0.368380 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 24.140255, 16.000000, 64.000000 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= false,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']				= Angle( 0, -180, 0 ),
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 100,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= false, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 32, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 8000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= nil, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= false,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= -10, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		 
		[DMG_POISON] 	 = -90,
		[DMG_NERVEGAS] 	 = -100,
		[DMG_PARALYZE] 	 = -100,
		
	},
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
	},
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 	= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self.m_fFireDelay = 0.1
			self.m_vecSpread = Vector( 0.025, 0.025, 0 )
			self.m_fJamLast = 0
			self.m_fJamDelay = 1
			self.m_fDamageThreshold = 0.3
			self.m_fMaxAmmo = -1
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			if self:Health() <= self:GetMaxHealth() * self.m_fDamageThreshold && !self.m_bSeverelyDamaged then
				self.m_vecSpread = Vector( 0.05, 0.05, 0 )				 
				self.m_fFireDelay = 0.25
				self:EmitSound( "ANP.CHeavyTurret.SevereDamage" )
				self.dmgSmoke = ANPlusCreateParticle( "striderbuster_smoke" )
				self.dmgSmoke:ANPlusParentToBone( self, "Gun", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
				local pos, ang = self:ANPlusGetBonePosAndAng( "Gun" )
				local fx = EffectData()
					fx:SetStart( pos )
					fx:SetOrigin( pos )
					fx:SetScale( 1 )
					fx:SetAngles( ang )
				util.Effect( "cball_explode", fx )
				self.m_bSeverelyDamaged = true
			end
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, wep, data) -- SHARED ( CLIENT & SERVER )	
			local target = nil
			local aimPos = nil
			local src, dir = nil
			if IsValid(self:GetEnemy()) || IsValid(self:GetTarget()) then
				local att = self:GetAttachment( 1 )
				target = self:GetEnemy() || self:GetTarget()
				aimPos = target:ANPlusGetHitGroupBone( 1 ) || target:ANPlusGetHitGroupBone( 2 ) || target:ANPlusGetHitGroupBone( 3 ) || target:ANPlusGetHitGroupBone( 4 ) || target:ANPlusGetHitGroupBone( 5 ) || target:ANPlusGetHitGroupBone( 6 ) || target:ANPlusGetHitGroupBone( 7 )
				src, dir = self:ANPlusNPCGetImprovedAiming( att.Pos, target, aimPos )
			end
			data.Src = src || data.Src
			data.Dir = dir || data.Dir
			data.Spread = self.m_vecSpread
			if self.m_fMaxAmmo > -1 then self.m_fMaxAmmo = self.m_fMaxAmmo - 1 end
			if self.m_fMaxAmmo == 0 then self:Fire( "SelfDestruct", nil, 0 ) end
			local jamChance = math.random( 1, 10 )
			if self.m_bSeverelyDamaged && jamChance == 5 && self.m_fJamLast < CurTime() then
				local pos, ang = self:ANPlusGetBonePosAndAng( "Gun" )
				local fx = EffectData()
					fx:SetStart( pos )
					fx:SetOrigin( pos )
					fx:SetScale( 1 )
					fx:SetAngles( ang )
				util.Effect( "cball_bounce", fx )
				local jamTime = math.random( 1, 3 )
				self:Fire( "DepleteAmmo", nil, 0 )
				self:Fire( "RestoreAmmo", nil, jamTime )
				self:EmitSound( "ANP.CHeavyTurret.Jam" )
				self.m_fJamLast = CurTime() + self.m_fJamDelay + jamTime	
			end		
			if (SERVER) then self:SetSaveValue( "m_flShotTime", self.m_fFireDelay ) end
			return true
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			self:ANPlusRemoveHealth( dmginfo:GetDamage(), 1 ) -- It should never reach 0, cuz then it breaks af.
			if self:Health() <= 1 && !self:GetInternalVariable( "m_bSelfDestructing" ) then
				self:Fire( "SelfDestruct", nil, 0 )
			end
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,	
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data)
		end,
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			if IsValid(self) && self.m_fMaxAmmo > 0 && self:GetInternalVariable( "m_bSelfDestructing" ) then
				local dmgb = DamageInfo()
					dmgb:SetDamageType( bit.bor( DMG_BLAST ) )
					dmgb:SetDamage( 35 )
					dmgb:SetAttacker( self )
					dmgb:SetInflictor( self )
				util.BlastDamageInfo( dmgb, self:GetPos(), 100 )
			end
		end,		
		},	
	}
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

sound.Add( {
	name = "ANP.ShotgunTurret.Fire",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 80,
	pitch = 70,
	sound = "weapons/ar2/fire1.wav"
} )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Shotgun Turret",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_turret_floor",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = { 
		---            
		{ "", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
				[1] = "models/floor_turret/combine_gun_sg",
			},
			['Color']		 = Color( 255, 200, 200, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = -1,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= false,
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -20.977320, -16.000000, -0.368380 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 24.140255, 16.000000, 64.000000 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= false,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']				= Angle( 0, -180, 0 ),
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 100,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= false, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 32, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 8000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= nil, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= false,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= -30, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		 
		[DMG_POISON] 	 = -90,
		[DMG_NERVEGAS] 	 = -100,
		[DMG_PARALYZE] 	 = -100,
		
	}, 
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
		['player'] = { ['MeToNPC'] = { "Default", 0 } }, -- Like/Hate/Fear/Neutral/Default(no change)
	
	},
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 	= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
		['OverPitch'] 			= nil, -- Pitch override for realistic random voices.
		['SoundList'] 			= {
			[1] = { "npc/turret_floor/shoot", ['Play'] = false, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
		},
	},
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self.m_fFireDelay = 0.8
			self.m_vecSpread = Vector( 0.05, 0.05, 0 )
			self.m_fJamLast = 0
			self.m_fJamDelay = 1
			self.m_fDamageThreshold = 0.3
			self.m_fMaxAmmo = -1
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			if self:Health() <= self:GetMaxHealth() * self.m_fDamageThreshold && !self.m_bSeverelyDamaged then
				self.m_vecSpread = Vector( 0.07, 0.07, 0 )				 
				self.m_fFireDelay = 1.2
				self:EmitSound( "ANP.CHeavyTurret.SevereDamage" )
				self.dmgSmoke = ANPlusCreateParticle( "striderbuster_smoke" )
				self.dmgSmoke:ANPlusParentToBone( self, "Gun", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
				local pos, ang = self:ANPlusGetBonePosAndAng( "Gun" )
				local fx = EffectData()
					fx:SetStart( pos )
					fx:SetOrigin( pos )
					fx:SetScale( 1 )
					fx:SetAngles( ang )
				util.Effect( "cball_explode", fx )
				self.m_bSeverelyDamaged = true
			end
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )					
		end,
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, wep, data) -- SHARED ( CLIENT & SERVER )	
			local target = nil
			local aimPos = nil
			local src, dir = nil
			if IsValid(self:GetEnemy()) || IsValid(self:GetTarget()) then
				local att = self:GetAttachment( 1 )
				target = self:GetEnemy() || self:GetTarget()
				aimPos = target:ANPlusGetHitGroupBone( 1 ) || target:ANPlusGetHitGroupBone( 2 ) || target:ANPlusGetHitGroupBone( 3 ) || target:ANPlusGetHitGroupBone( 4 ) || target:ANPlusGetHitGroupBone( 5 ) || target:ANPlusGetHitGroupBone( 6 ) || target:ANPlusGetHitGroupBone( 7 )
				src, dir = self:ANPlusNPCGetImprovedAiming( att.Pos, target, aimPos )
			end
			self:EmitSound( "ANP.ShotgunTurret.Fire" )
			data.Src = src || data.Src
			data.Dir = dir || data.Dir
			data.Num = 7 
			data.Spread = self.m_vecSpread
			if self.m_fMaxAmmo > -1 then self.m_fMaxAmmo = self.m_fMaxAmmo - 1 end
			if self.m_fMaxAmmo == 0 then self:Fire( "SelfDestruct", nil, 0 ) end
			local jamChance = math.random( 1, 6 )
			if self.m_bSeverelyDamaged && jamChance == 3 && self.m_fJamLast < CurTime() then
				local pos, ang = self:ANPlusGetBonePosAndAng( "Gun" )
				local fx = EffectData()
					fx:SetStart( pos )
					fx:SetOrigin( pos )
					fx:SetScale( 1 )
					fx:SetAngles( ang )
				util.Effect( "cball_bounce", fx )
				local jamTime = math.random( 2, 4 )
				self:Fire( "DepleteAmmo", nil, 0 )
				self:Fire( "RestoreAmmo", nil, jamTime )
				self:EmitSound( "ANP.CHeavyTurret.Jam" )
				self.m_fJamLast = CurTime() + self.m_fJamDelay + jamTime	
			end		
			if (SERVER) then self:SetSaveValue( "m_flShotTime", self.m_fFireDelay ) end
			if (SERVER) then self:SetSaveValue( "m_flThrashTime", 0 ) end
			return true
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			self:ANPlusRemoveHealth( dmginfo:GetDamage(), 1 ) -- It should never reach 0, cuz then it breaks af.
			if self:Health() <= 1 && !self:GetInternalVariable( "m_bSelfDestructing" ) then
				self:Fire( "SelfDestruct", nil, 0 )
			end
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,	
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data)
		end,
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			if IsValid(self) && self.m_fMaxAmmo > 0 && self:GetInternalVariable( "m_bSelfDestructing" ) then
				local dmgb = DamageInfo()
					dmgb:SetDamageType( bit.bor( DMG_BLAST ) )
					dmgb:SetDamage( 35 )
					dmgb:SetAttacker( self )
					dmgb:SetInflictor( self )
				util.BlastDamageInfo( dmgb, self:GetPos(), 100 )
			end
		end,		
		},	
	}
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

sound.Add( {
	name = "ANP.Combot.GasAttack",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = 80,
	pitch = 150,
	sound = "ambient/gas/cannister_loop.wav"
} )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combot",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_cscanner",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = { 
		---            
		{ "models/cup/npc/combot.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil,
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = -1,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= false,
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -8, -8, -4 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 8, 8, 4 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 6,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= false,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']				= false,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 60,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= false, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= false, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 	= {
		{ "SetFlightSpeed", "1500", 0.5 },
		{ "SetDistanceOverride", "60", 0 },
	},   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 8000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= nil, -- Stop taking pictures you c***
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= false,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		 
		[DMG_POISON] 	 = -100,
		[DMG_NERVEGAS] 	 = -100,
		[DMG_PARALYZE] 	 = -100,
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 200, 400, 1500, 2000 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Fear", 0 } },		
		['player'] = { ['MeToNPC'] = { "Hate", 0 } },		
		[9] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[10] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[13] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[14] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[15] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[16] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[17] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[20] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[23] = { ['MeToNPC'] = { "Neutral", 0 }, ['NPCToMe'] = { "Fear", 0 } },
		[25] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		["npc_breen"] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		["CLASS_COMBINE"] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
	
	}, 
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 	= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {	
		['OverPitch'] 			= nil, -- Pitch override for realistic random voices.
		['SoundList'] 			= {
			[1] = {"npc/scanner/cbot_fly_loop.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = false, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_fly_loop.wav" },
			[2] = {"npc/scanner/scanner_alert.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_alert1.wav" },   
			[3] = {"npc/scanner/scanner_blip.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_mechanism1.wav" },
			[4] = {"npc/scanner/scanner_combat_loop.", ['Play'] = true, ['SoundLevel'] = 1, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0.1, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[5] = {"npc/scanner/scanner_explode_crash.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_energyexplosion1.wav" },
			[6] = {"npc/scanner/scanner_scan1.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[7] = {"npc/scanner/scanner_scan2.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[8] = {"npc/scanner/scanner_scan4.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[9] = {"npc/scanner/scanner_scan5.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[10] = {"npc/scanner/scanner_scan_loop", ['Play'] = true, ['SoundLevel'] = 75, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_engine_loop1.wav", "npc/combot/cbot_engine_loop2.wav", "npc/combot/cbot_engine_loop3.wav" } }, 
			[11] = {"npc/scanner/scanner_siren.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_servocurious.wav" }, 
			[12] = {"npc/scanner/scanner_talk.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[13] = {"npc/scanner/cbot_servochatter.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_servochatter.wav", "npc/combot/cbot_servochatter1.wav", "npc/combot/cbot_servochatter2.wav", "npc/combot/cbot_servochatter3.wav" } }, 
			[14] = {"npc/scanner/cbot_servoscared.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_servoscared.wav" }, 
			[15] = {"npc/scanner/cbot_energyexplosion.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_energyexplosion1.wav" }, 
		},		
	}, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self.spriteEye = ANPlusCreateSprite( "sprites/animglow01.vmt", Color( 232, 85, 50 ), 0.1, 1, { rendermode = 5 } )
			self.spriteEye:ANPlusParent( self, "eyes" )
			self:DeleteOnRemove( self.spriteEye )
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			
			if IsValid(self:GetEnemy()) && self:GetEnemy():ANPlusAlive() then 				
				local enemy = self:GetEnemy()
				self:ANPlusMeleeAct( enemy, self:ANPlusTranslateSequence( "retract" ), 1, -1, 220, riotMeleeAngs, nil, function(seqID, seqDur) -- Custom cooldown added as spamming this act tends to break its ai?
					if !IsValid(self.exhaust) then
						self.exhaust = ANPlusCreateParticle( "steam_jet_80" )
						self.exhaust:ANPlusParent( self, nil, Vector( 5, 0, -10 ), Angle( 20, 0, 0 ) )		
						self:EmitSound( "ANP.Combot.GasAttack" )
					end		
					local tr = util.TraceEntity( {
						start = self:GetPos(),
						endpos = self:GetPos() + self:GetForward() * 80 + self:GetUp() * -40,
						filter = { self },
						ignoreworld = false,
						mask = MASK_SHOT_HULL
						}, 
						self 		
					)				
					local dmgPos = tr.HitPos || self:GetPos()
					timer.Create( "ANPlus_CombotAttackDMG" .. self:EntIndex(), 0.2, 0, function() 
						if !IsValid(self) || !IsValid(self.exhaust) then return end
						--local dmgb = DamageInfo()
						--	dmgb:SetDamageType( bit.bor( DMG_POISON ) )
						--	dmgb:SetDamage( 8 )
						--	dmgb:SetAttacker( self )
						--	dmgb:SetInflictor( self )
						--util.BlastDamageInfo( dmgb, dmgPos, 80 )					
						local dir = ( self:GetForward() - Vector( 0, 0, 0.5 ) ):GetNormalized()
						local pos = self:ANPlusGetBonePosAndAng( "Scanner.Body", Vector( 5, 0, 0 ), nil )
						for k, v in ipairs( ents.FindInCone( pos, dir, 150, 0.850 ) ) do
							if IsValid(v) && ( v:IsPlayer() || v:IsNPC() ) && self:Disposition( v ) != D_LI then
								local dmgb = DamageInfo()
									dmgb:SetDamageType( bit.bor( DMG_POISON ) )
									dmgb:SetDamage( 3 )
									dmgb:SetAttacker( self )
									dmgb:SetInflictor( self )
								self:ANPlusDealDamage( v, dmgb, 0, nil)
							end
						end
					end)
					timer.Create( "ANPlus_CombotEndAttack" .. self:EntIndex(), seqDur + 0.1, 1, function()
						if !IsValid(self) then return end
						if IsValid(self.exhaust) then self.exhaust:Remove() end
						self:StopSound( "ANP.Combot.GasAttack" )						
					end)					
				end) 	
			end			
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )			
			if (SERVER) then
				if ent:GetClass() == "beam" then
					ent:SetColor( Color( 232, 120, 50 ) )
				end
			end
		end,
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, wep, data) -- SHARED ( CLIENT & SERVER )	
			return true
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			local attacker = dmginfo:GetAttacker()
			--if self:Health() <= 0 then self:SetSaveValue( "m_bIsClawScanner", true ) end -- Dive attack breaks the NPC, dunno why.
			if IsValid(attacker) && attacker != self && ( attacker:IsNPC() || attacker:IsPlayer() ) && self:Disposition(attacker) != D_LI then
				if IsValid(self:GetEnemy()) && self:GetEnemy() != attacker then self:ClearEnemyMemory( self:GetEnemy() ) end					
				self:SetEnemy( attacker )
				self:UpdateEnemyMemory( attacker, attacker:GetPos() )
			end
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
			self:StopSound( "npc/combot/cbot_fly_loop.wav" )	
			self:StopSound( "npc/combot/cbot_engine_loop1.wav" )	
			self:StopSound( "npc/combot/cbot_engine_loop2.wav" )	
			self:StopSound( "npc/combot/cbot_engine_loop3.wav" )	
			self:StopSound( "ANP.Combot.GasAttack" )
			local lookForGibs = ents.FindInSphere( self:GetPos(), 80 )			
			for _, v in pairs( lookForGibs ) do		
				if IsValid(v) and v:GetClass() == "gib" then v:Remove() end			
			end	
			ParticleEffect( "grenade_explosion_01", self:GetPos(), self:GetAngles() )	
		end,		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,	
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data)
			--print(data.SoundName)
		end,
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			self:StopSound( "npc/combot/cbot_fly_loop.wav" )
			self:StopSound( "npc/combot/cbot_engine_loop1.wav" )	
			self:StopSound( "npc/combot/cbot_engine_loop2.wav" )	
			self:StopSound( "npc/combot/cbot_engine_loop3.wav" )
			self:StopSound( "ANP.Combot.GasAttack" )
		end,		
		},	
	}
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

sound.Add( {
	name = "ANP.WasteScanner.NadeFire",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = 80,
	pitch = { 95, 105 },
	sound = "npc/waste_scanner/grenade_fire.wav"
} )

sound.Add( {
	name = "ANP.WasteScanner.EnergyCharge",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = 80,
	pitch = { 95, 105 },
	sound = "npc/waste_scanner/altfire.wav"
} )

sound.Add( {
	name = "ANP.WasteScanner.EnergyFire",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = 80,
	pitch = { 95, 105 },
	sound = { "npc/waste_scanner/energy_fire1.wav", "npc/waste_scanner/energy_fire2.wav" }
} )

sound.Add( {
	name = "ANP.WasteScanner.EnergyExplode",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = 80,
	pitch = { 95, 105 },
	sound = { "npc/waste_scanner/energy_explode1.wav", "npc/waste_scanner/energy_explode2.wav" }
} )

local wScannerIdle = Color( 180, 255, 0, 255 )
local wScannerAler = Color( 233, 100, 0, 255 )
local attackAngs = {
	['Pitch'] 	= 70,
	['Yaw'] 	= 45,
	['Roll'] 	= 360,
}
local wsFlinchAnims = {
	['flinchfront'] = true,
	['flinchback'] = true,
	['flinchleft'] = true,
	['flinchright'] = true,
}

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Wasteland Scanner",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_cscanner",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = { 
		---            
		{ "models/cup/npc/wscanner_single.mdl", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil,
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= false,
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']	= {
	
		['Min']				= Vector( -8, -8, -4 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['Max']				= Vector( 8, 8, 4 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
		['HullType']		= 6,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL  
   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= false,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']				= false,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 60,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= false, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch", SpotlightDisabled = 1 }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= false, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 	= {
		{ "SetFlightSpeed", "1500", 0.5 },
		{ "SetDistanceOverride", "200", 0 },
	},   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 8000, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 524288, -- Stop taking pictures you c***
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= false,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= true,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 0 is default.
----------------------------------------------------------------- Increase or decrease NPC's self damage. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageSelfScale'] 	= -100, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		 
		[DMG_POISON] 	 = -100,
		[DMG_NERVEGAS] 	 = -100,
		[DMG_PARALYZE] 	 = -100,
		
	}, 
----------------------------------------------------------------- If set, NPC will be able to follow friendly Players when used. The first value sets the follow distance while out of combat and the second value when in combat.
	['CanFollowPlayers'] = { 200, 400, 1500, 2000 },
----------------------------------------------------------------- This table can be used to set NPC relations with other entities (also players). You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= {
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Fear", 0 } },		
		['player'] = { ['MeToNPC'] = { "Hate", 0 } },		
		[9] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[10] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[13] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[14] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[15] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[16] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[17] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[20] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		[23] = { ['MeToNPC'] = { "Neutral", 0 }, ['NPCToMe'] = { "Fear", 0 } },
		[25] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		["npc_breen"] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		["CLASS_COMBINE"] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
	
	}, 
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 	= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {	
		['OverPitch'] 			= nil, -- Pitch override for realistic random voices.
		['SoundList'] 			= {
			[1] = {"npc/scanner/cbot_fly_loop.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = false, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/waste_scanner/hover.wav" },
			[2] = {"npc/scanner/scanner_alert.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_alert1.wav" },   
			[3] = {"npc/scanner/scanner_blip.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_mechanism1.wav" },
			[4] = {"npc/scanner/scanner_combat_loop.", ['Play'] = true, ['SoundLevel'] = 1, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0.1, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = nil },
			[5] = {"npc/scanner/scanner_explode_crash.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = 0, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_energyexplosion1.wav" },
			[6] = {"npc/scanner/scanner_scan1.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[7] = {"npc/scanner/scanner_scan2.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[8] = {"npc/scanner/scanner_scan4.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[9] = {"npc/scanner/scanner_scan5.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[10] = {"npc/scanner/scanner_scan_loop", ['Play'] = true, ['SoundLevel'] = 75, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/waste_scanner/hover_alarm.wav" }, 
			[11] = {"npc/scanner/scanner_siren.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_servocurious.wav" }, 
			[12] = {"npc/scanner/scanner_talk.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_battletalk1.wav", "npc/combot/cbot_battletalk2.wav", "npc/combot/cbot_battletalk3.wav", "npc/combot/cbot_battletalk4.wav" } }, 
			[13] = {"npc/scanner/cbot_servochatter.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "npc/combot/cbot_servochatter.wav", "npc/combot/cbot_servochatter1.wav", "npc/combot/cbot_servochatter2.wav", "npc/combot/cbot_servochatter3.wav" } }, 
			[14] = {"npc/scanner/cbot_servoscared.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_servoscared.wav" }, 
			[15] = {"npc/scanner/cbot_energyexplosion.", ['Play'] = true, ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = "npc/combot/cbot_energyexplosion1.wav" }, 
		},		
	}, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)		
			self.spriteEye = ANPlusCreateSprite( "sprites/animglow01.vmt", Color( 180, 255, 0 ), 0.1, 1, { rendermode = 5 } )
			self.spriteEye:ANPlusParent( self, "0" )
			self:DeleteOnRemove( self.spriteEye )
			self.m_fFlinchLast = 0
			self.m_fFlinchDelay = 2
			self.m_fRangeAttack1Delay = 3
			self.m_fRangeAttack1DMG   = 30
			self.m_fRangeAttack1Rad   = 200
			self.m_fRangeAttack2Delay = 4
			local FLINCH_FORWARD = 1
			local FLINCH_RIGHT = 2
			local FLINCH_BACKWARD = 3
			local FLINCH_LEFT = 4

			local tbFlinchAct = { self:ANPlusTranslateSequence( "flinchfront" ), self:ANPlusTranslateSequence( "flinchleft" ), self:ANPlusTranslateSequence( "flinchback" ), self:ANPlusTranslateSequence( "flinchright" ) }
			
			function self:FlinchDanger(vecPos)
				if CurTime() - self.m_fFlinchLast < self.m_fFlinchDelay || !vecPos then return end				
				local sAng = self:GetAngles()
				local angDanger = ( vecPos - self:GetPos() ):Angle()
				local y = math.Round( math.NormalizeAngle( sAng.y - angDanger.y ) * 1000 ) / 1000
				--self:ANPlusGetAngleToPos( vecPos, ang ).y
				local flinch = 0
				if ( y <= 45 && y >= -45 ) then
					self:GetPhysicsObject():SetVelocity( self:GetForward() * -350 )
					flinch = FLINCH_BACKWARD
				elseif ( y <= 135 && y > 45 ) then
					self:GetPhysicsObject():SetVelocity( self:GetRight() * -350 )
					flinch = FLINCH_RIGHT
				elseif ( y >= -135 && y < -45 ) then
					self:GetPhysicsObject():SetVelocity( self:GetRight() * 350 )	
					flinch = FLINCH_LEFT
				else
					self:GetPhysicsObject():SetVelocity( self:GetForward() * 350 )
					flinch = FLINCH_FORWARD
				end
				self:ANPlusPlayActivity( tbFlinchAct[ flinch ], 1 )
				self.m_fFlinchLast = CurTime() 
			end
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)
			if IsValid(self:GetEnemy()) && self:GetEnemy():ANPlusAlive() then 
				local enemy = self:GetEnemy()
				
				if IsValid(self.spriteEye) && self.spriteEye:GetColor() != wScannerAler then self.spriteEye:SetColor( wScannerAler ) end
				
				if !wsFlinchAnims[ self:GetSequenceName( self:GetSequence() ) ] && self:ANPlusInRange( enemy, 512 ) then
				
					self:ANPlusRangeAct( enemy, self:ANPlusTranslateSequence( "rangeattack" ), 1, -1, 512, 200, attackAngs, self.m_fRangeAttack1Delay, function(seqID, seqDur) -- Custom cooldown added as spamming this act tends to break its ai?
						local att = self:LookupAttachment( "0" )
						local attTab = self:GetAttachment( att )
						local eneDist = ( enemy:GetPos() - self:GetPos() ):Length()
						local force = 250 * ( eneDist / 250 ) <= 400 && 300 * ( eneDist / 250 ) || 400
						self:ANPlusFireEntity( "grenade_ar2", false, attTab.Pos + self:GetForward() * 20, Angle( -30, 0, 0 ), 1, force, 0.3, 1, nil, nil, "ANP.WasteScanner.NadeFire", nil, function(ent)
							timer.Simple( 0, function()
								if !IsValid(ent) then return end
								ent:SetSaveValue( "m_flDamage", self.m_fRangeAttack1DMG )
								ent:SetSaveValue( "m_DmgRadius", self.m_fRangeAttack1Rad )
								ent:SetSaveValue( "m_takedamage", 0 )
								--[[
								ent.trail = ents.Create("env_rockettrail")
								ent.trail:SetPos( ent:GetPos() + ent:GetForward() * 0 )
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
								ent.trail:SetSaveValue( "m_SpawnRadius", 20 )
								ent.trail:SetSaveValue( "m_MinSpeed", 0 )
								ent.trail:SetSaveValue( "m_MaxSpeed", 16 )
								ent.trail:Spawn()
								]]--
							end)
						end,
						function()
							--ParticleEffectAttach( "weapon_muzzle_flash_assaultrifle", 4, self, att )
							ParticleEffect( "weapon_muzzle_flash_assaultrifle", attTab.Pos, attTab.Ang + Angle( 90, 0, 0 ), self )
						end)
					end) 					
				elseif !wsFlinchAnims[ self:GetSequenceName( self:GetSequence() ) ] && !self:ANPlusInRange( enemy, 512 ) then
					self:ANPlusRangeAct( enemy, self:ANPlusTranslateSequence( "flinchback" ), 0.4, -1, 1324, 512, attackAngs, self.m_fRangeAttack2Delay, function(seqID, seqDur) -- Custom cooldown added as spamming this act tends to break its ai?
						
						local att = self:LookupAttachment( "0" )					
						local partic = ANPlusCreateParticleSystem( "vortigaunt_hand_glow", nil, 1 )
						partic:ANPlusParent( self, att )
						local partic = ANPlusCreateParticleSystem( "striderbuster_break_lightning", nil, 1 )
						partic:ANPlusParent( self, att )
						
						self:EmitSound( "ANP.WasteScanner.EnergyCharge" )
						
						timer.Simple( 1, function()
							if !IsValid(self) then return end
							local attTab = self:GetAttachment( att )
							self:ANPlusFireEntity( "sent_cup_ws_proj", true, attTab.Pos, nil, 1, nil, 0, 1, nil, nil, "ANP.WasteScanner.EnergyFire", nil, function(ent)
								ent.Target = enemy
							end)
						end)						
					end)
				end
			else
				if IsValid(self.spriteEye) && self.spriteEye:GetColor() != wScannerIdle then self.spriteEye:SetColor( wScannerIdle ) end
			end			
		end, 	
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)		
		end,
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )			
		end,
		------------------------------------------------------------ OnNPCFireBullets - This function runs when NPC fires a bullet (best used with turrets). https://wiki.facepunch.com/gmod/GM:EntityFireBullets
		['OnNPCFireBullets'] = function(self, wep, data) -- SHARED ( CLIENT & SERVER )	
			return true
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			local attacker = dmginfo:GetAttacker()
			local inflictor = dmginfo:GetInflictor()
			--if self:Health() <= 0 then self:SetSaveValue( "m_bIsClawScanner", true ) end -- Dive attack breaks the NPC, dunno why.
			if IsValid(attacker) && attacker != self && ( attacker:IsNPC() || attacker:IsPlayer() ) && self:Disposition(attacker) != D_LI then
				if IsValid(self:GetEnemy()) && self:GetEnemy() != attacker then self:ClearEnemyMemory( self:GetEnemy() ) end					
				self:SetEnemy( attacker )
				self:UpdateEnemyMemory( attacker, attacker:GetPos() )
			end			
			local dangPos = IsValid(attacker) && attacker != self && attacker:GetPos() || IsValid(inflictor) && inflictor != self && inflictor:GetPos()
			self:FlinchDanger( dangPos )
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
			self:StopSound( "npc/waste_scanner/hover.wav" )	
			self:StopSound( "npc/waste_scanner/hover_alarm.wav" )	
			self:StopSound( "ANP.WasteScanner.EnergyCharge" )
			local lookForGibs = ents.FindInSphere( self:GetPos(), 80 )			
			for _, v in pairs( lookForGibs ) do		
				if IsValid(v) and v:GetClass() == "gib" then v:Remove() end			
			end	
			ParticleEffect( "grenade_explosion_01", self:GetPos(), self:GetAngles() )		
		end,		
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,	
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data)
			--print(data.SoundName)
		end,
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			self:StopSound( "npc/waste_scanner/hover.wav" )
			self:StopSound( "ANP.WasteScanner.EnergyCharge" )
			self:StopSound( "npc/waste_scanner/hover_alarm.wav" )	
		end,		
		},	
	}
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 

--[[
local apcGibs = {
	"models/cup/proto_apc/combine_apc_destroyed_gib02.mdl",
	"models/cup/proto_apc/combine_apc_destroyed_gib03.mdl",
	"models/cup/proto_apc/combine_apc_destroyed_gib04.mdl",
}

sound.Add( {
	name = "ANP.ProtoAPC.EngineStart", 
	channel = CHAN_AUTO,
	volume = 0.95,
	level = SNDLVL_NORM,
	pitch = 90,
	sound = "vehicles/proto_apc/apc_start_loop3.wav"
} )

sound.Add( {
	name = "ANP.ProtoAPC.EngineLoop", 
	channel = CHAN_AUTO,
	volume = 0.95,
	level = SNDLVL_NORM,
	pitch = 90,
	sound = "vehicles/proto_apc/apc_idle1.wav"
} )

local NPCTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Combine Units +PLUS+",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[CUP] Combine Proto APC",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "prop_vehicle_apc",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		---            
		{ "", 
			['BodyGroups'] 	 = nil, -- Table with body groups that you wish to change. 
			['Skin'] 		 = nil,	-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = nil,	-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = nil, -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = -1,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR   
		},
			---   
	},
----------------------------------------------------------------- Size of your NPC. It will apply to all models.	
	['Scale']				= { 100, 0 }, --% scale and delta time.
----------------------------------------------------------------- It is sadly necessary to input these manually. Model change tends to break NPCs collisions.	
	['CollisionBounds']		= nil,
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
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']				= Angle( 0, -90, 0 ),
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 250,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { SquadName = "overwatch", model = "models/cup/proto_apc/combine_apc.mdl", vehiclescript ="scripts/vehicles/apc_npc.txt", actionScale = "1" }, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= nil, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	--['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	--},    
	['InputsAndOutputs'] 	= nil,   
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= nil, 
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']	= false,
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 1, 
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= nil, 
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output.	
	['DamageDealtScale'] 	= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = nil, 
----------------------------------------------------------------- List of NPC that your NPC should be friends with. NPCs listed here will also be friends with your NPC. You can use classname/name/vj_class/classify(class like CLASS_COMBINE).	
	['Relations'] 		= nil,  
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] = nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = nil,
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
	['RemoveOrReplaceOnDeath'] = nil,
----------------------------------------------------------------- Here you can edit the bones of your NPC. You can change position, angles, and scale.	
	['BoneEdit'] = nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.       
	['Functions'] = {
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self)	
			self:AddEFlags(EFL_DONTBLOCKLOS)
			
			self.exhaust = ANPlusCreateParticle( "Rocket_Smoke" )
			self.exhaust:ANPlusParent( self, nil, Vector( -35, -125, 102 ), Angle( 190, 0, 0 ) )
			
			self:DeleteOnRemove( self.exhaust )
			self:EmitSound( "ANP.ProtoAPC.EngineStart" )
			self:EmitSound( "ANP.ProtoAPC.EngineLoop" )			
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
		end,		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)				
		end, 		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )	
			print(ent, ent:GetClass())
			if (SERVER) && ent:GetClass() == "gib" then
				local gibModel = apcGibs[ math.random( 1, 4 ) ]
				ent:SetModel( gibModel )
				ent:SetModelScale( 1 )
			end
		end,
		------------------------------------------------------------ OnNPCEventHandle - This hook allows you to do a lot of things, from changing footstep sounds to... A lot of things...
		['OnNPCEventHandle'] = function(self, ...)	
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
			if IsValid(self.turret) && self:Health() <= 0 && !self.turret.m_bDestroyed then
				self.turret:Fire( "SelfDestruct", nil, 0 )
				self:SetModel( "models/cup/proto_apc/combine_apc_destroyed_gib01.mdl" )
				self:StopSound( "ANP.ProtoAPC.EngineStart" )
				self:StopSound( "ANP.ProtoAPC.EngineLoop" )
				if IsValid(self.exhaust) then self.exhaust:Remove() end
				self.turret.m_bDestroyed = true
			end
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
		------------------------------------------------------------ OnRagdollCreated - This function runs when ragdoll of our NPC gets created.
		['OnNPCRagdollCreated'] = function(self, ragdoll) -- SHARED ( CLIENT & SERVER )	
		end,		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)
			self:StopSound( "ANP.ProtoAPC.EngineStart" )
			self:StopSound( "ANP.ProtoAPC.EngineLoop" )
		end,		
		},	
	}
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( NPCTab ) 
]]--