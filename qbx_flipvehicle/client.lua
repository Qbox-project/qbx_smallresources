local config = lib.loadJson('qbx_flipvehicle.config.json')

--- @param vehicle number? id of the vehicle, default closes vehicle
--- @param flipTest boolean? costom fliping task
local function flipVehicle(vehicle, flipTest)
    if cache.vehicle then return end
    if not vehicle then vehicle = lib.getClosestVehicle(cache.ped, cache.maxDistance) end
    if not vehicle then return exports.qbx_core:Notify(locale('error.no_vehicle_nearby'), 'error') end
    local peedCoords = GetEntityCoords(cache.ped)
    local vehicleCoords = GetEntityCoords(vehicle)

    if #(peedCoords - vehicleCoords) > config.maxDistance then
        return exports.qbx_core:Notify(locale('error.no_vehicle_nearby'), 'error')
    end

    if flipTest or lib.progressBar({
        label = locale('progress.flipping_car'),
        duration = config.flipingTime,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        },
    }) then
        SetVehicleOnGroundProperly(vehicle)
        exports.qbx_core:Notify(locale('success.flipped_car'), 'success')
    else
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end

exports('flipVehicle', flipVehicle)
exports('FlipVehicle', flipVehicle)
