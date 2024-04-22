return {
    disable = {
        -- Disables the Idle Cinematic Camera
        idleCamera = true,

        -- Disabled distance sirens, distance car alarms, etc
        ambience = true,

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
