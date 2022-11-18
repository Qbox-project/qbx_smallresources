function DrawPlayerName(x, y, z, name)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetFinalRenderedCamCoord())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = ((1/dist)*2)*((1/GetGameplayCamFov())*100)

    if onScreen then
        SetTextScale(0.0*scale, 0.5*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(name)
		GetScreenCoordFromWorldCoord(x, y, z, 0)
        EndTextCommandDisplayText(_x, _y)
    end
end

local showNames = false

CreateThread(function()
    while true do
        local sleep = 500
        if showNames then
            sleep = 0
            for _, id in ipairs(GetActivePlayers()) do
                if NetworkIsPlayerActive(id) then
                    local myPos = GetEntityCoords(PlayerPedId())
                    local otherPos = GetEntityCoords(GetPlayerPed(id))
                    local distance = #(myPos - otherPos)
                    if distance < 15.0 then
                        DrawPlayerName(otherPos.x, otherPos.y, otherPos.z + 1.0, GetPlayerServerId(id))
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterCommand('+showid', function()
    showNames = true
end, false)

RegisterCommand('-showid', function()
    showNames = false
end, false)

RegisterKeyMapping('+showid', 'Show ID\'s', 'keyboard', 'EQUALS')