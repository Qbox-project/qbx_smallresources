return {

    -- Damage needed to be able to puch a vehicle
    damageNeeded = 100.0,

    disable = {

        -- Disables the Idle Cinematic Camera
        idleCamera = true,

        -- Disabled distance sirens, distance car alarms, etc
        ambience = true,

        -- https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
        hudComponents = {1, 2, 3, 4, 7, 9, 13, 14, 19, 20, 21, 22},

        -- https://docs.fivem.net/docs/game-references/controls/
        controls = {37},

        -- False disables ammo display
        displayAmmo = true,
    },

    blacklisted = {
        scenarioTypes = {
            'WORLD_VEHICLE_AMBULANCE',
            'WORLD_VEHICLE_FIRE_TRUCK',
            'WORLD_VEHICLE_POLICE_BIKE',
            'WORLD_VEHICLE_POLICE_CAR',
            'WORLD_VEHICLE_POLICE',
            'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
            'WORLD_VEHICLE_SECURITY_CAR',
            'WORLD_VEHICLE_HELI_LIFEGUARD',
            'WORLD_VEHICLE_MILITARY_PLANES_BIG',
            'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
        },

        suppressedModels = {
            'SHAMAL',
            'LUXOR',
            'LUXOR2',
            'JET',
            'LAZER',
            'TITAN',
            'CRUSADER',
            'RHINO',
            'AIRTUG',
            'RIPLEY',
            'BLIMP',
        },

        scenarioGroups = {
            'LSA_Planes',
            'SANDY_PLANES',
            'GRAPESEED_PLANES',
            `ng_planes`,
        },
    },

    teleports = {

        --Elevator @ labs
        [1] = {
            [1] = {
                coords = vec4(3540.74, 3675.59, 20.99, 167.5),
                allowVehicle = false,
                drawText = '[E] Take Elevator Up'
            },
            [2] = {
                coords = vec4(3540.74, 3675.59, 28.11, 172.5),
                allowVehicle = false,
                drawText = '[E] Take Elevator Down'
            },
        },

        --Coke Processing Enter/Exit
        [2] = {
            [1] = {
                coords = vec4(909.49, -1589.22, 30.51, 92.24),
                ['AllowVehicle'] = false,
                drawText = '[E] Enter Coke Processing'
            },
            [2] = {
                coords = vec4(1088.81, -3187.57, -38.99, 181.7),
                ['AllowVehicle'] = false,
                drawText = '[E] Leave'
            },
        },
    }
}
