------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

if (SERVER) then
	resource.AddFile( "resource/fonts/frak.ttf" )
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