local config = lib.loadJson('qbx_vehiclepush.config')
local dict = 'missfinale_c2ig_11'
local pressed = {
    e = false,
    shift = false
}

local function checkClass(vehicle)
    local classes = config.blacklistedClasses
    local currentClass = GetVehicleClass(vehicle)

    for i = 1, #classes do
        if currentClass == classes[i] then
            return false
        end
    end
    return true
end

local function vehicleControl(vehicle, isInFront)
    local ped = cache.ped
    while true do
        Wait(0)
        if IsDisabledControlPressed(0, 34) then
            TaskVehicleTempAction(ped, vehicle, 11, 1)
        end

        if IsDisabledControlPressed(0, 9) then
            TaskVehicleTempAction(ped, vehicle, 10, 1)
        end

        SetVehicleForwardSpeed(vehicle, isInFront and -1.0 or 1.0)

        if HasEntityCollidedWithAnything(vehicle) then
            SetVehicleOnGroundProperly(vehicle)
        end

        if cache.vehicle or not pressed.shift then
            DetachEntity(ped, false, false)
            StopAnimTask(ped, dict, 'pushcar_offcliff_m', 2.0)
            FreezeEntityPosition(ped, false)
            break
        end
    end
end

local function pushVehicleThread(vehicle, vehicleCoords)
    local ped = cache.ped
    local playerId = cache.playerId
    local boneIndex = GetPedBoneIndex(ped, 6286)
    local dimensions = GetModelDimensions(GetEntityModel(vehicle))
    lib.requestAnimDict(dict)

    while pressed.e and pressed.shift do
        Wait(0)

        local pedCoords = GetEntityCoords(ped)

        local vehicleForwardVector = GetEntityForwardVector(vehicle)
        local isInFront = #(vehicleCoords - pedCoords + vehicleForwardVector) < #(vehicleCoords - pedCoords - vehicleForwardVector)

        if isInFront then
            AttachEntityToEntity(ped, vehicle, boneIndex, 0.0, dimensions.y * -1 + 0.1, dimensions.z + 1.0, 0.0, 0.0, 180.0, false, false, false, true, 0, true)
        else
            AttachEntityToEntity(ped, vehicle, boneIndex, 0.0, dimensions.y - 0.3, dimensions.z + 1.0, 0.0, 0.0, 0.0, false, false, false, true, 0, true)
        end

        TaskPlayAnim(ped, dict, 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)

        -- control loop
        if NetworkGetEntityOwner(vehicle) == playerId then
            vehicleControl(vehicle, isInFront)
        else
            Entity(vehicle).state:set('pushVehicle', isInFront and 'front' or 'back', true)
        end
    end

    RemoveAnimDict(dict)
end

local function isVehicleValid(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)

    return ((engineHealth >= 0 and engineHealth <= config.damageNeeded) or (Entity(vehicle).state.fuel or 100) < 3) and IsVehicleSeatFree(vehicle, -1) and checkClass(vehicle)
end

local function vehicleValidityThread(vehicle)
    CreateThread(function()
        while pressed.e and pressed.shift do
            Wait(500)
            if not isVehicleValid(vehicle) then
                pressed.e = false
                pressed.shift = false
            end
        end
    end)
end

local function pushVehicle()
    if cache.vehicle then return end

    local ped = cache.ped

    local vehicle, vehicleCoords = lib.getClosestVehicle(GetEntityCoords(ped), 3.0)
    if not vehicle then return end

    if IsEntityAttachedToEntity(cache.ped, vehicle) or not isVehicleValid(vehicle) then return end

    vehicleValidityThread(vehicle)
    pushVehicleThread(vehicle, vehicleCoords)
end

AddStateBagChangeHandler("pushVehicle", nil, function(bagName, key, value)
    if not value then return end

    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end

    if NetworkGetEntityOwner(entity) ~= cache.playerId then return end

    vehicleControl(entity, value == 'front')
    Wait(0)
    Entity(entity).state:set('pushVehicle', false, true)
end)

lib.addKeybind({
    name = 'push_vehicle_e',
    description = 'first keybind to push vehicle',
    defaultKey = 'E',
    onPressed = function()
        pressed.e = true
        if not pressed.shift then return end

        pushVehicle()
    end,
    onReleased = function()
        pressed.e = false
    end
})

lib.addKeybind({
    name = 'push_vehicle',
    description = 'second keybind to push vehicle',
    defaultKey = 'LSHIFT',
    onPressed = function()
        pressed.shift = true
        if not pressed.e then return end

        pushVehicle()
    end,
    onReleased = function()
        pressed.shift = false
    end
})
