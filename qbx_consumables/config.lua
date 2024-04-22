return {
    defaultStressRelief = {
        min = 0,
        max = 4
    },
    ---@class anim
    ---@field clip string
    ---@field dict string
    ---@field flag number

    ---@class prop
    ---@field model string
    ---@field bone number
    ---@field pos vector3
    ---@field rot vector3

    ---@class stressRelief
    ---@field min number
    ---@field max number

    ---@class consumable
    ---@field min number
    ---@field max number
    ---@field anim anim?
    ---@field prop table?
    ---@field stressRelief table?

    ---@class consumableAlcohol : consumable
    ---@field alcoholLevel number?

    consumables = {
        ---@type table<string, consumable>
        food = {
            sandwich = {
                min = 35,
                max = 54,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            tosti = {
                min = 40,
                max = 50,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            twerks_candy = {
                min = 35,
                max = 54,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            snikkel_candy = {
                min = 40,
                max = 50,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
        },

        ---@type table<string, consumable>
        drink = {
            water_bottle = {
                min = 35,
                max = 54,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            kurkakola = {
                min = 35,
                max = 54,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            coffee = {
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
        },

        ---@type table<string, consumableAlcohol>
        alcohol = {
            whiskey = {
                min = 20,
                max = 30,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
            beer = {
                min = 30,
                max = 40,
                stressRelief = {
                    min = 1,
                    max = 4
                },
                alcoholLevel = 0.25
            },
            vodka = {
                min = 20,
                max = 40,
                stressRelief = {
                    min = 1,
                    max = 4
                },
            },
        },
    },
}
