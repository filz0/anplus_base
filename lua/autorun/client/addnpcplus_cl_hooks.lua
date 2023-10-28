------------------------------------------------------------------------------=#
if ( !file.Exists( "autorun/addnpcplus_base.lua" , "LUA" ) ) then return end
------------------------------------------------------------------------------=#

hook.Add("CreateClientsideRagdoll", "ANPlusLoad_CreateClientsideRagdoll", function(npc, rag)
	
	if IsValid(npc) && IsValid(rag) && npc:IsNPC() then  
	
		npc.m_pCRagdollEntity = rag
		
		if npc:IsANPlus() then

			if npc:ANPlusGetDataTab()['CurFakeModel'] then rag:ANPlusFakeModel( npc:ANPlusGetDataTab()['CurFakeModel']['Model'], npc:ANPlusGetDataTab()['CurFakeModel']['VisualTab'] ) end
			
			for i = 1, #npc:GetBodyGroups() do		
				rag:SetBodygroup( i, npc:GetBodygroup( i ) )
			end
				
			for i = 0, #npc:GetMaterials() do				
				rag:SetSubMaterial( i, npc:GetSubMaterial( i ) || npc:GetMaterials()[ i ] )
			end
			
			if npc:ANPlusGetDataTab()['CurBones'] then
				for i = 1, #npc:ANPlusGetDataTab()['CurBones'] do		
					local bone = rag:GetPhysicsObjectNum( i )					
					if IsValid( bone ) then
						bone:SetPos( npc:ANPlusGetDataTab()['CurBones'][ i ][ 1 ] )
						bone:SetAngles( npc:ANPlusGetDataTab()['CurBones'][ i ][ 2 ] )
						bone:EnableMotion( true )				
					end			
				end
			end

			if npc:ANPlusGetDataTab()['Functions'] && npc:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'] != nil then
				
				npc:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'](npc, rag)
			
			end

		end

		if IsValid(npc) && IsValid(npc:GetOwner()) && npc:GetOwner():IsANPlus() then

			local raggibOwner = npc:GetOwner()

			if raggibOwner:ANPlusGetDataTab()['Functions'] && raggibOwner:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'] != nil then
				
				raggibOwner:ANPlusGetDataTab()['Functions']['OnNPCRagdollCreated'](raggibOwner, rag)
			
			end

		end
	
	end

end)

local dev = GetConVar( "developer" )
local barDist = GetConVar( "anplus_hpbar_dist" )
local function CheckDaThing(ent)	
	--if !IsValid(ent) then return false end
	if !ent:IsANPlus() then return false end 	
	if !ent:ANPlusGetDataTab()['HealthBar'] then return false end 
	local barTab = ent:ANPlusGetDataTab()['HealthBar']
	local state = ent:GetNWFloat( "m_fANPlusNPCState" )
	if ( barTab['Mode'] == 2 && state != 3 ) then return false end
	if ( barTab['Mode'] == 3 && state != 2 ) then return false end
	if ( barTab['Mode'] == 4 && state != 2 && state != 3 ) then return false end 
	return true
end

local hbBarStyle = GetConVar( "anplus_hpbar_def_style" )

hook.Add( "HUDPaint", "ANPlusLoad_HUDPaint", function()
	if ( dev:GetFloat() ) > 2 then DrawMaterialOverlay( "effects/anp/grid2.png", 0 ) end
	
	local ply = LocalPlayer()
	if ANPHealthBarStyles && hbBarStyle:GetString() != "Disable All" then
		local lookForBosses = ents.FindInSphere( ply:GetPos(), barDist:GetFloat() )	
		local ent, distSqr, dist = ANPlusFindClosestEntity( ply:GetPos(), lookForBosses, function(ent) if CheckDaThing(ent) then return true end end )
		local tr = ply:GetEyeTrace()
		ent = tr && CheckDaThing(tr.Entity) && tr.Entity || ent
		
		if IsValid(ent) then
			local barTab = ent:ANPlusGetDataTab()['HealthBar']
			local barStyle = ANPHealthBarStyles[barTab['StyleOverride'] || hbBarStyle:GetString()]

			if isfunction( barStyle ) then			
				barStyle(ent)
			end
		end
		
		if IsValid(ply:ANPlusControlled()) then
			local ent = ply:ANPlusControlled()
			local wep = ent:GetActiveWeapon()
			if IsValid(wep) then
				
				draw.RoundedBox( 8, 900 * ANPlusGetFixedScreenW(), 942 * ANPlusGetFixedScreenH(), 90 * ANPlusGetFixedScreenW(), 100 * ANPlusGetFixedScreenH(), Color( 0, 0, 0, 155 ) ) 
				draw.SimpleText( wep:Clip1(), "HudNumbers", 940 * ANPlusGetFixedScreenW(), 942 * ANPlusGetFixedScreenH(), Color( 255, 255, 255, 255 ), 1, 1 )	
				
			end
		end
	end
end)

hook.Add( "PopulateNPCs", "ANPlusLoad_PopulateNPCs", function(pnlContent, tree, node)
	local npcData = list.GetForEdit( "NPC" )
	for i = 1, #ANPRemoveFromSpawnList do
		local npcToRemove = ANPRemoveFromSpawnList[ i ]
		if npcData[ npcToRemove ] then
			print( "ANP REMOVED NPC", npcData[ npcToRemove ]['Name'] )
			npcData[ npcToRemove ] = nil
		end
	end
end)

hook.Add( "PopulateEntities", "ANPlusLoad_PopulateEntities", function(pnlContent, tree, node)
	local entData = list.GetForEdit( "SpawnableEntities" )
	for i = 1, #ANPRemoveFromSpawnList do
		local entToRemove = ANPRemoveFromSpawnList[ i ]
		if entData[ entToRemove ] then
			print( "ANP REMOVED ENTITY", entData[ entToRemove ]['PrintName'] )
			entData[ entToRemove ] = nil
		end
	end
end)

hook.Add( "OnSpawnMenuOpen", "ANPlusLoad_OnSpawnMenuOpen", function()
	local ply = LocalPlayer()
	net.Start( "anplus_ply_spawnmenu" )
	net.WriteBool( true )
	net.SendToServer()
	ply.m_bSpawnMenuOpen = true
end)

hook.Add( "OnSpawnMenuClose", "ANPlusLoad_OnSpawnMenuClose", function()
	local ply = LocalPlayer()
	net.Start( "anplus_ply_spawnmenu" )
	net.WriteBool( false )
	net.SendToServer()
	ply.m_bSpawnMenuOpen = false
end)

--[[
local metaPLAYER = FindMetaTable("Player")

metaPLAYER.suppressBScatter=0
metaPLAYER.suppressBLayers=1
metaPLAYER.suppressNextFadeout=0

local offset=ScreenScale(256)
local gradient=Material( " effects/anp/vignette.png" )
local blur=Material( "pp/blurscreen" )

metaPLAYER.suppressGWidth=ScrW()+offset
metaPLAYER.suppressGHeight=ScrH()+offset
 
function render.ANPlusDrawOverlay( effectName, tab )
	if effectName == "suppress" && tab then
		metaPLAYER.suppressGWidth		= ANPlusGetFixedScreenW() + ( tab['Offset'] || 0 )
		metaPLAYER.suppressGHeight		= ANPlusGetFixedScreenH() + ( tab['Offset'] || 0 )
		metaPLAYER.suppressBScatter 	= tab['Strength'] || 1
		metaPLAYER.suppressNextFadeout	= tab['Duration'] || CurTime() + 0.1
	end
end

hook.Add( "HUDPaint", "ANPlusLoad_TestDummyDMGStuff", function()

	local ply = LocalPlayer()
	local radius = ents.FindInSphere( ply:GetPos(), 300 )
	for k,v in pairs ( radius ) do	

		if v:IsNPC() && v:IsANPlus() && v:ANPlusGetDataTab()['CurName'] == "[ANP] Test Dummy" then
				
			local vpos = v:GetPos() + Vector(0,0,v:BoundingRadius()*1.85)
			local vpos2 = v:GetPos() + Vector(0,0,v:BoundingRadius()*2)
			local vinfopos = vpos:ToScreen()
			local vinfopos2 = vpos2:ToScreen()
			
			draw.SimpleTextOutlined( "Damage: " .. ( v:GetNWFloat( "ANP_TestDummyDamage" ) || 0 ) .. " | HitGroup: " .. ( hitboxTranslate[ v:GetNWFloat( "ANP_TestDummyHitBox" ) ] || "None" ), "Trebuchet18", vinfopos.x, vinfopos.y, v:GetColor(), 1, 1, 1, Color( 0, 0, 0, 255 ) )									
			
		end
		
	end
	
	local scrW=ScrW()
	local scrH=ScrH()
	local offx=scrW+offset
	local offy=scrH+offset
	local texW=physBullet.suppressGWidth
	local texH=physBullet.suppressGHeight

	if physBullet.suppressNextFadeout<=CurTime() then
		if texW<offx then
			texW=math.min(texW+2,offx)
		end

		if texH<offy then
			texH=math.min(texH+2,offy)
		end

		if physBullet.suppressBScatter>0 then
			physBullet.suppressBScatter=math.max(physBullet.suppressBScatter-0.05,0)
		end
	end

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(scrW/2-texW/2,scrH/2-texH/2,texW,texH)

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	if physBullet.suppressBScatter>0 then
		for i=1,physBullet.suppressBLayers do
			blur:SetFloat("$blur",(i/physBullet.suppressBLayers)*physBullet.suppressBScatter)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0,0,scrW,scrH)
		end
	end

	physBullet.suppressGWidth=texW
	physBullet.suppressGHeight=texH
	
end)

hook.Add( "PopulateNPCs", "ANPlusLoad_PopulateNPCs", function(pnlContent, tree, node)
	local npcData = list.GetForEdit( "NPC" )
	for i = 1, #ANPRemoveFromSpawnList do
		local npcToRemove = ANPRemoveFromSpawnList[ i ]
		if npcData[ npcToRemove ] then
			print("REMOVED NPC", npcData[ npcToRemove ])
			npcData[ npcToRemove ] = nil
			--npcToRemove = nil
		end
	end
end)

hook.Add( "PopulateEntities", "ANPlusLoad_PopulateEntities", function(pnlContent, tree, node)
	local entData = list.GetForEdit( "SpawnableEntities" )
	for i = 1, #ANPRemoveFromSpawnList do
		local entToRemove = ANPRemoveFromSpawnList[ i ]
		if entData[ entToRemove ] then
			entData[ entToRemove ] = nil
			--entToRemove = nil
		end
	end
end)
]]--