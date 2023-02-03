function EFFECT:Init(data)
	
	self.Entity = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.BoneID = data:GetColor()
	
	if !IsValid(self.Entity) then return end
	local Pos, Ang = self.Entity:GetBonePosition( self.BoneID )
	self.Position = self:GetTracerShootPos(Pos, self.Entity, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.Up = self.Angle:Up()
	
	local AddVel = self.Entity:GetVelocity()
	
	local emitter = ParticleEmitter(self.Position)

		for i = 1, 32 do
	
			local particle = emitter:Add("effects/yellowflare", self.Position)
		
				particle:SetVelocity(((self.Forward + VectorRand() * 0.5) * math.Rand(150, 300)))
				particle:SetDieTime(math.Rand(0.5, 2))
				particle:SetStartAlpha(255)
				particle:SetStartSize(2)
				particle:SetEndSize(2)
				particle:SetRoll(0)
				particle:SetGravity(Vector(0, 0, -50))
				particle:SetCollide(true)
				particle:SetBounce(0.8)
				particle:SetAirResistance(375)
				particle:SetStartLength(0.2)
				particle:SetEndLength(0)
				particle:SetVelocityScale(true)
				particle:SetCollide(true)
		end

		local particle = emitter:Add("effects/yellowflare", self.Position + 8 * self.Forward)

			particle:SetVelocity(self.Forward + 1.1 * AddVel)
			particle:SetAirResistance(160)

			particle:SetDieTime(0.25)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(30)
			particle:SetEndSize(40)

			particle:SetRoll(math.Rand(180, 480))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(255, 255, 255)	

	emitter:Finish()
end

function EFFECT:Think()

	return false
end

function EFFECT:Render()
end

effects.Register( EFFECT, "anp_shotgunsmoke" )