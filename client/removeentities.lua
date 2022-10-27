local objects = {
    { coords = vector3(266.09, -349.35, 44.74), hash = `prop_sec_barier_02b` },
    { coords = vector3(285.28, -355.78, 45.13), hash = `prop_sec_barier_02a` },
}

CreateThread(function()
    while true do
        for k in pairs(objects) do
            local ent = GetClosestObjectOfType(objects[k].coords.x, objects[k].coords.y, objects[k].coords.z, 2.0, objects[k].hash, false, false, false)
            if DoesEntityExist(ent) then
                SetEntityAsMissionEntity(ent, true, true)
                DeleteObject(ent)
                SetEntityAsNoLongerNeeded(ent)
                SetModelAsNoLongerNeeded(objects[k].hash)
            end
        end

        Wait(5000)
    end
end)
