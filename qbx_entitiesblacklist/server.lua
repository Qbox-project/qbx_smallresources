local config = require 'qbx_entitiesblacklist.config'
if config.settings.bucketLockDownMode == 'inactive' or table.type(config.blacklisted) == 'empty' then 
    return 
end

AddEventHandler('entityCreating', function(handle)
    local entityModel = GetEntityModel(handle)
    if config.blacklisted[entityModel] then
        CancelEvent()
    end
end)