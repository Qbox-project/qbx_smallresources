Config = {}
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0
Config.DamageNeeded = 100.0
Config.IdleCamera = true
Config.EnableProne = true
Config.JointEffectTime = 60
Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25
Config.DisableAmbience = false -- Disabled distance sirens, distance car alarms, etc
Config.TimeUntilAFKKick = 1800 -- The amount of seconds it takes for you to stand AFK and get kicked

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
    ['scenario'] = 0.8,
}

---@meta
---@class anim
---@field clip string
---@field dict string
---@field flag number

---@meta
---@class prop
---@field model string
---@field bone number
---@field pos vector3
---@field rot vector3

---@meta
---@class stressRelief
---@field min number
---@field max number

---@meta
---@class consumeables
---@field min number
---@field max number
---@field anim anim?
---@field prop table?
---@field stressRelief table?

---@class ConsumablesEat : consumeables

---@type ConsumablesEat
ConsumablesEat = {
    ['sandwich'] = {
        min = 35,
        max = 54,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
    ['tosti'] = {
        min = 40,
        max = 50,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
    ['twerks_candy'] = {
        min = 35,
        max = 54,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
    ['snikkel_candy'] = {
        min = 40,
        max = 50,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
}

---@class ConsumablesDrink : consumeables

---@type ConsumablesDrink
ConsumablesDrink = {
    ['water_bottle'] = {
        min = 35,
        max = 54,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
    ['kurkakola'] = {
        min = 35,
        max = 54,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
    ['coffee'] = {
        min = 40,
        max = 50,
        anim = {
            clip = 'idle_c',
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            flag = 49
        },
        prop = {
            model = 'p_amb_coffeecup_01',
            bone = 28422,
            pos = {x = 0.0, y = 0.0, z = 0.0},
            rot = {x = 0.0, y = 0.0, z = 0.0}
        },
        stressRelief = {
            min = -10,
            max = -1
        },
    },
}

---@class ConsumablesAlcohol : consumeables
    ---@field alcoholLevel? number

---@type ConsumablesAlcohol
ConsumablesAlcohol = {
    ['whiskey'] = {
        min = 20,
        max = 30,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
    ['beer'] = {
        min = 30,
        max = 40,
        stressRelief = {
            min = 1,
            max = 4
        },
        alcoholLevel = 0.25
    },
    ['vodka'] = {
        min = 20,
        max = 40,
        stressRelief = {
            min = 1,
            max = 4
        },
    },
}

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        -- "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
    },
    ['SUPPRESSED'] = {
        "SHAMAL",
        "LUXOR",
        "LUXOR2",
        "LAZER",
        "TITAN",
        "CRUSADER",
        "RHINO",
        "AIRTUG",
        "RIPLEY",
        "SUNTRAP",
	"BLIMP",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

-- these vehicles will always be deleted once anything tries to create them.
Config.BlacklistedVehs = {
    [`SHAMAL`] = true,
    [`LUXOR`] = true,
    [`LUXOR2`] = true,
    [`JET`] = true,
    [`LAZER`] = true,
    [`BUZZARD`] = true,
    [`BUZZARD2`] = true,
    [`ANNIHILATOR`] = true,
    [`SAVAGE`] = true,
    [`TITAN`] = true,
    [`RHINO`] = true,
    [`FIRETRUK`] = true,
    [`MULE`] = true,
    [`MAVERICK`] = true,
    [`BLIMP`] = true,
    [`AIRTUG`] = true,
    [`CAMPER`] = true,
    [`HYDRA`] = true,
    [`OPPRESSOR`] = true,
    [`technical3`] = true,
    [`insurgent3`] = true,
    [`apc`] = true,
    [`tampa3`] = true,
    [`trailersmall2`] = true,
    [`halftrack`] = true,
    [`hunter`] = true,
    [`vigilante`] = true,
    [`akula`] = true,
    [`barrage`] = true,
    [`khanjali`] = true,
    [`caracara`] = true,
    [`blimp3`] = true,
    [`menacer`] = true,
    [`oppressor2`] = true,
    [`scramjet`] = true,
    [`strikeforce`] = true,
    [`cerberus`] = true,
    [`cerberus2`] = true,
    [`cerberus3`] = true,
    [`scarab`] = true,
    [`scarab2`] = true,
    [`scarab3`] = true,
    [`rrocket`] = true,
    [`ruiner2`] = true,
    [`deluxo`] = true,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

Config.Teleports = {
    --Elevator @ labs
    [1] = {
        [1] = {
            coords = vector4(3540.74, 3675.59, 20.99, 167.5),
            ['AllowVehicle'] = false,
            drawText = '[E] Take Elevator Up'
        },
        [2] = {
            coords = vector4(3540.74, 3675.59, 28.11, 172.5),
            ['AllowVehicle'] = false,
            drawText = '[E] Take Elevator Down'
        },

    },
    --Coke Processing Enter/Exit
    [2] = {
        [1] = {
            coords = vector4(909.49, -1589.22, 30.51, 92.24),
            ['AllowVehicle'] = false,
            drawText = '[E] Enter Coke Processing'
        },
        [2] = {
            coords = vector4(1088.81, -3187.57, -38.99, 181.7),
            ['AllowVehicle'] = false,
            drawText = '[E] Leave'
        },
    },
}
