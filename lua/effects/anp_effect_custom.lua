function EFFECT:Init( data ) -- Idk...
	local index = data:GetEntIndex()
	local owner = data:GetEntity()
	local func = owner['m_funcANPCustomEffect' .. index]
	
	if isfunction(func) then
		func()
	end
	
end

effects.Register( EFFECT, "anp_effect_custom" )