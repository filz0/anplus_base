local bulletModels = {
	"models/anp/bullets/bt_9mm.mdl",
	"models/anp/bullets/bt_357.mdl",
	"models/anp/bullets/bt_762.mdl",
	"models/anp/bullets/bt_h9mm.mdl",
	"models/anp/bullets/bt_h357.mdl",
	"models/anp/bullets/bt_h762.mdl",
	"models/anp/bullets/w_pellet.mdl",
}

function EFFECT:Init(data)

	self.StartPos 			= data:GetStart()
	self.Entity  			= data:GetEntity()
	
	if ( !IsValid(self.Entity) ) then return end
	
	local dataTab 			= self.Entity.ANPTracerSettingTab
	self.EndPos 			= data:GetOrigin()
	self.Dir 				= self.EndPos - self.StartPos
	self.Normal 			= self.Dir:GetNormal()
	self.StartTime 			= 0
	self.LifeTime 			= ( self.Dir:Length() + 200 ) / 7000
	self.TrailDur			= dataTab && dataTab['TrailDuration'] || 1
	self.DieTime 			= CurTime() + self.TrailDur
	self.TrailLast 			= CurTime()	
	
	self.BulletModel		= ( dataTab && isnumber( dataTab['BulletModel'] && bulletModels[ dataTab['BulletModel'] ] ) || ( dataTab && isstring( dataTab['BulletModel'] ) && dataTab['BulletModel'] ) ) || bulletModels[ 1 ]
	self.BulletMat			= dataTab && dataTab['BulletMat'] || ""
	self.BulletCol			= dataTab && dataTab['BulletColor'] || Color( 255, 255, 255, 255 )
	self.BulletS			= dataTab && dataTab['BulletScale'] || Vector( 1, 1, 1 )
	self.BulletOffsetPos	= dataTab && dataTab['BulletOffsetPos'] || Vector( 0, 0, 0 )
	self.BulletOffsetAng	= dataTab && dataTab['BulletOffsetAng'] || Angle( 0, 0, 0 )
	self.BulletParticle		= dataTab && dataTab['BulletParticle'] || nil
	self.BulletSpeedMul		= dataTab && dataTab['BulletSpeedMul'] || 1	
	
	self.TracerMat			= dataTab && dataTab['TracerMat'] && Material( dataTab['TracerMat'] ) || ( dataTab && dataTab['TracerMat'] == nil || !dataTab ) && Material( "effects/spark" ) || false
	self.TracerS			= dataTab && dataTab['TracerScale'] || 4
	self.TracerLength		= dataTab && dataTab['TracerLength'] || 10
	self.TracerCol			= dataTab && dataTab['TracerColor'] || Color( 255, 255, 255, 255 )
	
	self.TrailMat			= dataTab && dataTab['TrailMat'] && Material( dataTab['TrailMat'] ) || ( dataTab && dataTab['TrailMat'] == nil || !dataTab ) && Material( "effects/anp/tracer_trail" ) || false
	self.TrailS				= dataTab && dataTab['TrailScale'] || 1	
	self.TrailDelay			= dataTab && dataTab['TrailDelay'] || 0	
	self.TrailCol			= dataTab && dataTab['TrailColor'] || Color( 10, 10, 10, 255 )
	
	local attachment = self.Entity:GetAttachment( data:GetAttachment() )
	if attachment then
		self.StartPos = attachment.Pos
	end
	hook.Add( "PreDrawEffects", self, self.RenderFixed )
end

function EFFECT:Think()
	if self.DieTime == nil || self.LifeTime == nil then return end
	if self.LifeTime <= 0 && IsValid(self.BulletEnt) then self.BulletEnt:Remove() end
	if ( CurTime() > self.DieTime ) then return false end
	self.LifeTime = self.LifeTime - FrameTime() * self.BulletSpeedMul
	self.StartTime = self.StartTime + FrameTime() * self.BulletSpeedMul
	return true
end

function EFFECT:Render()
end

function EFFECT:RenderFixed()
	
	local tracerDelay 		= 7000
	local tracerDelayTr 	= tracerDelay - self.TrailDelay
	local endDistance 		= tracerDelay * self.StartTime
	local endDistanceTr 	= tracerDelayTr * self.StartTime
	local startDistance 	= endDistance
	local startDistanceTr 	= 10
	
	startDistance 			= math.max( 0, startDistance )
	startDistanceTr 		= math.max( 0, startDistanceTr )
	endDistance 			= math.max( 0, endDistance )
	endDistanceTr 			= math.max( 0, endDistanceTr )

	local startPos 			= self.StartPos + self.Normal * startDistance
	local startPosTr 		= self.StartPos + self.Normal * startDistanceTr
	local endPos 			= self.StartPos + self.Normal * endDistance
	local endPosTr			= self.LifeTime > 0 && ( self.StartPos + self.Normal * endDistanceTr ) || self.EndPos
	local fDelta 			= ( self.DieTime - CurTime() ) / self.TrailDur
	local fDelta2 			= ( CurTime() - self.TrailLast ) / self.TrailDur
	--local sinWave 			= math.sin( fDelta * math.pi )
	--local sinWave2			= math.sin( fDelta2 * math.pi )
	fDelta 					= math.Clamp( fDelta, 0, 1 )
	fDelta2					= math.Clamp( fDelta2, 0, 1 )
	
	if !IsValid( self.BulletEnt ) then
		self.BulletEnt	= ClientsideModel( self.BulletModel )
		self.BulletEnt:ManipulateBoneScale( 0, self.BulletS )
		self.BulletEnt:SetMaterial( self.BulletMat )
		self.BulletEnt:SetColor( self.BulletCol )
		
		local newPos, newAng = LocalToWorld( self.BulletOffsetPos, self.BulletOffsetAng, startPos, self.Dir:Angle() )
		self.BulletEnt:SetPos( newPos )
		self.BulletEnt:SetAngles( newAng )
		
	elseif IsValid( self.BulletEnt ) then
		if self.LifeTime > 0 then
		
			local newPos, newAng = LocalToWorld( self.BulletOffsetPos, self.BulletOffsetAng, startPos, self.Dir:Angle() )
			self.BulletEnt:SetPos( newPos )
			
			if self.BulletParticle then
				ParticleEffectAttach( self.BulletParticle, 1, self.BulletEnt, -1 )
			elseif self.TracerMat then
				render.SetMaterial( self.TracerMat )				
				render.ANPlusDrawBeamTrail( self.BulletEnt, nil, Vector( -2, 0, 0 ), self.TracerCol, self.TracerS, self.TracerS, 0, self.TracerLength, 1, 1 )
			end
		end	
	end
	
	if self.TrailMat then
		local color = Color( self.TrailCol.r, self.TrailCol.g, self.TrailCol.b, self.TrailCol.a * fDelta )
		render.SetMaterial( self.TrailMat )	
		render.DrawBeam( startPosTr, endPosTr, self.TrailS + ( self.TrailS * 2 * fDelta2 ), 0, 1, color )
	end
	
end

effects.Register( EFFECT, "anp_tracer_3d" )