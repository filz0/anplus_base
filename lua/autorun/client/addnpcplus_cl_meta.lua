local metaPanel = FindMetaTable("Panel")

local scrWidth = 1920
local scrHeight = 1080

local multX = ScrW() / scrWidth
local multY = ScrH() / scrHeight

function ANPlusUISound(snd)
	EmitSound( snd, Vector( 0 ,0 ,0 ), -2 )
end

function metaPanel:ANPlusHighlightTextColor(color1, timed, color2)		
	self:SetTextColor( color1 )			
	timer.Create("SAM_UI_Normal", timed, 1, function()			
		if !IsValid(self) then return end			
		self:SetTextColor( color2 )				
	end)	
end

function metaPanel:ANPlus_CreateButton(x, y, w, h, r, color, text, txtcolor, tooltp)
	local panel = vgui.Create( "DButton", self )
	panel:SetPos( x, y )
	panel:SetSize( w, h )
	panel:SetText( text )
	panel:SetTextColor( txtcolor )
	panel:SetFont( "DermaDefaultBold" )
	panel:SetTooltip( tooltp )	
	function panel:Paint(w, h)
		draw.RoundedBox( r, 0, 0, w, h, color )
	end
	return panel
end

function metaPanel:ANPlus_CreateNumberWang(x, y, w, h, val, deci, mins, maxs, tooltp)
	local panel = vgui.Create( "DNumberWang", self )
	panel:SetPos( x, y )
	panel:SetSize( w, h )
	panel:SetMin( mins )
	panel:SetMax( maxs )			
	panel:SetValue( val )			
	panel:SetDecimals( deci )
	panel:SetTooltip( tooltp )
	return panel
end

function metaPanel:ANPlus_CreateLabel(x, y, w, text, color, font)
	local panel = vgui.Create( "DLabel", self )
	panel:SetPos( x, y )
	panel:SetWidth( w )
	panel:SetText( text )
	panel:SetFont( font )
	panel:SetTextColor( color )	
	return panel
end

function metaPanel:ANPlus_CreateListView(x, y, w, h, multisel, sort, columntab, tooltp)
	local panel = vgui.Create( "DListView", self ) 
	panel:SetPos( x, y )
	panel:SetSize( w, h )
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
	return panel
end

function metaPanel:ANPlus_CreateTextEntry(x, y, w, h, deftext, txtcolor, font, tooltp)
	local panel = vgui.Create( "DTextEntry", self ) 
	panel:SetPos( x, y )
	panel:SetSize( w, h )
	panel:SetFont( font )
	panel:SetTooltip( tooltp )
	panel:SetTextColor( txtcolor )
	panel:SetText( deftext )
	return panel
end

function metaPanel:ANPlus_CreateCheckBox(x, y, state, tooltp)
	local panel = vgui.Create( "DCheckBox", self ) 
	panel:SetPos( x, y )
	panel:SetTooltip( tooltp )
	panel:SetValue( state )
	return panel
end