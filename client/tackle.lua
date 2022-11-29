local QBCore = exports['qb-core']:GetCoreObject()

local function TackleAnim()
    if not QBCore.Functions.GetPlayerData().metadata.ishandcuffed and not IsPedRagdoll(cache.ped) then
        if IsEntityPlayingAnim(cache.ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedTasksImmediately(cache.ped)
        else
            lib.requestAnimDict("swimming@first_person@diving")

            TaskPlayAnim(cache.ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
            RemoveAnimDict("swimming@first_person@diving")

            Wait(250)

            ClearPedTasksImmediately(ped)
            SetPedToRagdoll(cache.ped, 150, 150, 0, false, false, false)
        end
    end
end

local function Tackle()
    local closestPlayer, distance = QBCore.Functions.GetClosestPlayer()

    if distance ~= -1 and distance < 2 then
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(closestPlayer))

        TackleAnim()
    end
end

CreateThread(function()
    local sleep

    while true do
        sleep = 250

        if LocalPlayer.state.isLoggedIn then
            if not IsPedInAnyVehicle(cache.ped, false) and GetEntitySpeed(cache.ped) > 2.5 then
                sleep = 0

                if IsControlJustPressed(1, 19) then
                    Tackle()
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('tackle:client:GetTackled', function()
	SetPedToRagdoll(cache.ped, math.random(1000, 6000), math.random(1000, 6000), 0, false, false, false)

	TimerEnabled = true

	Wait(1500)

	TimerEnabled = false
end)