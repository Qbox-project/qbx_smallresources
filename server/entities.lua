local config = require 'config.server'
local bucketLockDownMode = GetConvar('qbx:bucketlockdownmode', 'relaxed')

-- If you want to blacklist peds and vehicles from certaiin locations utilize Car gens ymaps as done in streams/car_gen_disablers, as entityCreating handler is very expensive compared to ymap.
if bucketLockDownMode == 'inactive' then return end

-- Blacklisting entities can just be handled entirely server side with onesync events
-- No need to run coroutines to supress or delete these when we can simply delete them before they spawn
AddEventHandler('entityCreating', function(handle)
    local entityModel = GetEntityModel(handle)

    if config.blacklisted.vehicles[entityModel] or config.blacklisted.peds[entityModel] then
        CancelEvent()
    end
end)
