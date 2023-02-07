AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Sterilizer Tank"
ENT.Author			= "FiLzO"
ENT.Purpose			= "Bazinga."
ENT.Category		= "ANPlus"

ENT.Spawnable		= false
ENT.AdminOnly		= false

sound.Add( {
	name = "CMANP.SterTank.Damaged",
	channel = CHAN_AUTO,
	volume = 0.8,
	level = 75,
	pitch = 90,
	sound = "ambient/gas/cannister_loop.wav"
} )

sound.Add( {
	name = "CMANP.HPBomb.Explode",
	channel = CHAN_AUTO,
	volume = 0.8,
	level = 70,
	pitch = 120,
	sound = "ambient/explosions/explode_7.wav"
} )

--SETTINGS
ENT.TankHealth = 40
--SETTINGS

function ENT:Initialize()
	
	self:SetModel( "models/hunter/blocks/cube05x075x025.mdl" )
	self:ManipulateBoneScale( 0, Vector( 1, 0.7, 0.8 ) )
	if (CLIENT) then self:SetupBones() end
	self:SetNoDraw( true )
	self:DrawShadow( false )
	self:SetSolid( SOLID_BBOX )
	self:AddEFlags( EFL_DONTBLOCKLOS )
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMaterial( "canister" )
	end
	
	if (SERVER) then
		self:SetHealth( self.TankHealth )
		self:SetMaxHealth( self.TankHealth )
	end
		
end

function ENT:OnTakeDamage(dmginfo)
	
	local att = dmginfo:GetAttacker()
	local inf = dmginfo:GetInflictor()
	local dmgt = dmginfo:GetDamageType()
	local dmg = dmginfo:GetDamage()
	
	if self.Destroyed || ( IsValid(att) && att == self ) || ( IsValid(inf) && inf == self ) || !IsValid(self:GetOwner()) then return end
	if IsValid(att) && ( att:IsNPC() || att:IsPlayer() ) && ( self:GetOwner():Disposition( att ) == D_LI || self:GetOwner():Disposition( att ) == D_NU ) then return end
	if IsValid(att:GetOwner()) && ( att:GetOwner():IsNPC() || att:GetOwner():IsPlayer() ) && ( self:GetOwner():Disposition( att:GetOwner() ) == D_LI || self:GetOwner():Disposition( att:GetOwner() ) == D_NU ) then return end
					
	self:SetHealth(	self:Health() - dmg	)
					
	if self:Health() <= self:GetMaxHealth() * 0.5 && !self:IsOnFire() then
		self:Ignite( 10, 50 )
		self:EmitSound( "CMANP.SterTank.Damaged" )
		ParticleEffectAttach( "steam_jet_50", 1, self, 0 )
		if IsValid(self:GetOwner()) then
			local panicc = self:GetOwner():ANPlusTranslateSequence( "bugbait_hit" )
			self:GetOwner():ANPlusPlayActivity( panicc, 1 ) 
		end
		self.Attacker = att
	end
	
	if self:Health() <= 0 then
		self.Destroyed = true
		self:Explode()
	end
					
end
	
function ENT:Explode()
	
	if IsValid(self:GetOwner()) then self:GetOwner():SetHealth( 1 ) end
	local dmginfo = DamageInfo()
		dmginfo:SetDamageType( DMG_BURN )
		dmginfo:SetDamage( 100 )
		dmginfo:SetAttacker( IsValid(self.Attacker) && self.Attacker || IsValid(self:GetOwner()) && self:GetOwner() || self )
		dmginfo:SetInflictor( self )
	util.BlastDamageInfo( dmginfo, self:GetPos(), 80 )
	self:StopSound( "CMANP.SterTank.Damaged" )
	self:EmitSound( "CMANP.HPBomb.Explode" )
	ParticleEffect( "explosion_turret_break", self:GetPos(), self:GetAngles() )		
	self:Remove()
	
end

function ENT:OnRemove()
	self:StopSound( "CMANP.SterTank.Damaged" )
	self:StopParticles()
end
