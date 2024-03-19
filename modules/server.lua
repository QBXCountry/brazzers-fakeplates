local BDs = {}

function BDs.GiveKeys(source, plate)
    if GetResourceState('qbx_vehiclekeys'):match('started') then
        TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    elseif GetResourceState('Renewed-Vehiclekeys'):match('started') then
        exports['Renewed-Vehiclekeys']:addKey(source, plate)
    else
        -- Insert your own key here!
    end
end

return BDs