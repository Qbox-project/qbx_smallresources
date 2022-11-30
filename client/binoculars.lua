local fov_max = 70.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local binoculars = false
local fov = (fov_max+fov_min)*0.5
local storeBinoclarKey = 177 -- Backspace

--FUNCTIONS--

local function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetControlNormal(0, 220)
    local rightAxisY = GetControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(cache.ped,new_z)
    end
end

local function HandleZoom(cam)
    if not IsPedSittingInAnyVehicle(cache.ped) then
        if IsControlJustPressed(0,241) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
    end
end

--EVENTS--

-- Activate binoculars
local cam = nil
local scaleform = nil
RegisterNetEvent('binoculars:Toggle', function()
    if cache.vehicle then return end
    binoculars = not binoculars

    if binoculars then
        TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_BINOCULARS', 0, true)
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        AttachCamToEntity(cam, cache.ped, 0.0,0.0,1.0, true)
        SetCamRot(cam, 0.0,0.0, GetEntityHeading(cache.ped), 2)
        RenderScriptCams(true, false, 5000, true, false)
    else
        ClearPedTasks(cache.ped)
        RenderScriptCams(false, true, 1000, false, false)
        SetScaleformMovieAsNoLongerNeeded()
        DestroyCam(cam, false)
        cam = nil
    end

    while binoculars do

        scaleform = RequestScaleformMovie('BINOCULARS')
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(10)
        end

        BeginScaleformMovieMethod(scaleform, 'SET_CAM_LOGO')
        ScaleformMovieMethodAddParamInt(0) -- 0 for nothing, 1 for LSPD logo
        EndScaleformMovieMethod()

        if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
            binoculars = false
            ClearPedTasks(cache.ped)
            RenderScriptCams(false, true, 1000, false, false)
            SetScaleformMovieAsNoLongerNeeded()
            DestroyCam(cam, false)
            cam = nil
        end

        local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
        CheckInputRotation(cam, zoomvalue)
        HandleZoom(cam)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        Wait(0)
    end
end)