local config = lib.loadJson('qbx_vehicleradio.config')
local radioEnabled = not config.disableRadioByDefault

RegisterCommand(config.toggleCommand, function()
    local currentVehicle = cache.vehicle
    if not currentVehicle or currentVehicle == 0 then
        return
    end

    radioEnabled = not radioEnabled

    if radioEnabled then
        exports.qbx_core:Notify(locale('success.vehicle_radio_on'), 'success')
        SetUserRadioControlEnabled(true)
    else
        exports.qbx_core:Notify(locale('error.vehicle_radio_off'), 'error')
        SetVehRadioStation(currentVehicle, "OFF")
        SetUserRadioControlEnabled(false)
    end
end, false)

if config.toggleKey then
    RegisterKeyMapping(config.toggleCommand, "Toggle Vehicle Radio", "keyboard", config.toggleKey)
end

lib.onCache('vehicle', function(currentVehicle)
    if currentVehicle and currentVehicle ~= 0 then
        SetUserRadioControlEnabled(radioEnabled)
        if not radioEnabled then
            SetVehRadioStation(currentVehicle, "OFF")
        end
    else
        SetUserRadioControlEnabled(true)
    end
end)