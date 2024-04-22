RegisterNetEvent('tackle:server:TacklePlayer', function(source)
    TriggerClientEvent('tackle:client:GetTackled', source)
end)
