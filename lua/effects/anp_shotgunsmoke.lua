
local cVar = GetConVar( "anplus_swep_muzzlelight" )

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
	self.Forward 	= self.Angle:Forward()
	self.Right 		= self.Angle:Right()
	self.Up 		= self.Angle:Up()

	local AddVel = self.Entity:GetVelocity()	
	local emitter = ParticleEmitter( self.Position )
	local dietime = math.Rand( 0.1, 0.15 )

	for i = 1, 32 do
		local particle = emitter:Add( "effects/yellowflare", self.Position )
	
		particle:SetVelocity( ( ( self.Forward + VectorRand() * 0.5 ) * math.Rand( 150, 300 ) ) * self.Scale )
		particle:SetDieTime( math.Rand(0.5, 2) )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( 2 * self.Scale )
		particle:SetEndSize( 2 * self.Scale )
		particle:SetRoll( 0 )
		particle:SetGravity( Vector( 0, 0, -50 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.8 )
		particle:SetAirResistance( 375 )
		particle:SetStartLength( 0.2 )
		particle:SetEndLength( 0 )
		particle:SetVelocityScale( true )
		particle:SetCollide( true )
	end

	local particle = emitter:Add( "effects/yellowflare", self.Position + 8 * self.Scale * self.Forward )

	particle:SetVelocity( ( self.Forward + 1.1 * AddVel ) * self.Scale )
	particle:SetAirResistance( 160 )
	particle:SetDieTime( 0.25 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 30 * self.Scale )
	particle:SetEndSize( 40 * self.Scale )
	particle:SetRoll( math.Rand( 180, 480 ) )
	particle:SetRollDelta( math.Rand( -1, 1 ) )
	particle:SetColor( 255, 255, 255 )	
	
	if cVar:GetBool() then
		local dlight = DynamicLight( 0 )
		if dlight then
			dlight.Pos 			= self.Position
			dlight.r 			= 70
			dlight.g 			= 50
			dlight.b 			= 0
			dlight.Brightness 	= 3
			dlight.size 		= 1000 * self.Scale
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

effects.Register( EFFECT, "anp_shotgunsmoke" )