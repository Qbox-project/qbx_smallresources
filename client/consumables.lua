-- Variables
local alcoholCount, parachuteEquipped, currentVest, currentVestTexture, healing, smokingWeed, relieveCount = 0, false, nil, nil, false, false, 0

-- Functions

local function equipParachuteAnim()
    local hasLoaded = lib.requestAnimDict('clothingshirt')
    if not hasLoaded then return end
    TaskPlayAnim(cache.ped, 'clothingshirt', 'try_shirt_positive_d', 8.0, 1.0, -1, 49, 0, false, false, false)
end

local function healOxy()
    if not healing then
        healing = true
    else
        return
    end

    local count = 9
    while count > 0 do
        Wait(1000)
        count -= 1
        SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) + 6)
    end
    healing = false
end

local function trevorEffect()
    AnimpostfxPlay('DrugsTrevorClownsFightIn', 3.0, 0)
    Wait(3000)
    AnimpostfxPlay('DrugsTrevorClownsFight', 3.0, 0)
    Wait(3000)
	AnimpostfxPlay('DrugsTrevorClownsFightOut', 3.0, 0)
	AnimpostfxStop('DrugsTrevorClownsFight')
	AnimpostfxStop('DrugsTrevorClownsFightIn')
	AnimpostfxStop('DrugsTrevorClownsFightOut')
end

local function methBagEffect()
    local startStamina = 8
    trevorEffect()
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)
    while startStamina > 0 do
        Wait(1000)
        if math.random(5, 100) < 10 then
            RestorePlayerStamina(cache.playerId, 1.0)
        end
        startStamina = startStamina - 1
        if math.random(5, 100) < 51 then
            trevorEffect()
        end
    end
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
end

local function ecstasyEffect()
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

local function alienEffect()
    AnimpostfxPlay('DrugsMichaelAliensFightIn', 3.0, 0)
    Wait(math.random(5000, 8000))
    AnimpostfxPlay('DrugsMichaelAliensFight', 3.0, 0)
    Wait(math.random(5000, 8000))
    AnimpostfxPlay('DrugsMichaelAliensFightOut', 3.0, 0)
    AnimpostfxStop('DrugsMichaelAliensFightIn')
    AnimpostfxStop('DrugsMichaelAliensFight')
    AnimpostfxStop('DrugsMichaelAliensFightOut')
end

local function crackBaggyEffect()
    local startStamina = 8
    alienEffect()
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.3)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(cache.playerId, 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 60 and IsPedRunning(cache.ped) then
            SetPedToRagdoll(cache.ped, math.random(1000, 2000), math.random(1000, 2000), 3, false, false, false)
        end
        if math.random(1, 100) < 51 then
            alienEffect()
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
end

local function cokeBaggyEffect()
    local startStamina = 20
    alienEffect()
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.1)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(cache.playerId, 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 10 and IsPedRunning(cache.ped) then
            SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
        end
        if math.random(1, 300) < 10 then
            alienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
end

local function smokeWeed()
    CreateThread(function()
        while smokingWeed do
            Wait(10000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(15, 18))
            relieveCount += 1
            if relieveCount == 6 then
                exports.scully_emotemenu:cancelEmote()
                if smokingWeed then
                    smokingWeed = false
                    relieveCount = 0
                end
            end
        end
    end)
end

-- Events

RegisterNetEvent('consumables:client:Eat', function(itemName)
    exports.scully_emotemenu:playEmoteByCommand('eat')
    if lib.progressBar({
        duration = 5000,
        label = 'Eating...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        exports.scully_emotemenu:cancelEmote()
        TriggerServerEvent('consumables:server:addHunger', PlayerData.metadata.hunger + Config.Consumables.food[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end
end)

RegisterNetEvent('consumables:client:Drink', function(itemName)
    exports.scully_emotemenu:playEmoteByCommand('drink')
    if lib.progressBar({
        duration = 5000,
        label = 'Drinking...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        exports.scully_emotemenu:cancelEmote()
        TriggerServerEvent('consumables:server:addThirst', PlayerData.metadata.thirst + Config.Consumables.drink[itemName])
    end
end)

RegisterNetEvent('consumables:client:DrinkAlcohol', function(itemName)
    exports.scully_emotemenu:playEmoteByCommand('beer7')
    if lib.progressBar({
        duration = math.random(3000, 6000),
        label = 'Drinking liquor...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        exports.scully_emotemenu:cancelEmote()
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        TriggerServerEvent('consumables:server:drinkAlcohol', itemName)
        TriggerServerEvent('consumables:server:addThirst', PlayerData.metadata.thirst + Config.Consumables.alcohol[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
        alcoholCount += 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent('evidence:client:SetStatus', 'alcohol', 200)
        elseif alcoholCount >= 4 then
            TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 200)
        end
    else -- if canceled
        exports.scully_emotemenu:cancelEmote()
        QBCore.Functions.Notify('Canceled...,', 'error')
    end
end)

RegisterNetEvent('consumables:client:Cokebaggy', function()
    if lib.progressBar({
        duration = math.random(5000, 8000),
        label = 'Quick sniff...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'switch@trevor@trev_smoking_meth',
            clip = 'trev_smoking_meth_loop',
            flag = 49
        }
    }) then -- if completed
        TriggerServerEvent('consumables:server:useCokeBaggy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['cokebaggy'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 200)
        cokeBaggyEffect()
    else -- if canceled
        QBCore.Functions.Notify('Canceled...', 'error')
    end
end)

RegisterNetEvent('consumables:client:Crackbaggy', function()
    if lib.progressBar({
        duration = math.random(7000, 10000),
        label = 'Smoking crack...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'switch@trevor@trev_smoking_meth',
            clip = 'trev_smoking_meth_loop',
            flag = 49
        }
    }) then -- if completed
        TriggerServerEvent('consumables:server:useCrackBaggy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['crack_baggy'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
        crackBaggyEffect()
    else -- if canceled
        QBCore.Functions.Notify('Canceled...', 'error')
    end
end)

RegisterNetEvent('consumables:client:EcstasyBaggy', function()
    if lib.progressBar({
        duration = 3000,
        label = 'Popping pills...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'mp_suicide',
            clip = 'pill',
            flag = 49
        }
    }) then -- if completed
        TriggerServerEvent('consumables:server:useXTCBaggy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['xtcbaggy'], 'remove')
        ecstasyEffect()
    else -- if canceled
        QBCore.Functions.Notify('Canceled...', 'error')
    end
end)

RegisterNetEvent('consumables:client:oxy', function()
    if lib.progressBar({
        duration = 2000,
        label = 'Healing...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'mp_suicide',
            clip = 'pill',
            flag = 49
        }
    }) then -- if completed
        TriggerServerEvent('consumables:server:useOxy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['oxy'], 'remove')
        ClearPedBloodDamage(cache.ped)
		healOxy()
    else -- if canceled
        QBCore.Functions.Notify('Canceled', 'error')
    end
end)

RegisterNetEvent('consumables:client:meth', function()
    if lib.progressBar({
        duration = 1500,
        label = 'Smoking meth...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'switch@trevor@trev_smoking_meth',
            clip = 'trev_smoking_meth_loop',
            flag = 49
        }
    }) then -- if completed
        TriggerServerEvent('consumables:server:useMeth')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['meth'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
		TriggerEvent('evidence:client:SetStatus', 'agitated', 300)
        methBagEffect()
    else -- if canceled
        QBCore.Functions.Notify('Canceled...', 'error')
	end
end)

RegisterNetEvent('consumables:client:UseJoint', function()
    if lib.progressBar({
        duration = 1500,
        label = 'Lighting joint...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['joint'], 'remove')
        exports.scully_emotemenu:playEmoteByCommand('joint')
        TriggerEvent('evidence:client:SetStatus', 'weedsmell', 300)
        smokeWeed()
    end
end)

RegisterNetEvent('consumables:client:UseParachute', function()
    equipParachuteAnim()
    if lib.progressBar({
        duration = 5000,
        label = 'Putting on parachute...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['parachute'], 'remove')
        GiveWeaponToPed(cache.ped, `GADGET_PARACHUTE`, 1, false, false)
        local parachuteData = {
            outfitData = {['bag'] = {item = 7, texture = 0}} -- Adding Parachute Clothing
        }
        TriggerEvent('qb-clothing:client:loadOutfit', parachuteData)
        parachuteEquipped = true
        TaskPlayAnim(cache.ped, 'clothingshirt', 'exit', 8.0, 1.0, -1, 49, 0, false, false, false)
    end
end)

RegisterNetEvent('consumables:client:ResetParachute', function()
    if parachuteEquipped then
        equipParachuteAnim()
        if lib.progressBar({
            duration = 40000,
            label = 'Packing parachute...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            }
        }) then -- if completed
            local parachuteRemoveData = {
                outfitData = {['bag'] = {item = 0, texture = 0}} -- Removing Parachute Clothing
            }
            TriggerEvent('qb-clothing:client:loadOutfit', parachuteRemoveData)
            TaskPlayAnim(cache.ped, 'clothingshirt', 'exit', 8.0, 1.0, -1, 49, 0, false, false, false)
            TriggerServerEvent('qb-smallpenis:server:AddParachute')
            parachuteEquipped = false
        end
    else
        QBCore.Functions.Notify('You don\'t have a parachute...', 'error')
    end
end)

RegisterNetEvent('consumables:client:UseArmor', function()
    if GetPedArmour(cache.ped) >= 75 then QBCore.Functions.Notify('You already have enough armor on!', 'error') return end
    if lib.progressBar({
        duration = 5000,
        label = 'Putting on the body armour...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['armor'], 'remove')
        TriggerServerEvent('hospital:server:SetArmor', 75)
        TriggerServerEvent('consumables:server:useArmor')
        SetPedArmour(cache.ped, 75)
    end
end)

RegisterNetEvent('consumables:client:UseHeavyArmor', function()
    if GetPedArmour(cache.ped) == 100 then QBCore.Functions.Notify('You already have enough armor on!', 'error') return end
    if lib.progressBar({
        duration = 5000,
        label = 'Putting on body armor...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        if PlayerData.charinfo.gender == 0 then
            currentVest = GetPedDrawableVariation(cache.ped, 9)
            currentVestTexture = GetPedTextureVariation(cache.ped, 9)
            if GetPedDrawableVariation(cache.ped, 9) == 7 then
                SetPedComponentVariation(cache.ped, 9, 19, GetPedTextureVariation(cache.ped, 9), 2)
            else
                SetPedComponentVariation(cache.ped, 9, 5, 2, 2) -- Blue
            end
        else
            currentVest = GetPedDrawableVariation(cache.ped, 30)
            currentVestTexture = GetPedTextureVariation(cache.ped, 30)
            SetPedComponentVariation(cache.ped, 9, 30, 0, 2)
        end
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['heavyarmor'], 'remove')
        TriggerServerEvent('consumables:server:useHeavyArmor')
        SetPedArmour(cache.ped, 100)
    end
end)

RegisterNetEvent('consumables:client:ResetArmor', function()
    if currentVest ~= nil and currentVestTexture ~= nil then
        if lib.progressBar({
            duration = 2500,
            label = 'Removing the body armour...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            }
        }) then -- if completed
            SetPedComponentVariation(cache.ped, 9, currentVest, currentVestTexture, 2)
            SetPedArmour(cache.ped, 0)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['heavyarmor'], 'add')
            TriggerServerEvent('consumables:server:resetArmor')
        end
    else
        QBCore.Functions.Notify('You\'re not wearing a vest...', 'error')
    end
end)

--Threads

CreateThread(function()
    while true do
        Wait(10)
        if alcoholCount > 0 then
            Wait(1000 * 60 * 15)
            alcoholCount -= 1
        else
            Wait(2000)
        end
    end
end)