EFFECT.Mat = Material("effects/bullettrail")

function EFFECT:Init(data)
	
	self.StartPos 	= data:GetStart()
	self.Entity  	= data:GetEntity()
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self.TracerTime = 0.4
	self.DieTime 	= CurTime() + self.TracerTime
	
	if (!IsValid(self.Entity)) then return end
	
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
	local attachment = self.Entity:GetAttachment(data:GetAttachment());
	if(attachment) then
		self.StartPos = attachment.Pos;
	end
	
	local dlight = DynamicLight(0)
		if (dlight) then
			dlight.Pos 		= self.StartPos
			dlight.r 		= 255
			dlight.g 		= 255
			dlight.b 		= 255
			dlight.Brightness = 4
			dlight.size 	= 64
			dlight.DieTime 	= CurTime() + 0.1
		end
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
	
	local color = Color(255, 255, 200, 255 * fDelta)
	
	render.DrawBeam(self.StartPos, self.EndPos, 8 * fDelta, 0.5, 0.5, color)
end