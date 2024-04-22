local config = lib.loadJson('qbx_itempickup.config')

CreateThread(function()
    for _, hash in ipairs(config.disabledPickups) do
        ToggleUsePickupsForPlayer(cache.playerId, hash, false)
    end
end)
