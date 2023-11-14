local BDc = {}

function BDc.HasKeys(plate)
    if GetResourceState('qbx_vehiclekeys'):match('started') then
        exports.qbx_vehiclekeys:HasKeys(plate)
    elseif GetResourceState('Renewed-Vehiclekeys'):match('started') then
        exports['Renewed-Vehiclekeys']:hasKey(plate)
    else
        -- Insert your own key here!
    end
end

return BDc