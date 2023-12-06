-- Variables
local prop = 0
local alcoholCount = 0
local drunk = false
local drunkDriving = false
local timing = false
local ParachuteEquiped = false


RegisterNetEvent('consumables:client:Eat', function(itemName)
    if not Config.ConsumablesEat[itemName] then return end

    local consume = Config.ConsumablesEat[itemName]

    if consume.prop then
        local propData = consume.prop
        lib.requestModel(propData.model)
        prop = CreateObject(joaat(propData.model), 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, propData.bone), propData.coords.x, propData.coords.y, propData.coords.z, propData.rot.x, propData.rot.y, propData.rot.z, true, true, false, true, 1, true)
    end

    if consume.anim then
        local anim = consume.anim
        lib.requestAnimDict(anim.lib)
        TaskPlayAnim(cache.ped, anim.lib, anim.name, 8.0, 1.0, -1, anim.flag, 0, false, false, false)
    elseif consume.scenario then
        TaskStartScenarioInPlace(cache.ped, consume.scenario, 0, true)
    else
        exports.scully_emotemenu:playEmoteByCommand(consume.emote or "eat")
    end

    if lib.progressBar({
        duration = consume.progress or 5000,
        label = consume.label or 'Eating...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        if prop ~= 0 then
            DeleteEntity(prop)
            prop = 0
        end
        lib.callback('consumables:server:AddHunger', false, function(retreval)
            if retreval then
                if consume.relieveStress then
                    TriggerServerEvent('hud:server:RelieveStress', consume.relieveStress)
                end
                if consume.action then
                    consume.action(itemName)
                end
            end
        end, itemName)
    else
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        lib.notify({
            description = "Cancelled",
            type = "error",
        })
    end
end)

RegisterNetEvent('consumables:client:Drink', function(itemName)
    if not Config.ConsumablesDrink[itemName] then return end

    local consume = Config.ConsumablesDrink[itemName]

    if consume.prop then
        local propData = consume.prop
        lib.requestModel(propData.model)
        prop = CreateObject(joaat(propData.model), 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, propData.bone), propData.coords.x, propData.coords.y, propData.coords.z, propData.rot.x, propData.rot.y, propData.rot.z, true, true, false, true, 1, true)
    end

    if consume.anim then
        local anim = consume.anim
        lib.requestAnimDict(anim.lib)
        TaskPlayAnim(cache.ped, anim.lib, anim.name, 8.0, 1.0, -1, anim.flag, 0, false, false, false)
    elseif consume.scenario then
        TaskStartScenarioInPlace(cache.ped, consume.scenario, 0, true)
    else
        exports.scully_emotemenu:playEmoteByCommand(consume.emote or "drink")
    end

    if lib.progressBar({
        duration = consume.progress or 5000,
        label = consume.label or 'Drinking...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        if prop ~= 0 then
            DeleteEntity(prop)
            prop = 0
        end
        lib.callback('consumables:server:AddThirst', false, function(retreval)
            if retreval then
                if consume.relieveStress then
                    TriggerServerEvent('hud:server:RelieveStress', consume.relieveStress)
                end
                if consume.action then
                    consume.action(itemName)
                end
            end
        end, itemName)
    else
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        lib.notify({
            description = "Cancelled",
            type = "error",
        })
    end
end)

RegisterNetEvent('consumables:client:Addiction', function(itemName)
    if not Config.ConsumablesAddiction[itemName] then return end

    local consume = Config.ConsumablesAddiction[itemName]

    if consume.prop then
        local propData = consume.prop
        lib.requestModel(propData.model)
        prop = CreateObject(joaat(propData.model), 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, propData.bone), propData.coords.x, propData.coords.y, propData.coords.z, propData.rot.x, propData.rot.y, propData.rot.z, true, true, false, true, 1, true)
    end

    if consume.anim then
        local anim = consume.anim
        lib.requestAnimDict(anim.lib)
        TaskPlayAnim(cache.ped, anim.lib, anim.name, 8.0, 1.0, -1, anim.flag, 0, false, false, false)
    elseif consume.scenario then
        TaskStartScenarioInPlace(cache.ped, consume.scenario, 0, true)
    else
        exports.scully_emotemenu:playEmoteByCommand(consume.emote or "smokeweed")
    end

    if lib.progressBar({
        duration = consume.progress or 5000,
        label = consume.label or 'Doing addiction...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        if prop ~= 0 then
            DeleteEntity(prop)
            prop = 0
        end
        lib.callback('consumables:server:useIllegal', false, function(retreval)
            if retreval then
                if consume.relieveStress then
                    TriggerServerEvent('hud:server:RelieveStress', consume.relieveStress)
                end
                if consume.action then
                    consume.action(itemName)
                end
            end
        end, itemName)
    else
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        lib.notify({
            description = "Cancelled",
            type = "error",
        })
    end
end)

RegisterNetEvent('consumables:client:Item', function(itemName)
    if not Config.ConsumablesItems[itemName] then return end

    local consume = Config.ConsumablesItems[itemName]

    if consume.prop then
        local propData = consume.prop
        lib.requestModel(propData.model)
        prop = CreateObject(joaat(propData.model), 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, propData.bone), propData.coords.x, propData.coords.y, propData.coords.z, propData.rot.x, propData.rot.y, propData.rot.z, true, true, false, true, 1, true)
    end

    if consume.anim then
        local anim = consume.anim
        lib.requestAnimDict(anim.lib)
        TaskPlayAnim(cache.ped, anim.lib, anim.name, 8.0, 1.0, -1, anim.flag, 0, false, false, false)
    elseif consume.scenario then
        TaskStartScenarioInPlace(cache.ped, consume.scenario, 0, true)
    elseif consume.emote then
        exports.scully_emotemenu:playEmoteByCommand(consume.emote)
    end

    if lib.progressBar({
        duration = consume.progress or 5000,
        label = consume.label or 'Using item...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        }
    }) then -- if completed
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        elseif consume.emote then
            exports.scully_emotemenu:cancelEmote()
        end
        if prop ~= 0 then
            DeleteEntity(prop)
            prop = 0
        end
        lib.callback('consumables:server:useItem', false, function(retreval)
            if retreval then
                if consume.action then
                    consume.action(itemName)
                end
            end
        end, itemName)
    else
        if consume.anim or consume.scenario then
            ClearPedTasks(cache.ped)
        elseif consume.emote then
            exports.scully_emotemenu:cancelEmote()
        end
        lib.notify({
            description = "Cancelled",
            type = "error",
        })
    end
end)

RegisterNetEvent('consumables:client:ResetParachute', function()
    if GetterParachute() then
        lib.requestAnimDict("clothingshirt")
        TaskPlayAnim(cache.ped, "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, false, false, false)
        if lib.progressBar({
            duration = 40000,
            label = 'Packing parachute...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            }
        }) then -- if completed
            local ped = cache.ped
            local ParachuteRemoveData = {
                outfitData = {
                    ["bag"] = { item = 0, texture = 0} -- Removing Parachute Clothing
                }
            }
            TriggerEvent('qb-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, false, false, false)
            TriggerServerEvent("consumables:server:AddParachute")
            SetterParachute(false)
        end
    else
        lib.notify({
            description = 'No parachute found',
            type = "error",
        })
    end
end)

local function timer()
	local time = 300
	CreateThread( function()
		if not timing then
			timing = true
			while timer ~= 0 do
				Wait(5000) --- update timer every 5 seconds
				time = time - 5
				if time == 0 then
					Sober()
					return
				end
			end
		end
	end)
end

-- Return to reality
function Sober()
	CreateThread(function()
		local playerPed = cache.ped
		timing = false
		drunk = false
		drunkDriving = false
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
		ClearPedSecondaryTask(playerPed)
		ShakeGameplayCam("DRUNK_SHAKE", 0.0)

	end)
end

local function fuckDrunkDriver()

	math.randomseed(GetGameTimer())

	local shitFuckDamn = math.random(1, #Config.RandomVehicleInteraction)
	return Config.RandomVehicleInteraction[shitFuckDamn]
end

local function setPlayerDrunk(anim, shake)
	local PlayerPed = cache.ped

	RequestAnimSet(anim)

	while not HasAnimSetLoaded(anim) do
		Wait(100)
	end

	SetPedMovementClipset(PlayerPed, anim, 1)
	ShakeGameplayCam("DRUNK_SHAKE", shake)
	SetPedMotionBlur(PlayerPed, true)
	SetPedIsDrunk(PlayerPed, true)

end

local function alcoholAction()
    if alcoholCount <= 1 then return end
    local anim, shake = 'move_m@drunk@slightlydrunk', 1.0
	if alcoholCount == 2 then
		anim = "move_m@drunk@slightlydrunk"
		shake = 1.0
		setPlayerDrunk(anim, shake)

	elseif alcoholCount == 3 then
		anim = "move_m@drunk@moderatedrunk"
		shake = 2.0
		setPlayerDrunk(anim, shake)

	elseif alcoholCount >= 4 then
		anim = "move_m@drunk@verydrunk"
		shake = 2.0
		setPlayerDrunk(anim, shake)
        
	end

	if not drunk then
		drunk = true
		timer()
		CreateThread(function()
			local PlayerPed = cache.ped
			drunkDriving = true

			while drunkDriving do
				Wait(Config.Fuckage) -- How often you want to fuck with the driver
				if IsPedInAnyVehicle(PlayerPed, false) or IsPedInAnyVehicle(PlayerPed, false) == 0 then
					local vehicle = GetVehiclePedIsIn(PlayerPed, false)
					if GetPedInVehicleSeat(vehicle, -1) == PlayerPed then
						local class = GetVehicleClass(vehicle)

						if class ~= 15 or 16 or 21 or 13 then
							local whatToFuckThemWith = fuckDrunkDriver()
							TaskVehicleTempAction(PlayerPed, vehicle, whatToFuckThemWith.interaction, whatToFuckThemWith.time)
						end
					end
				end
			end
		end)
	end
end

local looped = false
function AlcoholLoop()
    alcoholCount = alcoholCount + 1
    if alcoholCount > 1 and alcoholCount < 4 then
        TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
    elseif alcoholCount >= 4 then
        TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
    end
    alcoholAction()
    if not looped then
        looped = true
        CreateThread(function()
            while true do
                Wait(10)
                if alcoholCount > 0 then
                    Wait(1000 * 60 * 15)
                    alcoholCount -= 1
                else
                    looped = false
                    break
                end
            end
        end)
    end
end

function GetterParachute()
    print('get data')
    return ParachuteEquiped
end

function SetterParachute(data)
    print('set data')
    ParachuteEquiped = data
end

RegisterCommand('getdata', function()
    print(ParachuteEquiped)
end, false)