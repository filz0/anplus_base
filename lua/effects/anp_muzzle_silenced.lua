
function EFFECT:Init(data)
	
	self.Entity		= data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.BoneID 	= data:GetFlags()
	self.Scale 		= data:GetScale()
	
	if !IsValid(self.Entity) then return end
	
	local attTab 	= self.Attachment > 0 && self.Entity:GetAttachment( self.Attachment )
	local Pos, Ang 	= self.Entity:GetBonePosition( self.BoneID )	
	self.Position 	= attTab && attTab.Pos || Pos
	self.Angle 		= attTab && attTab.Ang || Ang
	if !self.Angle || self.Position then return end
	self.Forward 	= self.Angle:Forward()
	self.Right 		= self.Angle:Right()
	self.Up 		= self.Angle:Up()

	local AddVel = self.Entity:GetVelocity()	
	local emitter = ParticleEmitter( self.Position )
	local dietime = math.Rand( 0.1, 0.15 )
		
	local particle = emitter:Add( "sprites/heatwave", self.Position - self.Forward * 4 * self.Scale )
	particle:SetVelocity( ( 30 * self.Forward + 5 * VectorRand() + 1.05 * AddVel ) * self.Scale )
	particle:SetDieTime( math.Rand( 0.05, 0.07 ) )
	particle:SetStartSize( math.random( 3, 6 ) * self.Scale )
	particle:SetEndSize( 2 * self.Scale )
	particle:SetRoll( math.Rand( 180, 480 ) )
	particle:SetRollDelta( math.Rand( -1, 1 ) )
	particle:SetGravity( Vector( 0, 0, 100 ) )
	particle:SetAirResistance( 80 )
	
	local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )
	particle:SetVelocity( ( 50 * self.Forward + 1.1 * AddVel ) * self.Scale )
	particle:SetDieTime( math.Rand( 0.28, 0.34 ) )
	particle:SetStartAlpha( math.Rand( 30, 40 ) )
	particle:SetStartSize( math.random( 3, 4 ) * self.Scale )
	particle:SetEndSize( math.Rand( 16, 23 ) * self.Scale )
	particle:SetRoll( math.Rand( 180, 480 ) )
	particle:SetRollDelta( math.Rand( -1, 1 ) )
	particle:SetColor( 245, 245, 245 )
	particle:SetLighting( true )
	particle:SetAirResistance( 80 )

	local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )

	particle:SetVelocity( 100 * self.Forward + 8 * self.Scale * VectorRand() )
	particle:SetAirResistance( 400 )
	particle:SetGravity( Vector( 0, 0, math.Rand( 25, 100 ) ) )
	particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
	particle:SetStartAlpha( math.Rand( 225, 255 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 2, 5 ) * self.Scale )
	particle:SetEndSize( math.Rand( 13, 20 ) * self.Scale )
	particle:SetRoll( math.Rand( -25, 25 ) )
	particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )
	particle:SetColor( 120, 120, 120 )

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

effects.Register( EFFECT, "anp_muzzle_silenced" )



