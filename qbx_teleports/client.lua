local config = lib.loadJson('qbx_teleports.config')

if #config.teleports == 0 then return end

local zones = {}

AddEventHandler('onResourceStop', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for _, zone in ipairs(zones) do
        zone:remove()
    end
end)

local destination

CreateThread(function ()
    for _, passage in ipairs(config.teleports) do
        for i = 1, #passage do
            local entrance = passage[i]
            local exit = passage[(i % 2) + 1] -- (1 % 2) -> 1 (2 % 2) -> 0
            local coords = vec3(entrance.coords)
            zones[#zones+1] = lib.zones.sphere({
                coords = coords,
                radius = 2,
                onEnter = function ()
                    lib.showTextUI(entrance.drawText)
                    destination = {
                        coords = vec(exit.coords),
                        ignoreGround = exit.ignoreGround,
                        allowVehicle = entrance.allowVehicle
                    }
                end,
                onExit = function ()
                    lib.hideTextUI()
                    destination = nil
                end
            })
        end
    end
end)

local keybind

local function onPressed()
    keybind:disable(true)
    if destination then
        local coordZ = destination.coords.z

        if not destination.ignoreGround then
            local isSafe, z = GetGroundZFor_3dCoord(
                destination.coords.x,
                destination.coords.y,
                destination.coords.z,
                false
            )

            if isSafe then coordZ = z end
        end

        if destination.allowVehicle and cache.vehicle then
            SetPedCoordsKeepVehicle(
                cache.ped,
                destination.coords.x,
                destination.coords.y,
                coordZ
            )

            SetVehicleOnGroundProperly(cache.vehicle)
        else
            SetEntityCoords(
                cache.ped,
                destination.coords.x,
                destination.coords.y,
                coordZ,
                true, false, false, false
            )
        end

        if type(destination.coords) == 'vector4' then
            SetEntityHeading(cache.ped, destination.coords.w)
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
