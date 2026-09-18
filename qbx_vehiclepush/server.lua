RegisterNetEvent('qbx_vehiclepush:server:push', function(data)
    if type(data) ~= 'table' or math.type(data.netId) ~= 'integer' then return end
    if data.direction ~= nil and data.direction ~= 'left' and data.direction ~= 'right' and data.direction ~= 'front' and data.direction ~= 'back' then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.netId)
    if not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 then return end

    local ped = GetPlayerPed(source)
    if ped == 0 or GetVehiclePedIsIn(ped, false) ~= 0 then return end
    if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 5.0 then return end
    if GetPedInVehicleSeat(vehicle, -1) ~= 0 then return end

    Entity(vehicle).state:set('pushVehicle', data.direction, true)
end)
