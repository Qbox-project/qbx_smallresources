----------- / alcohol
for alcohol, params in pairs(ConsumablesAlcohol) do
    exports.qbx_core:CreateUseableItem(alcohol, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local drank = lib.callback.await('consumables:client:DrinkAlcohol', source, item.name)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = player.PlayerData.metadata.thirst + math.random(params.min, params.max)
        player.Functions.SetMetaData('thirst', sustenance)
        
        if not params.stressRelief then
            params.stressRelief = {
                min = 1,
                max = 4
            }
        end
        TriggerEvent('hud:server:RelieveStress', source, math.random(params.stressRelief.min, params.stressRelief.max))

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.thirst, sustenance)
    end)
end

----------- / Non-Alcoholic Drinks
for drink, params in pairs(ConsumablesDrink) do
    exports.qbx_core:CreateUseableItem(drink, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local drank = lib.callback.await('consumables:client:Drink', source, item.name)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = player.PlayerData.metadata.thirst + math.random(params.min, params.max)
        player.Functions.SetMetaData('thirst', sustenance)
        
        if not params.stressRelief then
            params.stressRelief = {
                min = 1,
                max = 4
            }
        end
        TriggerEvent('hud:server:RelieveStress', source, math.random(params.stressRelief.min, params.stressRelief.max))

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.thirst, sustenance)
    end)
end

----------- / Food
for food, params in pairs(ConsumablesEat) do
    exports.qbx_core:CreateUseableItem(food, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end
        
        local ate = lib.callback.await('consumables:client:Drink', source, item.name)
        if not ate then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = player.PlayerData.metadata.hunger + math.random(params.min, params.max)
        player.Functions.SetMetaData('hunger', sustenance)

        if not params.stressRelief then
            params.stressRelief = {
                min = 1,
                max = 4
            }
        end
        TriggerEvent('hud:server:RelieveStress', source, math.random(params.stressRelief.min, params.stressRelief.max))

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.hunger, sustenance)
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

lib.callback.register('consumables:server:usedItem', function(source, item)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    return exports.ox_inventory:RemoveItem(source, item, 1)
end)
