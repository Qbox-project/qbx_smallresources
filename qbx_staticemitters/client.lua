local config = require 'qbx_staticemitters.config'
local currentGameBuild = GetGameBuildNumber()
local disabledEmitters = {}

if not config.status then return end

lib.print.warn(
'You have static emitters enabled, this means that any emitter that is in config.lua will be set acording to its status, you can change this in qbx_smallresources/qbx_staticemitters/config.lua')

local function registerMenus()
    local submenus = {}
    local submenuStr = 'static_emitters_submenu_%s'

    for emitterGroup in pairs(disabledEmitters) do
        table.insert(submenus, {
            title = emitterGroup:gsub('%f[%a].', string.upper),
            menu = string.format(submenuStr, emitterGroup),
            arrow = true,
        })
    end

    lib.registerContext({
        id = 'static_emitters_menu',
        title = 'Static Emitters Menu',
        position = 'top-right',
        options = submenus,
    })

    for emitterGroup, emitters in pairs(disabledEmitters) do
        local emitterOptions = {}

        for _, data in pairs(emitters) do
            local pos = data.position
            local posStr = string.format('%.2f, %.2f, %.2f', pos.x, pos.y, pos.z)

            table.insert(emitterOptions, {
                title = string.format('%s', data.name),
                description = string.format('Coordinates: %s', posStr),
                icon = 'location-dot',
                onSelect = function()
                    SetEntityCoords(cache.ped, pos.x, pos.y, pos.z, true, false, false, false)

                    if config.menu.copyToClipboard then
                        lib.setClipboard(posStr)
                    end
                end,
            })
        end

        lib.registerContext({
            id = string.format(submenuStr, emitterGroup),
            title = emitterGroup:gsub('%f[%a].', string.upper),
            position = 'top-right',
            menu = 'static_emitters_menu',
            options = emitterOptions,
        })
    end
end

CreateThread(function()
    while true do
        if NetworkIsSessionStarted() then
            for gameBuild, emitterGroups in pairs(config.gameBuild) do
                if currentGameBuild >= gameBuild then
                    for emitterGroup, emitterGroupOptions in pairs(emitterGroups) do
                        if not emitterGroupOptions.status then
                            for emitterName, emitterOptions in pairs(emitterGroupOptions.emitters) do
                                if not emitterOptions.status then
                                    if not disabledEmitters[emitterGroup] then
                                        disabledEmitters[emitterGroup] = {}
                                    end

                                    table.insert(disabledEmitters[emitterGroup], {
                                        name = emitterName,
                                        position = emitterOptions.position
                                    })
                                end

                                SetStaticEmitterEnabled(emitterName, emitterOptions.status)
                            end
                        end
                    end
                end
            end
            if lib.callback.await('qbx_staticemitters:server:IsPlayerAceAllowed', false) and config.menu.status then
                registerMenus()
                RegisterCommand('staticemitters', function()
                    lib.showContext('static_emitters_menu')
                end, false)
            end
            break
        end
        Wait(0)
    end
end)