local ENT = FindMetaTable("Entity")

--[[
function ENT:ANPlusGetHitGroupBone( hg )

	for i = 0, self:GetHitboxSetCount() - 1 do

		for j = 0, self:GetHitBoxCount( i ) - 1 do
			--print(self:GetHitBoxHitGroup( j, i ))
			if self:GetHitBoxHitGroup( j, i ) == hg then
				
				local bone = self:GetHitBoxBone( j, i )
				print(bone)
				if ( !bone || bone < 0 ) then return false end
				
				local pos, ang = self:GetBonePosition( bone )
				
				return pos
			
			else
								
				return false
			
			end
			
		end
		
	end

end
]]--

function ENT:ANPlusGetDataTab()
	if self:GetTable() && self:GetTable()['ANPlusData'] then
		return self:GetTable()['ANPlusData']
	else
		return nil
	end
end

function ENT:ANPMuteSound(bool)
	self:SetNWBool( "ANP_IsMuted", bool )
end

function ENT:ANPlusApplyFlexData(flexTab, scale)

	if !flexTab then return end
	
	self:SetFlexScale( scale || 1 )
	
	for i = 1, #flexTab do

		self:SetFlexWeight( i - 1, flexTab[ i ] )
		
	end

end

function ENT:ANPlusShootEffect( att, bone, muzzleeffect, smokeeffect, smokeafterfiredelay )

	local boneid = self:LookupBone( bone || "" )
	
	local fx = EffectData()
	fx:SetEntity( self )
	fx:SetAttachment( att || -1 )
	fx:SetColor( boneid || -1 )
	util.Effect( muzzleeffect, fx )	
	
	if smokeeffect then util.Effect( smokeeffect, fx ) end
	
	if smokeafterfiredelay then
	
		timer.Create( "ANPlus_SmokeEffectTimer"..self:EntIndex(), smokeafterfiredelay, 1, function()
			
			if !IsValid(self) then return end
			
			ParticleEffectAttach( "weapon_muzzle_smoke_b", 4, self, att )  
			
		end)
		
	end
	
end
--[[
function ENT:ANPlusHitEffect( tr, scale )
	
	if tr && tr.Hit && !tr.HitSky then 
	
		local fx = EffectData()
		fx:SetOrigin( tr.HitPos )
		fx:SetNormal( tr.HitNormal )
		fx:SetScale( scale || 0 )
		util.Effect( "anp_hit_effect", fx )
	
	end

end
--]]  
--[[
1 = models/shells/shell_9mm.mdl
2 = models/shells/shell_57.mdl
3 = models/shells/shell_556.mdl
4 = models/shells/shell_762nato.mdl
5 = models/shells/shell_12gauge.mdl
6 = models/shells/shell_338mag.mdl
7 = models/weapons/rifleshell.mdl
--]]

function ENT:ANPlusShell( att, bone, type, scale, angVec )
	
	local boneid = self:LookupBone( bone || "" )

	local fx = EffectData()
	fx:SetEntity( self )
	fx:SetAttachment( att || -1 )
	fx:SetColor( boneid || -1 )
	fx:SetRadius( type || 1 )
	fx:SetScale( scale || 1 )
	fx:SetStart( angVec || Vector( 0, 0, 0 ) )
	util.Effect( "anp_shell", fx )	

end

function ENT:ANPlusFireBullet( bullet, marksmanAiming, pos, delay, burstCount, burstReset, fireSND, distFireSND, callback )
	
	if !bullet then return end
	
	self.m_fANPBulletLast = self.m_fANPBulletLast || 0
	self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst || burstCount
	if bullet && ( delay && CurTime() - self.m_fANPBulletLast >= delay ) && ( !burstCount || ( burstCount > 0 && self.m_fANPCurBulletBurst > 0 ) ) then
		
		local src, dir = nil
		if marksmanAiming && ( IsValid(self:GetEnemy()) || IsValid(self:GetTarget()) ) then
			target = self:GetEnemy() || self:GetTarget()
			aimPos = target:ANPlusGetHitGroupBone( 1 ) || target:ANPlusGetHitGroupBone( 2 ) || target:ANPlusGetHitGroupBone( 3 ) || target:ANPlusGetHitGroupBone( 4 ) || target:ANPlusGetHitGroupBone( 5 ) || target:ANPlusGetHitGroupBone( 6 ) || target:ANPlusGetHitGroupBone( 7 ) || target:WorldSpaceCenter() || target:GetPos() 
			src, dir = self:ANPlusNPCGetImprovedAiming( pos, target, aimPos )
		end

		bullet.Src = bullet.Src || src || self:GetShootPos()
		bullet.Dir = bullet.Dir || dir || self:GetAimVector()
		self:FireBullets( bullet )
		
		if isfunction( callback ) then	
			callback( self )
		end

		if burstCount && burstCount > 0 then		
			self.m_fANPCurBulletBurst = self.m_fANPCurBulletBurst - 1
			timer.Create( "ANP_BulletBurstReset" .. self:EntIndex(), burstReset, 1, function()	
				if IsValid(self) then				
					self.m_fANPCurBulletBurst = burstCount || 0							
				end		
			end)		
		end
	
		if (SERVER) then
			if distFireSND then sound.Play( distFireSND, self:GetPos() ) end
			if fireSND then self:EmitSound( fireSND ) end
		end
	
		self.m_fANPBulletLast = CurTime()
	
	end
	
end

/*
ENT:ANPlusGetEmittedLastSound().SoundName
ENT:ANPlusGetEmittedLastSound().SoundLevel
ENT:ANPlusGetEmittedLastSound().SoundTime
ENT:ANPlusGetEmittedLastSound().Pitch
ENT:ANPlusGetEmittedLastSound().Channel
ENT:ANPlusGetEmittedLastSound().Volume
ENT:ANPlusGetEmittedLastSound().Flags
ENT:ANPlusGetEmittedLastSound().Pos
ENT:ANPlusGetEmittedLastSound().DSP
*/

function ENT:ANPlusGetEmittedLastSound()
	return self.m_tLastSoundEmitted
end

function ENT:ANPlusGetHearDistance()
	return self:ANPlusGetDataTab()['Functions'] && self:ANPlusGetDataTab()['Functions']['HearDistance'] || nil
end

function ENT:ANPlusNPCGetEyeTrace(dist, mask) -- Almost certainly doens't work.	
	local tr = util.TraceLine( {
		start = self:EyePos(),
		endpos = self:EyePos() + self:EyeAngles():Forward() * ( dist || 2056 ),
		filter = { self, self:GetActiveWeapon() },
		mask = mask || MASK_VISIBLE_AND_NPCS
	})
	
	return tr	
end

function ENT:ANPlusFakeModel(model, visualTab)

	if (SERVER) then
	
		if model && !IsValid(self.m_pFakeModel) then
			self.m_pFakeModel = ents.Create( "prop_dynamic" )
			self.m_pFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
			self.m_pFakeModel:Spawn()
			self.m_pFakeModel:SetSolid( SOLID_NONE )
			self.m_pFakeModel:SetMoveType( MOVETYPE_NONE )
			self.m_pFakeModel:SetNotSolid( true )
			self.m_pFakeModel:SetParent( self )
			self.m_pFakeModel:AddEffects( EF_BONEMERGE )
			self.m_pFakeModel:SetOwner( self )
			self:SetNoDraw( true )
			self:DrawShadow( false )
			self:DeleteOnRemove( self.m_pFakeModel )
			
			if self:IsNPC() then
				local addTab = { ['CurFakeModel'] = { ['Model'] = model, ['VisualTab'] = self.m_pFakeModel:ANPlusGetVisual() } }
				table.Merge( self:ANPlusGetDataTab()['CurData'], addTab )			
				self:ANPlusApplyDataTab( self:ANPlusGetDataTab() )
			end
			
		elseif model && IsValid(self.m_pFakeModel) then
		
			self.m_pFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
			if self:IsNPC() then
				local addTab = { ['CurFakeModel'] = { ['Model'] = model, ['VisualTab'] = self.m_pFakeModel:ANPlusGetVisual() } }
				table.Merge( self:ANPlusGetDataTab()['CurData'], addTab )			
				self:ANPlusApplyDataTab( self:ANPlusGetDataTab() )
			end
		end
		
		return IsValid(self.m_pFakeModel) && self.m_pFakeModel || false
		
	elseif (CLIENT) then
	
		if model && !IsValid(self.m_pCFakeModel) then
			self.m_pCFakeModel = ents.CreateClientProp( model )
			self.m_pCFakeModel:ANPlusCopyVisualFrom( visualTab || self )
			self.m_pCFakeModel:Spawn()
			self.m_pCFakeModel:SetSolid( SOLID_VPHYSICS )
			self.m_pCFakeModel:SetMoveType( MOVETYPE_NONE )
			self.m_pCFakeModel:SetNotSolid( true )
			self.m_pCFakeModel:SetParent( self )
			self.m_pCFakeModel:AddEffects( EF_BONEMERGE )
			self.m_pCFakeModel:SetOwner( self )
			self:SetNoDraw( true )
			self:DrawShadow( false )
			
			function self.m_pCFakeModel:ANPlus_CheckCRemoval() -- Because C_Ragdolls don't call for the remove hooks.
				if !IsValid(self:GetParent()) then self:Remove() end
			end
			
			hook.Add( "Think", self.m_pCFakeModel, self.m_pCFakeModel.ANPlus_CheckCRemoval )
			
		elseif model && IsValid(self.m_pCFakeModel) then
			self.m_pCFakeModel:SetModel( model )
			if visualTab then self.m_pFakeModel:ANPlusCopyVisualFrom( visualTab ) end
		end
		
		return IsValid(self.m_pCFakeModel) && self.m_pCFakeModel || false
		
	end
	
end