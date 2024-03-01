local config = require 'config.client'
local disableHudComponents = config.disable.hudComponents
local disableControls = config.disable.controls
local displayAmmo = config.disable.displayAmmo

DecorRegister("ScriptedPed", 2)
local densityReasons = {}
local currentDensity = 0.8
local pedDensity = 1.0
local vehicleIsSpeeding = false
local isDriverSeatEmpty = false
local populationDensity = 0.8
local disabledDensity = false

local function registerDensityReason(pReason, pPriority)
  densityReasons[pReason] = { reason = pReason, priority = pPriority, level = -1, active = false }
end

exports('registerDensityReason', registerDensityReason)

local function setDensity(pReason, pLevel)
  if not densityReasons[pReason] then return end

  densityReasons[pReason]['level'] = pLevel

  local level = populationDensity
  local priority

  for _, reason in pairs(densityReasons) do
    if reason.level ~= -1 and (not priority or priority < reason.priority) then
      priority = reason.priority
      level = reason.level
    end
  end

  lib.print.warn("density", level)

  density = level + 0.0
end

exports('setDensity', setDensity)

CreateThread(function()
  while true do
    local vehDensity = vehicleIsSpeeding and (isDriverSeatEmpty and 0.1 or 0.0) or currentDensity

    if disabledDensity then vehDensity = 1.0 end

    SetParkedVehicleDensityMultiplierThisFrame(pedDensity)
    SetVehicleDensityMultiplierThisFrame(vehDensity)
    SetRandomVehicleDensityMultiplierThisFrame(vehDensity)
    SetPedDensityMultiplierThisFrame(pedDensity)
    SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity)
    Wait(0)
  end
end)

CreateThread(function()
    while true do

        -- Hud Components

        for i = 1, #disableHudComponents do
            HideHudComponentThisFrame(disableHudComponents[i])
        end

        for i = 1, #disableControls do
            DisableControlAction(2, disableControls[i], true)
        end

        DisplayAmmoThisFrame(displayAmmo)
    end
end)

local function addDisableHudComponents(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        disableHudComponents[#disableHudComponents+1] = hudComponents
    elseif hudComponentsType == 'table' and table.type(hudComponents) == 'array' then
        for i = 1, #hudComponents do
            disableHudComponents[#disableHudComponents+1] = hudComponents[i]
        end
    end
end

exports('addDisableHudComponents', addDisableHudComponents)

local function removeDisableHudComponents(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        for i = 1, #disableHudComponents do
            if disableHudComponents[i] == hudComponents then
                table.remove(disableHudComponents, i)
                break
            end
        end
    elseif hudComponentsType == 'table' and table.type(hudComponents) == 'array' then
        for i = 1, #disableHudComponents do
            for i2 = 1, #hudComponents do
                if disableHudComponents[i] == hudComponents[i2] then
                    table.remove(disableHudComponents, i)
                end
            end
        end
    end
end

exports('removeDisableHudComponents', removeDisableHudComponents)

local function getDisableHudComponents()
    return disableHudComponents
end

exports('getDisableHudComponents', getDisableHudComponents)

local function addDisableControls(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        disableControls[#disableControls+1] = controls
    elseif controlsType == 'table' and table.type(controls) == 'array' then
        for i = 1, #controls do
            disableControls[#disableControls+1] = controls[i]
        end
    end
end

exports('addDisableControls', addDisableControls)

local function removeDisableControls(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        for i = 1, #disableControls do
            if disableControls[i] == controls then
                table.remove(disableControls, i)
                break
            end
        end
    elseif controlsType == 'table' and table.type(controls) == 'array' then
        for i = 1, #disableControls do
            for i2 = 1, #controls do
                if disableControls[i] == controls[i2] then
                    table.remove(disableControls, i)
                end
            end
        end
    end
end

exports('removeDisableControls', removeDisableControls)

local function getDisableControls()
    return disableControls
end

exports('getDisableControls', getDisableControls)

local function setDisplayAmmo(bool)
    displayAmmo = bool
end

exports('setDisplayAmmo', setDisplayAmmo)

local function getDisplayAmmo()
    return displayAmmo
end

exports('getDisplayAmmo', getDisplayAmmo)
