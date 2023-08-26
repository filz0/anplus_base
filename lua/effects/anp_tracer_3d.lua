local bulletModels = {
	"models/anp/bullets/bt_9mm.mdl",
	"models/anp/bullets/bt_357.mdl",
	"models/anp/bullets/bt_762.mdl",
	"models/anp/bullets/bt_h9mm.mdl",
	"models/anp/bullets/bt_h357.mdl",
	"models/anp/bullets/bt_h762.mdl",
	"models/anp/bullets/w_pellet.mdl",
}

local flybyDist = 124

function EFFECT:Init(data)

	self.StartPos 			= data:GetStart()
	self.Entity  			= data:GetEntity()
	
	if ( !IsValid(self.Entity) ) then return end
	
	self.DataTab 			= self.Entity.ANPTracerSettingTab
	self.EndPos 			= data:GetOrigin()
	self.Dir 				= self.EndPos - self.StartPos
	self.Normal 			= self.Dir:GetNormal()
	self.StartTime 			= 0
	self.LifeTime 			= ( self.Dir:Length() + 200 ) / 7000
	self.TrailDur			= self.DataTab && self.DataTab['TrailDuration'] || 1
	self.DieTime 			= CurTime() + self.TrailDur
	self.TrailLast 			= CurTime()	
	
	self.BulletModel		= ( self.DataTab && isnumber( self.DataTab['BulletModel'] && bulletModels[ self.DataTab['BulletModel'] ] ) || ( self.DataTab && isstring( self.DataTab['BulletModel'] ) && self.DataTab['BulletModel'] ) ) || false
	self.BulletMat			= self.DataTab && self.DataTab['BulletMat'] || ""
	self.BulletCol			= self.DataTab && self.DataTab['BulletColor'] || Color( 255, 255, 255, 255 )
	self.BulletS			= self.DataTab && self.DataTab['BulletScale'] || Vector( 1, 1, 1 )
	self.BulletOffsetPos	= self.DataTab && self.DataTab['BulletOffsetPos'] || Vector( 0, 0, 0 )
	self.BulletOffsetAng	= self.DataTab && self.DataTab['BulletOffsetAng'] || Angle( 0, 0, 0 )
	self.BulletParticle		= self.DataTab && self.DataTab['BulletParticle'] || nil
	self.BulletSpeedMul		= self.DataTab && self.DataTab['BulletSpeedMul'] || 1	
	
	self.TracerMat			= self.DataTab && self.DataTab['TracerMat'] && Material( self.DataTab['TracerMat'] ) || ( self.DataTab && self.DataTab['TracerMat'] == nil || !self.DataTab ) && Material( "effects/spark" ) || false
	self.TracerS			= self.DataTab && self.DataTab['TracerScale'] || 4
	self.TracerLength		= self.DataTab && self.DataTab['TracerLength'] || 100
	self.TracerCol			= self.DataTab && self.DataTab['TracerColor'] || Color( 255, 255, 255, 255 )
	
	self.TrailMat			= self.DataTab && self.DataTab['TrailMat'] && Material( self.DataTab['TrailMat'] ) || ( self.DataTab && self.DataTab['TrailMat'] == nil || !self.DataTab ) && Material( "effects/anp/tracer_trail" ) || false
	self.TrailS				= self.DataTab && self.DataTab['TrailScale'] || 1	
	self.TrailDelay			= self.DataTab && self.DataTab['TrailDelay'] || 0	
	self.TrailCol			= self.DataTab && self.DataTab['TrailColor'] || Color( 10, 10, 10, 255 )
	
	local attachment = self.Entity:GetAttachment( data:GetAttachment() )
	if attachment then
		self.StartPos = attachment.Pos
	end
	
	if self.BulletModel then
		self.BulletEnt	= ClientsideModel( self.BulletModel )
		self.BulletEnt:ManipulateBoneScale( 0, self.BulletS )
		self.BulletEnt:SetMaterial( self.BulletMat )
		self.BulletEnt:SetColor( self.BulletCol )
		
		local newPos, newAng = LocalToWorld( self.BulletOffsetPos, self.BulletOffsetAng, self.StartPos, self.Dir:Angle() )
		self.BulletEnt:SetPos( newPos )
		self.BulletEnt:SetAngles( newAng )
	end
	
	if self.DataTab && self.DataTab['FunctionInit'] != nil then
		self.DataTab['FunctionInit'](self, data)
	end
	
	hook.Add( "PreDrawEffects", self, self.RenderFixed )
end

function EFFECT:Think()
	if self.DieTime == nil || self.LifeTime == nil then return end
	if self.LifeTime <= 0 && IsValid(self.BulletEnt) then self.BulletEnt:Remove() end
	if ( CurTime() > self.DieTime ) then return false end
	self.LifeTime = self.LifeTime - FrameTime() * self.BulletSpeedMul
	self.StartTime = self.StartTime + FrameTime() * self.BulletSpeedMul
	if self.DataTab && self.DataTab['FunctionThink'] != nil then
		self.DataTab['FunctionThink'](self)
	end
	return true
end

function EFFECT:Render()
end

function EFFECT:RenderFixed()
	
	local ply 				= LocalPlayer()
	local viewEnt			= ply:GetViewEntity()
	local off 				= viewEnt:OBBMaxs().z - viewEnt:OBBMins().z -- Get the center of mass of a Player
	local viewPos 			= viewEnt:GetPos() + Vector( 0, 0, off ) -- Get roughly a head position (and so ears)
	
	local tracerDelay 		= 7000
	local tracerDelayTr 	= tracerDelay - self.TrailDelay
	local endDistance 		= tracerDelay * self.StartTime
	local endDistanceTr 	= tracerDelayTr * self.StartTime
	local startDistance 	= endDistance - self.TracerLength
	local startDistanceB 	= endDistance
	local startDistanceTr 	= 3
	
	startDistance 			= math.max( 0, startDistance )
	startDistanceB 			= math.max( 0, startDistanceB )
	startDistanceTr 		= math.max( 0, startDistanceTr )
	endDistance 			= math.max( 0, endDistance )
	endDistanceTr 			= math.max( 0, endDistanceTr )

	local startPos 			= self.StartPos + self.Normal * startDistance
	local startPosB 		= self.StartPos + self.Normal * startDistanceB
	local startPosTr 		= self.StartPos + self.Normal * startDistanceTr
	local endPos 			= self.StartPos + self.Normal * endDistance
	local endPosTr			= self.LifeTime > 0 && ( self.StartPos + self.Normal * endDistanceTr ) || self.EndPos
	local fDelta 			= ( self.DieTime - CurTime() ) / self.TrailDur
	local fDelta2 			= ( CurTime() - self.TrailLast ) / self.TrailDur
	fDelta 					= math.Clamp( fDelta, 0, 1 )
	fDelta2					= math.Clamp( fDelta2, 0, 1 )
	
	if self.LifeTime > 0 then
		
		if IsValid( self.BulletEnt ) then
			local newPos, newAng = LocalToWorld( self.BulletOffsetPos, self.BulletOffsetAng, startPosB, self.Dir:Angle() )
			self.BulletEnt:SetPos( newPos )
		end
		
		if self.BulletParticle then
			ParticleEffectAttach( self.BulletParticle, 1, self.BulletEnt, -1 )
		end
		
		if self.TracerMat then
			render.SetMaterial( self.TracerMat )
			render.DrawBeam( startPos, endPos, self.TracerS, 0, 1, self.TracerCol )
		end
		
		if self.DataTab && self.DataTab['FunctionRender'] != nil then
			self.DataTab['FunctionRender'](self, self.Dir, startPos, endPos, self.StartPos, self.EndPos)
		end
--##--------------------------------------------------------------------------------------------------------------------## Nearmiss / Flyby bullet sounds.
		local dist, pos = util.DistanceToLine( self.StartPos, self.EndPos, viewPos )
		if dist <= flybyDist && !self['m_bNearMissFXPlayed' .. ply:EntIndex()] then			
			local measure	= viewPos - ( self.EndPos )
			local dot		= self.Dir:Dot(	measure	) /	measure:Length()
			if dot <= 0 then
				sound.Play( "ANP.WEAPON.Tracer.Flyby", pos )
				self['m_bNearMissFXPlayed' .. ply:EntIndex()] = true 
			end
			if viewEnt == ply && dist <= 60 then
				--render.ANPlusDrawOverlay( "suppress", { Offset = 0, Scatter = 1, Strength = 5, Fadeout = 30 } )
			end
		end
--##--------------------------------------------------------------------------------------------------------------------## Nearmiss / Flyby bullet sounds.		
	end	

	
	if self.TrailMat then
		local color = Color( self.TrailCol.r, self.TrailCol.g, self.TrailCol.b, self.TrailCol.a * fDelta )
		render.SetMaterial( self.TrailMat )	
		render.DrawBeam( startPosTr, endPosTr, self.TrailS + ( self.TrailS * 2 * fDelta2 ), 0, 1, color )
	end
	
end

effects.Register( EFFECT, "anp_tracer_3d" )