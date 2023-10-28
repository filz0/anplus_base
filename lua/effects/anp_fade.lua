function EFFECT:Init( data )
	self.Entity 	= data:GetEntity()
	if !IsValid(self.Entity) then return end
	self.Duration 	= data:GetMagnitude() -- to do
	self.ToColor 	= ColorAlpha( data:GetStart() || self.Entity:GetColor(), data:GetColor() )
	self.StartTime 	= CurTime()
	self.Color		= self.Entity:GetColor()
end

function EFFECT:Think()	
	if ( !IsValid( self.Entity ) ) then self.Entity = nil return end
	local lerp = ( ( CurTime() - self.StartTime ) * ( ( 1 / self.Duration ) ) )
	local r = Lerp( lerp, self.Color.r, self.ToColor.r )	
	local g = Lerp( lerp, self.Color.g, self.ToColor.g )	
	local b = Lerp( lerp, self.Color.b, self.ToColor.b )	
	local a = Lerp( lerp, self.Color.a, self.ToColor.a )	
	self.Entity:SetColor( Color( r, g, b, a ) )
	return self.Entity:GetColor() != self.ToColor
end

function EFFECT:Render()
end

effects.Register( EFFECT, "anp_fade" )