local config = lib.loadJson('qbx_teleports.config')

if #config.teleports == 0 then return end

local zones = {}

AddEventHandler('onResourceStop', function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end

    for _, zone in ipairs(zones) do
        zone:remove()
    end

    zones = nil
end)

local dst

CreateThread(function ()
    for _, passage in ipairs(config.teleports) do
        for i = 1, #passage do
            local coords = vec3(passage[i].coords)
            zones[#zones+1] = lib.zones.sphere({
                coords = coords.xyz,
                radius = 2,
                onEnter = function ()
                    lib.showTextUI(passage[i].drawText)
                    dst = {
                        coords = vec(passage[(i % 2) + 1].coords),
                        ignoreGround = passage[(i % 2) + 1].ignoreGround,
                        allowVehicle = passage[i].allowVehicle
                    }
                end,
                onExit = function ()
                    lib.hideTextUI()
                    dst = nil
                end
            })
        end
    end
end)

local keybind

local function onPressed()
    keybind:disable(true)
    if dst then
        if dst.allowVehicle and cache.vehicle then
            local coordz = dst.coords.z
            if not dst.ignoreGround then
                local isSafe, c = GetGroundZFor_3dCoord(
                    dst.coords.x,
                    dst.coords.y,
                    dst.coords.z,
                    false
                )

                if not isSafe then return end

                coordz = c
            end

            SetPedCoordsKeepVehicle(
                cache.ped,
                dst.coords.x,
                dst.coords.y,
                coordz
            )

            SetVehicleOnGroundProperly(cache.vehicle)
        else
            local coordz = dst.coords.z
            if not dst.ignoreGround then
                local isSafe, c = GetGroundZFor_3dCoord(
                    dst.coords.x,
                    dst.coords.y,
                    dst.coords.z,
                    false
                )

                if not isSafe then return end

                coordz = c
            end

            SetEntityCoords(
                cache.ped,
                dst.coords.x,
                dst.coords.y,
                coordz,
                true, false, false, false
            )
        end

        if type(dst.coords) == 'vector4' then
            SetEntityHeading(cache.ped, dst.coords.w)
        end
    end
    keybind:disable(false)
end

keybind = lib.addKeybind({
    name = 'passage',
    description = 'entry through passage',
    defaultKey = 'E',
    secondaryMapper = 'PAD_DIGITALBUTTONANY',
    secondaryKey = 'LRIGHT_INDEX',
    onPressed = onPressed
})
