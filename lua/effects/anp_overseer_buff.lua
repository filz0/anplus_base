function EFFECT:Init( data )

	self.Target = data:GetEntity()
	self.Length = data:GetMagnitude() -- to do
	self.StartTime = CurTime()
end

function EFFECT:Think()
	
	if ( !IsValid( self.Target ) ) then self.Target = nil return end
	
	return self.StartTime + self.Length > CurTime()

end

local icon = Material( "effects/overseer_buff.png" )
function EFFECT:Render()

	if ( !IsValid( self.Target ) ) then self.Target = nil return end

	local ply = LocalPlayer()
	local bananalevitate = math.sin( CurTime() * 3 ) * ( 1 * 2 )
		
	local dir = ( self.Target:GetPos() - ply:GetPos() ):Angle()
	
	local offsetVec = Vector( 0, 0, 40 + bananalevitate )
	local offsetAng = Angle( 0, -90 + dir.y, 90 )
	
	local newPos, newAng = LocalToWorld( offsetVec, offsetAng, self.Target:GetPos() + self.Target:OBBCenter() * 1.1, Angle( 0, 0, 0 ) ) 
	
	cam.Start3D2D( newPos, newAng, 1 )
		
		surface.SetDrawColor( 255, 50, 100, 200 ) -- Set the drawing color
		surface.SetMaterial( icon ) -- Use our cached material
		surface.DrawTexturedRect( -7.5, -10, 12, 14 ) -- Actually draw the rectangle
		
	cam.End3D2D()

end