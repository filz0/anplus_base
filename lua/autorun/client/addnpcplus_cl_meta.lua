------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

local metaPanel = FindMetaTable("Panel")

local scrWidth = 1920
local scrHeight = 1080

function ANPlusGetFixedScreenW()
	return ScrW() / scrWidth
end

function ANPlusGetFixedScreenH()
	return ScrH() / scrHeight
end

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
	panel:SetTextColor( txtcolor )
	panel:SetFont( "DermaDefaultBold" )
	panel:SetTooltip( tooltp )	
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
	panel:SetTooltip( tooltp )
	return panel
end

function metaPanel:ANPlus_CreateLabel(x, y, w, text, color, font)
	local panel = vgui.Create( "DLabel", self )
	if x && y then panel:SetPos( x, y ) end
	panel:SetWidth( w )
	panel:SetText( text )
	panel:SetFont( font )
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
	panel:SetTooltip( tooltp )
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
		panelN:SetTooltip( tooltp )
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
	panel:SetFont( font )
	panel:SetTooltip( tooltp )
	panel:SetTextColor( txtcolor )
	panel:SetText( deftext )
	return panel
end

function metaPanel:ANPlus_CreateCheckBox(x, y, state, tooltp)
	local panel = vgui.Create( "DCheckBox", self ) 
	if x && y then panel:SetPos( x, y ) end
	panel:SetTooltip( tooltp )
	panel:SetValue( state )
	return panel
end

function metaPanel:ANPlus_CreateCheckBoxLabel(x, y, text, txtcolor, state, tooltp)
	local panel = vgui.Create( "DCheckBoxLabel", self ) 
	if x && y then panel:SetPos( x, y ) end
	panel:SetTextColor( txtcolor )
	panel:SetText( text )
	panel:SetTooltip( tooltp )
	panel:SetValue( state )
	if isnumber( w ) && isnumber( h ) then
		panel:SetSize( w, h ) 
	elseif isbool( w ) && isbool( h ) && w == true && h == true then 
		panel:SizeToContents()
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
	panel:SetTooltip( tooltp )
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
	panel:SetTooltip( tooltp )
	panel:SetTextColor( txtcolor )
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
	
	if attachmentID && attachmentID != -1 then		
		local attTab = ent:GetAttachment( attachmentID )
		pos, ang = LocalToWorld( offsetVec, Angle( 0, 0, 0 ), attTab.Pos, attTab.Ang )
	else
		pos, ang = LocalToWorld( offsetVec, Angle( 0, 0, 0 ), ent:GetPos(), ent:GetAngles() )
		attachmentID = -1
	end
	
	ent['m_vOldPos_att'..attachmentID] = !ent['m_vOldPos_att'..attachmentID] && pos || Lerp( FrameTime() * 2, ent['m_vOldPos_att'..attachmentID], pos )

	local boxSize = 2
	local static = pos:WithinAABox( ent['m_vOldPos_att'..attachmentID] - Vector( boxSize, boxSize, boxSize ), ent['m_vOldPos_att'..attachmentID] + Vector( boxSize, boxSize, boxSize ) )
	
	if not static then
		
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
