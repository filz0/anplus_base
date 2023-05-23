AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.Author				= "filz0"
ENT.Category			= "TEST"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.m_fDistance 		= 200
ENT.m_fIgnoreWorld 		= false
ENT.m_fDirection 		= nil

ENT.m_sLaserMat 		= false
ENT.m_sStartDotMat 		= false
ENT.m_sEndDotMat 		= false

ENT.m_fLaserWidth 		= { 1, 1 }
ENT.m_fLaserMatStart 	= 0
ENT.m_fLaserMatEnd 		= 1
ENT.m_fLaserFPS 		= 1

ENT.m_fStartDotWidth 	= { 1, 1 }
ENT.m_fStartDotHeight 	= { 1, 1 }

ENT.m_fEndDotWidth 		= { 1, 1 }
ENT.m_fEndDotHeight 	= { 1, 1 }

ENT.m_sLaserColor 		= Color( 0, 220, 255, 255 )
ENT.m_sStartDotColor 	= Color( 0, 220, 255, 255 )
ENT.m_sEndDotColor 		= Color( 0, 220, 255, 255 )

ENT.m_tEntFilter 		= nil
ENT.m_fKillDelay 		= 0

ENT.m_funHitCallBack 	= nil

ENT.m_fNextThink 		= 0.05

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:DrawShadow( false )
	
	--self:PhysicsInit( SOLID_VPHYSICS )
	--self:SetSolid( SOLID_VPHYSICS )
	self:AddEFlags( EFL_DONTBLOCKLOS )
	
	self:SetColor( Color( 255, 255, 255, 0 ) )	
	
	self:SetNWBool( "LaserEnabled", true )
	self:SetNWFloat( "LaserDistance", self.m_fDistance )
	
	self:SetNWString( "LaserMat", self.m_sLaserMat )
	self:SetNWString( "StartDotMat", self.m_sStartDotMat )
	self:SetNWString( "EndDotMat", self.m_sEndDotMat )
	
	self:SetNWFloat( "LaserWidthMin", istable( self.m_fLaserWidth ) && self.m_fLaserWidth[ 1 ] || self.m_fLaserWidth )
	self:SetNWFloat( "LaserWidthMax", istable( self.m_fLaserWidth ) && self.m_fLaserWidth[ 2 ] || self.m_fLaserWidth )
	self:SetNWFloat( "LaserMatStart", self.m_fLaserMatStart )
	self:SetNWFloat( "LaserMatEnd", self.m_fLaserMatEnd )
	self:SetNWFloat( "LaserFPS", self.m_fLaserFPS )
	
	self:SetNWFloat( "StartDotWidthMin", istable( self.m_fStartDotWidth ) && self.m_fStartDotWidth[ 1 ] || self.m_fStartDotWidth )
	self:SetNWFloat( "StartDotWidthMax", istable( self.m_fStartDotWidth ) && self.m_fStartDotWidth[ 2 ] || self.m_fStartDotWidth )
	self:SetNWFloat( "StartDotHeightMin", istable( self.m_fStartDotHeight ) && self.m_fStartDotHeight[ 1 ] || self.m_fStartDotHeight )
	self:SetNWFloat( "StartDotHeightMax", istable( self.m_fStartDotHeight ) && self.m_fStartDotHeight[ 2 ] || self.m_fStartDotHeight )
	
	self:SetNWFloat( "EndDotWidthMin", istable( self.m_fEndDotWidth ) && self.m_fEndDotWidth[ 1 ] || self.m_fEndDotWidth )
	self:SetNWFloat( "EndDotWidthMax", istable( self.m_fEndDotWidth ) && self.m_fEndDotWidth[ 2 ] || self.m_fEndDotWidth )
	self:SetNWFloat( "EndDotHeightMin", istable( self.m_fEndDotHeight ) && self.m_fEndDotHeight[ 1 ] || self.m_fEndDotHeight )
	self:SetNWFloat( "EndDotHeightMax", istable( self.m_fEndDotHeight ) && self.m_fEndDotHeight[ 2 ] || self.m_fEndDotHeight )
	
	self:SetNWString( "LaserColor", tostring( self.m_sLaserColor ) )
	self:SetNWString( "StartDotColor", tostring( self.m_sStartDotColor ) )
	self:SetNWString( "EndDotColor", tostring( self.m_sEndDotColor ) )
	
	if (CLIENT) then
	--[[
		timer.Simple( 0.1, function()
			local dist = self:GetNWFloat( "LaserDistance" ) + 50
			local rbA, rbB = self:GetRenderBounds()
			self:SetRenderBounds( rbA, rbB, self:GetForward():GetNormalized() * dist )
		end )
	]]--
		hook.Add( "PreDrawEffects", self, self.DrawLaserBeam )
	end
	
	if self.m_fKillDelay && self.m_fKillDelay > 0 then SafeRemoveEntityDelayed( self, self.m_fKillDelay ) end	
end

function ENT:SetLaserColors(laserCol, startDotCol, endDotCol)
	if laserCol then self:SetNWString( "LaserColor", tostring( laserCol ) ) end
	if startDotCol then self:SetNWString( "StartDotColor", tostring( startDotCol ) ) end
	if endDotCol then self:SetNWString( "EndDotColor", tostring( endDotCol ) ) end
end

function ENT:ToggleLaser(bool)
	self:SetNWBool( "LaserEnabled", bool )
end

function ENT:Think()
	if self:GetNWBool( "LaserEnabled" ) then
		local dir = self.m_fDirection || self:GetForward():GetNormalized()
		local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos() + dir * self:GetNWFloat( "LaserDistance" ),
		ignoreworld = self.m_fIgnoreWorld,
		filter = self.m_tEntFilter || { self, self:GetOwner() }
		} )
		
		self:SetNWVector( "BeamHitPos", tr.HitPos )
		if self:GetNWVector( "BeamHitPos" ) && isfunction( self.m_funHitCallBack ) then
			self.m_funHitCallBack( self, tr ) 
		end
	end

	self:NextThink( CurTime() + self.m_fNextThink )
	return true
end

function ENT:DrawLaserBeam()
	if self:GetNWVector( "BeamHitPos" ) && self:GetNWBool( "LaserEnabled" ) then
		local hitPos = self:GetNWVector( "BeamHitPos" )
		local dist = self:GetNWFloat( "LaserDistance" )
		
		self.m_sCLaserMat = self.m_sCLaserMat || self:GetNWString( "LaserMat" ) && Material( self:GetNWString( "LaserMat" ) )
		self.m_sCStartDotMat = self.m_sCStartDotMat || self:GetNWString( "StartDotMat" ) && Material( self:GetNWString( "StartDotMat" ) )
		self.m_sCEndDotMat = self.m_sCEndDotMat || self:GetNWString( "EndDotMat" ) && Material( self:GetNWString( "EndDotMat" ) )
	
		local laserCol = string.ToColor( self:GetNWString( "LaserColor" ) )
		local laserWidth = self:GetNWFloat( "LaserWidthMin" ) == self:GetNWFloat( "LaserWidthMax" ) && self:GetNWFloat( "LaserWidthMin" ) || math.random( self:GetNWFloat( "LaserWidthMin" ), self:GetNWFloat( "LaserWidthMax" ) )
		local laserMatStart = self:GetNWFloat( "LaserMatStart" )
		local laserMatEnd = self:GetNWFloat( "LaserMatEnd" )
		local laserFPS = CurTime() * self:GetNWFloat( "LaserFPS" )
		local startDotCol = string.ToColor( self:GetNWString( "StartDotColor" ) )
		local startDotWidth = self:GetNWFloat( "StartDotWidthMin" ) == self:GetNWFloat( "StartDotWidthMax" ) && self:GetNWFloat( "StartDotWidthMin" ) || math.random( self:GetNWFloat( "StartDotWidthMin" ), self:GetNWFloat( "StartDotWidthMax" ) )
		local startDotHeight = self:GetNWFloat( "StartDotHeightMin" ) == self:GetNWFloat( "StartDotHeightMax" ) && self:GetNWFloat( "StartDotHeightMin" ) || math.random( self:GetNWFloat( "StartDotHeightMin" ), self:GetNWFloat( "StartDotHeightMax" ) )
		local endDotCol = string.ToColor( self:GetNWString( "EndDotColor" ) )
		local endDotWidth = self:GetNWFloat( "EndDotWidthMin" ) == self:GetNWFloat( "EndDotWidthMax" ) && self:GetNWFloat( "EndDotWidthMin" ) || math.random( self:GetNWFloat( "EndDotWidthMin" ), self:GetNWFloat( "EndDotWidthMax" ) )
		local endDotHeight = self:GetNWFloat( "EndDotHeightMin" ) == self:GetNWFloat( "EndDotHeightMax" ) && self:GetNWFloat( "EndDotHeightMin" ) || math.random( self:GetNWFloat( "EndDotHeightMin" ), self:GetNWFloat( "EndDotHeightMax" ) )

		cam.Start3D()
			
			if self.m_sCLaserMat then
				render.SetMaterial( self.m_sCLaserMat )
				--render.DrawBeam( self:GetPos(), hitPos, laserWidth, laserMatStart, laserMatEnd, laserCol )
				
				render.DrawBeam( self:GetPos(), hitPos, laserWidth, laserFPS + laserMatStart, laserFPS + laserMatEnd, laserCol )
			end
			if self.m_sCStartDotMat then 
				render.SetMaterial( self.m_sCStartDotMat )
				render.DrawSprite( self:GetPos(), startDotWidth, startDotHeight, startDotCol )
			end
			if self.m_sCEndDotMat then
				render.SetMaterial( self.m_sCEndDotMat )
				render.DrawSprite( hitPos, endDotWidth, endDotHeight, endDotCol )
			end
			
		cam.End3D()
	end
end

--if CLIENT then function ENT:Think() end end