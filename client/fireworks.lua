local fireworkTime = 0
local fireworkLoc = nil
local fireworkList = {
    ['proj_xmas_firework'] = {
        'scr_firework_xmas_ring_burst_rgw',
        'scr_firework_xmas_burst_rgw',
        'scr_firework_xmas_repeat_burst_rgw',
        'scr_firework_xmas_spiral_burst_rgw',
        'scr_xmas_firework_sparkle_spawn',
    },
    ['scr_indep_fireworks'] = {
        'scr_indep_firework_sparkle_spawn',
        'scr_indep_firework_starburst',
        'scr_indep_firework_shotburst',
        'scr_indep_firework_trailburst',
        'scr_indep_firework_trailburst_spawn',
        'scr_indep_firework_burst_spawn',
        'scr_indep_firework_trail_spawn',
        'scr_indep_firework_fountain',
    },
    ['proj_indep_firework'] = {
        'scr_indep_firework_grd_burst',
        'scr_indep_launcher_sparkle_spawn',
        'scr_indep_firework_air_burst',
        'proj_indep_flare_trail',
    },
    ['proj_indep_firework_v2'] = {
        'scr_firework_indep_burst_rwb',
        'scr_firework_indep_spiral_burst_rwb',
        'scr_xmas_firework_sparkle_spawn',
        'scr_firework_indep_ring_burst_rwb',
        'scr_xmas_firework_burst_fizzle',
        'scr_firework_indep_repeat_burst_rwb',
    },
}

local function doFirework(asset, coords)
    fireworkTime = 5
    fireworkLoc = {x = coords.x, y = coords.y, z = coords.z}
    CreateThread(function()
        while fireworkTime > 0 do
            Wait(1000)
            fireworkTime -= 1
        end
        UseParticleFxAsset('scr_indep_fireworks')
        for _ = 1, math.random(5, 10), 1 do
            local firework = fireworkList[asset][math.random(1, #fireworkList[asset])]
            UseParticleFxAsset(asset)
            StartNetworkedParticleFxNonLoopedAtCoord(firework, fireworkLoc.x, fireworkLoc.y, fireworkLoc.z + 42.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false)
            Wait(math.random()*500)
        end
        fireworkLoc = nil
    end)
end

CreateThread(function()
    local assets = {
        'scr_indep_fireworks',
        'proj_xmas_firework',
        'proj_indep_firework_v2',
        'proj_indep_firework'
    }
    
    for i = 1, #assets do
        lib.requestNamedPtfxAsset(assets[i])
    end

    while true do
        Wait(700)
        if fireworkTime > 0 and fireworkLoc then
            DrawText3D('Firework over ~r~'..fireworkTime, fireworkLoc)
        end
    end
end)

RegisterNetEvent('fireworks:client:UseFirework', function(itemName, assetName)
    if lib.progressBar({
        duration = 3000,
        label = 'Placing firework...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'anim@narcotics@trash',
            clip = 'drop_front',
            flag = 16
        },
    }) then
        TriggerServerEvent('consumables:server:UseFirework', itemName)
        TriggerEvent('inventory:client:ItemBox', exports.ox_inventory:Items()[itemName], 'remove')
        local pos = GetEntityCoords(cache.ped)
        doFirework(assetName, pos)
    else
        exports.qbx_core:Notify('Canceled...', 'error')
    end
end)
