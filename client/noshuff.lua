local disableShuffle = true

local function DisableVehicleShuff()
    while cache.vehicle do
        local sleep = 100
        if disableShuffle then
            if cache.seat == -1 then
                if GetIsTaskActive(cache.ped, 165) then
                    sleep = 0
                    SetPedIntoVehicle(cache.ped, cache.vehicle, 0)
                    SetPedConfigFlag(cache.ped, 184, true)
                end
            end
        end
        Wait(sleep)
    end
end

lib.onCache('vehicle', function()
    DisableVehicleShuff()
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
