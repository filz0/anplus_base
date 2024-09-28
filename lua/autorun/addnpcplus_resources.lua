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