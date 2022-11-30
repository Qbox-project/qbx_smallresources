-- We do this check as we don't want players using these commands due to crashing with escrowed maps.
local shouldAllow, mapNames = true, {
    'cfx-gabz-mapdata'
}

for i = 1, #mapNames do
    local state = GetResourceState(mapNames[i])
    if state == 'starting' or state == 'started' then
        shouldAllow = false
    end
end

if not shouldAllow then return end

RegisterCommand('record', function()
    StartRecording(1)
    TriggerEvent('QBCore:Notify', 'Started Recording!', 'success')
end, false)

RegisterCommand('clip', function()
    StartRecording(0)
end, false)

RegisterCommand('saveclip', function()
    StopRecordingAndSaveClip()
    TriggerEvent('QBCore:Notify', 'Saved Recording!', 'success')
end, false)

RegisterCommand('delclip', function()
    StopRecordingAndDiscardClip()
    TriggerEvent('QBCore:Notify', 'Deleted Recording!', 'error')
end, false)

RegisterCommand('editor', function()
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
    TriggerEvent('QBCore:Notify', 'Later aligator!', 'error')
end, false)
