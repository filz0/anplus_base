
local cVar = GetConVar( "anplus_swep_muzzlelight" )

function EFFECT:Init(data)
	
	self.Entity 	= data:GetEntity()
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
		
	for i = 1, 2 do 	
		local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )
		particle:SetVelocity( ( 40 * i * self.Forward + 10 * VectorRand() + AddVel ) * self.Scale )
		particle:SetDieTime( math.Rand( 0.36, 0.38 ) )
		particle:SetStartAlpha( math.Rand( 60, 70 ) )
		particle:SetStartSize( ( math.random( 1, 2 ) * i ) * self.Scale )
		particle:SetEndSize( ( math.Rand( 5, 8 ) * i ) * self.Scale )
		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( 245, 245, 245 )
		particle:SetLighting( true )
		particle:SetAirResistance( 140 )		
	end
	
	for i = 1,6 do
		local particle = emitter:Add( "sprites/heatwave", self.Position + self.Forward * 1 * self.Scale )

		particle:SetVelocity( ( 40 * self.Forward + 20 * VectorRand() + 1.05 * AddVel ) * self.Scale )
		particle:SetGravity( Vector( 0, 0, 100 ) )
		particle:SetAirResistance( 160 )
		particle:SetDieTime( dietime )
		particle:SetStartSize( math.random( 0.15, 0.3 ) * self.Scale )
		particle:SetEndSize( math.Rand( 1.5, 3 ) * self.Scale )
		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position + self.Forward * 1 * self.Scale )

		particle:SetVelocity( ( 25 * i * self.Forward + 8 * VectorRand() + AddVel ) * self.Scale )
		particle:SetAirResistance( 400 )
		particle:SetGravity( Vector(0, 0, math.Rand( 100, 200 ) ) )
		particle:SetDieTime( dietime )
		particle:SetStartAlpha(  math.Rand( 150, 255 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 0.1, 0.2 ) * self.Scale )
		particle:SetEndSize( math.Rand( 2, 6 ) * self.Scale )
		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( 255, 255, 255 )		
	end
	
	for i = 1, 6 do
		for j = 1, 2 do
		
			local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position + 0.5 * self.Scale * self.Forward )

			particle:SetVelocity( 350 * self.Forward + 1.1 * AddVel )
			particle:SetAirResistance( 800 )
			particle:SetDieTime( 0.1 )
			particle:SetStartAlpha( 160 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 0.7 * self.Scale )
			particle:SetEndSize( 0.7 * self.Scale )
			particle:SetRoll( math.Rand( 180, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1) )
			particle:SetColor( 255, 255, 255 )				
		end
	
		for i = 1, 4 do 
			local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position + 0.5 * self.Scale * self.Forward )

			particle:SetVelocity( 150 * self.Forward + 1.1 * AddVel )
			particle:SetAirResistance( 160 )
			particle:SetDieTime( 0.1 )
			particle:SetStartAlpha( 160 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( ( 0.7 * i ) * self.Scale )
			particle:SetEndSize( ( 0.7 * i ) * self.Scale )
			particle:SetRoll( math.Rand( 180, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1) )
			particle:SetColor( 255, 255, 255 )	
		end
	end

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
	
	if cVar:GetBool() then
		local dlight = DynamicLight( 0 )
		if dlight then
			dlight.Pos 			= self.Position
			dlight.r 			= 70
			dlight.g 			= 50
			dlight.b 			= 0
			dlight.Brightness 	= 3
			dlight.size 		= 300 * self.Scale
			dlight.Decay 		= 300
			dlight.DieTime 		= CurTime() + 0.01
		end
	end
	
	emitter:Finish()

end

function EFFECT:Think()
	return false	
end

function EFFECT:Render()
end

effects.Register( EFFECT, "anp_muzzle_pistol" )


