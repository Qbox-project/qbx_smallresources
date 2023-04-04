lib.onCache('vehicle', function(vehicle)
    if vehicle and GetPedInVehicleSeat(vehicle, cache.seat) == cache.ped then
        SetPedIntoVehicle(cache.ped, vehicle, cache.seat)
        SetPedConfigFlag(cache.ped, 184, true)
    end
end)