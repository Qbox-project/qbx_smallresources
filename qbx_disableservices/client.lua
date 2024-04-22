local config = lib.loadJson('qbx_disableservices.config')

CreateThread(function()
    for key, value in ipairs(config.enabledServices) do
        EnableDispatchService(key, value)
    end

    SetMaxWantedLevel(config.maxWantedLevel)
end)
