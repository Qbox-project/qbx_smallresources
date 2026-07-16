local lastTackle = {}

RegisterNetEvent('tackle:server:TacklePlayer', function(target)
    local src = source
    if math.type(target) ~= 'integer' or target == src then return end

    local now = GetGameTimer()
    if lastTackle[src] and now - lastTackle[src] < 1000 then return end

    local srcPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(target)
    if srcPed == 0 or targetPed == 0 then return end
    if GetVehiclePedIsIn(srcPed, false) ~= 0 or GetVehiclePedIsIn(targetPed, false) ~= 0 then return end

    local srcCoords = GetEntityCoords(srcPed)
    local targetCoords = GetEntityCoords(targetPed)

    if #(srcCoords - targetCoords) > 2.0 then return end

    lastTackle[src] = now
    TriggerClientEvent('tackle:client:GetTackled', target)
end)

AddEventHandler('playerDropped', function()
    lastTackle[source] = nil
end)
