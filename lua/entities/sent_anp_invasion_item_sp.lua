AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "[ANP] Invasion Item Spawner"
ENT.Author			= "FiLzO"
ENT.Purpose			= "Used as a Weapon/Ammo/Entity/NPC spawner." ..
					"\n Can be set to spawn different things on chosen waves."
ENT.Category		= "ANP[BASE]"

ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.RespawnLast = 0
ENT.ItemsToSpawn = {}
ENT.CurWave = 0
ENT.RespawnDelay = 0
ENT.SpawnerActive = false

if (SERVER) then
	util.AddNetworkString("ANP_SpawnerMenu")
	util.AddNetworkString("ANP_SpawnerUpdate")
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Initialize()
		
		local model = self:GetModel() != "models/error.mdl" && self:GetModel() || "models/xqm/panel1x1.mdl"
		local material = self:GetMaterial() != "" && self:GetMaterial() || "models/debug/debugwhite"
		local color = self:GetColor() != Color( 255, 255, 255 ) && self:GetColor() || Color( 55, 55, 55, 255 )
		self:SetModel( model  )
		self:SetMaterial( material )
		self:SetColor( color )
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
			self_phys:Wake()
		end
		
		self:SetNWEntity( "ANP_INV_ISP_ENT", NULL )
		self:SetNWBool( "ANP_INV_SP_DRAW", true )
		
		self.SettingTab = self.SaveTab || {
		['ItemsToSpawn'] 	= {},
		['RespawnSND']		= "anp/invasion/other/Generic_ItemRespawn01.mp3",
		['UseAnimation'] 	= true,
		}
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Use(ply)
		if !ply:IsPlayer() || !self:GetNWBool( "ANP_INV_SP_DRAW" ) then return end	
		PrintTable(list.Get( "NPC" ))
		net.Start( "ANP_SpawnerMenu" )
		--net.WriteTable( list.Get( "NPC" ) ) -- Cuz on client it's missing half of the data >:(
		net.WriteTable( self.SettingTab )
		net.Send( ply )	
		net.Receive("ANP_SpawnerUpdate", function(_, ply)
			local tab = net.ReadTable()		
			self.SettingTab = tab				
		end)
		
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:UpdateItem(wave)
		if #self.SettingTab['ItemsToSpawn'] <= 0 then return end
		if IsValid(self.ent) then self.ent:Remove() end
		self:SetNWBool( "ANP_INV_SP_DRAW", false )
		self.CurWave = wave || 0
		self.ItemsToSpawn = {}
		for _, ent in pairs( self.SettingTab['ItemsToSpawn'] ) do	
			if ent['Wave'] == self.CurWave then
				table.insert( self.ItemsToSpawn, ent )
			end
		end
		self.SpawnerActive = true
		self.RespawnLast = CurTime()
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	function ENT:StopRespawningItem()
		if IsValid(self.ent) then self.ent:Remove() end
		self.ItemsToSpawn = {}
		self.CurWave = 0
		self:SetNWBool( "ANP_INV_SP_DRAW", true )
		self.SpawnerActive = false
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:Think()
		
		if IsValid(self.ent) && !IsValid(self.ent:GetOwner()) then self.RespawnLast = CurTime() + self.RespawnDelay return end
		if self.RespawnLast > CurTime() || #self.ItemsToSpawn <= 0 || self.CurWave == 0 || !self.SpawnerActive || ( IsValid(self.ent) && !IsValid(self.ent:GetOwner()) ) then return end
		self:SpawnItem()		
	
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
local function GetNPCInShape(self, npc, npcData)
	if !npc:IsNPC() then return end
	npc:ANPlusNPCApply( npcData['Name'] )
	if npcData['Health'] then
		npc:SetHealth( npcData['Health'] )
		npc:SetMaxHealth( npcData['Health'] )
	end
	if npcData['KeyValues'] then
		for _, v in pairs( npcData['KeyValues'] ) do
			npc:SetKeyValue( tostring( _ ), v )			
		end
	end
	if list.Get( "NPC" )[npcData['ID']] && list.Get( "NPC" )[npcData['ID']]['Weapons'] && !npcData['CustomWeapon'] then 
		local wep = npcData['Weapons'][ math.random( 1, #npcData['Weapons'] ) ]
		npc:Give( wep )
	elseif npcData['CustomWeapon'] then
		npc:Give( npcData['CustomWeapon']['Class'] )
	end
	if npcData['SpawnFlags'] then npc:SetKeyValue( "spawnflags", npcData['SpawnFlags'] ) end
	if npcData['Model'] then npc:SetModel( npcData['Model'] ) end
	if npcData['Skin'] then npc:SetSkin( npcData['Skin'] ) end
	
	npc.ANPInvasionOnDeath = function(npc, att, inf)
		if npc != self.ent then return end
		if IsValid(npc:GetActiveWeapon()) then npc:GetActiveWeapon():Remove() end
	end
	
	npc:DropToFloor()
end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////	
	function ENT:SpawnItem()
		if IsValid(self.ent) && !IsValid(self.ent:GetOwner()) then return end
		local entData = self.ItemsToSpawn[ math.random( 1, #self.ItemsToSpawn ) ]
		self.ent = ents.Create( entData['ClassName'] || entData['Class'] )
		local addHeight = self.ent:IsNPC() && Vector( 0, 0, 10 ) || Vector( 0, 0, 40 )
		self.ent:SetPos( self:GetPos() + addHeight )
		self.ent:SetAngles( Angle( 0, self:GetAngles().y, 0 ) )	
		GetNPCInShape( self, self.ent, entData )
		self.ent:Spawn()
		self.ent:Activate()
		if self.SettingTab['RespawnSND'] then self.ent:EmitSound( self.SettingTab['RespawnSND'], 70, 100, 0.7 ) end
		local fx = EffectData()
			fx:SetEntity( self.ent )
		util.Effect( "inv_spawn", fx, true )
		if !self.ent:IsNPC() then
			self.ent:SetParent( self )
			self:SetNWEntity( "ANP_INV_ISP_ENT", self.ent )
		elseif self.ent:IsNPC() then
			if !self.ent.IsVJBaseSNPC then self.ent:ANPlusNPCApply( self.ent:ANPlusGetName() ) end		
			if IsValid(self.ent:GetActiveWeapon()) then
				local fx = EffectData()
					fx:SetEntity( self.ent:GetActiveWeapon() )
				util.Effect( "inv_spawn", fx, true )
			end
		end
		self.RespawnDelay = entData['Delay']
		self.RespawnLast = CurTime() + self.RespawnDelay
	end
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:PreEntityCopy()	
		if IsValid(self.ent) then self.ent:Remove() end
		self:SetNWEntity( "ANP_INV_ISP_ENT", NULL )
		self:SetNWBool( "ANP_INV_SP_DRAW", true )
		self.SpawnerActive = false
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
		if IsValid(self.ent) then self.ent:Remove() end
	end
end
if (CLIENT) then
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	local scrWidth = 1920
	local scrHeight = 1080

	local multX = ScrW() / scrWidth
	local multY = ScrH() / scrHeight

	local function ANP_Spawner_Menu()
		
		local ply = LocalPlayer()
		local npcList = list.Get( "NPC" )
		local tab = net.ReadTable()	
		if !tab then return end
		local newtab = tab || {}
		local datatab = {}

		ANPlusUISound( "ANP.UI.Open" )

		local dFrame = vgui.Create( "DFrame" )
			dFrame:SetTitle( "" )
			dFrame:SetSize( 940, 550 )
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

		--dFrame:ANPlus_CreateLabel( 12, 65, 200, "Respawn Delay:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )		
		local respawnDelay = dFrame:ANPlus_CreateNumberWang( 568, 271, 58, 17, 5, 1, 1, 1e8, "Set respawn delay for the item spawner." )
		function respawnDelay:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function respawnDelay:OnValueChanged(val)
			ANPlusUISound( "ANP.UI.Text" )
		end

		--dFrame:ANPlus_CreateLabel( 12, 45, 200, "Select Wave:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )		
		local waveSelect = dFrame:ANPlus_CreateNumberWang( 292, 271, 58, 17, 1, 1, 1, 1e8, "Select a wave at which you wish to add selected entity." )
		function waveSelect:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function waveSelect:OnValueChanged(val)
			ANPlusUISound( "ANP.UI.Text" )
		end
		
		local dItemsToSpawn = dFrame:ANPlus_CreateListView( 10, 290, 920, 250, false, false, { {"Entity To Spawn", 125}, {"Wave", 10}, {"Delay", 10}, {"Weapon", 145} }, "Entities that will spawn at given waves. Entities with the same wave values will be chosen randomly." )		
		function dItemsToSpawn:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dItemsToSpawn:OnRowRightClick(lineID, line)
			local v1 = line:GetValue( 1 )
			--local v2 = line:GetValue( 2 )
			local rID = line:GetID()				
			if self:GetLine(rID) != nil then
				self:RemoveLine( rID ) 
				for _, v in pairs( newtab['ItemsToSpawn']) do 
					if v['Name'] && v['Name'] == v1 || v['PrintName'] && v['PrintName'] == v1 then
						table.RemoveByValue( newtab['ItemsToSpawn'], v )
					end
				end					
				ANPlusUISound( "ANP.UI.Close" )
			end				
		end
		
		newtab['ItemsToSpawn'] = newtab['ItemsToSpawn'] || {}
		
		for _, v in pairs( newtab['ItemsToSpawn'] ) do 
			dItemsToSpawn:AddLine( v['PrintName'] || v['Name'], v['Wave'], v['Delay'], v['CustomWeapon'] && v['CustomWeapon']['Title'] )
		end
		
		local dListGlobal = dFrame:ANPlus_CreateListView( 10, 28, 230, 240, false, true, { {"NPC Name"}, {"NPC Class"} }, "List of all spawnable NPCs." ) 	
		local dListGlobalWep = dFrame:ANPlus_CreateListView( 240, 28, 230, 240, false, true, { {"NPC Weapons Name"}, {"NPC Weapons Class"} }, "List of all NPC Weapons." ) 	
		local dListGlobalPlyWep = dFrame:ANPlus_CreateListView( 470, 28, 230, 240, false, true, { {"Player Weapon Name"}, {"Player Weapon Class"} }, "List of all Player Weapons." ) 
		local dListGlobalEnt = dFrame:ANPlus_CreateListView( 700, 28, 230, 240, false, true, { {"Entity Name"}, {"Entity Class"} }, "List of all spawnable Entities." ) 
		
		function dListGlobal:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobal:OnRowSelected()
			ANPlusUISound( "ANP.UI.Hover" )
			dListGlobalEnt:UnselectAll()
			dListGlobalPlyWep:UnselectAll()
		end
		function dListGlobal:OnRowRightClick()
			ANPlusUISound( "ANP.UI.Hover" )
			self:UnselectAll()
		end 
		for _, v in pairs( npcList ) do 
			dListGlobal:AddLine( v['Name'], v['Class'] )
		end
		
				
		function dListGlobalWep:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobalWep:OnRowSelected()
			ANPlusUISound( "ANP.UI.Hover" )
			dListGlobalPlyWep:UnselectAll()
			dListGlobalEnt:UnselectAll()
		end 
		function dListGlobalWep:OnRowRightClick()
			ANPlusUISound( "ANP.UI.Hover" )
			self:UnselectAll()
		end
		for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do 
			dListGlobalWep:AddLine( v['title'], v['class'] )
		end
		
		
		function dListGlobalPlyWep:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobalPlyWep:OnRowSelected()
			ANPlusUISound( "ANP.UI.Hover" )
			dListGlobalEnt:UnselectAll()
			dListGlobalWep:UnselectAll()
			dListGlobal:UnselectAll()
		end 
		function dListGlobalPlyWep:OnRowRightClick()
			ANPlusUISound( "ANP.UI.Hover" )
			self:UnselectAll()
		end
		for _, v in pairs( list.Get( "Weapon" ) ) do 
			if v['Spawnable'] then
				dListGlobalPlyWep:AddLine( v['PrintName'], v['ClassName'] )
			end
		end
		
					
		function dListGlobalEnt:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function dListGlobalEnt:OnRowSelected()
			ANPlusUISound( "ANP.UI.Hover" )
			dListGlobalPlyWep:UnselectAll()
			dListGlobalWep:UnselectAll()
			dListGlobal:UnselectAll()
		end 
		function dListGlobalEnt:OnRowRightClick()
			ANPlusUISound( "ANP.UI.Hover" )
			self:UnselectAll()
		end
		for _, v in pairs( list.Get( "SpawnableEntities" ) ) do 
			dListGlobalEnt:AddLine( v['PrintName'], v['ClassName'] )
		end

		local add1 = dFrame:ANPlus_CreateButton( 351, 269, 216, 20, 8, Color( 200, 200, 200, 255 ), "Add Entity", Color ( 100, 100, 100, 255 ), "Add NPC to the Common table." )
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
	
				dItemsToSpawn:AddLine( l1v1, waveSelect:GetValue(), respawnDelay:GetValue(), l2v1 )				
				for _, npc in pairs( npcList ) do 
					if npc['Name'] == l1v1 && npc['Class'] == l1v2 then
						local npcTab = table.Copy( npc )
						local addTab = { ['Wave'] = waveSelect:GetValue(), ['Delay'] = respawnDelay:GetValue(), ['ID'] = _ }
						table.Merge( npcTab, addTab )
						if l2v1 then
							for _, wep in pairs( list.Get( "NPCUsableWeapons" ) ) do 
								if wep['title'] == l2v1 then
									local addTab = { ['CustomWeapon'] = { ['Title'] = wep['title'], ['Class'] = wep['class'] } }
									table.Merge( npcTab, addTab )
								end
							end
						end
						table.insert( newtab['ItemsToSpawn'], npcTab )
						ANPlusUISound( "ANP.UI.Text" )
					end
				end
			elseif dListGlobalEnt:GetSelectedLine() then
				local lineID3, line3 = dListGlobalEnt:GetSelectedLine()
				local l3v1 = line3:GetValue( 1 )
				local l3v2 = line3:GetValue( 2 )
				dItemsToSpawn:AddLine( l3v1, waveSelect:GetValue(), respawnDelay:GetValue() )				
				for _, ent in pairs( list.Get( "SpawnableEntities" ) ) do 
					if ent['PrintName'] == l3v1 && ent['ClassName'] == l3v2 then
						local entTab = table.Copy( ent )
						local addTab = { ['Wave'] = waveSelect:GetValue(), ['Delay'] = respawnDelay:GetValue() }
						table.Merge( entTab, addTab )
						table.insert( newtab['ItemsToSpawn'], entTab )
						ANPlusUISound( "ANP.UI.Text" )
					end
				end	
				ANPlusUISound( "ANP.UI.Click" )
			elseif dListGlobalPlyWep:GetSelectedLine() then
				local lineID4, line4 = dListGlobalPlyWep:GetSelectedLine()
				local l4v1 = line4:GetValue( 1 )
				local l4v2 = line4:GetValue( 2 )
				dItemsToSpawn:AddLine( l4v1, waveSelect:GetValue(), respawnDelay:GetValue() )				
				for _, ent in pairs( list.Get( "Weapon" ) ) do 
					if ent['PrintName'] == l4v1 && ent['ClassName'] == l4v2 then
						local entTab = table.Copy( ent )
						local addTab = { ['Wave'] = waveSelect:GetValue(), ['Delay'] = respawnDelay:GetValue() }
						table.Merge( entTab, addTab )
						table.insert( newtab['ItemsToSpawn'], entTab )
						ANPlusUISound( "ANP.UI.Text" )
					end
				end	
				ANPlusUISound( "ANP.UI.Click" )
			end
		end
		
		dFrame:ANPlus_CreateLabel( 515, 4, 100, "Respawn Sound:", Color( 245, 245, 245, 255 ), "DermaDefaultBold" )
		local resSND = dFrame:ANPlus_CreateTextEntry( 610, 5, 320, 16, tab['RespawnSND'], Color( 0, 0, 0, 255 ), "DermaDefaultBold", "Set Entity respawn sound." )
		function resSND:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		function resSND:OnEnter(text)
			newtab['RespawnSND'] = text
			ANPlusUISound( "ANP.UI.Text" )
		end
		
		-------------------------------------------------------------	
		local save = dFrame:ANPlus_CreateButton( 10, 5, 50, 20, 8, Color( 200, 200, 200, 255 ), "Save", Color ( 100, 100, 100, 255 ), "Apply all of the changes." )
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
			net.Start( "ANP_SpawnerUpdate" )
			net.WriteTable( newtab )
			net.SendToServer() 
		end

		local cancel = dFrame:ANPlus_CreateButton( 70, 5, 50, 20, 8, Color( 200, 200, 200, 255 ), "Close", Color ( 100, 100, 100, 255 ), "Close the interface." )
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
		
		local helptext = " This menu can be used to modify this entity spawner."..
		"\n You can spawn all sort of things:"..
		"\n - Weapons"..
		"\n - Ammo"..
		"\n - Ally NPCs"..
		"\n "..
		"\n Adding entities to the spawning list works the same way as with the gamemode entity menu."
		local help = dFrame:ANPlus_CreateButton( 130, 5, 190, 20, 8, Color( 200, 200, 200, 255 ), "Hover For Help", Color ( 100, 100, 100, 255 ), helptext )
		function help:OnCursorEntered()
			ANPlusUISound( "ANP.UI.Hover" )
		end
		
		dFrame:ShowCloseButton( false )
		
	end
	
	net.Receive( "ANP_SpawnerMenu", ANP_Spawner_Menu )
--[[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
|||||
|||||
|||||
]]--////////////////////////////////////////////////////////////////////////////////////////////////
	function ENT:GetOverlayText()	
		if !self:GetNWBool( "ANP_INV_SP_DRAW" ) then return "" end
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
	function ENT:Draw()
		
		local ent = self:GetNWEntity( "ANP_INV_ISP_ENT" )
		if IsValid(ent) then
			local bananalevitate = math.sin( CurTime() * 3 ) * ( 1 * 3 )
			local bananarotate = ( CurTime() * ( 100 * 0.2 ) ) % 360
			
			local offsetVec = Vector( 0, 0, bananalevitate + 40 )
			local offsetAng = Angle( 0, bananarotate, 0 )
			
			local newPos, newAng = LocalToWorld( offsetVec, offsetAng, self:GetPos(), self:GetAngles() )
			
			ent:SetPos( newPos )
			ent:SetAngles( newAng )
		end
		
		self:DrawModel()	
	end
end
