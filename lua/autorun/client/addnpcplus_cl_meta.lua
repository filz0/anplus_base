------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local metaPanel = FindMetaTable("Panel")
local metaPLAYER = FindMetaTable("Player")

function ANPlusUISound(snd)
	EmitSound( snd, Vector( 0 ,0 ,0 ), -2 )
end

function metaPanel:ANPlusHighlightTextColor(newCol, timed, defCol)		
	self:SetTextColor( newCol )			
	timer.Simple( timed, function()			
		if !IsValid(self) then return end			
		self:SetTextColor( defCol )				
	end)	
end

function metaPanel:ANPlus_CreateButton(x, y, w, h, r, color, text, txtcolor, tooltp)
	local panel = vgui.Create( "DButton", self )
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	panel:SetText( text )
	panel:SetTextColor( txtcolor || Color( 255, 255, 255, 255 ) )
	panel:SetFont( "DermaDefaultBold" )
	if tooltp then panel:SetTooltip( tooltp ) end
	if r then
		function panel:Paint(w, h)
			draw.RoundedBox( r, 0, 0, w, h, color )
		end
	end
	return panel
end

function metaPanel:ANPlus_CreateNumberWang(x, y, w, h, val, deci, mins, maxs, tooltp)
	local panel = vgui.Create( "DNumberWang", self )
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	panel:SetMin( mins )
	panel:SetMax( maxs )			
	panel:SetValue( val )			
	panel:SetDecimals( deci )
	if tooltp then panel:SetTooltip( tooltp ) end
	return panel
end

function metaPanel:ANPlus_CreateNumberScratch(x, y, val, deci, mins, maxs, tooltp)
	local panel = vgui.Create( "DNumberScratch", self )
	if x && y then panel:SetPos( x, y ) end
	panel:SetMin( mins )
	panel:SetMax( maxs )			
	panel:SetValue( val )					
	panel:SetDecimals( deci )
	if tooltp then panel:SetTooltip( tooltp ) end
	return panel
end

function metaPanel:ANPlus_CreateLabel(x, y, w, text, color, font)
	local panel = vgui.Create( "DLabel", self )
	if x && y then panel:SetPos( x, y ) end
	panel:SetWidth( w )
	panel:SetText( text )
	panel:SetFont( font || "DermaDefaultBold" )
	panel:SetTextColor( color )	
	return panel
end

function metaPanel:ANPlus_CreateListView(x, y, w, h, multisel, sort, columntab, tooltp, title)
	local panel = vgui.Create( "DListView", self ) 
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	panel:SetMultiSelect( multisel )
	if tooltp then panel:SetTooltip( tooltp ) end
	panel:SetSortable( sort )
	for i = 1, columntab && #columntab || -1 do
		local column = columntab[ i ]
		if column[ 2 ] then
			panel:AddColumn( column[ 1 ] ):SetWidth( column[ 2 ] )
		else
			panel:AddColumn( column[ 1 ] )
		end
	end	
	if title then
		local panelN = vgui.Create( "DListView", self ) 
		local pX, pY = panel:GetPos()
		panelN:SetPos( pX, pY - 17 )
		local pW, pH = panel:GetSize()
		panelN:SetSize( pW, 18 )
		if tooltp then panelN:SetTooltip( tooltp ) end
		panelN:AddColumn( title )
	end
	return panel
end

function metaPanel:ANPlus_CreateTextEntry(x, y, w, h, deftext, txtcolor, font, tooltp)
	local panel = vgui.Create( "DTextEntry", self ) 
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	panel:SetFont( font || "DermaDefaultBold" )
	if tooltp then panel:SetTooltip( tooltp ) end
	panel:SetTextColor( txtcolor || Color( 255, 255, 255, 255 ) )
	panel:SetText( deftext )
	return panel
end

function metaPanel:ANPlus_CreateCheckBox(x, y, state, tooltp)
	local panel = vgui.Create( "DCheckBox", self ) 
	if x && y then panel:SetPos( x, y ) end
	if tooltp then panel:SetTooltip( tooltp ) end
	panel:SetValue( state )
	return panel
end

function metaPanel:ANPlus_CreateCheckBoxLabel(x, y, label, txtcolor, state, tooltp)
	local panel = vgui.Create( "DCheckBoxLabel", self ) 
	if x && y then panel:SetPos( x, y ) end
	panel:SetTextColor( txtcolor || Color( 255, 255, 255, 255 ) )
	panel:SetText( label )
	if tooltp then panel:SetTooltip( tooltp ) end
	panel:SetValue( state )
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	return panel
end

function metaPanel:ANPlus_CreateCollapsibleCategory(x, y, w, h, expanded, label, tooltp)
	local panel = vgui.Create( "DCollapsibleCategory", self )
	panel:SetLabel( label )	
	panel:SetExpanded( expanded )
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	if tooltp then panel:SetTooltip( tooltp ) end
	if r then
		function panel:Paint(w, h)
			draw.RoundedBox( r, 0, 0, w, h, color )
		end
	end
	
	return panel
end

function metaPanel:ANPlus_CreateImage(x, y, w, h, image, color, keepAspect, tooltp)
	local panel = vgui.Create( "DImage", self ) 
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	panel:SetImage( image, "vgui/anp_ico.png" )
	panel:SetImageColor( color || Color( 255, 255, 255, 255 ) )
	panel:SetKeepAspect( keepAspect || true )
	if tooltp then panel:SetTooltip( tooltp ) end
	return panel
end

function metaPanel:ANPlus_ComboBox(x, y, w, h, deftext, txtcolor, font, tooltp)
	local panel = vgui.Create( "DComboBox", self ) 
	if x && y then panel:SetPos( x, y ) end
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
	end
	panel:SetFont( font )
	if tooltp then panel:SetTooltip( tooltp ) end
	panel:SetTextColor( txtcolor || Color( 255, 255, 255, 255 ) )
	panel:SetValue( deftext )
	return panel
end

function metaPanel:ANPlus_AdjustPos(x, y)
	local pX, pY = self:GetPos()
	self:SetPos( pX + x, pY + y )
end

function metaPanel:ANPlus_AdjustSize(w, h)
	local pW, pH = self:GetSize()
	self:SetSize( pW + w, pH + h )
end

function metaPanel:ANPlus_AdjustWidth(w)
	local pW = self:GetSize()
	self:SetWidth( pW + w )
end


function metaPanel:ANPlus_MenuSeparator(tittle)
	local panel = vgui.Create( "DCategoryList", self )
	panel:Dock( TOP )
	panel:Add( tittle || "" )
	return panel
end

function metaPanel:ANPlus_SecureMenuItem(callback, help, deniedMsg)
	if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
		local deniedMsg = deniedMsg || "ACCESS DENIED"
		local nope = self:AddControl( "Label", { Text = deniedMsg })
		if help then self:ControlHelp( help ) end
		return nope
	else
		if isfunction( callback ) then callback() end
		if help then self:ControlHelp( help ) end
	end
end

function metaPanel:ANPlus_MenuItem(callback, help)
	if isfunction( callback ) then callback() end
	if help then self:ControlHelp( help ) end
end

local defFov = GetConVar( "fov_desired" )

render.ANPlusDrawSpriteParallax = function(pos, widthMin, heightMin, widthMax, heightMax, dist, color)
	local ply = LocalPlayer()	
	local viewEnt = ply:GetViewEntity()	
	local dSqr, d = ANPlusGetRangeVector( viewEnt:GetPos(), pos )	
	local transFov = math.Remap( ply:GetFOV(), 0, defFov:GetFloat(), 0, 1 )
	local w = math.Remap( d * transFov, 1, dist, widthMin, widthMax )
	w = math.Round( w, 1 )
	w = math.Clamp( w, widthMin, widthMax )
	local h = math.Remap( d * transFov, 1, dist, heightMin, heightMax )
	h = math.Round( h, 1 )
	h = math.Clamp( h, heightMin, heightMax )
	render.DrawSprite( pos, w, h, color )
end

render.ANPlusDrawBeamTrail = function(ent, attachmentID, offsetVec, color, width, startSize, endSize, length, spacing, stretch )

	offsetVec = offsetVec || Vector( 0, 0, 0 )
	spacing = spacing || 0
	local pos, ang = nil, nil
	
	if attachmentID && attachmentID > 0 then		
		local attTab = ent:GetAttachment( attachmentID )
		pos, ang = LocalToWorld( offsetVec, Angle( 0, 0, 0 ), attTab.Pos, attTab.Ang )
	else
		pos, ang = LocalToWorld( offsetVec, Angle( 0, 0, 0 ), ent:GetPos(), ent:GetAngles() )
		attachmentID = 0
	end

	ent['m_vOldPos_att'..attachmentID] = !ent['m_vOldPos_att'..attachmentID] && pos || Lerp( FrameTime() * 2, ent['m_vOldPos_att'..attachmentID], pos )

	local boxSize = 2
	local static = pos:WithinAABox( ent['m_vOldPos_att'..attachmentID] - Vector( boxSize, boxSize, boxSize ), ent['m_vOldPos_att'..attachmentID] + Vector( boxSize, boxSize, boxSize ) )
	
	if !static then
		
		local gScale = 2 + ( -1 * game.GetTimeScale() )
		
		if spacing == 0 || ( ent['m_fLastAdd_att'..attachmentID] || 0 ) < CurTime() then
			table.insert( ent['m_tPoints_att'..attachmentID], pos )
			ent['m_fLastAdd_att'..attachmentID] = CurTime() + ( spacing / 1000 )		
		end
		
		local count = #ent['m_tPoints_att'..attachmentID]
		
		if spacing > 0 then
			length = math.ceil( math.abs( length - spacing ) )
		end

		render.StartBeam( count )
			for i, point in pairs( ent['m_tPoints_att'..attachmentID] ) do
				local width = ( i / ( length / startSize ) ) 
				local coord = ( 1 / count ) * ( i - 1 )

				render.AddBeam( i == count && pos || point, width + endSize, stretch && coord || width, color )
			end
		render.EndBeam()

		if count >= length then
			table.remove( ent['m_tPoints_att'..attachmentID], 1 )
		end
	else
		ent['m_tPoints_att'..attachmentID] = {}
	end
end

local offset	=	ScreenScale( 256 )
local blur		=	Material( "pp/blurscreen" )

local function PlayerVisionSuppress()
	local ply = LocalPlayer()
	local scrW = ScrW()
	local scrH = ScrH()
	local offx = scrW + offset
	local offy = scrH + offset
	local texW = ply.anpOTab.suppressGWidth || ScrW()
	local texH = ply.anpOTab.suppressGHeight || ScrH()
	local fadeout = 1 / 1 * ply.anpOTab.suppressDuration / 100

	if texW <= offx then
		--texW = Lerp( FrameTime() * ply.suppressNextFadeout, texW, offx )
		texW = math.min( texW + fadeout, offx )
	end

	if texH <= offy then
		--texH = Lerp( FrameTime() * ply.suppressNextFadeout, texH, offy )
		texH = math.min( texH + fadeout, offy )
	end
		
	if ply.anpOTab.suppressGMat then
		ply.anpOTab.suppressGColor.a = math.max( ply.anpOTab.suppressGColor.a - fadeout, 0 )
		surface.SetDrawColor( ply.anpOTab.suppressGColor )
		surface.SetMaterial( ply.anpOTab.suppressGMat )
		surface.DrawTexturedRect( scrW / 2 - texW / 2, scrH / 2 - texH / 2, texW, texH )
	end
	
	if ply.anpOTab.suppressBLayers > 0 then
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( blur )
		if ply.anpOTab.suppressBScatter || 0 > 0 then
			for i = 1, ply.anpOTab.suppressBLayers || 0 do
				blur:SetFloat( "$blur", ( i / ply.anpOTab.suppressBLayers ) * ply.anpOTab.suppressBScatter )
				blur:Recompute()
				render.UpdateScreenEffectTexture()			
				surface.DrawTexturedRect( 0, 0, scrW, scrH )
			end
		end		
		ply.anpOTab.suppressBScatter = math.max( ply.anpOTab.suppressBScatter - fadeout, 0 )
		if ply.anpOTab.suppressBLayers > 1 && ply.anpOTab.suppressBScatter <= 0 then ply.anpOTab.suppressBLayers = math.max( ply.anpOTab.suppressBLayers - fadeout, 0 ) end		
	end
	
	ply.anpOTab.suppressGWidth 	= texW
	ply.anpOTab.suppressGHeight	= texH

	if ply.anpOTab.suppressDuration + ply.anpOTab.suppressStartTime <= CurTime() then
		ply.anpOTab = nil
		hook.Remove( "HUDPaint", "ANPlusLoad_OVERLAY_PlayerVisionSuppress" )
	end
end

function render.ANPlusDrawOverlay( effectName, tab )
	local ply = LocalPlayer()
	if effectName == "suppress" && tab then
		tab.suppressGWidth		= ScrW() + ( tab['Offset'] || 0 )
		tab.suppressGHeight		= ScrH() + ( tab['Offset'] || 0 )
		tab.suppressGMat		= tab['Texture'] && Material( tab['Texture'] ) || Material( "effects/anp/vignette.png" )
		tab.suppressGColor		= tab['Color'] || Color( 255, 255, 255, 255 )
		tab.suppressBLayers 	= tab['Strength'] || 1
		tab.suppressBScatter 	= tab['Scatter'] || 1
		tab.suppressNextFadeout	= tab['Fadeout'] || 1
		tab.suppressDuration	= tab['Duration'] || 50
		tab.suppressStartTime	= CurTime()
		ply.anpOTab 			= tab
		hook.Add( "HUDPaint", "ANPlusLoad_OVERLAY_PlayerVisionSuppress", PlayerVisionSuppress )
	end
end