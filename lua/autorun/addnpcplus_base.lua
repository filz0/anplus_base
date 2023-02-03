ANPlusLoadGlobal = { ['Base']  = { ['Name'] = "ANPlus BASE" }, ['entids'] = {} }

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
	
	AddNPC = function( tab, listType )

		if ANPlusLoadGlobal then
			local listType = listType || "NPC"
			local id = tostring( tab['Name'] ) 	
			
			local addTab = { [ ANPlusLoadGlobal['entids'][ id ] && ANPlusLoadGlobal['entids'][ id ][ 2 ] || #ANPlusLoadGlobal + 1 ] = tab } 		
			table.Merge( ANPlusLoadGlobal, addTab )	
			
			local addTab = { [ id ] = { true, #ANPlusLoadGlobal, IDCreate( tab['Name'] ) } } 
			table.Merge( ANPlusLoadGlobal['entids'], ANPlusLoadGlobal['entids'][ id ] || addTab )
			
			if (CLIENT) then				
				print( "AddNPCPlus " .. ANPlusLoadGlobal['entids'][ id ][ 2 ] .. " Loaded: " .. tab['Name'] )  				
				language.Add( id, id )
				language.Add( "#" .. id, id )
			end		
			
			if listType == "NPC" && tab['Relations'] && !tab['Relations'][ tab['Name'] ] then			
				local addTab = { [''.. tab['Name'] ..''] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } }, } 
				table.Merge( tab['Relations'], addTab )			
			end
			
			tab['KeyValues'] = tab['KeyValues'] || {}
			local addTab = { targetname = id } -- This should help with all these NPC spawner tools :/
			table.Merge( tab['KeyValues'], addTab )		
			
			if tab['Spawnable'] != nil && tab['Spawnable'] == false then return end		
			
			if listType == "NPC" then
				list.Set( listType, id, {
					Name 		= tab['Name'], 
					Class 		= tab['Class'], 
					--Model 		= tab['Models'] && tab['Models'][ 1 ] && tab['Models'][ 1 ][ 1 ] || nil, 
					Health 		= tab['Health'], 
					Category 	= tab['Category'], 
					KeyValues 	= tab['KeyValues'], 
					Weapons 	= tab['DefaultWeapons'] || nil, 
					SpawnFlags 	= tab['SpawnFlags'],			
					AdminOnly 	= tab['AdminOnly'] || false,			
					OnCeiling 	= tab['OnCeiling'] || false,			
					OnFloor 	= tab['OnFloor'] || false,			
					Offset 		= tab['Offset'] || 10,
					DropToFloor = tab['DropToFloor'] || nil,
					Rotate 		= tab['Rotate'] || nil,			
					NoDrop 		= tab['NoDrop'] || false,	
				})
			elseif listType == "SpawnableEntities" then
				list.Set( listType, id, {
					PrintName 		= tab['Name'], 
					ClassName 		= tab['Class'], 
					--Model 			= id, 
					Health 			= tab['Health'], 
					Category 		= tab['Category'], 
					KeyValues 		= tab['KeyValues'], 
					Weapons 		= tab['DefaultWeapons'] || nil, 
					SpawnFlags 		= tab['SpawnFlags'],			
					AdminOnly 		= tab['AdminOnly'] || false,			
					OnCeiling 		= tab['OnCeiling'] || false,			
					OnFloor 		= tab['OnFloor'] || false,			
					NormalOffset 	= tab['Offset'] || 10,			
					Rotate 			= tab['Rotate'] || nil,			
					NoDrop 			= tab['NoDrop'] || false,	
					Author 			= tab['Author'] || "",	
				})
			end
		end		
	end,

	AddNPCWeapon = function( base, name, entclass, killcon, killconcolor )
		
		local checkIfBaseExists = base && file.Exists( "lua/weapons/" .. base, "GAME" ) || !base && true
		if !checkIfBaseExists then return end
		
		if !file.Exists( "lua/weapons/" .. entclass .. "", "GAME" ) || ( file.Exists( "lua/weapons/" .. entclass .. "", "GAME" ) && weapons.Get( entclass ) && weapons.Get( entclass )['Base'] && !file.Exists( "lua/weapons/" .. weapons.Get( entclass )['Base'] .. "", "GAME" ) ) then 
			print("ANPlus denied weapon [" .. name .. "]. Weapon is not valid or its BASE has not been installed/enabled.")
		return end
		
		local tab = { title = name, class = entclass }
		
		list.Set("NPCUsableWeapons", tab.class, tab )
		if (CLIENT) then killicon.Add( tab.class, killcon || "HUD/killicons/default", killconcolor || Color( 255, 80, 0, 255 ) ) end
		
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
	
} 

timer.ANPlusDelayed = function( id, delay, time, repeats, callback ) -- This is stupid and has to go... Far away...
	
	if id && delay == -1 then timer.Remove( id .. "ANPlusDelayed" ); timer.Remove( id ) return end
	
	if !timer.Exists( id .. "ANPlusDelayed" ) then
	
		timer.Create( id .. "ANPlusDelayed", delay, 1, function()
		
			timer.Create( id, time, repeats, callback )
		
		end)
	
	end

end

local ANPlusInvalidChars = {
" ",
"{",
"}",
"[",
"]",
"(",
")",
"!",
"+",
"=",
"?",
".",
",",
"/",
"-",
"`",
"~"
}

function IDCreate( name )

	for i = 1, #ANPlusInvalidChars do

		name = string.Replace( name, ANPlusInvalidChars[ i ], ANPlusInvalidChars[ i ] == " " && "_" || "" )
	
	end
	
	local id = string.lower( name )
	
	return id
	
end






