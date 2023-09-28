CreateThread(function()
    for _, v in pairs(exports.qbx_core:GetVehiclesByName()) do
        local text
        if v.brand then
            text = v.brand .. ' ' .. v.name
        else
            text = v.name
        end
        if v.hash ~= 0 and v.hash ~= nil then
            AddTextEntryByHash(v.hash, text)
        end
    end
end)
