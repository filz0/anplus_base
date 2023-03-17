local ENT = FindMetaTable("Entity")
local scrWidth = 1920
local scrHeight = 1080

local multX = ScrW() / scrWidth
local multY = ScrH() / scrHeight

net.Receive("anplus_add_fakename_language", function()
	local name = net.ReadString()
	if name then language.Add( name, name ); language.Add( "#" .. name, name ) end	
end)

net.Receive("anplus_fix_bones", function()

	local ent = net.ReadEntity()

	if IsValid(ent) then

		ent:SetupBones() 
		ent:DestroyShadow()
		
	end
	
end)

net.Receive("anplus_set_ik", function()

	local ent = net.ReadEntity()
	local bool = net.ReadBool()
	
	if IsValid(ent) then
	
		ent:SetIK(bool)
		
	end

end)

net.Receive("anplus_holo_eff", function()

	local ent = net.ReadEntity()
	local color = net.ReadColor()
	local size = net.ReadFloat()
	local leng = net.ReadFloat()

	--if IsValid(ent) then
	
		local fx = EffectData()
		fx:SetEntity( ent )
		fx:SetStart( Vector( color.r, color.g, color.b ) ) -- color
		fx:SetScale( size ) -- color
		fx:SetMagnitude( leng ) -- color
		util.Effect( "anp_holo_blip", fx, true )	
		
	--end

end)

net.Receive("anplus_client_effect", function()

	local ent = net.ReadEntity()
	local effTab = net.ReadTable()		
	if IsValid(ent) then		
		local fx = EffectData()
		fx:SetEntity( ent )
		fx:SetStart( effTab.SetStart || Vector( 0, 0, 0 ) )
		fx:SetOrigin( effTab.SetOrigin || Vector( 0, 0, 0 ) )
		fx:SetNormal( effTab.SetNormal || Vector( 0, 0, 0 ) )
		fx:SetMagnitude( effTab.SetMagnitude || 1 )
		fx:SetScale( effTab.SetScale || 1 )
		fx:SetRadius( effTab.SetRadius || 1 )
		fx:SetAngles( effTab.SetAngles || Angle( 0, 0, 0 ) )
		fx:SetAttachment( effTab.SetAttachment || 0 )
		fx:SetColor( effTab.SetColor || 0 )
		fx:SetDamageType( effTab.SetDamageType || 0 )
		fx:SetFlags( effTab.SetFlags || 0 )
		fx:SetHitBox( effTab.SetHitBox || 0 )		
		fx:SetMaterialIndex( effTab.SetMaterialIndex || 0 )
		fx:SetSurfaceProp( effTab.SetSurfaceProp || -1 )
		util.Effect( effTab.Effect, fx, true )				
	end

end)

net.Receive("anplus_data_tab", function()

	local npc = net.ReadEntity()
	local tab = net.ReadTable()
	
	for i = 1, #ANPlusLoadGlobal do	
		local dataTab = ANPlusLoadGlobal[ i ]
		if ( dataTab && dataTab['Name'] == tab['CurName'] ) then		
			local addTab = { ['Functions'] = dataTab['Functions'] }
			table.Merge( tab, addTab )
		end		
	end
	npc['ANPlusData'] = tab
end)

--[[
net.Receive("anplus_data_tab", function()

	local npc = net.ReadEntity()
	local tab = net.ReadTable()
	
	for i = 1, #ANPlusLoadGlobal do
		
		local dataTab = ANPlusLoadGlobal[ i ]

		if ( dataTab && dataTab['Name'] == tab['CurName'] ) then
			
			local addTab = { ['Functions'] = dataTab['Functions'] }
			table.Merge( tab, addTab )

		end
		
	end
	
	npc.ANPlusIDName = ANPlusIDCreate( tab['CurName'] )
	npc.ANPlusDataCur = tab

end)
]]--
local clientSounds = {}
net.Receive("anplus_play_ui_snd", function()
		
	local ply = LocalPlayer()
	local snd = net.ReadString() || ""
	local vol = net.ReadFloat() || 100
	
	if snd != "" then	
		ply:EmitSound( snd, nil, nil, vol / 100 )
		table.insert( clientSounds, snd )	
	elseif snd != "" && clientSounds && vol == 0 then
		for k, v in ipairs ( clientSounds ) do
			if v == snd then
				ply:StopSound( v ) 	
				table.remove( clientSounds, k ) 						
			end			
		end			
	elseif snd == "" && clientSounds then		
		for k, v in ipairs ( clientSounds ) do
			if v != nil then
				ply:StopSound( v ) 
				table.remove( clientSounds, k ) 						
			end			
		end
	end	
end)

/*
net.Receive("anplus_play_ui_snd", function()
		
	local ply = LocalPlayer()
	local snd = net.ReadString() || ""
	local vol = net.ReadFloat() || 100
	
	if snd != "" then
	
		ply:EmitSound( snd, nil, nil, vol / 100 )
		table.insert( clientSounds, snd )
	
	elseif snd != "" && clientSounds && vol == 0 then

		for k, v in ipairs ( clientSounds ) do
			if v == snd then
				timer.Simple( 0.1, function()
					ply:StopSound( v ) 
				end)
				timer.Simple( 0.2, function()		
					table.remove( clientSounds, k ) 				
				end)		
			end			
		end	
		
	elseif snd == "" && clientSounds then
		
		for k, v in ipairs ( clientSounds ) do

			if v != nil then
				timer.Simple( 0.1, function()
					ply:StopSound( v ) 
				end)
				timer.Simple( 0.2, function()		
					table.remove( clientSounds, k ) 				
				end)		
			end			
		end
	end	
end)
*/

net.Receive("anplus_chatmsg_ply", function()	
	local ply = LocalPlayer()
	local snd = net.ReadString() || ""
	local color = net.ReadColor() || ""
	local text = net.ReadString()
	chat.AddText( color, text )
	if snd then EmitSound( snd, ply:GetPos(), -2 ) end		
end)

net.Receive("anplus_screenmsg_ply", function()
	local ply = LocalPlayer()
	local dur = net.ReadFloat()
	local x = net.ReadFloat()
	local y = net.ReadFloat()
	local size = net.ReadFloat()
	local font = net.ReadString()
	local color = net.ReadColor()
	local text = net.ReadString() || ""	
	if IsValid(ply.anp_ScreenMSG) then ply.anp_ScreenMSG:Remove() end
	if text == "" then return end	
	ply.anp_ScreenMSG = vgui.Create( "DLabel" )
	ply.anp_ScreenMSG:SetPos( x * multX, y * multY )
	ply.anp_ScreenMSG:SetSize( ScrW(), size * multY )
	ply.anp_ScreenMSG:SetText( text )
	ply.anp_ScreenMSG:SetTextColor( color )
	ply.anp_ScreenMSG:SetFont( font )
	ply.anp_ScreenMSG:SetWrap( false )
	ply.anp_ScreenMSG:ParentToHUD()	
	timer.Create( "CHATMODmsgRemove" .. ply:EntIndex(), dur, 1, function()	
		if IsValid(ply.anp_ScreenMSG) then ply.anp_ScreenMSG:Remove() end	
	end)
end)