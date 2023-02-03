AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_gmodentity"
ENT.PrintName			= "ANP TEST ENTITY"
ENT.Category			= "ANP[BASE]"
ENT.Author				= "filz0"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.Particle = "electrical_arc_01"

function ENT:Initialize()

	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetColor( Color( 255, 255, 255, 50 ) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
	self:SetSolid( SOLID_VPHYSICS )
	self:AddEFlags( EFL_DONTBLOCKLOS )
	self:DrawShadow( false )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
end

function ENT:Think()
end

function ENT:OnTakeDamage()
	ParticleEffect( self.Particle, self:GetPos() + Vector( 0, 0, 50 ), self:GetAngles(), self )
end

function ENT:Use()
	self:StopParticles()
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:Touch()
end

function ENT:OnRemove()
	self:StopParticles()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data, phys)
end