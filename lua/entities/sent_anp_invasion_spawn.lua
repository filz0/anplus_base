AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "[ANP] Invasion NPC Spawnpoint"
ENT.Author			= "FiLzO"
ENT.Purpose			= "Used as a spawnpoint of Invasion NPCs." ..
					"\n Place it somewhere where NPCs won't get stuck." ..
					"\n Arrow indicates the way NPC will face after spawning."
ENT.Category		= "ANP[BASE]"

ENT.Spawnable		= true
ENT.AdminOnly		= true

if (SERVER) then
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Initialize()

		self:SetModel( "models/hunter/plates/plate1x1.mdl" )
		self:SetMaterial( "models/debug/debugwhite" )
		self:SetColor( Color( 55, 55, 55, 255 ) )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )	
		self:DrawShadow( false )
		
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		local self_phys = self:GetPhysicsObject()
		if ( IsValid( self_phys ) ) then
			self_phys:SetMaterial( "metal" )
			self_phys:Wake()
		end
	
		self:SetNWBool( "ANP_INV_SP_DRAW", true )
	
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:ShowSpawner(bool)
		self:SetNWBool( "ANP_INV_SP_DRAW", bool )
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Think()
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:PreEntityCopy()	
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:OnDuplicated( dupeTable )	
		self:SetNWBool( "ANP_INV_SP_DRAW", true )
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:PhysicsCollide(data, physobj)

		local SurTab = util.GetSurfaceData(util.GetSurfaceIndex(physobj:GetMaterial())) 
		if (data.Speed > 80 and data.Speed <= 250 and data.DeltaTime > 0.1) and SurTab.impactSoftSound then	
			self:EmitSound(SurTab.impactSoftSound)		
		elseif (data.Speed > 250 and data.DeltaTime > 0.1) and SurTab.impactHardSound then	
			self:EmitSound(SurTab.impactHardSound)		
		end
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:OnRemove()
	end
end
if (CLIENT) then
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:GetOverlayText()	
		if !self:GetNWBool( "ANP_INV_SP_DRAW" ) then return "" end
		if self.Purpose then	
			return self.Purpose
		else		
			return ""		
		end		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	local icon = Material( "effects/anp/sp_dir.png" )
	function ENT:Draw()
		if !self:GetNWBool( "ANP_INV_SP_DRAW" ) then return end
		self:DrawModel()	
		local offsetVec = Vector( 1, 0, 2 )
		local offsetAng = Angle( 0, 90, 0 )		
		local newPos, newAng = LocalToWorld( offsetVec, offsetAng, self:GetPos(), self:GetAngles() )
		cam.Start3D2D( newPos, newAng, 1 )

			surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
			surface.SetMaterial( icon ) -- Use our cached material
			surface.DrawTexturedRect( -10, -10, 20, 20 ) -- Actually draw the rectangle
		
		cam.End3D2D()
	end
end
