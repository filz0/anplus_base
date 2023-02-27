hook.Add("CreateClientsideRagdoll", "ANPlusLoad_CreateClientsideRagdoll", function(npc, rag)

	if IsValid(npc) && npc:IsANPlus() then
		
		if npc:ANPlusGetDataTab()['CurBGS'] then
		
			for i = 1, #npc:ANPlusGetDataTab()['CurBGS'] do
			
				rag:SetBodygroup( i, npc:ANPlusGetDataTab()['CurBGS'][ i ] )
	
			end
			
		end
			
		if npc:ANPlusGetDataTab()['CurSMS'] then

			for i = 0, #npc:ANPlusGetDataTab()['CurSMS'] do

				rag:SetSubMaterial( i, npc:ANPlusGetDataTab()['CurSMS'][ i + 1 ] )
				
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

end)

hook.Add("InitPostEntity", "ANPlusLoad_GModSaveLoadFromTheMenu", function()

	net.Start("anplus_gmodsave_load_from_the_menu")
	net.SendToServer()
	
end)

--[[////////////////////////
||||| Used for the test dummy ANPC.
]]--\\\\\\\\\\\\\\\\\\\\\\\\

local hitboxTranslate = {
	[0] = "Generic",
	[1] = "Head",
	[2] = "Chest",
	[3] = "Stomach",
	[4] = "LeftArm",
	[5] = "RightArm",
	[6] = "LeftLeg",
	[7] = "RightLeg",
	[8] = "Gear",
}

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
	
end)