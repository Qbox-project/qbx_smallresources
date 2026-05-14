lib.callback.register('qbx_staticemitters:server:IsPlayerAceAllowed', function(src)
    return IsPlayerAceAllowed(src, 'admin')
end)