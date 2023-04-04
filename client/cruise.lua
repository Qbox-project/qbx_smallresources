local QBCore = exports['qbx-core']:GetCoreObject()
local CruisedSpeed = 0
local vehicleClasses = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = false,
    [14] = false,
    [15] = false,
    [16] = false,
    [17] = true,
    [18] = true,
    [19] = true,
    [20] = true,
    [21] = false
}

local function TriggerCruiseControl()
    if CruisedSpeed == 0 and cache.seat == -1 then
        CruisedSpeed = GetEntitySpeed(cache.vehicle)

        if CruisedSpeed > 0 and GetVehicleCurrentGear(cache.vehicle) > 0 then
            local cruiseSpeed = CruisedSpeed * 2.23694

            TriggerEvent('seatbelt:client:ToggleCruise')
            QBCore.Functions.Notify('Cruise control enabled!', 'success')

            CreateThread(function()
                while CruisedSpeed > 0 and cache.vehicle do
                    Wait(0)
                    local speed = GetEntitySpeed(cache.vehicle)
                    local turningOrBraking = IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64)

                    if not turningOrBraking and speed < (CruisedSpeed - 1.5) then
                        CruisedSpeed = 0
                        TriggerEvent('seatbelt:client:ToggleCruise')
                        QBCore.Functions.Notify('Cruise control disabled!', 'error')
                        Wait(500)
                        break
                    end

                    if not turningOrBraking and IsVehicleOnAllWheels(cache.vehicle) and speed < CruisedSpeed then
                        SetVehicleForwardSpeed(cache.vehicle, CruisedSpeed)
                    end

                    if IsControlJustPressed(1, 246) then
                        TriggerEvent('seatbelt:client:ToggleCruise')
                        CruisedSpeed = GetEntitySpeed(cache.vehicle)
                    end

                    if IsControlJustPressed(2, 72) then
                        CruisedSpeed = 0
                        TriggerEvent('seatbelt:client:ToggleCruise')
                        QBCore.Functions.Notify('Cruise control disabled!', 'error')
                        Wait(500)
                        break
                    end
                end
            end)
        end
    end
end

RegisterCommand('togglecruise', function()
    local vehicleClass = GetVehicleClass(cache.vehicle)

    if cache.seat == -1 then
        if vehicleClasses[vehicleClass] then
            TriggerCruiseControl()
        else
            QBCore.Functions.Notify('Cruise control unavailable', 'error')
        end
    end
end, false)

RegisterKeyMapping('togglecruise', 'Toggle Cruise Control', 'keyboard', 'y')
