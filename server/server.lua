local BDs = lib.require('modules.server')

-- Functions
local function GeneratePlate()
    local plate = lib.string.random('1AA111AA')
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function isVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    return result and true or false
end

local function isFakePlateOnVehicle(plate)
    local result = MySQL.scalar.await('SELECT 1 FROM player_vehicles WHERE fakeplate = ?', {plate})
    return result and true or false
end
exports("isFakePlateOnVehicle", isFakePlateOnVehicle)

local function getPlateFromFakePlate(fakeplate)
    return MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE fakeplate = ?', {fakeplate})
end
exports("getPlateFromFakePlate", getPlateFromFakePlate)

local function getFakePlateFromPlate(plate)
    return MySQL.scalar.await('SELECT fakeplate FROM player_vehicles WHERE plate = ?', {plate})
end
exports("getFakePlateFromPlate", getFakePlateFromPlate)

-- Net Events
RegisterNetEvent('brazzers-fakeplates:server:usePlate', function(vehNetID, vehPlate, newPlate, hasKeys)
    local src = source
    if not vehNetID or not vehPlate or not newPlate then return end

    local vehicle = NetworkGetEntityFromNetworkId(vehNetID)
    if not vehicle or vehicle == 0 then return end

    if isFakePlateOnVehicle(vehPlate) then 
        return exports.qbx_core:Notify(src, 'This vehicle already has another plate over this plate', 'error') 
    end

    if not isVehicleOwned(vehPlate) then
        if not hasKeys then 
            return exports.qbx_core:Notify(src, 'You don\'t have keys..', 'error') 
        end

        SetVehicleNumberPlateText(vehicle, newPlate)
        BDs.GiveKeys(src, vehNetID) -- Pass network ID instead of plate
        exports.ox_inventory:RemoveItem(src, 'fakeplate', 1)
        return
    end

    exports.ox_inventory:UpdateVehicle(vehPlate, newPlate)
    MySQL.update('UPDATE player_vehicles SET fakeplate = ? WHERE plate = ?', {newPlate, vehPlate})

    SetVehicleNumberPlateText(vehicle, newPlate)
    exports.ox_inventory:RemoveItem(src, 'fakeplate', 1)
    
    if hasKeys then
        BDs.GiveKeys(src, vehNetID) -- Pass network ID instead of plate
    end
end)

RegisterNetEvent('brazzers-fakeplates:server:removePlate', function(vehNetID, vehPlate, hasKeys)
    local src = source
    if not vehNetID or not vehPlate then return end

    local vehicle = NetworkGetEntityFromNetworkId(vehNetID)
    if not vehicle or vehicle == 0 then return end

    if not isFakePlateOnVehicle(vehPlate) then 
        return exports.qbx_core:Notify(src, 'This vehicle doesn\'t have a fake plate', 'error') 
    end

    local originalPlate = getPlateFromFakePlate(vehPlate)
    if not originalPlate then return end

    exports.ox_inventory:UpdateVehicle(vehPlate, originalPlate)
    MySQL.update('UPDATE player_vehicles SET fakeplate = NULL WHERE plate = ?', {originalPlate})

    exports.ox_inventory:AddItem(src, 'fakeplate', 1)
    SetVehicleNumberPlateText(vehicle, originalPlate)
    
    if hasKeys then
        BDs.GiveKeys(src, vehNetID) -- Pass network ID instead of plate
    end
end)

-- Callbacks
lib.callback.register('brazzers-fakeplates:server:checkPlateStatus', function(_, vehPlate)
    return isFakePlateOnVehicle(vehPlate)
end)

-- Items
exports.qbx_core:CreateUseableItem('fakeplate', function(source)
    TriggerClientEvent('brazzers-fakeplates:client:usePlate', source, GeneratePlate())
end)