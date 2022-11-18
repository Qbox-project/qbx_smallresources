local QBCore = exports['qb-core']:GetCoreObject()
RegisterCommand('tackle', function()
    if IsPedSprinting(cache.ped) or IsPedRunning(cache.ped) then
        local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
        if closestDistance ~= -1 and closestDistance < 1.6 then
            if not cache.vehicle and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
                TriggerServerEvent('tackle:server:TacklePlayer', GetPlayerServerId(closestPlayer))
                lib.requestAnimDict('swimming@first_person@diving', 1000)
                TaskPlayAnim(cache.ped, 'swimming@first_person@diving', 'dive_run_fwd_-45_loop' ,3.0, 3.0, -1, 49, 0, false, false, false)
                Wait(250)
                ClearPedTasks(cache.ped)
                SetPedToRagdoll(cache.ped, 150, 150, 0, 0, 0, 0)
                RemoveAnimDict('swimming@first_person@diving')
            end
        end
    end
end, false)

RegisterKeyMapping('tackle', 'Tackle', 'keyboard', 'e')

RegisterNetEvent('tackle:client:GetTackled', function()
	SetPedToRagdoll(cache.ped, 7000, 7000, 0, 0, 0, 0)
end)
