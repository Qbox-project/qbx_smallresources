local Config = require 'qbx_zoomcam.config'

local currentFOV = Config.DefaultFOV
local currentZOffset = 0.0
local zoomCam = nil
local isHolding = false

local function ZoomLoop()
    if zoomCam then return end -- Loop is already active

    CreateThread(function()
        -- Create cam on first hold
        currentFOV = GetGameplayCamFov()
        zoomCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        local camCoords = GetGameplayCamCoord()
        local camRot = GetGameplayCamRot(2)
        
        SetCamCoord(zoomCam, camCoords.x, camCoords.y, camCoords.z)
        SetCamRot(zoomCam, camRot.x, camRot.y, camRot.z, 2)
        SetCamFov(zoomCam, currentFOV)
        
        RenderScriptCams(true, false, 0, true, false)

        -- Keep looping while holding OR while the FOV is still transitioning back to default
        while isHolding or (zoomCam and math.abs(currentFOV - Config.DefaultFOV) >= 0.5) do
            Wait(0)
            
            -- Set target based on hold state
            local targetFOV = isHolding and Config.ZoomFOV or Config.DefaultFOV
            local targetZOffset = isHolding and 0.3 or 0.0
            local speed = isHolding and Config.ZoomInSpeed or Config.ZoomOutSpeed
            
            -- Lerp FOV and Z Offset smoothly
            currentFOV = currentFOV + (targetFOV - currentFOV) / speed
            currentZOffset = currentZOffset + (targetZOffset - currentZOffset) / speed

            -- Update cam every frame
            local coords = GetGameplayCamCoord()
            local rot = GetGameplayCamRot(2)

            SetCamCoord(zoomCam, coords.x, coords.y, coords.z + currentZOffset)
            SetCamRot(zoomCam, rot.x, rot.y, rot.z, 2)
            SetCamFov(zoomCam, currentFOV)
        end

        -- Destroy cam when fully back to default and not holding
        currentFOV = Config.DefaultFOV
        currentZOffset = 0.0
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
