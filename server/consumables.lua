local config = require 'config.server'

local function addHunger(amount)
    amount = lib.math.clamp(amount, 0, 100)
    local playerState = Player(source).state
    playerState:set('hunger', amount, true)
    TriggerClientEvent('hud:client:UpdateNeeds', source, amount, playerState.thirst)
end

local function addThirst(amount)
    amount = lib.math.clamp(amount, 0, 100)
    local playerState = Player(source).state
    playerState:set('thirst', amount, true)
    TriggerClientEvent('hud:client:UpdateNeeds', source, playerState.hunger, amount)
end

local function relieveStress(source, min, max)
    local playerState = Player(source).state
    local verifiedMin = (type(min) == "number" and min) or config.defaultStressRelief.min
    local verifiedMax = max or config.defaultStressRelief.max
    local amount = math.random(verifiedMin, verifiedMax)
    local newStress = (playerState.stress or 0) - amount
    newStress = lib.math.clamp(newStress, 0, 100)

    playerState:set("stress", newStress, true)
    if amount < 0 then
        exports.qbx_core:Notify(source, locale('error.stress_gain'), 'inform', 2500, nil, nil, {'#141517', '#ffffff'}, 'brain', '#C53030')
    else
        exports.qbx_core:Notify(source, locale('success.stress_relief'), 'inform', 2500, nil, nil, {'#141517', '#ffffff'}, 'brain', '#0F52BA')
    end
end

for alcohol, params in pairs(config.consumables.alcohol) do
    exports.qbx_core:CreateUseableItem(alcohol, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local drank = lib.callback.await('consumables:client:DrinkAlcohol', source, params.alcoholLevel, params.anim, params.prop)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end
        local playerState = Player(source).state

        local sustenance = (playerState.thirst or 0) + math.random(params.min, params.max)
        relieveStress(source, params.stressRelief.min, params.stressRelief.max)
        addThirst(sustenance)
    end)
end

for drink, params in pairs(config.consumables.drink) do
    exports.qbx_core:CreateUseableItem(drink, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local drank = lib.callback.await('consumables:client:Drink', source, params.anim, params.prop)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end
        local playerState = Player(source).state

        local sustenance = (playerState.thirst or 0) + math.random(params.min, params.max)
        relieveStress(source, params.stressRelief.min, params.stressRelief.max)
        addThirst(sustenance)
    end)
end

for food, params in pairs(config.consumables.food) do
    exports.qbx_core:CreateUseableItem(food, function(source, item)
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        local ate = lib.callback.await('consumables:client:Eat', source, params.anim, params.prop)
        if not ate then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end
        local playerState = Player(source).state

        local sustenance = (playerState.hunger or 0) + math.random(params.min, params.max)
        relieveStress(source, params.stressRelief.min, params.stressRelief.max)
        addHunger(sustenance)
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

-- Added for ox_inv until I make a proper qbx bridge
RegisterNetEvent('consumables:server:addThirst', addThirst)

RegisterNetEvent('consumables:server:addHunger', addHunger)
