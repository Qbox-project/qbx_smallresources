local disableShuffle = true

AddEventHandler('ox_lib:cache:vehicle', function(_)
    CreateThread(function()
        local sleep = 100
        while cache.vehicle do
            if disableShuffle then
                if GetPedInVehicleSeat(cache.vehicle, 0) == cache.ped then
                    if GetIsTaskActive(cache.ped, 165) then
                        sleep = 0
                        SetPedIntoVehicle(cache.ped, cache.vehicle, 0)
                        SetPedConfigFlag(cache.ped, 184, true)
                    end
                end
            end
            Wait(sleep)
        end
    end)
end)

RegisterNetEvent('SeatShuffle', function()
	if cache.vehicle then
		disableShuffle = false
        SetPedConfigFlag(cache.ped, 184, false)
        Wait(3000)
        disableShuffle = true
	else
		CancelEvent()
	end
end)

RegisterCommand('shuff', function()
    TriggerEvent('SeatShuffle')
end, false)
