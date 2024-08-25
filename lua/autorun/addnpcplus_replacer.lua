------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

ANPlusENTReplacerData = {}
ANPlusReplacerNPCList = ANPlusReplacerNPCList || {}
local customNPCList = {
	------------=#
	['Citizen Male'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	1,
		},
		Model		=	"models/Humans/Group01/male",
		Name		=	"Citizen Male",
	},
	------------=#
	['Citizen Female'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	1,
		},
		Model		=	"models/Humans/Group01/female",
		Name		=	"Citizen Female",
	},
	------------=#
	['Rebel Male'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	3,
		},
		Model		=	"models/Humans/Group03/male",
		Name		=	"Rebel Male",
		SpawnFlags	=	262144,
		Weapons 	= {
			"weapon_pistol",
			"weapon_ar2",
			"weapon_smg1",
			"weapon_ar2",
			"weapon_shotgun",
		}
	},
	------------=#
	['Rebel Female'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	3,
		},
		Model		=	"models/Humans/Group03/female",
		Name		=	"Rebel Female",
		SpawnFlags	=	262144,
		Weapons 	= {
			"weapon_pistol",
			"weapon_ar2",
			"weapon_smg1",
			"weapon_ar2",
			"weapon_shotgun",
		}
	},
	------------=#
	['Medic Male'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	3,
		},
		Model		=	"models/Humans/Group03m/male",
		Name		=	"Medic Male",
		SpawnFlags	=	131080,
		Weapons 	= {
			"weapon_pistol",
			"weapon_ar2",
			"weapon_smg1",
			"weapon_shotgun",
		}
	},
	------------=#
	['Medic Female'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	3,
		},
		Model		=	"models/Humans/Group03m/female",
		Name		=	"Medic Female",
		SpawnFlags	=	131080,
		Weapons 	= {
			"weapon_pistol",
			"weapon_ar2",
			"weapon_smg1",
			"weapon_shotgun",
		}
	},
	------------=#
	['Refugee Male'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	2,
		},
		Model		=	"models/Humans/Group02/male",
		Name		=	"Refugee Male",
		Weapons 	= {
			"weapon_pistol",
			"weapon_smg1",
		}
	},
	------------=#
	['Refugee Female'] = {
		Category	=	"Humans + Resistance",
		Class		=	"npc_citizen",
		KeyValues = {
			SquadName	=	"resistance",
			citizentype	=	2,
		},
		Model		=	"models/Humans/Group02/female",
		Name		=	"Refugee Female",
		Weapons 	= {
			"weapon_pistol",
			"weapon_smg1",
		}
	},
	------------=#
}
ANPlusENTReplacerFix = {
	['Rebel'] 			= "models/Humans/Group03/",
	['Refugee'] 		= "models/Humans/Group02/",
	['Medic'] 			= "models/Humans/Group03m/",
	--['VortigauntUriah'] = "models/vortigaunt_doctor.mdl",
	--['VortigauntSlave'] = "models/vortigaunt_slave.mdl",
}
	
hook.Add( "InitPostEntity", "ANPlusReplacer_InitPostEntity", function()
	ANPlusReplacerNPCList = list.Get( "NPC" )

	for _, v in pairs( ANPlusReplacerNPCList ) do 
		if v then
			if ANPlusENTReplacerFix[ tostring( _ ) ] then
				v.Model = ANPlusENTReplacerFix[ tostring( _ ) ]
			end
			if ANPlusLoadGlobal[ _ ] then
				table.RemoveByValue( ANPlusReplacerNPCList, v )				
			end
		end
	end
	
	table.Merge( ANPlusReplacerNPCList, customNPCList )
end )

if (SERVER) then
	
	util.AddNetworkString("anplus_replacer_savetab") 
	util.AddNetworkString("anplus_replacer_gettab_s") 
	util.AddNetworkString("anplus_replacer_gettab_c") 
	local von = include( "von/von_1_3_4.lua" )	
	local dir = "anplus_replacer"
	local dir_presets = dir.."/anplus_replacer_data.txt"
	
------------------------------------------------------------------------------=#
	if !file.Exists( dir, "DATA" ) then file.CreateDir( dir ) end
	if !file.Exists( dir_presets, "DATA" ) then file.Write( dir_presets ) end 
------------------------------------------------------------------------------=#	
	local function LoadData()		
		if file.Exists( dir_presets, "DATA" ) then 
			ANPlusENTReplacerData = von.deserialize( file.Read( dir_presets, "DATA" ) ) || {}
		end
	end
------------------------------------------------------------------------------=#	
	local function SaveReplacerData(tab)		
		if !istable( ANPlusENTReplacerData ) || !istable( tab ) then return end	
		file.Write( dir_presets, von.serialize( tab ) )
		ANPlusENTReplacerData = tab
	end
------------------------------------------------------------------------------=#	
	net.Receive("anplus_replacer_gettab_s", function(_, ply)	

		
		net.Start( "anplus_replacer_gettab_c" )
		net.WriteTable( ANPlusENTReplacerData )
		--net.WriteTable( newNPCList )
		--net.WriteString( game.GetMap() ) -- We do it here because of " In Multiplayer this does not return the current map in the CLIENT realm before GM:Initialize. "
		net.Send( ply )
	end)
------------------------------------------------------------------------------=#	
	net.Receive("anplus_replacer_savetab", function(_, ply)
		local tab = net.ReadTable()
		SaveReplacerData(tab)
	end)
------------------------------------------------------------------------------=#	
	hook.Add( "InitPostEntity", "ANPlusLoad_Init", LoadData )
	if player.GetCount() > 0 then LoadData() end -- Debug (for lua refresh)

end
------------------------------------------------------------------------------=#
if (CLIENT) then

	local function ANPlusNPCReplacerMenu(ANPlusENTReplacerData, npcList)

		ANPlusUISound( "ANP.UI.Open" )
		------------
		local dFrame = vgui.Create( "DFrame" )
			dFrame:SetTitle( "" )
			dFrame:SetSize( 1500, 530 )
			dFrame:Center()
			dFrame:SetVisible( true )
			dFrame:SetDraggable( true )
			dFrame:ShowCloseButton( true )
			dFrame:NoClipping( true )
			dFrame:SetSizable( false )
			dFrame:SetMinWidth( dFrame:GetWide() )
			dFrame:SetMinHeight( dFrame:GetTall() )
			--dFrame:SetIcon("vgui/csb_ico2.png")
			dFrame:MakePopup()
		function dFrame:PerformLayout()
			self:SetFontInternal( "ChatFont" )
			self:SetFGColor( color_white )		
		end
		dFrame.OnClose = function ()		
			ANPlusUISound( "ANP.UI.Close" )		
		end
		dFrame.Paint = function( self, w, h )	
			draw.RoundedBox( 8, 0, 0, w, h, Color( 50, 50, 50, 200 ) )			
		end
		------------=#
		local replacementG = dFrame:ANPlus_CreateTextEntry( 1075, 95, 230, 20, "ANPC Replacement Name", Color( 200, 200, 200, 255 ), "DermaDefaultBold", "This field takes ANPlus Names/IDs. It's mandatory." )
		
		local chanceG = dFrame:ANPlus_CreateNumberWang( 1315, 95, 50, 20, 100, 1, 1, 100, "Chance for turning selected NPC into an ANPC." )
		function chanceG:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		chanceG:SetInterval( 5 )
		function chanceG:OnValueChanged(val)
			ANPlusUISound( "ANP.UI.Slider" )
		end
		
		local skinG = dFrame:ANPlus_CreateNumberWang( 1025, 95, 40, 20, 0, 1, 0, 20, "Skin Rule. NPC'll be only replaced if it has a selected skin value. NPCs that have no skins usually return 0." )
		function skinG:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function skinG:OnValueChanged(val)
			ANPlusUISound( "ANP.UI.Slider" )
		end
		
		local modelG = dFrame:ANPlus_CreateTextEntry( 735, 95, 280, 20, "Model", Color( 200, 200, 200, 255 ), "DermaDefaultBold", "Model Rule. Only NPCs with the selected model will be replaced." )
		
		local classG = dFrame:ANPlus_CreateTextEntry( 615, 95, 110, 20, "Class", Color( 200, 200, 200, 255 ), "DermaDefaultBold", "Class Rule. It's mandatory." )
		
		local mapG = dFrame:ANPlus_CreateTextEntry( 1375, 95, 110, 20, "Map Name", Color( 200, 200, 200, 255 ), "DermaDefaultBold", "Set at which map this rule should apply." )
		
		local mapList = dFrame:ANPlus_ComboBox( 1375, 65, 110, 20, "All Maps", Color( 200, 200, 200, 255 ), "DermaDefaultBold", "List of all the maps. ALL. OF. THEM." )
		
		mapList:AddChoice( "-Current Map-", game.GetMap() )
		
		for _, v in ipairs( ANPlusGetAllMaps() ) do
			v = string.Replace( v, ".bsp", "" )
			mapList:AddChoice( v )
		end
		mapList.OnSelect = function( self, index, value, data )
			mapG:SetText( data || value )
		end
		
		------------=#
		local dListANPCReplacement = dFrame:ANPlus_CreateListView( 610, 137, 880, 383, false, true, { {"NPC Class", 80}, {"Model", 250}, {"Skin", 10}, {"Replacement", 200}, {"Chance", 20}, {"Map", 80} }, "Rule Table. It represents conditions at which chosen NPCs will be replaced with ANPCs.", "RULESET LIST" )		
		
		function dListANPCReplacement:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListANPCReplacement:OnRowSelected(lineID, line)
			--local id = line:GetValue( 1 ) -- Class
			local cla = line:GetValue( 1 ) -- Class
			local mod = line:GetValue( 2 ) -- Model 
			local ski = line:GetValue( 3 ) -- Skin 
			local rep = line:GetValue( 4 ) -- Replacement 
			local cha = line:GetValue( 5 ) -- Chance
			local map = line:GetValue( 6 ) -- Map
			
			classG:SetText( cla )
			modelG:SetText( mod )
			skinG:SetValue( ski )
			replacementG:SetText( rep )
			chanceG:SetValue( cha )
			mapG:SetText( map )
			
		end
		function dListANPCReplacement:OnRowRightClick(lineID, line)
			self:RemoveLine( lineID )		
			self:ClearSelection()
			ANPlusUISound( "ANP.UI.Text" )	
		end

		for _, v in pairs( ANPlusENTReplacerData ) do 
			if v then
				dListANPCReplacement:AddLine( v['Class'], tostring( v['Model'] ), v['Skin'], v['Replacement'], v['Chance'], v['Map'] )
			end
		end
		------------=#		
		local dListNPCs = dFrame:ANPlus_CreateListView( 10, 50, 590, 220, false, true, { {"Category", 90}, {"NPC Name", 90}, {"NPC Class", 80}, {"Model", 180}, {"Skin", 1} }, "List of all NPCs. For your convenience.", "NPC LIST" )			

		function dListNPCs:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListNPCs:OnRowSelected(lineID, line)
			local cla = line:GetValue( 3 ) -- Class
			local mod = line:GetValue( 4 ) -- Model 
			local ski = line:GetValue( 5 ) -- Skin 
			
			classG:SetText( cla )
			modelG:SetText( mod )
			skinG:SetValue( ski )			
		end
		
		for _, v in pairs( npcList ) do 
			if v then
				dListNPCs:AddLine( v['Category'], v['Name'], v['Class'], v['Model'] || "No Model", v['Skin'] || 0 )
			end
		end
		------------=#		
		local dListANPCs = dFrame:ANPlus_CreateListView( 10, 300, 590, 220, false, true, { {"Category"}, {"ANPC Name", 250} }, "List of all ANPCs. For your convenience.", "ANPC LIST" )			

		function dListANPCs:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListANPCs:OnRowSelected(lineID, line)
			local nam = line:GetValue( 2 ) -- ANPC Name/ID 
			
			replacementG:SetText( nam )			
		end

		for _, v in pairs( ANPlusLoadGlobal ) do
			if v && ( v['Spawnable'] || v['Spawnable'] != false ) then
				dListANPCs:AddLine( v['Category'], v['Name'] )
			end
		end
		------------=#
		local add = dFrame:ANPlus_CreateButton( 610, 65, 760, 20, 8, Color( 200, 200, 200, 255 ), "Add Rule", Color ( 100, 100, 100, 255 ), "Add created ruleset." )
		function add:OnCursorEntered()
			function add:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function add:OnCursorExited()
			function add:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end
		function add:DoClick()
			local error = nil
			--local id = idG:GetValue()
			local cla = classG:GetText()
			local mod = modelG:GetText() != nil && modelG:GetText() != "" && modelG:GetText() || "No Model"
			local ski = skinG:GetValue()
			local rep = replacementG:GetText()
			local cha = chanceG:GetValue()
			local map = mapG:GetText() != nil && mapG:GetText() != "" && mapG:GetText() || "No Map"
			
			if cla == nil || cla == "" || cla == "Class" then classG:ANPlusHighlightTextColor( Color( 255, 0, 0, 255 ), 1, Color( 200, 200, 200, 255 ) ); error = true end			
			if rep == nil || rep == "" || rep == "ANPC Replacement Name" then replacementG:ANPlusHighlightTextColor( Color( 255, 0, 0, 255 ), 1, Color( 200, 200, 200, 255 ) ); error = true end
			
			if error then ANPlusUISound( "ANP.UI.Error" ) return end
			
			if mod == "Model" then mod = "No Model" end
			if map == "Map Name" then map = "No Map" end
			
			dListANPCReplacement:AddLine( cla, mod, ski, rep, cha, map )
			ANPlusUISound( "ANP.UI.Click" )
		end
		------------=#

		local apply = dFrame:ANPlus_CreateButton( 610, 35, 880, 20, 8, Color( 200, 200, 200, 255 ), "Save Changes", Color ( 100, 100, 100, 255 ), "Save rules to a confing file." )
		function apply:OnCursorEntered()
			function apply:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function apply:OnCursorExited()
			function apply:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end
		function apply:DoClick()
			ANPlusENTReplacerData = {}
			--[[
			for k, line in ipairs( dListANPCReplacement:GetLines() ) do -- It breaks when line gets removed. Why?
				local cla = line:GetValue( 1 ) -- Class
				local mod = line:GetValue( 2 ) -- Model 
				local ski = line:GetValue( 3 ) -- Skin 
				local rep = line:GetValue( 4 ) -- Replacement 
				local cha = line:GetValue( 5 ) -- Chance
				local map = line:GetValue( 6 ) -- Map
				ANPlusENTReplacerData[ k ] = { ['Class'] = cla, ['Model'] = mod, ['Skin'] = ski, ['Replacement'] = rep, ['Chance'] = cha, ['Map'] = map }
			end
			]]--

			for i = 1, #dListANPCReplacement:GetLines() do
				local line = dListANPCReplacement:GetLines()[ i ]			
				if line then				
					local cla = line:GetValue( 1 ) -- Class
					local mod = line:GetValue( 2 ) -- Model 
					local ski = line:GetValue( 3 ) -- Skin 
					local rep = line:GetValue( 4 ) -- Replacement 
					local cha = line:GetValue( 5 ) -- Chance
					local map = line:GetValue( 6 ) -- Map
					ANPlusENTReplacerData[ i ] = { ['Class'] = cla, ['Model'] = mod, ['Skin'] = ski, ['Replacement'] = rep, ['Chance'] = cha, ['Map'] = map }					
				end			
			end
			
			net.Start( "anplus_replacer_savetab" )
			net.WriteTable( ANPlusENTReplacerData )
			net.SendToServer()
			
			ANPlusUISound( "ANP.UI.Click" )
		end
		------------=#
		local cVar = GetConVar( "anplus_replacer_enabled" )
		local checkbox = dFrame:ANPlus_CreateCheckBoxLabel( 1170, 5, "Enable Replacer", Color( 200, 200, 200, 255 ), cVar:GetBool(), "Enable the ANPlus Replacer." )
		function checkbox:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		checkbox:SetConVar( "anplus_replacer_enabled" )
		function checkbox:OnChange( bool )
			ANPlusUISound( "ANP.UI.Slider" )
		end
		------------=#
		local close = dFrame:ANPlus_CreateButton( 1440, 5, 50, 20, 8, Color( 200, 200, 200, 255 ), "Close", Color ( 100, 100, 100, 255 ), "Close the menu." )
		function close:OnCursorEntered()
			function close:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function close:OnCursorExited()
			function close:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end
		function close:DoClick()
			--ANPlusUISound( "ANP.UI.Click" )
			dFrame:Close()
		end
		------------=#
		local helptext = " This menu can be used to replace engine NPCs/Entities(soonTM) with ANPCs."..
		"\n You can either enter everything manually or use lists on the left."..
		"\n Simply select (left click) a line to automaticly fill respected replacement rules."..
		"\n You can remove lines/rulesets from the RULESET list simply right-click them."..
		"\n Remember to save all the changes!"
		local help = dFrame:ANPlus_CreateButton( 1300, 5, 130, 20, 8, Color( 200, 200, 200, 255 ), "Hover For Help", Color ( 100, 100, 100, 255 ), helptext )
		function help:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end

		------------=#
		dFrame:ShowCloseButton( false )
	end

	net.Receive("anplus_replacer_gettab_c", function()
		local tab = net.ReadTable()
		--local tab2 = net.ReadTable()
		ANPlusNPCReplacerMenu( tab, ANPlusReplacerNPCList )	
	end)

	concommand.Add( "anplus_replacer_menu", function(ply, cmd, args, argStr)
		if !ply:IsAdmin() then	
			ply:ChatPrint( "Sorry but this command is reserved for Admins only." )		
		else		
			net.Start( "anplus_replacer_gettab_s" )
			net.SendToServer() 
		end	
	end)

end
------------=#------------=#------------=#------------=#------------=#------------=#------=#