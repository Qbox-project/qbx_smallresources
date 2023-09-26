----------- / alcohol
for cAl in pairs(ConsumablesAlcohol) do
    QBX.Functions.CreateUseableItem(cAl, function(source, item)
        local src = source
        local player = QBX.Functions.GetPlayer(src)
        if player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:DrinkAlcohol', src, item.name)
        end
    end)
end

----------- / Non-Alcoholic Drinks
for cDr in pairs(ConsumablesDrink) do
    QBX.Functions.CreateUseableItem(cDr, function(source, item)
        local src = source
        local player = QBX.Functions.GetPlayer(src)
        if player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:Drink', src, item.name)
        end
    end)
end

----------- / Food
for cEa in pairs(ConsumablesEat) do
    QBX.Functions.CreateUseableItem(cEa, function(source, item)
        local src = source
        local player = QBX.Functions.GetPlayer(src)
        if player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:Eat', src, item.name)
        end
    end)
end

----------- / Drug

QBX.Functions.CreateUseableItem('joint', function(source, item)
    local player = QBX.Functions.GetPlayer(source)
	if not player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent('consumables:client:UseJoint', source)
end)

QBX.Functions.CreateUseableItem('cokebaggy', function(source)
    TriggerClientEvent('consumables:client:Cokebaggy', source)
end)

QBX.Functions.CreateUseableItem('crack_baggy', function(source)
    TriggerClientEvent('consumables:client:Crackbaggy', source)
end)

QBX.Functions.CreateUseableItem('xtcbaggy', function(source, _)
    TriggerClientEvent('consumables:client:EcstasyBaggy', source)
end)

QBX.Functions.CreateUseableItem('oxy', function(source)
    TriggerClientEvent('consumables:client:oxy', source)
end)

QBX.Functions.CreateUseableItem('meth', function(source)
    TriggerClientEvent('consumables:client:meth', source)
end)

----------- / Tools

QBX.Functions.CreateUseableItem('armor', function(source)
    TriggerClientEvent('consumables:client:UseArmor', source)
end)

QBX.Functions.CreateUseableItem('heavyarmor', function(source)
    TriggerClientEvent('consumables:client:UseHeavyArmor', source)
end)

lib.addCommand('resetvest', {
    help = 'Resets Vest (Police Only)',
}, function(source)
    local Player = QBX.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('consumables:client:ResetArmor', source)
    else
        TriggerClientEvent('QBCore:Notify', source,  'For Police Officer Only', 'error')
    end
end)

QBX.Functions.CreateUseableItem('binoculars', function(source)
    TriggerClientEvent('binoculars:Toggle', source)
end)

QBX.Functions.CreateUseableItem('parachute', function(source, item)
    local player = QBX.Functions.GetPlayer(source)
	if not player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent('consumables:client:UseParachute', source)
end)

lib.addCommand('resetparachute', {
    help = 'Resets Parachute',
}, function(source)
	TriggerClientEvent('consumables:client:ResetParachute', source)
end)

RegisterNetEvent('qb-smallpenis:server:AddParachute', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.AddItem('parachute', 1)
end)

----------- / Firework

QBX.Functions.CreateUseableItem('firework1', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_indep_firework')
end)

QBX.Functions.CreateUseableItem('firework2', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_indep_firework_v2')
end)

QBX.Functions.CreateUseableItem('firework3', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_xmas_firework')
end)

QBX.Functions.CreateUseableItem('firework4', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'scr_indep_fireworks')
end)

----------- / Lockpicking

QBX.Functions.CreateUseableItem('lockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, false)
    TriggerEvent('lockpicks:UseLockpick', source, false)
end)

QBX.Functions.CreateUseableItem('advancedlockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, true)
    TriggerEvent('lockpicks:UseLockpick', source, true)
end)

----------- / Unused

-- QBX.Functions.CreateUseableItem('smoketrailred', function(source, item)
--     local player = QBX.Functions.GetPlayer(source)
-- 	   if not player.Functions.RemoveItem(item.name, 1, item.slot) then return end
--     TriggerClientEvent('consumables:client:UseRedSmoke', source)
-- end)

-- Events for adding and removing specific items to fix some exploits

RegisterNetEvent('consumables:server:resetArmor', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.AddItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useHeavyArmor', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useArmor', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('armor', 1)
end)

RegisterNetEvent('consumables:server:useMeth', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('meth', 1)
end)

RegisterNetEvent('consumables:server:useOxy', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('oxy', 1)
end)

RegisterNetEvent('consumables:server:useXTCBaggy', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('xtcbaggy', 1)
end)

RegisterNetEvent('consumables:server:useCrackBaggy', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('crack_baggy', 1)
end)

RegisterNetEvent('consumables:server:useCokeBaggy', function()
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('cokebaggy', 1)
end)

RegisterNetEvent('consumables:server:drinkAlcohol', function(item)
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    local foundItem = nil

    for k in pairs(ConsumablesAlcohol) do
        if k == item then
            foundItem = k
            break
        end
    end

    if not foundItem then return end

    player.Functions.RemoveItem(foundItem, 1)
end)

RegisterNetEvent('consumables:server:UseFirework', function(item)
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    local foundItem = nil

    for i = 1, #ConsumablesFireworks do
        if ConsumablesFireworks[i] == item then
            foundItem = ConsumablesFireworks[i]
            break
        end
    end

    if not foundItem then return end

    player.Functions.RemoveItem(foundItem, 1)
end)

RegisterNetEvent('consumables:server:addThirst', function(amount)
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.SetMetaData('thirst', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.hunger, amount)
end)

RegisterNetEvent('consumables:server:addHunger', function(amount)
    local player = QBX.Functions.GetPlayer(source)

    if not player then return end

    player.Functions.SetMetaData('hunger', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, amount, player.PlayerData.metadata.thirst)
end)
