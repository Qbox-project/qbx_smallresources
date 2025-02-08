
local config = require 'qbx_entitiesblacklist.config'

Citizen.CreateThread(function()
    while true do
        if config.settings.bucketLockDownMode ~= 'inactive' then
            local playerPed = GetPlayerPed(-1)
            local vehicles = GetGamePool('CVehicle')
            for _, vehicle in ipairs(vehicles) do
                local model = GetEntityModel(vehicle)
                if config.blacklisted[model] then
                    DeleteEntity(vehicle)
                end
            end
            local peds = GetGamePool('CPed')
            for _, ped in ipairs(peds) do
                if ped ~= playerPed then 
                    local model = GetEntityModel(ped)
                    if config.blacklisted[model] then
                        DeleteEntity(ped)
                    end
                end
            end
        end
        Citizen.Wait(config.settings.cleanupInterval)
    end
end)
