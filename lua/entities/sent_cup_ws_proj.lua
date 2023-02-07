AddCSLuaFile()
DEFINE_BASECLASS("sent_anp_base_proj")

if (CLIENT) then
	killicon.Add( "sent_cup_ws_proj", "HUD/killicons/ws_energy", Color ( 255, 80, 0, 255 ) )
	language.Add( "sent_cup_ws_proj", "Energy Bolt" )
end

ENT.Author				= "filz0"

--SETTINGS
ENT.LoopSND 			= nil

ENT.Model 				= "models/props_lab/tpplug.mdl"
ENT.RunCollideOnDeath	= true
ENT.Speed 				= 900
ENT.SpeedAcceleration	= 900
ENT.Target				= nil
ENT.TurnSpeed 			= 40
ENT.TurnAcceleration	= 40

ENT.CollideDecal		= nil
ENT.LifeTime 			= 2
ENT.LoopSND 			= nil
--SETTINGS

if (SERVER) then
	
	function ENT:ANPlusOnInitialize()	
		self:SetNoDraw( true )
		self:DrawShadow( false )
		ParticleEffectAttach( "striderbuster_break_lightning", 1, self, 0 )
		ParticleEffectAttach( "striderbuster_break_lightning", 1, self, 0 )
		ParticleEffectAttach( "striderbuster_break_lightning", 1, self, 0 )
		local sprite = ANPlusCreateSprite( "sprites/animglow01.vmt", Color( 0, 255, 0 ), 0.3, 1, { rendermode = 5 } )
		sprite:ANPlusParent( self )
		--util.SpriteTrail(self,10,Color(0,255,0),true,100,0.6,0.6,12/(20+20)*30,"VJ_Base/sprites/vj_trial1.vmt")
		util.SpriteTrail( self, -1, Color( 0, 255, 0 ), true, 100, 8, 0.8, 0.125, "models/fassassin/eyetrail.vmt" )
	end
	
	function ENT:ANPlusOnPhysicsObj(physObj)	
		physObj:Wake()
		physObj:EnableDrag( false )
		physObj:EnableGravity( false )
		physObj:SetBuoyancyRatio( 0 )
	end
	
	function ENT:ANPlusOnThink()	
	end
	
	function ENT:ANPlusOnRemove()	
	end
	
	function ENT:ANPlusOnDestroyed(dmg)	
	end
	
	function ENT:ANPlusOnCollide()	
		local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_SHOCK )
			dmginfo:SetDamage( 35 )
			local att = IsValid(self:GetOwner()) && self:GetOwner() || self
			dmginfo:SetAttacker( att )
			dmginfo:SetInflictor( self )
		ParticleEffect( "vortigaunt_beam", self:LocalToWorld( Vector( math.random(1,1), math.random(1,1) ) ), Angle( 0, 0, 0 ), nil )
		ParticleEffect( "vortigaunt_beam", self:LocalToWorld( Vector( math.random(1,1), math.random(1,1) ) ), Angle( 0, 0, 0 ), nil )
		ParticleEffect( "vortigaunt_glow_beam_cp1b", self:LocalToWorld( Vector( math.random(1,1), math.random(1,1) ) ), Angle( 0, 0, 0 ), nil ) 
		self:EmitSound( "ANP.WasteScanner.EnergyExplode" )
		util.BlastDamageInfo( dmginfo, self:GetPos(), 100 )
		self:Remove()
	end

end
