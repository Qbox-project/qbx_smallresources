local weapons = {}

for k, v in pairs(Weapons.List) do
	weapons[GetHashKey(k)] = v
end

lib.onCache('weapon', function(weapon)
	if weapon then
		if weapons[weapon] and weapons[weapon].disableHeadshot then
			-- i dunno how this native work
			SetPedSuffersCriticalHits(cache.ped, false)
		end
	end
end)

AddEventHandler('CEventGunShot', function(entity, ped, coords)
	if cache.ped ~= ped then return end
	if not weapons[cache.weapon] then return end
	local tv = 0
	local p
	local cfg = weapons[cache.weapon]
	if cfg.damage then
		SetWeaponDamageModifier(cache.weapon, cfg.damage)
	end
	if cfg.recoil then
		if GetFollowPedCamViewMode() ~= 4 then
			if cfg.shake then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', cfg.shake)
			end
			repeat
				Wait(0)
				SetWeaponAnimationOverride(cache.ped, GetHashKey('Default'))
				p = GetGameplayCamRelativePitch()
				SetGameplayCamRelativePitch(p + 0.1, 0.5)
				tv = tv + 0.1
			until tv >= cfg.recoil
		else
			if cfg.shake then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', cfg.shake)
			end
			repeat
				Wait(0)
				SetWeaponAnimationOverride(cache.ped, GetHashKey('FirstPersonAiming'))
				p = GetGameplayCamRelativePitch()
				if cfg.recoil > 0.1 then
					SetGameplayCamRelativePitch(p + 0.6, 1.2)
					tv = tv + 0.6
				else
					SetGameplayCamRelativePitch(p + 0.016, 0.333)
					tv = tv + 0.1
				end
			until tv >= cfg.recoil
		end
	end
end)
