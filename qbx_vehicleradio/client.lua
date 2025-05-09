local config = lib.loadJson('qbx_vehicleradio.config')
local radioEnabled = not config.disableRadioByDefault
local isInVehicle = false

RegisterCommand(config.toggleCommand, function()
    local playerPed = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)

    if currentVehicle == 0 then
        return
    end

    radioEnabled = not radioEnabled

    if radioEnabled then
        exports.qbx_core:Notify('Vehicle radio is now ON', 'success')
        SetUserRadioControlEnabled(true)
    else
        exports.qbx_core:Notify('Vehicle radio is now OFF', 'error')
        SetVehRadioStation(currentVehicle, "OFF")
        SetUserRadioControlEnabled(false)
    end
end, false)

if config.toggleKey then
    RegisterKeyMapping(config.toggleCommand, "Toggle Vehicle Radio", "keyboard", config.toggleKey)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)

        if currentVehicle ~= 0 then
            if not isInVehicle then
                isInVehicle = true
                SetUserRadioControlEnabled(radioEnabled)
                if not radioEnabled then
                    SetVehRadioStation(currentVehicle, "OFF")
                end
            end

            if not radioEnabled and GetPlayerRadioStationName() ~= nil then
                SetVehRadioStation(currentVehicle, "OFF")
            end
        else
            isInVehicle = false
        end

        Citizen.Wait(500)
    end
end)