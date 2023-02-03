AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_gmodentity"
ENT.Author				= "filz0"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.Particle = nil
ENT.StartDelay = 0
ENT.KillDelay = 0

function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate.mdl" )
	self:DrawShadow( false )
	self:SetNoDraw( true )	
	if self.Particle then 
		if self.StartDelay > 0 then
			timer.Simple( self.StartDelay, function()
				if !IsValid(self) then return end
				ParticleEffectAttach( self.Particle, 1, self, -1 ) 
			end)
		end
		if self.KillDelay > 0 then
			timer.Simple( self.KillDelay, function()
				if !IsValid(self) then return end
				self:Remove() 
			end)
		end
	end
end

function ENT:OnRemove()
	self:StopParticles()
end