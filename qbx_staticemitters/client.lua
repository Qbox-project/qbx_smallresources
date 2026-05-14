local config = require 'qbx_staticemitters.config'
local currentGameBuild = GetGameBuildNumber()
local setStaticEmitterEnabled = SetStaticEmitterEnabled
local disabledEmitters = {}

if not config.status then return end

lib.print.warn('Static emitters enabled ! config: qbx_smallresources/qbx_staticemitters/config.lua')

local function registerMenus()
    local submenus = {}
    local submenuStr = 'static_emitters_submenu_%s'

    for emitterGroup in pairs(disabledEmitters) do
        submenus[#submenus + 1] = {
            title = emitterGroup:gsub('%f[%a].', string.upper),
            menu = submenuStr:format(emitterGroup),
            arrow = true,
        }
    end

    lib.registerContext({
        id = 'static_emitters_menu',
        title = 'Static Emitters Menu',
        position = 'top-right',
        options = submenus,
    })

    for emitterGroup, emitters in pairs(disabledEmitters) do
        local emitterOptions = {}
        local groupTitle = emitterGroup:gsub('%f[%a].', string.upper)

        for i = 1, #emitters do
            local data = emitters[i]
            local pos = data.position
            local posStr = ('%.2f, %.2f, %.2f'):format(pos.x, pos.y, pos.z)

            emitterOptions[#emitterOptions + 1] = {
                title = data.name,
                description = ('Coordinates: %s'):format(posStr),
                icon = 'location-dot',
                onSelect = function()
                    if config.menu.copyToClipboard then lib.setClipboard(posStr) end
                    SetEntityCoords(cache.ped, pos.x, pos.y, pos.z, true, false, false, false)
                end,
            }
        end

        lib.registerContext({
            id = submenuStr:format(emitterGroup),
            title = groupTitle,
            position = 'top-right',
            menu = 'static_emitters_menu',
            options = emitterOptions,
        })
    end
end

CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(500) end

    for gameBuild, emitterGroups in pairs(config.gameBuild) do
        if currentGameBuild >= gameBuild then
            for emitterGroup, emitterGroupOptions in pairs(emitterGroups) do
                if not emitterGroupOptions.status then
                    local groupList = disabledEmitters[emitterGroup] or {}

                    for emitterName, emitterOptions in pairs(emitterGroupOptions.emitters) do
                        local status = emitterOptions.status

                        if not status then
                            groupList[#groupList + 1] = {
                                name = emitterName,
                                position = emitterOptions.position
                            }
                        end

                        setStaticEmitterEnabled(emitterName, status)
                    end

                    disabledEmitters[emitterGroup] = groupList
                end
            end
        end
    end

    if config.menu.status then
        local isAllowed = lib.callback.await('qbx_staticemitters:server:IsPlayerAceAllowed', false)

        if isAllowed then
            registerMenus()
            RegisterCommand('staticemitters', function()
                lib.showContext('static_emitters_menu')
            end, false)
        end
    end
end)