AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "[ANP] Invasion Start"
ENT.Author			= "FiLzO"

if (CLIENT) then
	local USE_KEY = string.upper( input.LookupBinding( "use", false ) )
	ENT.Purpose			= "[ANP Invasion Start Button]" ..
						"\n Used to start the Invasion." ..
						"\n Use your USE (" .. USE_KEY .. ") key on it to start the invasion."
end

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
	
		local model = self:GetModel() != "models/error.mdl" && self:GetModel() || "models/hunter/blocks/cube025x025x025.mdl"
		local material = self:GetMaterial() != "" && self:GetMaterial() || "models/debug/debugwhite"
		local color = self:GetColor() != Color( 255, 255, 255 ) && self:GetColor() || Color( 55, 55, 55, 255 )
		self:SetModel( model  )
		self:SetMaterial( material )
		self:SetColor( color )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )	
		self:DrawShadow( false )
		self:SetTrigger( true )
		self:SetUseType( SIMPLE_USE )
		
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		local self_phys = self:GetPhysicsObject()
		if ( IsValid( self_phys ) ) then
			self_phys:SetMaterial( "metal" )
			--self_phys:Wake()
		end
	
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Use(ply)
		if !ply:IsPlayer() then return end	
		local invCont = ents.FindByClass( "sent_anp_invasion" )
		for _, v in pairs( invCont ) do
			if IsValid(v) then 
				if !v:GetNWBool( "ANP_INV_ACTIVE" ) then 
					v:Start()
				end
				return
			end
		end
		if #invCont <= 0 then
			ANPlusMSGPlayer( true, "No Invasion Control detected!", Color( 255, 100, 0 ), "ANP.UI.Error" )
		end
		
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
	function ENT:Draw()
		self:DrawModel()	
	end
end
