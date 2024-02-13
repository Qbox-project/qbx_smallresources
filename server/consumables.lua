local sharedConfig = require 'config.shared'

for alcohol, params in pairs(sharedConfig.consumables.alcohol) do
    exports.qbx_core:CreateUseableItem(alcohol, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local drank = lib.callback.await('consumables:client:DrinkAlcohol', source, item.name)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = player.PlayerData.metadata.thirst + math.random(params.min, params.max)
        player.Functions.SetMetaData('thirst', sustenance)

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.thirst, sustenance)
    end)
end

for drink, params in pairs(sharedConfig.consumables.drink) do
    exports.qbx_core:CreateUseableItem(drink, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local drank = lib.callback.await('consumables:client:Drink', source, item.name)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = player.PlayerData.metadata.thirst + math.random(params.min, params.max)
        player.Functions.SetMetaData('thirst', sustenance)

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.thirst, sustenance)
    end)
end

for food, params in pairs(sharedConfig.consumables.food) do
    exports.qbx_core:CreateUseableItem(food, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local ate = lib.callback.await('consumables:client:Eat', source, item.name)
        if not ate then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = player.PlayerData.metadata.hunger + math.random(params.min, params.max)
        player.Functions.SetMetaData('hunger', sustenance)

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.hunger, sustenance)
    end)
end

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

exports.qbx_core:CreateUseableItem('lockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, false)
    TriggerEvent('lockpicks:UseLockpick', source, false)
end)

exports.qbx_core:CreateUseableItem('advancedlockpick', function(source)
    TriggerClientEvent('lockpicks:UseLockpick', source, true)
    TriggerEvent('lockpicks:UseLockpick', source, true)
end)

lib.callback.register('consumables:server:usedItem', function(source, item)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    return exports.ox_inventory:RemoveItem(source, item, 1)
end)
