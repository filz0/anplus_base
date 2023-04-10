AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_gmodentity"
ENT.Author				= "filz0"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.Particle = nil
ENT.StartDelay = 0
ENT.KillDelay = 0
ENT.Parent = nil
ENT.Attachment = nil

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:DrawShadow( false )
	self:SetNoDraw( true )	
	if self.Particle then 
		if self.StartDelay >= 0 then
			timer.Simple( self.StartDelay, function()				
				if !IsValid(self) then return end
				if IsValid(self.Parent) then
					self:SetParent( self.Parent )					
					if self.Attachment then 
						local attName = self.Parent:ANPlusGetAttachmentName( self.Attachment )
						self:Fire( "SetParentAttachment", attName, 0 )
					end
				end
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