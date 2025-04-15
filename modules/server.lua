local BDs = {}

function BDs.GiveKeys(source, vehNetID)
    local vehicle = NetworkGetEntityFromNetworkId(vehNetID)
    if not vehicle or vehicle == 0 then return end

    if GetResourceState('qbx_vehiclekeys'):match('started') then
        TriggerClientEvent('qbx_vehiclekeys:client:GiveKeys', source, vehicle)
    elseif GetResourceState('Renewed-Vehiclekeys'):match('started') then
        exports['Renewed-Vehiclekeys']:addKey(source, vehicle)
    else
        -- Fallback for other key systems
    end
end

return BDs