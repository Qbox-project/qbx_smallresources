-- To Set This Up visit https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686
local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        -- This is the Application ID (Replace this with you own)
        SetDiscordAppId(0)

        -- Here you will have to put the image name for the "large" icon.
        SetDiscordRichPresenceAsset('logo_name')

        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('This is a lage icon with text')

        -- Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('small_logo_name')

        -- Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('This is a small icon with text')

        QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
            SetRichPresence('Players: ' .. result .. '/' .. GetConvarInt('sv_maxclients', 48))
        end)

        -- (26-02-2021) New Native:

        --[[
            Here you can add buttons that will display in your Discord Status,
            First paramater is the button index (0 or 1), second is the title and
            last is the url (this has to start with "fivem://connect/" or "https://")
        ]]--
        SetDiscordRichPresenceAction(0, "Connect", "fivem://connect/localhost:30120")
        SetDiscordRichPresenceAction(1, "Website", "https://localhost")

        -- It updates every minute just in case.
        Wait(60000)
    end
end)
