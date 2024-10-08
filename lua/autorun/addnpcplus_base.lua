------------------------------------------------------------------------------=#
--SHARED
AddCSLuaFile("autorun/addnpcplus_resources.lua")
AddCSLuaFile("autorun/addnpcplus_menus.lua")
AddCSLuaFile("autorun/addnpcplus_replacer.lua")
AddCSLuaFile("autorun/addnpcplus_sh_func.lua")
AddCSLuaFile("autorun/addnpcplus_sh_hooks.lua")
AddCSLuaFile("autorun/addnpcplus_sh_meta.lua")
--SERVER
AddCSLuaFile("autorun/server/addnpcplus_sr_func.lua")
AddCSLuaFile("autorun/server/addnpcplus_sr_hooks.lua")
AddCSLuaFile("autorun/server/addnpcplus_sr_meta.lua")
------------------------------------------------------------------------------=#

ANPlusLoadGlobal = {}
ANPlusLoadGlobalCount = 0

ANPlusDangerStuffGlobalNameOrClass = { "grenade", "missile", "rocket", "frag", "flashbang", "portal", "spore", "prop_combine_ball", "bolt" }
ANPlusDangerStuffGlobal = {}
ANPlusCustomSquads = { base_squad = {} }
ANPlusToolMenuGlobal = {}
ANPlusRemoveFromSpawnList = {}
ANPlusHealthBarStyles = { ['Disable All'] = true }
ANPlusScriptedSentences = {}
ANPlusCategoryCustom = ANPlusCategoryCustom || {}

SV_BRANCH = ""

ANPDefaultGMODWeapons = {
['weapon_pistol'] 		= true,
['weapon_357'] 			= true,
['weapon_smg1'] 		= true,
['weapon_shotgun'] 		= true,
['weapon_ar2'] 			= true,
['weapon_rpg'] 			= true,
['weapon_alyxgun'] 		= true,
['weapon_annabelle'] 	= true,
['weapon_crossbow'] 	= true,
['weapon_stunstick'] 	= true,
['weapon_crowbar'] 		= true,
['weapon_glock_hl1'] 	= true
}

ANPlus = {
	--[[////////////////////////
	||||| Used to add ANPlus NPCs to the spawn menu and global table.
	]]--\\\\\\\\\\\\\\\\\\\\\\\\
	AddNPC = function( tab, listType )

		if ANPlusLoadGlobal then

			local id = tostring( tab['Name'] ) 	
			
			local base = tab['Base'] && ANPlusLoadGlobal[ tab['Base'] ]
			if base then tab = table.Merge( table.Copy( base ), tab ) end

			local addTab = { [ id ] = tab } 		

			local listType = listType || "NPC"
			tab['EntityType'] = listType

			table.Merge( ANPlusLoadGlobal, addTab )	

			ANPlusLoadGlobalCount = ANPlusLoadGlobalCount + 1
			
			if (CLIENT) then				
				print( "AddNPCPlus " .. ANPlusLoadGlobalCount .. " Loaded: " .. id )  				
				--language.Add( id, id )
				--language.Add( "#" .. id, id )
			end		
			--	
			if listType == "NPC" then -- Default stuff that We need for other stuff to not break.
				if tab['Relations'] then
					--if !tab['Relations'][ tab['Name'] ] then			
					--	local addTab = { [''.. tab['Name'] ..''] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, } 
					--	table.Merge( tab['Relations'], addTab )		
					--end
					if !tab['Relations']['Default'] then
						local addTab = { ['Default'] = { ['MeToNPC'] = { "Default", 0 }, ['NPCToMe'] = { "Default", 0 } }, } 
						table.Merge( tab['Relations'], addTab )	
					end
				end
				if tab['WeaponProficiencyTab'] then
					if !tab['WeaponProficiencyTab']['Default'] then
						local addTab = { ['Default'] = { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil }, } 
						table.Merge( tab['WeaponProficiencyTab'], addTab )	
					end
				end
				if tab['SpawnFlags'] then
					local addSFs = 1024 --bit.bor( 512, 1024 )
					tab['SpawnFlags'] = tab['SpawnFlags'] + addSFs
				end
			elseif listType == "SpawnableEntities" then
				if tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] then
					local getModel = tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ]
					tab['KeyValues'] = tab['KeyValues'] || {}
					local addTab = { model = getModel }
					table.Merge( tab['KeyValues'], addTab )	
				end
			elseif listType == "Vehicles" then
				if tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] then
					local getModel = tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ]
					tab['KeyValues'] = tab['KeyValues'] || {}
					local addTab = { model = getModel }
					table.Merge( tab['KeyValues'], addTab )	
				end
				if tab['VehicleScript'] then
					local addTab = { vehiclescript = tab['VehicleScript'] }
					tab['KeyValues'] = tab['KeyValues'] || {}
					table.Merge( tab['KeyValues'], addTab )
				else 
					return
				end
			end
			
			tab['KeyValues'] = tab['KeyValues'] || {}
			local addTab = { parentname = id } -- This should help with all these NPC spawner tools :/
			table.Merge( tab['KeyValues'], addTab )		
			
			if tab['Spawnable'] != nil && tab['Spawnable'] == false then return end
			
			local category = tab['Category'] && string.Split( tab['Category'], " | " )
			category = istable( category ) && #category >= 2 && category[ 1 ] || tab['Category']
			
			if listType == "NPC" then
				list.Set( listType, id, {
					Name 			= tab['Name'], 
					Class 		 	= tab['Class'], 
					Model 		 	= tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] || false, 
					Health 		 	= tab['Health'], 
					Category 	 	= category, 
					KeyValues 	 	= tab['KeyValues'] || {}, 
					Weapons 	 	= tab['DefaultWeapons'] || false, 
					SpawnFlags 	 	= tab['SpawnFlags'],			
					AdminOnly 	 	= tab['AdminOnly'] || false,			
					OnCeiling 	 	= tab['OnCeiling'] || false,			
					OnFloor 	 	= tab['OnFloor'] || false,			
					Offset 		 	= tab['Offset'] || 10,
					--DropToFloor = tab['DropToFloor'] || false,
					Rotate 		 	= tab['Rotate'] || false,			
					NoDrop 			= tab['NoDrop'] || false,
					Author 		 	= tab['Author'] || false,	
					Information  	= tab['Information'] || false,					
				})
			elseif listType == "Vehicles" then
				list.Set( listType, id, {
					Name 		 	= tab['Name'], 
					Class 		 	= tab['Class'], 
					Model 		 	= tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] || false, 
					Health 		 	= tab['Health'], 
					Category 	 	= category, 
					KeyValues 	 	= tab['KeyValues'] || {}, 
					SpawnFlags 	 	= tab['SpawnFlags'],			
					AdminOnly 	 	= tab['AdminOnly'] || false,			
					OnCeiling 	 	= tab['OnCeiling'] || false,			
					OnFloor 	 	= tab['OnFloor'] || false,			
					Offset 		 	= tab['Offset'] || 10,
					--DropToFloor = tab['DropToFloor'] || false,
					Rotate 		 	= tab['Rotate'] || false,			
					NoDrop 		 	= tab['NoDrop'] || false,
					VC_ExtraSeats 	= tab['ExtraSeats'] || false,
					Author 		 	= tab['Author'] || false,	
					Information  	= tab['Information'] || false,					
				})
			elseif listType == "SpawnableEntities" then
				list.Set( listType, id, {
					PrintName 	 	= tab['Name'], 
					ClassName 	 	= tab['Class'], 					 
					Health 		 	= tab['Health'], 
					Category 	 	= category, 
					KeyValues 	 	= tab['KeyValues'] || {},  
					SpawnFlags 	 	= tab['SpawnFlags'],			
					AdminOnly 	 	= tab['AdminOnly'] || false,			
					OnCeiling 	 	= tab['OnCeiling'] || false,			
					OnFloor 	 	= tab['OnFloor'] || false,			
					NormalOffset 	= tab['Offset'] || 10,			
					Rotate 		 	= tab['Rotate'] || false,			
					NoDrop 		 	= tab['NoDrop'] || false,	
					Author 		 	= tab['Author'] || "Baka",	
					Information  	= tab['Information'] || "Amongus",	
				})
			end
		end		
	end,
	--[[////////////////////////
	||||| Used to add NPC weapons to the spawn menu while also checking if added weapon has its base installed. If not, it won't be added.
	]]--\\\\\\\\\\\\\\\\\\\\\\\\
	AddNPCWeapon = function( base, name, entclass, killcon, killconcolor, killconfont, killconscale )
		
		local checkIfBaseExists = base && file.Exists( "lua/weapons/" .. base, "GAME" ) || !base && true
		if !checkIfBaseExists then return end
		
		if !file.Exists( "lua/weapons/" .. entclass .. "", "GAME" ) || ( file.Exists( "lua/weapons/" .. entclass .. "", "GAME" ) && weapons.Get( entclass ) && weapons.Get( entclass )['Base'] && !file.Exists( "lua/weapons/" .. weapons.Get( entclass )['Base'] .. "", "GAME" ) ) then 
			print("ANPlus denied weapon [" .. name .. "]. Weapon is not valid or its BASE has not been installed/enabled.")
		return end
		
		local tab = { title = name, class = entclass }
		
		list.Set( "NPCUsableWeapons", tab.class, tab )
		
		if (CLIENT) && killcon then

			local isTexturePath = string.find( string.lower( killcon ), "hud/killicons/" )

			if isTexturePath then
				killicon.Add( tab.class, killcon || "HUD/killicons/default", killconcolor || Color( 255, 80, 0, 255 ) ) 
			else
				killicon.AddFont( tab.class, killconfont || "HL2MPTypeDeath", killcon || "-", killconcolor || Color( 255, 80, 0, 255 ), killconscal || 1 )
			end
			
		end
		
	end,  
	
	IsWeaponValid = function(wep)
			
		if ANPDefaultGMODWeapons[ wep ] then return true end
				
		timer.Simple(0, function() 
		
			if !file.Exists( "lua/weapons/" .. wep .. "", "GAME" ) || ( file.Exists( "lua/weapons/" .. wep .. "", "GAME" ) && weapons.Get( wep ) && weapons.Get( wep )['Base'] && !file.Exists( "lua/weapons/" .. weapons.Get( wep )['Base'] .. "", "GAME" ) ) then  
					
				--print("ANPlus removed weapon [" .. wep .. "] and replaced it with [" .. replacement .. "]. Weapon is not valid or its BASE has not been installed/enabled.")
				
				return false
				
			else
			
				return true
				
			end
			
		end)
	
	end,
	
	AddToolMenu = function(category, name, panel, tab)
		if ANPlusToolMenuGlobal then 
			local addTab = { [ #ANPlusToolMenuGlobal + 1 ] = { ['Category'] = category, ['Name'] = name, ['Panel'] = panel, ['Table'] = tab } } -- This should help with all these NPC spawner tools :/
			table.Merge( ANPlusToolMenuGlobal, addTab )				
		end
	end,
	
	--[[////////////////////////
	||||| Wanted to make a ANPC but model/s comes with its own NPC/s? Use this function to get rid of it/them.
	--]]
	RemoveFromSpawnList = function(name)	
		if !ANPlusRemoveFromSpawnList[ name ] then
			table.insert( ANPlusRemoveFromSpawnList, name )
		end
	end,

	AddConVar = function(command, defaultValue, flags, help, min, max)
		if !ConVarExists( command ) then
			CreateConVar( command, defaultValue, flags || FCVAR_NONE, help || "", min, max )
		end
	end,
	
	AddClientConVar = function(command, defaultValue, flags, help, min, max)
		if !ConVarExists( command ) && (CLIENT) then
			CreateClientConVar( command, defaultValue, flags || true, true, help || "", min, max )
		end
	end,
	
	AddParticle = function(fileName, particleList)
		game.AddParticles( fileName )
		for k, v in ipairs( particleList ) do
			PrecacheParticleSystem( v )
		end	
	end,
	
	AddHealthBarStyle = function(id, hpbarTab)
		if id && hpbarTab then
			ANPlusHealthBarStyles[ id ] = hpbarTab 
		end
	end,

	AddScriptedSentence = function(ssTab)
		if !istable(ssTab) || !ssTab['name'] then return end
		ANPlusScriptedSentences[ ssTab['name'] ] = ssTab 
	end,

	AddNPCClass = function(className, relationTab)
		if !className || !relationTab then return end
		Add_NPC_Class( className )
		table.Merge( ANPlusPlayerRelations, relationTab )
	end,

	AddCategoryCustomize = function(category, icon, bgImg, w, h, color, bgMusic)
		if SERVER then return end
		ANPlusCategoryCustom[ category ] = { ['Icon'] = icon, ['BGImage'] = bgImg, ['BGAddSize'] = { w || 0, h || 0 }, ['BGColor'] = color || Color( 255, 255, 255, 150 ), ['BGMusic'] = bgMusic }
	end
	
} 

timer.ANPlusDelayed = function( id, delay, time, repeats, callback ) -- This is stupid and has to go... Far away... Pls don't use.	
	if id && delay == -1 then timer.Remove( id .. "ANPlusDelayed" ); timer.Remove( id ) return end	
	if !timer.Exists( id .. "ANPlusDelayed" ) then	
		timer.Create( id .. "ANPlusDelayed", delay, 1, function()		
			timer.Create( id, time, repeats, callback )		
		end)	
	end
end  

ANPlus.AddConVar( "anplus_ff_disabled", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Allow friendly fire.", 0, 1 )
ANPlus.AddConVar( "anplus_force_swep_anims", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Force fixed swep animations.", 0, 1 )
ANPlus.AddConVar( "anplus_random_placement", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "If enabled and spawned by Players, ANPCs will be placed randomy around the map.", 0, 1 )
ANPlus.AddConVar( "anplus_hp_mul", 1, (FCVAR_GAMEDLL + FCVAR_ARCHIVE), "Multiply ANPC's health.", 0.1 )
ANPlus.AddConVar( "anplus_replacer_enabled", 1, (FCVAR_GAMEDLL + FCVAR_ARCHIVE), "Enable ANPlus Replacer.", 0, 1 )
ANPlus.AddConVar( "anplus_look_distance_override", 2048, (FCVAR_GAMEDLL + FCVAR_ARCHIVE), "Set NPC look/sight distance. This command only affect ANPCs that don't have thier look distance changed by thier code.", 0, 32000 )
ANPlus.AddConVar( "anplus_follower_collisions", 0, (FCVAR_GAMEDLL + FCVAR_ARCHIVE + FCVAR_NOTIFY), "Enable collisions on following You ANPCs.", 0, 1 )
ANPlus.AddClientConVar( "anplus_hpbar_dist", 2048, false, "Enable light effect used by the muzzle effects from this base.", 0 )
ANPlus.AddClientConVar( "anplus_hpbar_def_style", "HL2 Retail", false, "Select a style of NPC's health bar if one has it enabled." )
ANPlus.AddClientConVar( "anplus_bm_volume", "1", false, "Volume of the boss music." )
ANPlus.AddClientConVar( "anplus_swep_muzzlelight", 1, false, "Enable light effect used by the muzzle effects from this base.", 0, 1 )
ANPlus.AddClientConVar( "anplus_swep_shell_smoke", 1, false, "Allow smoke effect to be emitted from fired bullet casings.", 0, 1 )
ANPlus.AddClientConVar( "anplus_swep_flight_fade_distance_start", 2048, false, "Distance at which SWEP's flashlight will start fading.", 512, 10240 )
ANPlus.AddClientConVar( "anplus_swep_flight_fade_distance", 1024, false, "SWEP's flashlight fade distance.", 512, 10240 )
ANPlus.AddClientConVar( "anplus_swep_flight_smartmode", 1, false, "NPCs will only use flashlights in dark places.", 0, 1 )
ANPlus.AddClientConVar( "anplus_swep_laser_fade_distance_start", 1024, false, "Distance at which SWEP's laser will start fading.", 512, 10240 )
ANPlus.AddClientConVar( "anplus_swep_laser_fade_distance", 512, false, "SWEP's laser fade distance.", 512, 10240 )
 
local invChars = {" ","{","}","[","]","(",")","!","+","=","?",".",",","/","-","`","~"}
function ANPlusIDCreate(name)
	for i = 1, #invChars do
		name = string.Replace( name, invChars[ i ], invChars[ i ] == " " && "_" || "" )	
	end	
	name = string.lower( name )	
	return name	
end

--[[

]]--



