local QBCore = exports['qbx-core']:GetCoreObject()
local logQueue, isProcessingQueue, logCount = {}, false, 0
local lastRequestTime, requestDelay = 0, 0

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

---Log Queue
local function applyRequestDelay()
    local currentTime = GetGameTimer()
    local timeDiff = currentTime - lastRequestTime

    if timeDiff < requestDelay then
        local remainingDelay = requestDelay - timeDiff

        Wait(remainingDelay)
    end

    lastRequestTime = GetGameTimer()
end

local allowedErr = {
    [200] = true,
    [201] = true,
    [204] = true,
    [304] = true
}

---Log Queue
---@param payload Log Queue
local function logPayload(payload)
    PerformHttpRequest(payload.webhook, function(err, text, headers)
        if err and not allowedErr[err] then
            print('^1Error occurred while attempting to send log to discord: ' .. err .. '^7')
            return
        end

        local remainingRequests = tonumber(headers["X-RateLimit-Remaining"])
        local resetTime = tonumber(headers["X-RateLimit-Reset"])

        if remainingRequests and resetTime and remainingRequests == 0 then
            local currentTime = os.time()
            local resetDelay = resetTime - currentTime

            if resetDelay > 0 then
                requestDelay = resetDelay * 1000 / 10
            end
        end
    end, 'POST', json.encode({content = payload.tag and '@everyone' or nil, embeds = {payload.embed}}), { ['Content-Type'] = 'application/json' })
end

---Log Queue
local function processLogQueue()
    if #logQueue > 0 then
        local payload = table.remove(logQueue, 1)

        logPayload(payload)

        logCount += 1

        if logCount % 5 == 0 then
            Wait(60000)
        else
            applyRequestDelay()
        end

        processLogQueue()
    else
        isProcessingQueue = false
    end
end

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
                ['text'] = os.date('%H:%M:%S %m-%d-%Y'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'QBCore Logs',
                ['icon_url'] = 'https://media.discordapp.net/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png?width=670&height=670',
            },
        }
    }

    logQueue[#logQueue + 1] = {
        webhook = webHook,
        tag = tag,
        embed = embedData
    }

    if not isProcessingQueue then
        isProcessingQueue = true

        CreateThread(processLogQueue)
    end
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
