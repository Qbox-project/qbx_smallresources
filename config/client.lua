return {
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
}
