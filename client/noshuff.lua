local disableShuffle = true
local vehicle = nil

RegisterNetEvent('baseevents:enteredVehicle', function (veh)
    vehicle = veh
    local ped = PlayerPedId()
    while vehicle do
        local sleep = 100
        if disableShuffle then
            if GetPedInVehicleSeat(vehicle, 0) == ped then
                if GetIsTaskActive(ped, 165) then
                    sleep = 0
                    SetPedIntoVehicle(ped, vehicle, 0)
                    SetPedConfigFlag(ped, 184, true)
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('baseevents:leftVehicle', function ()
    vehicle = nil
end)

RegisterNetEvent('SeatShuffle', function()
    local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		disableShuffle = false
        SetPedConfigFlag(ped, 184, false)
        Wait(3000)
        disableShuffle = true
	else
		CancelEvent()
	end
end)

RegisterCommand("shuff", function()
    TriggerEvent("SeatShuffle")
end, false)
