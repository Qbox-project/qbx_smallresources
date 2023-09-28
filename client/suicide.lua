local suicideWeapons = {
	`WEAPON_PISTOL`,
	`WEAPON_PISTOL_MK2`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_APPISTOL`,
	`WEAPON_PISTOL50`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_SNSPISTOL_MK2`,
	`WEAPON_REVOLVER`,
	`WEAPON_REVOLVER_MK2`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_MARKSMANPISTOL`
}

RegisterCommand('suicide', function()
	local canSuicide = false
    for i = 1, #suicideWeapons do
        if cache.weapon == suicideWeapons[i] then
            if GetAmmoInPedWeapon(cache.ped, cache.weapon) > 0 then
                canSuicide = true
                break
            end
        end
    end
	if canSuicide then
        lib.requestAnimDict('mp_suicide')
		TaskPlayAnim(cache.ped, 'mp_suicide', 'pistol', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
		Wait(750)
		SetPedShootsAtCoord(cache.ped, 0.0, 0.0, 0.0, 0)
		SetEntityHealth(cache.ped, 0)
        exports.qbx_core:Notify('You killed yourself', 'error')
    else
        exports.qbx_core:Notify('You don\'t have a pistol with ammo in your hand', 'error')
	end
end, false)