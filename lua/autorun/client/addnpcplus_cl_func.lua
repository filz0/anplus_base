------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local ENT = FindMetaTable("Entity")
local scrWidth = 1920
local scrHeight = 1080

local multX = ScrW() / scrWidth
local multY = ScrH() / scrHeight

net.Receive("anplus_add_fakename_language", function()
	local name = net.ReadString()
	if name then
		if language.GetPhrase( name ) == name then 
			language.Add( name, name ) 
		end
	end	
end)

net.Receive("anplus_fix_bones", function()

	local ent = net.ReadEntity()

	if IsValid(ent) then

		ent:SetupBones() 
		ent:DestroyShadow()
		
	end
	
end)

net.Receive("anplus_set_ik", function()

	local ent = net.ReadEntity()
	local bool = net.ReadBool()
	
	if IsValid(ent) then
	
		ent:SetIK(bool)
		
	end

end)

net.Receive("anplus_holo_eff", function()

	local ent = net.ReadEntity()
	local color = net.ReadColor()
	local size = net.ReadFloat()
	local lenght = net.ReadFloat()

	--if IsValid(ent) then
	
		local fx = EffectData()
		fx:SetEntity( ent )
		fx:SetStart( Vector( color.r, color.g, color.b ) ) -- color
		fx:SetScale( size ) -- color
		fx:SetMagnitude( lenght ) -- color
		util.Effect( "anp_holo_blip", fx, true )	
		
	--end

end)

net.Receive("anplus_client_effect", function()

	local ent = net.ReadEntity()
	local effTab = net.ReadTable()		
	if IsValid(ent) then		
		local fx = EffectData()
		fx:SetEntity( ent )
		fx:SetStart( effTab.SetStart || Vector( 0, 0, 0 ) )
		fx:SetOrigin( effTab.SetOrigin || Vector( 0, 0, 0 ) )
		fx:SetNormal( effTab.SetNormal || Vector( 0, 0, 0 ) )
		fx:SetMagnitude( effTab.SetMagnitude || 1 )
		fx:SetScale( effTab.SetScale || 1 )
		fx:SetRadius( effTab.SetRadius || 1 )
		fx:SetAngles( effTab.SetAngles || Angle( 0, 0, 0 ) )
		fx:SetAttachment( effTab.SetAttachment || 0 )
		fx:SetColor( effTab.SetColor || 0 )
		fx:SetDamageType( effTab.SetDamageType || 0 )
		fx:SetFlags( effTab.SetFlags || 0 )
		fx:SetHitBox( effTab.SetHitBox || 0 )		
		fx:SetMaterialIndex( effTab.SetMaterialIndex || 0 )
		fx:SetSurfaceProp( effTab.SetSurfaceProp || -1 )
		util.Effect( effTab.Effect, fx, true )				
	end

end)

net.Receive("anplus_net_entity", function()
	local ent = net.ReadEntity()
	local id = net.ReadString()
	if ent then
		ent:ANPlusNPCApply( id )	
	end
end)

net.Receive("anplus_data_tab", function()

	local ent = net.ReadEntity()
	local tab = net.ReadTable()
	
	if ent && ent['ANPlusData'] && tab then
		table.Merge( ent['ANPlusData'], tab )
	end
end)

--[[
net.Receive("anplus_data_tab", function()

	local npc = net.ReadEntity()
	local tab = net.ReadTable()
	
	for i = 1, #ANPlusLoadGlobal do
		
		local dataTab = ANPlusLoadGlobal[ i ]

		if ( dataTab && dataTab['Name'] == tab['CurName'] ) then
			
			local addTab = { ['Functions'] = dataTab['Functions'] }
			table.Merge( tab, addTab )

		end
		
	end
	
	npc.ANPlusIDName = ANPlusIDCreate( tab['CurName'] )
	npc.ANPlusDataCur = tab

end)
]]--

net.Receive("anplus_paint_decal", function()
	local ent = net.ReadEntity()
	local decal = net.ReadString()
	local sP = net.ReadVector()
	local eP = net.ReadVector()
	local col = net.ReadColor()
	local w = net.ReadFloat()
	local h = net.ReadFloat()
	if IsValid(ent) then
		local mat = string.find( decal, "decals/" ) && Material( decal ) || Material( util.DecalMaterial( decal ) )
		util.DecalEx( mat, ent, sP, eP:GetNormalized(), col, w, h )
	end
end)

net.Receive("anplus_play_ui_snd", function()		
	local snd = net.ReadString() || ""
	local vol = net.ReadFloat() || 100
	ANPlusEmitUISound( nil, snd, vol )
end)

net.Receive("anplus_notify", function()		
	local snd = net.ReadString() || ""
	local text = net.ReadString() || ""
	local type = net.ReadFloat()
	local length = net.ReadFloat()	
	ANPlusSendNotify( nil, snd, text, type, length )		
end)

net.Receive("anplus_chatmsg_ply", function()	
	local snd = net.ReadString() || ""
	local color = net.ReadColor() || ""
	local text = net.ReadString()
	ANPlusMSGPlayer( nil, text, color, snd )
end)

net.Receive("anplus_screenmsg_ply", function()
	local dur = net.ReadFloat()
	local x = net.ReadFloat()
	local y = net.ReadFloat()
	local size = net.ReadFloat()
	local font = net.ReadString()
	local color = net.ReadColor()
	local text = net.ReadString() || ""	
	ANPlusScreenMsg( nil, x, y, size, dur, text, font, color)
end)

net.Receive("anplus_entmod_net", function()	
	local ent = net.ReadEntity()
	local data = net.ReadTable()
	if IsValid(ent) && data then table.Merge( ent:GetTable(), data ) end
end)

function ENT:ANPlusNPCPreDrawEffects()
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPreDrawEffects'] != nil then
		self:ANPlusGetDataTab()['Functions']['OnNPCPreDrawEffects'](self)
	end
end

function ENT:ANPlusNPCPostDrawEffects()
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCPostDrawEffects'] != nil then
		self:ANPlusGetDataTab()['Functions']['OnNPCPostDrawEffects'](self)
	end
end

function ENT:ANPlusCustomConfigMenu(tab)
		
	local ply = LocalPlayer()
	local ent = self
	if !tab then print("Couldn't load variables, aborting...") return end

	ANPlusUISound( "ANP.UI.Open" )

	local dFrame = vgui.Create( "DFrame" )
		dFrame:SetTitle( "" )
		dFrame:SetSize( 280, 55 )
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
	
	
	local colCat = dFrame:ANPlus_CreateCollapsibleCategory( 5, 5, 215, 50, false, "List Of Editable Variables (CLICK)", "Use this list to edit certain things about this entity." )
	function colCat:OnToggle( bool )	

		if bool == true then		
			ANPlusUISound( "ANP.UI.List.Open" )	
			timer.Simple( colCat:GetAnimTime() + 0.1, function()
				if !dFrame then return end
				local w, h = colCat:GetSize()
				h = h + 10 < 55 && 55 || h + 10 >= 55 && h + 10
				dFrame:SetSize( 280, h )
			end )
		elseif bool == false then		
			ANPlusUISound( "ANP.UI.List.Close" )		
			timer.Simple( colCat:GetAnimTime() + 0.1, function()
				if !dFrame then return end
				dFrame:SetSize( 280, 55 )
			end )
		end		
	end
	
	local colCatSP = vgui.Create( "DScrollPanel", dFrame )
	colCatSP:SetSize( 235, 250 )
	colCat:SetContents( colCatSP )
	
	local count = 0
	local height = 20
	for _, var in ipairs( tab ) do 
		if var then
			if isbool( ent:GetTable()[ var[ 1 ] ] ) then
				count = count + 1				
				local val = colCatSP:ANPlus_CreateCheckBoxLabel( 5, ( count * height ) - 20, var[ 2 ], false, ent:GetTable()[ var[ 1 ] ], var[ 3 ] || "" )
				function val:OnChange( bVal )
					var[ 10 ] = bVal
				end
			elseif isnumber( ent:GetTable()[ var[ 1 ] ] ) then
				count = count + 1
				local valLab = colCatSP:ANPlus_CreateLabel( 25, ( count * height - 2 ) - 20, 200, var[ 2 ], Color( 200, 200, 200, 255 ) )
				local val = colCatSP:ANPlus_CreateNumberScratch( 5, ( count * height ) - 20, ent:GetTable()[ var[ 1 ] ], var[ 6 ] || 0, var[ 4 ] || 0, var[ 5 ] || 1, var[ 3 ] || "" )
				function val:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var[ 6 ] || 0 )
					var[ 10 ] = nVal
				end				
			elseif isstring( ent:GetTable()[ var[ 1 ] ] ) then
				count = count + 1				
				local val = colCatSP:ANPlus_CreateTextEntry( 5, ( count * height ) - 20, 200, 15, ent:GetTable()[ var[ 1 ] ], Color( 200, 200, 200, 255 ), false, var[ 3 ] || "" )
				local valLab = colCatSP:ANPlus_CreateLabel( 8, ( count * height - 2 ) - 20, 200, var[ 2 ], Color( 200, 200, 200, 255 ) )
				function val:OnEnter( sVal )
					var[ 10 ] = sVal
				end	
				function val:OnGetFocus()
					valLab:SetWidth( 1 )
					val:SetText( ent:GetTable()[ var[ 1 ] ] )
				end	
				function val:OnLoseFocus()
					valLab:SetWidth( 200 )
				end				
			end
		end
	end
	
	colCat:Toggle()
	
	local save = dFrame:ANPlus_CreateButton( 225, 5, 50, 20, 8, Color( 200, 200, 200, 255 ), "Apply", Color ( 100, 100, 100, 255 ), "Apply all of the changes." )
	function save:OnCursorEntered()
		function save:Paint(w, h)
			draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
		end
		ANPlusUISound( "ANP.UI.Hover" )
	end
	function save:OnCursorExited()
		function save:Paint(w, h)
			draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
		end
	end
	function save:DoClick()
		ANPlusUISound( "ANP.UI.Click" )
		
		for _, var in pairs( tab ) do 
			if var then
				ent:GetTable()[ var[ 1 ] ] = var[ 10 ] || ent:GetTable()[ var[ 1 ] ]
				if ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'] != nil then	
					ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'](ent, var[ 1 ], ply)			
				end
			end
		end
		
		--ent:ANPlusHaloEffect( Color( 255, 255, 0 ), 5, 0.5 )
		
		net.Start( "anplus_propmenu" )
		net.WriteEntity( ent )
		net.WriteTable( tab )
		net.SendToServer() 	
		
		timer.Simple( 0.2, function() 
			if !IsValid(dFrame) then return end
			dFrame:Close()
		end )
		
	end
	
	local cancel = dFrame:ANPlus_CreateButton( 225, 30, 50, 20, 8, Color( 200, 200, 200, 255 ), "Close", Color ( 100, 100, 100, 255 ), "Close the interface." )
	function cancel:OnCursorEntered()
		function cancel:Paint(w, h)
			draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
		end
		ANPlusUISound( "ANP.UI.Hover" )
	end
	function cancel:OnCursorExited()
		function cancel:Paint(w, h)
			draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
		end
	end
	function cancel:DoClick()
		ANPlusUISound( "ANP.UI.Click" )
		dFrame:Close()
	end
	
	dFrame:ShowCloseButton( false )
end