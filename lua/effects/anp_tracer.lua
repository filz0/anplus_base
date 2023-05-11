function EFFECT:Init(data)

	self.StartPos 		= data:GetStart()
	self.Entity  		= data:GetEntity()
	
	if ( !IsValid(self.Entity) ) then return end
	
	local dataTab 		= self.Entity.ANPTracerSettingTab
	self.EndPos 		= data:GetOrigin()
	self.Dir 			= self.EndPos - self.StartPos
	self.Normal 		= self.Dir:GetNormal()
	self.StartTime 		= 0
	self.LifeTime 		= ( self.Dir:Length() + 200 ) / 7000
	self.TrailDur		= dataTab && dataTab['TrailDuration'] || 1
	self.DieTime 		= CurTime() + self.TrailDur
	self.TrailLast 		= CurTime()	
	
	self.TracerMat		= dataTab && dataTab['TracerMat'] && Material( dataTab['TracerMat'] ) || ( dataTab && dataTab['TracerMat'] == nil || !dataTab ) && Material( "effects/spark" ) 
	self.TracerS		= dataTab && dataTab['TracerScale'] || 1
	self.TracerLength	= dataTab && dataTab['TracerLength'] || 200
	self.TracerSpeedMul	= dataTab && dataTab['TracerSpeedMul'] || 1
	self.TracerCol		= dataTab && dataTab['TracerColor'] || Color( 255, 255, 255, 255 )
	
	self.TrailMat		= dataTab && dataTab['TrailMat'] && Material( dataTab['TrailMat'] ) || ( dataTab && dataTab['TrailMat'] == nil || !dataTab ) && Material( "effects/anp/tracer_trail" ) || false
	self.TrailS			= dataTab && dataTab['TrailScale'] || 1	
	self.TrailDelay		= dataTab && dataTab['TrailDelay'] || 200	
	self.TrailCol		= dataTab && dataTab['TrailColor'] || Color( 10, 10, 10, 255 )

	local attachment = self.Entity:GetAttachment( data:GetAttachment() )
	if attachment then
		self.StartPos = attachment.Pos
	end
	hook.Add( "PreDrawEffects", self, self.RenderFixed )
end

function EFFECT:Think()
	if self.DieTime == nil || self.LifeTime == nil then return end
	if ( CurTime() > self.DieTime ) then return false end
	self.LifeTime = self.LifeTime - FrameTime() * self.TracerSpeedMul
	self.StartTime = self.StartTime + FrameTime() * self.TracerSpeedMul
	return true
end

function EFFECT:Render()
end

function EFFECT:RenderFixed()
	
	local tracerDelay 		= 7000
	local tracerDelayTr 	= tracerDelay - self.TrailDelay
	local endDistance 		= tracerDelay * self.StartTime
	local endDistanceTr 	= tracerDelayTr * self.StartTime
	local startDistance 	= endDistance - self.TracerLength
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
	fDelta 					= math.Clamp( fDelta, 0, 1 )
	fDelta2					= math.Clamp( fDelta2, 0, 1 )

	if self.LifeTime > 0 then
		render.SetMaterial( self.TracerMat )
		render.DrawBeam( startPos, endPos, self.TracerS, 0, 1, self.TracerCol )
		--[[
		local newAng = self.Dir:Angle() + Angle( 90, 0, 0 )
		cam.Start3D2D( endPos, newAng, 1 )
		
			surface.SetDrawColor( 255, 200, 100, 255 ) -- Set the drawing color
			surface.SetMaterial( self.Cap ) -- Use our cached material
			surface.DrawTexturedRect( -1, -1, 2, 2 ) -- Actually draw the rectangle
		
		cam.End3D2D()
		]]--
	end	
	
	if self.TrailMat then
		local color = Color( self.TrailCol.r, self.TrailCol.g, self.TrailCol.b, self.TrailCol.a * fDelta )
		render.SetMaterial( self.TrailMat )	
		render.DrawBeam( startPosTr, endPosTr, self.TrailS + ( self.TrailS * 2 * fDelta2 ), 0, 1, color )
	end
	
end

effects.Register( EFFECT, "anp_tracer" ) 

--[[
-----------------\
-----------------|\
--By Cpt.Hazama--| > http://steamcommunity.com/id/cpthazama/
-----------------|/
-----------------/
EFFECT.Mat = Material( "effects/spark" ) 

function EFFECT:Init(data)

	self.StartPos 	= data:GetStart();
	self.Entity  	= data:GetEntity();
	self.EndPos 	= data:GetOrigin();
	self.Dir 		= self.EndPos - self.StartPos;
	self.Normal 	= self.Dir:GetNormal();
	self.StartTime 	= 0;
	self.LifeTime 	= (self.Dir:Length()+200)/7000;
	
	if (!IsValid(self.Entity)) then return end
	
	local attachment = self.Entity:GetAttachment(data:GetAttachment());
	if(attachment) then
		self.StartPos = attachment.Pos;
	end
	
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
end

function EFFECT:Think()
if self.LifeTime == nil then return end
	self.LifeTime = self.LifeTime -FrameTime();
	self.StartTime = self.StartTime +FrameTime(); 
return self.LifeTime > 0;
end

function EFFECT:Render()

	local endDistance = 7000*self.StartTime;
	local startDistance = endDistance-200;
	
	startDistance = math.max(0,startDistance);
	endDistance = math.max(0,endDistance);

	local startPos = self.StartPos+self.Normal*startDistance;
	local endPos = self.StartPos+self.Normal*endDistance;
	
	local color = Color(255,255,200,255);
	
	render.SetMaterial(self.Mat);
	render.DrawBeam(startPos,endPos,6,0,1,color);
end
]]--