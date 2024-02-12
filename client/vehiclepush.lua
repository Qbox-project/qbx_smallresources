local config = require 'config.client'

local Vehicle = {
    Coords = nil,
    Vehicle = nil,
    Dimension = nil,
    IsInFront = false
}

CreateThread(function()
    while true do
        Wait(1000)
        local pos = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(pos, 3.0)
        if vehicle and vehicle ~= 0 then
            local vehpos = GetEntityCoords(vehicle)
            local dimension = GetModelDimensions(GetEntityModel(vehicle))

            if #(pos - vehpos) < 3.0 and not IsPedInAnyVehicle(cache.ped, false) then
                Vehicle.Coords = vehpos
                Vehicle.Dimensions = dimension
                Vehicle.Vehicle = vehicle
                if #(vehpos + GetEntityForwardVector(vehicle) - pos) >
                    #(vehpos + GetEntityForwardVector(vehicle) * -1 - pos) then
                    Vehicle.IsInFront = false
                else
                    Vehicle.IsInFront = true
                end
            else
                Vehicle = {
                    Coords = nil,
                    Vehicle = nil,
                    Dimensions = nil,
                    IsInFront = false
                }
            end
        end
    end
end)

CreateThread(function()
    local sleep
    while true do
        sleep = 250
        local pos = GetEntityCoords(cache.ped)
        if Vehicle.Vehicle and #(pos - Vehicle.Coords) < 3.5 then
            local vehClass = GetVehicleClass(Vehicle.Vehicle)
            sleep = 0

            if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= config.damageNeeded and GetVehicleEngineHealth(Vehicle.Vehicle) >= 0 then
                if vehClass ~= 13 or vehClass ~= 14 or vehClass ~= 15 or vehClass ~= 16 then
                    qbx.drawText3d({ text = 'Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle', coords = Vehicle.Coords})
                end
            end

            if IsControlPressed(0, 21) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and
                not IsEntityAttachedToEntity(cache.ped, Vehicle.Vehicle) and IsControlJustPressed(0, 38) and
                GetVehicleEngineHealth(Vehicle.Vehicle) <= config.damageNeeded then
                NetworkRequestControlOfEntity(Vehicle.Vehicle)
                if Vehicle.IsInFront then
                    AttachEntityToEntity(cache.ped, Vehicle.Vehicle, GetPedBoneIndex(cache.ped, 6286), 0.0,
                        Vehicle.Dimensions.y * -1 + 0.1, Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, false, false, false,
                        true, 0, true)
                else
                    AttachEntityToEntity(cache.ped, Vehicle.Vehicle, GetPedBoneIndex(cache.ped, 6286), 0.0,
                        Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 0.0, false, false, false, true,
                        0, true)
                end

                lib.requestAnimDict('missfinale_c2ig_11')
                TaskPlayAnim(cache.ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)
                Wait(200)

                local currentVehicle = Vehicle.Vehicle
                while true do
                    Wait(0)
                    if IsDisabledControlPressed(0, 34) then
                        TaskVehicleTempAction(cache.ped, currentVehicle, 11, 1000)
                    end

                    if IsDisabledControlPressed(0, 9) then
                        TaskVehicleTempAction(cache.ped, currentVehicle, 10, 1000)
                    end

                    if Vehicle.IsInFront then
                        SetVehicleForwardSpeed(currentVehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(currentVehicle, 1.0)
                    end

                    if HasEntityCollidedWithAnything(currentVehicle) then
                        SetVehicleOnGroundProperly(currentVehicle)
                    end

                    if not IsDisabledControlPressed(0, 38) then
                        DetachEntity(cache.ped, false, false)
                        StopAnimTask(cache.ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                        FreezeEntityPosition(cache.ped, false)
                        break
                    end
                end
            end
        end
        Wait(sleep)
    end
end)