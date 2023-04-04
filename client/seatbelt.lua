local QBCore = exports['qbx-core']:GetCoreObject()
local seatbeltOn = false
local harnessOn = false
local harnessHp = 20
local handbrake = 0
local harnessData = {}
local newvehicleBodyHealth = 0
local currentvehicleBodyHealth = 0
local frameBodyChange = 0
local lastFrameVehiclespeed = 0
local lastFrameVehiclespeed2 = 0
local thisFrameVehicleSpeed = 0
local tick = 0
local damagedone = false
local modifierDensity = true
local lastVehicle = nil
local veloc

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    if GetResourceState('ox_inventory'):match("start") then
        exports.ox_inventory:displayMetadata({
            harnessuses = "Uses",
        })
    end
end)

-- Functions

local function EjectFromVehicle()
    local coords = GetOffsetFromEntityInWorldCoords(cache.vehicle, 1.0, 0.0, 1.0)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z)
    Wait(1)
    SetPedToRagdoll(cache.ped, 5511, 5511, 0, false, false, false)
    SetEntityVelocity(cache.ped, veloc.x*4,veloc.y*4,veloc.z*4)
    local ejectspeed = math.ceil(GetEntitySpeed(cache.ped) * 8)
    if GetEntityHealth(cache.ped) - ejectspeed > 0 then
        SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) - ejectspeed)
    elseif GetEntityHealth(cache.ped) ~= 0 then
        SetEntityHealth(cache.ped, 0)
    end
end

local function ToggleSeatbelt()
    seatbeltOn = not seatbeltOn
    TriggerEvent('seatbelt:client:ToggleSeatbelt')
    TriggerServerEvent('InteractSound_SV:PlayOnSource', seatbeltOn and 'carbuckle' or 'carunbuckle', 0.25)
end

local function ToggleHarness()
    harnessOn = not harnessOn
    if not harnessOn then return end
    ToggleSeatbelt()
end

local function ResetHandBrake()
    if handbrake <= 0 then return end
    handbrake -= 1
end

local function Seatbelt()
    while cache.vehicle do
        local sleep = 1000
        if seatbeltOn or harnessOn then
            sleep = 10
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
        end
        Wait(sleep)
    end
    seatbeltOn = false
    harnessOn = false
end

-- Export

function HasHarness()
    return harnessOn
end

exports('HasHarness', HasHarness)

-- Main Thread

lib.onCache('vehicle', function()
    Seatbelt()
end)

-- Ejection Logic

CreateThread(function()
    while true do
        Wait(0)
        if cache.vehicle and cache.vehicle ~= false and cache.vehicle ~= 0 then
            SetPedHelmet(cache.ped, false)
            lastVehicle = cache.vehicle
            if GetVehicleEngineHealth(cache.vehicle) < 0.0 then
                SetVehicleEngineHealth(cache.vehicle, 0.0)
            end
            if (GetVehicleHandbrake(cache.vehicle) or (GetVehicleSteeringAngle(cache.vehicle)) > 25.0 or (GetVehicleSteeringAngle(cache.vehicle)) < -25.0) then
                if handbrake == 0 then
                    handbrake = 100
                    ResetHandBrake()
                else
                    handbrake = 100
                end
            end

            thisFrameVehicleSpeed = GetEntitySpeed(cache.vehicle) * 3.6
            currentvehicleBodyHealth = GetVehicleBodyHealth(cache.vehicle)
            if currentvehicleBodyHealth == 1000 and frameBodyChange ~= 0 then
                frameBodyChange = 0
            end
            if frameBodyChange ~= 0 then
                if lastFrameVehiclespeed > 110 and thisFrameVehicleSpeed < (lastFrameVehiclespeed * 0.75) and not damagedone then
                    if frameBodyChange > 18.0 then
                        if not seatbeltOn and not IsThisModelABike(cache.vehicle) then
                            if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then
                                if not harnessOn then
                                    EjectFromVehicle()
                                else
                                    harnessHp -= 1
                                    TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                end
                            end
                        elseif (seatbeltOn or harnessOn) and not IsThisModelABike(cache.vehicle) then
                            if lastFrameVehiclespeed > 150 then
                                if math.random(math.ceil(lastFrameVehiclespeed)) > 150 then
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp -= 1
                                        TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                    end
                                end
                            end
                        end
                    else
                        if not seatbeltOn and not IsThisModelABike(cache.vehicle) then
                            if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then
                                if not harnessOn then
                                    EjectFromVehicle()
                                else
                                    harnessHp -= 1
                                    TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                end
                            end
                        elseif (seatbeltOn or harnessOn) and not IsThisModelABike(cache.vehicle) then
                            if lastFrameVehiclespeed > 120 then
                                if math.random(math.ceil(lastFrameVehiclespeed)) > 200 then
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp -= 1
                                        TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                    end
                                end
                            end
                        end
                    end
                    damagedone = true
                    SetVehicleEngineOn(cache.vehicle, false, true, true)
                end
                if currentvehicleBodyHealth < 350.0 and not damagedone then
                    damagedone = true
                    SetVehicleEngineOn(cache.vehicle, false, true, true)
                    Wait(1000)
                end
            end
            if lastFrameVehiclespeed < 100 then
                Wait(100)
                tick = 0
            end
            frameBodyChange = newvehicleBodyHealth - currentvehicleBodyHealth
            if tick > 0 then
                tick -= 1
                if tick == 1 then
                    lastFrameVehiclespeed = GetEntitySpeed(cache.vehicle) * 3.6
                end
            else
                if damagedone then
                    damagedone = false
                    frameBodyChange = 0
                    lastFrameVehiclespeed = GetEntitySpeed(cache.vehicle) * 3.6
                end
                lastFrameVehiclespeed2 = GetEntitySpeed(cache.vehicle) * 3.6
                if lastFrameVehiclespeed2 > lastFrameVehiclespeed then
                    lastFrameVehiclespeed = GetEntitySpeed(cache.vehicle) * 3.6
                end
                if lastFrameVehiclespeed2 < lastFrameVehiclespeed then
                    tick = 25
                end

            end
            if tick < 0 then
                tick = 0
            end
            newvehicleBodyHealth = GetVehicleBodyHealth(cache.vehicle)
            if not modifierDensity then
                modifierDensity = true
            end
            veloc = GetEntityVelocity(cache.vehicle)
        else
            if lastVehicle then
                SetPedHelmet(cache.ped, true)
                Wait(200)
                newvehicleBodyHealth = GetVehicleBodyHealth(lastVehicle)
                if not damagedone and newvehicleBodyHealth < currentvehicleBodyHealth then
                    damagedone = true
                    SetVehicleEngineOn(lastVehicle, false, true, true)
                    Wait(1000)
                end
                lastVehicle = nil
            end
            lastFrameVehiclespeed2 = 0
            lastFrameVehiclespeed = 0
            newvehicleBodyHealth = 0
            currentvehicleBodyHealth = 0
            frameBodyChange = 0
            Wait(2000)
        end
    end
end)

-- Events

RegisterNetEvent('seatbelt:client:UseHarness', function(ItemData)
    local class = GetVehicleClass(cache.vehicle)
    if cache.vehicle and class ~= 8 and class ~= 13 and class ~= 14 then
        if not harnessOn then
            LocalPlayer.state:set('inv_busy', true, true)
            if lib.progressCircle({
                duration = 5000,
                label = 'Attaching Race Harness',
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    combat = true
                }
            }) then
                LocalPlayer.state:set('inv_busy', false, true)
                ToggleHarness()
                TriggerServerEvent('equip:harness', ItemData)
            end
            harnessHp = ItemData.metadata.harnessuses
            harnessData = ItemData
            TriggerEvent('hud:client:UpdateHarness', harnessHp)
        else
            LocalPlayer.state:set('inv_busy', true, true)
            if lib.progressCircle({
                duration = 5000,
                label = 'Removing Race Harness',
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    combat = true
                }
            }) then
                LocalPlayer.state:set('inv_busy', false, true)
                ToggleHarness()
            end
        end
    else
        QBCore.Functions.Notify('You\'re not in a car.', 'error')
    end
end)

-- Register Key

RegisterCommand('toggleseatbelt', function()
    if not cache.vehicle or IsPauseMenuActive() then return end
    local class = GetVehicleClass(cache.vehicle)
    if class == 8 or class == 13 or class == 14 then return end
    ToggleSeatbelt()
end, false)

RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'B')
