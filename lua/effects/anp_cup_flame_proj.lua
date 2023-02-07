local spr = Material("effects/fire_cloud2")

function EFFECT:Init(data)
	
	local ePos = data:GetOrigin()
	local eAng = data:GetAngles()
	local emitter = ParticleEmitter( ePos, false )
	local particle = nil
	
	for i = 0, 3 do
	
		local dir = ( eAng:Forward() + ( ( eAng:Up() * ( math.random() * 2 - 1) ) + ( eAng:Right() * ( math.random() * 2 - 1 ) ) ) * 0.1 ):GetNormal()
		local pPos = dir * 4		
		particle = emitter:Add( "particle/flamelet" .. tostring( math.floor( math.random() * 5 + 1) ), ePos + pPos )
		
		if particle then
		
			particle:SetVelocity( dir * ( 400 + math.random() * 80 ) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.5 )
			particle:SetStartSize( 2 )
			particle:SetEndSize( 12 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetColor( 255,220 + math.random() * 30, 200 + math.random() * 20, 255 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
			particle:SetAirResistance( 10 )
			particle:SetCollide( true )
			particle:SetBounce( 0.2 )
			particle:SetRoll( math.random() * 4 - 2 )
			particle:SetRollDelta( math.random() * 6 - 3 )
			
		end
		
	end
	
	for i = 0 , 3 do
	
		local dir = ( eAng:Forward() + ( ( eAng:Up() * ( math.random() * 2 - 1) ) + ( eAng:Right() * ( math.random() * 2 - 1) ) ) * 0.2 ):GetNormal()
		local pPos = dir * 4
		particle = emitter:Add( "effects/fire_cloud" .. tostring( math.floor( math.random() * 2 + 1) ), ePos + pPos )
		
		if particle then
		
			particle:SetVelocity( dir * ( 440 + math.random() * 60 )) 
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.5 )
			particle:SetStartSize( 2 )
			particle:SetEndSize( 12 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetColor( 255,100 + math.random() * 60,60 + math.random() * 40, 255 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
			particle:SetAirResistance( 10 )
			particle:SetCollide( true )
			particle:SetBounce( 0.4 )
			particle:SetRoll( math.random() * 4 - 2 )
			particle:SetRollDelta( math.random() * 4 - 2 )
			
		end
		
	end
	
	for i = 0 , 2 do
	
		local dir = ( eAng:Forward() + ( ( eAng:Up() * ( math.random() * 2 - 1 ) ) + ( eAng:Right() * ( math.random() * 2 - 1) ) ) * 0.05 ):GetNormal()
		local pPos = dir * 4
		particle = emitter:Add( "particle/hzglo", ePos + pPos )
		
		if particle then
		
			particle:SetVelocity( dir * ( 480 + math.random() * 40 ) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.2 )
			particle:SetStartSize( 4 )
			particle:SetEndSize( 0 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
			particle:SetColor( 255,240,220,255 )
			particle:SetGravity( Vector( 0, 0, -300 ) )
			particle:SetAirResistance( 20 )
			particle:SetCollide( true )
			particle:SetBounce( 0.2 )
			particle:SetRoll( math.random() * 4 - 2 )
			particle:SetRollDelta( math.random() * 2 - 1 )
			
		end
		
	end
	
end

function EFFECT:Render()

end

function EFFECT:Think()
	return false
end
