Config.ConsumablesEat = {
    ["sandwich"] = {
        label = "Eating Sandwich",
        progress = 5000,
        emote = "sandwich",
        fill = math.random(35, 54),
    },
    ["tosti"] = {
        label = "Eating Tosti",
        progress = 5000,
        emote = "croissant",
        fill = math.random(40, 50),
    },
    ["twerks_candy"] = {
        label = "Eating Twerks Candy",
        progress = 5000,
        emote = "candyapple",
        fill = math.random(35, 54),
    },
    ["snikkel_candy"] = {
        label = "Eating Snikkel Candy",
        progress = 5000,
        emote = "candyapple",
        fill = math.random(40, 50),
    }
}

-- Drinking
Config.ConsumablesDrink = {
    ["water_bottle"] = {
        label = "Drinking Water",
        progress = 5000,
        emote = "water",
        fill = math.random(35, 54),
    },
    ["kurkakola"] = {
        label = "Drinking Kurkakola",
        progress = 5000,
        emote = "soda",
        fill = math.random(35, 54),
    },
    ["coffee"] = {
        label = "Drinking Coffee",
        progress = 5000,
        emote = "coffee",
        fill = math.random(40, 50),
    },
}

Config.ConsumablesAddiction = {

    -- Alcohol

    ["whiskey"] = {
        label = "Drinking Whiskey",
        progress = 5000,
        emote = "whiskeyb2",
        relieveStress = 10,
        filltype = 'thirst',
        fill = math.random(10, 20),
        action = function()
            AlcoholLoop()
        end
    },
    ["beer"] = {
        label = "Drinking Beer",
        progress = 5000,
        emote = "beer3",
        relieveStress = 10,
        filltype = 'thirst',
        fill = math.random(10, 20),
        action = function()
            AlcoholLoop()
        end
    },
    ["vodka"] = {
        label = "Drinking Vodka",
        progress = 5000,
        prop = {
            model = 'prop_vodka_bottle',
            bone = 60309,
            coords = vector3(-0.005, 0.00, -0.09),
            rot = vector3(0.0, 0.0, 0.0),
        },
        anim = {
            lib = "mp_player_intdrink",
            name = "loop_bottle",
            flag = 49,
        },
        relieveStress = 10,
        filltype = 'thirst',
        fill = math.random(10, 20),
        action = function()
            AlcoholLoop()
        end
    },

    --drugs

    ["cokebaggy"] = {
        label = "Snorting Coke",
        progress = 5000,
        anim = {
            lib = "switch@trevor@trev_smoking_meth",
            name = "trev_smoking_meth_loop",
            flag = 49,
        },
        relieveStress = 10,
        action = function()
            local function AlienEffect()
                StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, false)
                Wait(math.random(5000, 8000))
                StartScreenEffect("DrugsMichaelAliensFight", 3.0, false)
                Wait(math.random(5000, 8000))
                StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, false)
                StopScreenEffect("DrugsMichaelAliensFightIn")
                StopScreenEffect("DrugsMichaelAliensFight")
                StopScreenEffect("DrugsMichaelAliensFightOut")
            end

            local startStamina = 20
            local ped = cache.ped
            AlienEffect()
            SetRunSprintMultiplierForPlayer(cache.playerId, 1.1)
            while startStamina > 0 do
                Wait(1000)
                if math.random(1, 100) < 20 then
                    RestorePlayerStamina(cache.playerId, 1.0)
                end
                startStamina -= 1
                if math.random(1, 100) < 10 and IsPedRunning(ped) then
                    SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
                end
                if math.random(1, 300) < 10 then
                    AlienEffect()
                    Wait(math.random(3000, 6000))
                end
            end
            if IsPedRunning(ped) then
                SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
            end
            SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
        end
    },
    ["crack_baggy"] = {
        label = "Snorting Crack",
        progress = 5000,
        anim = {
            lib = "switch@trevor@trev_smoking_meth",
            name = "trev_smoking_meth_loop",
            flag = 49,
        },
        relieveStress = 10,
    },
    ["meth"] = {
        label = "Snorting Meth",
        progress = 5000,
        anim = {
            lib = "switch@trevor@trev_smoking_meth",
            name = "trev_smoking_meth_loop",
            flag = 49,
        },
        relieveStress = 10,
        action = function ()
            local function TrevorEffect()
                StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, false)
                Wait(3000)
                StartScreenEffect("DrugsTrevorClownsFight", 3.0, false)
                Wait(3000)
                StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, false)
                StopScreenEffect("DrugsTrevorClownsFight")
                StopScreenEffect("DrugsTrevorClownsFightIn")
                StopScreenEffect("DrugsTrevorClownsFightOut")
            end

            local startStamina = 8
            TrevorEffect()
            SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)
            while startStamina > 0 do
                Wait(1000)
                if math.random(5, 100) < 10 then
                    RestorePlayerStamina(cache.playerId, 1.0)
                end
                startStamina = startStamina - 1
                if math.random(5, 100) < 51 then
                    TrevorEffect()
                end
            end
            SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
        end
    },
    ["xtcbaggy"] = {
        label = "Taking XTC",
        progress = 5000,
        anim = {
            lib = "mp_suicide",
            name = "pill",
            flag = 49,
        },
        relieveStress = 10,
        action = function()
            local startStamina = 30
            SetFlash(0, 0, 500, 7000, 500)
            while startStamina > 0 do
                Wait(1000)
                startStamina -= 1
                RestorePlayerStamina(cache.playerId, 1.0)
                if math.random(1, 100) < 51 then
                    SetFlash(0, 0, 500, 7000, 500)
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                end
            end
            if IsPedRunning(cache.ped) then
                SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
            end
        end
    },
    ["oxy"] = {
        label = "Taking OXY",
        progress = 5000,
        anim = {
            lib = "mp_suicide",
            name = "pill",
            flag = 49,
        },
        relieveStress = 10,
    },

    --smoke

    ["joint"] = {
        label = "Smoking Joint",
        progress = 5000,
        emote = "smokeweed",
        relieveStress = 20,
    },
}


Config.ConsumablesItems = {
    ['armor'] = {
        label = 'Using Armor',
        progress = 5000,  --ms
        anim = {
            lib = 'clothingshirt',
            name = 'try_shirt_positive_d',
            flag = 49,
        },
        removeItem = true,
        action = function()
            TriggerServerEvent('hospital:server:SetArmor', 50)
            SetPedArmour(cache.ped, 50)
        end
    },
    ['heavyarmor'] = {
        label = 'Using Armor',
        progress = 5000,  --ms
        anim = {
            lib = 'clothingshirt',
            name = 'try_shirt_positive_d',
            flag = 49,
        },
        removeItem = true,
        action = function()
            TriggerServerEvent('hospital:server:SetArmor', 100)
            SetPedArmour(cache.ped, 100)
        end
    },
    ['parachute'] = {
        label = 'Preparing Parachute',
        progress = 15000,  --ms
        anim = {
            lib = 'clothingshirt',
            name = 'try_shirt_positive_d',
            flag = 49,
        },
        removeItem = true,
        action = function()
            if not GetterParachute() then
                local ped = cache.ped
                GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 1, false, false)
                local ParachuteData = {
                    outfitData = {
                        ["bag"]   = { item = 8, texture = 0},  -- Adding Parachute Clothing
                    }
                }
                TriggerEvent('qb-clothing:client:loadOutfit', ParachuteData)
                SetterParachute(true)
            end
        end
    },
}

Config.Fuckage = 2000 -- in MS

-- Adjust the time to change how long the driver is forced into the random event. IN MS
-- There are more random events you can add on the fivem native wiki

Config.RandomVehicleInteraction = {
	{interaction = 27, time = 1500},
	{interaction = 6, time = 1000},
	{interaction = 7, time = 800}, --turn left and accel
	{interaction = 8, time = 800}, --turn right and accel
	{interaction = 10, time = 800}, --turn left and restore wheel pos
	{interaction = 11, time = 800}, --turn right and restore wheel pos
	{interaction = 23, time = 2000}, -- accel fast
	{interaction = 31, time = 2000} -- accel fast and then handbrake
}