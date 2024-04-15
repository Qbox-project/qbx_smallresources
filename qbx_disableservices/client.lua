CreateThread(function()
    local config = lib.loadJson('config')

    for key, value in ipairs(config.enabledServices) do
        EnableDispatchService(key, value)
    end

    SetMaxWantedLevel(config.maxWantedLevel)
end)
