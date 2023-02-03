
local LASER = Material('effects/bluelaser1')
local SPRITE = Material('sprites/blueglow2')

function EFFECT:Init( data )
 
self.Weapon = data:GetEntity() 
 
self.Attachment = data:GetAttachment()
 
self.Pos = data:GetOrigin()

self.Entity:SetPos( self.Pos )

self.Forw = self.Weapon:GetForward()

self.Alpha = 0

self.MAlpha = 150

self.rot = math.random(-100, 100)

self.Spawntime = CurTime()
self.Lifetime = 2
 
end 

function EFFECT:Think()
	
	if (!IsValid(self.Weapon)) or (!IsValid(self.Weapon:GetOwner())) then return false end
	
	self.Pos, self.Forw = self:GetTracerShootPosAng(self.Weapon:GetOwner():GetShootPos(), self.Weapon, self.Attachment)
	
	self.Entity:SetPos( self.Pos )
	
	local lifeleft = self.Spawntime + self.Lifetime - CurTime()
	if lifeleft < 0.8 then self.Alpha = lifeleft/0.8 * self.MAlpha end
	
	local livelived = CurTime() - self.Spawntime
	if livelived < 0.8 then self.Alpha = livelived/0.8 * self.MAlpha end
	
	return CurTime() <= (self.Spawntime + self.Lifetime)
	
end


function EFFECT:Render()
	
	local origin
	local target
	local normal
	
	origin = self.Pos
	
		traceres = util.QuickTrace(origin, self.Forw * 5000, {})
		target = traceres.HitPos
		normal = traceres.HitNormal
	
	
	render.SetMaterial( LASER )
	render.DrawBeam(origin, target, 2, 0, 12.5, Color(255, 255, 255, self.Alpha))
	
	render.SetMaterial( SPRITE )
	render.DrawSprite( target + normal*1, 10, 10, Color(255, 255, 255, self.Alpha * 0.7) )
	render.DrawQuadEasy( target + normal*0.5, normal, 11, 11, Color(255, 255, 255, self.Alpha), CurTime() * self.rot )
	
end


function EFFECT:GetTracerShootPosAng( pos, ent, att )
	
	local forward = Vector(0,0,1)
	if (!IsValid(pos)) then return pos, Vector(0,0,1) end
	if (!IsValid(ent)) then return pos, Vector(0,0,1) end
	if (!ent:IsWeapon()) then return pos, Vector(0,0,1) end

	forward = ent:GetOwner():GetAimVector() 
	pos = att.pos + Forward * 40 + Ent:GetUp() * 13 + Ent:GetRight() * 8

	return pos,forward

end
