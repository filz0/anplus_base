--[[ TODO: Fix this shit

local eBullet = ents.Create("sent_rg_bullet")

			local Velocity = speed*(PlayerAim + VectorRand()*spread + 0.04*spray*sprayvec:GetNormalized()):GetNormalized()

			eBullet:SetPos(PlayerPos)
			eBullet:SetVar("Velocity",Velocity)
			eBullet:SetVar("Acceleration",accel)
			
			local tBullet = {} -- This is the bullet our bullet SENT will be firing when it hits something.  Everything except force and damage is determined by the bullet SENT
			tBullet.Force	= 0.15*dmg
			tBullet.Damage	= dmg
			
			local tTrace = {} --This is the trace the bullet SENT uses to see if it has hit something
			tTrace.filter = filter or {self.Owner,eBullet}
			tTrace.mask = mask
			
			eBullet:SetVar("Bullet",tBullet)
			eBullet:SetVar("Trace",tTrace)
			eBullet:SetVar("Owner",self.Owner)
			eBullet:Spawn()

			eBullet:Spawn()

AddCSLuaFile()
ENT.Type = "point"


function ENT:Initialize()

	self.Position = self.Entity:GetPos()
	self.Velocity = self.Entity:GetVar("Velocity",false)
	self.Acceleration = self.Entity:GetVar("Acceleration",false)
	self.Bullet = self.Entity:GetVar("Bullet",false)
	self.Trace = self.Entity:GetVar("Trace",false)
	
	if not (self.Position and self.Velocity and self.Acceleration and self.Bullet and self.Trace) then 
		Msg("sent_anp_bullet: Error! Insufficient data to spawn.\n")
		self:Remove() 
		return 
	end
	
	self.Owner = self.Owner or self.Entity
	self.LastThink = CurTime()
	self.Trace.endpos = self.Position
	
	self.Bullet.Spread = Vector(0,0,0)
	self.Bullet.Num = 1
	self.Bullet.Tracer = 0
	
	SafeRemoveEntityDelayed( self, 7 ) -- Kill this entity after awhile
	
end


function ENT:Think() -- Do prediction serverside

	local fTime = CurTime()
	local DeltaTime = fTime - self.LastThink
	self.LastThink = fTime

	self.Position = self.Position + self.Velocity*DeltaTime
	self.Velocity = self.Velocity + self.Acceleration*DeltaTime
	
	self.Trace.start = self.Trace.endpos
	self.Trace.endpos = self.Position
	
	local TraceRes = util.TraceLine(self.Trace)
	
	if TraceRes.Hit then
		self.Bullet.Src = self.Trace.start
		self.Bullet.Dir = (TraceRes.HitPos - self.Trace.start)
		self.Owner:FireBullets(self.Bullet)
		
		self:Remove()
		return false
	end


end
]]--