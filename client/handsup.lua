local animDict = "missminuteman_1ig_2"
local anim = "handsup_base"
local handsup = false
local disableHandsupControls = {24, 25, 47, 58, 59, 63, 64, 71, 72, 75, 140, 141, 142, 143, 257, 263, 264}

lib.addKeybind({
    name = 'hu',
    description = 'Put your hands up',
    defaultKey = 'X',
    onPressed = function(_)
        handsup = not handsup

        if exports['qb-policejob']:IsHandcuffed() then
            return
        end

        if handsup then
            lib.requestAnimDict(animDict)

            TaskPlayAnim(cache.ped, animDict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
            RemoveAnimDict(animDict)

            exports['qb-smallresources']:addDisableControls(disableHandsupControls)
        else
            ClearPedTasks(cache.ped)

            exports['qb-smallresources']:removeDisableControls(disableHandsupControls)
        end
    end
})

exports('getHandsup', function()
    return handsup
end)