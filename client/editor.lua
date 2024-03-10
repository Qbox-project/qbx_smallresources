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
    exports.qbx_core:Notify(locale('success.started_recording'), 'success')
end, false)

RegisterCommand('clip', function()
    StartRecording(0)
    exports.qbx_core:Notify(locale('success.stopped_recording'), 'success')
end, false)

RegisterCommand('saveclip', function()
    StopRecordingAndSaveClip()
    exports.qbx_core:Notify(locale('success.saved_recording'), 'success')
end, false)

RegisterCommand('delclip', function()
    StopRecordingAndDiscardClip()
    exports.qbx_core:Notify(locale('error.deleted_recording'), 'error')
end, false)

RegisterCommand('editor', function()
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
    exports.qbx_core:Notify(locale('error.later_aligator'), 'error')
end, false)
