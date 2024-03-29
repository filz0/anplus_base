function EFFECT:Init( data )
	
	self.Entity 		= data:GetEntity()
	self.Position 		= data:GetOrigin()
	self.Normal 		= data:GetNormal()
	self.Scale 			= data:GetScale()
	self.SurfaceColor 	= render.GetSurfaceColor( self.Position + self.Normal, self.Position + self.Normal * -60 ) * 255

	self.SurfaceColor.r = math.Clamp( self.SurfaceColor.r + 100, 0, 255 )
	self.SurfaceColor.g = math.Clamp( self.SurfaceColor.g + 100, 0, 255 )
	self.SurfaceColor.b = math.Clamp( self.SurfaceColor.b + 100, 0, 255 )

	local emitter = ParticleEmitter( self.Position )

	for i = 0, 3 do
		local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )

		particle:SetVelocity( 200 * i * self.Normal  + 8 * VectorRand() )
		particle:SetAirResistance( 400 )
		particle:SetDieTime( math.Rand( 0.5, 1.5 ) )
		particle:SetStartAlpha( math.Rand( 50, 150 ) )
		particle:SetEndAlpha( math.Rand( 0, 5 ) )
		particle:SetStartSize( math.Rand( 8, 12 ) )
		particle:SetEndSize( math.Rand( 52, 76 ) )
		particle:SetRoll( math.Rand( -25, 25 ) )
		particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )
		particle:SetColor( self.SurfaceColor.r, self.SurfaceColor.g, self.SurfaceColor.b )
	end
	
	for i = 1, 2 do 
		local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position )

		particle:SetVelocity( 100 * self.Normal  )
		particle:SetAirResistance( 200 )
		particle:SetDieTime( 0.18 )
		particle:SetStartAlpha( 160 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 35 * i )
		particle:SetEndSize( 31 * i )
		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1 , 1 ) )
		particle:SetColor( 255, 255, 255 )	
	end

	local particle = emitter:Add( "sprites/heatwave", self.Position )

	particle:SetVelocity( 80 * self.Normal  + 20 * VectorRand() )
	particle:SetAirResistance( 200 )
	particle:SetDieTime( math.Rand( 0.2, 0.25 ) )
	particle:SetStartSize( math.random( 15, 20 ) )
	particle:SetEndSize( 3 )
	particle:SetRoll( math.Rand( 180, 480 ) )
	particle:SetRollDelta( math.Rand( -1, 1 ) )
	emitter:Finish()
	
end

function EFFECT:Think( )

	return false
end

function EFFECT:Render()
end

effects.Register( EFFECT, "anp_hit_effect" )