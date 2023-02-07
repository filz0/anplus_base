function EFFECT:Init( data )

    local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	local vOffset = data:GetOrigin()
	local emitter = ParticleEmitter( vOffset )

	for i = 1,3 do 	
	
		local particle = emitter:Add( "particle/particle_smokegrenade", Pos + Norm * 3 )
		particle:SetVelocity( math.Rand( -60, 90 ) * VectorRand() + 2 * VectorRand())
		particle:SetAirResistance( 140 )
		particle:SetGravity( Vector(0, 0, -90) )
		particle:SetDieTime( 1 )
		particle:SetStartAlpha( math.Rand( 200, 255 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 1, 2 ) )
		particle:SetEndSize( math.Rand( 250, 300 ) )
		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( 0, 155, 255 )
		particle:SetCollide( true )
		
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end


function EFFECT:Render()
end

effects.Register( EFFECT, "cm_healthing_smoke" )