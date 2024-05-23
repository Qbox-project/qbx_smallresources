CreateThread(function()
    local config = lib.loadJson('qbx_vehiclepush.config')

    while true do
        Wait(1000)
        local pedCoords = GetEntityCoords(cache.ped)
        local vehicle, vehicleCoords = lib.getClosestVehicle(pedCoords, 3.0)

        if vehicle and vehicleCoords and not cache.vehicle then
            local vehicleClass = GetVehicleClass(vehicle)
            local isValidVehicle = vehicleClass ~= 13 and vehicleClass ~= 14 and vehicleClass ~= 15 and vehicleClass ~= 16

            if isValidVehicle and IsVehicleSeatFree(vehicle, -1)
               and ((GetVehicleEngineHealth(vehicle) >= 0
               and GetVehicleEngineHealth(vehicle) <= config.damageNeeded)
               or (Entity(vehicle).state.fuel or 100) < 3) then
                while true do
                    Wait(0)

                    qbx.drawText3d({ text = locale('actions.push_vehicle'), coords = vehicleCoords })

                    if IsControlPressed(0, 21)
                       and not IsEntityAttachedToEntity(cache.ped, vehicle)
                       and IsControlJustPressed(0, 38) then

                        NetworkRequestControlOfEntity(vehicle)

                        local boneIndex = GetPedBoneIndex(cache.ped, 6286)
                        local dimensions = GetModelDimensions(GetEntityModel(vehicle))
                        local vehicleForwardVector = GetEntityForwardVector(vehicle)
                        local isInFront = #(vehicleCoords - pedCoords + vehicleForwardVector) <
                                          #(vehicleCoords - pedCoords - vehicleForwardVector)

                        if isInFront then
                            AttachEntityToEntity(cache.ped, vehicle, boneIndex, 0.0,
                            dimensions.y * -1 + 0.1, dimensions.z + 1.0, 0.0, 0.0, 180.0, false, false, false, true, 0, true)
                        else
                            AttachEntityToEntity(cache.ped, vehicle, boneIndex, 0.0,
                            dimensions.y - 0.3, dimensions.z + 1.0, 0.0, 0.0, 0.0, false, false, false, true, 0, true)
                        end

                        lib.requestAnimDict('missfinale_c2ig_11')
                        TaskPlayAnim(cache.ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)

                        while true do
                            Wait(0)
                            if IsDisabledControlPressed(0, 34) then
                                TaskVehicleTempAction(cache.ped, vehicle, 11, 1)
                            end

                            if IsDisabledControlPressed(0, 9) then
                                TaskVehicleTempAction(cache.ped, vehicle, 10, 1)
                            end

                            SetVehicleForwardSpeed(vehicle, isInFront and -1.0 or 1.0)

                            if HasEntityCollidedWithAnything(vehicle) then
                                SetVehicleOnGroundProperly(vehicle)
                            end

                            if cache.vehicle or not IsDisabledControlPressed(0, 21) then
                                DetachEntity(cache.ped, false, false)
                                StopAnimTask(cache.ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                                FreezeEntityPosition(cache.ped, false)
                                break
                            end
                        end
                    end

                    vehicleCoords = GetEntityCoords(vehicle)
                    pedCoords = GetEntityCoords(cache.ped)
                    if cache.vehicle
                       or #(pedCoords - vehicleCoords) > 3
                       or not IsVehicleSeatFree(vehicle, -1)
                       or not ((GetVehicleEngineHealth(vehicle) >= 0
                       and GetVehicleEngineHealth(vehicle) <= config.damageNeeded)
                       or (Entity(vehicle).state.fuel or 100) < 3)
                    then break end
                end
            end
        end
    end
end)
