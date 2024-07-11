lib.callback.register('tackle:server:TacklePlayer', function(source, target)
    TriggerClientEvent('tackle:client:GetTackled', target)
end)
