AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Combine Medic Thingy"
ENT.Author			= "FiLzO"
ENT.Purpose			= "Bazinga."
ENT.Category		= "ANPlus"

ENT.Spawnable		= false
ENT.AdminOnly		= false

sound.Add( {
	name = "CMANP.HPBomb.Deploy",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 70,
	pitch = 150,
	sound = { "npc/attack_helicopter/aheli_mine_drop1.wav" }
} )

sound.Add( {
	name = "CMANP.HPBomb.Tick",
	channel = CHAN_ITEM,
	volume = 1,
	level = 75,
	pitch = 70,
	sound = { "items/medshotno1.wav" }
} )

sound.Add( {
	name = "CMANP.HPBomb.Explode",
	channel = CHAN_ITEM,
	volume = 1,
	level = 75,
	pitch = 70,
	sound = { "items/smallmedkit1.wav" }
} )

--SETTINGS
ENT.PrepTimes = 4
ENT.Prep = 0
--SETTINGS
if (SERVER) then
	function ENT:Initialize()
		
		self:SetModel("models/healthvial.mdl")
		self:SetMaterial("models/healthvial/healthvial_blue")
			
		self:SetMoveType( MOVETYPE_FLYGRAVITY )
		self:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
			
		self:DrawShadow( true )
		self:SetNoDraw( false )
		self:AddEFlags( EFL_DONTBLOCKLOS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:EmitSound("CSBMedic.HPBomb.Deploy")
			
		SafeRemoveEntityDelayed( self , 5 )

		local self_phys = self:GetPhysicsObject()
			
		if ( IsValid( self_phys ) ) then	
			self_phys:EnableMotion(true)			
		end
			
		timer.Create("CSBMedBomb" .. self:EntIndex(), 0.5, self.PrepTimes, function()
			
			if !IsValid(self) then return end
				
			self.Prep = self.Prep + 1
				
			if self.Prep < self.PrepTimes then
				
				if (SERVER) then self:ANPlusHaloEffect( Color( 0, 155, 255 ), 1, 0.5 ) end
				self:EmitSound("CSBMedic.HPBomb.Tick")
				
			elseif self.Prep >= self.PrepTimes then
											
				self:Explode()

			end
			
		end)
			
	end
		
	function ENT:Explode()
			
		if !IsValid(self.Owner) then self:Remove() end
			
		local allyTab = ents.FindInSphere( self:GetPos(), 300 )
				
		for _, ally in pairs( allyTab ) do
					
			if IsValid(ally) && ( ally:IsNPC() || ( ally:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() ) ) && ally != self && self:Visible( ally ) && ally:ANPlusAlive() && ally:GetMaxHealth() > 0 && ally:Health() < ally:GetMaxHealth() && ally:GetBloodColor() == 0 && self.Owner:Disposition( ally ) != D_HT then
					
				local need = math.min( ally:GetMaxHealth() - ally:Health(), 50 )-- Dont overheal 
				ally:SetHealth( math.min( ally:GetMaxHealth(), ally:Health() + need ) )
						 
				ally:ANPlusHaloEffect( Color( 0, 155, 255 ), 7, 2 ) 					
				ally:EmitSound( "ANP.CombineMedicHeal.Passive" )
				self:EmitSound("CSBMedic.HPBomb.Explode")
					
				local fx = EffectData()
				fx:SetEntity( self )
				fx:SetOrigin( self:GetPos() + Vector( 0, 0, 10 ) )
				util.Effect( "cm_healthing_smoke", fx, true )	
					
			end
				
		end
			
		self:Remove()
		
	end
end