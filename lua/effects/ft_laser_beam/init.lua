
local LASER = Material('effects/bluelaser1')
local SPRITE = Material('sprites/blueglow2')

function EFFECT:Init( data )

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
 
self.Pos = data:GetOrigin()
self.Entity:SetPos( self.Pos )

--data:GetAttachment()

self.Weapon = data:GetEntity()

self.Forw = self.Weapon:GetForward()

self.att = self.Weapon:GetAttachment("1")

self.Alpha = 0

self.MAlpha = 150

self.rot = math.random(-100, 100)

self.Spawntime = CurTime()
self.Lifetime = 2
 
end 

function EFFECT:Think()
	
	if !self.Weapon:IsValid() then return false end
	print(self.Weapon:GetOwner())
	
	self.Entity:SetPos( self.Pos )
	
	local lifeleft = self.Spawntime + self.Lifetime - CurTime()
	if lifeleft < 0.8 then self.Alpha = lifeleft/0.8 * self.MAlpha end
	
	local livelived = CurTime() - self.Spawntime
	if livelived < 0.8 then self.Alpha = livelived/0.8 * self.MAlpha end
	
	return CurTime() <= (self.Spawntime + self.Lifetime)
	
end


function EFFECT:Render()

--self.att.Ang:RotateAroundAxis(self.att.Ang:Up(), -89.998) -- 100% on-spot with the player's eye angles if the weapon isn't shaking. Aw ye.
			
local finalAng = Angle(self.att.Ang.p, self.att.Ang.y, 0)
			
local addOffset = finalAng:Right() * 0.5 + finalAng:Up() * 3
			
local td = {}
td.start = self.att.Pos - finalAng:Forward() * 10 + addOffset 
td.endpos = td.start + finalAng:Forward() * 4096
td.filter = self.Owner
			
local trace = util.TraceLine(td)
render.SetMaterial(LASER)
render.DrawBeam(trace.StartPos, trace.HitPos, 1, 0.5, 0.5, Color(255, 255, 255, 1))
				
render.SetMaterial(SPRITE)
render.DrawSprite(trace.HitPos - finalAng:Forward() * 1, 2, 2, Color(255, 0, 0, 255))
	
end
