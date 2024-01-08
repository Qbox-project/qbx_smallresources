CreateThread(function()
    for _, v in pairs(exports.qbx_core:GetVehiclesByName()) do
        local text
        if v.brand then
            text = v.brand .. ' ' .. v.name
        else
            text = v.name
        end
        if v.hash then
            AddTextEntryByHash(GetDisplayNameFromVehicleModel(v.model), text)
        end
    end
end)
