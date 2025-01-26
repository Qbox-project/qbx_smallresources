---@alias Direction 'right' | 'left' | 'front' | 'back' | nil

local config = lib.loadJson('qbx_vehiclepush.config')
local dict = 'missfinale_c2ig_11'
local pressed = {
    e = false,
    shift = false
}

---@type Direction
local pushingControl = nil

---@param vehicle number
---@return boolean
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

---@param vehicle number
---@param value Direction
local function vehicleControl(vehicle, value)
    if not pushingControl then -- initial loop for new owner
        local oldDirection = value -- save old front | back direction for new owner

        CreateThread(function()
            local ped = cache.ped
            local playerId = cache.playerId

            pushingControl = value

            while DoesEntityExist(vehicle) and pushingControl and NetworkGetEntityOwner(vehicle) == playerId do
                Wait(0)
                if pushingControl == 'left' then
                    TaskVehicleTempAction(ped, vehicle, 11, 1)
                elseif pushingControl == 'right' then
                    TaskVehicleTempAction(ped, vehicle, 10, 1)
                end

                SetVehicleForwardSpeed(vehicle, value == 'front' and -1.0 or 1.0)

                if HasEntityCollidedWithAnything(vehicle) then
                    SetVehicleOnGroundProperly(vehicle)
                end
            end

            if DoesEntityExist(vehicle) and NetworkGetEntityOwner(vehicle) ~= playerId and pushingControl then -- handle changing owner in the middle of pushing
                TriggerServerEvent('qbx_vehiclepush:server:push', {
                    direction = oldDirection,
                    netId = VehToNet(vehicle)
                })
            end
        end)
    end

    pushingControl = value
end

---@param vehicle number
local function isVehicleValid(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)

    return ((engineHealth >= 0 and engineHealth <= config.damageNeeded) or (Entity(vehicle).state.fuel or 100) < 3) and IsVehicleSeatFree(vehicle, -1) and checkClass(vehicle)
end

---@param vehicle number
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

---@param vehicle number
---@param direction Direction
local function taskControlVehicle(vehicle, direction)
    if NetworkGetEntityOwner(vehicle) == cache.playerId then
        vehicleControl(vehicle, direction)
    else
        TriggerServerEvent('qbx_vehiclepush:server:push', {
            direction = direction,
            netId = VehToNet(vehicle)
        })
    end
end

local function pushVehicle()
    if cache.vehicle then return end

    local ped = cache.ped
    local vehicle, vehicleCoords = lib.getClosestVehicle(GetEntityCoords(ped), 3.0)
    if not vehicle then return end

    if IsEntityAttachedToEntity(cache.ped, vehicle) or not isVehicleValid(vehicle) then return end

    vehicleValidityThread(vehicle)

    if not pressed.e or not pressed.shift then return end

    local pedCoords = GetEntityCoords(ped)
    local boneIndex = GetPedBoneIndex(ped, 6286)
    local dimensions = GetModelDimensions(GetEntityModel(vehicle))
    local vehicleForwardVector = GetEntityForwardVector(vehicle)
    local isInFront = #(vehicleCoords - pedCoords + vehicleForwardVector) < #(vehicleCoords - pedCoords - vehicleForwardVector)

    if isInFront then
        AttachEntityToEntity(ped, vehicle, boneIndex, 0.0, dimensions.y * -1 + 0.1, dimensions.z + 1.0, 0.0, 0.0, 180.0,
            false, false, false, true, 0, true)
    else
        AttachEntityToEntity(ped, vehicle, boneIndex, 0.0, dimensions.y - 0.3, dimensions.z + 1.0, 0.0, 0.0, 0.0, false,
            false, false, true, 0, true)
    end

    lib.playAnim(ped, dict, 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)

    local direction = isInFront and 'front' or 'back'
    taskControlVehicle(vehicle, direction)

    CreateThread(function()
        local wheelsDirection = ''
        while pressed.shift and not cache.vehicle do
            local newDirection = nil

            if IsDisabledControlPressed(0, 34) then
                newDirection = 'left'
            elseif IsDisabledControlPressed(0, 9) then
                newDirection = 'right'
            end

            if newDirection and wheelsDirection ~= newDirection then
                wheelsDirection = newDirection
                taskControlVehicle(vehicle, wheelsDirection)
            end

            Wait(0)
        end

        DetachEntity(ped, false, false)
        StopAnimTask(ped, dict, 'pushcar_offcliff_m', 2.0)
        FreezeEntityPosition(ped, false)
        taskControlVehicle(vehicle)

        pushingControl = nil
    end)

    return vehicle
end

AddStateBagChangeHandler('pushVehicle', nil, function(bagName, _, value)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end

    if NetworkGetEntityOwner(entity) ~= cache.playerId then return end

    if not value then
        pushingControl = nil
        return
    end

    vehicleControl(entity, value)
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
    onPressed = function(self)
        pressed.shift = true
        if not pressed.e then return end

        self.vehicle = pushVehicle()
    end,
    onReleased = function(self)
        pressed.shift = false
        if self.vehicle then
            taskControlVehicle(self.vehicle)
        end
    end
})
