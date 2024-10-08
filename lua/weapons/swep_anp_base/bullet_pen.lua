

SWEP.BulletPenTab = {
	['AR2'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 11, 0.35 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 6, 0.4 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 4.5, 0.65 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 6.5, 0.15 }, -- All glass
		[MAT_PLASTIC] = { 10, 0.2 }, -- Plastic
		[MAT_METAL] = { 3, 0.8 }, -- All sorts of metals
		[MAT_DIRT] = { 11, 0.4 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 12, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 20, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['Pistol'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 6, 0.5 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 3, 0.6 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 2.5, 0.8 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 3, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 6, 0.3 }, -- Plastic
		[MAT_METAL] = { 1.5, 0.9 }, -- All sorts of metals
		[MAT_DIRT] = { 8, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 10, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 18, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['SMG1'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 7, 0.5 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 4, 0.6 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 3, 0.8 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 5, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 8, 0.3 }, -- Plastic
		[MAT_METAL] = { 2, 0.9 }, -- All sorts of metals
		[MAT_DIRT] = { 9, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 12, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 20, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['357'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 14, 0.35 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 8, 0.3 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.6 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 10, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 4.5, 0.8 }, -- All sorts of metals	
		[MAT_DIRT] = { 14, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 17, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 27, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['Buckshot'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 4, 0.8 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 3, 0.8 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 2, 0.9 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 3, 0.6 }, -- All glass
		[MAT_PLASTIC] = { 5, 0.9 }, -- Plastic
		[MAT_METAL] = { 0.4, 0.95 }, -- All sorts of metals
		[MAT_DIRT] = { 5, 0.6 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 8, 0.5 }, -- Even softer than dirt
		[MAT_SNOW] = { 15, 0.4 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['AlyxGun'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 7, 0.5 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 4, 0.6 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 3, 0.8 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 5, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 8, 0.3 }, -- Plastic
		[MAT_METAL] = { 2, 0.9 }, -- All sorts of metals
		[MAT_DIRT] = { 9, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 12, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 20, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['SniperRound'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 16, 0.3 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 10, 0.2 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.6 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 12, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 5, 0.8 }, -- All sorts of metals
		[MAT_DIRT] = { 14, 0.3 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 18, 0.3 }, -- Even softer than dirt
		[MAT_SNOW] = { 30, 0.05 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['SniperPenetratedRound'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 16, 0.3 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 10, 0.2 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.6 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 12, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 5, 0.8 }, -- All sorts of metals
		[MAT_DIRT] = { 14, 0.3 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 18, 0.3 }, -- Even softer than dirt
		[MAT_SNOW] = { 30, 0.05 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['AirboatGun'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 10, 0.4 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 7, 0.5 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.65 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 10, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 6, 0.7 }, -- All sorts of metals
		[MAT_DIRT] = { 12, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 16, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 27, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['StriderMinigun'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 10, 0.4 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 7, 0.5 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.65 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 10, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 6, 0.7 }, -- All sorts of metals
		[MAT_DIRT] = { 12, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 16, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 27, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['StriderMinigunDirect'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 10, 0.4 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 7, 0.5 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.65 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 10, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 6, 0.7 }, -- All sorts of metals
		[MAT_DIRT] = { 12, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 16, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 27, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['HelicopterGun'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 10, 0.4 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 7, 0.5 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.65 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 10, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 6, 0.7 }, -- All sorts of metals
		[MAT_DIRT] = { 12, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 16, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 27, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['CombineHeavyCannon'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 20, 0.3 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 15, 0.2 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 9, 0.5 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 16, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 16, 0.3 }, -- Plastic
		[MAT_METAL] = { 9, 0.8 }, -- All sorts of metals
		[MAT_DIRT] = { 18, 0.3 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 24, 0.3 }, -- Even softer than dirt
		[MAT_SNOW] = { 37, 0.05 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['9mmRound'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 6, 0.5 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 3, 0.6 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 2.5, 0.8 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 3, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 6, 0.3 }, -- Plastic
		[MAT_METAL] = { 1.5, 0.9 }, -- All sorts of metals
		[MAT_DIRT] = { 8, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 10, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 18, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['357Round'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 14, 0.35 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 8, 0.3 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 6, 0.6 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 10, 0.3 }, -- All glass
		[MAT_PLASTIC] = { 12, 0.3 }, -- Plastic
		[MAT_METAL] = { 4.5, 0.8 }, -- All sorts of metals	
		[MAT_DIRT] = { 14, 0.5 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 17, 0.4 }, -- Even softer than dirt
		[MAT_SNOW] = { 27, 0.2 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
	['BuckshotHL1'] = { -- A = Penetration in Hammer Units, B = Damage/Penetration reduction by %
		[MAT_FLESH] = { 4, 0.8 }, -- NPCs/Body penetration
		[MAT_WOOD] = { 3, 0.8 }, -- Wooden planks etc
		[MAT_CONCRETE] = { 2, 0.9 }, -- Concrete, rocks etc
		[MAT_GLASS] = { 3, 0.6 }, -- All glass
		[MAT_PLASTIC] = { 5, 0.9 }, -- Plastic
		[MAT_METAL] = { 0.4, 0.95 }, -- All sorts of metals
		[MAT_DIRT] = { 5, 0.6 }, -- Dirt, usually solid ground, usally soft
		[MAT_SAND] = { 8, 0.5 }, -- Even softer than dirt
		[MAT_SNOW] = { 15, 0.4 }, -- EVEN softer than dirt, ice as well?
		---- Just more flesh
		[MAT_ANTLION] = MAT_FLESH, [MAT_BLOODYFLESH] = MAT_FLESH, [MAT_ALIENFLESH] = MAT_FLESH, [MAT_EGGSHELL] = MAT_FLESH,
		---- Metal?
		[MAT_VENT] = MAT_METAL, -- Like metal but vents are usually thin
		---- Same as dirt
		[MAT_FOLIAGE] = MAT_DIRT, [MAT_GRASS] = MAT_DIRT,
		--- Plastic?
		[MAT_COMPUTER] = MAT_PLASTIC,
		---- Same as glass
		[MAT_TILE] = MAT_GLASS,
		---- Specials/Ignore
		[MAT_SLOSH] = { 0, 0 }, [MAT_GRATE] = { 0, 0 }, [MAT_DEFAULT] = { 0, 0 },
	},
}

function ANPlusAddAmmoPenData( ammo, data )
    self.BulletPenTab[ ammo ] = data
end