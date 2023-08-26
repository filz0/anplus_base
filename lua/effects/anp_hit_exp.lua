function EFFECT:Init( data )
	
	self.Entity 		= data:GetEntity()
	self.Position 		= data:GetOrigin()
	self.Normal 		= data:GetNormal()
	self.Scale 			= data:GetScale()

	local emitter = ParticleEmitter( self.Position )

	for i = 2, 4 do
		local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )

		particle:SetAirResistance( 400 )
		particle:SetDieTime( math.Rand( 0.5, 1.5 ) )
		particle:SetStartAlpha( math.Rand( 50, 150 ) )
		particle:SetEndAlpha( math.Rand( 0, 5 ) )
		particle:SetStartSize( math.Rand( 20, 25 ) * self.Scale )
		particle:SetEndSize( math.Rand( 62, 76 ) * self.Scale )
		particle:SetRoll( math.Rand( -25, 25 ) )
		particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )
		particle:SetColor( 10, 10, 10 )
	end

	for i = 1, 2 do 
		local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position )

		particle:SetVelocity( 100 * self.Normal  )
		particle:SetAirResistance( 200 )
		particle:SetDieTime( 0.18 )
		particle:SetStartAlpha( 160 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( ( 20 * i ) * self.Scale )
		particle:SetEndSize( ( 13 * i ) * self.Scale )
		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1 , 1 ) )
		particle:SetColor( 255, 255, 255 )	
	end

	local particle = emitter:Add( "sprites/heatwave", self.Position )

	particle:SetVelocity( 80 * self.Normal  + 20 * VectorRand() )
	particle:SetAirResistance( 200 )
	particle:SetDieTime( math.Rand( 0.2, 0.25 ) * self.Scale )
	particle:SetStartSize( math.random( 25, 30 ) * self.Scale )
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

effects.Register( EFFECT, "anp_hit_exp" )