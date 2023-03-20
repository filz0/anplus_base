if !ConVarExists("anplus_ff_disabled") then	
   CreateConVar("anplus_ff_disabled", '0', (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Allow friendly fire.")
end

if !ConVarExists("anplus_force_swep_anims") then	
   CreateConVar("anplus_force_swep_anims", '1', (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Force fixed swep animations.")
end

if !ConVarExists("anplus_random_placement") then	
   CreateConVar("anplus_random_placement", '0', (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "If enabled and spawned by Players, ANPCs will be placed randomy around the map.")
end