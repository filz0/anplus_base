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
	local SM_GenericBG = "vgui/anplus_log.png"
	local SM_GenericIcon = "vgui/anp_def_ico.png"
	local SM_GenericNPCIcon = "vgui/anp_npc_ico.png"
	local SM_GenericENTIcon = "vgui/anp_ent_ico.png"
	local SM_GenericVEHIcon = "vgui/anp_veh_ico.png"
	local SM_BGImage 
	local SM_HeaderTable = {
        ['NPC'] = {},
        ['SpawnableEntities'] = {},
        ['Vehicles'] = {},
    }
	local SM_MainNodes = {
		['[ NPCs ]'] 		= true,
		['[ Entities ]'] 	= true,
		['[ Vehicles ]'] 	= true,
	}

	local SM_IconHoverMat = Material( "gui/sm_hover.png", "nocull" )
	local SM_IconHoverFunc = GWEN.CreateTextureBorder( 3, 3, 64 - 3 * 2, 64 - 3 * 2, 5, 5, 5, 5, SM_IconHoverMat )

	local SM_IconMATOverlayNormal = Material( "gui/ContentIcon-normal.png" )
	local SM_IconMATOverlayHovered = Material( "gui/ContentIcon-hovered.png" )
	local SM_IconMATOverlayAdminOnly = Material( "icon16/shield.png" )
	local SM_IconMATOverlayNPCWeapon = Material( "icon16/monkey.png" )
	local SM_IconMATOverlayNPCWeaponSelected = Material( "icon16/monkey_tick.png" )


	Derma_Hook( PANEL, "Paint", "Paint", "Tree" )
	PANEL.m_bBackground = true -- Hack for above

	local function IsValidIcon(path)
		local png = string.gsub( path, ".mdl", "_128.png" )
		return file.Exists( "materials/spawnicons/" .. png, "GAME" ) && "spawnicons/" .. png
	end

	local shadowColor = Color( 0, 0, 0, 200 )
	local function DrawTextShadow( text, x, y )
		draw.SimpleText( text, "DermaDefault", x + 1, y + 1, shadowColor )
		draw.SimpleText( text, "DermaDefault", x, y, color_white )
	end

	local function GenerateIconFromModel(model, successCallback)

		iconGen = vgui.Create( "SpawnIcon" )
		iconGen:SetPos( -128, -128 )
		iconGen:SetSize( 128, 128 )
		iconGen:SetMouseInputEnabled( false )
		iconGen:SetKeyboardInputEnabled( false )
		iconGen:SetModel( model )	

		iconGen.Think = function(self)

			if IsValidIcon( model ) then

				if isfunction(successCallback) then
					if !successCallback(self) then self:Remove() return end
				end

				self:Remove()

			end

		end

		--iconGen.Icon:SetVisible( false )

	end
	
	spawnmenu.AddContentType( "anplus_npcs", function( panel, obj )
		if ( !obj.material ) then return end
		if ( !obj.nicename ) then return end
		if ( !obj.spawnname ) then return end
		if ( !obj.category ) then return end
        if ( !obj.type ) then return end

		local label	
		local iconGen
		local iconGenIco	
		local category = !SM_MainNodes[ obj.nodeN ] && obj.subCategory || obj.category

		if !SM_HeaderTable[ obj.type ][ category ] then

			label = vgui.Create( "ContentHeader", panel )
			label:SetText( category )	
			SM_HeaderTable[ obj.type ][ category ] = true
			
		end

		local icon = vgui.Create( "ContentIcon" )
		icon:SetContentType( "anplus_npcs" )
		icon:SetSpawnName( obj.spawnname )
		icon:SetName( obj.nicename )
		icon:SetMaterial( obj.material )
		icon:SetAdminOnly( obj.admin )
		icon:SetColor( Color( 205, 92, 92, 255 ) )
		icon.m_fOverlayFade = 0
		icon.m_pngAutoIcon = icon.m_pngAutoIcon || false

		if obj.model && obj.material == SM_GenericIcon then

			if obj.model && !IsValidIcon( obj.model ) then

				GenerateIconFromModel( obj.model, function(self) if IsValid(icon) && IsValidIcon( obj.model ) then icon.m_pngAutoIcon = Material( IsValidIcon( obj.model ) ) end end )

			elseif obj.model && IsValidIcon( obj.model ) then

				if IsValidIcon( obj.model ) then icon.m_pngAutoIcon = Material( IsValidIcon( obj.model ) ) end

			end

		end

		icon.DoClick = function()

			if obj.type == "NPC" then

				local override = GetConVar( "gmod_npcweapon" ):GetString()
				local weapon = obj.weapon && ( override == "" && table.Random(obj.weapon) || override ) || "none"			
				RunConsoleCommand( "gmod_spawnnpc", obj.spawnname, weapon )

			elseif obj.type == "SpawnableEntities" then

				RunConsoleCommand( "gm_spawnsent", obj.spawnname )

			elseif obj.type == "Vehicles" then

				RunConsoleCommand( "gm_spawnvehicle", obj.spawnname )

			end

			surface.PlaySound( "ANP.UI.Spawn" )

		end

		icon.Think = function( self )
			
			self.m_fOverlayFade = math.Clamp( self.m_fOverlayFade - RealFrameTime() * 640 * 2, 0, 255 )
		
			if ( dragndrop.IsDragging() || !self:IsHovered() ) then return end
		
			self.m_fOverlayFade = math.Clamp( self.m_fOverlayFade + RealFrameTime() * 640 * 8, 0, 255 )
		
		end

		icon.PaintOver = function( self, w, h )

			if ( self.m_fOverlayFade > 0 ) then
				SM_IconHoverFunc( 0, 0, w, h, Color( 0, 255, 255, self.m_fOverlayFade ) )
			end
		
		end

		icon.Paint = function( self, w, h )
			
			if ( self.Depressed && !self.Dragging ) then
				if ( self.Border != 8 ) then
					self.Border = 8
					self:OnDepressionChanged( true )
				end
			else
				if ( self.Border != 0 ) then
					self.Border = 0
					self:OnDepressionChanged( false )
				end
			end
			
			render.PushFilterMag( TEXFILTER.ANISOTROPIC )
			render.PushFilterMin( TEXFILTER.ANISOTROPIC )
			
			self.Image:PaintAt( 3 + self.Border, 3 + self.Border, 128 - 8 - self.Border * 2, 128 - 8 - self.Border * 2 )

			if self.m_pngAutoIcon then
				surface.SetMaterial( self.m_pngAutoIcon )
				surface.DrawTexturedRect( 3 + self.Border, 3 + self.Border, 128 - 8 - self.Border * 2, 128 - 8 - self.Border * 2 )			
			end

			render.PopFilterMin()
			render.PopFilterMag()

			surface.SetDrawColor( 255, 255, 255, 255 )

			local drawText = false
			if ( !dragndrop.IsDragging() && ( self:IsHovered() || self.Depressed || self:IsChildHovered() ) ) then

				surface.SetMaterial( SM_IconMATOverlayHovered )

			else

				surface.SetMaterial( SM_IconMATOverlayNormal )
				drawText = true

			end

			surface.DrawTexturedRect( self.Border, self.Border, w-self.Border*2, h-self.Border*2 )

			if ( self:GetAdminOnly() ) then
				surface.SetMaterial( SM_IconMATOverlayAdminOnly )
				surface.DrawTexturedRect( self.Border + 8, self.Border + 8, 16, 16 )
			end

			-- This whole thing could be more dynamic
			if ( self:GetIsNPCWeapon() ) then
				surface.SetMaterial( SM_IconMATOverlayNPCWeapon )

				if ( self:GetSpawnName() == GetConVarString( "gmod_npcweapon" ) ) then
					surface.SetMaterial( SM_IconMATOverlayNPCWeaponSelected )
				end

				surface.DrawTexturedRect( w - self.Border - 24, self.Border + 8, 16, 16 )
			end
			self:ScanForNPCWeapons()

			if ( drawText ) then
				local buffere = self.Border + 10
		
				-- Set up smaller clipping so cut text looks nicer
				local px, py = self:LocalToScreen( buffere, 0 )
				local pw, ph = self:LocalToScreen( w - buffere, h )
				render.SetScissorRect( px, py, pw, ph, true )
		
				-- Calculate X pos
				surface.SetFont( "DermaDefault" )
				local tW, tH = surface.GetTextSize( self.m_NiceName )
		
				local x = w / 2 - tW / 2
				if ( tW > ( w - buffere * 2 ) ) then
					local mx, my = self:ScreenToLocal( input.GetCursorPos() )
					local diff = tW - w + buffere * 2
		
					x = buffere + math.Remap( math.Clamp( mx, 0, w ), 0, w, 0, -diff )
				end
		
				-- Draw
				DrawTextShadow( self.m_NiceName, x, h - tH - 9 )
		
				render.SetScissorRect( 0, 0, 0, 0, false )
			end

		end
	
		icon.OpenMenu = function( self )

			local menu = DermaMenu()
			
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( self:GetSpawnName() ) end ):SetIcon( "icon16/page_copy.png" )
			if ( isfunction( self.OpenMenuExtra ) ) then
				self:OpenMenuExtra( menu )
			end
		
			menu:AddOption( "#spawnmenu.menu.spawn_with_toolgun", function()
				local override = GetConVar( "gmod_npcweapon" ):GetString()
				local weapon = obj.weapon && ( override == "" && table.Random(obj.weapon) || override ) || "none"
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

	end )

	local forceDefault = {
		['[ NPCs ]'] = true,
		['[ Entities ]'] = true,
		['[ Vehicles ]'] = true,
	}

	local SM_BGMusic = nil
	local custmBGMusicLast = nil

	local function GiveIconsToNode( panel, tree, node, npcdata )

		node.DoPopulate = function( self ) -- When we click on the node - populate it using this function
			-- If we've already populated it - forget it. NO?
			if ( self.PropPanel ) then self.PropPanel:Remove() end
			if ( SM_BGImage ) then SM_BGImage:Remove() end

			local nodeN = node.Label:GetText()
			
			-- Clean the header table
			SM_HeaderTable = { ['NPC'] = {}, ['SpawnableEntities'] = {}, ['Vehicles'] = {} }

			-- Create the category background
			SM_BGImage = panel:ANPlus_CreateImage( 0, 0, 1024, 1024, SM_GenericBG, false, true, false )
			SM_BGImage:SetZPos( -999 )
			SM_BGImage:SetKeepAspect( false )

			local w2, h2 = panel:GetSize()
			SM_BGImage:SetSize( w2, h2 )	

			-- Create the icon panel
			self.PropPanel = vgui.Create( "ContentContainer", panel )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			local custmBGImg = "none"
			local custmBGSize = { 0, 0 }
			local custmBGColor = Color( 255, 255, 255, 100 )
			local custmBGMusic = nil

			local custmIco
			local custmIcoHColor = Color( 255, 255, 255, 255 )
			
			for name, ent in SortedPairsByMemberValue( npcdata, "Category" ) do
				local mat = SM_GenericIcon
	
				if file.Exists( "materials/entities/" .. name .. ".png", "GAME" ) then
					mat = "entities/" .. name .. ".png"
				end

                local category = ent['Category'] && string.Split( ent['Category'], " | " )
				category, subCategory = istable(category) && category[ 1 ] || ent['Category'], istable(category) && category[ 2 ]

				if !forceDefault[ nodeN ] then
					
					local custCat = ANPlusCategoryCustom[ nodeN ] || ANPlusCategoryCustom[ ent['Category'] ]
					if custCat then
						custmBGImg = custCat['BGImage']
						custmBGSize = custCat['BGAddSize']
						custmBGColor = custCat['BGColor']
						custmBGMusic = custCat['BGMusic']
					end

				end

				local icon = spawnmenu.CreateContentIcon( "anplus_npcs", self.PropPanel, {
					nicename	= ent['Name'],
					spawnname	= name,
					material	= mat,
					model		= ent['Models'] && ent['Models'][ 1 ] && ent['Models'][ 1 ][ 1 ] || "models/props_junk/watermelon01.mdl",
					weapon		= ent['DefaultWeapons'],
					admin		= ent['AdminOnly'],
                    type        = ent['EntityType'],
					nodeN		= nodeN,
					category	= category,
					subCategory = subCategory
				} )
			end

			SM_BGImage:SetImage( custmBGImg, SM_GenericBG )
			SM_BGImage:SetImageColor( custmBGColor )
			
			local x, y = SM_BGImage:GetPos()						
			function SM_BGImage:PaintAt( x, y, dw, dh )

				dw, dh = dw || self:GetWide(), dh || self:GetTall()
				self:LoadMaterial()
				
				if ( !self.m_Material ) then return true end

				local Texture = self.m_Material:GetTexture( "$basetexture" )
			
				surface.SetMaterial( self.m_Material )
				surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a ) 
				--[[
				if ( Texture ) then
					local color = Vector( r / 255, g / 255, b / 255 )
					local alpha = a / 255
					self.m_Material:SetVector( "$color", color )
					self.m_Material:SetInt( "$translucent", 1 )
					self.m_Material:SetInt( "$alphatest", 1 )
					self.m_Material:SetInt( "$allowalphatocoverage", 1 )
					self.m_Material:SetInt( "$alpha", 1 )
				end
				]]
				
				surface.DrawTexturedRect( x, y, dw, dh )
				return true
			end
			------------------------------------------------------------BG Music
			local activeThink = CurTime()

			function self.PropPanel:Paint()
				activeThink = CurTime() + 0.1
			end

			local function StopMusic()

				if SM_BGMusic then

					SM_BGMusic:Stop()
					SM_BGMusic = nil
					custmBGMusicLast = nil
					--timer.Remove( "ANPSpawnMenuThink" )

				end

			end

			timer.Create( "ANPSpawnMenuThink", 0, 0, function()
				
				if ( self.PropPanel ) then

					if custmBGMusic && !forceDefault[nodeN] && custmBGMusic != custmBGMusicLast then

						SM_BGMusic = CreateSound( LocalPlayer(), custmBGMusic )
						SM_BGMusic:PlayEx( 0, 100 )
						SM_BGMusic:ChangeVolume( 1, 1 )
						
						custmBGMusicLast = custmBGMusic

					elseif !custmBGMusic || activeThink < CurTime() then

						StopMusic()

					end

				else

					timer.Remove( "ANPSpawnMenuThink" )

				end

			end )

			--self.PropPanel.OnRemove = function()				
			--	StopMusic()
			--end
			------------------------------------------------------------BG Music
			function SM_BGImage:Paint(w, h)		
				
				local w1, h1 = tree:GetSize()
				self:PaintAt( x + w1, y, ( w2 + custmBGSize[ 1 ] ) - w1, h2 + custmBGSize[ 2 ] )

			end
			
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

				local catIcon = ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon'] || ANPlusCategoryCustom[ categoryName ] && ANPlusCategoryCustom[ categoryName ]['Icon']
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
					--print(dataID, dataIcon, lastIconPath)
					local catNode = node:AddNode( dataID, dataIcon )
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

				local catIcon = ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon'] || ANPlusCategoryCustom[ categoryName ] && ANPlusCategoryCustom[ categoryName ]['Icon']
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
	
					local catNode = node:AddNode( dataID, dataIcon )
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

				local catIcon = ANPlusCategoryCustom[ categoryName .. " | " .. dataID ] && ANPlusCategoryCustom[ categoryName .. " | " .. dataID ]['Icon'] || ANPlusCategoryCustom[ categoryName ] && ANPlusCategoryCustom[ categoryName ]['Icon']
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
	
					local catNode = node:AddNode( dataID, dataIcon )
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

		function tree:ChildExpanded( bool )

			if bool == true || bool == false then
				surface.PlaySound( bool && "ANP.UI.List.Open" || "ANP.UI.List.Close" )
			end

			self:InvalidateLayout()
		end

		function tree:OnNodeSelected( node )
			surface.PlaySound( "ANP.UI.Click" )
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