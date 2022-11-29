local disableShuffle = true
local inVehicle = false

lib.onCache('vehicle', function(value)
    if value then
        inVehicle = true

        while inVehicle do
            local sleep = 100

            if disableShuffle then
                if GetPedInVehicleSeat(value, 0) == cache.ped then
                    if GetIsTaskActive(cache.ped, 165) then
                        sleep = 0

                        SetPedIntoVehicle(cache.ped, value, 0)
                        SetPedConfigFlag(cache.ped, 184, true)
                    end
                end
            end

            Wait(sleep)
        end
    else
        inVehicle = false
    end
end)

RegisterNetEvent('SeatShuffle', function()
	if IsPedInAnyVehicle(cache.ped, false) then
		disableShuffle = false

        SetPedConfigFlag(cache.ped, 184, false)

        Wait(3000)

        disableShuffle = true
	else
		CancelEvent()
	end
end)

RegisterCommand("shuff", function()
    TriggerEvent("SeatShuffle")
end, false)