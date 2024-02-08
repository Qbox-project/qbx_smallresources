----------- / alcohol
for alcohol in pairs(ConsumablesAlcohol) do
    exports.qbx_core:CreateUseableItem(alcohol, function(source, item)
        TriggerClientEvent('consumables:client:DrinkAlcohol', source, item.name)
    end)
end

----------- / Non-Alcoholic Drinks
for drink in pairs(ConsumablesDrink) do
    exports.qbx_core:CreateUseableItem(drink, function(source, item)
        TriggerClientEvent('consumables:client:Drink', source, item.name)
    end)
end

----------- / Food
for food in pairs(ConsumablesEat) do
    exports.qbx_core:CreateUseableItem(food, function(source, item)
        TriggerClientEvent('consumables:client:Eat', source, item.name)
    end)
end

----------- / Drug

exports.qbx_core:CreateUseableItem('joint', function(source)
    TriggerClientEvent('consumables:client:UseJoint', source)
end)

exports.qbx_core:CreateUseableItem('cokebaggy', function(source)
    TriggerClientEvent('consumables:client:Cokebaggy', source)
end)

exports.qbx_core:CreateUseableItem('crack_baggy', function(source)
    TriggerClientEvent('consumables:client:Crackbaggy', source)
end)

exports.qbx_core:CreateUseableItem('xtcbaggy', function(source)
    TriggerClientEvent('consumables:client:EcstasyBaggy', source)
end)

exports.qbx_core:CreateUseableItem('oxy', function(source)
    TriggerClientEvent('consumables:client:oxy', source)
end)

exports.qbx_core:CreateUseableItem('meth', function(source)
    TriggerClientEvent('consumables:client:meth', source)
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

lib.callback.register('consumables:server:usedItem', function(source, item)
    local player = exports.qbx_core:GetPlayer(source)
    if not player or not item then return end

    return exports.ox_inventory:RemoveItem(source, item, 1)
end)