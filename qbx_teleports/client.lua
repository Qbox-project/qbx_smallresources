---@class Teleport
---@field coords vector3 | vector4
---@field drawText string
---@field allowVehicle boolean?
---@field ignoreGround boolean?

---@type { teleports: Teleport[][] }
local config = lib.loadJson('qbx_teleports.config')
if #config.teleports == 0 then return end

local buttonTemplate = '[%s] %s - %s'
local keybindUp
local keybindDown

local toRemove = {}
for i = 1, #config.teleports do
    local passage = config.teleports[i]
    if #passage > 1 then
        for level = 1, #passage do
            local data = passage[level]
            if #data.coords == 4 then
                data.coords = vec4(data.coords[1], data.coords[2], data.coords[3])
            else
                data.coords = vec3(data.coords[1], data.coords[2], data.coords[3])
            end
        end
    else
        toRemove[#toRemove + 1] = i
    end
end

if #toRemove ~= 0 then
    for i = 1, #toRemove do
        table.remove(config.teleports, toRemove[i])
    end
end

local zones = {}

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for i = 1, #zones do
        zones[i]:remove()
    end
end)

local currentLevel = {0, 0}

CreateThread(function()
    for i = 1, #config.teleports do
        local passage = config.teleports[i]
        for level = 1, #passage do
            local entrance = passage[level]
            zones[#zones + 1] = lib.zones.sphere({
                coords = entrance.coords.xyz,
                radius = 2,
                onEnter = function()
                    local hasUp = passage[level + 1] ~= nil
                    local hasDown = passage[level - 1] ~= nil
                    lib.showTextUI(('%s%s%s'):format(
                        hasUp and buttonTemplate:format(keybindUp.currentKey, entrance.drawText, locale('info.teleportUp')) or '',
                        hasUp and '  \n' or '',
                        hasDown and buttonTemplate:format(keybindDown.currentKey, entrance.drawText, locale('info.teleportDown')) or ''
                    ))

                    currentLevel = {i, level}
                end,
                onExit = function()
                    currentLevel = {0, 0}
                    lib.hideTextUI()
                end
            })
        end
    end
end)

local function onPressed(self)
    if currentLevel[1] == 0 or currentLevel[2] == 0 then return end

    local destination = self.name == 'passageUp' and config.teleports[currentLevel[1]][currentLevel[2] + 1] or config.teleports[currentLevel[1]][currentLevel[2] - 1]

    keybindUp:disable(true)
    keybindDown:disable(true)

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

    Wait(250) -- Make sure we can't spam teleport and we have been teleported completely

    keybindUp:disable(false)
    keybindDown:disable(false)
end

keybindUp = lib.addKeybind({
    name = 'passageUp',
    description = 'entry through passage upwards',
    defaultKey = 'Q',
    secondaryMapper = 'PAD_DIGITALBUTTONANY',
    secondaryKey = 'LLEFT_INDEX',
    onPressed = onPressed
})

keybindDown = lib.addKeybind({
    name = 'passageDown',
    description = 'entry through passage downwards',
    defaultKey = 'E',
    secondaryMapper = 'PAD_DIGITALBUTTONANY',
    secondaryKey = 'LRIGHT_INDEX',
    onPressed = onPressed
})
