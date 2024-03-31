local config = require 'config.client'
local resetCounter = 0
local jumpDisabled = false
isLoggedIn = LocalPlayer.state.isLoggedIn

lib.addKeybind({
    name = 'tackle',
    description = 'Tackle',
    defaultKey = 'E',
    onReleased = function(self)
        if cache.vehicle then return end
        if QBX.PlayerData.metadata.ishandcuffed then return end
        if IsPedSprinting(cache.ped) or IsPedRunning(cache.ped) then
            local coords = GetEntityCoords(cache.ped)
            local targetId, targetPed, _ = lib.getClosestPlayer(coords, 1.6, false)
            if not targetPed then return end
            if IsPedInAnyVehicle(targetPed, true) then return end
            self:disable(true)
            TriggerServerEvent('tackle:server:TacklePlayer', GetPlayerServerId(targetId))
            lib.requestAnimDict('swimming@first_person@diving')
            TaskPlayAnim(cache.ped, 'swimming@first_person@diving', 'dive_run_fwd_-45_loop', 3.0, 3.0, -1, 49, 0, false, false, false)
            Wait(250)
            ClearPedTasks(cache.ped)
            SetPedToRagdoll(cache.ped, 150, 150, 0, 0, 0, 0)
            RemoveAnimDict('swimming@first_person@diving')
            SetTimeout(1000, function ()
                self:disable(false)
            end)
        end
    end
})

RegisterNetEvent('tackle:client:GetTackled', function()
	SetPedToRagdoll(cache.ped, 7000, 7000, 0, 0, 0, 0)
end)

CreateThread(function()
    if config.disable.jumpDisabled then
        while true do
            Wait(4)
            if isLoggedIn then
                if jumpDisabled and resetCounter > 0 and IsPedJumping(cache.ped) then
                    SetPedToRagdoll(cache.ped, 1000, 1000, 3, 0, 0, 0)
                    resetCounter = 0
                end
                if not jumpDisabled and IsPedJumping(cache.ped) then
                    jumpDisabled = true
                    resetCounter = 10
                    Wait(1200)
                end
                if resetCounter > 0 then
                    resetCounter = resetCounter - 1
                else
                    if jumpDisabled then
                        resetCounter = 0
                        jumpDisabled = false
                    end
                end
                Wait(250)
            else
                Wait(5000)
            end
        end
    end
end)
