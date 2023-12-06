lib.callback.register('consumables:server:AddHunger', function(source, item)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)

    if not Player then return false end

    if Player.Functions.RemoveItem(item, 1) then
        local hunger = Player.PlayerData.metadata['hunger'] + (Config.ConsumablesEat[item].fill or 0)
        hunger = hunger > 100 and 100 or hunger
        Player.Functions.SetMetaData('hunger', hunger)
        TriggerClientEvent('hud:client:UpdateNeeds', src, hunger, Player.PlayerData.metadata.thirst)
        return true
    end

    return false
end)

lib.callback.register('consumables:server:AddThirst', function(source, item)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)

    if not Player then return false end

    if Player.Functions.RemoveItem(item, 1) then
        local thirst = Player.PlayerData.metadata['thirst'] +  (Config.ConsumablesDrink[item].fill or 0)
        thirst = thirst > 100 and 100 or thirst
        Player.Functions.SetMetaData('thirst', thirst)
        TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger, thirst)
        return true
    end

    return false
end)

lib.callback.register('consumables:server:useIllegal', function(source, item)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)

    if not Player then return false end
    if Player.Functions.RemoveItem(item, 1) then
        if Config.ConsumablesAddiction[item].fill then
            if Config.ConsumablesAddiction[item].filltype == 'hunger' then
                local hunger = Player.PlayerData.metadata['hunger'] + (Config.ConsumablesAddiction[item].fill or 0)
                hunger = hunger > 100 and 100 or hunger
                Player.Functions.SetMetaData('hunger', hunger)
                TriggerClientEvent('hud:client:UpdateNeeds', src, hunger, Player.PlayerData.metadata.thirst)
            elseif Config.ConsumablesAddiction[item].filltype == 'thirst' then
                local thirst = Player.PlayerData.metadata['thirst'] +  (Config.ConsumablesAddiction[item].fill or 0)
                thirst = thirst > 100 and 100 or thirst
                Player.Functions.SetMetaData('thirst', thirst)
                TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger, thirst)
            end
        end
        return true
    end
    return false
end)

lib.callback.register('consumables:server:useItem', function(source, item)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)

    if not Player then return false end

    if not Config.ConsumablesItems[item].removeItem then return true end

    if Player.Functions.RemoveItem(item, 1) then
        return true
    end
    return false
end)

-- Add CreateUseable Events

----------- / alcohol
for k,_ in pairs(Config.ConsumablesAddiction) do
    exports.qbx_core:CreateUseableItem(k, function(source, item)
        TriggerClientEvent("consumables:client:Addiction", source, item.name)
    end)
end

----------- / Eat
for k,_ in pairs(Config.ConsumablesEat) do
    exports.qbx_core:CreateUseableItem(k, function(source, item)
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end)
end

----------- / Drink
for k,_ in pairs(Config.ConsumablesDrink) do
    exports.qbx_core:CreateUseableItem(k, function(source, item)
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end)
end

----------- / Item
for k,_ in pairs(Config.ConsumablesItems) do
    exports.qbx_core:CreateUseableItem(k, function(source, item)
        local consume = Config.ConsumablesItems[item.name]
        if consume.event then
            TriggerClientEvent(consume.event, source, consume.args or nil)
        elseif consume.serverEvent then
            TriggerEvent(consume.serverEvent, source, consume.args or nil)
        else
            TriggerClientEvent("consumables:client:Item", source, item.name)
        end
    end)
end


----------- / external useable item
local function CreateItem(name,type)
    exports.qbx_core:CreateUseableItem(name, function(source, item)
        TriggerClientEvent("consumables:client:"..type, source, item.name)
    end)
end

local function AddDrink(drinkname, replenish)
    if Config.ConsumablesDrink[drinkname] ~= nil then
        return {false, "already added"}
    else
        Config.ConsumablesDrink[drinkname] = replenish
        CreateItem(drinkname, 'Drink')
        return {true, "success"}
    end
end

exports('AddDrink', AddDrink)

local function AddFood(foodname, replenish)
    if Config.ConsumablesEat[foodname] ~= nil then
        return {false, "already added"}
    else
        Config.ConsumablesEat[foodname] = replenish
        CreateItem(foodname, 'Eat')
        return {true, "success"}
    end
end

exports('AddFood', AddFood)

local function Addiction(alcoholname, replenish)
    if Config.ConsumablesAlcohol[alcoholname] ~= nil then
        return {false, "already added"}
    else
        Config.ConsumablesAlcohol[alcoholname] = replenish
        CreateItem(alcoholname, 'Addiction')
        return {true, "success"}
    end
end

exports('Addiction', Addiction)

lib.addCommand('adminheal', {
    help = 'Admin heal command',
    params = {},
    restricted = 'group.admin'
}, function(source, args, raw)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return false end
    Player.Functions.SetMetaData('hunger', 100)
    Player.Functions.SetMetaData('thirst', 100)
    TriggerClientEvent('hud:client:UpdateNeeds', src, 100, 100)
end)

lib.addCommand('adminremove', {
    help = 'Admin Thirsty command',
    params = {},
    restricted = 'group.admin'
}, function(source, args, raw)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return false end
    Player.Functions.SetMetaData('hunger', 10)
    Player.Functions.SetMetaData('thirst', 10)
    TriggerClientEvent('hud:client:UpdateNeeds', src, 10, 10)
end)

lib.addCommand("removeparachute", {
    help = 'Take off your Parachute',
    params = {},
}, function(source)
    TriggerClientEvent("consumables:client:ResetParachute", source)
end)

RegisterNetEvent('consumables:server:AddParachute', function()
    local Player = exports.qbx_core:GetPlayer(source)

    if not Player then return end

    Player.Functions.AddItem("parachute", 1)
end)