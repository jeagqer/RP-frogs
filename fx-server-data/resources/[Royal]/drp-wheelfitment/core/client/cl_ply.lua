DecorRegister("drp-wheelfitment_applied", 2)
DecorRegister("drp-wheelfitment_w_width", 1)
DecorRegister("drp-wheelfitment_w_fl", 1)
DecorRegister("drp-wheelfitment_w_fr", 1)
DecorRegister("drp-wheelfitment_w_rl", 1)
DecorRegister("drp-wheelfitment_w_rr", 1)
--[[
cl_ply.lua
]] -- #[Local Variables]#--
local plyVehFitments = {}
local vehiclesToCheckFitment = {}
local didPlyAdjustFitments = false
local performVehicleCheck = true
local isWheelFitmentInUse = false
local currentFitmentsToSet = {width = 0, fl = 0, fr = 0, rl = 0, rr = 0}
local isPlyWhitelisted = false
local inZone = false
local devmode = false

-- #[Local Functions]#--
local function roundNum(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function isNear(pos1, pos2, distMustBe)
    local diff = #(pos2 - pos1)
    return (diff < (distMustBe))
end

-- #[Global Functions]#--
function SyncWheelFitment()
    --if isPlyWhitelisted then
        local plyPed = PlayerPedId()
        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        if didPlyAdjustFitments then
            if not DecorExistOn(plyVeh, "drp-wheelfitment_applied") then
                DecorSetBool(plyVeh, "drp-wheelfitment_applied", true)
            end

            DecorSetFloat(plyVeh, "drp-wheelfitment_w_width", roundNum(GetVehicleWheelWidth(plyVeh), 2))
            DecorSetFloat(plyVeh, "drp-wheelfitment_w_fl", roundNum(GetVehicleWheelXOffset(plyVeh, 0), 2))
            DecorSetFloat(plyVeh, "drp-wheelfitment_w_fr", roundNum(GetVehicleWheelXOffset(plyVeh, 1), 2))
            DecorSetFloat(plyVeh, "drp-wheelfitment_w_rl", roundNum(GetVehicleWheelXOffset(plyVeh, 2), 2))
            DecorSetFloat(plyVeh, "drp-wheelfitment_w_rr", roundNum(GetVehicleWheelXOffset(plyVeh, 3), 2))

            -- local vin = exports["drp-garages"]:NearVehicle("plate")
            -- TriggerServerEvent("drp-wheelfitment_sv:saveWheelfitment", vin, currentFitmentsToSet)
            RPC.execute("drp-wheelfitment_sv:saveWheelfitment", currentFitmentsToSet)
            
            didPlyAdjustFitments = false
        end

        currentFitmentsToSet = {width = 0, fl = 0, fr = 0, rl = 0, rr = 0}

        performVehicleCheck = true

        checkVehicleFitment()

        FreezeEntityPosition(plyVeh, false)
        SetEntityCollision(plyVeh, true, true)

        --RPC.execute("drp-wheelfitment_sv:setIsWheelFitmentInUse", false)
        isWheelFitmentInUse = false
    --end
end

function AdjustWheelFitment(state, wheel, amount)
    if isPlyWhitelisted then
        if amount == -1 then
            amount = -1.00
        elseif amount == 1 then
            amount = 1.00
        elseif amount == 0 then
            amount = 0.00
        end

        if state then
            if wheel == "w_fl" then
                wheel = 0

                currentFitmentsToSet.fl = amount
            elseif wheel == "w_fr" then
                wheel = 1

                currentFitmentsToSet.fr = amount
            elseif wheel == "w_rl" then
                wheel = 2

                currentFitmentsToSet.rl = amount
            elseif wheel == "w_rr" then
                wheel = 3

                currentFitmentsToSet.rr = amount
            end

            if not didPlyAdjustFitments then
                didPlyAdjustFitments = true
            end
        else
            if not didPlyAdjustFitments then
                didPlyAdjustFitments = true
            end

            currentFitmentsToSet.width = amount
        end
    end
end

function checkVehicleFitment()
    vehiclesToCheckFitment = {}

    local vehicles = GetGamePool("CVehicle")

    for _, veh in ipairs(vehicles) do
        local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed)

        if isNear(plyPos, GetEntityCoords(veh), 150) then
            if DecorExistOn(veh, "drp-wheelfitment_applied") then
                vehiclesToCheckFitment[#vehiclesToCheckFitment + 1] = {
                    vehicle = veh,
                    w_width = DecorGetFloat(veh, "drp-wheelfitment_w_width"),
                    w_fl = DecorGetFloat(veh, "drp-wheelfitment_w_fl"),
                    w_fr = DecorGetFloat(veh, "drp-wheelfitment_w_fr"),
                    w_rl = DecorGetFloat(veh, "drp-wheelfitment_w_rl"),
                    w_rr = DecorGetFloat(veh, "drp-wheelfitment_w_rr")
                }
            end
        end
    end
end

-- #[Citizen Threads]#--
Citizen.CreateThread(function()
    isWheelFitmentInUse = false
    isPlyWhitelisted = true
    isWheelFitmentInUse = false
    isPlyWhitelisted = true

    exports["drp-polyzone"]:AddBoxZone("wheel_zone_1", vector3(144.93, -3030.51, 7.04), 6.6, 3.6)
end)

Citizen.CreateThread(function()
    while true do
        if performVehicleCheck then
            for _, vehData in ipairs(vehiclesToCheckFitment) do
                if vehData.vehicle ~= nil and DoesEntityExist(vehData.vehicle) then
                    if GetVehicleWheelWidth(vehData.vehicle) ~=vehData.w_width then
                        SetVehicleWheelWidth(vehData.vehicle, vehData.w_width)
                    end
                    if GetVehicleWheelXOffset(vehData.vehicle, 0) ~= vehData.w_fl then
                        SetVehicleWheelXOffset(vehData.vehicle, 0, vehData.w_fl)
                        SetVehicleWheelXOffset(vehData.vehicle, 1, vehData.w_fr)
                        SetVehicleWheelXOffset(vehData.vehicle, 2, vehData.w_rl)
                        SetVehicleWheelXOffset(vehData.vehicle, 3, vehData.w_rr)
                    end
                end
            end
        else
            if isMenuShowing then
                local plyPed = PlayerPedId()
                local plyVeh = GetVehiclePedIsIn(plyPed, false)

                SetVehicleWheelWidth(plyVeh, currentFitmentsToSet.width)
                SetVehicleWheelXOffset(plyVeh, 0, currentFitmentsToSet.fl)
                SetVehicleWheelXOffset(plyVeh, 1, currentFitmentsToSet.fr)
                SetVehicleWheelXOffset(plyVeh, 2, currentFitmentsToSet.rl)
                SetVehicleWheelXOffset(plyVeh, 3, currentFitmentsToSet.rr)
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if performVehicleCheck then
            checkVehicleFitment()
        end

        Citizen.Wait(cfg_scanVehicleTimer)
    end
end)

AddEventHandler("drp-polyzone:enter", function(zone, data)
    if zone ~= "wheel_zone_1" then return end
    Citizen.CreateThread(function()
        local plyPed = PlayerPedId()
        inZone = true
        while inZone do
            -- print('In zone')
            if IsPedInAnyVehicle(plyPed, false) then
                if not isMenuShowing then
                    local plyPos = GetEntityCoords(plyPed, false)
                    if isNear(plyPos, cfg_wheelFitmentPos, 2.0) then
                        local job = exports["isPed"]:GroupRank("tuner_shop")
                        if job > 1 then 
                        exports['drp-textui']:showInteraction('[E] - Adjust Wheel Fitment')


                        if IsControlJustReleased(1, 38) then -- Key: E
                            exports['drp-textui']:hideInteraction()
                            local slider_wWidth = {}
                            local slider_wfFL = {}
                            local slider_wfFR = {}
                            local slider_wfRL = {}
                            local slider_wfRR = {}
                            local sliderStartPos = {}
                            local plyVeh = GetVehiclePedIsIn(plyPed, false)

                            performVehicleCheck = false

                            SetEntityCoords(plyVeh, cfg_wheelFitmentPos)
                            SetEntityHeading(plyVeh, cfg_wheelFitmentHeading)
                            FreezeEntityPosition(plyVeh, true)
                            SetEntityCollision(plyVeh, false, true)

                            -- RPC.execute("drp-wheelfitment_sv:setIsWheelFitmentInUse", true)
                            isWheelFitmentInUse = true

                            for i = 0.0, 1.56, 0.01 do
                                slider_wWidth[#slider_wWidth + 1] = roundNum(i, 2)

                                if math.abs(i - roundNum(GetVehicleWheelWidth(plyVeh), 2)) < 0.00000001 then
                                    sliderStartPos[#sliderStartPos + 1] = #slider_wWidth
                                end
                            end

                            for i = 0.0, -1.56, -0.01 do
                                slider_wfFL[#slider_wfFL + 1] = roundNum(i, 2)

                                if math.abs(i - roundNum(GetVehicleWheelXOffset(plyVeh, 0), 2)) < 0.00000001 then
                                    sliderStartPos[#sliderStartPos + 1] = #slider_wfFL
                                end
                            end

                            for i = 0.0, 1.56, 0.01 do
                                slider_wfFR[#slider_wfFR + 1] = roundNum(i, 2)

                                if math.abs(i - roundNum(GetVehicleWheelXOffset(plyVeh, 1), 2)) < 0.00000001 then
                                    sliderStartPos[#sliderStartPos + 1] = #slider_wfFR
                                end
                            end

                            for i = 0.0, -1.56, -0.01 do
                                slider_wfRL[#slider_wfRL + 1] = roundNum(i, 2)

                                if math.abs(i - roundNum(GetVehicleWheelXOffset(plyVeh, 2), 2)) < 0.00000001 then
                                    sliderStartPos[#sliderStartPos + 1] = #slider_wfRL
                                end
                            end

                            for i = 0.0, 1.56, 0.01 do
                                slider_wfRR[#slider_wfRR + 1] = roundNum(i, 2)

                                if math.abs(i - roundNum(GetVehicleWheelXOffset(plyVeh, 3), 2)) < 0.00000001 then
                                    sliderStartPos[#sliderStartPos + 1] = #slider_wfRR
                                end
                            end

                            currentFitmentsToSet.width = GetVehicleWheelWidth(plyVeh)
                            currentFitmentsToSet.fl = GetVehicleWheelXOffset(plyVeh, 0)
                            currentFitmentsToSet.fr = GetVehicleWheelXOffset(plyVeh, 1)
                            currentFitmentsToSet.rl = GetVehicleWheelXOffset(plyVeh, 2)
                            currentFitmentsToSet.rr = GetVehicleWheelXOffset(plyVeh, 3)
                            checkVehicleFitment()

                            DisplayMenu(true, slider_wWidth, slider_wfFL, slider_wfFR, slider_wfRL, slider_wfRR, sliderStartPos)
                        end
                    end
                end
            end
            Citizen.Wait(0)
        end
    end
    end)
end)

AddEventHandler("drp-polyzone:exit", function(zone)
    if zone ~= "wheel_zone_1" then
        return
    end
    inZone = false
end)

RegisterNetEvent("drp-admin:currentDevmode")
AddEventHandler("drp-admin:currentDevmode", function(pDevmode)
    devmode = pDevmode
end)

-- #[Event Handlers]#--
RegisterNetEvent("drp-wheelfitment_cl:applySavedWheelFitment")
AddEventHandler("drp-wheelfitment_cl:applySavedWheelFitment", function(wheelFitments, plyVeh)
    wheelFitments = json.decode(wheelFitments)
    performVehicleCheck = false

    SetVehicleWheelWidth(plyVeh, wheelFitments.width)
    SetVehicleWheelXOffset(plyVeh, 0, wheelFitments.fl)
    SetVehicleWheelXOffset(plyVeh, 1, wheelFitments.fr)
    SetVehicleWheelXOffset(plyVeh, 2, wheelFitments.rl)
    SetVehicleWheelXOffset(plyVeh, 3, wheelFitments.rr)

    if not DecorExistOn(plyVeh, "drp-wheelfitment_applied") then
        DecorSetBool(plyVeh, "drp-wheelfitment_applied", true)
    end

    DecorSetFloat(plyVeh, "drp-wheelfitment_w_width", wheelFitments.width)
    DecorSetFloat(plyVeh, "drp-wheelfitment_w_fl", wheelFitments.fl)
    DecorSetFloat(plyVeh, "drp-wheelfitment_w_fr", wheelFitments.fr)
    DecorSetFloat(plyVeh, "drp-wheelfitment_w_rl", wheelFitments.rl)
    DecorSetFloat(plyVeh, "drp-wheelfitment_w_rr", wheelFitments.rr)

    performVehicleCheck = true
    checkVehicleFitment()
end)

RegisterNetEvent("drp-wheelfitment_cl:forceMenuClose")
AddEventHandler("drp-wheelfitment_cl:forceMenuClose", function()
    if isMenuShowing then
        local plyPed = PlayerPedId()
        local plyVeh = GetVehiclePedIsIn(plyPed, false)

        if plyVeh ~= 0 or plyVeh ~= nil then
            SetEntityCoords(plyVeh, cfg_wheelFitmentPos)
            SetEntityHeading(plyVeh, cfg_wheelFitmentHeading)
            FreezeEntityPosition(plyVeh, false)
            SetEntityCollision(plyVeh, true, true)
        end
    end

    --RPC.execute("drp-wheelfitment_sv:setIsWheelFitmentInUse", false)
    isWheelFitmentInUse = false

    SyncWheelFitment()
    DisplayMenu(false)
end)

RegisterCommand("leavefitment", function()
    DisplayMenu(true)
end)
