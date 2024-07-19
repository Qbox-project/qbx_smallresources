AddStateBagChangeHandler('crouch', ('player:%s'):format(cache.serverId), function(_, _, value, _, replicated)
  if replicated then return end
  lib.requestAnimSet('move_Ped_crouched')
  if not value then
    ResetPedMovementClipset(cache.ped, 1.0)
    ResetPedWeaponMovementClipset(cache.ped)
    ResetPedStrafeClipset(cache.ped)
    SetPedStealthMovement(cache.ped, false, 'DEFAULT_ACTION')
  else
    SetPedMovementClipset(cache.ped, 'move_Ped_crouched', 1.0)
    SetPedStrafeClipset(cache.ped, 'move_Ped_crouched_strafing')
  end
  RemoveAnimSet('move_Ped_crouched')
end)

lib.addKeybind({
  name = 'crouch',
  description = 'Crouch',
  defaultKey = 'K',
  onReleased = function(self)
    if cache.vehicle then return end
      LocalPlayer.state:set("crouch", not LocalPlayer.state.crouch, false)
  end
})
  
