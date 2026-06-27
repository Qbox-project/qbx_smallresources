local Config = require 'qbx_zoomcam.config'

local currentFOV = Config.DefaultFOV
local zoomCam = nil
local isHolding = false

local function ZoomLoop()
    if zoomCam then return end -- Loop is already active

    CreateThread(function()
        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        
        -- Create cam on first hold
        zoomCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(zoomCam, pos.x, pos.y, pos.z + 0.7)
        RenderScriptCams(true, false, 0, true, false)

        -- Keep looping while holding OR while the FOV is still transitioning back to default
        while isHolding or (zoomCam and math.abs(currentFOV - Config.DefaultFOV) >= 0.5) do
            Wait(0)
            
            -- Set target based on hold state
            local targetFOV = isHolding and Config.ZoomFOV or Config.DefaultFOV
            local speed = isHolding and Config.ZoomInSpeed or Config.ZoomOutSpeed
            
            -- Lerp FOV smoothly
            currentFOV = currentFOV + (targetFOV - currentFOV) / speed

            -- Update cam every frame
            playerPed = PlayerPedId()
            pos = GetEntityCoords(playerPed)
            local rot = GetGameplayCamRot(2)

            SetCamCoord(zoomCam, pos.x, pos.y, pos.z + 0.7)
            SetCamRot(zoomCam, rot.x, rot.y, rot.z, 2)
            SetCamFov(zoomCam, currentFOV)
        end

        -- Destroy cam when fully back to default and not holding
        currentFOV = Config.DefaultFOV
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(zoomCam, false)
        zoomCam = nil
    end)
end

RegisterCommand('+zoomcam', function()
    isHolding = true
    ZoomLoop()
end, false)

RegisterCommand('-zoomcam', function()
    isHolding = false
end, false)

RegisterKeyMapping('+zoomcam', 'Zoom Camera', 'keyboard', Config.DefaultKey)
