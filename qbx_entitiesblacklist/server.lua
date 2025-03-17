local config = require 'qbx_entitiesblacklist.config'
-- Blacklisting entities can just be handled entirely server side with onesync events
-- No need to run coroutines to supress or delete these when we can simply delete them before they spawn
AddEventHandler('entityCreating', function(handle)
    local entityModel = GetEntityModel(handle)

    if config.blacklisted[entityModel] then
        lib.print.warning('[qbx_smallresources] Blocked entity creation for model: ' .. entityModel)
        CancelEvent()
    end
end)