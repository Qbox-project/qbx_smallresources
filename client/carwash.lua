local washingVehicle = false

RegisterNetEvent('qb-carwash:client:washCar', function()
    washingVehicle = true
    if lib.progressBar({
        duration = math.random(4000, 8000),
        label = 'Vehicle is being washed...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true
        },
    }) then -- if completed
        SetVehicleDirtLevel(cache.vehicle, 0.0)
        SetVehicleUndriveable(cache.vehicle, false)
        WashDecalsFromVehicle(cache.vehicle, 1.0)
        washingVehicle = false
    else -- if cancel
        QBCore.Functions.Notify('Washing canceled...', 'error')
        washingVehicle = false
    end
end)

CreateThread(function()
    while true do
        local playerPos = GetEntityCoords(cache.ped)
        local driver = cache.seat == -1
        local dirtLevel = GetVehicleDirtLevel(cache.vehicle)
        local sleep = 1000
        if IsPedInAnyVehicle(cache.ped, false) then
            for i = 1, #Config.CarWash.locations do
                local carWashCoords = Config.CarWash.locations[i]
                local dist = #(playerPos - carWashCoords)
                if dist <= 7.5 and driver then
                    sleep = 0
                    if not washingVehicle then
                        DrawText3D('~g~E~w~ - Wash the car ($'..Config.CarWash.defaultPrice..')', carWashCoords)
                        if IsControlJustPressed(0, 38) then
                            if dirtLevel > Config.CarWash.dirtLevel then
                                TriggerServerEvent('qb-carwash:server:washCar')
                            else
                                QBCore.Functions.Notify('The vehicle isn\'t dirty', 'error')
                            end
                        end
                    else
                        DrawText3D('The car wash is not available...', carWashCoords)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    for k in pairs(Config.CarWash.locations) do
        local carWash = AddBlipForCoord(Config.CarWash.locations[k].coords.x, Config.CarWash.locations[k].coords.y, Config.CarWash.locations[k].coords.z)
        SetBlipSprite (carWash, 100)
        SetBlipDisplay(carWash, 4)
        SetBlipScale  (carWash, 0.75)
        SetBlipAsShortRange(carWash, true)
        SetBlipColour(carWash, 37)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.CarWash.locations[k].label)
        EndTextCommandSetBlipName(carWash)
    end
end)