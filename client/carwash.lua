local QBCore = exports['qb-core']:GetCoreObject()
local washingVehicle = false

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x,y,z, 0)
    EndTextCommandDisplayText(0.0, 0.0)

    local factor = (string.len(text)) / 370

    DrawRect(0.0, 0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)

    ClearDrawOrigin()
end

RegisterNetEvent('qb-carwash:client:washCar', function()
    local PedVehicle = GetVehiclePedIsIn(cache.ped, false)

    washingVehicle = true

    QBCore.Functions.Progressbar("search_cabin", "Vehicle is being washed ..", math.random(4000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
    }, {}, {}, {}, function() -- Done
        SetVehicleDirtLevel(PedVehicle, 0.0)
        SetVehicleUndriveable(PedVehicle, false)
        WashDecalsFromVehicle(PedVehicle, 1.0)

        washingVehicle = false
    end, function() -- Cancel
        lib.notify({
            description = "Washing canceled ..",
            type = 'error'
        })

        washingVehicle = false
    end)
end)

CreateThread(function()
    local sleep

    while true do
        local PlayerPos = GetEntityCoords(cache.ped)
        local PedVehicle = GetVehiclePedIsIn(cache.ped, false)
        local Driver = GetPedInVehicleSeat(PedVehicle, -1)
        local dirtLevel = GetVehicleDirtLevel(PedVehicle)

        sleep = 1000

        if IsPedInAnyVehicle(cache.ped, false) then
            for k in pairs(Config.CarWash) do
                local dist = #(PlayerPos - vec3(Config.CarWash[k]["coords"]["x"], Config.CarWash[k]["coords"]["y"], Config.CarWash[k]["coords"]["z"]))

                if dist <= 7.5 and Driver == cache.ped then
                    sleep = 0

                    if not washingVehicle then
                        DrawText3Ds(Config.CarWash[k]["coords"]["x"], Config.CarWash[k]["coords"]["y"], Config.CarWash[k]["coords"]["z"], '~g~E~w~ - Washing car ($'..Config.DefaultPrice..')')

                        if IsControlJustPressed(0, 38) then
                            if dirtLevel > Config.DirtLevel then
                                TriggerServerEvent('qb-carwash:server:washCar')
                            else
                                lib.notify({
                                    description = "The vehicle isn't dirty",
                                    type = 'error'
                                })
                            end
                        end
                    else
                        DrawText3Ds(Config.CarWash[k]["coords"]["x"], Config.CarWash[k]["coords"]["y"], Config.CarWash[k]["coords"]["z"], 'The car wash is not available ..')
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    for k in pairs(Config.CarWash) do
        local carWash = AddBlipForCoord(Config.CarWash[k]["coords"]["x"], Config.CarWash[k]["coords"]["y"], Config.CarWash[k]["coords"]["z"])

        SetBlipSprite(carWash, 100)
        SetBlipDisplay(carWash, 4)
        SetBlipScale(carWash, 0.75)
        SetBlipAsShortRange(carWash, true)
        SetBlipColour(carWash, 37)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.CarWash[k]["label"])
        EndTextCommandSetBlipName(carWash)
    end
end)