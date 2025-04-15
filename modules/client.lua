local BDc = {}

function BDc.HasKeys(vehicle)
    if not vehicle then return false end
    
    if GetResourceState('qbx_vehiclekeys'):match('started') then
        return exports.qbx_vehiclekeys:HasKeys(vehicle)
    elseif GetResourceState('Renewed-Vehiclekeys'):match('started') then
        return exports['Renewed-Vehiclekeys']:hasKey(vehicle)
    else
        -- Fallback logic if neither keysystem is available
        -- You might want to check if player owns the vehicle or similar
        return false
    end
end

return BDc