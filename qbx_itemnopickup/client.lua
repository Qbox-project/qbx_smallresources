CreateThread(function()
    local config = lib.loadJson('config')

    for _, hash in ipairs(config.disabledPickups) do
        ToggleUsePickupsForPlayer(cache.playerId, hash, false)
    end
end)
