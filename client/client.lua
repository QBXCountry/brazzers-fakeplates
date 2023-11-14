lib.locale()
local hasFakePlate = false
local KeyScript = 'qbx_vehiclekeys'
local BDc = require 'modules.client'

-- Net Events

RegisterNetEvent('brazzers-fakeplates:client:usePlate', function(plate)
    if not plate then return end
    local pedCoords = GetEntityCoords(cache.ped)
    local vehicle = GetClosestVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)
    local dist = #(vehicleCoords - pedCoords)
    local hasKeys = false
    
    if dist <= 5.0 then
        local currentPlate = GetPlate(vehicle)
        -- Has Keys Check
        if BDc.HasKeys(currentPlate) then
            hasKeys = true
        end
        TaskTurnPedToFaceEntity(cache.ped, vehicle, 3.0)
        if lib.progressCircle({
            label = locale('attaching_plate'),
            duration = 4000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, combat = true, car = true, },
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 }
        }) then
            TriggerServerEvent('brazzers-fakeplates:server:usePlate', VehToNet(vehicle), currentPlate, plate, hasKeys)
            ClearPedTasks(cache.ped)
        else
            ClearPedTasks(cache.ped)
        end
    end
end)

RegisterNetEvent('brazzers-fakeplates:client:removePlate', function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)
    local dist = #(vehicleCoords - pedCoords)
    local hasKeys = false
    
    if dist <= 5.0 then
        local currentPlate = GetPlate(vehicle)
        -- Has Keys Check
        if exports[KeyScript]:HasKeys(currentPlate) then
            hasKeys = true
        end
        TaskTurnPedToFaceEntity(cache.ped, vehicle, 3.0)
        if lib.progressCircle({
            label = locale('removing_plate'),
            duration = 4000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true, },
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 }
        }) then
            TriggerServerEvent('brazzers-fakeplates:server:removePlate', VehToNet(vehicle), currentPlate, hasKeys)
            ClearPedTasks(cache.ped)
        else
            ClearPedTasks(cache.ped)
        end
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1000)
        local inRange = false
        local pos = GetEntityCoords(PlayerPedId())
        local vehicle = GetClosestVehicle()
        local vehCoords = GetEntityCoords(vehicle)
        local closestPlate = GetPlate(vehicle)

        if BDc.HasKeys(closestPlate) then -- Has Keys
            if not IsPedInAnyVehicle(PlayerPedId()) then -- Not in vehicle
                if #(pos - vector3(vehCoords.xyz)) < 7.0 then -- dist check
                    inRange = true
                    lib.callback('brazzers-fakeplates:server:checkPlateStatus', false, function(result)
                        if result then
                            hasFakePlate = true
                        else
                            hasFakePlate = false
                        end
                    end, closestPlate)
                end
                if not inRange then
                    Wait(3000)
                end
            end
        end
    end
end)

CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        {
            name = 'fake_plate_install',
            event = 'brazzers-fakeplates:client:removePlate',
            icon = 'fas fa-closed-captioning',
            label = 'Remove Plate',
            bones = { 'boot' },
            canInteract = function()
                if hasFakePlate then return true end
            end,
            distance = 2.5,
        }
    })
end)
