AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "ai_translations.lua" )
AddCSLuaFile( "sh_anim.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "bullet_pen.lua" )

include( "ai_translations.lua" )
include( "sh_anim.lua" )
include( "shared.lua" )
include( "bullet_pen.lua" )

SWEP.Weight			= 5		-- Decides whether we should switch from/to this
SWEP.AutoSwitchTo	= true	-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom	= true	-- Auto switch from if you pick up a better weapon
