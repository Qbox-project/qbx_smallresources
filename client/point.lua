local mp_pointing = false

local function startPointing()
    lib.requestAnimDict("anim@mp_point")

    SetPedCurrentWeaponVisible(cache.ped, false, true, true, true)
    SetPedConfigFlag(cache.ped, 36, true)
	TaskMoveNetworkByName(cache.ped, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
	RequestTaskMoveNetworkStateTransition(cache.ped, 'Stop')

    if not IsPedInjured(cache.ped) then
        ClearPedSecondaryTask(cache.ped)
    end

    if not IsPedInAnyVehicle(cache.ped, true) then
        SetPedCurrentWeaponVisible(cache.ped, true, true, true, true)
    end

    SetPedConfigFlag(cache.ped, 36, false)
    ClearPedSecondaryTask(cache.ped)
end

lib.addKeybind({
    name = 'point',
    description = 'Toggles Point',
    defaultKey = 'B',
    onPressed = function(_)
        if not IsPedInAnyVehicle(cache.ped, false) then
            if mp_pointing then
                stopPointing()

                mp_pointing = false
            else
                startPointing()

                mp_pointing = true
            end

            while mp_pointing do
                local camPitch = GetGameplayCamRelativePitch()

                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end

                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)

                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end

                camHeading = (camHeading + 180.0) / 360.0

                local blocked
                local coords = GetOffsetFromEntityInWorldCoords(cache.ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, cache.ped, 7)

                _, blocked = GetRaycastResult(ray)
                SetTaskMoveNetworkSignalFloat(cache.ped, "Pitch", camPitch)
                SetTaskMoveNetworkSignalFloat(cache.ped, "Heading", camHeading * -1.0 + 1.0)
                SetTaskMoveNetworkSignalBool(cache.ped, "isBlocked", blocked)
                SetTaskMoveNetworkSignalBool(cache.ped, "isFirstPerson", GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)

                Wait(0)
            end
        end
    end
})