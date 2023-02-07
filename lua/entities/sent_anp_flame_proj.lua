AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "base_gmodentity"
ENT.PrintName			= "Napalm"
ENT.Author				= "filz0"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

--SETTINGS
ENT.Life = 0
ENT.Radius = 0
ENT.Damage = 0
--SETTINGS
ENT.DieTime = 0
ENT.Setup = false

if (SERVER) then

	function ENT:Initialize()
		
		--self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		self:SetNoDraw( true )
		self:DrawShadow( false )
		self:PhysicsInitSphere( self.Radius, "default_silent" )
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBounds( Vector() * -self.Radius, Vector() * self.Radius )
		self:AddEFlags( EFL_DONTBLOCKLOS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:SetTrigger( true )
		
		local zfire = ents.Create( "env_fire_trail" )
		zfire:SetPos( self:GetPos() )
		zfire:SetParent( self )
		zfire:Spawn()
		zfire:Activate()
		
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass( 0.01 )
			phys:SetDamping( 2.5, 5 )
			--phys:EnableGravity( false )
			phys:Wake()
		end

		self.DieTime = CurTime() + self.Life
		self.Setup = true
		
	end

	function ENT:Think()

		if ( self.Setup && CurTime() > self.DieTime ) || self:WaterLevel() > 1 then
			print("fuck", CurTime())
			self:Remove()
		end
		
		if IsValid(self:GetParent()) && self:GetParent():ANPlusAlive() then
			self:Firefy( self:GetParent() ) 
		--elseif IsValid(self:GetParent()) && !self:GetParent():ANPlusAlive() then
			--self:SetParent()
		end
		
	end

	function ENT:PhysicsCollide(data,phys)
		
		
		
		if data.HitEntity:GetClass() != self:GetClass() then
			if data.HitEntity:IsWorld() then
				self:GetPhysicsObject():EnableMotion( false )
			else		
				self:Firefy( data.HitEntity )
			end
		end
		
	end

	function ENT:Firefy(ent)
	
		if !IsValid(ent) || ent == self:GetOwner() || ent:GetClass() == self:GetClass() then return end
		
		if ent:WaterLevel() > 1 then return end
		
		local attacker = IsValid(self:GetOwner()) && self:GetOwner() || self				
		local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_BURN )
			dmginfo:SetDamage( self.Damage )
			dmginfo:SetAttacker( attacker )
			dmginfo:SetInflictor( IsValid(self:GetOwner()) && IsValid(self:GetOwner():GetActiveWeapon()) && self:GetOwner():GetActiveWeapon() || self )
		
		attacker:ANPlusDealDamage( ent, dmginfo, 0.1, function(self, dmginfo)
			if ent:IsOnFire() then ent:Extinguish() end
		end)
		
		if ( ent:IsNPC() || ent:IsPlayer() ) && !IsValid(self:GetParent()) then
			self:SetParent( ent )
		end
	
	end

	function ENT:Touch(ent)	
		self:Firefy( ent )		
	end
	
	function ENT:OnRemove()
	end

end
