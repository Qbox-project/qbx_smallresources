local config = require 'qbx_consumables.config'

---hotfix: remove when qbx_core issue #470 fixed https://github.com/Qbox-project/qbx_core/issues/470
---Enforces synchronization of player's hunger or thirst metadata with value from statebag
---@param source number
---@param amount number inverted, lower == more
---@param type string
local function metadataSyncHotfix(source, amount, type)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    player.Functions.SetMetaData(type, amount)
end
---hotfix

---Set player's hunger state to 'amount'
---@param source number
---@param amount number inverted, lower == more hungry
local function setHunger(source, amount)
    amount = lib.math.clamp(amount, 0, 100)
    Player(source).state.hunger = amount

    metadataSyncHotfix(source, amount, 'hunger')
end

---Increment player's hunger state by 'amount'
---@param source number
---@param amount number inverted, lower == more hungry
local function addHunger(source, amount)
    local hunger = Player(source).state.hunger or 0
    setHunger(source, hunger + amount)
end

---Set player's thirst state to 'amount'
---@param source number
---@param amount number inverted, lower == more thirsty
local function setThirst(source, amount)
    amount = lib.math.clamp(amount, 0, 100)
    Player(source).state.thirst = amount

    metadataSyncHotfix(source, amount, 'thirst')
end

---Increment player's thirst state by 'amount'
---@param source number
---@param amount number inverted, lower == more thirsty
local function addThirst(source, amount)
    local thirst = Player(source).state.thirst or 0
    setThirst(source, thirst + amount)
end

---Relieve a random amount of stress from the player's state
---@param source number
---@param min number lower limit for random generation
---@param max number upper limit for rancom generation
local function relieveStress(source, min, max)
    local playerState = Player(source).state
    local verifiedMin = (type(min) == "number" and min) or config.defaultStressRelief.min
    local verifiedMax = max or config.defaultStressRelief.max
    local amount = math.random(verifiedMin, verifiedMax)
    local newStress = (playerState.stress or 0) - amount
    newStress = lib.math.clamp(newStress, 0, 100)

    playerState:set("stress", newStress, true)
    if amount < 0 then
        exports.qbx_core:Notify(source, locale('error.stress_gain'), 'inform', 2500, nil, nil, { '#141517', '#ffffff' }, 'brain', '#C53030')
    else
        exports.qbx_core:Notify(source, locale('success.stress_relief'), 'inform', 2500, nil, nil, { '#141517', '#ffffff' }, 'brain', '#0F52BA')
    end
end

for alcohol, params in pairs(config.consumables.alcohol) do
    exports.qbx_core:CreateUseableItem(alcohol, function(source, item)
        local drank = lib.callback.await('consumables:client:DrinkAlcohol', source, params.alcoholLevel, params.anim, params.prop)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = math.random(params.min, params.max)
        relieveStress(source, params.stressRelief.min, params.stressRelief.max)

        addThirst(source, sustenance)
    end)
end

for drink, params in pairs(config.consumables.drink) do
    exports.qbx_core:CreateUseableItem(drink, function(source, item)
        local drank = lib.callback.await('consumables:client:Drink', source, params.anim, params.prop)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = math.random(params.min, params.max)
        relieveStress(source, params.stressRelief.min, params.stressRelief.max)

        addThirst(source, sustenance)
    end)
end

for food, params in pairs(config.consumables.food) do
    exports.qbx_core:CreateUseableItem(food, function(source, item)
        local ate = lib.callback.await('consumables:client:Eat', source, params.anim, params.prop)
        if not ate then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end

        local sustenance = math.random(params.min, params.max)
        relieveStress(source, params.stressRelief.min, params.stressRelief.max)

        addHunger(source, sustenance)
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

---Set player's hunger state to 'amount'
---@param amount number
RegisterNetEvent('consumables:server:setHunger', function(amount)
    --Make sure this can only be triggered from the client
    if not GetInvokingResource() then setHunger(source, amount) end
end)

---Increment player's hunger state by 'amount'
---@param amount number new hunger level
RegisterNetEvent('consumables:server:addHunger', function(amount)
    local resource = GetInvokingResource()
    --handles calls from ox_inventory's QB bridge, using improper QB nomenclature
    --todo remove upon merger of a proper qbx bridge to ox_inventory
    if resource == 'ox_inventory' then
        setHunger(source, amount)
    --Make sure this can only be triggered from the client
    elseif not resource then
        addHunger(source, amount)
    end
end)

---Set player's thirst state to 'amount'
---@param amount number
RegisterNetEvent('consumables:server:setThirst', function(amount)
    --Make sure this can only be triggered from the client
    if not GetInvokingResource() then setThirst(source, amount) end
end)

---Increment player's thirst state by 'amount'
---@param amount number new thirst level
RegisterNetEvent('consumables:server:addThirst', function(amount)
    local resource = GetInvokingResource()
    --handles calls from ox_inventory's QB bridge, using improper QB nomenclature
    --todo remove upon merger of a proper qbx bridge to ox_inventory
    if resource == 'ox_inventory' then
        setThirst(source, amount)
    --Make sure this can only be triggered from the client
    elseif not resource then
        addThirst(source, amount)
    end
end)

---@deprecated use SetHunger instead
exports('setHunger', setHunger)
---@deprecated use AddHunger instead
exports('addHunger', addHunger)
---@deprecated use SetThirst instead
exports('setThirst', setThirst)
---@deprecated use AddThirst instead
exports('addThirst', addThirst)

exports('SetHunger', setHunger)
exports('AddHunger', addHunger)
exports('SetThirst', setThirst)
exports('AddThirst', addThirst)
