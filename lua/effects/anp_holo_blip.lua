function EFFECT:Init( data )

	self.Target = data:GetEntity()
	self.Color = data:GetStart() -- to do
	self.Size = data:GetScale() -- to do
	self.Length = data:GetMagnitude() -- to do
	self.StartTime = CurTime()

end

function EFFECT:Think()
	
	if ( !IsValid( self.Target ) ) then self.Target = nil return end
	
	return self.StartTime + self.Length > CurTime()

end

function EFFECT:Render()

	if ( !IsValid( self.Target ) ) then self.Target = nil return end

	local delta = ( ( CurTime() - self.StartTime ) / self.Length ) ^ 0.5
	local idelta = 1 - delta

	halo.Add( { self.Target }, Color( self.Color.x, self.Color.y, self.Color.z, 255 * idelta ), self.Size, self.Size, 1, true, false )

end

effects.Register( EFFECT, "anp_holo_blip" )