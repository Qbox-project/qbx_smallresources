local Config = require 'qbx_zoomcam.config'

local currentFOV = Config.DefaultFOV
local currentZOffset = 0.0
local zoomCam = nil
local isHolding = false

local function ZoomLoop()
    if zoomCam then return end -- Loop is already active

    CreateThread(function()
        -- Create cam on first hold
        local originalFOV = GetGameplayCamFov()
        currentFOV = originalFOV
        zoomCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        local camCoords = GetGameplayCamCoord()
        local camRot = GetGameplayCamRot(2)
        
        SetCamCoord(zoomCam, camCoords.x, camCoords.y, camCoords.z)
        SetCamRot(zoomCam, camRot.x, camRot.y, camRot.z, 2)
        SetCamFov(zoomCam, currentFOV)
        
        RenderScriptCams(true, false, 0, true, false)

        -- Keep looping while holding OR while the FOV is still transitioning back to default
        while isHolding or (zoomCam and math.abs(currentFOV - originalFOV) >= 0.5) do
            Wait(0)
            
            -- Set target based on hold state
            local targetFOV = isHolding and Config.ZoomFOV or originalFOV
            local targetZOffset = isHolding and 0.3 or 0.0
            local speed = isHolding and Config.ZoomInSpeed or Config.ZoomOutSpeed
            
            -- Lerp FOV and Z Offset smoothly
            currentFOV = currentFOV + (targetFOV - currentFOV) / speed
            currentZOffset = currentZOffset + (targetZOffset - currentZOffset) / speed

            -- Update cam every frame
            local playerPed = PlayerPedId()
            local coords = GetGameplayCamCoord()
            local rot = GetGameplayCamRot(2)

            -- Fix vehicle camera jitter by predicting the next frame's position
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle ~= 0 then
                local vel = GetEntityVelocity(vehicle)
                local frameTime = GetFrameTime()
                -- Predict camera position to eliminate 1-frame delay
                coords = vector3(coords.x + (vel.x * frameTime), coords.y + (vel.y * frameTime), coords.z + (vel.z * frameTime))
            end

            SetCamCoord(zoomCam, coords.x, coords.y, coords.z + currentZOffset)
            SetCamRot(zoomCam, rot.x, rot.y, rot.z, 2)
            SetCamFov(zoomCam, currentFOV)
        end

        -- Destroy cam when fully back to default and not holding
        currentFOV = originalFOV
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
