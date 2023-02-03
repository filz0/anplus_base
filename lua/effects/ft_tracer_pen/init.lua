EFFECT.Mat = Material("effects/spark")

function EFFECT:Init(data)
	
	self.StartPos 	= data:GetStart()
	self.Entity  	= data:GetEntity()
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self.TracerTime = 0.4
	self.DieTime 	= CurTime() + self.TracerTime

	if (!IsValid(self.StartPos)) or (!IsValid(self.EndPos)) or (!IsValid(self.Entity)) then return end
	
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

	local emitter = ParticleEmitter( self.EndPos )

		for i = 0,3 do
			local particle = emitter:Add( "particle/particle_smokegrenade", self.StartPos )

				particle:SetVelocity( 200 * i * data:GetNormal() + 8 * VectorRand() )
				particle:SetAirResistance(400)

				particle:SetDieTime( math.Rand( 0.5, 1.5 ) )

				particle:SetStartAlpha( math.Rand( 50, 150 ) )
				particle:SetEndAlpha( math.Rand( 0, 5 ) )

				particle:SetStartSize( math.Rand( 8, 12 ) )
				particle:SetEndSize( math.Rand( 52, 76 ) )

				particle:SetRoll( math.Rand( -25, 25 ) )
				particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )

				particle:SetColor( 120, 120, 120 )
		end

		for i=1,2 do 
			local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), self.StartPos )

				particle:SetVelocity( 100 * data:GetNormal() )
				particle:SetAirResistance( 200 )

				particle:SetDieTime( 0.18 )

				particle:SetStartAlpha( 160 )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( 5 * i )
				particle:SetEndSize( 1 * i )

				particle:SetRoll( math.Rand(180,480) )
				particle:SetRollDelta( math.Rand(-1,1) )

				particle:SetColor(255,255,255)	
		end

			local particle = emitter:Add( "sprites/heatwave", self.StartPos )

				particle:SetVelocity( 80 * data:GetNormal() + 20 * VectorRand() )
				particle:SetAirResistance( 200 )

				particle:SetDieTime( math.Rand(0.2, 0.25) )

				particle:SetStartSize( math.random(15,20) )
				particle:SetEndSize( 3 )


				particle:SetRoll( math.Rand(180,480) )
				particle:SetRollDelta( math.Rand(-1,1) )

	emitter:Finish()
end

function EFFECT:Think()
if self.DieTime == nil then return end
	if (CurTime() > self.DieTime) then return false end
	return true
end

function EFFECT:Render()

	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp(fDelta, 0, 1)
			
	render.SetMaterial(self.Mat)
	
	local sinWave = math.sin(fDelta * math.pi)
	
	local color = Color(255, 255, 200, 155 * fDelta)
	
	render.DrawBeam(self.StartPos, self.EndPos, 8 * fDelta, 0.5, 0.5, color)
end