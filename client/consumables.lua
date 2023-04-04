-- Variables

local QBCore = exports['qbx-core']:GetCoreObject()
local alcoholCount, ParachuteEquiped, currentVest, currentVestTexture, healing, SmokingWeed, RelieveCount = 0, false, nil, nil, false, false, 0

-- Functions

local function EquipParachuteAnim()
    local hasLoaded = lib.requestAnimDict('clothingshirt')
    if not hasLoaded then return end
    TaskPlayAnim(cache.ped, 'clothingshirt', 'try_shirt_positive_d', 8.0, 1.0, -1, 49, 0, false, false, false)
end

local function HealOxy()
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

local function TrevorEffect()
    AnimpostfxPlay('DrugsTrevorClownsFightIn', 3.0, 0)
    Wait(3000)
    AnimpostfxPlay('DrugsTrevorClownsFight', 3.0, 0)
    Wait(3000)
	AnimpostfxPlay('DrugsTrevorClownsFightOut', 3.0, 0)
	AnimpostfxStop('DrugsTrevorClownsFight')
	AnimpostfxStop('DrugsTrevorClownsFightIn')
	AnimpostfxStop('DrugsTrevorClownsFightOut')
end

local function MethBagEffect()
    local startStamina = 8
    TrevorEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    while startStamina > 0 do
        Wait(1000)
        if math.random(5, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(5, 100) < 51 then
            TrevorEffect()
        end
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

local function EcstasyEffect()
    local startStamina = 30
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do
        Wait(1000)
        startStamina -= 1
        RestorePlayerStamina(PlayerId(), 1.0)
        if math.random(1, 100) < 51 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
end

local function AlienEffect()
    AnimpostfxPlay('DrugsMichaelAliensFightIn', 3.0, 0)
    Wait(math.random(5000, 8000))
    AnimpostfxPlay('DrugsMichaelAliensFight', 3.0, 0)
    Wait(math.random(5000, 8000))
    AnimpostfxPlay('DrugsMichaelAliensFightOut', 3.0, 0)
    AnimpostfxStop('DrugsMichaelAliensFightIn')
    AnimpostfxStop('DrugsMichaelAliensFight')
    AnimpostfxStop('DrugsMichaelAliensFightOut')
end

local function CrackBaggyEffect()
    local startStamina = 8
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 60 and IsPedRunning(cache.ped) then
            SetPedToRagdoll(cache.ped, math.random(1000, 2000), math.random(1000, 2000), 3, false, false, false)
        end
        if math.random(1, 100) < 51 then
            AlienEffect()
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

local function CokeBaggyEffect()
    local startStamina = 20
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 10 and IsPedRunning(cache.ped) then
            SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
        end
        if math.random(1, 300) < 10 then
            AlienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

local function SmokeWeed()
    CreateThread(function()
        while SmokingWeed do
            Wait(10000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(15, 18))
            RelieveCount += 1
            if RelieveCount == 6 then
                exports.scully_emotemenu:CancelAnimation()
                if SmokingWeed then
                    SmokingWeed = false
                    RelieveCount = 0
                end
            end
        end
    end)
end

-- Events

RegisterNetEvent('consumables:client:Eat', function(itemName)
    exports.scully_emotemenu:PlayByCommand('eat')
    QBCore.Functions.Progressbar('eat_something', 'Eating..', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        exports.scully_emotemenu:CancelAnimation()
        TriggerServerEvent('consumables:server:addHunger', QBCore.Functions.GetPlayerData().metadata['hunger'] + ConsumablesEat[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

RegisterNetEvent('consumables:client:Drink', function(itemName)
    exports.scully_emotemenu:PlayByCommand('drink')
    QBCore.Functions.Progressbar('drink_something', 'Drinking..', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        exports.scully_emotemenu:CancelAnimation()
        TriggerServerEvent('consumables:server:addThirst', QBCore.Functions.GetPlayerData().metadata['thirst'] + ConsumablesDrink[itemName])
    end)
end)

RegisterNetEvent('consumables:client:DrinkAlcohol', function(itemName)
    exports.scully_emotemenu:PlayByCommand('beer7')
    QBCore.Functions.Progressbar('snort_coke', 'Drinking liquor..', math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        exports.scully_emotemenu:CancelAnimation()
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        TriggerServerEvent('consumables:server:drinkAlcohol', itemName)
        TriggerServerEvent('consumables:server:addThirst', QBCore.Functions.GetPlayerData().metadata['thirst'] + ConsumablesAlcohol[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
        alcoholCount += 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent('evidence:client:SetStatus', 'alcohol', 200)
        elseif alcoholCount >= 4 then
            TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 200)
        end

    end, function() -- Cancel
        exports.scully_emotemenu:CancelAnimation()
        QBCore.Functions.Notify('Cancelled..', 'error')
    end)
end)

RegisterNetEvent('consumables:client:Cokebaggy', function()
    QBCore.Functions.Progressbar('snort_coke', 'Quick sniff..', math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'switch@trevor@trev_smoking_meth',
        anim = 'trev_smoking_meth_loop',
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(cache.ped, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0)
        TriggerServerEvent('consumables:server:useCokeBaggy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['cokebaggy'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 200)
        CokeBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(cache.ped, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0)
        QBCore.Functions.Notify('Canceled..', 'error')
    end)
end)

RegisterNetEvent('consumables:client:Crackbaggy', function()
    QBCore.Functions.Progressbar('snort_coke', 'Smoking crack..', math.random(7000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'switch@trevor@trev_smoking_meth',
        anim = 'trev_smoking_meth_loop',
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(cache.ped, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0)
        TriggerServerEvent('consumables:server:useCrackBaggy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['crack_baggy'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
        CrackBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(cache.ped, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0)
        QBCore.Functions.Notify('Canceled..', 'error')
    end)
end)

RegisterNetEvent('consumables:client:EcstasyBaggy', function()
    QBCore.Functions.Progressbar('use_ecstasy', 'Pops Pills', 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = 'mp_suicide',
		anim = 'pill',
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(cache.ped, 'mp_suicide', 'pill', 1.0)
        TriggerServerEvent('consumables:server:useXTCBaggy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['xtcbaggy'], 'remove')
        EcstasyEffect()
    end, function() -- Cancel
        StopAnimTask(cache.ped, 'mp_suicide', 'pill', 1.0)
        QBCore.Functions.Notify('Failed', 'error')
    end)
end)

RegisterNetEvent('consumables:client:oxy', function()
    QBCore.Functions.Progressbar('use_oxy', 'Healing', 2000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = 'mp_suicide',
		anim = 'pill',
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(cache.ped, 'mp_suicide', 'pill', 1.0)
        TriggerServerEvent('consumables:server:useOxy')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['oxy'], 'remove')
        ClearPedBloodDamage(cache.ped)
		HealOxy()
    end, function() -- Cancel
        StopAnimTask(cache.ped, 'mp_suicide', 'pill', 1.0)
        QBCore.Functions.Notify('Canceled', 'error')
    end)
end)

RegisterNetEvent('consumables:client:meth', function()
    QBCore.Functions.Progressbar('snort_meth', 'Smoking Ass Meth', 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'switch@trevor@trev_smoking_meth',
        anim = 'trev_smoking_meth_loop',
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(cache.ped, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0)
        TriggerServerEvent('consumables:server:useMeth')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['meth'], 'remove')
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
		TriggerEvent('evidence:client:SetStatus', 'agitated', 300)
        MethBagEffect()
    end, function() -- Cancel
        StopAnimTask(cache.ped, 'switch@trevor@trev_smoking_meth', 'trev_smoking_meth_loop', 1.0)
        QBCore.Functions.Notify('Canceled..', 'error')
	end)
end)

RegisterNetEvent('consumables:client:UseJoint', function()
    QBCore.Functions.Progressbar('smoke_joint', 'Lighting joint..', 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['joint'], 'remove')
        exports.scully_emotemenu:PlayByCommand('joint')
        TriggerEvent('evidence:client:SetStatus', 'weedsmell', 300)
        SmokeWeed()
    end)
end)

RegisterNetEvent('consumables:client:UseParachute', function()
    EquipParachuteAnim()
    QBCore.Functions.Progressbar('use_parachute', 'Putting on parachute..', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['parachute'], 'remove')
        GiveWeaponToPed(cache.ped, `GADGET_PARACHUTE`, 1, false, false)
        local ParachuteData = {
            outfitData = {
                ['bag']   = { item = 7, texture = 0},  -- Adding Parachute Clothing
            }
        }
        TriggerEvent('qb-clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(cache.ped, 'clothingshirt', 'exit', 8.0, 1.0, -1, 49, 0, false, false, false)
    end)
end)

RegisterNetEvent('consumables:client:ResetParachute', function()
    if ParachuteEquiped then
        EquipParachuteAnim()
        QBCore.Functions.Progressbar('reset_parachute', 'Packing parachute..', 40000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['parachute'], 'add')
            local ParachuteRemoveData = {
                outfitData = {
                    ['bag'] = { item = 0, texture = 0} -- Removing Parachute Clothing
                }
            }
            TriggerEvent('qb-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(cache.ped, 'clothingshirt', 'exit', 8.0, 1.0, -1, 49, 0, false, false, false)
            TriggerServerEvent('qb-smallpenis:server:AddParachute')
            ParachuteEquiped = false
        end)
    else
        QBCore.Functions.Notify('You dont have a parachute!', 'error')
    end
end)

RegisterNetEvent('consumables:client:UseArmor', function()
    if GetPedArmour(cache.ped) >= 75 then QBCore.Functions.Notify('You already have enough armor on!', 'error') return end
    QBCore.Functions.Progressbar('use_armor', 'Putting on the body armour..', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['armor'], 'remove')
        TriggerServerEvent('hospital:server:SetArmor', 75)
        TriggerServerEvent('consumables:server:useArmor')
        SetPedArmour(cache.ped, 75)
    end)
end)

RegisterNetEvent('consumables:client:UseHeavyArmor', function()
    if GetPedArmour(cache.ped) == 100 then QBCore.Functions.Notify('You already have enough armor on!', 'error') return end
    local PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.Progressbar('use_heavyarmor', 'Putting on body armour..', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
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
    end)
end)

RegisterNetEvent('consumables:client:ResetArmor', function()
    if currentVest ~= nil and currentVestTexture ~= nil then
        QBCore.Functions.Progressbar('remove_armor', 'Removing the body armour..', 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(cache.ped, 9, currentVest, currentVestTexture, 2)
            SetPedArmour(cache.ped, 0)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['heavyarmor'], 'add')
            TriggerServerEvent('consumables:server:resetArmor')
        end)
    else
        QBCore.Functions.Notify('You\'re not wearing a vest..', 'error')
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
