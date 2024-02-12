local config = require 'config.client'

CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        local pos = GetEntityCoords(cache.ped)

        for loc in pairs(config.teleports) do
            for k, v in pairs(config.teleports[loc]) do
                local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                if dist < 2 then
                    sleep = 0
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, false, false, 0, true, nil, nil, false)

                    if dist < 1 then
                        qbx.drawText3d({ text = v.drawText, coords = v.coords})
                        if IsControlJustReleased(0, 51) then
                            if k == 1 then
                                if v.allowVehicle then
                                    SetPedCoordsKeepVehicle(cache.ped, config.teleports[loc][2].coords.x, config.teleports[loc][2].coords.y, config.teleports[loc][2].coords.z)
                                else
                                    SetEntityCoords(cache.ped, config.teleports[loc][2].coords.x, config.teleports[loc][2].coords.y, config.teleports[loc][2].coords.z)
                                end

                                if type(config.teleports[loc][2].coords) == 'vector4' then
                                    SetEntityHeading(cache.ped, config.teleports[loc][2].coords.w)
                                end
                            elseif k == 2 then
                                if v.allowVehicle then
                                    SetPedCoordsKeepVehicle(cache.ped, config.teleports[loc][1].coords.x, config.teleports[loc][1].coords.y, config.teleports[loc][1].coords.z)
                                else
                                    SetEntityCoords(cache.ped, config.teleports[loc][1].coords.x, config.teleports[loc][1].coords.y, config.teleports[loc][1].coords.z)
                                end

                                if type(config.teleports[loc][1].coords) == 'vector4' then
                                    SetEntityHeading(cache.ped, config.teleports[loc][1].coords.w)
                                end
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
