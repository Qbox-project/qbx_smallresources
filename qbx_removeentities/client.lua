local config = lib.loadJson('qbx_removeentities.config')

CreateThread(function()
    while true do
        for _, obj in ipairs(config.objects) do
            local ent = GetClosestObjectOfType(obj.coords[1], obj.coords[2], obj.coords[3], 2.0, obj.hash, false, false, false)
            if DoesEntityExist(ent) then
                SetEntityAsMissionEntity(ent, true, true)
                DeleteObject(ent)
                SetEntityAsNoLongerNeeded(ent)
                SetModelAsNoLongerNeeded(obj.hash)
            end
        end

        Wait(5000)
    end
end)
