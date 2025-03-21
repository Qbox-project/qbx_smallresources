local config = require 'qbx_entitiesblacklist.config'
local bucketLockDownMode = GetConvar('qbx:bucketlockdownmode', 'relaxed')
-- If you want to blacklist peds and vehicles from certaiin locations utilize Car gens ymaps as done in streams/car_gen_disablers, as entityCreating handler is very expensive compared to ymap.
if bucketLockDownMode ~= 'inactive' or table.type(config.blacklisted) == 'empty' then return end
lib.print.warn('[qbx_entitiesblacklist] You have entity blacklist enabled, this means that any entity that is blacklisted in config.lua will not be able to spawn, you can change this in qbx_smallresource/qbx_entitiesblacklist/config.lua')
-- Blacklisting entities can just be handled entirely server side with onesync events
-- No need to run coroutines to supress or delete these when we can simply delete them before they spawn
if type(config.blacklisted) ~= 'table' then
    lib.print.warning('[qbx_entitiesblacklist] Blacklisted vehicles is not a table')
    return
end

AddEventHandler('entityCreating', function(handle)
    local entityModel = GetEntityModel(handle)

    if config.blacklisted[entityModel] then
        CancelEvent()
    end
end)