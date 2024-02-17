function SWEP:SetupWeaponHoldTypeForAI( hType )
	
	local owner = self:GetOwner()

	--if !IsValid(owner) then return end

	local function V_A(act) -- ValidActivity
		return owner:ANPlusSequenceExists(act)
	end

    self.ActivityTranslateAI = {}
	
	if hType == "ar2" then

            self.ActivityTranslateAI[ACT_IDLE]							= V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_SMG1_RELAXED) || V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_SMG1_STIMULATED) || V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= V_A(ACT_IDLE_AIM_RIFLE_STIMULATED) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= ACT_IDLE_ANGRY_SMG1

			self.ActivityTranslateAI[ACT_WALK]							= ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= V_A(ACT_WALK_RIFLE_RELAXED) || ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_RIFLE_STIMULATED) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM]						= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= ACT_WALK_AIM_RIFLE

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RUN]							= ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= V_A(ACT_RUN_RIFLE_RELAXED) || ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_WALK_RIFLE_STIMULATED) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM]						= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_AIM_RIFLE_STIMULATED) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= ACT_RUN_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_RIFLE
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RELOAD]						= ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= ACT_RELOAD_SMG1_LOW		

			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
		
	elseif hType == "smg" then

            self.ActivityTranslateAI[ACT_IDLE]							= ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_SMG1_RELAXED) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_SMG1_STIMULATED) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= ACT_IDLE_ANGRY_SMG1

			self.ActivityTranslateAI[ACT_WALK]							= ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= V_A(ACT_WALK_RIFLE_RELAXED) || ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_RIFLE_STIMULATED) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM]						= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= ACT_WALK_AIM_RIFLE

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_RIFLE
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_RIFLE

			self.ActivityTranslateAI[ACT_RUN]							= ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= V_A(ACT_RUN_RIFLE_RELAXED) || ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_WALK_RIFLE_STIMULATED) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM]						= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_AIM_RIFLE_STIMULATED) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= ACT_RUN_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RELOAD]						= ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= ACT_RELOAD_SMG1_LOW

			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= ACT_RANGE_AIM_SMG1_LOW
		
	elseif hType == "pistol" then
			
            self.ActivityTranslateAI[ACT_IDLE]							= V_A(ACT_IDLE_PISTOL) || ACT_IDLE
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_PISTOL) || ACT_IDLE
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= V_A(ACT_IDLE_STEALTH_PISTOL) || V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY

			self.ActivityTranslateAI[ACT_WALK]							= V_A(ACT_WALK_PISTOL) || ACT_WALK
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= V_A(ACT_WALK_PISTOL) || ACT_WALK
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= V_A(ACT_WALK_STEALTH_PISTOL) || V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM]						= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= V_A(ACT_WALK_AIM_STEALTH_PISTOL) || V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_AIM
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RUN]							= V_A(ACT_RUN_PISTOL) || ACT_RUN
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= V_A(ACT_RUN_PISTOL) || ACT_RUN
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= V_A(ACT_RUN_STEALTH_PISTOL) || V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM]						= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= V_A(ACT_RUN_AIM_STEALTH_PISTOL) || V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RELOAD]						= V_A(ACT_RELOAD_PISTOL) || ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= V_A(ACT_RELOAD_PISTOL_LOW) || ACT_RELOAD_SMG1_LOW

			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack) || V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_PISTOL) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_PISTOL) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= V_A(ACT_COVER_PISTOL_LOW) || ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= V_A(ACT_COVER_PISTOL_LOW) || ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
	elseif hType == "revolver" then
			
			self.ActivityTranslateAI[ACT_IDLE]							= V_A(ACT_IDLE_PISTOL) || ACT_IDLE
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_PISTOL) || ACT_IDLE
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= V_A(ACT_IDLE_STEALTH_PISTOL) || V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY

			self.ActivityTranslateAI[ACT_WALK]							= V_A(ACT_WALK_PISTOL) || ACT_WALK
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= V_A(ACT_WALK_PISTOL) || ACT_WALK
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= V_A(ACT_WALK_STEALTH_PISTOL) || V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM]						= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= V_A(ACT_WALK_AIM_STEALTH_PISTOL) || V_A(ACT_WALK_AIM_PISTOL) || ACT_WALK_AIM

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_AIM
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RUN]							= V_A(ACT_RUN_PISTOL) || ACT_RUN
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= V_A(ACT_RUN_PISTOL) || ACT_RUN
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= V_A(ACT_RUN_STEALTH_PISTOL) || V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM]						= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= V_A(ACT_RUN_AIM_STEALTH_PISTOL) || V_A(ACT_RUN_AIM_PISTOL) || ACT_RUN_AIM

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RELOAD]						= V_A(ACT_RELOAD_PISTOL) || ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= V_A(ACT_RELOAD_PISTOL_LOW) || ACT_RELOAD_SMG1_LOW

			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack) || V_A(ACT_IDLE_ANGRY_PISTOL) || ACT_IDLE_ANGRY
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_PISTOL) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_PISTOL) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= V_A(ACT_COVER_PISTOL_LOW) || ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= V_A(ACT_COVER_PISTOL_LOW) || ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= V_A(ACT_RANGE_AIM_PISTOL_LOW) || ACT_RANGE_AIM_SMG1_LOW

	elseif hType == "shotgun" then -- V_A() || 

            self.ActivityTranslateAI[ACT_IDLE]							= V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_SHOTGUN_RELAXED) || V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= V_A(ACT_IDLE_SHOTGUN_STIMULATED) || V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= V_A(ACT_IDLE_SHOTGUN_AGITATED) || V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1

			self.ActivityTranslateAI[ACT_WALK]							= ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM]						= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= V_A(ACT_WALK_AIM_SHOTGUN) || ACT_WALK_AIM_RIFLE

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_AIM
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RUN]							= ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM]						= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= V_A(ACT_RUN_AIM_SHOTGUN) || ACT_RUN_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RELOAD]						= V_A(ACT_RELOAD_SHOTGUN) || ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= V_A(ACT_RELOAD_SHOTGUN_LOW) || ACT_RELOAD_SMG1_LOW

			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack) || V_A(ACT_IDLE_ANGRY_SHOTGUN) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_SHOTGUN) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_SHOTGUN) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= ACT_COVER_SMG1_LOW 
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
	
	elseif hType == "crossbow" then -- V_A() || 
		
		    self.ActivityTranslateAI[ACT_IDLE]							= V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_SMG1_RELAXED) || V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_SMG1_STIMULATED) || V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= V_A(ACT_IDLE_AIM_RIFLE_STIMULATED) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= ACT_IDLE_ANGRY_SMG1

			self.ActivityTranslateAI[ACT_WALK]							= ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= V_A(ACT_WALK_RIFLE_RELAXED) || ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_RIFLE_STIMULATED) || ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM]						= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= ACT_WALK_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= ACT_WALK_AIM_RIFLE

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_AIM_RIFLE
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RUN]							= ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= V_A(ACT_RUN_RIFLE_RELAXED) || ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_WALK_RIFLE_STIMULATED) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM]						= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_AIM_RIFLE_STIMULATED) || ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= ACT_RUN_AIM_RIFLE
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= ACT_RUN_AIM_RIFLE

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RELOAD]						= ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= ACT_RELOAD_SMG1_LOW

			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack)|| ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_SHOTGUN) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_SHOTGUN) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= ACT_COVER_SMG1_LOW 
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
	
	elseif hType == "rpg" then

            self.ActivityTranslateAI[ACT_IDLE]							= V_A(ACT_IDLE_RPG) || V_A(ACT_IDLE_ANGRY_RPG) || V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_RELAXED]					= V_A(ACT_IDLE_RPG) || V_A(ACT_IDLE_ANGRY_RPG) || V_A(ACT_IDLE_RIFLE) || ACT_IDLE_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STIMULATED]				= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AGITATED]					= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_STEALTH]					= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_ANGRY]					= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_RELAXED]				= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STIMULATED]			= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_AGITATED]				= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_IDLE_AIM_STEALTH]				= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1

			self.ActivityTranslateAI[ACT_WALK]							= V_A(ACT_WALK_RPG_RELAXED) || V_A(ACT_WALK_RPG) || ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_RELAXED]					= V_A(ACT_WALK_RPG_RELAXED) || V_A(ACT_WALK_RPG) || ACT_WALK_RIFLE
			self.ActivityTranslateAI[ACT_WALK_STIMULATED]				= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_AGITATED]					= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_STEALTH]					= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_AIM]						= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_AIM_RELAXED]				= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_AIM_STIMULATED]			= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_AIM_AGITATED]				= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)
			self.ActivityTranslateAI[ACT_WALK_AIM_STEALTH]				= V_A(ACT_WALK_RPG) || V_A(ACT_WALK_RIFLE)

			self.ActivityTranslateAI[ACT_WALK_CROUCH]					= ACT_WALK_CROUCH_AIM
			self.ActivityTranslateAI[ACT_WALK_CROUCH_AIM]				= ACT_WALK_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RUN]							= V_A(ACT_RUN_RPG_RELAXED) || V_A(ACT_RUN_RPG) || ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_RELAXED]					= V_A(ACT_RUN_RPG_RELAXED) || V_A(ACT_RUN_RPG) || ACT_RUN_RIFLE
			self.ActivityTranslateAI[ACT_RUN_STIMULATED]				= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_AGITATED]					= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_STEALTH]					= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_AIM]						= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_AIM_RELAXED]				= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_AIM_STIMULATED]			= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_AIM_AGITATED]				= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)
			self.ActivityTranslateAI[ACT_RUN_AIM_STEALTH]				= V_A(ACT_RUN_RPG) || V_A(ACT_RUN_RIFLE)

			self.ActivityTranslateAI[ACT_RUN_CROUCH]					= ACT_RUN_CROUCH_AIM
			self.ActivityTranslateAI[ACT_RUN_CROUCH_AIM]				= ACT_RUN_CROUCH_AIM

			self.ActivityTranslateAI[ACT_RELOAD]						= ACT_RELOAD_SMG1
			self.ActivityTranslateAI[ACT_RELOAD_LOW]					= ACT_RELOAD_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1]					= V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_SHIELD_UP]						= V_A(self.Secondary.Attack) || V_A(ACT_IDLE_ANGRY_RPG) || ACT_IDLE_ANGRY_SMG1
			self.ActivityTranslateAI[ACT_RANGE_ATTACK1_LOW]				= V_A(ACT_RANGE_AIM_AR2_LOW) || V_A(ACT_RANGE_AIM_SMG1_LOW)
			self.ActivityTranslateAI[ACT_SHIELD_DOWN]					= V_A(self.Secondary.AttackLow) || V_A(ACT_RANGE_AIM_AR2_LOW) || V_A(ACT_RANGE_AIM_SMG1_LOW)
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK1]			= V_A(self.Primary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_SHOTGUN) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ACT_GESTURE_RANGE_ATTACK2]			= V_A(self.Secondary.AttackGesture) || V_A(ACT_GESTURE_RANGE_ATTACK_SHOTGUN) || V_A(ACT_GESTURE_RANGE_ATTACK_AR2) || ACT_GESTURE_RANGE_ATTACK_SMG1

			self.ActivityTranslateAI[ACT_COVER_LOW]						= V_A(ACT_COVER_LOW_RPG) || ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE]					= V_A(ACT_COVER_LOW_RPG) || ACT_COVER_SMG1_LOW
			self.ActivityTranslateAI[ACT_RANGE_AIM_LOW]					= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			
			self.ActivityTranslateAI[ACT_CROUCHIDLE_STIMULATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AIM_STIMULATED]		= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
			self.ActivityTranslateAI[ACT_CROUCHIDLE_AGITATED]			= V_A(ACT_RANGE_AIM_AR2_LOW) || ACT_RANGE_AIM_SMG1_LOW
	
	elseif hType == "custom" then 

		self:ANPlusSetupWeaponHoldTypeForAI( hType, owner )

    end
    
end