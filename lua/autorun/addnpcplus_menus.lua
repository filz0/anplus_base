if (CLIENT) then
    
	local scrWidth = 1920
	local scrHeight = 1080

	function ANPlusGetFixedScreenW()
		return ScrW() / scrWidth
	end

	function ANPlusGetFixedScreenH()
		return ScrH() / scrHeight
	end

	function ANPlusMiddleScreenW()
		return ScrW() / 2
	end

	function ANPlusMiddleScreenH()
		return ScrH() / 2
	end
	
	local function ANPlusMenuDefault_Settings(panel)

		panel:ClearControls()	
		
		local image = panel:ANPlus_CreateImage( 0, 20, 250 * ANPlusGetFixedScreenW(), 250 * ANPlusGetFixedScreenH(), "vgui/anplus_log.png", false, true, false )		
		image:Dock( TOP )
		
		panel:ANPlus_SecureMenuItem( panel:CheckBox( "Disable Anti-FriendlyFire", "anplus_ff_disabled" ), "Disable Anti-FriendlyFire feature built-in to the base." )
		panel:ANPlus_SecureMenuItem( panel:CheckBox( "Random Placement", "anplus_random_placement" ), "If enabled, ANPCs spawned by the Players will be placed randomly if possible." )		
		panel:ANPlus_SecureMenuItem( panel:CheckBox( "Follower Collisions", "anplus_follower_collisions" ), "Enables collisions on following You ANPCs." )		
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "Health Multiplier", "anplus_hp_mul", 1, 10, 2 ), "Multiply health values of ANPCs." )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "Look Distance", "anplus_look_distance_override", 0, 32000, 0 ), "Sets the Look Distance of ANPCs. This setting only affect ANPCs which don't have thier look distance already changed in thier code." )		

		local hpBarList = vgui.Create( "DComboBox" )
		--DComboBox:SetPos( 5, 30 )
		hpBarList:SetConVar( "anplus_hpbar_def_style" )
		hpBarList:SetValue( "options" )
		for id, func in pairs( ANPlusHealthBarStyles ) do
			if id && func then
				hpBarList:AddChoice( id, func )
			end
		end
		hpBarList.OnSelect = function( self, index, value )
			RunConsoleCommand( "anplus_hpbar_def_style", value )
		end
		
		local hpBarLabel = vgui.Create( "DLabel" )
		hpBarLabel:SetText( "Health Bar Style:" )
		hpBarLabel:SetTextColor( Color( 200, 200, 200 ) )
		
		panel:AddItem( hpBarLabel )
		panel:AddItem( hpBarList )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "Health Bar Render Distance", "anplus_hpbar_dist", 0, 4096, 0 ), "Distance at which the special Health Bar will show on Player's screen." )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "Boss/Chase Music Volume", "anplus_bm_volume", 0, 1, 2 ), "Volume of the boss music." )
		panel:ANPlus_SecureMenuItem( panel:CheckBox( "SWEP Muzzle Light Effect", "anplus_swep_muzzlelight" ), "If enabled, muzzle effects from this base will emit light." )
		panel:ANPlus_SecureMenuItem( panel:CheckBox( "SWEP Casing/Shell Smoke", "anplus_swep_shell_smoke" ), "If enabled, spent casings/shells from this base will generate smoke particle effect." )
		panel:ANPlus_SecureMenuItem( panel:CheckBox( "SWEP Flashlight Smart Mode", "anplus_swep_flight_smartmode" ), "If enabled, NPCs will only use flashlights in dark places." )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "SWEP Flashlight Fade Distance Start", "anplus_swep_flight_fade_distance_start", 512, 10240, 0 ), "Distance at which SWEP's flashlight will start fading." )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "SWEP Flashlight Fade Distance", "anplus_swep_flight_fade_distance", 512, 10240, 0 ), "Distance at which SWEP's flashlight will fade." )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "SWEP Laser Fade Distance Start", "anplus_swep_laser_fade_distance_start", 512, 10240, 0 ), "Distance at which SWEP's laser will start fading." )
		panel:ANPlus_SecureMenuItem( panel:NumSlider( "SWEP Laser Fade Distance", "anplus_swep_laser_fade_distance", 512, 10240, 0 ), "Distance at which SWEP's laser will fade." )

	end
	
	local function ANPlusMenuDefault_Functions(panel)
		panel:ClearControls()	
		
		local image = panel:ANPlus_CreateImage( false, false, 250 * ANPlusGetFixedScreenW(), 250 * ANPlusGetFixedScreenH(), "vgui/anplus_log.png", false, true, false )	
		image:Dock( TOP )
		
		panel:ANPlus_SecureMenuItem( panel:Button( "[NPC]: Frezee", "anplus_sleep_npcs" ), "Frezee all NPCs." )
		panel:ANPlus_SecureMenuItem( panel:Button( "[NPC]: Unfrezee", "anplus_wake_npcs" ), "Unfrezee all NPCs." )
		panel:ANPlus_SecureMenuItem( panel:Button( "Replacer Menu", "anplus_replacer_menu" ), "Here you can set all sorts of rules for NPC/Entity(soonTM) replacement." )
	end
	
	hook.Add( "AddToolMenuTabs", "ANPlusLoad_AddToolMenuTabs", function( category, name, panel, tab )
		spawnmenu.AddToolTab( "ANPlus", "ANPlus", "vgui/anp_ico.png" )
		spawnmenu.AddToolMenuOption( "ANPlus", "[BASE]", "anplus_mainsettings", "Settings", nil, nil, ANPlusMenuDefault_Settings )
		spawnmenu.AddToolMenuOption( "ANPlus", "[BASE]", "anplus_mainfunctions", "Functions", nil, nil, ANPlusMenuDefault_Functions )
		for i = 1, #ANPlusToolMenuGlobal do
			local toolData = ANPlusToolMenuGlobal[ i ]
			if toolData then spawnmenu.AddToolMenuOption( "ANPlus", toolData['Category'], ANPlusIDCreate( toolData['Category'] ) .. "_menu", toolData['Name'], nil, nil, toolData['Panel'], toolData['Table'] || nil ) end
		end		
	end)





    local PANEL = {}
	local SM_GenericIcon = "vgui/anplus_log.png"
	local SM_GenericNPCIcon = "vgui/anp_npc_ico.png"
	local SM_GenericENTIcon = "vgui/anp_ent_ico.png"
	local SM_GenericVEHIcon = "vgui/anp_veh_ico.png"
	local SM_BGImage 
	local SM_HeaderTable = {
        ['NPC'] = {},
        ['SpawnableEntities'] = {},
        ['Vehicles'] = {},
    }

	Derma_Hook( PANEL, "Paint", "Paint", "Tree" )
	PANEL.m_bBackground = true -- Hack for above
	
	spawnmenu.AddContentType( "anplus_npcs", function( panel, obj )
		if ( !obj.material ) then return end
		if ( !obj.nicename ) then return end
		if ( !obj.spawnname ) then return end
		if ( !obj.category ) then return end
        if ( !obj.type ) then return end

		local label

		if !SM_HeaderTable[ obj.type ][ obj.category ] then

			label = vgui.Create( "ContentHeader", panel )
			label:SetText( obj.category )	
			SM_HeaderTable[ obj.type ][ obj.category ] = true
			
		end
	
		local icon = vgui.Create( "ContentIcon", panel )
		icon:SetContentType( "anplus_npcs" )
		icon:SetSpawnName( obj.spawnname )
		icon:SetName( obj.nicename )
		icon:SetMaterial( obj.material )
		icon:SetAdminOnly( obj.admin )
		icon:SetColor( Color( 205, 92, 92, 255 ) )
		icon.DoClick = function()
			if obj.type == "NPC" then
				local override = GetConVar("gmod_npcweapon"):GetString()
				RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, obj.weapon && ( override == "" && table.Random(obj.weapon) || override ) || "none" )
			elseif obj.type == "SpawnableEntities" then
				RunConsoleCommand( "gm_spawnsent", obj.spawnname )
			elseif obj.type == "Vehicles" then
				RunConsoleCommand( "gm_spawnvehicle", obj.spawnname )
			end
			surface.PlaySound( "buttons/button16.wav" )
		end
	
	
		icon.OpenMenu = function( self )
			local menu = DermaMenu()
			
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( self:GetSpawnName() ) end ):SetIcon( "icon16/page_copy.png" )
			if ( isfunction( self.OpenMenuExtra ) ) then
				self:OpenMenuExtra( menu )
			end
		
			menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function()
				RunConsoleCommand( "gmod_tool", "creator" ) RunConsoleCommand( "creator_type", "2" )
				RunConsoleCommand( "creator_name", obj.spawnname ) RunConsoleCommand( "creator_arg", weapon )
			end ):SetIcon( "icon16/brick_add.png" )
		
			menu:Open()
		end	
	
		if ( IsValid( panel ) ) then
			if label then panel:Add( label ) end
			panel:Add( icon )
		end
	
	
		return icon
	end)

	local function GiveIconsToNode( panel, tree, node, npcdata )
		node.DoPopulate = function( self ) -- When we click on the node - populate it using this function
			-- If we've already populated it - forget it.
			if ( self.PropPanel ) then return end
			if ( SM_BGImage ) then SM_BGImage:Remove() end
			
			SM_BGImage = panel:ANPlus_CreateImage( 0, 0, 1024, 1024, SM_GenericIcon, false, true, false )
			SM_BGImage:SetZPos( -999 )
			--SM_BGImage:Dock( RIGHT )		
			--local w1, h1 = panel.ContentNavBar:GetSize()	
			local w2, h2 = panel:GetSize()
			SM_BGImage:SetSize( w2, h2 )	
			local x1, y1 = SM_BGImage:GetPos()
			SM_BGImage:SetPos( x1, y1 + 15 )			
			SM_BGImage:SetAlpha( 150 )
			

			-- Create the panel panel
			self.PropPanel = vgui.Create( "ContentContainer", panel )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )

			--local generalHeader = vgui.Create( "ContentHeader", self.PropPanel )
			--generalHeader:SetText( "Test Lmao" )

			local custmBGImg = "none"
	
			for name, ent in SortedPairsByMemberValue( npcdata, "Category" ) do
				local mat = SM_GenericIcon
	
				if file.Exists( "materials/entities/" .. name .. ".png", "GAME" ) then
					mat = "entities/" .. name .. ".png"
				end

                local nicecategory = ent['Category'] && string.Split( ent['Category'], " | " )
				custmBGImg = ANPlusCategoryCustom[ ent['Category'] ] && ANPlusCategoryCustom[ ent['Category'] ]['BGImage'] || custmBGImg
	
				local icon = spawnmenu.CreateContentIcon( "anplus_npcs", self.PropPanel, {
					nicename	= ent['Name'],
					spawnname	= name,
					material	= mat,
					weapon		= ent['DefaultWeapons'],
					admin		= ent['AdminOnly'],
                    type        = ent['EntityType'],
					category	= istable(nicecategory) && nicecategory[ 1 ] || ent['Category']
				} )
			end

			SM_BGImage:SetImage( custmBGImg, SM_GenericIcon )

		end 
	
		node.DoClick = function( self )
			self:DoPopulate()
			panel:SwitchPanel( self.PropPanel )
		end
	end

	hook.Add( "ANPlusSpawnMenuPopulate", "ANPlus_SpawnMenuPopulate", function( panel, tree, node )
		
		local NPCTab = {}
		local ENTTab = {}
		local VEHTab = {}
		for class, entData in pairs( ANPlusLoadGlobal ) do

			if isstring( entData['Category'] ) then
				
				if ( entData['Spawnable'] == nil || entData['Spawnable'] == true ) then
					
					if entData['EntityType'] == "NPC" then

						local categories = string.Split( entData['Category'], " | " )
						local category1, category2 = categories[ 1 ], categories[ 2 ]
						NPCTab[category1] = NPCTab[ category1 ] || {}
			
						if category2 then
							NPCTab[ category1 ][ category2 ] = NPCTab[ category1 ][ category2 ] || {}
							NPCTab[ category1 ][ category2 ][ class ] = entData
						else
							NPCTab[ category1 ][ class ] = entData
						end

					end

					if entData['EntityType'] == "SpawnableEntities" then

						local categories = string.Split( entData['Category'], " | " )
						local category1, category2 = categories[ 1 ], categories[ 2 ]
						ENTTab[ category1 ] = ENTTab[ category1 ] || {}
			
						if category2 then
							ENTTab[ category1 ][ category2 ] = ENTTab[ category1 ][ category2 ] || {}
							ENTTab[ category1 ][ category2 ][ class ] = entData
						else
							ENTTab[ category1 ][ class ] = entData
						end

					end

					if entData['EntityType'] == "Vehicles" then

						local categories = string.Split( entData['Category'], " | " )
						local category1, category2 = categories[ 1 ], categories[ 2 ]
						VEHTab[ category1 ] = VEHTab[ category1 ] || {}
			
						if category2 then
							VEHTab[ category1 ][ category2 ] = VEHTab[ category1 ][ category2 ] || {}
							VEHTab[ category1 ][ category2 ][ class ] = entData
						else
							VEHTab[ category1 ][ class ] = entData
						end

					end

				end

			end

		end

		local allNodeNPCs = tree:AddNode( "[ NPCs ]", SM_GenericNPCIcon )	

		local allNodeCacheNPCs = {}

		for categoryName, entData in SortedPairs( NPCTab ) do

			local allCatIconsSame = true
			local lastIconPath
			for dataID, data in SortedPairs( entData ) do

				local catIcon = ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon']
				if isstring( lastIconPath ) && catIcon != lastIconPath then
					allCatIconsSame = false
				end
				lastIconPath = catIcon
			end
	
			local dataIcon = allCatIconsSame && lastIconPath || SM_GenericNPCIcon
			local dataNodes = {}
				
			local node = allNodeNPCs:AddNode( categoryName, dataIcon )

			for dataID, data in SortedPairs( entData ) do	

				if ANPlusLoadGlobal[ dataID ] then
					
					GiveIconsToNode( panel, tree, node, entData )
					table.Merge( allNodeCacheNPCs, entData )
				else
	
					local catNode = node:AddNode( dataID, ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon'] || SM_GenericNPCIcon )
					GiveIconsToNode( panel, tree, catNode, data )
					table.Merge( dataNodes, data )
	
				end
				
			end

			if !table.IsEmpty( dataNodes ) then
				GiveIconsToNode( panel, tree, node, dataNodes )
				table.Merge( allNodeCacheNPCs, dataNodes )
			end
	
		end
		if !table.IsEmpty( allNodeCacheNPCs ) then
			GiveIconsToNode( panel, tree, allNodeNPCs, allNodeCacheNPCs )
		end



		local allNodeENTs = tree:AddNode( "[ Entities ]", SM_GenericENTIcon )	
		local allNodeCacheENTs = {}

		for categoryName, entData in SortedPairs( ENTTab ) do

			local allCatIconsSame = true
			local lastIconPath
			for dataID, data in SortedPairs( entData ) do

				local catIcon = ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon']
				if isstring( lastIconPath ) && catIcon != lastIconPath then
					allCatIconsSame = false
				end
				lastIconPath = catIcon
			end
	
			local dataIcon = allCatIconsSame && lastIconPath || SM_GenericENTIcon
			local dataNodes = {}
				
			local node = allNodeENTs:AddNode( categoryName, dataIcon )

			for dataID, data in SortedPairs( entData ) do	

				if ANPlusLoadGlobal[ dataID ] then
					
					GiveIconsToNode( panel, tree, node, entData )
					table.Merge( allNodeCacheENTs, entData )
				else
	
					local catNode = node:AddNode( dataID, ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon'] || SM_GenericENTIcon )
					GiveIconsToNode( panel, tree, catNode, data )
					table.Merge( dataNodes, data )
	
				end
				
			end

			if !table.IsEmpty( dataNodes ) then
				GiveIconsToNode( panel, tree, node, dataNodes )
				table.Merge( allNodeCacheENTs, dataNodes )
			end
	
		end
		if !table.IsEmpty( allNodeCacheENTs ) then
			GiveIconsToNode( panel, tree, allNodeENTs, allNodeCacheENTs )
		end
		


		local allNodeVEHs = tree:AddNode( "[ Vehicles ]", SM_GenericVEHIcon )	
		local allNodeCacheVEHs = {}

		for categoryName, entData in SortedPairs( VEHTab ) do

			local allCatIconsSame = true
			local lastIconPath
			for dataID, data in SortedPairs( entData ) do

				local catIcon = ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon']
				if isstring( lastIconPath ) && catIcon != lastIconPath then
					allCatIconsSame = false
				end
				lastIconPath = catIcon
			end
	
			local dataIcon = allCatIconsSame && lastIconPath || SM_GenericVEHIcon
			local dataNodes = {}
				
			local node = allNodeVEHs:AddNode( categoryName, dataIcon )

			for dataID, data in SortedPairs( entData ) do	

				if ANPlusLoadGlobal[ dataID ] then
					
					GiveIconsToNode( panel, tree, node, entData )
					table.Merge( allNodeCacheVEHs, entData )
				else
	
					local catNode = node:AddNode( dataID, ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon'] || SM_GenericVEHIcon )
					GiveIconsToNode( panel, tree, catNode, data )
					table.Merge( dataNodes, data )
	
				end
				
			end

			if !table.IsEmpty( dataNodes ) then
				GiveIconsToNode( panel, tree, node, dataNodes )
				table.Merge( allNodeCacheVEHs, dataNodes )
			end
	
		end
		if !table.IsEmpty( allNodeCacheENTs ) then
			GiveIconsToNode( panel, tree, allNodeVEHs, allNodeCacheVEHs )
		end
	
	end)

	vgui.Register( "ANPlus_SpawnMenu", PANEL, "DDrawer" )
	spawnmenu.AddCreationTab( "ANPlus", function(...)
		
		local panel = vgui.Create( "SpawnmenuContentPanel" )
		panel:CallPopulateHook( "ANPlusSpawnMenuPopulate" )

		local sidebar = panel.ContentNavBar
		sidebar.Options = vgui.Create( "ANPlus_SpawnMenu", sidebar )

		return panel

	end, "vgui/anp_ico.png", 25 )

end

properties.Add( "anplus_editmenu", {
	MenuLabel = "ANP Edit Menu", -- Name to display on the context menu
	Order = 60000, -- The order to display this property relative to other properties
	MenuIcon = "vgui/anp_ico_hd.png", -- The icon to display next to the property

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		--if ( !ent:IsANPlus( true ) ) then return false end
		if ( !ent['m_tSaveDataMenu'] || table.Count( ent['m_tSaveDataMenu'] ) == 0 ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "anplus_editmenu", ent ) ) then return false end

		return true
	end,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
		--ent:ANPlusCreateVar( "mCategory", "Category", "----[Default Variables]----", "Percentage damage resistance given by the Overseer's buff." )
		
		ent:ANPlusCustomConfigMenu()
		--ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenu'](ent) -- CLIENT

	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end
		
		--ent:ANPlusCreateVar( "mCategory", "Category", "----[Default Variables]----", "Percentage damage resistance given by the Overseer's buff." )
		--ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenu'](ent) -- SERVER
		
	end 
} )

properties.Add( "anplus_controller", {
	MenuLabel = "ANP Controller", -- Name to display on the context menu
	Order = 60001, -- The order to display this property relative to other properties
	MenuIcon = "vgui/anp_ico.png", -- The icon to display next to the property

	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		--if ( !ent:IsANPlus( true ) ) then return false end
		--if ( !ent['m_tSaveDataMenu'] || table.Count( ent['m_tSaveDataMenu'] ) == 0 ) then return false end
		if ( !GetConVar( "developer" ):GetBool() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "anplus_editmenu", ent ) ) then return false end
		
		return true
	end,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
		local ply = LocalPlayer()
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
		ply:DrawViewModel( false )
		ply.m_pANPControlledENT = ent

	end,
	Receive = function( self, length, ply ) -- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()

		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end
		ply:ANPlusControlled( ent )		
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity( ent )
		ply:SetNoTarget( true )
		ply:DrawShadow( false )
		ply:SetNoDraw( true )
		ply:SetMoveType( MOVETYPE_OBSERVER )
		ply:DrawViewModel( false )
		ply:DrawWorldModel( false )
		ply:StripWeapons()
		ent:SetMaxLookDistance( 1 )
		--ent:SetMaxLookDistance( 1 )
	end 
} )