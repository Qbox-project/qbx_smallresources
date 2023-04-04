local QBCore = exports['qbx-core']:GetCoreObject()

----------- / alcohol
for cAl in pairs(ConsumablesAlcohol) do
    QBCore.Functions.CreateUseableItem(cAl, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:DrinkAlcohol', src, item.name)
        end
    end)
end

----------- / Non-Alcoholic Drinks
for cDr in pairs(ConsumablesDrink) do
    QBCore.Functions.CreateUseableItem(cDr, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:Drink', src, item.name)
        end
    end)
end

----------- / Food
for cEa in pairs(ConsumablesEat) do
    QBCore.Functions.CreateUseableItem(cEa, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:Eat', src, item.name)
        end
    end)
end

----------- / Drug

QBCore.Functions.CreateUseableItem('joint', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent('consumables:client:UseJoint', source)
end)

QBCore.Functions.CreateUseableItem('cokebaggy', function(source)
    TriggerClientEvent('consumables:client:Cokebaggy', source)
end)

QBCore.Functions.CreateUseableItem('crack_baggy', function(source)
    TriggerClientEvent('consumables:client:Crackbaggy', source)
end)

QBCore.Functions.CreateUseableItem('xtcbaggy', function(source, _)
    TriggerClientEvent('consumables:client:EcstasyBaggy', source)
end)

QBCore.Functions.CreateUseableItem('oxy', function(source)
    TriggerClientEvent('consumables:client:oxy', source)
end)

QBCore.Functions.CreateUseableItem('meth', function(source)
    TriggerClientEvent('consumables:client:meth', source)
end)

----------- / Tools

QBCore.Functions.CreateUseableItem('armor', function(source)
    TriggerClientEvent('consumables:client:UseArmor', source)
end)

QBCore.Functions.CreateUseableItem('heavyarmor', function(source)
    TriggerClientEvent('consumables:client:UseHeavyArmor', source)
end)

QBCore.Commands.Add('resetarmor', 'Resets Vest (Police Only)', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('consumables:client:ResetArmor', source)
    else
        TriggerClientEvent('QBCore:Notify', source,  'For Police Officer Only', 'error')
    end
end)

QBCore.Functions.CreateUseableItem('binoculars', function(source)
    TriggerClientEvent('binoculars:Toggle', source)
end)

QBCore.Functions.CreateUseableItem('parachute', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent('consumables:client:UseParachute', source)
end)

QBCore.Commands.Add('resetparachute', 'Resets Parachute', {}, false, function(source)
	TriggerClientEvent('consumables:client:ResetParachute', source)
end)

RegisterNetEvent('qb-smallpenis:server:AddParachute', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.AddItem('parachute', 1)
end)

----------- / Firework

QBCore.Functions.CreateUseableItem('firework1', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_indep_firework')
end)

QBCore.Functions.CreateUseableItem('firework2', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_indep_firework_v2')
end)

QBCore.Functions.CreateUseableItem('firework3', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_xmas_firework')
end)

QBCore.Functions.CreateUseableItem('firework4', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'scr_indep_fireworks')
end)

----------- / Lockpicking

QBCore.Functions.CreateUseableItem('lockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, false)
    TriggerEvent('lockpicks:UseLockpick', source, false)
end)

QBCore.Functions.CreateUseableItem('advancedlockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, true)
    TriggerEvent('lockpicks:UseLockpick', source, true)
end)

----------- / Unused

-- QBCore.Functions.CreateUseableItem('smoketrailred', function(source, item)
--     local Player = QBCore.Functions.GetPlayer(source)
-- 	   if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
--     TriggerClientEvent('consumables:client:UseRedSmoke', source)
-- end)

-- Events for adding and removing specific items to fix some exploits

RegisterNetEvent('consumables:server:resetArmor', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.AddItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useHeavyArmor', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useArmor', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('armor', 1)
end)

RegisterNetEvent('consumables:server:useMeth', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('meth', 1)
end)

RegisterNetEvent('consumables:server:useOxy', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('oxy', 1)
end)

RegisterNetEvent('consumables:server:useXTCBaggy', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('xtcbaggy', 1)
end)

RegisterNetEvent('consumables:server:useCrackBaggy', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('crack_baggy', 1)
end)

RegisterNetEvent('consumables:server:useCokeBaggy', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('cokebaggy', 1)
end)

RegisterNetEvent('consumables:server:drinkAlcohol', function(item)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    local foundItem = nil

    for k in pairs(ConsumablesAlcohol) do
        if k == item then
            foundItem = k
            break
        end
    end

    if not foundItem then return end

    Player.Functions.RemoveItem(foundItem, 1)
end)

RegisterNetEvent('consumables:server:UseFirework', function(item)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    local foundItem = nil

    for i = 1, #ConsumablesFireworks do
        if ConsumablesFireworks[i] == item then
            foundItem = ConsumablesFireworks[i]
            break
        end
    end

    if not foundItem then return end

    Player.Functions.RemoveItem(foundItem, 1)
end)

RegisterNetEvent('consumables:server:addThirst', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.SetMetaData('thirst', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, Player.PlayerData.metadata.hunger, amount)
end)

RegisterNetEvent('consumables:server:addHunger', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.SetMetaData('hunger', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, amount, Player.PlayerData.metadata.thirst)
end)
