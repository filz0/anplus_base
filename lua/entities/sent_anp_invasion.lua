AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "[ANP] Invasion"
ENT.Author			= "FiLzO"
if (CLIENT) then
	local USE_KEY = string.upper( input.LookupBinding( "use", false ) )
	ENT.Purpose			= "[ANPlus Invasion Mini-Gamemode]" ..
						"\n Use your USE (" .. USE_KEY .. ") key on it" ..
						"\n to access the Invasion settings." ..
						"\n Duplicator tools may be used to copy/paste this entity with settings preserved."
end					
ENT.Category		= "ANP[BASE]"

ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.ActiveNPCTab = {}
ENT.NPCForCurWave = {}
ENT.NPCBossForCurWave = {}
ENT.NPCSpawnPoints = {}
ENT.ItemSpawners = {}
ENT.NPCBossSpawned = false
ENT.HUDLast = 0
ENT.HUDDelay = 0.2
ENT.NPCSpawnLast = 0
ENT.NPCSpawnDelay = 1
ENT.NPCsSpawned = 0
ENT.NPCCountUpdateLast = 0
ENT.NPCCountUpdateDelay = 0.2

if (SERVER) then
	
	util.AddNetworkString("ANP_InvasionUpdate")
	util.AddNetworkString("ANP_InvasionMenu")
	
	concommand.Add( "anplus_start_invasion", function(ply, cmd, args, argStr)
		if !ply:IsAdmin() then		
			ply:ChatPrint( "Only Admins can start the Invasion." )			
		else		
			for _, v in pairs( ents.FindByClass( "sent_anp_invasion" ) ) do
				v:Start()
			end		
		end	
	end)
	
	local rngDeathSND = {
		"anp/invasion/announcer/Totalled.mp3",
		"anp/invasion/announcer/Burn_out.mp3",
		"anp/invasion/announcer/Denied.mp3"	
	}
	local rngDeathLastSND = {
		"anp/invasion/announcer/sudden_death.mp3",
		"anp/invasion/announcer/last_man_standing.mp3"
	}
	
	hook.Add( "PlayerDeath", "ANPlusInvasion_PlayerDeath", function(ply, inf, att)
		for _, v in pairs( ents.FindByClass( "sent_anp_invasion" ) ) do
			if v:GetNWBool( "ANP_INV_ACTIVE" ) then
				if tonumber( v:GetNWFloat( "ANP_INV_PLY_LIFES" ) ) >= 1 then
					v:SetNWFloat( "ANP_INV_PLY_LIFES", v:GetNWFloat( "ANP_INV_PLY_LIFES" ) - 1 )
				end

				if tonumber( v:GetNWFloat( "ANP_INV_PLY_LIFES" ) ) > 1 && tonumber( v.SettingTab['PlayerLifes'] ) >= 1 || tonumber( v.SettingTab['PlayerLifes'] ) == 0 then
					ANPlusEmitUISound( true, rngDeathSND[ math.random( 1, #rngDeathSND ) ] )
				elseif tonumber( v:GetNWFloat( "ANP_INV_PLY_LIFES" ) ) == 1 && tonumber( v.SettingTab['PlayerLifes'] ) >= 1 then
					ANPlusEmitUISound( true, rngDeathLastSND[ math.random( 1, #rngDeathLastSND ) ] )
				end
			end
		end
	end)
	
	local garbage = {
		['item_battery'] = true,
		['item_healthvial'] = true,
		['item_ammo_ar2_altfire'] = true,
		['item_ammo_smg1_grenade'] = true,
		['weapon_frag'] = true,
	}
	
	hook.Add( "OnNPCKilled", "ANPlusInvasion_OnNPCKilled", function(npc, att, inf)
		if IsValid(npc) then
			if npc.ANPInvasionOnDeath != nil then
				npc.ANPInvasionOnDeath(npc, att, inf)
			end
			if npc.ANP_INV_NPC then
				local removeGarbage = ents.FindInSphere( npc:GetPos(), 120 )		
				for _, v in pairs( removeGarbage ) do
					if IsValid(v) && garbage[ v:GetClass() ] then SafeRemoveEntity( v ) end
				end
			end
		end
	end)
	
	hook.Add( "EntityRemoved", "ANPlusInvasion_EntityRemoved", function(npc)
		if IsValid(npc) && npc.ANPInvasionOnRemove != nil then
			npc.ANPInvasionOnRemove(npc)
		end
	end)
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Initialize()

		self.SettingTab = self.SaveTab || {
		['NPCMax'] 		= 5,
		['NPCToKill'] 	= 10,
		['NPCList'] 	= {},
		['NPCBossList'] = {},
		['RoundMax']	= 3,
		['PrepTime']	= 15,
		['CurRound']	= 0,
		['PlayerLifes']	= 0,
		['StripEQ']		= false,
		['MulHP']		= 0,
		--['MulDMG']		= 0,
		}
		
		for _, v in pairs( ents.FindByClass( "sent_anp_invasion" ) ) do
			if IsValid(v) && v != self then 
				self:Remove()
				return 
			end
		end
		
		self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
		self:SetMaterial("models/debug/debugwhite")
		self:SetColor( Color( 55, 55, 55, 255 ) )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )	
		self:DrawShadow( false )
		self:SetTrigger( true )
		self:SetUseType( SIMPLE_USE )
		
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		local self_phys = self:GetPhysicsObject()
		if ( IsValid( self_phys ) ) then
			self_phys:SetMaterial( "metal" )
			--self_phys:Wake()
		end
		
		self:SetNWFloat( "ANP_INV_NPC_COUNT", 0 )		
		for _, ply in pairs( player.GetAll() ) do
			ply:SetNWBool( "ANP_INV_HUD", true )
		end		
		self:SetNWBool( "ANP_INV_ACTIVE", false )
		
		self:SetNWFloat( "ANP_INV_CURROUND", self.SettingTab['CurRound'] )
		self:SetNWFloat( "ANP_INV_NPC_COUNT", #self.ActiveNPCTab )	
		self:SetNWFloat( "ANP_INV_MAXROUND", self.SettingTab['RoundMax'] )
		self:SetNWFloat( "ANP_INV_NPCTOKILL", self.SettingTab['NPCToKill'] )
		self:SetNWFloat( "ANP_INV_PLY_LIFES", self.SettingTab['PlayerLifes'] )
		self:SetNWFloat( "ANP_INV_PLY_LIFESMAX", self.SettingTab['PlayerLifes'] )
		self.FullyLoaded = true
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	function ENT:ResetStuff()
	
		for _, v in pairs( self.ActiveNPCTab ) do
			if IsValid(v) then
				SafeRemoveEntity( v )
			end
		end
		for _, v in pairs( self.NPCSpawnPoints ) do
			if IsValid(v) then 
				v:ShowSpawner( true )
			end
		end
		for _, sp in pairs( self.ItemSpawners ) do
			if IsValid(sp) then 
				sp:StopRespawningItem()
			end
		end
		ANPlusEmitUISound( true, "", 0 )
		self.ActiveNPCTab = {}
		self.NPCsSpawned = 0
		self.SettingTab['CurRound'] = 0
		self:SetNWFloat( "ANP_INV_CURROUND", self.SettingTab['CurRound'] )
		self:SetNWFloat( "ANP_INV_NPC_COUNT", 0 )	
		self:SetNWFloat( "ANP_INV_MAXROUND", self.SettingTab['RoundMax'] )
		self:SetNWFloat( "ANP_INV_NPCTOKILL", self.SettingTab['NPCToKill'] )
		self:SetNWFloat( "ANP_INV_PLY_LIFES", self.SettingTab['PlayerLifes'] )
		self:SetNWFloat( "ANP_INV_PLY_LIFESMAX", self.SettingTab['PlayerLifes'] )
		self:SetNWBool( "ANP_INV_ACTIVE", false )
		self.PrepTimeLast = CurTime() + self.SettingTab['PrepTime']
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Start()	
		
		self:ResetStuff()
		
		for _, v in pairs( ents.FindByClass( "sent_anp_invasion_spawn" ) ) do
			if IsValid(v) then 
				table.insert( self.NPCSpawnPoints, v )
			end
		end
		for _, v in pairs( ents.FindByClass( "sent_anp_invasion_item_sp" ) ) do
			if IsValid(v) then 
				table.insert( self.ItemSpawners, v )--v:UpdateItem(wave)
			end
		end
		
		if #self.NPCSpawnPoints <= 0 then
			ANPlusMSGPlayer( true, "Invasion can't start! No Spawnpoints detected!", Color( 255, 100, 0 ), "ANP.UI.Error" )
			return
		elseif #self.SettingTab['NPCList'] <= 0 then 
			ANPlusMSGPlayer( true, "Invasion can't start! NPC list empty!", Color( 255, 100, 0 ), "ANP.UI.Error" )
			return
		end
		
		for _, v in pairs( self.NPCSpawnPoints ) do
			if IsValid(v) then 
				v:ShowSpawner( false )
			end
		end
		
		self:SetNWBool( "ANP_INV_ACTIVE", true )
		self:NextWave()
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	function ENT:Stop()
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	function ENT:Use(ply)
		if !ply:IsPlayer() || self:GetNWBool( "ANP_INV_ACTIVE" ) then return end	

		net.Start( "ANP_InvasionMenu" )
		--net.WriteTable( list.Get( "NPC" ) ) -- Cuz on client it's missing half of the data >:(
		net.WriteTable( self.SettingTab )
		net.Send( ply )	
		net.Receive("ANP_InvasionUpdate", function(_, ply)
			local tab = net.ReadTable()		
			self.SettingTab = tab
			self:SetNWFloat( "ANP_INV_CURROUND", self.SettingTab['CurRound'] )
			self:SetNWFloat( "ANP_INV_MAXROUND", self.SettingTab['RoundMax'] )
			self:SetNWFloat( "ANP_INV_NPCTOKILL", self.SettingTab['NPCToKill'] )
			self:SetNWFloat( "ANP_INV_PLY_LIFES", self.SettingTab['PlayerLifes'] )
			self:SetNWFloat( "ANP_INV_PLY_LIFESMAX", self.SettingTab['PlayerLifes'] )
		end)
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:FailWave()
		
		self:ResetStuff()
		
		if tonumber( self.SettingTab['CurRound'] ) == 1 then
			ANPlusEmitUISound( true, "anp/invasion/announcer/Humiliating_defeat.mp3" )
		else
			ANPlusEmitUISound( true, "anp/invasion/announcer/You_Have_Lost_the_Match.mp3" )
		end	
		ANPlusEmitUISound( true, "anp/invasion/announcer/round_lost.mp3", 20 )
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:NextWave()
		
		self.SettingTab['CurRound'] = self.SettingTab['CurRound'] + 1
		self:SetNWFloat( "ANP_INV_CURROUND", self.SettingTab['CurRound'] )
		
		if tonumber( self.SettingTab['CurRound'] ) > tonumber( self.SettingTab['RoundMax'] ) then -- Victory!
		
			if self:GetNWFloat( "ANP_INV_PLY_LIFES" ) == tonumber( self.SettingTab['PlayerLifes'] ) then
				ANPlusEmitUISound( true, "anp/invasion/announcer/Flawless_victory.mp3" )
				ANPlusEmitUISound( true, "anp/invasion/music/victory2.mp3" )
			else
				ANPlusEmitUISound( true, "anp/invasion/announcer/You_Have_Won_the_Match.mp3" )
				ANPlusEmitUISound( true, "anp/invasion/music/final_round.mp3" )
			end	
			for _, v in pairs( self.NPCSpawnPoints ) do
				if IsValid(v) then 
					v:ShowSpawner( true )
				end
			end
			for _, sp in pairs( self.ItemSpawners ) do
				if IsValid(sp) then 
					sp:StopRespawningItem()
				end
			end
			
			self:SetNWBool( "ANP_INV_ACTIVE", false )
			self.PrepTimeLast = CurTime() + self.SettingTab['PrepTime']
			return
		end
		
		local countDown = self.SettingTab['PrepTime']
		self.NPCsSpawned = 0
		self:SetNWFloat( "ANP_INV_NPCTOKILL", self.SettingTab['NPCToKill'] )
		self:SetNWFloat( "ANP_INV_PLY_LIFES", self.SettingTab['PlayerLifes'] )
		self.NPCForCurWave = {}
		self.NPCBossForCurWave = {}
		self.NPCBossSpawned = false
		
		for _, npc in pairs( self.SettingTab['NPCList'] ) do	
			if npc['Wave'] == self.SettingTab['CurRound'] then
				table.insert( self.NPCForCurWave, npc )
			end
			timer.Simple( 0, function()
				if #self.NPCForCurWave <= 0 then
					if npc['Wave'] == 1 then
						table.insert( self.NPCForCurWave, npc )
					end
				end
			end)
		end
		
		if #self.SettingTab['NPCBossList'] > 0 then
			for _, npc in pairs( self.SettingTab['NPCBossList'] ) do	
				if npc['Wave'] == self.SettingTab['CurRound'] then
					table.insert( self.NPCBossForCurWave, npc )
				end
			end
		end
		
		for _, sp in pairs( self.ItemSpawners ) do
			if IsValid(sp) then 
				sp:UpdateItem( self.SettingTab['CurRound'] )
			end
		end
		
		if tonumber( self.SettingTab['CurRound'] ) == 1 then
			ANPlusEmitUISound( true, "anp/invasion/announcer/team_under_attack.mp3" )
			ANPlusScreenMsg( true, "anp_invasion", 750, 200, 100, 2, "( Enemy Attack Inbound )", "anp_inv_big", Color( 255, 255, 255 ) )
			if self.SettingTab['StripEQ'] then
				for _, ply in pairs( player.GetAll() ) do					
					ply:StripWeapons()			
					ply:StripAmmo()		
				end	
			end
		else
			ANPlusEmitUISound( true, "anp/invasion/announcer/EndOfRound.mp3" )
			ANPlusEmitUISound( true, "anp/invasion/announcer/round_won.mp3", 20 )
			ANPlusScreenMsg( true, "anp_invasion", 800, 200, 100, 2, "( End Of Round )", "anp_inv_big", Color( 255, 255, 255 ) )
		end
		
		for _, ply in pairs( player.GetAll() ) do
			if IsValid(ply) then
				ply:SetHealth( ply:GetMaxHealth() )
				ply:SetArmor( ply:GetMaxArmor() )
			end
		end
		
		timer.Create( "ANP_INV_COUNTDOWN" .. self:EntIndex(), 1, self.SettingTab['PrepTime'], function()
			if !IsValid(self) then return end
			
			ANPlusScreenMsg( true, "anp_invasion", 875, 200, 100, 1, "( " .. string.ToMinutesSeconds( countDown ) .. " )", "anp_inv_big", Color( 255, 255, 255 ) )
			
			if tonumber( countDown ) == 30 then		
				ANPlusEmitUISound( true, "anp/invasion/announcer/30_seconds_remain.mp3" )
			elseif tonumber( countDown ) == 20 then		
				ANPlusEmitUISound( true, "anp/invasion/announcer/20_seconds.mp3" )
			elseif tonumber( countDown ) == 12 then
				if tonumber( self.SettingTab['CurRound'] ) != tonumber( self.SettingTab['RoundMax'] ) then
					ANPlusEmitUISound( true, "anp/invasion/announcer/NewRoundIn.mp3" )	
				elseif tonumber( self.SettingTab['CurRound'] ) != 1 && tonumber( self.SettingTab['CurRound'] ) == tonumber( self.SettingTab['RoundMax'] ) then
					ANPlusEmitUISound( true, "anp/invasion/announcer/last_wave_in.mp3" )
				end
				if tonumber( self.SettingTab['CurRound'] ) == 1 then
					ANPlusEmitUISound( true, "anp/invasion/music/first_round.mp3" )
				end
			elseif tonumber( countDown ) <= 10 then			
				ANPlusEmitUISound( true, "anp/invasion/announcer/" .. countDown .. ".mp3" )			
			end

			countDown = countDown - 1
		end)
		
		self.PrepTimeLast = CurTime() + self.SettingTab['PrepTime'] + 1
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Think()
		
		--if !self:GetNWBool( "ANP_INV_ACTIVE" ) then self.PrepTimeLast = CurTime() + self.SettingTab['PrepTime'] end
		--[[
		if CurTime() - self.HUDLast >= self.HUDDelay then
			for _, npc in pairs( self.ActiveNPCTab ) do	
				if !IsValid(npc) then
					table.remove( self.ActiveNPCTab, _ )				
					self:SetNWFloat( "ANP_INV_NPCTOKILL", self:GetNWFloat( "ANP_INV_NPCTOKILL" ) - 1 )	
					--if tonumber( self:GetNWFloat( "ANP_INV_NPCTOKILL" ) ) == 10 then
					--	ANPlusEmitUISound( true, "anp/invasion/announcer/TenKillsRemain.mp3" )
					--elseif tonumber( self:GetNWFloat( "ANP_INV_NPCTOKILL" ) ) == 5 then
					--	ANPlusEmitUISound( true, "anp/invasion/announcer/FiveKillsRemain.mp3" )
					--end
				end
			end
			self.HUDLast = CurTime()
		end
		]]--
		
		if !self:GetNWBool( "ANP_INV_ACTIVE" ) || ( self.PrepTimeLast && self.PrepTimeLast >= CurTime() ) then return end

		if tonumber( self:GetNWFloat( "ANP_INV_PLY_LIFES" ) ) <= 0 && tonumber( self.SettingTab['PlayerLifes'] ) >= 1 then
			self:FailWave()
			return
		end
		
		if CurTime() - self.NPCSpawnLast >= self.NPCSpawnDelay then
			for _, npc in pairs( self.ActiveNPCTab ) do	
				if IsValid(npc) then
					for _, ply in pairs( player.GetAll() ) do					
						npc:UpdateEnemyMemory( ply, ply:GetPos() )				
					end	
				end
			end
			
			if #self.ActiveNPCTab < tonumber( self.SettingTab['NPCMax'] ) then
				if self.NPCsSpawned >= tonumber( self.SettingTab['NPCToKill'] ) && #self.ActiveNPCTab <= 0 then
					self:NextWave()
				elseif self.NPCsSpawned < tonumber( self.SettingTab['NPCToKill'] ) then
					if #self.NPCBossForCurWave > 0 && !self.NPCBossSpawned then
						self:SpawnBossNPC()
					else
						self:SpawnNPC()
					end
				end
			end
			self.NPCSpawnLast = CurTime()
		end
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
local function GetNPCInShape(self, npc, npcData)
	local npcListData = list.Get( "NPC" )[ npcData['ID'] ] || list.Get( "NPC" )[ npcData['Name'] ] || list.Get( "NPC" )[ npcData['Class'] ]
	
	if npc:IsNPC() && !IsValid(npc:GetActiveWeapon()) then
		
		if !npcData['CustomWeapon'] && npcListData && npcListData['Weapons'] then 
			local wep = npcListData['Weapons'][ math.random( 1, #npcListData['Weapons'] ) ]
			if wep then npc:Give( wep ) end
		elseif npcData['CustomWeapon'] then
			npc:Give( npcData['CustomWeapon']['Class'] )
		end
		
	end
	
	if npcData['Health'] then
		npc:SetHealth( npcData['Health'] )
		npc:SetMaxHealth( npcData['Health'] )
	end
	if npcListData['KeyValues'] then
		for _, v in pairs( npcListData['KeyValues'] ) do
			npc:SetKeyValue( tostring( _ ), v )			
		end
	end
	if npcListData['SpawnFlags'] then
		--local newsflags = bit.band( npcData['SpawnFlags'], bit.bnot( 8 ) ) -- Stop dropping health dang it.
		--npc:SetKeyValue( "spawnflags", newsflags ) 
		npc:SetKeyValue( "spawnflags", npcListData['SpawnFlags'] ) 
	end
	if npcListData['Model'] then npc:SetModel( npcListData['Model'] ) end
	if npcListData['Skin'] then npc:SetSkin( npcListData['Skin'] ) end
	
	npc.ANPInvasionOnDeath = function(npc, att, inf)
		if !table.HasValue( self.ActiveNPCTab, npc ) then return end
		if IsValid(npc:GetActiveWeapon()) then npc:GetActiveWeapon():Remove() end
		table.RemoveByValue( self.ActiveNPCTab, npc )				
		self:SetNWFloat( "ANP_INV_NPCTOKILL", self:GetNWFloat( "ANP_INV_NPCTOKILL" ) - 1 )
		self:SetNWFloat( "ANP_INV_NPC_COUNT", #self.ActiveNPCTab )
	end
	npc.ANPInvasionOnRemove = function(npc)
		if !self.ActiveNPCTab || !table.HasValue( self.ActiveNPCTab, npc ) then return end
		table.RemoveByValue( self.ActiveNPCTab, npc )				
		self:SetNWFloat( "ANP_INV_NPCTOKILL", self:GetNWFloat( "ANP_INV_NPCTOKILL" ) - 1 )
		self:SetNWFloat( "ANP_INV_NPC_COUNT", #self.ActiveNPCTab )
	end
	npc.ANP_INV_NPC = true

end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	function ENT:SpawnNPC()
		
		local npcData = self.NPCForCurWave[ math.random( 1, #self.NPCForCurWave ) ]
		local spRand = self.NPCSpawnPoints[ math.random( 1, #self.NPCSpawnPoints ) ]
		local spoint = IsValid(spRand) && spRand || self		
		local npc = ents.Create( tostring( npcData['Class'] ) )		
		npc:SetPos( spoint:GetPos() + Vector( 0, 0, 10 ) )
		npc:SetAngles( Angle( 0, spoint:GetAngles().y, 0 ) )
		GetNPCInShape( self, npc, npcData )
		npc:Spawn()
		npc:Activate()
		local fx = EffectData()
			fx:SetEntity( npc )
		util.Effect( "inv_spawn", fx, true )
		if IsValid(npc:GetActiveWeapon()) then
			local fx = EffectData()
				fx:SetEntity( npc:GetActiveWeapon() )
			util.Effect( "inv_spawn", fx, true )
		end
		
		if npc.IsVJBaseSNPC then
			npc.DropWeaponOnDeath = false
			npc.HasItemDropsOnDeath = false
			npc.SightDistance = 10000
			npc.FindEnemy_UseSphere = true
			npc.FindEnemy_CanSeeThroughWalls = true
		else
			npc:ANPlusNPCApply( npc:ANPlusGetName() )	
			npc:Fire( "SetMaxLookDistance", 20000 ) 
		end	
		
		npc:SetHealth( npc:Health() * ( 1 + ( ( self.SettingTab['MulHP'] / 100 ) * self.SettingTab['CurRound'] ) ) )
		npc:SetMaxHealth( npc:GetMaxHealth() * ( 1 + ( ( self.SettingTab['MulHP'] / 100 ) * self.SettingTab['CurRound'] ) ) )
		
		self.NPCsSpawned = self.NPCsSpawned + 1			
		table.insert( self.ActiveNPCTab, npc )
		self:SetNWFloat( "ANP_INV_NPC_COUNT", #self.ActiveNPCTab )
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:SpawnBossNPC()
		
		local npcData = self.NPCBossForCurWave[ math.random( 1, #self.NPCBossForCurWave ) ]
		local spRand = self.NPCSpawnPoints[ math.random( 1, #self.NPCSpawnPoints ) ]
		local spoint = IsValid(spRand) && spRand || self		
		local npc = ents.Create( npcData['Class'] )	
		npc:SetPos( spoint:GetPos() + Vector( 0, 0, 10 ) )
		npc:SetAngles( Angle( 0, spoint:GetAngles().y, 0 ) )
		GetNPCInShape( self, npc, npcData )
		npc:Spawn()
		npc:Activate()
		npc:ANPlusNPCApply( npcData['Name'] )
		local fx = EffectData()
			fx:SetEntity( npc )
		util.Effect( "inv_spawn", fx, true )
		if IsValid(npc:GetActiveWeapon()) then
			local fx = EffectData()
				fx:SetEntity( npc:GetActiveWeapon() )
			util.Effect( "inv_spawn", fx, true )
		end
		
		ANPlusEmitUISound( true, "anp/invasion/announcer/new_mutant.mp3" )
		
		if npc.IsVJBaseSNPC then
			npc.DropWeaponOnDeath = false
			npc.HasItemDropsOnDeath = false
			npc.SightDistance = 10000
			npc.FindEnemy_UseSphere = true
			npc.FindEnemy_CanSeeThroughWalls = true
		else
			npc:ANPlusNPCApply( npc:ANPlusGetName() )	
			npc:Fire( "SetMaxLookDistance", 20000 ) 
		end	
		
		npc:SetHealth( npc:Health() * ( 1 + ( ( self.SettingTab['MulHP'] / 100 ) * self.SettingTab['CurRound'] ) ) )
		npc:SetMaxHealth( npc:GetMaxHealth() * ( 1 + ( ( self.SettingTab['MulHP'] / 100 ) * self.SettingTab['CurRound'] ) ) )
		
		self.NPCsSpawned = self.NPCsSpawned + 1			
		table.insert( self.ActiveNPCTab, npc )
		self:SetNWFloat( "ANP_INV_NPC_COUNT", #self.ActiveNPCTab )
		self.NPCBossSpawned = true
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:PreEntityCopy()
		self:ResetStuff()
		self.SaveTab = self.SettingTab	
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:OnDuplicated( dupeTable )	
		if dupeTable.SaveTab then	
			self.SaveTab = dupeTable.SaveTab		
		end	
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:PostEntityPaste()
		self.FullyLoaded = false
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:PhysicsCollide(data, physobj)
		local SurTab = util.GetSurfaceData(util.GetSurfaceIndex(physobj:GetMaterial())) 
		if (data.Speed > 80 and data.Speed <= 250 and data.DeltaTime > 0.1) and SurTab.impactSoftSound then	
			self:EmitSound(SurTab.impactSoftSound)		
		elseif (data.Speed > 250 and data.DeltaTime > 0.1) and SurTab.impactHardSound then	
			self:EmitSound(SurTab.impactHardSound)		
		end	
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:OnRemove()
		if self.FullyLoaded then
			for _, ply in pairs( player.GetAll() ) do
				if IsValid(ply) then
					ply:SetNWBool( "ANP_INV_HUD", false )
					ANPlusEmitUISound( ply, "" )
				end
			end
			self:ResetStuff()
		end
	end
end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
if (CLIENT) then
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:GetOverlayText()	
		if self:GetNWBool( "ANP_INV_ACTIVE" ) then return "" end
		if self.Purpose then	
			return self.Purpose
		else		
			return ""		
		end		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	
	local scrWidth = 1920
	local scrHeight = 1080

	local multX = ScrW() / scrWidth
	local multY = ScrH() / scrHeight

	local function ANP_Invasion_Menu()
		
		local ply = LocalPlayer()
		local npcList = list.Get( "NPC" )
		local tab = net.ReadTable()	
		if !tab then return end
		local newtab = tab || {}
		local datatab = {}

		ANPlusUISound( "ANP.UI.Open" )

		local dFrame = vgui.Create( "DFrame" )
			dFrame:SetTitle( "" )
			dFrame:SetSize( 680, 530 )
			dFrame:Center()
			dFrame:SetVisible( true )
			dFrame:SetDraggable( true )
			dFrame:ShowCloseButton( true )
			dFrame:NoClipping( true )
			dFrame:SetSizable( false )
			dFrame:SetMinWidth( dFrame:GetWide() )
			dFrame:SetMinHeight( dFrame:GetTall() )
			--dFrame:SetIcon("vgui/csb_ico2.png")
			dFrame:MakePopup()
		function dFrame:PerformLayout()
			self:SetFontInternal( "ChatFont" )
			self:SetFGColor( color_white )		
		end
		dFrame.OnClose = function ()		
			ANPlusUISound( "ANP.UI.Close" )		
		end
		dFrame.Paint = function( self, w, h )	
			draw.RoundedBox( 8, 0, 0, w, h, Color( 50, 50, 50, 200 ) )			
		end
		--[[
		local dFrameIco = vgui.Create( "DImage", dFrame )
			dFrameIco:SetImage( "vgui/sam_interface_logo" )
			dFrameIco:SetPos( 10 * multX, 5 * multY )
			dFrameIco:SetSize( 80 * multX, 20 * multY )
			
		]]--
		-------------------------------------------------------------
		dFrame:ANPlus_CreateLabel( 438, 383, 200, "Max NPCs Active:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 385, 40, 17, tab['NPCMax'], 1, 1, 1e8, "Max amount of NPCs that could be active during a wave." )
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['NPCMax'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end
		
		dFrame:ANPlus_CreateLabel( 438, 403, 200, "NPCs To Kill:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )	
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 405, 40, 17, tab['NPCToKill'], 1, 1, 1e8, "Number of NPC kills required to proceed to the next wave." )
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['NPCToKill'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end
		
		dFrame:ANPlus_CreateLabel( 438, 423, 200, "Max Rounds:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )	
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 425, 40, 17, tab['RoundMax'], 1, 1, 1e8, "Max amount of waves." )
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['RoundMax'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end
		
		dFrame:ANPlus_CreateLabel( 438, 443, 200, "Prep Time:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )	
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 445, 40, 17, tab['PrepTime'], 1, 15, 1e8, "Break between the waves." )	
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['PrepTime'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end
		
		dFrame:ANPlus_CreateLabel( 438, 463, 200, "Player Lifes:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )	
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 465, 40, 17, tab['PlayerLifes'], 1, 0, 1e8, "How many times all Players can die during a wave. If this reaches 0, the game will end." )
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['PlayerLifes'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end		
		
		dFrame:ANPlus_CreateLabel( 438, 483, 200, "Additional Health (%):", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 485, 40, 17, tab['MulHP'], 1, 0, 1e8, "NPC health multiplier. It will be doubled each wave." )
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['MulHP'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end	
		
		dFrame:ANPlus_CreateLabel( 438, 503, 200, "First Wave Equipment Strip:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )
		local checkbox = dFrame:ANPlus_CreateCheckBox( 630, 505, tab['StripEQ'], "Set if Player's Weapons and Ammo should be stripped at the first wave." )
		function checkbox:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function checkbox:OnChange( bool )
			newtab['StripEQ'] = bool
			ANPlusUISound( "ANP.UI.Slider" )
		end
		--[[
		dFrame:ANPlus_CreateLabel( 438, 503, 200, "Damage Multiplier:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )
		local wang = dFrame:ANPlus_CreateNumberWang( 630, 505, 40, 17, tab['MulDMG'], 1, 0, 1e8, "NPC damage multiplier. It will be doubled each wave." )
		function wang:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function wang:OnValueChanged(val)
			newtab['MulDMG'] = val
			ANPlusUISound( "ANP.UI.Slider" )
		end	
		]]--
		-------------------------------------------------------------
		--dFrame:ANPlus_CreateLabel( 400, 18, 200, "Select Wave:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )	
		local waveCommon = dFrame:ANPlus_CreateNumberWang( 630, 29, 40, 17, 1, 1, 1, 1e8, "Select a wave at which you wish to add selected NPC." )
		function waveCommon:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function waveCommon:OnValueChanged(val)
			ANPlusUISound( "ANP.UI.Slider" )
		end	
		
		local waveBoss = dFrame:ANPlus_CreateNumberWang( 630, 209, 40, 17, 1, 1, 1, 1e8, "Select a wave at which you wish to add selected NPC." )
		function waveBoss:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function waveBoss:OnValueChanged(val)
			ANPlusUISound( "ANP.UI.Slider" )
		end	
		
		local dListNPCs = dFrame:ANPlus_CreateListView( 435, 50, 235, 147, false, false, { {"Common NPC", 130}, {"Weapon", 110}, {"Wave"} }, "NPCs from this table will spawn during the wave at selected waves." )			
		function dListNPCs:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListNPCs:OnRowRightClick(lineID, line)
			local v1 = line:GetValue( 1 )
			local v2 = line:GetValue( 2 )
			local rID = line:GetID()			
			if self:GetLine(rID) != nil then
				self:RemoveLine( rID ) 
				for _, v in pairs( newtab['NPCList']) do 
					if v['Name'] == v1 then
						table.remove( newtab['NPCList'], _ )
					end
				end			
				ANPlusUISound( "ANP.UI.Text" )
			end	
		end
		
		newtab['NPCList'] = newtab['NPCList'] || {}
		
		for _, v in pairs( newtab['NPCList'] ) do 
			dListNPCs:AddLine( v['Name'], v['CustomWeapon'] && v['CustomWeapon']['Title'], v['Wave'] )
		end
		
		local dListBossNPCs = dFrame:ANPlus_CreateListView( 435, 230, 235, 147, false, false, { {"Boss NPC", 130}, {"Weapon", 110}, {"Wave"} }, "NPCs from this table will be treated as the Boss of the selected wave and spawn once at the beginning." )			
		function dListBossNPCs:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListBossNPCs:OnRowRightClick(lineID, line)
			local v1 = line:GetValue( 1 )
			local v2 = line:GetValue( 2 )
			local rID = line:GetID()		
			if self:GetLine( rID ) != nil then
				self:RemoveLine( rID ) 
				for _, v in pairs( newtab['NPCBossList'] ) do 
					if v['Name'] == v1 then
						--table.remove( newtab['NPCBossList'], _ )
						table.RemoveByValue( newtab['NPCBossList'], v )
					end
				end			
				ANPlusUISound( "ANP.UI.Text" )
			end				
		end			
		
		newtab['NPCBossList'] = newtab['NPCBossList'] || {}
		
		for _, v in pairs( newtab['NPCBossList'] ) do 
			dListBossNPCs:AddLine( v['Name'], v['CustomWeapon'] && v['CustomWeapon']['Title'], v['Wave'] )
		end
				
		local dListGlobal = dFrame:ANPlus_CreateListView( 10, 28, 230, 490, false, true, { {"NPC Name"}, {"NPC Class"} }, "List of all spawnable NPCs." ) 			
		function dListGlobal:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobal:OnRowSelected()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobal:OnRowRightClick()
			ANPlusUISound( "ANP.UI.Hover" )
			self:UnselectAll()
		end 
		for _, v in pairs( npcList ) do 
			dListGlobal:AddLine( v['Name'], v['Class'] )
		end
		
		
		local dListGlobalWep = dFrame:ANPlus_CreateListView( 240, 28, 190, 490, false, true, { {"NPC Weapons"} }, "List of all NPC weapons." ) 			
		function dListGlobalWep:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobalWep:OnRowSelected()
			ANPlusUISound( "ANP.UI.Hover" )
		end 
		function dListGlobalWep:OnRowRightClick()
			ANPlusUISound( "ANP.UI.Hover" )
			self:UnselectAll()
		end
		for _, v in pairs( list.GetForEdit( "NPCUsableWeapons" ) ) do 
			dListGlobalWep:AddLine( v['title'] )
		end
		
		
		local add1 = dFrame:ANPlus_CreateButton( 435, 28, 190, 20, 8, Color( 200, 200, 200, 255 ), "Add Common NPC", Color ( 100, 100, 100, 255 ), "Add NPC to the Common table." )
		function add1:OnCursorEntered()
			function add1:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function add1:OnCursorExited()
			function add1:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end

		function add1:DoClick()
			if dListGlobal:GetSelectedLine() then
				local lineID, line = dListGlobal:GetSelectedLine()
				local lineID2, line2 = dListGlobalWep:GetSelectedLine()
				local l1v1 = line:GetValue( 1 )
				local l1v2 = line:GetValue( 2 )
				local l2v1 = line2 && line2:GetValue( 1 ) || nil
				dListNPCs:AddLine( l1v1, l2v1, waveCommon:GetValue() )
				for _, npc in pairs( npcList ) do 
					if npc['Name'] == l1v1 && npc['Class'] == l1v2 then
						local npcTab = table.Copy( npc )
						local addTab = { ['Wave'] = waveCommon:GetValue(), ['ID'] = _ }
						table.Merge( npcTab, addTab )
						if l2v1 then
							for _, wep in pairs( list.GetForEdit( "NPCUsableWeapons" ) ) do 
								if wep['title'] == l2v1 then
									local addTab = { ['CustomWeapon'] = { ['Title'] = wep['title'], ['Class'] = wep['class'] } }
									table.Merge( npcTab, addTab )
								end
							end
						end
						table.insert( newtab['NPCList'], npcTab )
						ANPlusUISound( "ANP.UI.Text" )
					end
				end	
				ANPlusUISound( "ANP.UI.Click" )
			end
		end
		
		
		local add2 = dFrame:ANPlus_CreateButton( 435, 207, 190, 20, 8, Color( 200, 200, 200, 255 ), "Add Boss NPC", Color ( 100, 100, 100, 255 ), "Add NPC to the Boss table." )
		function add2:OnCursorEntered()
			function add2:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function add2:OnCursorExited()
			function add2:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end
		function add2:DoClick()
			if dListGlobal:GetSelectedLine() then
				local lineID, line = dListGlobal:GetSelectedLine()
				local lineID2, line2 = dListGlobalWep:GetSelectedLine()
				local l1v1 = line:GetValue( 1 )
				local l1v2 = line:GetValue( 2 )
				local l2v1 = line2 && line2:GetValue( 1 ) || nil
				dListBossNPCs:AddLine( l1v1, l2v1, waveBoss:GetValue() )
				for _, npc in pairs( npcList ) do 
					if npc['Name'] == l1v1 && npc['Class'] == l1v2 then
						local npcTab = table.Copy( npc )
						local addTab = { ['Wave'] = waveBoss:GetValue(), ['ID'] = _ }
						table.Merge( npcTab, addTab )
						if l2v1 then
							for _, wep in pairs( list.GetForEdit( "NPCUsableWeapons" ) ) do 
								if wep['title'] == l2v1 then
									local addTab = { ['CustomWeapon'] = { ['Title'] = wep['title'], ['Class'] = wep['class'] } }
									table.Merge( npcTab, addTab )
								end
							end
						end
						table.insert( newtab['NPCBossList'], npcTab )
						ANPlusUISound( "ANP.UI.Text" )
					end
				end
				ANPlusUISound( "ANP.UI.Click" )
			end
		end
			
		-------------------------------------------------------------
		local save = dFrame:ANPlus_CreateButton( 360, 5, 50, 20, 8, Color( 200, 200, 200, 255 ), "Save", Color ( 100, 100, 100, 255 ), "Apply all of the changes." )
		function save:OnCursorEntered()
			function save:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function save:OnCursorExited()
			function save:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end
		function save:DoClick()
			ANPlusUISound( "ANP.UI.Click" )
			net.Start( "ANP_InvasionUpdate" )
			net.WriteTable( newtab )
			net.SendToServer() 
		end
		local cancel = dFrame:ANPlus_CreateButton( 420, 5, 50, 20, 8, Color( 200, 200, 200, 255 ), "Close", Color ( 100, 100, 100, 255 ), "Close the interface." )
		function cancel:OnCursorEntered()
			function cancel:Paint(w, h)
				draw.RoundedBox( 8, 3, 3, w - 6, h - 6, Color( 150, 150, 150, 255 ) )
			end
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function cancel:OnCursorExited()
			function cancel:Paint(w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end
		end
		function cancel:DoClick()
			ANPlusUISound( "ANP.UI.Click" )
			dFrame:Close()
		end
		
		local helptext = " This menu can be used to modify the whole mode."..
		"\n Common NPCs - These spawn throughout the whole wave."..
		"\n Boss NPCs - These spawn once per wave at the beginning."..
		"\n How to add a NPC:"..
		"\n"..
		"\n 1) Select a NPC from the left list,"..
		"\n 2) Select a weapon for it from the right list (if no weapon has been set, NPC's default weapon/s will be used)"..
		"\n 3) Now look at the tables on the right side of the menu, here you can select the wave at which you'd like to add your NPC and"..
		"\n decide if said NPC should spawn as a Common or Boss NPC."..
		"\n You can add more than one NPC per wave and it will be randomised on spawn."..
		"\n"..
		"\n You can use the settings at the bottom to edit the gamemode itself."..
		"\n Health and Damage multipliers are doubled each wave!"
		local help = dFrame:ANPlus_CreateButton( 480, 5, 190, 20, 8, Color( 200, 200, 200, 255 ), "Hover For Help", Color ( 100, 100, 100, 255 ), helptext )
		function help:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		
		dFrame:ShowCloseButton( false )
		
	end
	
	net.Receive( "ANP_InvasionMenu", ANP_Invasion_Menu )

--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	

	surface.CreateFont("anp_inv_med", {
		font = "Frak",
		size = 28*multX,
		shadow = true,
		antialias = true,
		outline = true
	})
	
	surface.CreateFont("anp_inv_big", {
		font = "Frak",
		size = 55*multX,
		antialias = true,
		outline = true
	})
	
	local vicIco = Material( "vgui/anp_victory.png" )
	
	hook.Add( "HUDPaint", "ANPlus_Invasion_HUD", function()
		local CANDRAW = false
		local ply = LocalPlayer()
		local hasHUD = ply:GetNWBool( "ANP_INV_HUD" )
		local self = NULL
		for _, v in pairs( ents.FindByClass( "sent_anp_invasion" ) ) do
			self = v; break
		end
		CANDRAW = ( IsValid(self) && hasHUD )
		if CANDRAW == false || !GetConVar( "cl_drawhud" ):GetBool() then return end
		
		draw.RoundedBox( 8, 37 * multX, 30 * multY, 120 * multX, 80 * multY, Color( 0, 0, 0, 155 ) )
		draw.RoundedBox( 8, 167 * multX, 30 * multY, 120 * multX, 80 * multY, Color( 0, 0, 0, 155 ) )
		draw.RoundedBox( 8, 297 * multX, 30 * multY, 120 * multX, 80 * multY, Color( 0, 0, 0, 155 ) )
		draw.RoundedBox( 8, 427 * multX, 30 * multY, 120 * multX, 80 * multY, Color( 0, 0, 0, 155 ) )
		
		if tonumber( self:GetNWFloat( "ANP_INV_CURROUND" ) ) <= tonumber( self:GetNWFloat( "ANP_INV_MAXROUND" ) ) then
			draw.SimpleTextOutlined( "Round", "anp_inv_med", 97 * multX, 47 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
			draw.SimpleTextOutlined( self:GetNWFloat( "ANP_INV_CURROUND" ) .. "/" .. self:GetNWFloat( "ANP_INV_MAXROUND" ), "anp_inv_big", 97 * multX, 82 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( vicIco )
			surface.DrawTexturedRect( 60 * multX, 35 * multY, 75 * multX, 75 * multY )
		end
		
		draw.SimpleTextOutlined( "NPCs Alive", "anp_inv_med", 227 * multX, 47 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined( self:GetNWFloat( "ANP_INV_NPC_COUNT" ), "anp_inv_big", 227 * multX, 82 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleTextOutlined( "NPCs Left", "anp_inv_med", 357 * multX, 47 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		draw.SimpleTextOutlined( self:GetNWFloat( "ANP_INV_NPCTOKILL" ), "anp_inv_big", 357 * multX, 82 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleTextOutlined( "Player Lifes", "anp_inv_med", 487 * multX, 47 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		local lives = ( tonumber( self:GetNWFloat( "ANP_INV_PLY_LIFESMAX" ) ) > 0 && self:GetNWFloat( "ANP_INV_PLY_LIFES" ) ) || "∞"
		draw.SimpleTextOutlined( lives, "anp_inv_big", 487 * multX, 82 * multY, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 255 ) )
		
	end)
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Draw()
		if self:GetNWBool( "ANP_INV_ACTIVE" ) then return end
		self:DrawModel()
	end
end
