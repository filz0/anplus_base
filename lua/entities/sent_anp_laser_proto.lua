AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_entity"
ENT.Author				= "filz0"
ENT.Category			= "TEST"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.m_fDistance 		= 200
ENT.m_fIgnoreWorld 		= false

ENT.m_tEntFilter 		= nil
ENT.m_fKillDelay 		= 0

ENT.m_funHitCallBack 	= nil

ENT.m_fNextThink 		= 0.05

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "LaserEnabled" )
	self:NetworkVar( "Float", 0, "LaserDistance" )

	self:NetworkVar( "String", 0, "LaserMat" )
	self:NetworkVar( "String", 1, "StartDotMat" )
	self:NetworkVar( "String", 2, "EndDotMat" )

	self:NetworkVar( "Float", 1, "LaserWidthMin" )
	self:NetworkVar( "Float", 2, "LaserWidthMax" )
	self:NetworkVar( "Float", 3, "LaserMatStart" )
	self:NetworkVar( "Float", 4, "LaserMatEnd" )
	self:NetworkVar( "Float", 5, "LaserFPS" )

	self:NetworkVar( "Float", 6, "StartDotWidthMin" )
	self:NetworkVar( "Float", 7, "StartDotWidthMax" )
	self:NetworkVar( "Float", 8, "StartDotHeightMin" )
	self:NetworkVar( "Float", 9, "StartDotHeightMax" )

	self:NetworkVar( "Float", 10, "EndDotWidthMin" )
	self:NetworkVar( "Float", 11, "EndDotWidthMax" )
	self:NetworkVar( "Float", 12, "EndDotHeightMin" )
	self:NetworkVar( "Float", 13, "EndDotHeightMax" )

	self:NetworkVar( "Vector", 0, "LaserColor" )
	self:NetworkVar( "Vector", 1, "StartDotColor" )
	self:NetworkVar( "Vector", 2, "EndDotColor" )

	if (SERVER) then
		self:SetLaserEnabled( true )
	end

end

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:DrawShadow( false )
	
	--self:PhysicsInit( SOLID_VPHYSICS )
	--self:SetSolid( SOLID_VPHYSICS )
	self:AddEFlags( EFL_DONTBLOCKLOS )
	
	self:SetColor( Color( 255, 255, 255, 0 ) )	
	
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
	if laserCol then self:SetLaserColor( laserCol:ToVector() ) end
	if startDotCol then self:SetStartDotColor( startDotCol:ToVector() ) end
	if endDotCol then self:SetEndDotColor( endDotCol:ToVector() ) end
end

function ENT:Think()
	if self:GetLaserEnabled() then
		local dir = self:GetForward():GetNormalized()
		local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos() + dir * self:GetLaserDistance(),
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
	if self:GetNWVector( "BeamHitPos" ) && self:GetLaserEnabled() then
		local hitPos = self:GetNWVector( "BeamHitPos" )
		local dist = self:GetLaserDistance()
		
		self.m_sCLaserMat = self.m_sCLaserMat || self:GetLaserMat() && Material( self:GetLaserMat() )
		self.m_sCStartDotMat = self.m_sCStartDotMat || self:GetStartDotMat() && Material( self:GetStartDotMat() )
		self.m_sCEndDotMat = self.m_sCEndDotMat || self:GetEndDotMat() && Material( self:GetEndDotMat() )
	
		local laserCol = self:GetLaserColor():ToColor()
		local laserWidth = self:GetLaserWidthMin() == self:GetLaserWidthMax() && self:GetLaserWidthMin() || math.random( self:GetLaserWidthMin(), self:GetLaserWidthMax() )
		local laserMatStart = self:GetLaserMatStart()
		local laserMatEnd = self:GetLaserMatEnd()
		local laserFPS = CurTime() * self:GetLaserFPS()
		local startDotCol = self:GetStartDotColor():ToColor()
		local startDotWidth = self:GetStartDotWidthMin() == self:GetStartDotWidthMax() && self:GetStartDotWidthMin() || math.random( self:GetStartDotWidthMin(), self:GetStartDotWidthMax() )
		local startDotHeight = self:GetStartDotHeightMin() == self:GetStartDotHeightMax() && self:GetStartDotHeightMin() || math.random( self:GetStartDotHeightMin(), self:GetStartDotHeightMax() )
		local endDotCol = self:GetEndDotColor():ToColor()
		local endDotWidth = self:GetEndDotWidthMin() == self:GetEndDotWidthMax() && self:GetEndDotWidthMin() || math.random( self:GetEndDotWidthMin(), self:GetEndDotWidthMax() )
		local endDotHeight = self:GetEndDotHeightMin() == self:GetEndDotHeightMax() && self:GetEndDotHeightMin() || math.random( self:GetEndDotHeightMin(), self:GetEndDotHeightMax() )

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