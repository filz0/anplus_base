local EFFECT = {}
EFFECT.Models = {}
EFFECT.Models[1] = Model( "models/shells/shell_9mm.mdl" )
EFFECT.Models[2] = Model( "models/shells/shell_57.mdl" )
EFFECT.Models[3] = Model( "models/shells/shell_556.mdl" )
EFFECT.Models[4] = Model( "models/shells/shell_762nato.mdl" )
EFFECT.Models[5] = Model( "models/shells/shell_12gauge.mdl" )
EFFECT.Models[6] = Model( "models/shells/shell_338mag.mdl" )
EFFECT.Models[7] = Model( "models/weapons/rifleshell.mdl" )
EFFECT.Models[8] = Model( "models/anp/shells/ar2_shell.mdl" )
EFFECT.Models[9] = Model( "models/Items/combine_rifle_ammo01.mdl" )

EFFECT.Sounds = {}
EFFECT.Sounds[1] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[2] = { Pitch = 100, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[3] = { Pitch = 90, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[4] = { Pitch = 90, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[5] = { Pitch = 110, Wavs = { "weapons/fx/tink/shotgun_shell1.wav", "weapons/fx/tink/shotgun_shell2.wav", "weapons/fx/tink/shotgun_shell3.wav" } }
EFFECT.Sounds[6] = { Pitch = 80, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[7] = { Pitch = 70, Wavs = { "player/pl_shell1.wav", "player/pl_shell2.wav", "player/pl_shell3.wav" } }
EFFECT.Sounds[8] = { Pitch = 70, Wavs = { "anp/fx/ar2_shell1.wav", "anp/fx/ar2_shell2.wav", "anp/fx/ar2_shell3.wav", "anp/fx/ar2_shell4.wav", "anp/fx/ar2_shell5.wav", "anp/fx/ar2_shell6.wav", "anp/fx/ar2_shell7.wav", "anp/fx/ar2_shell8.wav", "anp/fx/ar2_shell9.wav", "anp/fx/ar2_shell10.wav" } }
EFFECT.Sounds[9] = { Pitch = 70, Wavs = { "anp/fx/ar2_shell1.wav", "anp/fx/ar2_shell2.wav", "anp/fx/ar2_shell3.wav", "anp/fx/ar2_shell4.wav", "anp/fx/ar2_shell5.wav", "anp/fx/ar2_shell6.wav", "anp/fx/ar2_shell7.wav", "anp/fx/ar2_shell8.wav", "anp/fx/ar2_shell9.wav", "anp/fx/ar2_shell10.wav" } }

local cVar = GetConVar( "anplus_swep_shell_smoke" )

function EFFECT:Init( data )
	
	if not ( data:GetEntity() ):IsValid() then 
		self.Entity:SetModel( "models/shells/shell_9mm.mdl" )
		self.RemoveMe = true
		return 
	end
	
	self.OwnerEntity = data:GetEntity()
	
	--local bullettype = math.Clamp( ( data:GetRadius() || 1 ), 1, 6 )
	local bullettype = math.Round( data:GetRadius() ) || 1 
	local angle, pos = self.Entity:GetBulletEjectPos( data:GetOrigin(), data:GetEntity(), data:GetAttachment(), data:GetColor() )
	
	local angmod = data:GetStart() || Vector ( 0, 0, 0 )
	angle:RotateAroundAxis( angle:Forward(), angmod.x )
	angle:RotateAroundAxis( angle:Right(), angmod.y )
	angle:RotateAroundAxis( angle:Up(), angmod.z )
	
	local direction = angle:Forward()
	local ang = LocalPlayer():GetAimVector():Angle()

	self.Entity:SetPos( pos )
	self.Entity:SetModel( self.Models[ bullettype ] || "models/shells/shell_9mm.mdl" )
	
	self.Entity:PhysicsInitBox( Vector(-1,-1,-1), Vector(1,1,1) )
	
	self.Entity:SetModelScale( ( data:GetScale() || 1.2 ), 0 )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ( phys ):IsValid() then
	
		phys:Wake()
		phys:SetDamping( 0, 15 )
		phys:SetVelocity( direction * math.random( 100, 200 ) )
		phys:AddAngleVelocity( ( VectorRand() * 50000 ) )
		phys:SetMaterial( "gmod_silent" )
	
	end
	
	self.Entity:SetAngles( ang )
	
	if cVar:GetBool() then ParticleEffectAttach( "weapon_muzzle_smoke", 1, self.Entity, -1 ) end
	
	self.HitSound = table.Random( self.Sounds[ bullettype ].Wavs )
	self.HitPitch = self.Sounds[ bullettype ].Pitch + math.random(-10,10)
	
	self.SoundTime = CurTime() + math.Rand( 0.5, 0.75 )
	self.LifeTime = CurTime() + 3
	self.Alpha = 255
	
end

function EFFECT:GetBulletEjectPos( Position, Ent, Attachment, BoneID )

	if (!Ent:IsValid()) then return Angle(), Position end
	--if (!Ent:IsWeapon()) then return Angle(), Position end
	
	local att = Ent:GetAttachment( Attachment )
	
	if ( att ) then
	
		return att.Ang, att.Pos
		
	elseif ( BoneID ) then
		
		local Pos, Ang = self.OwnerEntity:GetBonePosition( BoneID )
		return Ang, Pos
		
	end

	return Angle(), Position

end


function EFFECT:Think( )

	if self.RemoveMe then return false end

	if self.SoundTime && self.SoundTime < CurTime() then
	
		self.SoundTime = nil
		sound.Play( self.HitSound, self.Entity:GetPos(), 60, self.HitPitch ) 
	
	end
	
	if self.LifeTime < CurTime() then
	
			self:Remove()
			
	end

	return self.Alpha > 2
	
end

function EFFECT:Render()

	self.Entity:DrawModel()

end
effects.Register( EFFECT, "anp_shell" ) 