Config = Config or {}

Config.EnableOxLogging = false -- See https://overextended.github.io/docs/ox_lib/Logger/Server
Config.EnableDiscordLogging = true
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0
Config.DamageNeeded = 100.0
Config.IdleCamera = true
Config.EnableProne = true
Config.JointEffectTime = 60
Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25
Config.DefaultPrice = 20 -- Default price for the carwash
Config.DirtLevel = 0.1 -- Threshold for the dirt level to be counted as dirty
Config.DisableAmbience = false -- Disabled distance sirens, distance car alarms, etc
Config.TimeUntilAFKKick = 999999999999 -- The amount of seconds it takes for you to stand AFK and get kicked

Config.IgnoreGroupsForAFK = { -- The groups to ignore when checking for AFK activity
    ['mod'] = true,
    ['admin'] = true,
    ['god'] = true
}

Config.Disable = {
    disableHudComponents = {1, 2, 3, 4, 7, 9, 13, 14, 19, 20, 21, 22}, -- Hud Components: https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
    disableControls = {37}, -- Controls: https://docs.fivem.net/docs/game-references/controls/
    displayAmmo = true -- false disables ammo display
}

Config.Density = {
    ['parked'] = 0.8,
    ['vehicle'] = 0.8,
    ['multiplier'] = 0.8,
    ['peds'] = 0.8,
    ['scenario'] = 0.8
}

ConsumablesEat = {
    ["sandwich"] = math.random(35, 54),
    ["tosti"] = math.random(40, 50),
    ["twerks_candy"] = math.random(35, 54),
    ["snikkel_candy"] = math.random(40, 50)
}

ConsumablesDrink = {
    ["water_bottle"] = math.random(35, 54),
    ["kurkakola"] = math.random(35, 54),
    ["coffee"] = math.random(40, 50)
}

ConsumablesAlcohol = {
    ["whiskey"] = math.random(20, 30),
    ["beer"] = math.random(30, 40),
    ["vodka"] = math.random(20, 40)
}

ConsumablesFireworks = {
    "firework1",
    "firework2",
    "firework3",
    "firework4"
}

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
        "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE_BIKE"
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        joaat('ng_planes')
    }
}

Config.BlacklistedVehs = {
    [joaat('SHAMAL')] = true,
    [joaat('LUXOR')] = true,
    [joaat('LUXOR2')] = true,
    [joaat('JET')] = true,
    [joaat('LAZER')] = true,
    [joaat('BUZZARD')] = true,
    [joaat('BUZZARD2')] = true,
    [joaat('ANNIHILATOR')] = true,
    [joaat('SAVAGE')] = true,
    [joaat('TITAN')] = true,
    [joaat('RHINO')] = true,
    [joaat('FIRETRUK')] = true,
    [joaat('MULE')] = true,
    [joaat('MAVERICK')] = true,
    [joaat('BLIMP')] = true,
    [joaat('AIRTUG')] = true,
    [joaat('CAMPER')] = true,
    [joaat('HYDRA')] = true,
    [joaat('OPPRESSOR')] = true,
    [joaat('technical3')] = true,
    [joaat('insurgent3')] = true,
    [joaat('apc')] = true,
    [joaat('tampa3')] = true,
    [joaat('trailersmall2')] = true,
    [joaat('halftrack')] = true,
    [joaat('hunter')] = true,
    [joaat('vigilante')] = true,
    [joaat('akula')] = true,
    [joaat('barrage')] = true,
    [joaat('khanjali')] = true,
    [joaat('caracara')] = true,
    [joaat('blimp3')] = true,
    [joaat('menacer')] = true,
    [joaat('oppressor2')] = true,
    [joaat('scramjet')] = true,
    [joaat('strikeforce')] = true,
    [joaat('cerberus')] = true,
    [joaat('cerberus2')] = true,
    [joaat('cerberus3')] = true,
    [joaat('scarab')] = true,
    [joaat('scarab2')] = true,
    [joaat('scarab3')] = true,
    [joaat('rrocket')] = true,
    [joaat('ruiner2')] = true,
    [joaat('deluxo')] = true
}

Config.BlacklistedPeds = {
    [joaat('s_m_y_ranger_01')] = true,
    [joaat('s_m_y_sheriff_01')] = true,
    [joaat('s_m_y_cop_01')] = true,
    [joaat('s_f_y_sheriff_01')] = true,
    [joaat('s_f_y_cop_01')] = true,
    [joaat('s_m_y_hwaycop_01')] = true
}

Config.Teleports = {
    -- Elevator @ labs
    [1] = {
        [1] = {
            coords = vec4(3540.74, 3675.59, 20.99, 167.5),
            AllowVehicle = false,
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vec4(3540.74, 3675.59, 28.11, 172.5),
            AllowVehicle = false,
            drawText = '[E] Take Elevator Down'
        }
    },

    -- Coke Processing Enter/Exit
    [2] = {
        [1] = {
            coords = vec4(909.49, -1589.22, 30.51, 92.24),
            AllowVehicle = false,
            drawText = '[E] Enter Coke Processing'
        },
        [2] = {
            coords = vec4(1088.81, -3187.57, -38.99, 181.7),
            AllowVehicle = false,
            drawText = '[E] Leave'
        }
    }
}

Config.CarWash = { -- carwash
    [1] = {
        label = "Hands Free Carwash",
        coords = vec3(25.29, -1391.96, 29.33)
    },
    [2] = {
        label = "Hands Free Carwash",
        coords = vec3(174.18, -1736.66, 29.35)
    },
    [3] = {
        label = "Hands Free Carwash",
        coords = vec3(-74.56, 6427.87, 31.44)
    },
    [4] = {
        label = "Hands Free Carwash",
        coords = vec3(1363.22, 3592.7, 34.92)
    },
    [5] = {
        label = "Hands Free Carwash",
        coords = vec3(-699.62, -932.7, 19.01)
    }
}