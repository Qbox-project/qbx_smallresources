RegisterNetEvent('qbx_vehiclepush:server:push', function(data)
    local vehicle = NetworkGetEntityFromNetworkId(data.netId)
    if not DoesEntityExist(vehicle) then return end

    Entity(vehicle).state:set('pushVehicle', data.direction, true)
end)