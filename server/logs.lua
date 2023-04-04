local QBCore = exports['qbx-core']:GetCoreObject()

local Webhooks = {
    ['default'] = '',
    ['testwebhook'] = '',
    ['playermoney'] = '',
    ['playerinventory'] = '',
    ['robbing'] = '',
    ['cuffing'] = '',
    ['drop'] = '',
    ['trunk'] = '',
    ['stash'] = '',
    ['glovebox'] = '',
    ['banking'] = '',
    ['vehicleshop'] = '',
    ['vehicleupgrades'] = '',
    ['shops'] = '',
    ['dealers'] = '',
    ['storerobbery'] = '',
    ['bankrobbery'] = '',
    ['powerplants'] = '',
    ['death'] = '',
    ['joinleave'] = '',
    ['ooc'] = '',
    ['report'] = '',
    ['me'] = '',
    ['pmelding'] = '',
    ['112'] = '',
    ['bans'] = '',
    ['anticheat'] = '',
    ['weather'] = '',
    ['moneysafes'] = '',
    ['bennys'] = '',
    ['bossmenu'] = '',
    ['robbery'] = '',
    ['casino'] = '',
    ['traphouse'] = '',
    ['911'] = '',
    ['palert'] = '',
    ['house'] = '',
}

---@enum Colors
local Colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ['lightgreen'] = 65309,
}

---Logs using ox_lib logger regardless of Config.EnableOxLogging value
---@see https://overextended.github.io/docs/ox_lib/Logger/Server
local function OxLog(source, event, message, ...)
    lib.logger(source, event, message, ...)
end

exports('OxLog', OxLog)

---Logs to discord regardless of Config.EnableDiscordLogging value
---@param name string source of the log. Usually a playerId or name of a script.
---@param title string the action or 'event' being logged. Usually a verb describing what the name is doing. Example: SpawnVehicle
---@param message string the message attached to the log
---@param color? string what color the message should be
---@param tagEveryone? boolean Whether an @everyone tag should be applied to this log.
local function DiscordLog(name, title, message, color, tagEveryone)
    local tag = tagEveryone or false
    local webHook = Webhooks[name] or Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Colors[color] or Colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'QBCore Logs',
                ['icon_url'] = 'https://media.discordapp.net/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png?width=670&height=670',
            },
        }
    }
    PerformHttpRequest(webHook, function() end, 'POST', json.encode({ username = 'QB Logs', content = tag and '@everyone' or nil, embeds = embedData }), { ['Content-Type'] = 'application/json' })
end

exports('DiscordLog', DiscordLog)

---Creates a log using either ox_lib logger, discord webhooks, or both depending on config. If not needing discord logs, use qb-log:server:CreateOxLog event instead.
---@param name string source of the log. Usually a playerId or name of a script.
---@param title string the action or 'event' being logged. Usually a verb describing what the name is doing. Example: SpawnVehicle
---@param color? string used for discord logging only, what color the message should be
---@param message string the message attached to the log
---@param tagEveryone? boolean used for discord logging only. Whether an @everyone tag should be applied to this log.
local function CreateLog(name, title, color, message, tagEveryone)
    if Config.EnableOxLogging then
        OxLog(name, title, message)
    end

    if Config.EnableDiscordLogging then
        DiscordLog(name, title, message, color, tagEveryone)
    end
end

exports('CreateLog', CreateLog)

---@deprecated use the CreateLog export instead for discord logging, or OxLog for other logging.
RegisterNetEvent('qb-log:server:CreateLog', CreateLog)

QBCore.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    CreateLog('testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
