AddCSLuaFile()

if (CLIENT) then killicon.Add( "sent_anp_tpnade", "HUD/killicons/tpnade_frag", Color( 255, 80, 0, 255 ) ) end

ENT.Type 				= "anim"
ENT.Base 				= "base_gmodentity"
ENT.PrintName			= "Synth TPNade"
ENT.Author				= "filz0"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.ReadyToTeleport		= false

sound.Add( {
	name = "ANP.SynthSoldier.TPnade.Active",
	channel = CHAN_WEAPON,
	volume = 0.7,
	level = 65,
	pitch = 130,
	sound = "npc/synth_soldier/tpnade_charge.wav"
} )

sound.Add( {
	name = "ANP.SynthSoldier.TPnade.Damaged",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 80,
	pitch = { 90, 110 },
	sound = { "ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav", "ambient/energy/spark5.wav", "ambient/energy/spark6.wav", }
} )

sound.Add( {
	name = "ANP.SynthSoldier.TPnade.Teleport",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 70,
	pitch = 130,
	sound = "ambient/machines/teleport1.wav"
} )

sound.Add( {
	name = "ANP.SynthSoldier.TPnade.TeleportFail",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 70,
	pitch = 130,
	sound = "buttons/combine_button_locked.wav"
} )

sound.Add( {
	name = "ANP.SynthSoldier.TPnade.TeleportCritical",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 70,
	pitch = 130,
	sound = "ambient/explosions/explode_7.wav"
} )

sound.Add( {
	name = "ANP.SynthSoldier.TPnade.Bounce",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 80,
	pitch = { 99, 101 },
	sound = { "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_01_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_02_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_03_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_04_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_05_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_06_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_07_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_08_ext.wav", "weapons/sparbine_fb/phy_flash_bounce_concrete_hard_09_ext.wav" }
} )



function ENT:Initialize()

	self:SetModel( "models/cup/tpnade/tpnade.mdl" )
	self:SetMaterial( "phoenix_storms/metalset_1-2" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
	self:SetSolid( SOLID_VPHYSICS )
	self:AddEFlags( EFL_DONTBLOCKLOS )
	self:DrawShadow( false )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	util.SpriteTrail( self, 0, Color( 0, 200, 255 ), false, 14, 0, 0.5, 1 / ( 10 + 0 ) * 0.5, "effects/anp/generic_trail" )
					
	self.sprite = ents.Create("env_sprite")
	self.sprite:SetKeyValue('renderamt', '255')
	self.sprite:SetKeyValue('rendercolor', '0 200 255')
	self.sprite:SetKeyValue('rendermode', '3')
	self.sprite:SetKeyValue('model', 'sprites/glow.vmt')
	self.sprite:SetKeyValue('scale', '0.2')
	self.sprite:SetKeyValue('GlowProxySize', '1')
	self.sprite:SetKeyValue('renderfx', '10')
	self.sprite:SetOwner( self )
	self.sprite:ANPlusParent( self, nil, Vector( 0, 0, 0 ), nil )
	self.sprite:Spawn()
	self.sprite:Activate()
	self:DeleteOnRemove( self.sprite )
					
	self.sprite2 = ents.Create("env_sprite")
	self.sprite2:SetKeyValue('renderamt', '255')
	self.sprite2:SetKeyValue('rendercolor', '0 200 255')
	self.sprite2:SetKeyValue('rendermode', '3')
	self.sprite2:SetKeyValue('model', 'sprites/glow.vmt')
	self.sprite2:SetKeyValue('scale', '0.2')
	self.sprite2:SetKeyValue('GlowProxySize', '1')
	self.sprite2:SetKeyValue('renderfx', '10')
	self.sprite2:SetOwner( self )
	self.sprite2:ANPlusParent( self, nil, Vector( 0, 0, 3 ), nil )
	self.sprite2:Spawn()
	self.sprite2:Activate()
	self:DeleteOnRemove( self.sprite2 )
	
	local phys = self:GetPhysicsObject()
	
	if ( IsValid(phys) ) then
		
		phys:EnableMotion(true)
		phys:Wake()
		phys:SetMass( 5 )
		
	end
	
	timer.Simple( 3, function()
	
		if IsValid(self) && IsValid(self:GetOwner()) then 
		
			self.ReadyToTeleport = true
			
		elseif IsValid(self) then
		
			self:Remove()
			
		end
		
	end)
	
	self:EmitSound( "ANP.SynthSoldier.TPnade.Active" )
	
end

function ENT:Teleport()

	if !self:GetOwner():ANPlusCheckSpace( self:GetPos() + Vector( 0, 0, 5 ), self:GetPos() + Vector( 0, 0, 5 ), {self:GetOwner(), self:GetOwner():GetActiveWeapon(), self}, false, MASK_SHOT_HULL ) then
		
		self:GetOwner():SetPos( self:GetPos() + Vector( 0, 0, 5 ) )		
		
		if self.Damaged then
		
			ParticleEffect( "aurora_shockwave_debris", self:GetPos(), self:GetAngles() )
			self:EmitSound( "ANP.SynthSoldier.TPnade.TeleportCritical" )
			
			local dmginfo = DamageInfo()
				dmginfo:SetDamageType( DMG_DISSOLVE )
				dmginfo:SetDamage( self:GetOwner():GetMaxHealth() * 2 )
				dmginfo:SetAttacker( self.Attacker || self:GetOwner() )
				dmginfo:SetInflictor( self )
			
			self:GetOwner():ANPlusDealDamage( self:GetOwner(), dmginfo, 1 )		
			
		else
			
			ParticleEffect( "aurora_shockwave", self:GetOwner():GetPos() + self:GetOwner():OBBCenter(), self:GetAngles() )
			self:EmitSound( "ANP.SynthSoldier.TPnade.Teleport" )
			local makeSpace = ents.FindInSphere( self:GetPos(), 150 ) 
			
			for _, v in pairs( makeSpace ) do
									
				if IsValid(v) && v != self && v != self:GetOwner() && v:Health() > 0 && self:Visible(v) && ( ( v:IsNPC() || v:IsPlayer() ) && self:GetOwner():Disposition(v) != D_LI && self:GetOwner():Disposition(v) != D_NU ) then
									
					local force = ( v:GetPos() - self:GetPos() )						
					local dmginfo = DamageInfo()
						dmginfo:SetDamageType( DMG_DISSOLVE )
						dmginfo:SetDamage( 40 )
						dmginfo:SetAttacker( self:GetOwner() )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamageForce( force )
						
					self:GetOwner():ANPlusDealDamage( v, dmginfo, 1 )
									
				end		
			
			end
		
		end
		
	else	
		ParticleEffect( "electrical_arc_01", self:GetPos(), self:GetAngles() )
		self:EmitSound( "ANP.SynthSoldier.TPnade.TeleportFail" )		
	end		
	self:Remove()	
end

function ENT:Think()
	if self:GetVelocity():Length() <= 0 && self:ANPlusIsOnGround( 20 ) && self.ReadyToTeleport then
		self.ReadyToTeleport = false
		self:Teleport()
	end
end

function ENT:OnTakeDamage(dmginfo)	
	if !self.Damaged then
		local att = dmginfo:GetAttacker()
		ParticleEffect( "electrical_arc_01", self:GetPos(), self:GetAngles() )
		self:EmitSound( "ANP.SynthSoldier.TPnade.Damaged" )
		if IsValid(att) && ( att:IsPlayer() || att:IsNPC() ) then
			self.Attacker = att
		end
		self.Damaged = true		
	end	
end

function ENT:Use()
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:Touch()
end

function ENT:OnRemove()
	self:StopSound( "ANP.SynthSoldier.TPnade.Active" )
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data, phys)

	if data.Speed > 50 then
	
		self:EmitSound( "ANP.SynthSoldier.TPnade.Bounce" )
		
	end

end

if (CLIENT) then

	function ENT:Initialize()

		timer.Simple( 2.95, function()
			
			if !IsValid(self) then return end
			
			local dynamicflash = DynamicLight( self:EntIndex() )

			if ( dynamicflash ) then
				dynamicflash.Pos = self:GetPos()
				dynamicflash.r = 0
				dynamicflash.g = 200
				dynamicflash.b = 255
				dynamicflash.Brightness = 1.5
				dynamicflash.Size = 600
				dynamicflash.Decay = 1000
				dynamicflash.DieTime = CurTime() + 5
			end 
			
		end)
		
	end

	function ENT:Think()
	end

	function ENT:Draw()

		self:DrawModel()
	end

	function ENT:IsTranslucent()

		return true
	end
	
end