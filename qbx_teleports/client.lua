local config = lib.loadJson('qbx_teleports.config')

CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        local pedCoords = GetEntityCoords(cache.ped)

        for _, passage in ipairs(config.teleports) do
            passage[1].coords = vec4(passage[1].coords)
            passage[2].coords = vec4(passage[2].coords)
            for k, v in ipairs(passage) do
                local dist = #(pedCoords - v.coords.xyz)
                if dist < 2 then
                    sleep = 0
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, false, false, 0, true, nil, nil, false)

                    if dist < 1 then
                        qbx.drawText3d({ text = v.drawText, coords = v.coords})
                        if IsControlJustReleased(0, 51) then
                            local i = k % 2 + 1
                            local dstCoords = passage[i].coords
                            if v.allowVehicle then
                                SetPedCoordsKeepVehicle(cache.ped, dstCoords.x, dstCoords.y, dstCoords.z)
                            else
                                SetEntityCoords(cache.ped, dstCoords.x, dstCoords.y, dstCoords.z, true, false, false, false)
                            end

                            if type(dstCoords) == 'vector4' then
                                SetEntityHeading(cache.ped, dstCoords.w)
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
