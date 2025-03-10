------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#
AddCSLuaFile()

local ENT = FindMetaTable("Entity")
--[[
net.Receive( "anplus_add_fakename_language", function()
	local name = net.ReadString()
	if name then
		if language.GetPhrase( name ) == name then 
			language.Add( name, name ) 
		end
	end	
end )
]]--
net.Receive( "anplus_fix_bones", function()

	local ent = net.ReadEntity()

	if IsValid(ent) then

		ent:SetupBones() 
		ent:DestroyShadow()
		
	end
	
end )

net.Receive( "anplus_holo_eff", function()

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

end )

net.Receive( "anplus_net_entity", function()
	local ent = net.ReadEntity()
	local id = net.ReadString()

	if ent then
		ent:ANPlusNPCApply( id )	
	end
end )

net.Receive( "anplus_data_tab", function()

	local ent = net.ReadEntity()
	local tab = net.ReadTable()
	
	if ent && ent['ANPlusData'] && tab then
		table.Merge( ent['ANPlusData'], tab )
	end
end )


net.Receive( "anplus_client_particle_start", function()

	local ent = net.ReadEntity()
	local effect = net.ReadString()
	local partAttachment = net.ReadFloat()
	local entAttachment = net.ReadFloat()
	local offset = net.ReadVector()
	local stop = net.ReadBool()

	if IsValid(ent) then
		ent:ANPlusClientParticleSystem( stop, effect, partAttachment, entAttachment, offset )
	end
end )

net.Receive( "anplus_client_particle_start_no_ent", function()

	local effect = net.ReadString()
	local pos = net.ReadVector()
	local ang = net.ReadAngle()

	ANPlusClientParticleSystem( effect, pos, ang )

end )

net.Receive( "anplus_paint_decal", function()
	local ent = net.ReadEntity()
	local decal = net.ReadString()
	local sP = net.ReadVector()
	local eP = net.ReadVector()
	local col = net.ReadColor()
	local w = net.ReadFloat()
	local h = net.ReadFloat()
	local mat = string.find( decal, "decals/" ) && Material( decal ) || Material( util.DecalMaterial( decal ) )
	util.DecalEx( mat, ent, sP, eP, col, w, h )
end )

net.Receive( "anplus_play_ui_snd", function()		
	local snd = net.ReadString() || ""
	local vol = net.ReadFloat() || 100
	ANPlusEmitUISound( nil, snd, vol )
end )

net.Receive( "anplus_notify", function()		
	local snd = net.ReadString() || ""
	local text = net.ReadString() || ""
	local type = net.ReadFloat()
	local length = net.ReadFloat()	
	ANPlusSendNotify( nil, snd, text, type, length )		
end )

net.Receive( "anplus_chatmsg_ply", function()	
	local snd = net.ReadString() || ""
	local color = net.ReadColor() || ""
	local text = net.ReadString()
	ANPlusMSGPlayer( nil, text, color, snd )
end )

net.Receive( "anplus_screenmsg_ply", function()
	local dur = net.ReadFloat()
	local x = net.ReadFloat()
	local y = net.ReadFloat()
	local size = net.ReadFloat()
	local font = net.ReadString()
	local color = net.ReadColor()
	local text = net.ReadString()	
	local id = net.ReadString()	
	ANPlusScreenMsg( nil, id, x, y, size, dur, text, font, color)
end )

net.Receive( "anplus_savedata_net", function()	
	local ent = net.ReadEntity()
	local data = net.ReadTable()
	if IsValid(ent) && data then table.Merge( ent, data ) end
end )

net.Receive( "anplus_add_caption", function()	
	local text = net.ReadString()
	local dur = net.ReadFloat()	
	local fromPly = net.ReadBool()	
	ANPlusAddCaption( nil, text, dur, fromPly )
end )

function ENT:ANPlusNPCHUDPaint()
	if self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['OnNPCHUDPaint'] != nil then
		self:ANPlusGetDataTab()['Functions']['OnNPCHUDPaint'](self)
	end
end

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

local ccm_DCol = Color( 200, 200, 200, 255 )
local ccm_BTCol = Color ( 100, 100, 100, 255 )
local ccm_BHCol = Color( 150, 150, 150, 255 )

function ENT:ANPlusCustomConfigMenu()
		
	local ply = LocalPlayer()
	local ent = self
	local tab = ent['m_tSaveDataMenu']
	if !tab then ANPlusUISound( "ANP.UI.Error" ); print("Couldn't load variables, aborting...") return end

	ANPlusUISound( "ANP.UI.Open" )
	
	local dFrame = vgui.Create( "DFrame" )
		dFrame:SetTitle( "" )
		dFrame:SetSize( 225, 75 )
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
	
	
	local colCat = dFrame:ANPlus_CreateCollapsibleCategory( 5, 30, 215, 50, false, "List Of Editable Variables (CLICK)", "Use this list to edit certain things about this entity." )
	function colCat:OnToggle( bool )	

		if bool == true then		
			ANPlusUISound( "ANP.UI.List.Open" )	
			timer.Simple( colCat:GetAnimTime() + 0.1, function()
				if !dFrame then return end
				local w, h = colCat:GetSize()
				h = h + 10 < 55 && 95 || h + 10 >= 55 && h + 35
				dFrame:SetSize( 225, h )
			end )
		elseif bool == false then		
			ANPlusUISound( "ANP.UI.List.Close" )		
			timer.Simple( colCat:GetAnimTime() + 0.1, function()
				if !dFrame then return end
				dFrame:SetSize( 225, 55 )
			end )
		end		
	end
	
	local colCatSP = vgui.Create( "DScrollPanel", dFrame )
	colCatSP:SetSize( 235, 250 )
	colCat:SetContents( colCatSP )
	
	local count = 0
	local height = 20
	
	if ent:IsANPlus(true) then colCatSP:ANPlus_CreateLabel( 5, ( height - 2 ) - 20, 200, "[ Custom Variables ]-----------------", ccm_DCol ); count = 1 end
	
	for _, var in ipairs( tab ) do 
		if var then			
			if isstring( ent[ var['Variable'] ] ) && ent[ var['Variable'] ] == "Category" && var['Label'] then
				count = count + 1
				colCatSP:ANPlus_CreateLabel( 5, ( count * height - 2 ) - 20, 200, var['Label'], ccm_DCol )
			elseif isbool( ent[ var['Variable'] ] ) then
				count = count + 1				
				local val = colCatSP:ANPlus_CreateCheckBoxLabel( 5, ( count * height ) - 20, var['Label'], false, ent[ var['Variable'] ], var['Description'] || "" )
				function val:OnChange( bVal )
					var['ValueNew'] = bVal
				end
			elseif isnumber( ent[ var['Variable'] ] ) then
				count = count + 1
				local valLab = colCatSP:ANPlus_CreateLabel( 29, ( count * height - 2 ) - 20, 200, var['Label'], color_white, "DermaDefault" )
				local val = colCatSP:ANPlus_CreateNumberScratch( 5, ( count * height ) - 20, ent[ var['Variable'] ], var['Decimals'] || 0, var['Min'] || 0, var['Max'] || 1, var['Description'] || "" )
				function val:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					var['ValueNew'] = nVal
				end				
			elseif isstring( ent[ var['Variable'] ] ) then
				count = count + 1	
				local valLab = colCatSP:ANPlus_CreateLabel( 8, ( count * height - 2 ) - 20, 200, var['Label'] .. ":", color_white, "DermaDefault" )
				count = count + 1
				local val = colCatSP:ANPlus_CreateTextEntry( 5, ( count * height ) - 20, 205, 15, ent[ var['Variable'] ], color_black, false, var['Description'] || "" )				
				function val:OnEnter( sVal )
					var['ValueNew'] = sVal
					val:ANPlusHighlightTextColor( Color( 0, 255, 0, 255 ), 0.5, color_black )
				end	
				function val:OnLoseFocus()
					var['ValueNew'] = val:GetText()
					val:ANPlusHighlightTextColor( Color( 0, 255, 0, 255 ), 0.5, color_black )
				end	
				function val:OnChange()
					var['ValueNew'] = val:GetText()
					timer.Create( "Timer_ANPlusCustomConfigMenu_TextCheck", 0.7, 1, function()
						if !IsValid(dFrame) then return end
						val:ANPlusHighlightTextColor( Color( 0, 255, 0, 255 ), 0.5, color_black )
					end )
				end		
			elseif isvector( ent[ var['Variable'] ] ) then
				count = count + 1	
				local valLab = colCatSP:ANPlus_CreateLabel( 8, ( count * height - 2 ) - 20, 200, var['Label'] .. ":", color_white, "DermaDefault" )
				count = count + 1

				local valLab = colCatSP:ANPlus_CreateLabel( 8, ( count * height - 2 ) - 20, 10, "X:", color_white, "DermaDefault" )
				local valX = colCatSP:ANPlus_CreateNumberScratch( 19, ( count * height ) - 20, ent[ var['Variable'] ].x, var['Decimals'] || 0, var['Min'].x || 0, var['Max'].x || 1, var['Description'] || "" )
				function valX:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					local y = var['ValueNew'] && var['ValueNew'].y || ent[ var['Variable'] ].y
					local z = var['ValueNew'] && var['ValueNew'].z || ent[ var['Variable'] ].z
					var['ValueNew'] = Vector( nVal, y, z )
				end	
				
				local valLab = colCatSP:ANPlus_CreateLabel( 38, ( count * height - 2 ) - 20, 10, "Y:", color_white, "DermaDefault" )
				local valY = colCatSP:ANPlus_CreateNumberScratch( 49, ( count * height ) - 20, ent[ var['Variable'] ].y, var['Decimals'] || 0, var['Min'].y || 0, var['Max'].y || 1, var['Description'] || "" )
				function valY:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					local x = var['ValueNew'] && var['ValueNew'].x || ent[ var['Variable'] ].x
					local z = var['ValueNew'] && var['ValueNew'].z || ent[ var['Variable'] ].z
					var['ValueNew'] = Vector( x, nVal, z )
				end	
				
				local valLab = colCatSP:ANPlus_CreateLabel( 68, ( count * height - 2 ) - 20, 10, "Z:", color_white, "DermaDefault" )
				local valZ = colCatSP:ANPlus_CreateNumberScratch( 79, ( count * height ) - 20, ent[ var['Variable'] ].z, var['Decimals'] || 0, var['Min'].z || 0, var['Max'].z || 1, var['Description'] || "" )
				function valZ:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					local x = var['ValueNew'] && var['ValueNew'].x || ent[ var['Variable'] ].x
					local y = var['ValueNew'] && var['ValueNew'].y || ent[ var['Variable'] ].y
					var['ValueNew'] = Vector( x, y, nVal )
				end	
			elseif isangle( ent[ var['Variable'] ] ) then
				count = count + 1	
				local valLab = colCatSP:ANPlus_CreateLabel( 8, ( count * height - 2 ) - 20, 200, var['Label'] .. ":", color_white, "DermaDefault" )
				count = count + 1

				local valLab = colCatSP:ANPlus_CreateLabel( 8, ( count * height - 2 ) - 20, 10, "P:", color_white, "DermaDefault" )
				local valX = colCatSP:ANPlus_CreateNumberScratch( 19, ( count * height ) - 20, ent[ var['Variable'] ].x, var['Decimals'] || 0, var['Min'].x || 0, var['Max'].x || 1, var['Description'] || "" )
				function valX:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					local y = var['ValueNew'] && var['ValueNew'].y || ent[ var['Variable'] ].y
					local z = var['ValueNew'] && var['ValueNew'].z || ent[ var['Variable'] ].z
					var['ValueNew'] = Angle( nVal, y, z )
				end	
				
				local valLab = colCatSP:ANPlus_CreateLabel( 38, ( count * height - 2 ) - 20, 10, "Y:", color_white, "DermaDefault" )
				local valY = colCatSP:ANPlus_CreateNumberScratch( 49, ( count * height ) - 20, ent[ var['Variable'] ].y, var['Decimals'] || 0, var['Min'].y || 0, var['Max'].y || 1, var['Description'] || "" )
				function valY:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					local x = var['ValueNew'] && var['ValueNew'].x || ent[ var['Variable'] ].x
					local z = var['ValueNew'] && var['ValueNew'].z || ent[ var['Variable'] ].z
					var['ValueNew'] = Angle( x, nVal, z )
				end	
				
				local valLab = colCatSP:ANPlus_CreateLabel( 68, ( count * height - 2 ) - 20, 10, "R:", color_white, "DermaDefault" )
				local valZ = colCatSP:ANPlus_CreateNumberScratch( 79, ( count * height ) - 20, ent[ var['Variable'] ].z, var['Decimals'] || 0, var['Min'].z || 0, var['Max'].z || 1, var['Description'] || "" )
				function valZ:OnValueChanged( nVal )					
					nVal = math.Round( nVal, var['Decimals'] || 0 )
					local x = var['ValueNew'] && var['ValueNew'].x || ent[ var['Variable'] ].x
					local y = var['ValueNew'] && var['ValueNew'].y || ent[ var['Variable'] ].y
					var['ValueNew'] = Angle( x, y, nVal )
				end	
			end
		end
	end
	
	colCat:Toggle()
	
	local save = dFrame:ANPlus_CreateButton( 5, 5, 50, 20, 8, ccm_DCol, "Apply", ccm_BTCol, "Apply all of the changes." )
	function save:OnCursorEntered()
		function save:Paint(w, h)
			draw.RoundedBox( 8, 3, 3, w - 6, h - 6, ccm_BHCol )
		end
		ANPlusUISound( "ANP.UI.Hover" )
	end
	function save:OnCursorExited()
		function save:Paint(w, h)
			draw.RoundedBox( 8, 0, 0, w, h, ccm_DCol )
		end
	end
	function save:DoClick()
		ANPlusUISound( "ANP.UI.Click" )
		
		for _, var in pairs( tab ) do 
			if var then
				ent[ var['Variable'] ] = var['ValueNew'] || var['ValueNew'] != false && ent[ var['Variable'] ]
				
				if ent:IsANPlus(true) && ent:ANPlusGetDataTab()['Functions'] && ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'] != nil then	  
					ent:ANPlusGetDataTab()['Functions']['OnNPCPropertyMenuApplyVar'](ent, var['Variable'], ply)			
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
	
	local cancel = dFrame:ANPlus_CreateButton( 170, 5, 50, 20, 8, ccm_DCol, "Close", ccm_BTCol, "Close the interface." )
	function cancel:OnCursorEntered()
		function cancel:Paint(w, h)
			draw.RoundedBox( 8, 3, 3, w - 6, h - 6, ccm_BHCol )
		end
		ANPlusUISound( "ANP.UI.Hover" )
	end
	function cancel:OnCursorExited()
		function cancel:Paint(w, h)
			draw.RoundedBox( 8, 0, 0, w, h, ccm_DCol )
		end
	end
	function cancel:DoClick()
		ANPlusUISound( "ANP.UI.Click" )
		dFrame:Close()
	end
	
	dFrame:ShowCloseButton( false )
end

function ANPlusGetAll()

	local entsAround = ents.GetAll()
	local entsSelected = {}
	local count = 1

	for i = 1, #entsAround do
	
		if !entsAround[ i ]:IsNPC() && !entsAround[ i ]:IsPlayer() then continue end
		
		local v = entsAround[ i ]
		-- && v:GetKeyValues()['sleepstate'] == 0 && !IsValid(v:GetInternalVariable( "m_hCine" ))
		if ( v:IsNPC() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "generic_actor" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && v:ANPlusAlive() ) || ( v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) then
			
			entsSelected[count] = v
			count = count + 1

		end
		
	end

	return entsSelected
	
end