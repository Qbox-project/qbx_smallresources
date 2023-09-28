----------- / alcohol
for cAl in pairs(ConsumablesAlcohol) do
    exports.qbx_core:CreateUseableItem(cAl, function(source, item)
        local src = source
        local player = exports.qbx_core:GetPlayer(src)
        if player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:DrinkAlcohol', src, item.name)
        end
    end)
end

----------- / Non-Alcoholic Drinks
for cDr in pairs(ConsumablesDrink) do
    exports.qbx_core:CreateUseableItem(cDr, function(source, item)
        local src = source
        local player = exports.qbx_core:GetPlayer(src)
        if player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:Drink', src, item.name)
        end
    end)
end

----------- / Food
for cEa in pairs(ConsumablesEat) do
    exports.qbx_core:CreateUseableItem(cEa, function(source, item)
        local src = source
        local player = exports.qbx_core:GetPlayer(src)
        if player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent('consumables:client:Eat', src, item.name)
        end
    end)
end

----------- / Drug

exports.qbx_core:CreateUseableItem('joint', function(source, item)
    local player = exports.qbx_core:GetPlayer(source)
	if not player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent('consumables:client:UseJoint', source)
end)

exports.qbx_core:CreateUseableItem('cokebaggy', function(source)
    TriggerClientEvent('consumables:client:Cokebaggy', source)
end)

exports.qbx_core:CreateUseableItem('crack_baggy', function(source)
    TriggerClientEvent('consumables:client:Crackbaggy', source)
end)

exports.qbx_core:CreateUseableItem('xtcbaggy', function(source, _)
    TriggerClientEvent('consumables:client:EcstasyBaggy', source)
end)

exports.qbx_core:CreateUseableItem('oxy', function(source)
    TriggerClientEvent('consumables:client:oxy', source)
end)

exports.qbx_core:CreateUseableItem('meth', function(source)
    TriggerClientEvent('consumables:client:meth', source)
end)

----------- / Tools

exports.qbx_core:CreateUseableItem('armor', function(source)
    TriggerClientEvent('consumables:client:UseArmor', source)
end)

exports.qbx_core:CreateUseableItem('heavyarmor', function(source)
    TriggerClientEvent('consumables:client:UseHeavyArmor', source)
end)

lib.addCommand('resetvest', {
    help = 'Resets Vest (Police Only)',
}, function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('consumables:client:ResetArmor', source)
    else
        TriggerClientEvent('QBCore:Notify', source,  'For Police Officer Only', 'error')
    end
end)

exports.qbx_core:CreateUseableItem('binoculars', function(source)
    TriggerClientEvent('binoculars:Toggle', source)
end)

exports.qbx_core:CreateUseableItem('parachute', function(source, item)
    local player = exports.qbx_core:GetPlayer(source)
	if not player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent('consumables:client:UseParachute', source)
end)

lib.addCommand('resetparachute', {
    help = 'Resets Parachute',
}, function(source)
	TriggerClientEvent('consumables:client:ResetParachute', source)
end)

RegisterNetEvent('qb-smallpenis:server:AddParachute', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.AddItem('parachute', 1)
end)

----------- / Firework

exports.qbx_core:CreateUseableItem('firework1', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_indep_firework')
end)

exports.qbx_core:CreateUseableItem('firework2', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_indep_firework_v2')
end)

exports.qbx_core:CreateUseableItem('firework3', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'proj_xmas_firework')
end)

exports.qbx_core:CreateUseableItem('firework4', function(source, item)
    local src = source
    TriggerClientEvent('fireworks:client:UseFirework', src, item.name, 'scr_indep_fireworks')
end)

----------- / Lockpicking

exports.qbx_core:CreateUseableItem('lockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, false)
    TriggerEvent('lockpicks:UseLockpick', source, false)
end)

exports.qbx_core:CreateUseableItem('advancedlockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, true)
    TriggerEvent('lockpicks:UseLockpick', source, true)
end)

----------- / Unused

-- exports.qbx_core:CreateUseableItem('smoketrailred', function(source, item)
--     local player = exports.qbx_core:GetPlayer(source)
-- 	   if not player.Functions.RemoveItem(item.name, 1, item.slot) then return end
--     TriggerClientEvent('consumables:client:UseRedSmoke', source)
-- end)

-- Events for adding and removing specific items to fix some exploits

RegisterNetEvent('consumables:server:resetArmor', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.AddItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useHeavyArmor', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('heavyarmor', 1)
end)

RegisterNetEvent('consumables:server:useArmor', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('armor', 1)
end)

RegisterNetEvent('consumables:server:useMeth', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('meth', 1)
end)

RegisterNetEvent('consumables:server:useOxy', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('oxy', 1)
end)

RegisterNetEvent('consumables:server:useXTCBaggy', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('xtcbaggy', 1)
end)

RegisterNetEvent('consumables:server:useCrackBaggy', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('crack_baggy', 1)
end)

RegisterNetEvent('consumables:server:useCokeBaggy', function()
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.RemoveItem('cokebaggy', 1)
end)

RegisterNetEvent('consumables:server:drinkAlcohol', function(item)
    local player = exports.qbx_core:GetPlayer(source)

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
    local player = exports.qbx_core:GetPlayer(source)

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
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.SetMetaData('thirst', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.hunger, amount)
end)

RegisterNetEvent('consumables:server:addHunger', function(amount)
    local player = exports.qbx_core:GetPlayer(source)

    if not player then return end

    player.Functions.SetMetaData('hunger', amount)
    TriggerClientEvent('hud:client:UpdateNeeds', source, amount, player.PlayerData.metadata.thirst)
end)
