local stage = 0
local movingForward = false
local walkSet = "default"

local function ResetAnimSet()
    ResetPedMovementClipset(cache.ped, 0)
    ResetPedWeaponMovementClipset(cache.ped)
    ResetPedStrafeClipset(cache.ped)

    if walkSet ~= "default" then
        Wait(100)

        lib.requestAnimSet(walkSet)

        SetPedMovementClipset(cache.ped, walkSet, 1)
        RemoveAnimSet(walkSet)
    end
end

RegisterNetEvent('crouchprone:client:SetWalkSet', function(clipset)
    walkSet = clipset
end)

CreateThread(function()
    local sleep

    while true do
        sleep = 1000

        if not IsPedSittingInAnyVehicle(cache.ped) and not IsPedFalling(cache.ped) and not IsPedSwimming(cache.ped) and not IsPedSwimmingUnderWater(cache.ped) then
            sleep = 0

            if IsControlJustReleased(2, 36) then
                stage += 1

                if stage == 2 then
                    -- Crouch stuff
                    ClearPedTasks(cache.ped)

                    lib.requestAnimSet("move_ped_crouched")

                    SetPedMovementClipset(cache.ped, "move_ped_crouched", 1.0)
                    SetPedWeaponMovementClipset(cache.ped, "move_ped_crouched")
                    SetPedStrafeClipset(cache.ped, "move_ped_crouched_strafing")
                    RemoveAnimSet("move_ped_crouched")
                elseif stage == 3 then
                    ClearPedTasks(cache.ped)
                elseif stage > 3 then
                    stage = 0

                    ClearPedTasksImmediately(cache.ped)

                    ResetAnimSet()

                    SetPedStealthMovement(cache.ped, false, "DEFAULT_ACTION")
                end
            end

            if stage == 2 then
                if GetEntitySpeed(cache.ped) > 1.0 then
                    lib.requestAnimSet("move_ped_crouched")

                    SetPedWeaponMovementClipset(cache.ped, "move_ped_crouched")
                    SetPedStrafeClipset(cache.ped, "move_ped_crouched_strafing")
                    RemoveAnimSet("move_ped_crouched")
                elseif GetEntitySpeed(cache.ped) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                    ResetPedWeaponMovementClipset(cache.ped)
                    ResetPedStrafeClipset(cache.ped)
                end
            elseif stage == 3 then
                DisableControlAction(0, 21, true ) -- sprint
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)

                if (IsControlPressed(0, 32) and not movingForward) and Config.EnableProne then
                    movingForward = true

                    SetPedMoveAnimsBlendOut(cache.ped)

                    local pronepos = GetEntityCoords(cache.ped)

                    lib.requestAnimDict("move_crawl")

                    TaskPlayAnimAdvanced(cache.ped, "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z + 0.1, 0.0, 0.0, GetEntityHeading(cache.ped), 100.0, 0.4, 1.0, 7, 2.0, 1, 1)
                    RemoveAnimDict("move_crawl")

                    Wait(500)
                elseif not IsControlPressed(0, 32) and movingForward then
                    local pronepos = GetEntityCoords(cache.ped)

                    lib.requestAnimDict("move_crawl")

                    TaskPlayAnimAdvanced(cache.ped, "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z + 0.1, 0.0, 0.0, GetEntityHeading(cache.ped), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
                    RemoveAnimDict("move_crawl")

                    Wait(500)

                    movingForward = false
                end

                if IsControlPressed(0, 34) then
                    SetEntityHeading(cache.ped, GetEntityHeading(cache.ped) + 1)
                end

                if IsControlPressed(0, 9) then
                    SetEntityHeading(cache.ped, GetEntityHeading(cache.ped) - 1)
                end
            end
        else
            stage = 0
        end

        Wait(sleep)
    end
end)