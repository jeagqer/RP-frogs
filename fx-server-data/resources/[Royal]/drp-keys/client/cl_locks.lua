local distanceParam = 5 -- Change this value to change the distance needed to lock / unlock a vehicle
local key = 182 -- Change this value to change the key (List of values below)
local chatMessage = true -- Set to false for disable chatMessage
local playSound = true -- Set to false for disable sound when Lock/Unlock (To change the sounds, follow the instructions here : https://forum.fivem.net/t/release-locksystem/17750/5)

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 250 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('keys:unlockDoor')
AddEventHandler('keys:unlockDoor', function(targetVehicle, allow)
    if allow then
        local playerped = PlayerPedId()
        inveh = IsPedInAnyVehicle(playerped)
        lockStatus = GetVehicleDoorLockStatus(targetVehicle) 
        TriggerEvent("dooranim")
        if lockStatus == 1 or lockStatus == 0 then 
            
            lockStatus = SetVehicleDoorsLocked(targetVehicle, 2)

            SetVehicleDoorsLockedForPlayer(targetVehicle, PlayerId(), false)
            SetVehicleDoorsLockedForAllPlayers(targetVehicle, true)

            if playSound then
                TriggerEvent('InteractSound_CL:PlayOnOne','lock', 0.7)
                TriggerEvent('DoLongHudText', 'Vehicle Locked!', 1)
            end
            
            if not inveh then
                SetVehicleLights(targetVehicle, 2)

                SetVehicleBrakeLights(targetVehicle, true)
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
                Citizen.Wait(450)
                
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleLights(targetVehicle, 0)
                SetVehicleBrakeLights(targetVehicle, false)
                SetVehicleInteriorlight(targetVehicle, false)
                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
            end

        else

            lockStatus = SetVehicleDoorsLocked(targetVehicle, 1)

            SetVehicleDoorsLockedForAllPlayers(targetVehicle, false)

            if playSound then
                TriggerEvent('DoLongHudText', 'Vehicle Unlocked!', 1)
                TriggerEvent('InteractSound_CL:PlayOnOne','unlock', 0.7)
            end

            if not inveh then
                SetVehicleLights(targetVehicle, 2)
                SetVehicleFullbeam(targetVehicle, true)
                SetVehicleBrakeLights(targetVehicle, true)
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
                Citizen.Wait(450)
                
                SetVehicleInteriorlight(targetVehicle, true)
                SetVehicleIndicatorLights(targetVehicle, 0, true)
                SetVehicleIndicatorLights(targetVehicle, 1, true)
                Citizen.Wait(450)

                SetVehicleLights(targetVehicle, 0)
                SetVehicleFullbeam(targetVehicle, false)
                SetVehicleBrakeLights(targetVehicle, false)
                SetVehicleInteriorlight(targetVehicle, false)
                SetVehicleIndicatorLights(targetVehicle, 0, false)
                SetVehicleIndicatorLights(targetVehicle, 1, false)
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(10)
        if IsControlJustPressed(0, key) and GetLastInputMethod(2) then

        local playerped = PlayerPedId()
        local targetVehicle = GetVehiclePedIsUsing(playerped)
    
        if not DoesEntityExist(targetVehicle) then
            local coordA = GetEntityCoords(playerped, 1)
            local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 255.0, 0.0)
            targetVehicle = getVehicleInDirection(coordA, coordB)
        end
    
        if DoesEntityExist(targetVehicle) then
            TriggerEvent("keys:hasKeys", 'doors', targetVehicle)
        end
        Citizen.Wait(300)
    end
    end
end)