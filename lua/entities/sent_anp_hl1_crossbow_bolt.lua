AddCSLuaFile()
DEFINE_BASECLASS("sent_anp_base_proj")

if (CLIENT) then
	--killicon.Add( "sent_anp_immolator_proj", "HUD/killicons/ws_energy", Color ( 255, 80, 0, 255 ) )
	--language.Add( "sent_anp_immolator_proj", "Immolator Flame" )
end

ENT.Author					= "filz0"

ENT.Spawnable				= false
ENT.AdminSpawnable			= false
ENT.CurTurnSpeed			= 0
ENT.CurSpeed				= 0

--SETTINGS
ENT.Model 					= "models/anp/bullets/crossbow_bolt_hl1.mdl"
ENT.Rad						= 4

ENT.RunCollideOnDeath		= false
ENT.UsePhysCollide			= false
ENT.PhysObjUse				= 2 -- 1 = PhysObject 2 = Entity

ENT.EjectForce				= false
ENT.Thrust 					= false

ENT.LifeTime 				= 5
ENT.TouchDelay				= 0.1
ENT.TouchNext				= 0
ENT.Damage					= 1
ENT.BlastDamage				= 1
ENT.Radius					= 1

ENT.CollideDecal			= false
ENT.StartSND 				= false
ENT.LoopSND 				= false
--SETTINGS

if (SERVER) then 
	
	function ENT:ANPlusPreInitialize()	
	end

	function ENT:ANPlusOnInitialize()	
	
		self:SetCollisionBounds( Vector( -self.Rad, -self.Rad, -self.Rad ), Vector( self.Rad, self.Rad, self.Rad ) )
		self:SetTrigger( true )
		self:SetMoveType( MOVETYPE_FLYGRAVITY )
		self:SetMoveCollide( MOVECOLLIDE_FLY_CUSTOM )
		self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
		self:AddFlags( FL_NOTARGET )
		self:SetNotSolid( true )
		self:UseTriggerBounds( true, self.Rad )
		self.m_pWeapon = IsValid(self:GetOwner()) && self:GetOwner():GetActiveWeapon()

	end

	function ENT:Hit(ent)
		self.Touch = nil

		local owner = self:GetOwner()

		--if ent == game.GetWorld() then
		--	ent:ANPlusPaintDecal( true, "decals/kblaster_scorch", self:GetPos(), self:GetForward() * -1, Color( 255, 255, 255, 255 ), 0.4, 0.4 )
		--	ent:ANPlusPaintDecal( true, "decals/kblaster_glow", self:GetPos(), self:GetForward() * -1, Color( 255, 255, 255, 255 ), 0.4, 0.4 )
		--end

		local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetDamage( self.Damage )
			dmginfo:SetAttacker( IsValid(owner) && owner || self )
			dmginfo:SetInflictor( IsValid(self.m_pWeapon) && self.m_pWeapon || self )		
			dmginfo:SetDamagePosition( self:GetPos() )		
			dmginfo:SetDamageForce( ( self:GetPos() - ent:GetPos() ) )
		ent:TakeDamageInfo( dmginfo )
		
		local fx = EffectData()
			fx:SetEntity( self )
			fx:SetOrigin( self:GetPos() )
			fx:SetMagnitude( 0.2 )
			fx:SetScale( 0.2 )
			fx:SetFlags( 0 )
		util.Effect( "Explosion", fx )

		util.BlastDamage( ent, IsValid(owner) && owner || ent, ent:GetPos(), self.Radius, self.BlastDamage )
		
		self:Remove()

	end
	
	function ENT:ANPlusTouch(ent)		
		if !ent:ANPlusIsTrigger() && self:TouchCheck( ent, self, MASK_SHOT_HULL, self.Rad ) then
			self:Hit( ent )
		end
	end
	
end

