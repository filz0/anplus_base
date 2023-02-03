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