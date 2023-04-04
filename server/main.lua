local QBCore = exports['qbx-core']:GetCoreObject()
local VehicleNitrous = {}

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent('tackle:client:GetTackled', playerId)
end)

QBCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(_, cb)
    cb(VehicleNitrous)
end)

QBCore.Commands.Add('id', 'Check Your ID #', {}, false, function(source)
    TriggerClientEvent('QBCore:Notify', source,  'ID: '..source)
end)

QBCore.Functions.CreateUseableItem('harness', function(source, item)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if item.metadata.harnessuses == nil then
        item.metadata.harnessuses = 19
        exports.ox_inventory:SetMetadata(src, item.slot, item.metadata)
    elseif item.metadata.harnessuses == 1 then
        exports.ox_inventory:RemoveItem(src, 'harness', 1)
    else
        item.metadata.harnessuses -= 1
        exports.ox_inventory:SetMetadata(src, item.slot, item.metadata)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local harness = exports.ox_inventory:Search(src, 1, 'harness')

    if not Player then return end

    if hp == 0 then
        exports.ox_inventory:RemoveItem(src, 'harness', 1, data.metadata, data.slot)
    else
        harness.metadata.harnessuses -= 1
        exports.ox_inventory:SetMetadata(src, harness.slot, harness.metadata)
    end
end)

RegisterNetEvent('qb-carwash:server:washCar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, 'car-washed') then
        TriggerClientEvent('qb-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, 'car-washed') then
        TriggerClientEvent('qb-carwash:client:washCar', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You dont have enough money..', 'error')
    end
end)
