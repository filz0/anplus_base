------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

vec3_origin = Vector( 0, 0, 0 )

if (SERVER) then
	resource.AddFile( "resource/fonts/frak.ttf" )
	resource.AddFile( "resource/fonts/ocrbczyk.ttf" )
	resource.AddFile( "resource/fonts/ocrbczyk_bold.ttf" )
end

sound.Add( {
	name = "ANP.UI.Open",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/menu_open.wav",
} )

sound.Add( {
	name = "ANP.UI.Close",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/menu_close.wav",
} )

sound.Add( {
	name = "ANP.UI.Error",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/error.wav",
} )

sound.Add( {
	name = "ANP.UI.Deny",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 60,
	sound = "buttons/button16.wav",
} )

sound.Add( {
	name = "ANP.UI.Click",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/click.wav",
} )

sound.Add( {
	name = "ANP.UI.Hover",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/hover.wav",
} )

sound.Add( {
	name = "ANP.UI.List.Open",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/list_open.wav",
} )

sound.Add( {
	name = "ANP.UI.List.Close",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/list_close.wav",
} )

sound.Add( {
	name = "ANP.UI.Text",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/text.wav",
} )

sound.Add( {
	name = "ANP.UI.Slider",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/slider_apply.wav",
} )

sound.Add( {
	name = "ANP.UI.Spawn",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = 100,
	sound = "anp/ui/spawn.wav",
} )

sound.Add( {
	name = "ANP.WEAPON.Flashlight",
	channel = CHAN_ITEM,
	volume = 0.9,
	level = 70,
	pitch = 100, 
	sound = "anp/fx/flashlight1.wav"
} )

sound.Add( {
	name = "ANP.WEAPON.Tracer.Flyby",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = 140,
	pitch = 100, 
	sound = {
		"weapons/fx/nearmiss/bulletltor03.wav",
		"weapons/fx/nearmiss/bulletltor04.wav",
		"weapons/fx/nearmiss/bulletltor05.wav",
		"weapons/fx/nearmiss/bulletltor06.wav",
		"weapons/fx/nearmiss/bulletltor07.wav",
		"weapons/fx/nearmiss/bulletltor08.wav",
		"weapons/fx/nearmiss/bulletltor09.wav",
		"weapons/fx/nearmiss/bulletltor10.wav",
		"weapons/fx/nearmiss/bulletltor11.wav",
		"weapons/fx/nearmiss/bulletltor12.wav",
		"weapons/fx/nearmiss/bulletltor13.wav",
		"weapons/fx/nearmiss/bulletltor14.wav",
	}
} )

sound.Add( {
	name = "ANP.WEAPON.Beam.Flyby",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = 140,
	pitch = { 70, 90 }, 
	sound = "anp/fx/beam_flyby.wav",

} )

ANPlus.AddParticle( "particles/grenade_fx.pcf", {
	"grenade_explosion_01",
	"grenade_explosion_01b",
	"grenade_explosion_01c",
	"grenade_explosion_01d",
	"grenade_explosion_01e",
	"grenade_explosion_01f",
	"grenade_explosion_01g",
	"grenade_explosion_01h",
} )

ANPlus.AddParticle( "particles/devtest.pcf", {
	"test_beam",
	"test_collision",
	"test_lighting",
	"test_orientation",
	"test_trails",
	"weapon_explosion_grenade",
	"weapon_muzzle_flash_assaultrifle",
	"weapon_muzzle_flash_assaultrifle_glow",
	"weapon_muzzle_flash_assaultrifle_main",
	"weapon_muzzle_flash_assaultrifle_vent",
	"weapon_muzzle_flash_smoke_small2",
	"weapon_muzzle_smoke",
	"weapon_muzzle_smoke_b",
	"weapon_muzzle_smoke_b Version #2",
	"weapon_muzzle_smoke_long",
	"weapon_muzzle_smoke_long_b",
	"weapon_shove",
} )

ANPlus.AddParticle( "particles/anp_penetration_stuff.pcf", {
	"anp_penetration",
	"anp_penetration_dust",
	"anp_penetration_dust_spray",
	"anp_penetration_sparks",
} )

--
local precacheSND = {
	"ANP.WEAPON.Tracer.Flyby",
}

local precacheModels = {
	"models/anp/bullets/bt_9mm.mdl",
	"models/anp/bullets/bt_357.mdl",
	"models/anp/bullets/bt_762.mdl",
	"models/anp/bullets/bt_h9mm.mdl",
	"models/anp/bullets/bt_h357.mdl",
	"models/anp/bullets/bt_h762.mdl",
	"models/anp/bullets/w_pellet.mdl",
}

for i = 1, #precacheModels do
	util.PrecacheModel( precacheModels[ i ] )
end 

for i = 1, #precacheSND do
	util.PrecacheSound( precacheSND[ i ] )
end 

COND = COND || {} -- Port from dev / x86 branch

COND.BEHIND_ENEMY				= 29	
COND.BETTER_WEAPON_AVAILABLE	= 46	
COND.CAN_MELEE_ATTACK1			= 23	
COND.CAN_MELEE_ATTACK2			= 24	
COND.CAN_RANGE_ATTACK1			= 21	
COND.CAN_RANGE_ATTACK2			= 22	
COND.ENEMY_DEAD					= 30	
COND.ENEMY_FACING_ME			= 28	
COND.ENEMY_OCCLUDED				= 13	
COND.ENEMY_TOO_FAR				= 27	
COND.ENEMY_UNREACHABLE			= 31	
COND.ENEMY_WENT_NULL			= 12	
COND.FLOATING_OFF_GROUND		= 61	
COND.GIVE_WAY					= 48	
COND.HAVE_ENEMY_LOS				= 15	
COND.HAVE_TARGET_LOS			= 16	
COND.HEALTH_ITEM_AVAILABLE		= 47	
COND.HEAR_BUGBAIT				= 52	
COND.HEAR_BULLET_IMPACT			= 56	
COND.HEAR_COMBAT				= 53	
COND.HEAR_DANGER				= 50	
COND.HEAR_MOVE_AWAY				= 58	
COND.HEAR_PHYSICS_DANGER		= 57	
COND.HEAR_PLAYER				= 55	
COND.HEAR_SPOOKY				= 59	
COND.HEAR_THUMPER				= 51	
COND.HEAR_WORLD					= 54	
COND.HEAVY_DAMAGE				= 18	
COND.IDLE_INTERRUPT				= 2	
COND.IN_PVS						= 1	
COND.LIGHT_DAMAGE				= 17	
COND.LOST_ENEMY					= 11	
COND.LOST_PLAYER				= 33	
COND.LOW_PRIMARY_AMMO			= 3	
COND.MOBBED_BY_ENEMIES			= 62	
COND.NEW_ENEMY					= 26	
COND.NO_CUSTOM_INTERRUPTS		= 70	
COND.NO_HEAR_DANGER				= 60	
COND.NO_PRIMARY_AMMO			= 4	
COND.NO_SECONDARY_AMMO			= 5	
COND.NO_WEAPON					= 6	
COND.NONE						= 0	
COND.NOT_FACING_ATTACK			= 40	
COND.NPC_FREEZE					= 67	
COND.NPC_UNFREEZE				= 68	
COND.PHYSICS_DAMAGE				= 19	
COND.PLAYER_ADDED_TO_SQUAD		= 64	
COND.PLAYER_PUSHING				= 66	
COND.PLAYER_REMOVED_FROM_SQUAD	= 65	
COND.PROVOKED					= 25	
COND.RECEIVED_ORDERS			= 63	
COND.REPEATED_DAMAGE			= 20	
COND.SCHEDULE_DONE				= 36	
COND.SEE_DISLIKE				= 9	
COND.SEE_ENEMY					= 10	
COND.SEE_FEAR					= 8	
COND.SEE_HATE					= 7	
COND.SEE_NEMESIS				= 34	
COND.SEE_PLAYER					= 32	
COND.SMELL						= 37	
COND.TALKER_RESPOND_TO_QUESTION	= 69	
COND.TARGET_OCCLUDED			= 14	
COND.TASK_FAILED				= 35	
COND.TOO_CLOSE_TO_ATTACK		= 38	
COND.TOO_FAR_TO_ATTACK			= 39	
COND.WAY_CLEAR					= 49	
COND.WEAPON_BLOCKED_BY_FRIEND	= 42	
COND.WEAPON_HAS_LOS				= 41	
COND.WEAPON_PLAYER_IN_SPREAD	= 43	
COND.WEAPON_PLAYER_NEAR_TARGET	= 44	
COND.WEAPON_SIGHT_OCCLUDED		= 45	

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

