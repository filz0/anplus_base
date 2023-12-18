local ANPlusLoaded = file.Exists("lua/autorun/addnpcplus_base.lua","GAME") 
if !ANPlusLoaded then return end

----------------------------------------------------------- Precache Section
--WARNING!
--Modelprecache is limited to 4096 unique models. When it reaches the limit the game will crash.
--Soundcache is limited to 16384 unique sounds on the server.
----------------------------------------------------------]] 

--util.PrecacheModel( "models/odessa.mdl" ) -- There is no need to precache this model

--util.PrecacheSound( string soundName )
------------------------------------------------------------
 
--if !duplicator.IsAllowed( "item_item_crate" ) then duplicator.Allow( "item_item_crate" ) end
--[[

item_item_crate turned out to be unusable due to its spawn function

	if ( NULL_STRING == m_strItemClass )
	{
		Warning( "CItem_ItemCrate(%i):  CRATE_SPECIFIC_ITEM with NULL ItemClass string (deleted)!!!\n", entindex() );
		UTIL_Remove( this );
		return;
	}
	
which makes it delete itself cuz duplicator can't apply required KeyValue fast enough.

]]--

ANPlus.AddNPC( {
	['Spawnable']				= false,
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "ANPBase",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "ANPlusGib", 
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "gib",
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= false,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks. Remember to remove unused functions for the performance's sake.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- ( CLIENT & SERVER ) -- Player is valid only when PlayerSpawnedNPC gets called.
			if (SERVER) then
			
				self:ANPlusCreateVar( "m_fRemoveDelay", 6 )
				self:ANPlusCreateVar( "m_fRadius", self:GetModelRadius() || 10 )
				self:ANPlusCreateVar( "m_fAngularVelocity", Angle( math.random( 250, 400 ), math.random( 250, 400 ), 0 ) )
				self:ANPlusCreateVar( "m_fVelocity", Vector( math.random( -400, 400 ), math.random( -400, 400 ), math.random( 400, 800 ) ) )
				self.m_fRemoveLast = CurTime()	
				self.m_fHitWorld = false	
				
				self:SetMoveType( 5 )
				self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				self:SetLocalAngularVelocity( self.m_fAngularVelocity )
				self:SetVelocity( self.m_fVelocity )
				
			end
		end,
		
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self) -- ( CLIENT & SERVER )   	
			if (SERVER) then
			
				if CurTime() - self.m_fRemoveLast >= self.m_fRemoveDelay then
					self:Remove()
				end
				
				if !self.m_fHitWorld then
				
					local tr = util.TraceLine( {
						start = self:GetPos(),
						endpos = self:GetPos() - self:GetUp() * self.m_fRadius,
						filter = self,
						mask = MASK_SOLID_BRUSHONLY
						} 		
					)
					
					if tr.Hit then
						self.m_fHitWorld = true
						self:SetMoveType( MOVETYPE_NONE )
						self:SetLocalAngularVelocity( Angle( 0, 0, 0 ) )
						self:SetVelocity( Vector( 0, 0, 0 ) )
					end
					
				end
			end
		end, 
		
	},
	
}, "SpawnableEntities" )

 
if (CLIENT) then
	surface.CreateFont("anphl2defaultABC", {
		font = "dejavusans",
		size = 22 * ANPlusGetFixedScreenW(),
		--scanlines = 3
	})
	surface.CreateFont("anphl2default123", {
		font = "halflife2",
		size = 22 * ANPlusGetFixedScreenW(),
		--scanlines = 3
	})
	surface.CreateFont("anphl2betaABC", {
		font 		= "ocrbczyk",
		size 		= 42 * ANPlusGetFixedScreenW(),
		scanlines 	= 3,
		blursize 	= 2
	})
	surface.CreateFont("anphl2betaABCBG", {
		font 		= "ocrbczyk",
		size 		= 42 * ANPlusGetFixedScreenW(),
		scanlines 	= 3,
		blursize 	= 8,
	})
	surface.CreateFont("anphl2beta123", {
		font = "ocrbczyk_bold",
		size 		= 42 * ANPlusGetFixedScreenW(),
		scanlines 	= 3,
		blursize 	= 2
	})
	surface.CreateFont("anphl2beta123BG", {
		font 		= "ocrbczyk_bold",
		size 		= 42 * ANPlusGetFixedScreenW(),
		scanlines 	= 3,
		blursize 	= 1
	})
end

local hpLast = 0
local hpBuff = 0
local hpTime = 0

local bgCol 	= Color( 0, 0, 0, 155 )
local textCol 	= Color( 255, 220, 0, 255 )
local textBGCol = Color( 0, 0, 0, 255 )
local font 		= "anphl2defaultABC"
local font2 	= "anphl2default123"

ANPlus.AddHealthBarStyle( "HL2 Retail", function(ent) 
	print("lol")
	local ply = LocalPlayer()
	local barTab = ent:ANPlusGetDataTab()['HealthBar']
	
	local x = 660 * ANPlusGetFixedScreenW()
	local y = 100 * ANPlusGetFixedScreenH()
	local w = 600 * ANPlusGetFixedScreenW()
	local h = 60 * ANPlusGetFixedScreenH()
	
	local x2 = x + 10 * ANPlusGetFixedScreenW()
	local y2 = y + 25 * ANPlusGetFixedScreenH()
	local w2 = w - 20 * ANPlusGetFixedScreenW()
	local h2 = h - 35 * ANPlusGetFixedScreenH()
	
	local x3 = x + 13 * ANPlusGetFixedScreenW()
	local y3 = y + 28 * ANPlusGetFixedScreenH()
	local w3 = w - 26 * ANPlusGetFixedScreenW()
	local h3 = h - 40 * ANPlusGetFixedScreenH() 
	
	local hp = ent:GetNW2Float( "m_fANPBossHP" ) || ent:Health()
	local hpMax = ent:GetMaxHealth()
	local hpper = math.Remap( hp, 0, hpMax, 0, 100 )
	hpper = math.Round( hpper, 2 )
	hp = math.Remap( hp, 0, hpMax, 0, 1 )		
	
	local col = col || textCol	
	
	if hpLast != hp || ply.m_pANPLastHPBarEnt != ent then				
		hpBuff = ( hp - hpLast )
		hpTime = CurTime() + 1
		hpLast = hp	
	end
	
	if hpTime > CurTime() && ( IsValid(ply.m_pANPLastHPBarEnt) && ply.m_pANPLastHPBarEnt == ent ) then
		if hpBuff < 0 then
			col = Color( 255, math.Clamp( 255 - ( 255 * (hpTime - CurTime()) ), 0, 220 ), 0, 255 )  
			--hpOLine = math.Clamp( ( hpTime - CurTime() ) * 2, 0, 1 ) * 2
		elseif hpBuff > 0 then
			col = Color( math.Clamp( 255 - ( 255 * (hpTime - CurTime()) ), 0, 255 ), math.Clamp( 255 + ( 255 * (hpTime - CurTime()) ), 0, 220 ), 0, 255 )
			--hpOLine = math.Clamp( ( hpTime - CurTime() ) * 255, 0, 1 ) * 2
		end
	else
		hpBuff = 0
	end
 
	local text = string.upper( ent:ANPlusGetDataTab()['KillfeedName'] || ent:ANPlusGetDataTab()['CurName'] )
	 
	draw.RoundedBox( 8, x, y, w, h, bgCol )
	surface.SetDrawColor( textCol )
	surface.DrawOutlinedRect( x2, y2, w2, h2, 2 * ANPlusGetFixedScreenW() )
	draw.RoundedBox( 0, x3, y3, w3 * hp, h3, col )
	
	local tx = x + 300 * ANPlusGetFixedScreenW()
	
	draw.SimpleText( text, font, tx, y, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	
	ply.m_pANPLastHPBarEnt = ent
end )

local bgCol 	= Color( 0, 0, 0, 155 )
local textCol 	= Color( 255, 220, 0, 255 )
local textBGCol = Color( 255, 220, 0, 170 )
local textBGCol2 = Color( 255, 220, 0, 40 )
local font 		= "anphl2betaABC"
local fontBG 	= "anphl2betaABCBG"
local font2 	= "anphl2beta123"
local font2BG 	= "anphl2beta123BG"

ANPlus.AddHealthBarStyle( "HL2 Beta", function(ent) 
	local ply = LocalPlayer()
	local barTab = ent:ANPlusGetDataTab()['HealthBar']
	
	local x = 660 * ANPlusGetFixedScreenW()
	local y = 100 * ANPlusGetFixedScreenH()
	local w = 600 * ANPlusGetFixedScreenW()
	local h = 60 * ANPlusGetFixedScreenH()
	
	local x2 = x + 10 * ANPlusGetFixedScreenW()
	local y2 = y + 25 * ANPlusGetFixedScreenH()
	local w2 = w - 20 * ANPlusGetFixedScreenW()
	local h2 = h - 35 * ANPlusGetFixedScreenH()
	
	local x3 = x + 13 * ANPlusGetFixedScreenW()
	local y3 = y + 28 * ANPlusGetFixedScreenH()
	local w3 = w - 26 * ANPlusGetFixedScreenW()
	local h3 = h - 40 * ANPlusGetFixedScreenH()  
	
	local hp = ent:GetNW2Float( "m_fANPBossHP" ) || ent:Health()
	local hpMax = ent:GetMaxHealth()
	local hpper = math.Remap( hp, 0, hpMax, 0, 100 )
	hpper = math.Round( hpper, 0 )		
	hpper = math.max( hpper, 0 )		
 
	local text = string.upper( ent:ANPlusGetDataTab()['KillfeedName'] || ent:ANPlusGetDataTab()['CurName'] )
	
	local tx = x + 300 * ANPlusGetFixedScreenW()

	draw.SimpleText( text, fontBG, tx, y, textBGCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( text, font, tx, y, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	local x2 = x + 300 * ANPlusGetFixedScreenW()
	local x3 = x + 328 * ANPlusGetFixedScreenW()
	local y2 = y + 35 * ANPlusGetFixedScreenH()	
	
	local col = col ||  textCol	
	
	if hpLast != hp then				
		hpBuff = ( hp - hpLast )
		hpTime = hp != hpLast && CurTime() + 1 || CurTime()
		hpLast = hp	
	end
	
	if hpTime > CurTime() then
		if hpBuff < 0 then
			col = Color( 255, math.Clamp( (hpTime - CurTime()) * 255, 220, 255 ), math.Clamp( (hpTime - CurTime()) * 255, 0, 255 ), 255 )  
		elseif hpBuff > 0 then
			col = Color( math.Clamp( 255 - ( 255 * (hpTime - CurTime()) ), 0, 255 ), math.Clamp( 255 + ( 255 * (hpTime - CurTime()) ), 0, 220 ), 0, 255 )
		end
	else
		hpBuff = 0
	end
	
	draw.SimpleText( "+ 000 +", font2BG, x2, y2, textBGCol2, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( "+ 222 +", font2BG, x2, y2, textBGCol2, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( "+ 000 +", fontBG, x2, y2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.SimpleText( hpper, font2, x3, y2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	draw.SimpleText( "+       +", font2, x2, y2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	
	local x3 = x2 + 10 * ANPlusGetFixedScreenW()
	
	--draw.SimpleTextOutlined( "%", font, x3, y2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, textBGCol )
	ply.m_pANPLastHPBarEnt = ent
end )

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "Half-Life 2",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Item Crate", 
----------------------------------------------------------------- If set, this name will be used in the killfeed instead keeping the Name/ID alone.
	['KillfeedName'] 			= "Item Crate",	
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "prop_physics",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] 					= { 
		{ "models/Items/item_item_crate.mdl",  
			['BodyGroups'] 	 	= nil, 
			['Skin'] 		 	= nil,			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 	= nil,				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] 	= nil,  
		},
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Displays author of this Entity.
	['Author']					= "filz0",
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after the spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not possess any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= 20,
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 				= { ItemClass = "item_dynamic_resupply", ItemCount = 3 },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Increase or decrease NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 			= false,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- ( CLIENT & SERVER ) -- Player is valid only when PlayerSpawnedNPC gets called.
			self:ANPlusCreateVar( "m_sItemClass", "item_dynamic_resupply", "Item Class", "Class of an item to spawn when broken." )
			self:ANPlusCreateVar( "m_sItemKeyValues", "SpawnFlags = 4", "Item KeyValues", "KeyValues that will be applied to the spawned item/s. ( SpawnFlags = 2, Model=models/cool/cool.mdl, etc )" )
			self:ANPlusCreateVar( "m_sItemInputs", "CalculateType ; 0 ; 0", "Item Inputs", "KeyValues that will be applied to the spawned item/s. ( InputName ; Value ; Delay, InputName2;Value;Delay, etc )" )
			self:ANPlusCreateVar( "m_fItemCount", 1, "Item Count", "Amount of items to spawn.", 1, 10, 0 )
			
			if (SERVER) then 
				--BoxSetup(self, self.m_fAmmoType)
				--self:ANPlusCreateOutputHook( "OnUsed", "ANPAmmoCrateOnUsed" ) 
				--self:ANPlusWiremodSetOutputs( false, 			
				--{ -- Outputs
				--"OnUsed"
				--},
				--
				--{ -- Descriptions
			--	"Fires when +used by the player."
			--	} )
			
			end
		end,
		
		------------------------------------------------------------ OnNPCBreak - Called when entity breaks. Used for non-NPC entities.
		['OnNPCBreak'] = function(self, attacker) -- ( CLIENT & SERVER )	
			if self.m_sItemClass && isstring(self.m_sItemClass) && self.m_sItemClass != "" then
				for i = 1, self.m_fItemCount do
					
					anpEnt = ANPlusLoadGlobal[self.m_sItemClass]
				
					local drop = ents.Create( anpEnt && anpEnt['Class'] || self.m_sItemClass )
					
					if ( !IsValid( drop ) ) then print( "Item Crate's loot didn't spawn or its class was invalid." ) return nil end
					
					local tr = util.TraceLine( {
						start = self:GetPos(),
						endpos = self:GetPos() + Vector( 0, 0, -self:GetModelRadius() || -5 ),
						filter = self,
						ignoreworld = false,
						mask = MASK_SHOT_HULL
						} 		
					)
									
					local pos = tr.Hit && tr.HitPos || self:GetPos() + self:OBBCenter()
					
					drop:SetPos( pos )							
					
					local phyObj = drop:GetPhysicsObject()
					local ang = ( drop:IsNPC() || !IsValid(phyObj) ) && Angle( 0, self:GetAngles().y, 0 ) || Angle( math.random( -20, 20 ), math.random( 0, 360 ), math.random( -20, 20 ) )
					
					drop:SetAngles( ang )	
					
					if IsValid(phyObj) then
						local vel = VectorRand( -10, 10 )
						phyObj:SetVelocity( vel )
					end
					
					if self.m_sItemKeyValues && isstring(self.m_sItemKeyValues) && self.m_sItemKeyValues != "" then
						
						local kvs = string.find( self.m_sItemKeyValues:lower(), ", " ) && string.Split( self.m_sItemKeyValues, ", " ) || string.find( self.m_sItemKeyValues:lower(), "," ) && string.Split( self.m_sItemKeyValues, "," ) || self.m_sItemKeyValues

						if istable(kvs) then
							for i = 1, #kvs do
								local val = kvs[ i ]
								if val then 
									val = string.find( val:lower(), " = " ) && string.Split( val, " = " ) || string.find( val:lower(), "=" ) && string.Split( val, "=" )
									drop:SetKeyValue( tostring( val[ 1 ] ), tostring( val[ 2 ] ) )
								end
							end
						else
							kvs = string.find( kvs:lower(), " = " ) && string.Split( kvs, " = " ) || string.find( kvs:lower(), "=" ) && string.Split( kvs, "=" )
							drop:SetKeyValue( tostring( kvs[ 1 ] ), tostring( kvs[ 2 ] ) )
						end
					end
					
					if self.m_sItemInputs && isstring(self.m_sItemInputs) && self.m_sItemInputs != "" then
						
						local inp = string.find( self.m_sItemInputs:lower(), ", " ) && string.Split( self.m_sItemInputs, ", " ) || string.find( self.m_sItemInputs:lower(), "," ) && string.Split( self.m_sItemInputs, "," ) || self.m_sItemInputs

						if istable(inp) then
							for i = 1, #inp do
								local val = inp[ i ]
								if val then 
									val = string.find( val:lower(), " ; " ) && string.Split( val, " ; " ) || string.find( val:lower(), ";" ) && string.Split( val, ";" )
									drop:Fire( istable(val) && tostring( val[ 1 ] ) || val, istable(val) && tostring( val[ 2 ] ) || "", istable(val) && tonumber( val[ 3 ] ) || 0 )
								end
							end
						else
							inp = string.find( inp:lower(), " ; " ) && string.Split( inp, " ; " ) || string.find( inp:lower(), ";" ) && string.Split( inp, ";" ) || inp							
							drop:Fire( istable(inp) && tostring( inp[ 1 ] ) || inp, istable(inp) && tostring( inp[ 2 ] ) || "", istable(inp) && tonumber( inp[ 3 ] ) || 0 )
						end
					end
					
					drop:Spawn()
					drop:Activate()
					
					drop:ANPlusNPCApply( anpEnt && anpEnt['Name'] )
				end
			end
		end,
		
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
		end,
		
	},
	
}, "SpawnableEntities" )

if !duplicator.IsAllowed( "item_ammo_crate" ) then duplicator.Allow( "item_ammo_crate" ) end

local function BoxSetup(self, val)
	self:SetKeyValue( "AmmoType", val )
	self:SetSaveValue( "m_nAmmoType", val )
	self:SetSaveValue( "m_nAmmoIndex", val )
	self:Spawn()
	self:PhysicsInit( SOLID_VPHYSICS )
end

hook.Add( "ANPAmmoCrateOnUsed", "ANPBaseAmmoCrate_OnUsed", function()
	local activator, self = ACTIVATOR, CALLER	
	if self:ANPlusIsWiremodCompEnt() then WireLib.TriggerOutput( self, "OnUsed", 1 ) end
end )

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "Half-Life 2",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Ammo Crate", 
----------------------------------------------------------------- If set, this name will be used in the killfeed instead keeping the Name/ID alone.
	['KillfeedName'] 			= "Ammo Crate",	
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "item_ammo_crate",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] 					= nil,
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Displays author of this Entity.
	['Author']					= "filz0",
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after the spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not possess any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= false,
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Increase or decrease NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 			= false,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- ( CLIENT & SERVER ) -- Player is valid only when PlayerSpawnedNPC gets called.
			self:ANPlusCreateVar( "m_fAmmoType", 0, "AmmoType", "Total charge of suit points.", 0, 9, 0, function(self, val) BoxSetup(self, val) end )
			if (SERVER) then
				BoxSetup(self, self.m_fAmmoType)
				self:ANPlusCreateOutputHook( "OnUsed", "ANPAmmoCrateOnUsed" ) 
				self:ANPlusWiremodSetOutputs( false, 			
				{ -- Outputs
				"OnUsed"
				},
				
				{ -- Descriptions
				"Fires when +used by the player."
				} )
			end
		end,
		
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
		end,
		
	},
	
}, "SpawnableEntities" )

hook.Add( "ANPCitadelChargerOutRemainingCharge", "ANPBaseCCharger_OutRemainingCharge", function()
	local activator, self = ACTIVATOR, CALLER	
	if self:ANPlusIsWiremodCompEnt() then WireLib.TriggerOutput( self, "OutRemainingCharge", 1 ) end
end )

hook.Add( "ANPCitadelChargerOnHalfEmpty", "ANPBaseCCharger_OnHalfEmpty", function()
	local activator, self = ACTIVATOR, CALLER	
	if self:ANPlusIsWiremodCompEnt() then WireLib.TriggerOutput( self, "OnHalfEmpty", 1 ) end
end )

hook.Add( "ANPCitadelChargerOnEmpty", "ANPBaseCCharger_", function()
	local activator, self = ACTIVATOR, CALLER	
	if self:ANPlusIsWiremodCompEnt() then WireLib.TriggerOutput( self, "OnEmpty", 1 ) end
end )

hook.Add( "ANPCitadelChargerOnFull", "ANPBaseCCharger_OnFull", function()
	local activator, self = ACTIVATOR, CALLER	
	if self:ANPlusIsWiremodCompEnt() then WireLib.TriggerOutput( self, "OnFull", 1 ) end
end )

hook.Add( "ANPCitadelChargerOnPlayerUse", "ANPBaseCCharger_OnPlayerUse", function()
	local activator, self = ACTIVATOR, CALLER	
	if self:ANPlusIsWiremodCompEnt() then WireLib.TriggerOutput( self, "OnPlayerUse", 1 ) end
end )

local ENTTab = {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 				= "Half-Life 2",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 					= "Suit Charger (Citadel)",   
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 					= "item_suitcharger",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "", 
			['PhysicsInit'] = SOLID_VPHYSICS, 
		},
		---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Displays author of this Entity.
	['Author']					= "filz0",
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after the spawn. (eg. ['Rotate'] = Angle( 0, 180,  0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not possess any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= false,
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
--[[ EXAMPLE
	['KeyValues'] 			= { citizentype = CT_REBEL, SquadName = "resistance" },
--]]
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 8192, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
--[[ EXAMPLE
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
		{ "kill", "", 1 }, -- I'll kill*myself within 1 second after spawn.
	},  
--]]
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Increase or decrease NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
--[[ EXAMPLE
	['SoundModification'] = {
	
		['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			['SoundLevel'] = 100, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			['Pitch'] = { 70, 100 }, -- Also can be randomised,
			['Channel'] = CHAN_VOICE, 
			['Volume'] = 0.3, -- Same.
			['Flags'] = 1024, 
			['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" } }, 

		},
		
	}, 
--]]
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {
	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- Player is valid only when PlayerSpawnedNPC gets called.
			
			self:ANPlusCreateVar( "m_iMaxJuice", GetConVar( "sk_suitcharger_citadel" ):GetFloat(), "Max Charge", "Total charge of suit points.", 1, 99999, 0, function(self, val) self:SetSaveValue( "m_iMaxJuice", val ) end )
			self:ANPlusCreateVar( "m_iJuice", GetConVar( "sk_suitcharger_citadel" ):GetFloat(), "Charge", "Current charge of suit points.", 1, 99999, 0, function(self, val) self:SetSaveValue( "m_iJuice", val ) end )
			
			if (SERVER) then
				self:SetSaveValue( "m_iMaxJuice", self.m_iMaxJuice )
				self:SetSaveValue( "m_iJuice", self.m_iJuice )
				self.m_sBatteryModel = "models/items/battery.mdl"
				self:ANPlusCreateOutputHook( "OutRemainingCharge", "ANPCitadelChargerOutRemainingCharge" ) 
				self:ANPlusCreateOutputHook( "OnHalfEmpty", "ANPCitadelChargerOnHalfEmpty" ) 
				self:ANPlusCreateOutputHook( "OnEmpty", "ANPCitadelChargerOnEmpty" ) 
				self:ANPlusCreateOutputHook( "OnFull", "ANPCitadelChargerOnFull" ) 
				self:ANPlusCreateOutputHook( "OnPlayerUse", "ANPCitadelChargerOnPlayerUse" ) 			
				
				self:ANPlusWiremodSetInputs( false, 
				{ -- Inputs
					"SetCharge",
					"Recharge"
				}, 
				
				{ -- Descriptions
					"Set charge and total charge to a specific amount.",
					"Sets charge to maximum."
				},
				
				{ -- Functions (each input should have one)
					function(self, key, val)
						self:Fire( key, val, 0 )
					end,
					function(self, key, val)
						self:Fire( key, val, 0 )
					end,
				} )
				
				self:ANPlusWiremodSetOutputs( false, 			
				{ -- Outputs
					"OutRemainingCharge",
					"OnHalfEmpty",
					"OnEmpty",
					"OnFull",
					"OnPlayerUse",
				},
				
				{ -- Descriptions
					"Fired once for every single point of power given to the suit. This means it will not fire when the charger is depleted or when the suit is at full power.",
					"Fired when the 'charge left' reaches 50% of its max.",
					"Fired when the charger is empty.",
					"Fired when player gets recharged to the max.",
					"Fired when the player tries to +use the charger.",
				} )
			end
			
		end,
		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['SetUseType'] = CONTINUOUS_USE,
		['OnNPCUse'] = function(self, activator, caller, type)	
			timer.Create( "ANP_TEMP_SUITCHARGER_DRIPEEG_STOP" .. self:EntIndex(), 0.1, 1, function()
				if !IsValid(self) then return end
				self.m_bFireThatEEgg = false
				self:StopSound( "anp/suitcharger_egg/suitchargeok1.wav" )
				self:StopSound( "anp/suitcharger_egg/suitcharge1.wav" )
			end)
		end,
		
		------------------------------------------------------------ OnNPCInput - Almost anything that happens to this NPC/Entity will go through here. Great for detecting inputs.
		['OnNPCInput'] = function(self, input, activator, caller, data)	
			if input == "Recharge" then
				self:ANPlusHaloEffect( Color( 255, 155, 0 ), 3, 1 )
			end
		end,
		
		------------------------------------------------------------ OnNPCPhysicsCollide - Called when the entity collides with anything. The move type and solid type must be VPHYSICS for the hook to be called.
		['OnNPCPhysicsCollide'] = function(self, data, physobj)	
			local ent = data.HitEntity
			if IsValid(ent) && ent:GetModel() == self.m_sBatteryModel && IsValid(ent:GetPhysicsObject()) && self:GetInternalVariable( "m_iJuice" ) < GetConVar( "sk_suitcharger_citadel" ):GetFloat() then
				ent:Remove()
				self:Fire( "Recharge", "", 0 )
			end
		end,
		
		------------------------------------------------------------ OnNPCEmitSound - This function runs whenever NPC emits any sounds (no scripted sequences).
		['OnNPCEmitSound'] = function(self, data) -- SHARED ( CLIENT & SERVER )
			if data['SoundName'] == "items/suitchargeok1.wav" && ANPlusPercentageChance( 3 ) then
				self.m_bFireThatEEgg = true
			end
			if self.m_bFireThatEEgg then
				if data['SoundName'] == "items/suitchargeok1.wav" then data['SoundName'] = "anp/suitcharger_egg/suitchargeok1.wav" end			
				if data['SoundName'] == "items/suitcharge1.wav" then data['SoundName'] = "anp/suitcharger_egg/suitcharge1.wav" end
				return true
			end
		end,
		
		------------------------------------------------------------ OnNPCRemove - This function runs whenever NPC gets removed.
		['OnNPCRemove'] = function(self)	
			self:StopSound( "anp/suitcharger_egg/suitchargeok1.wav" )
			self:StopSound( "anp/suitcharger_egg/suitcharge1.wav" )
		end,
		
		},
	
	}  
 
----------------------------------------------------------------- This bit of code here makes sure that your NPC will get added to the global table. Remember to update table name. You can have multiple tables in a single lua file.
ANPlus.AddNPC( ENTTab, "SpawnableEntities" )

local hitboxTranslate = {
	[0] = "Generic",
	[1] = "Head",
	[2] = "Chest",
	[3] = "Stomach",
	[4] = "Left Arm",
	[5] = "Right Arm",
	[6] = "Left Leg",
	[7] = "Right Leg",
	[8] = "Gear",
}

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC. 
	['Category'] 			= "[ANP] Dev",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "[ANP] Test Dummy",               
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 				= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/breen.mdl", 
			['BodyGroups'] = nil, 
			['Skin'] 		 = nil,			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "models/debug/debugwhite",				-- This value will set a new material for your NPC with this model applied. 
			['SubMaterials'] = nil,
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['BloodColor']	 = 3,	-- Set blood color. https://wiki.facepunch.com/gmod/Enums/BLOOD_COLOR
			['BoneEdit']	 = nil, 
			['Scale']					= { 100, 0 }, --% scale and delta time.
			['CollisionBounds']	= {	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL           
			},
			['PhysicsInit'] = false,
		},
		---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 				= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 				= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 				= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 					= nil,
----------------------------------------------------------------- Rotates NPC after spawn. (eg. ['Rotate'] = Angle( 0, 180, 0 ))
	['Rotate']					= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 					= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 					= 999999999,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 			= nil, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 				= {},
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 				= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 		= nil,    
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 			= {},
----------------------------------------------------------------- Set if your NPC should be allowed to spawn only with default weapons.	
	['ForceDefaultWeapons']		= true, 
----------------------------------------------------------------- If a weapon from the ['DefaultWeapons'] is not valid, a weapon from this table will be issued instead (mind the order and make sure that amount of vaules in both tables are equal).
	['ReplacementWeapons'] 		= nil, 
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 			= 1,   
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType https://wiki.facepunch.com/gmod/Hold_Types . Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil, ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },

	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 		= nil,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 		= 1,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 		= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 		= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 0, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. The lowest value is -100% (no damage) and it can go as high as you wish (be reasonable).
		['Head'] 	 = 0, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.         
		['Stomach']  = 0, --%, 0 is default. 
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		
	}, 
----------------------------------------------------------------- This table can be used to specify how our NPC should react to other NPCs and vice versa. ['MeToNPC'] sets how our NPC should react to the other NPC. ['NPCToMe'] sets how other NPC should react to ours. The first value sets the relation and the second one sets its strength. If you plan to use this table, make sure that ['Default'] is present inside as it will tell NPCs that are not present in here what to do. You can use NPC classes (npc_citizen) or ANP IDs/Names.
	['Relations'] = { 
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, -- "Hate" / "Like" / "Fear" / "Neutral"   
		[1] = { ['MeToNPC'] = { "Hate", 0 } },
 
	},  	
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
	['ActivityOther'] 			= nil,
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities. You can also change the movement speed at specified activities.
	['ActivityMovement'] 		= nil,
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] 		= nil,
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- Player is valid only when PlayerSpawnedNPC gets called.
			self:SetNoDraw( false )
			if (CLIENT) then return end
			self:ANPMuteSound( true )   
			
		end,			
		------------------------------------------------------------ OnNPCThink - This function runs almost every frame.
		['OnNPCThink'] = function(self)     
			if (CLIENT) then return end
			self:StopMoving()
		end,					
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
			local dmg = dmginfo:GetDamage()
			local dmgPos = dmginfo:GetDamagePosition()
			self:SetNWFloat( "ANP_TestDummyDamage", dmg )
			debugoverlay.Cross( dmgPos, 1, 1, Color( 255, 50, 50 ), true )
			dmginfo:SetDamage( 0 )
		end,		
		------------------------------------------------------------ OnNPCScaleDamage - This function runs whenever NPC gets damaged. Can also be used to detect which body part was hit.
		['OnNPCScaleDamage'] = function(self, hitgroup, dmginfo)	
			self:SetNWFloat( "ANP_TestDummyHitBox", hitgroup )    
		end,							
		------------------------------------------------------------ OnNPCHUDPaint - This function can be used to display stuff on Player's screen.
		['OnNPCHUDPaint'] = function(self)	
			local ply = LocalPlayer()
			if self:ANPlusInRange( ply, 1024 ) then
				local vpos = self:GetPos() + Vector(0,0,self:BoundingRadius()*1.85)
				local vpos2 = self:GetPos() + Vector(0,0,self:BoundingRadius()*2)
				local vinfopos = vpos:ToScreen()
				local vinfopos2 = vpos2:ToScreen()
				local text = "Damage: " .. ( self:GetNWFloat( "ANP_TestDummyDamage" ) || 0 ) .. " | HitGroup: " .. ( hitboxTranslate[ self:GetNWFloat( "ANP_TestDummyHitBox" ) ] || "None" )
				draw.SimpleTextOutlined( text, "Trebuchet18", vinfopos.x, vinfopos.y, self:GetColor(), 1, 1, 1, Color( 0, 0, 0, 255 ) )  
			end
		end,
	},
} ) 	

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Humans + Resistance",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "Mega Odessa Cubbage",   
----------------------------------------------------------------- Entity class of your NPC aka base NPC       
	['Class'] 				= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/odessa.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomised between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
			}, 
			['Skin'] 		 = { 0, 0 },			-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { -- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 255, 255, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha. 
			['Scale']					= { 100, 0 }, --% scale and delta time.
			['CollisionBounds']	= {	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL           
			},
		},
			---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false, 
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= nil,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 400,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { true, 1, 10 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { citizentype = CT_REBEL, DontPickupWeapons = "true", SquadName = "resistance" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	},    
	--['InputsAndOutputs'] 	= { {"kill", "", 1} },  
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_crossbow" },
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 20000,   
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType https://wiki.facepunch.com/gmod/Hold_Types . Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { 
			['Proficiency'] = 1, -- Weapon accuracy https://wiki.facepunch.com/gmod/Enums/WEAPON_PROFICIENCY
			['PrimaryMinRange'] = nil,  -- Minimum range at which our NPC can use this weapon's primary fire. Set to "nil" to keep the weapon's default values.
			['SecondaryMinRange'] = nil,  -- Minimum range at which our NPC can use this weapon's secondary fire. Set to "nil" to keep the weapon's default values. (Usually NPCs don't use secondary fire modes)
			['PrimaryMaxRange'] = nil,  -- Maximum range at which our NPC can use this weapon's primary fire. Set to "nil" to keep the weapon's default values.
			['SecondaryMaxRange'] = nil  -- Maximum range at which our NPC can use this weapon's secondary fire. Set to "nil" to keep the weapon's default values. (Usually NPCs don't use secondary fire modes)
		},
		
		['weapon_rpg'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = 20000 },
		['weapon_crossbow'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = nil },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 8 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 300, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. The lowest value is -100% (no damage) and it can go as high as you wish (be reasonable).
		['Head'] 	 = -50, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default. 
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= -100, --%,
		[DMG_POISON]	= -100, --%,
		[DMG_RADIATION]	= -30, --%,
		[DMG_ACID]		= -50, --%,
		[DMG_POISON]	= -50, --%, 
		
	}, 
----------------------------------------------------------------- Set if your NPC should be friendly to players. true = Yes / false = No / nil = default to the NPC
	['PlayerAlly'] 			= nil,
----------------------------------------------------------------- This table can be used to specify how our NPC should react to other NPCs and vice versa. ['MeToNPC'] sets how our NPC should react to the other NPC. ['NPCToMe'] sets how other NPC should react to ours. The first value sets the relation and the second one sets its strength. If you plan to use this table, make sure that ['Default'] is present inside as it will tell NPCs that are not present in here what to do. You can use NPC classes (npc_citizen) or ANP IDs/Names.
--[[
	['Relations'] = { 
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, -- "Hate" / "Like" / "Fear" / "Neutral"     
		
		[1] = { ['MeToNPC'] = { "Default", 0 } },
		
		['npc_combine_s'] = { ['MeToNPC'] = { "Like", 0 }, ['NPCToMe'] = { "Like", 0 } },
		
		['Other ANPlus NPC ID/Name'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Like", 0 } },
	},
--]]
	['Relations'] = nil, 	
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[	
	['ActivityOther'] = {
	
		[ACT_RELOAD] = { 100, { 49, 50 } }, -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
----EXAMPLE /\

	['ActivityOther'] = {
		 
		[ACT_RELOAD]		= { 800 },
		[ACT_RANGE_ATTACK1]	= { 3000 },
		[ACT_RANGE_ATTACK2]	= { 300 },
		
	},
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities. You can also change the movement speed at specified activities.
--[[	
	['ActivityMovement'] = {
	
		[ACT_RUN] = { 100, 100, { 49, 50 } }, -- The first value (100) represents the animation speed in %, the second value (100) represents the movement speed in %, and the third value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
	
	},
--]]
----EXAMPLE /\
	['ActivityMovement'] = {
	
		[ACT_RUN]			= { 200, 900 },     
		[ACT_WALK]			= { 200, 900 },      
		
	},
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
	
		--['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			--['SoundLevel'] = nil, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			--['Pitch'] = nil, -- Also can be randomised,
			--['Channel'] = CHAN_VOICE, 
			--['Volume'] = { 0.3 }, -- Same.
			--['Flags'] = 1024, 
			--['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }
			}, 
			[2] = {"vo/npc/male01/ahgordon", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[3] = {"vo/npc/male01/docfreeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[4] = {"vo/npc/male01/freeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[5] = {"vo/npc/male01/hellodrfm", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[6] = {"vo/npc/male01/heydoc", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[7] = {"vo/npc/male01/hi", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			
			[8] = {"vo/npc/male01/evenodds", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[9] = {"vo/npc/male01/nice", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[10] = {"vo/npc/male01/oneforme", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[11] = {"vo/npc/male01/thislldonicely", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[12] = {"vo/npc/male01/yeah", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[13] = {"vo/npc/male01/finally", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[14] = {"vo/npc/male01/fantastic", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			
			[13] = {"vo/npc/male01/gotone", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[14] = {"vo/npc/male01/likethat", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[15] = {"vo/episode_1/npc/male01/cit_kill", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			
			[16] = {"vo/npc/male01/civilprotection", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[17] = {"vo/npc/male01/combine", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[18] = {"vo/npc/male01/cps", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[19] = {"vo/npc/male01/hacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[20] = {"vo/npc/male01/headcrabs", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[21] = {"vo/npc/male01/herecomehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[22] = {"vo/npc/male01/heretheycome", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[23] = {"vo/npc/male01/incoming", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[24] = {"vo/npc/male01/itsamanhack", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[25] = {"vo/npc/male01/scanners", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[26] = {"vo/npc/male01/strider", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[27] = {"vo/npc/male01/thehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[28] = {"vo/npc/male01/zombies", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 

		},
		
	}, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
--[[
	['RemoveOrReplaceOnDeath'] = {
		
		['SERVER'] = {
			[1] = {"raggib", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"}, -- The first vaule is for the entity class, the second is for it's default model, and the third one is for model the new model.
		},  
		['CLIENT'] = {
			[1] = {"class C_ClientRagdoll", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"},
		},  
        
	}, 
]]--
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {		
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- Player is valid only when PlayerSpawnedNPC gets called.
			if (CLIENT) then return end
			if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():SetClip1( 9999 ) end
			
			self.anp_HealLast = 0
			self.anp_HealDelay = 3
		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)

			activator:SetHealth( 200 )
			self:EmitSound( "vo/npc/male01/health05.wav", 75, 50, 1, CHAN_VOICE, 0, 0 )
			self:ANPlusPlayActivity( self:ANPlusTranslateSequence("heal"), 1, false, activator, 4 )   
		
		end,		
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )	
			if (SERVER) && ent:GetClass() == "crossbow_bolt" then 
				
				ent:SetVelocity( ent:GetForward() * 1200 )
				ent.trail = ents.Create("env_rockettrail")
				ent.trail:SetPos( ent:GetPos() + ent:GetForward() * 16 )
				ent.trail:SetParent( ent )
				ent.trail:SetOwner( ent )
				ent.trail:SetLocalAngles( Angle( 0, 0, 0 ) )
				ent.trail:SetKeyValue( "scale", "1" )
				ent.trail:SetSaveValue( "m_SpawnRate", 100 )
				ent.trail:SetSaveValue( "m_ParticleLifetime", 1 )
				--ent.trail:SetSaveValue( "m_StartColor.Init( 0.65f, 0.65f , 0.65f );
				--ent.trail:SetSaveValue( "m_EndColor.Init( 0.0, 0.0, 0.0 );
				ent.trail:SetSaveValue( "m_StartSize", 6 )
				ent.trail:SetSaveValue( "m_EndSize", 32 )
				ent.trail:SetSaveValue( "m_SpawnRadius", 4 )
				ent.trail:SetSaveValue( "m_MinSpeed", 2 )
				ent.trail:SetSaveValue( "m_MaxSpeed", 16 )
				ent.trail:Spawn()
			
			end
		
		end,			
		------------------------------------------------------------ OnNPCTakeDamage - This function runs whenever NPC gets damaged.
		['OnNPCTakeDamage'] = function(self, dmginfo)
			
			local attacker = dmginfo:GetAttacker()
			
			if IsValid(attacker) and ( attacker:IsNPC() or attacker:IsPlayer() ) and attacker != self and self:Disposition( attacker ) != D_HT then   

				self:AddEntityRelationship( attacker, D_HT, 99 )
				self:SetEnemy( attacker )
			
			end
		
		end,	
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(self, npc, hitgroup, dmginfo)		
			npc:Ignite(2,2)	
		end,		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(self, ply, hitgroup, dmginfo)			
			ply:Ignite(2,2)		
		end,		
	},
	
} ) 

ANPlus.AddNPC( {
----------------------------------------------------------------- Category at which you'll be able to find your NPC.
	['Category'] 			= "Humans + Resistance",
----------------------------------------------------------------- Name of your NPC, it also works as an identifier in the base. Make sure that it is unique. If you wish to make a spawnicon, name it after this value.
	['Name'] 				= "Mega Angry Odessa Cubbage",
----------------------------------------------------------------- Entity class of your NPC aka base NPC	
	['Class'] 				= "npc_citizen",
----------------------------------------------------------------- Table with models. Each model can have different body groups, material, color, and skin.	
	['Models'] = {
		--- 
		{ "models/odessa.mdl", 
			['BodyGroups'] = { 					-- Table with body groups that you wish to change.
				[1] = { 0, 1 },					-- This table represents body group 1 and its value will be randomised between 0 and 1. In this case, our model has no body groups so this does nothing xd.
				[2] = { 0, 7 },					-- You can add as many as you wish.
				[3] = nil,	 					-- While the table must go in order from 1 up. You can "skip" a body group by setting it to "nil".
				[4] = { 1, 3 },
			}, 
			['Skin'] 		 = { 0, 0 },		-- This table represents skin of this model. In this case, it will be randomized between 0 and 2.
			['Material']	 = "",				-- This value will set a new material for your NPC with this model applied.
			['SubMaterials'] = { 				-- Table with sub materials to set on your NPC. You can put as many replacements as you wish. The table must go in order from 1 up. You can "skip" a sub material by leaving the table empty "{}".
				[1] = "",    
				[2] = "",    
				[3] = { "squad/orangebox", "metal6", "rubber" }, -- One of these 3 will be chosen randomly.    
			},
			['Color']		 = Color( 255, 0, 0, 255 ),	-- This table will change the color of your NPC with this model applied. Red Green Blue Alpha.
			['Scale']					= { 100, 0 }, --% scale and delta time.
			['CollisionBounds']	= {	
				['Min']				= Vector( -13, -13, 0 ), -- Mins of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['Max']				= Vector( 13, 13, 72 ),  -- Maxs of collision bounds. For a human sized NPC (npc_citizen or npc_combine_s for an example).
				['HullType']		= 0,					-- Hull type. https://wiki.facepunch.com/gmod/Enums/HULL           
			},
		},
			---   
	},
----------------------------------------------------------------- Sets if NPC should only be spawnable by admins. 
	['AdminOnly'] 			= false, 
----------------------------------------------------------------- Sets if NPC should only be spawnable on the ceiling.
	['OnCeiling'] 			= false,
----------------------------------------------------------------- Sets if NPC should only be spawnable on the floor.
	['OnFloor'] 			= false,
----------------------------------------------------------------- Position offset from the crosshair.
	['Offset'] 				= 0,
----------------------------------------------------------------- Set if your NPC should drop to the floor on spawn (seems to be only working on NPCs that do not posses any physics).
	['NoDrop'] 				= false, 
----------------------------------------------------------------- NPC health and max health.	
	['Health'] 				= 400,
----------------------------------------------------------------- The first variable sets if NPC should regenerate health only when out of combat, the second variable represents the delay between health gains, the third variable represents the health of each gain.	
	['HealthRegen'] 		= { true, 1, 10 }, 
----------------------------------------------------------------- KeyValues to give your NPC. Refer to Valve's wiki for more information.	
	['KeyValues'] 			= { citizentype = CT_REBEL, DontPickupWeapons = "true", SquadName = "omegadessa" },
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['SpawnFlags'] 			= 0, 
----------------------------------------------------------------- Spawnflags to give your NPC. Refer to Valve's wiki for more information. If you wish to add more, just do it like this: 256 + 1024 + etc.
	['InputsAndOutputs'] 	= { -- string input, string param = "nil", number delay = 0, Entity activator = nil, Entity caller = nil
	
	},    
	--['InputsAndOutputs'] 	= {"kill", true}, 
----------------------------------------------------------------- Default weapons for your NPC.
	['DefaultWeapons'] 		= { "weapon_crossbow" },
----------------------------------------------------------------- Set a distance at which your NPC will be able to spot enemies.	
	['LookDistance'] 		= 20000,   
----------------------------------------------------------------- Set how well your NPC should handle certain weapons. You can either specify a certain weapon by its Class or HoldType "https://wiki.facepunch.com/gmod/Hold_Types". Default refers to weapons that do not meet the Class or HoldType requirement.	 
	['WeaponProficiencyTab'] 	= {
	
		['Default']	= { ['Proficiency'] = 1, ['PrimaryMinRange'] = nil,  ['SecondaryMinRange'] = nil, ['PrimaryMaxRange'] = nil, ['SecondaryMaxRange'] = nil },
		
		['weapon_crossbow'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = nil },
		['weapon_rpg'] = { ['Proficiency'] = 4, ['PrimaryMinRange'] = 0,  ['SecondaryMinRange'] = 0, ['PrimaryMaxRange'] = 20000, ['SecondaryMaxRange'] = 20000 },
		
	},
----------------------------------------------------------------- Capabilities that should be added to your NPC. They should be added like this: 24 + 54 + 256 + etc. https://wiki.facepunch.com/gmod/Enums/CAP
	['AddCapabilities'] 	= 2 + 8 + 67108864,
----------------------------------------------------------------- Capabilities that should be removed from your NPC. https://wiki.facepunch.com/gmod/Enums/CAP	
	['RemoveCapabilities'] 	= 0,
----------------------------------------------------------------- Enables or disables the inverse kinematic usage of this NPC.	
	['EnableInverseKinematic'] 	= true,
----------------------------------------------------------------- Allow or disable PhysGun pickup on your NPC. If set to false, it will disable all PhysGun-related functions!	
	['AllowPhysgunPickup'] 	= true, 
----------------------------------------------------------------- Allow or disallow GravGun pickup on your NPC. Might not work on all NPCs. If set to false, it will disable all GravGun-related functions!	
	['AllowGravGunPickUp'] 	= false,
----------------------------------------------------------------- Increase or decrease your NPC's damage output. The lowest is -100 (%) and it can go as high as you wish (be reasonable).
	['DamageDealtScale'] 		= 300, --%, 0 is default.
----------------------------------------------------------------- This table allows you to increase or decrease NPC's resistances based on body part hit or damage type.	
	['DamageTakenScale'] = {
		  
		---------- Body parts
		
		['Body'] 	 = 0, --%, 0 is default. The lowest value is -100% (no damage) and it can go as high as you wish (be reasonable).
		['Head'] 	 = -50, --%, 0 is default.
		['Chest'] 	 = 0, --%, 0 is default.
		['Stomach']  = 0, --%, 0 is default.
		['LeftArm']  = 0, --%, 0 is default.
		['RightArm'] = 0, --%, 0 is default.
		['LeftLeg']  = 0, --%, 0 is default.
		['RightLeg'] = 0, --%, 0 is default.  
		
		---------- Damage Types
		
		[DMG_NERVEGAS]	= -100, --%,
		[DMG_POISON]	= -100, --%,
		[DMG_RADIATION]	= -30, --%,
		[DMG_ACID]		= -50, --%,
		[DMG_POISON]	= -50, --%,  
		
	}, 
----------------------------------------------------------------- This table can be used to specify how our NPC should react to other NPCs and vice versa. ['MeToNPC'] sets how our NPC should react to the other NPC. ['NPCToMe'] sets how other NPC should react to ours. First value sets the relation and the second one sets its strength. If you plan to use this table, make sure that ['Default'] is present inside as it will tell NPCs that are not present in here what to do.
	['Relations'] = { 
	
		['Default'] = { ['MeToNPC'] = { "Hate", 0 }, ['NPCToMe'] = { "Hate", 0 } }, -- "Hate" / "Like" / "Fear" / "Neutral"   
		[1] = { ['MeToNPC'] = { "Hate", 0 } },		

	},    
----------------------------------------------------------------- Increase the speed of certain actions/activities of your NPC or replace them.	Do NOT use movement activities here!
--[[	
	['ActivityOther'] = {
		[ACT_RELOAD]		= {
		
		{ 100, { 49, 50 } } -- The first value (100) represents speed in %, the second value (table) contains replacement activities. You can either use numbers or ACT_NAMEs. If you simply wish to only change the current activity speed, remove the table with the replacements ( { 100, { 49, 50 } } --> { 100 } ).
		
		}, 
	},
--]]
----EXAMPLE /\

	['ActivityOther'] = {
		 
		[ACT_RELOAD]		= { 800 },
		[ACT_RANGE_ATTACK1]	= { 3000 },
		[ACT_RANGE_ATTACK2]	= { 300 },
		
	},
----------------------------------------------------------------- Similar to ActivityOther but only for movement activities.	
	['ActivityMovement'] = {
	
		[ACT_RUN]			= { 200, 9000 },        
		[ACT_WALK]			= { 200, 9000 },  
		
	},
----------------------------------------------------------------- This table lets you override/edit sounds made by your NPC.	
	['SoundModification'] = {
	
		--['OverPitch'] 			= { 90, 110 }, -- Pitch override for realistic random voices.
		['SoundList'] = {
			[1] = {"*vo/npc/male01/abouttime", -- Sound that we want to edit/replace. If you use only a part of sound path like here (normally it would look something like this vo/npc/male01/abouttime01.wav), all sounds with similar names/paths will be edited like this. It saves some time.
			--['SoundLevel'] = nil, -- Or sound range, can be randomized ['SoundLevel'] = { min, max } or specified ['SoundLevel'] = { val }
			--['Pitch'] = nil, -- Also can be randomised,
			--['Channel'] = CHAN_VOICE, 
			--['Volume'] = { 0.3 }, -- Same.
			--['Flags'] = 1024, 
			--['DSP'] = 38, 
			['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" } 
			}, 
			[2] = {"vo/npc/male01/ahgordon", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[3] = {"vo/npc/male01/docfreeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[4] = {"vo/npc/male01/freeman", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[5] = {"vo/npc/male01/hellodrfm", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[6] = {"vo/npc/male01/heydoc", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			[7] = {"vo/npc/male01/hi", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_freeman.wav", "vo/coast/odessa/nlo_cub_service.wav", "vo/coast/odessa/nlo_cub_volunteer.wav" }}, 
			
			[8] = {"vo/npc/male01/evenodds", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[9] = {"vo/npc/male01/nice", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[10] = {"vo/npc/male01/oneforme", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[11] = {"vo/npc/male01/thislldonicely", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[12] = {"vo/npc/male01/yeah", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[13] = {"vo/npc/male01/finally", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			[14] = {"vo/npc/male01/fantastic", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_carry.wav", "vo/coast/odessa/nlo_cub_class01.wav", "vo/coast/odessa/nlo_cub_class02.wav", "vo/coast/odessa/nlo_cub_class03.wav" }}, 
			
			[13] = {"vo/npc/male01/gotone", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[14] = {"vo/npc/male01/likethat", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			[15] = {"vo/episode_1/npc/male01/cit_kill", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_thatsthat.wav", "vo/coast/odessa/nlo_cub_ledtobelieve.wav" }}, 
			
			[16] = {"vo/npc/male01/civilprotection", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[17] = {"vo/npc/male01/combine", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[18] = {"vo/npc/male01/cps", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[19] = {"vo/npc/male01/hacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[20] = {"vo/npc/male01/headcrabs", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[21] = {"vo/npc/male01/herecomehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[22] = {"vo/npc/male01/heretheycome", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[23] = {"vo/npc/male01/incoming", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[24] = {"vo/npc/male01/itsamanhack", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[25] = {"vo/npc/male01/scanners", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[26] = {"vo/npc/male01/strider", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[27] = {"vo/npc/male01/thehacks", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 
			[28] = {"vo/npc/male01/zombies", ['SoundLevel'] = nil, ['Pitch'] = nil, ['Channel'] = nil, ['Volume'] = nil, ['Flags'] = nil, ['DSP'] = nil, ['Replacement'] = { "vo/coast/odessa/nlo_cub_corkscrew.wav", "vo/coast/odessa/nlo_cub_teachgunship.wav", "vo/coast/odessa/nlo_cub_youllmakeit.wav" }}, 

		},
		
	}, 
----------------------------------------------------------------- This table can be used to remove/replace gibs, body parts, or NPCs like headcrabs.
--[[
	['RemoveOrReplaceOnDeath'] = {
		
		['SERVER'] = {
			[1] = {"raggib", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"}, -- The first vaule is for the entity class, the second is for it's default model, and the third one is for model the new model.
		},  
		['CLIENT'] = {
			[1] = {"class C_ClientRagdoll", "models/zombie/classic_torso.mdl", "models/zombie/feclassic.mdl"},
		},  
        
	}, 
]]--
----------------------------------------------------------------- Custom functions.	An order doesn't matter. They are based on hooks.
	['Functions'] = {	
		------------------------------------------------------------ OnNPCSpawn - This function runs on NPC spawn/dupe placement/save load.
		['OnNPCSpawn'] = function(self, ply) -- Player is valid only when PlayerSpawnedNPC gets called.
			if (CLIENT) then return end
			if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():SetClip1( 9999 ) end
			
			--self:Ignite( 9999, 0 )
			
			self.anp_HealLast = 0
			self.anp_HealDelay = 3   
			
			self:SetSaveValue( "m_bRPGAvoidPlayer", false )
		
		end,		
		------------------------------------------------------------ OnNPCUse - This function runs every frame when the player presses its "Use" key on our NPC.
		['OnNPCUse'] = function(self, activator, caller, type)
			
			activator:TakeDamage( 999, self, self )
			self:EmitSound( "vo/npc/male01/yeah02.wav", 75, 50, 1, CHAN_VOICE, 0, 0 )
			self:ANPlusPlayActivity( self:ANPlusTranslateSequence("heal"), 1, false, activator, 4 )   
		
		end,
		------------------------------------------------------------ OnNPCCreateEntity - This function runs whenever this NPC spawns/creates (server side) something (like combine throwing a grenade).
		['OnNPCCreateEntity'] = function(self, ent)	-- SHARED ( CLIENT & SERVER )
		
			if (SERVER) && ent:GetClass() == "crossbow_bolt" then
				
				ent:SetVelocity( ent:GetForward() * 1200 )
				ent.trail = ents.Create("env_rockettrail")
				ent.trail:SetPos( ent:GetPos() + ent:GetForward() * 16 )
				ent.trail:SetParent( ent )
				ent.trail:SetOwner( ent )
				ent.trail:SetLocalAngles( Angle( 0, 0, 0 ) )
				ent.trail:SetKeyValue( "scale", "1" )
				ent.trail:SetSaveValue( "m_SpawnRate", 100 )
				ent.trail:SetSaveValue( "m_ParticleLifetime", 1 )
				--ent.trail:SetSaveValue( "m_StartColor.Init( 0.65f, 0.65f , 0.65f );
				--ent.trail:SetSaveValue( "m_EndColor.Init( 0.0, 0.0, 0.0 );
				ent.trail:SetSaveValue( "m_StartSize", 6 )
				ent.trail:SetSaveValue( "m_EndSize", 32 )
				ent.trail:SetSaveValue( "m_SpawnRadius", 4 )
				ent.trail:SetSaveValue( "m_MinSpeed", 2 )
				ent.trail:SetSaveValue( "m_MaxSpeed", 16 )
				ent.trail:Spawn()
			
			end
		
		end,	
		------------------------------------------------------------ OnNPCScaleDamage - This function runs whenever NPC gets damaged. Can also be used to detect which body part was hit.
		['OnNPCScaleDamage'] = function(self, hitgroup, dmginfo)	
			end,		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages other NPCs.
		['OnNPCScaleDamageOnNPC'] = function(self, npc, hitgroup, dmginfo)			
			npc:Ignite(2,2)		
		end,		
		------------------------------------------------------------ OnNPCScaleDamageOnNPC - This function runs whenever NPC damages Players.
		['OnNPCScaleDamageOnPlayer'] = function(self, ply, hitgroup, dmginfo)			
			ply:Ignite(2,2)	
		end,	
	},	
	
} )
