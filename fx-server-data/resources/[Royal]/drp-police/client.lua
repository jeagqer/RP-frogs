local handCuffed = false
local isPolice = false
local isSheriff = false
local isState = false
local isEMS = false
local isSuit = false
local currentCallSign = nil
local isInService = false


RegisterNetEvent("police:setCallSign")
AddEventHandler("police:setCallSign", function(pCallSign)
	if pCallSign ~= nil then currentCallSign = pCallSign end
end)

RegisterNetEvent("drp-jobmanager:playerBecameJob")
AddEventHandler("drp-jobmanager:playerBecameJob", function(job, name, notify)
	if isEMS and job ~= "ems" then isEMS = false isInService = false end
	if isPolice and job ~= "police" then isPolice = false isInService = false end
	if isState and job ~= "state" then isState = false isInService = false end
	if isSheriff and job ~= "sheriff" then isSheriff = false isInService = false end
	if isNews and job ~= "news" then isNews = false isInService = false end
	if job == "police" then isPolice = true TriggerServerEvent('police:getRank',"police") isInService = true end
	if job == "state" then isState = true isInService = true end
	if job == "sheriff" then isSheriff = true isInService = true end
	if job == "ems" then isEMS = true TriggerServerEvent('police:getRank',"ems") isInService = true end
	if job == "doctor" then isDoctor = true TriggerServerEvent('police:getRank',"doctor") isInService = true end
	if job == "news" then isNews = true isInService = false end
	if job == "suits" then isSuit = true isInService = false end
end)

RegisterNetEvent('police:checkLicenses')
AddEventHandler('police:checkLicenses', function()
	t, distance = GetClosestPlayerIgnoreCar()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("police:getLicenses", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent('evidence:dnaSwab')
AddEventHandler('evidence:dnaSwab', function()
    local finished = exports["drp-taskbar"]:taskBar(8000,"DNA Testing")
    if finished == 100 then
        t, distance = GetClosestPlayer()
        if(distance ~= -1 and distance < 5) then
            TriggerServerEvent("police:dnaAsk", GetPlayerServerId(t))
        end
    end
end)

RegisterNetEvent('police:checkBank')
AddEventHandler('police:checkBank', function()
	t, distance, closestPed = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("police:targetCheckBank", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent('police:checkInventory')
AddEventHandler('police:checkInventory', function(isFrisk)
	if isFrisk == nil then isFrisk = false end
	t, distance, closestPed = GetClosestPlayer()
	if(distance ~= -1 and distance < 5) then
		TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t), isFrisk)
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)


function KneelMedic()
    local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

	        loadAnimDict( "amb@medic@standing@tendtodead@enter" )
	        loadAnimDict( "amb@medic@standing@timeofdeath@enter" )
	        loadAnimDict( "amb@medic@standing@tendtodead@idle_a" )
	        loadAnimDict( "random@crash_rescue@help_victim_up" )

			TaskPlayAnim( player, "amb@medic@standing@tendtodead@enter", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "amb@medic@standing@tendtodead@idle_a", "idle_b", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
			Wait (3000)
			TaskPlayAnim( player, "amb@medic@standing@tendtodead@exit", "exit_flee", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
            TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "enter", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  
            Wait (500)
            TaskPlayAnim( player, "amb@medic@standing@timeofdeath@enter", "helping_victim_to_feet_player", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )  

    end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('revive')
AddEventHandler('revive', function(t)

	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 10) then
		TriggerServerEvent("drp-death:reviveSV", GetPlayerServerId(t))
		KneelMedic()
		TriggerServerEvent("take100",GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end

end)

--RegisterNetEvent('event:control:police')
--AddEventHandler('event:control:police', function(useID)
--	if useID == 1 then
--		TriggerServerEvent('police:checkForBar')
--
--	elseif useID == 2 and not handCuffed and GetLastInputMethod(2) then
--		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
--		if not isInVeh and GetEntitySpeed(PlayerPedId()) > 2.5 then
--			TryTackle()
--		end
--
--	elseif useID == 3 and not handCuffed and GetLastInputMethod(2) then
--		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
--		if isInVeh then
--			TriggerEvent("toggle:cruisecontrol")
--		end
--	end
--end)

function vehCruise()
	if not handCuffed and GetLastInputMethod(2) then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("toggle:cruisecontrol")
		end
	end
end

function plyTackel()
	if not handCuffed and GetLastInputMethod(2) then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if not isInVeh and GetEntitySpeed(PlayerPedId()) > 2.5 then
			TryTackle()
		end
	end
end

Citizen.CreateThread(function()
  exports["drp-binds"]:registerKeyMapping("", "Vehicle", "Cruise Control", "+vehCruise", "-vehCruise", "X")
  RegisterCommand('+vehCruise', vehCruise, false)
  RegisterCommand('-vehCruise', function() end, false)
  
  exports["drp-binds"]:registerKeyMapping("", "Player", "Tackle", "+plyTackel", "-plyTackel")
  RegisterCommand('+plyTackel', plyTackel, false)
  RegisterCommand('-plyTackel', function() end, false)
end)

local inmenus = false

RegisterNetEvent('inmenu')
AddEventHandler('inmenu', function(change)
	inmenus = change
end)

TimerEnabled = false

function policeCuff()
	if not inmenus and (isPolice or isState or isSheriff) and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("platecheck:frontradar")
		else
			if not IsControlPressed(0,19) then
				TriggerEvent("police:cuffFromMenu",false)
			end
		end
	end
end

function medicRevive()
	if not inmenus and (isMedic or isDoctor or isDoc) and not IsPauseMenuActive() then
		TriggerEvent("revive")
	end
end

function emsHeal()
	if not inmenus and (isMedic or isDoctor or isDoc) and not IsPauseMenuActive() then
		TriggerEvent("ems:heal")
	end
end

function policeEscort()
	if not inmenus and (isMedic or isDoctor or isPolice or isState or isSheriff) and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh and (isPolice or isState or isSheriff) then
			TriggerEvent("startSpeedo")
		else
			TriggerEvent("escortPlayer") 
		end
	end
end

function policeSeat()
	if not inmenus and (isMedic or isPolice or isState or isSheriff) and not IsPauseMenuActive() then
		TriggerEvent("police:forceEnter")
	end
end

function policeUnCuff()
	if not inmenus and (isPolice or isState or isSheriff) and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			TriggerEvent("platecheck:rearradar")
		else
			TriggerEvent("police:uncuffMenu")
		end
	end
end

function policeSoft()
	if not inmenus and (isPolice or isState or isSheriff) and not IsPauseMenuActive() then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if not isInVeh then
			TriggerEvent("police:cuffFromMenu",true)
		end
	end
end

Citizen.CreateThread( function()
	RegisterCommand('+policeCuff', policeCuff, false)
	RegisterCommand('-policeCuff', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "Cuff / Radar Front", "+policeCuff", "-policeCuff", "UP")

	RegisterCommand('+medicRevive', medicRevive, false)
	RegisterCommand('-medicRevive', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "EMS Revive", "+medicRevive", "-medicRevive")

	RegisterCommand('+emsHeal', emsHeal, false)
	RegisterCommand('-emsHeal', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "EMS Heal", "+emsHeal", "-emsHeal")

	RegisterCommand('+policeEscort', policeEscort, false)
	RegisterCommand('-policeEscort', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "Escort / Speedo", "+policeEscort", "-policeEscort", "LEFT")

	RegisterCommand('+policeSeat', policeSeat, false)
	RegisterCommand('-policeSeat', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "Force into Vehicle", "+policeSeat", "-policeSeat", "RIGHT")

	RegisterCommand('+policeUnCuff', policeUnCuff, false)
	RegisterCommand('-policeUnCuff', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "UnCuff / Radar Rear", "+policeUnCuff", "-policeUnCuff", "DOWN")

	RegisterCommand('+policeSoft', policeSoft, false)
	RegisterCommand('-policeSoft', function() end, false)
	exports["drp-binds"]:registerKeyMapping("", "Police", "Soft Cuff", "+policeSoft", "-policeSoft")
end)

RegisterNetEvent('revive2')
AddEventHandler('revive2', function(t)

	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 10) then
		TriggerServerEvent("drp-death:reviveSV", GetPlayerServerId(t))
		KneelMedic()
		TriggerEvent('inventory:removeItem', 'medbeg', 1)
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end

end)

function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

-- RegisterNetEvent('police:woxy')
-- AddEventHandler('police:woxy', function()
-- 	local vehFront = VehicleInFront()
-- 	if vehFront > 0 then
--   		loadAnimDict('anim@narcotics@trash')
-- 		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 3800, 49, 3.0, 0, 0, 0)		
-- 		local finished = exports["drp-taskbar"]:taskBar(4000,"Grabbing Scuba Gear")
-- 	  	if finished == 100 then
-- 	  		loadAnimDict('anim@narcotics@trash')
--     		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)	  		
-- 			TriggerEvent("UseOxygenTank")
-- 		end
-- 	end
-- end)

RegisterNetEvent('police:remmaskAccepted')
AddEventHandler('police:remmaskAccepted', function()
	TriggerEvent("facewear:adjust", 1, true)
	TriggerEvent("facewear:adjust", 3, true)
	TriggerEvent("facewear:adjust", 4, true)
	TriggerEvent("facewear:adjust", 2, true)
end)

RegisterNetEvent('police:remmask')
AddEventHandler('police:remmask', function(t)
	t, distance = GetClosestPlayer()
	if (distance ~= -1 and distance < 5) then
		if not IsPedInVehicle(t,GetVehiclePedIsIn(t, false),false) then
			TriggerServerEvent("police:remmaskGranted", GetPlayerServerId(t))
			AnimSet = "mp_missheist_ornatebank"
			AnimationOn = "stand_cash_in_bag_intro"
			AnimationOff = "stand_cash_in_bag_intro"
			loadAnimDict( AnimSet )
			TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOn, 8.0, -8, -1, 49, 0, 0, 0, 0 )
			Citizen.Wait(500)
			ClearPedTasks(PlayerPedId())						
		end
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent("shoes:steal")
AddEventHandler("shoes:steal", function(t)
	t, distance = GetClosestPlayer()
	if (distance ~= -1 and distance < 2) then
		if not IsPedInVehicle(t,GetVehiclePedIsIn(t, false),false) then
  			loadAnimDict('random@domestic')
  			TaskPlayAnim(PlayerPedId(),'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
  			Citizen.Wait(1600)
  			ClearPedTasks(PlayerPedId())
  			TriggerServerEvent("police:remShoesBitch", GetPlayerServerId(t))
		end
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)


tryingcuff = false
RegisterNetEvent('police:cuff2')
AddEventHandler('police:cuff2', function(t,softcuff)
	if not tryingcuff then

		
		tryingcuff = true

		t, distance, ped = GetClosestPlayer()

		Citizen.Wait(1500)
		if(distance ~= -1 and #(GetEntityCoords(ped) - GetEntityCoords(PlayerPedId())) < 2.5 and GetEntitySpeed(ped) < 1.0) then
			TriggerEvent('police:cuff2')
			TriggerServerEvent("police:cuffGranted2", GetPlayerServerId(t), softcuff)
		else
			ClearPedSecondaryTask(PlayerPedId())
			TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
		end

		tryingcuff = false

	end
end)

RegisterNetEvent('police:cuff')
AddEventHandler('police:cuff', function(t)
	if not tryingcuff then



		TriggerEvent("Police:ArrestingAnim")
		tryingcuff = true

		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 1.5) then
			TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
		else
			TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
		end


		tryingcuff = false
	end
end)

local cuffstate = false


RegisterNetEvent('civ:cuffFromMenu')
AddEventHandler('civ:cuffFromMenu', function()
	TriggerEvent("police:cuffFromMenu",false)
end)

RegisterNetEvent('police:cuffFromMenu')
AddEventHandler('police:cuffFromMenu', function(softcuff)
	if not cuffstate and not handCuffed and not IsPedRagdoll(PlayerPedId()) and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then
		cuffstate = true

		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 2 and not IsPedRagdoll(PlayerPedId())) then
			if softcuff then
				TriggerEvent('DoLongHudText', 'You soft cuffed a player!', 1)
			else
				TriggerEvent('DoLongHudText', 'You hard cuffed a player!', 1)
			end
			
			TriggerEvent("police:cuff2", GetPlayerServerId(t),softcuff)
		end

		cuffstate = false
	end
end)

RegisterNetEvent('police:gsr')
AddEventHandler('police:gsr', function(t)
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, 1)
	local finished = exports["drp-taskbar"]:taskBar(15000,"GSR Testing")
    if finished == 100 then
		t, distance = GetClosestPlayer()
		if(distance ~= -1 and distance < 7) then
			TriggerServerEvent("police:gsrGranted", GetPlayerServerId(t))
		end
	end
end)

RegisterNetEvent('police:giveweaponlicense')
AddEventHandler('police:giveweaponlicense', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("drp-base:giveLicenses", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent('police:removeweaponlicense')
AddEventHandler('police:removeweaponlicense', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("drp-base:removeLicenses", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)


RegisterNetEvent('police:givehuntinglicense')
AddEventHandler('police:givehuntinglicense', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("drp-base:giveLicenseshunt", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent('police:removehuntinglicense')
AddEventHandler('police:removehuntinglicense', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("drp-base:removeLicenseshunt", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)


RegisterNetEvent('police:givefishinglicense')
AddEventHandler('police:givefishinglicense', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("drp-base:giveLicensesfish", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent("serial:search")
AddEventHandler("serial:search", function()
    local serialS = exports["drp-applications"]:KeyboardInput({
        header = "Weapon Serial Lookup",
        rows = {
            {
                id = 1,
                txt = "Serial"
            }
        }
    })
    if serialS then
        TriggerServerEvent("serial:search:weapon", serialS[1].input)
    end
end)

RegisterNetEvent("blood:search")
AddEventHandler("blood:search", function()
    local finished = exports["drp-taskbar"]:taskBar(3000,"Loading Terminal")
		if (finished == 100) then
		local bloodS = exports["drp-applications"]:KeyboardInput({
			header = "National D.N.A Databse",
			rows = {
				{
					id = 1,
					txt = "Blood Identifier"
				}
			}
		})
		if bloodS then
			TriggerServerEvent("blood:search:weapon", bloodS[1].input)
			
		end
	end
end)

RegisterNetEvent('police:removeLicensesfish')
AddEventHandler('police:removeLicensesfish', function(t)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 7) then
		TriggerServerEvent("drp-base:removeLicensesfish", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)





Citizen.CreateThread(function()

	Citizen.Wait(60000)
	TriggerServerEvent('police:setServerMeta')
	-- Saves META once a minute to database - hopefully armor saving?
end)


local shotRecently = false

Citizen.CreateThread(function()
	local lastShot = 0
	
	while true do
		Citizen.Wait(5)

		if IsPedShooting(PlayerPedId()) then
			local name = GetSelectedPedWeapon(PlayerPedId())
			if name ~= `WEAPON_STUNGUN` then
				lastShot = GetGameTimer()
				shotRecently = true
			end
		end

		if shotRecently and GetGameTimer() - lastShot >= 1200000 then shotRecently = false end 
	end
end)

RegisterNetEvent("police:hasShotRecently")
AddEventHandler("police:hasShotRecently", function(copId)
	TriggerServerEvent("police:hasShotRecently", shotRecently, copId)
end)

RegisterNetEvent('police:uncuffMenu')
AddEventHandler('police:uncuffMenu', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 2.2) then
		TriggerEvent("animation:PlayAnimation","uncuff")
		local finished = exports["drp-taskbar"]:taskBar(5000, "Uncuffing", false, true, false, false, nil, 1.0, PlayerPedId())
		if finished == 100 then
			TriggerServerEvent("falseCuffs", GetPlayerServerId(t))
			TriggerEvent("DoLongHudText", "You uncuffed a player!",1)
			TriggerServerEvent('police:setCuffState', GetPlayerServerId(t), false)
			
		end
	else
		TriggerEvent("DoLongHudText", "No player near you (maybe get closer)!",2)
	end
end)

RegisterNetEvent('resetCuffs')
AddEventHandler('resetCuffs', function()
	ClearPedTasksImmediately(PlayerPedId())
	handcuffType = 49
	handCuffed = false
	handCuffedWalking = false
	TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
	TriggerEvent("handcuffed",false)
end)

RegisterNetEvent('falseCuffs')
AddEventHandler('falseCuffs', function()
	ClearPedTasksImmediately(PlayerPedId())
	handcuffType = 49
	handCuffed = false
	handCuffedWalking = false
	TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
	TriggerEvent("handcuffed",false)
end)

RegisterNetEvent('police:getArrested2')
AddEventHandler('police:getArrested2', function(cuffer)

	ClearPedTasksImmediately(PlayerPedId())
	CuffAnimation(cuffer)
	
	local cuffPed = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))

	local finished = 0
	if not exports['drp-death']:GetDeathStatus() then
		local finished2 = exports["drp-bar"]:taskBar(3000,math.random(4,8))
        if (finished2 == 100) then
			TriggerEvent('DoLongHudText', 'You slipped out of cuffs !',1)
			TriggerEvent("handcuffed",false)
			return end
	end

	if #(GetEntityCoords( PlayerPedId()) - GetEntityCoords(cuffPed)) < 2.5 and finished ~= 100 then
		TriggerEvent('InteractSound_CL:PlayOnOne', 'handcuff', 0.4)
		handcuffType = 16
		handCuffed = true
		handCuffedWalking = false
		TriggerEvent("police:currentHandCuffedState", handCuffed, handCuffedWalking)
		TriggerEvent('DoLongHudText', 'Cuffed!', 1)
		TriggerEvent("handcuffed",true)
		TriggerEvent("DensityModifierEnable",false)	
	end

end)

function CuffAnimation(cuffer)
	loadAnimDict("mp_arrest_paired")
	local cuffer = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))
	local dir = GetEntityHeading(cuffer)
	SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
	Citizen.Wait(100)
	SetEntityHeading(PlayerPedId(),dir)
	TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
end

RegisterNetEvent('police:cuffTransition')
AddEventHandler('police:cuffTransition', function()
	loadAnimDict("mp_arrest_paired")
	Citizen.Wait(100)
	TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(3500)
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('police:getArrested')
AddEventHandler('police:getArrested', function(cuffer)

		if(handCuffed) then
			Citizen.Wait(3500)
			ClearPedTasksImmediately(PlayerPedId())
			handCuffed = false
			handcuffType = 49
			TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
			TriggerEvent("handcuffed",true)
			TriggerEvent("DensityModifierEnable",true)
		else
			ClearPedTasksImmediately(PlayerPedId())
			CuffAnimation(cuffer) 

			local cuffPed = GetPlayerPed(GetPlayerFromServerId(tonumber(cuffer)))
			if Vdist2( GetEntityCoords( GetPlayerPed(-1) , GetEntityCoords(cuffPed) ) ) < 1.5 then
				handcuffType = 49
				handCuffed = true
				TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)
				TriggerEvent("handcuffed",false)
				TriggerEvent("DensityModifierEnable",false)
			end
		end
end)

RegisterNetEvent('police:jailing')
AddEventHandler('police:jailing', function(args)
	Citizen.Trace("Jailing in process.")
	TriggerServerEvent('police:jailGranted', args)
	TriggerServerEvent('updateJailTime', tonumber(args[2]))
end)

RegisterNetEvent('police:jailing2')
AddEventHandler('police:jailing2', function(pPlayer, time)
	Citizen.Trace("Jailing in process.")
	TriggerServerEvent('police:jailGranted2', pPlayer, time)
	TriggerEvent('drp-base:setEverything')
    TriggerEvent('drp-hud:EnableHud', true)
end)

RegisterNetEvent('startJail')
AddEventHandler('startJail', function(minutes)
	TriggerServerEvent('updateJailTime', tonumber(minutes))
end)

RegisterNetEvent('police:forceEnter')
AddEventHandler('police:forceEnter', function(id)

	ped, distance, t = GetClosestPedIgnoreCar()
	if(distance ~= -1 and distance < 3) then

		local isInVeh = IsPedInAnyVehicle(ped, true)
		if not isInVeh then
			playerped = PlayerPedId()
	        coordA = GetEntityCoords(playerped, 1)
	        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
	        v = getVehicleInDirection(coordA, coordB)
	        if GetVehicleEngineHealth(v) < 100.0 then
				TriggerEvent('DoLongHudText', 'That vehicle is too damaged!', 1)
	        	return
	        end
			local netid = NetworkGetNetworkIdFromEntity(v)	
			TriggerEvent('forcedEnteringVeh', GetPlayerServerId(t))
			TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), netid)
			TriggerEvent("dr:releaseEscort")
		else
			TriggerEvent("unseatPlayer")
		end

	else
		TriggerEvent('DoLongHudText', 'No player near you (maybe get closer)!', 2)
	end
end)

RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function(sender)

	local vehicleHandle = NetworkGetEntityFromNetworkId(sender)
    if vehicleHandle ~= nil then
        Citizen.Trace("22")
      if IsEntityAVehicle(vehicleHandle) then
      	TriggerEvent("respawn:sleepanims")
      	Citizen.Wait(1000)
        for i=1,GetVehicleMaxNumberOfPassengers(vehicleHandle) do
            Citizen.Trace("33")
          if IsVehicleSeatFree(vehicleHandle,i) then
		 	TriggerEvent("unEscortPlayer")
			Citizen.Wait(100)
            SetPedIntoVehicle(PlayerPedId(),vehicleHandle,i)
            
            Citizen.Trace("whatsasdsass")
            return true
          end
        end
	    if IsVehicleSeatFree(vehicleHandle,0) then
	    	TriggerEvent("unEscortPlayer") 
			Citizen.Wait(100)
	        SetPedIntoVehicle(PlayerPedId(),vehicleHandle,0)
	        
	    end
      end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(19)
		if isCop and not inmenus then

			local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
 
			if isInVeh then
 
				if IsControlJustReleased(0,172) or IsDisabledControlJustReleased(0,172) then
					TriggerEvent("platecheck:frontradar")
					Citizen.Wait(400)
				end
 
				if IsControlJustReleased(0,173) then
					TriggerEvent("platecheck:rearradar")
					Citizen.Wait(400)
				end
 
				if IsControlJustReleased(0,174) then
					TriggerEvent("startSpeedo")
					Citizen.Wait(400)
				end
			end
		end
	 end

	end)

function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayers(targetVector,dist)
	local players = GetPlayers()
	local ply = PlayerPedId()
	local plyCoords = targetVector
	local closestplayers = {}
	local closestdistance = {}
	local closestcoords = {}

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(distance < dist) then
				valueID = GetPlayerServerId(value)
				closestplayers[#closestplayers+1]= valueID
				closestdistance[#closestdistance+1]= distance
				closestcoords[#closestcoords+1]= {targetCoords["x"], targetCoords["y"], targetCoords["z"]}
				
			end
		end
	end
	return closestplayers, closestdistance, closestcoords
end

function GetClosestPlayerVehicleToo()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) then
					closestPlayer = value
					closestDistance = distance
				end
			end
		end
		return closestPlayer, closestDistance
	end
end

function GetClosestPlayerAny()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)


	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance



end


function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPed = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestPed = target
					closestDistance = distance
				end
			end
		end
		
		return closestPlayer, closestDistance, closestPed

	end
end
function GetClosestPedIgnoreCar()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPlayerId = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = target
				closestPlayerId = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance, closestPlayerId
end
function GetClosestPlayerIgnoreCar()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

handCuffedWalking = false
RegisterNetEvent('handCuffedWalking')
AddEventHandler('handCuffedWalking', function()

	if handCuffedWalking then
		handCuffedWalking = false
		TriggerEvent("handcuffed",false)
		TriggerEvent("animation:PlayAnimation","cancel")
		TriggerEvent('InteractSound_CL:PlayOnOne', 'handcuff', 0.4)
		TriggerEvent("police:currentHandCuffedState",false,false)
		return
	end
	
	handCuffedWalking = true
	handCuffed = false
	TriggerEvent("handcuffed",true)

	TriggerEvent('InteractSound_CL:PlayOnOne', 'handcuff', 0.4)

	TriggerEvent("police:currentHandCuffedState",handCuffed,handCuffedWalking)

end)

local disabledWeapons = false
RegisterNetEvent("disabledWeapons")
AddEventHandler("disabledWeapons", function(sentinfo)
	SetCurrentPedWeapon(PlayerPedId(), `weapon_unarmed`, 1)
	disabledWeapons = sentinfo
end)

Citizen.CreateThread(function() 

  while true do

	Citizen.Wait(5)
	

    if disabledWeapons then
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
    end

    if beingDragged or escort then
		DisableControlAction(1, 23, true)  -- F
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions	
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
		DisableControlAction(2, 32, true)
		DisableControlAction(1, 33, true)
		DisableControlAction(1, 34, true)
		DisableControlAction(1, 35, true)
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisableControlAction(0, 59)
		DisableControlAction(0, 60)
		DisableControlAction(2, 31, true) 
		SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    end

    if handCuffedWalking or handCuffed then
    	
    	if handCuffed and CanPedRagdoll(PlayerPedId()) then
    		SetPedCanRagdoll(PlayerPedId(), false)
    	end

    	number = 49

    	if handCuffed then 
    		number = 16
		else 
			number = 49
		end

		DisableControlAction(1, 23, true)  -- F
		DisableControlAction(1, 288, true) -- F1
		DisableControlAction(1, 311, true) -- K
		DisableControlAction(1, 243, true) -- ~
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions	
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
		if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not exports['drp-death']:GetDeathStatus()) or (IsPedRagdoll(PlayerPedId()) and not exports['drp-death']:GetDeathStatus()) then
	    	RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(1)
			end
			TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, number, 0, 0, 0, 0)
		end
		if exports['drp-death']:GetDeathStatus() then
			Citizen.Wait(1000)
		end
    end

	if not handCuffed and not CanPedRagdoll(PlayerPedId()) then
		SetPedCanRagdoll(PlayerPedId(), true)
	end
  end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

handcuffType = 16

RegisterNetEvent('police:isPlayerCuffed')
AddEventHandler('police:isPlayerCuffed', function(requestedID)
	TriggerServerEvent("police:confirmIsCuffed",requestedID,handCuffed)
end)

--Citizen.CreateThread(function()
-- 	while true do
--    	Citizen.Wait(10)
--
--		if isPolice or isState or isSheriff then
--
--			if IsControlJustReleased(2,172) and not IsControlPressed(0,19) then
--				TriggerEvent("police:cuffFromMenu",false)
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,172) and IsControlPressed(0,19) then
--				TriggerEvent("police:cuffFromMenu",true)
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,173) then
--				TriggerEvent("police:uncuffMenu")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,174) then
--				TriggerEvent("escortPlayer")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,175) then
--				TriggerEvent("police:forceEnter")
--				Citizen.Wait(400)
--			end
--
--		elseif isEMS then
--			if IsControlJustReleased(2,172) then
--				TriggerEvent("revive")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,173) then
--				TriggerEvent("ems:heal")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,174) then
--				TriggerEvent("escortPlayer")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,175) then
--				TriggerEvent("police:forceEnter")
--				Citizen.Wait(400)
--			end
--
--		elseif isSuit then
--			if IsControlJustReleased(2,172) then
--				TriggerEvent("revive")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,173) then
--				TriggerEvent("ems:heal")
--				Citizen.Wait(400)
--			end
--
--			if IsControlJustReleased(2,174) then
--				TriggerEvent("escortPlayer")
--				Citizen.Wait(400)
--			end
--		end
--	end
--end)


RegisterNetEvent('binoculars:Activate')
AddEventHandler('binoculars:Activate', function()
	if not handCuffed and not handCuffedWalking then
	   TriggerEvent("binoculars:Activate2")
	end
end)

RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
	if not handCuffed and not handCuffedWalking then
	   TriggerEvent("camera:Activate2")
	end
end)

RegisterNetEvent('clientcheckLicensePlate')
AddEventHandler('clientcheckLicensePlate', function()
	if isPolice or isState or isSheriff then
	  playerped = PlayerPedId()
      coordA = GetEntityCoords(playerped, 1)
      coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
      targetVehicle = getVehicleInDirection(coordA, coordB)
     	targetspeed = GetEntitySpeed(targetVehicle) * 3.6
     	herSpeedMph = GetEntitySpeed(targetVehicle) * 2.236936
      licensePlate = GetVehicleNumberPlateText(targetVehicle)
      local vehicleClass = GetVehicleClass(targetVehicle)

      if licensePlate == nil then

		TriggerEvent('DoLongHudText', 'Can not target vehicle!', 2)

      else
			TriggerServerEvent('checkLicensePlate',licensePlate)
		end
	end
end)

RegisterCommand('runplatet', function(source, args)
	if isPolice or isState or isSheriff then
		TriggerEvent('clientcheckLicensePlate')
	end
end)

RegisterCommand('911', function(source, args)
	TriggerServerEvent('911', args)
end)

RegisterCommand('911r', function(source, args)
	TriggerServerEvent('911r', args)
end)

RegisterCommand('311', function(source, args)
	TriggerServerEvent('311', args)
end)
	
RegisterCommand('311r', function(source, args)
	TriggerServerEvent('311r', args)
end)

RegisterCommand("sc", function(source, args)
	if isPolice or isState or isSheriff then
		TriggerServerEvent("police:cuffGranted2", args[1], "softcuff")
	end
end)

RegisterNetEvent('unseatPlayer')
AddEventHandler('unseatPlayer', function()
	t, distance = GetClosestPlayerIgnoreCar()
	if(distance ~= -1 and distance < 10) then
		local ped = PlayerPedId()  
		pos = GetEntityCoords(ped,  true)

		TriggerServerEvent('unseatAccepted',GetPlayerServerId(t),pos["x"], pos["y"], pos["z"])
		Citizen.Wait(1000)
		TriggerServerEvent("police:escortAsk", GetPlayerServerId(t))
	else
		TriggerEvent('DoLongHudText', 'No Player Found!', 2)
	end
end)

RegisterNetEvent('unseatPlayerFinish')
AddEventHandler('unseatPlayerFinish', function(x,y,z)
	local ped = PlayerPedId()  
	ClearPedTasksImmediately(ped)
	local veh = GetVehiclePedIsIn(ped, false)
    TaskLeaveVehicle(ped, veh, 256)
	SetEntityCoords(ped, x, y, z)
end)

function LoadAnimationDictionary(animationD) -- Simple way to load animation dictionaries to save lines.
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Citizen.Wait(1)
	end
end

otherid = 0
escort = false
keystroke = 49
triggerkey = false

dragging = false
beingDragged = false

escortStart = false
shitson = false

RegisterNetEvent('dragPlayer')
AddEventHandler('dragPlayer', function()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 1.2) then
		if not beingDragged then
			DetachEntity(PlayerPedId(), true, false)
			TriggerServerEvent("police:dragAsk", GetPlayerServerId(t))
		end
	end
end)

RegisterNetEvent('drag:stopped')
AddEventHandler('drag:stopped', function(sentid)
	if tonumber(sentid) == tonumber(otherid) and beingDragged then
		shitson = false
		beingDragged = false
		DetachEntity(PlayerPedId(), true, false)
		TriggerEvent("deathdrop",beingDragged)
	end
end)

RegisterNetEvent('escortPlayer')
AddEventHandler('escortPlayer', function()
	t, distance = GetClosestPlayer()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if(distance ~= -1 and distance < 4) then
			if not escort then
				TriggerServerEvent("police:escortAsk", GetPlayerServerId(t))
			end
		else
			escorting = false
		end
	end
end)

RegisterNetEvent("unEscortPlayer")
AddEventHandler("unEscortPlayer", function()
	escort = false
	beingDragged = false
	ClearPedTasks(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

local escorting = false

RegisterNetEvent("dr:releaseEscort")
AddEventHandler("dr:releaseEscort", function()
	escorting = false
end)

RegisterNetEvent("dr:escort")
AddEventHandler('dr:escort', function(pl)
	otherid = tonumber(pl)
	if not escort and IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end
	escort = not escort
	if not escort then
		TriggerServerEvent("dr:releaseEscort",otherid)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if escorting or dragging then
			if IsPedRunning(PlayerPedId()) or IsPedSprinting(PlayerPedId()) then
				SetPlayerControl(PlayerId(), 0, 0)
				Citizen.Wait(1000)
				SetPlayerControl(PlayerId(), 1, 1)
			end
		else
			Citizen.Wait(1000)
		end
		Citizen.Wait(5)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if IsEntityDead(GetPlayerPed(GetPlayerFromServerId(otherid))) and (escort) then 
			DetachEntity(PlayerPedId(), true, false)
			shitson = false	
			escort = false
			local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(otherid)), 0.0, 0.8, 2.8)
			SetEntityCoords(PlayerPedId(),pos)
		end


		if escort or beingDragged then
			local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
			local myped = PlayerPedId()
			if escort then
				x,y,z = 0.54, 0.44, 0.0
			else
				x,y,z = 0.0, 0.44, 0.0
			end
			if not beingDragged then
				AttachEntityToEntity(myped, ped, 11816, x, y, z, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				AttachEntityToEntity(myped, ped, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
			end
			
			shitson = true
			--escortStart = true
		else
			if not beingDragged and not escort and shitson then
				DetachEntity(PlayerPedId(), true, false)	
				shitson = false	
				Citizen.Trace("no escort or drag")
				ClearPedTasksImmediately(PlayerPedId())
			end
		end

		if dragging then

			if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
				LoadAnimationDictionary( "missfinale_c2mcs_1" ) 
				TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
			end
			if exports['drp-death']:GetDeathStatus() or IsControlJustPressed(0, 38) or (`WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId())) then
				dragging = false
				ClearPedTasks(PlayerPedId())
				TriggerServerEvent("dragPlayer:disable")
			end

		end

		if beingDragged then
			if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
				LoadAnimationDictionary( "amb@world_human_bum_slumped@male@laying_on_left_side@base" ) 
				TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
		end
		Citizen.Wait(5)
	end
end)

RegisterNetEvent('FlipVehicle')
AddEventHandler('FlipVehicle', function()
	
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)

	local targetVehicle = getVehicleInDirection(coordA, coordB)
	
	if targetVehicle ~= nil then
		local finished = exports["drp-taskbar"]:taskBar(math.random(4000, 6000),"Flipping Vehicle Over",false,true)	
		if finished == 100 then
			-- if player is still close to the vehicle, flip it
			local playerped = PlayerPedId()
			local pPitch, pRoll, pYaw = GetEntityRotation(playerped)
			local vPitch, vRoll, vYaw = GetEntityRotation(targetVehicle)
			SetEntityRotation(targetVehicle, pPitch, vRoll, vYaw, 1, true)
			Wait(10)
			SetVehicleOnGroundProperly(targetVehicle)
		end
	else
		TriggerEvent("DoLongHudText","No Vehicle found!", 2)
	end
end)

function deleteVeh(ent)
	SetVehicleHasBeenOwnedByPlayer(ent, true)
	NetworkRequestControlOfEntity(ent)
	local finished = exports["drp-taskbar"]:taskBar(1000,"Impounding",false,true)	
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(ent))
	DeleteEntity(ent)
	DeleteVehicle(ent)
	SetEntityAsNoLongerNeeded(ent)
end

RegisterNetEvent('impoundVehicle')
AddEventHandler('impoundVehicle', function()
	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
	licensePlate = GetVehicleNumberPlateText(targetVehicle)

	TriggerServerEvent("drp-vehicles:repo2",licensePlate)
	
	if DoesEntityExist(targetVehicle) then
		deleteVeh(targetVehicle)
		TriggerEvent('DoLongHudText', 'Impounded with retrieval price of $100', 1)
	else
		TriggerEvent('DoLongHudText', 'No vehicle to impound!', 2)
	end
end)

RegisterNetEvent('impoundsc')
AddEventHandler('impoundsc', function()
	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
	licensePlate = GetVehicleNumberPlateText(targetVehicle)
	TriggerServerEvent("drp-vehicles:repo3",licensePlate)
	deleteVeh(targetVehicle)
end)

RegisterNetEvent('civ:reimpoundscuff')
AddEventHandler('civ:reimpoundscuff', function()
	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
	licensePlate = GetVehicleNumberPlateText(targetVehicle)

	DeleteVehicle(targetVehicle)
	
	ped = GetPlayerPed(-1)
	location = GetEntityCoords(ped)
	cid = exports["isPed"]:isPed("cid")

	exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE id = @id', {['@id'] = cid}, function(vehicles)
		args = {
			model = vehicles[1].model,
			fuel = vehicles[1].fuel, 
			customized = vehicles[1].data,
			plate = vehicles[1].license_plate,
			enigine_damage = vehicles[i].engine_damage,
			body_damage = vehicles[i].body_damage,
		}
		local vehicle = SpawnVehicle(data.model, location, data.fuel, data.customized, data.plate, true, data.engine_health, data.body_health)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
	end)
end)

RegisterNetEvent('fullimpoundVehicle')
AddEventHandler('fullimpoundVehicle', function()
	playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
   	targetVehicle = getVehicleInDirection(coordA, coordB)
	licensePlate = GetVehicleNumberPlateText(targetVehicle)
	TriggerServerEvent("drp-vehicles:repo2",licensePlate)
	TriggerEvent('DoLongHudText', 'Impounded with retrieval price of $1500', 1)
	deleteVeh(targetVehicle)
end)


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
	
	if vehicle == nil then
		vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
	end

	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 25 then
		vehicle = nil
	end

	


    return vehicle ~= nil and vehicle or 0
end


RegisterNetEvent('police:stealrob')
AddEventHandler('police:stealrob', function()
	if not exports['drp-death']:GetDeathStatus() then
		RequestAnimDict("random@shop_robbery")
		while not HasAnimDictLoaded("random@shop_robbery") do
			Citizen.Wait(0)
		end
		-- TriggerEvent("stealcommand:log")
		local lPed = PlayerPedId()
		ClearPedTasksImmediately(lPed)

		TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
		local finished = exports["drp-taskbar"]:taskBar(15000,"Robbing",false,true)	

		if finished == 100 then
			t, distance, closestPed = GetClosestPlayer()

			if distance ~= -1 and distance < 4 and ( IsEntityPlayingAnim(closestPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(closestPed, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(closestPed, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(closestPed, "missminuteman_1ig_2", "handsup_base", 3) ) or TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0) then
				if not IsPedInAnyVehicle(PlayerPedId()) then
					ClearPedTasksImmediately(lPed)
					TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t), false)
					TriggerServerEvent("Stealtheybread", GetPlayerServerId(t))
				else
					TriggerEvent('DoLongHudText', 'You are in a vehicle asshole!', 2)
				end
			else
				TriggerEvent('DoLongHudText', 'They need to do /e handsup2 or be dead!', 2)
			end
		end
	else
		TriggerEvent('DoLongHudText', 'You are dead, you can\'t rob people you stupid fuck.', 2)
	end
end)

RegisterCommand('livery', function(source, args, raw)
  local coords = GetEntityCoords(GetPlayerPed(-1))
  local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
  if isPolice or isState or isSheriff or isEMS and GetVehicleLiveryCount(vehicle) - 1 >= tonumber(args[1]) then
  	SetVehicleLivery(vehicle, tonumber(args[1]))
	TriggerEvent('DoLongHudText', 'Livery Set', 1)
  else
	TriggerEvent('DoLongHudText', 'You are not a police officer!', 2)
  end
end)

RegisterCommand("extra", function(source, args, rawCommand)
	if isPolice or isState or isSheriff or isEMS then
	  local ped = PlayerPedId()
	  local veh = GetVehiclePedIsIn(ped, false)
	  local extraID = tonumber(args[1])
	  local extra = args[1]
	  local toggle = tostring(args[2])
	  if IsPedInAnyVehicle(ped, true) then
	  local veh = GetVehiclePedIsIn(ped, false)
		  if toggle == "true" then
			  toggle = 0
			  end
		  if veh ~= nil and veh ~= 0 and veh ~= 1 then
			  TriggerEvent('DoLongHudText', 'Extra Toggled', 1)
		
		  if extra == "all" then
			SetVehicleExtra(veh, 1, toggle)
			SetVehicleExtra(veh, 2, toggle)
			SetVehicleExtra(veh, 3, toggle)
			SetVehicleExtra(veh, 4, toggle)
			SetVehicleExtra(veh, 5, toggle)       
			SetVehicleExtra(veh, 6, toggle)
			SetVehicleExtra(veh, 7, toggle)
			SetVehicleExtra(veh, 8, toggle)
			SetVehicleExtra(veh, 9, toggle)               
			SetVehicleExtra(veh, 10, toggle)
			SetVehicleExtra(veh, 11, toggle)
			SetVehicleExtra(veh, 12, toggle)
			SetVehicleExtra(veh, 13, toggle)
			SetVehicleExtra(veh, 14, toggle)
			SetVehicleExtra(veh, 15, toggle)
			SetVehicleExtra(veh, 16, toggle)
			SetVehicleExtra(veh, 17, toggle)
			SetVehicleExtra(veh, 18, toggle)
			SetVehicleExtra(veh, 19, toggle)
			SetVehicleExtra(veh, 20, toggle)
			TriggerEvent('DoLongHudText', 'Extra All Toggled', 1)
		  elseif extraID == extraID then
			SetVehicleExtra(veh, extraID, toggle)
		  end
	   	end
	  end
	end
end, false)

RegisterCommand("serial", function(source, args)
	local ped = PlayerPedId()
	local dist = #(GetEntityCoords(ped)-vector3(483.9296875,-993.29669189453,30.678344726562))
	if dist <= 2.0 then 
		if isPolice or isState or isSheriff then
			TriggerServerEvent('weapons:get:data', args[1])
			exports["drp-taskbar"]:taskBar(20000,"Checking Serial")
			end
		else
		TriggerEvent('DoLongHudText', 'You are not near the lab to run this serial!', 2)
	end
end)

RegisterNetEvent('police:tenThirteenA')
AddEventHandler('police:tenThirteenA', function()
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == 'police' or myJob == 'ems' or myJob == 'state' or myJob == 'sheriff' then	
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13A",
			firstStreet = GetStreetAndZone(),
            name = exports["isPed"]:isPed("fullname"),
            number =  currentCallSign,
            priority = 1,
            isDead = true,
			dispatchMessage = "Officer Down URGENT!",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
            },
        })
		TriggerEvent('drp-dispatch:1013A')
	end
end)

RegisterNetEvent('police:tenThirteenB')
AddEventHandler('police:tenThirteenB', function()
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == 'police' or myJob == 'ems' or myJob == 'state' or myJob == 'sheriff' then	
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13B",
			firstStreet = GetStreetAndZone(),
            name = exports["isPed"]:isPed("fullname"),
            number =  currentCallSign,
            priority = 2,
            isDead = true,
			dispatchMessage = "Officer Down",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
            },
        })
		TriggerEvent('drp-dispatch:1013B')
	end
end)

RegisterNetEvent('police:policePanic')
AddEventHandler('police:policePanic', function()
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == 'police' or myJob == 'ems' or myJob == 'state' or myJob == 'sheriff' then	
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-78",
			firstStreet = GetStreetAndZone(),
            name = exports["isPed"]:isPed("fullname"),
            number =  currentCallSign,
            priority = 2,
            isDead = false,
			dispatchMessage = "Panic Button",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
            },
        })
		TriggerEvent('drp-dispatch:policepanic')
	end
end)


RegisterNetEvent("police:tenForteenA")
AddEventHandler("police:tenForteenA", function()
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == 'police' or myJob == 'ems' or myJob == 'state' or myJob == 'sheriff' then	
	local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-14A",
			firstStreet = GetStreetAndZone(),
            name = exports["isPed"]:isPed("fullname"),
            number =  currentCallSign,
            priority = 1,
            isDead = true,
			dispatchMessage = "Medic Down URGENT!",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
            },
        })
		TriggerEvent('drp-dispatch:1014A')
	end
end)

RegisterNetEvent("police:tenForteenB")
AddEventHandler("police:tenForteenB", function()
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == 'police' or myJob == 'ems' or myJob == 'state' or myJob == 'sheriff' then	
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-14B",
			firstStreet = GetStreetAndZone(),
            name = exports["isPed"]:isPed("fullname"),
            number =  currentCallSign,
            priority = 2,
            isDead = false,
			dispatchMessage = "Medic Down",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
            },
        })
		TriggerEvent('drp-dispatch:1014B')
	end
end)


RegisterNetEvent('ems:panicbutton')
AddEventHandler('ems:panicbutton', function()
	local myJob = exports["isPed"]:isPed("myJob")
	if myJob == 'ems' then
		local pos = GetEntityCoords(PlayerPedId(),  true)
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-78",
			firstStreet = GetStreetAndZone(),
            name = exports["isPed"]:isPed("fullname"),
            number =  currentCallSign,
            priority = 2,
            isDead = false,
			dispatchMessage = "EMS Panic Button",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
            },
        })
		TriggerEvent('drp-dispatch:emspanic')
	end
end)

RegisterNetEvent("police:billpd")
AddEventHandler("police:billpd", function(amount)
	local personalbill = math.ceil(amount / 10)
	local bankbill = math.ceil(amount - personalbill)
    TriggerServerEvent("server:GroupPayment","police", bankbill)
end)

cruisecontrol = false
RegisterNetEvent('toggle:cruisecontrol')
AddEventHandler('toggle:cruisecontrol', function()
	local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
	if driverPed == PlayerPedId() then
		if cruisecontrol then
			SetEntityMaxSpeed(currentVehicle, 999.0)
			cruisecontrol = false
			TriggerEvent("DoLongHudText","Speed Limiter Inactive",5)
		else
			speed = GetEntitySpeed(currentVehicle)
			if speed > 13.3 then
			SetEntityMaxSpeed(currentVehicle, speed)
			cruisecontrol = true
				TriggerEvent("DoLongHudText","Speed Limiter Active",5)
			else
				TriggerEvent("DoLongHudText","Speed Limiter can only activate over 35mph",2)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
        local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if not isInVeh and GetEntitySpeed(PlayerPedId()) > 2.5 then
            if IsControlJustReleased(0, 38) then
                TryTackle()
            end
        end
    end
end)

TimerEnabled = false

function TryTackle()
    if not TimerEnabled then
        t, distance = GetClosestPlayer()
        if(distance ~= -1 and distance < 2.2) then
            local maxheading = (GetEntityHeading(PlayerPedId()) + 15.0)
            local minheading = (GetEntityHeading(PlayerPedId()) - 15.0)
            local theading = (GetEntityHeading(t))

            TriggerServerEvent('CrashTackle',GetPlayerServerId(t))
            TriggerEvent("animation:tacklelol") 

            TimerEnabled = true
            Citizen.Wait(4500)
            TimerEnabled = false

        else
            TimerEnabled = true
            Citizen.Wait(1000)
            TimerEnabled = false

        end
    end
end

RegisterNetEvent('playerTackled')
AddEventHandler('playerTackled', function()
	SetPedToRagdoll(PlayerPedId(), math.random(2000, 8500), math.random(2000, 8500), 0, 0, 0, 0) 

	TimerEnabled = true
	Citizen.Wait(1500)
	TimerEnabled = false
end)

RegisterNetEvent('animation:tacklelol')
AddEventHandler('animation:tacklelol', function()

    if not handCuffed and not IsPedRagdoll(GetPlayerPed(-1)) then

        local lPed = GetPlayerPed(-1)

        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
            
        if IsEntityPlayingAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedSecondaryTask(lPed)
        else
            TaskPlayAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
            seccount = 3
            while seccount > 0 do
                Citizen.Wait(100)
                seccount = seccount - 1
            end
            ClearPedSecondaryTask(lPed)
            SetPedToRagdoll(GetPlayerPed(-1), 150, 150, 0, 0, 0, 0) 
        end        
    end
end)




local isAllowedStang = true

local isAllowedVette = true

local isAllowedDemon = true 

	RegisterNetEvent("spawnHeat:Demon")
	AddEventHandler("spawnHeat:Demon", function(data)
		if exports["isPed"]:GroupRank("heat") >= 1 then
			if isAllowedDemon == true then
			if data.livery == 'SASP' then
			local vehHash = GetHashKey("npolchal")
			RequestModel(vehHash)
			while not HasModelLoaded(vehHash) do
				RequestModel(vehHash)
				Citizen.Wait(1)
			end
			local spawnCoord = vector3(462.4992, -1019.523, 28.103)
			local vHeading = 85.538
			CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
			local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
			local vehplate = "HEAT"..math.random(10,99) .. "PD"
			SetVehicleNumberPlateText(veh, vehplate)
			TriggerEvent("keys:addNew",veh, plate)
	
			SetVehicleModKit(veh, 0)
	
			SetVehicleMod(veh, 46, 4, true)
			SetVehicleMod(veh, 42, 2, true) 
			SetVehicleMod(veh, 44, 0, true) 
			SetVehicleMod(veh, 45, 7, true) 
			SetVehicleMod(veh, 48, 3, false)
	
			SetVehicleWindowTint(veh, 1)
			ToggleVehicleMod(veh,  22, true) 

			SetVehicleMod(veh, 15, 3, true)
	
	
			SetVehicleMod(veh, 6, 0, true) 
			SetVehicleMod(veh, 8, 6, true)
			SetVehicleMod(veh, 9, 9, true) 
	
			SetVehicleExtra(veh, 1, toggle)
			SetVehicleExtra(veh, 2, toggle)
			SetVehicleExtra(veh, 3, toggle)
			SetVehicleExtra(veh, 4, toggle)
			SetVehicleExtra(veh, 5, toggle)       
			SetVehicleExtra(veh, 6, toggle)
			SetVehicleExtra(veh, 7, toggle)
			SetVehicleExtra(veh, 8, toggle)
			isAllowedDemon = false
			TriggerEvent("DoLongHudText","You have spawned a Demon.")

		elseif data.livery == 'BCSO' then 
			local vehHash = GetHashKey("npolchal")
			RequestModel(vehHash)
			while not HasModelLoaded(vehHash) do
				RequestModel(vehHash)
				Citizen.Wait(1)
			end
			local spawnCoord = vector3(462.4992, -1019.523, 28.103)
			local vHeading = 85.538
			CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
			local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
			local vehplate = "HEAT"..math.random(10,99) .. "PD"
			SetVehicleNumberPlateText(veh, vehplate)
			TriggerEvent("keys:addNew",veh, plate)
	
			SetVehicleModKit(veh, 0)
	
			SetVehicleMod(veh, 46, 4, true)
			SetVehicleMod(veh, 42, 3, true) 
			SetVehicleMod(veh, 44, 0, true) 
			SetVehicleMod(veh, 45, 1, true) 
			SetVehicleMod(veh, 48, 1, false)
	
	
	
			SetVehicleMod(veh, 15, 3, true)
	
	
			SetVehicleMod(veh, 6, 0, true) 
			SetVehicleMod(veh, 8, 6, true)
			SetVehicleMod(veh, 9, 9, true) 
	
			SetVehicleExtra(veh, 1, toggle)
			SetVehicleExtra(veh, 2, toggle)
			SetVehicleExtra(veh, 3, toggle)
			SetVehicleExtra(veh, 4, toggle)
			SetVehicleExtra(veh, 5, toggle)       
			SetVehicleExtra(veh, 6, toggle)
			SetVehicleExtra(veh, 7, toggle)
			SetVehicleExtra(veh, 8, toggle)
			isAllowedDemon = false
			TriggerEvent("DoLongHudText","You have spawned a Demon.")
		elseif data.livery == 'LSPD' then 
			local vehHash = GetHashKey("npolchal")
			RequestModel(vehHash)
			while not HasModelLoaded(vehHash) do
				RequestModel(vehHash)
				Citizen.Wait(1)
			end
			local spawnCoord = vector3(462.4992, -1019.523, 28.103)
			local vHeading = 85.538
			CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
			local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
			local vehplate = "HEAT"..math.random(10,99) .. "PD"
			SetVehicleNumberPlateText(veh, vehplate)
			TriggerEvent("keys:addNew",veh, plate)
	
			SetVehicleModKit(veh, 0)
	
			SetVehicleMod(veh, 46, 4, true)
			SetVehicleMod(veh, 42, 1, true) 
			SetVehicleMod(veh, 44, 0, true) 
			SetVehicleMod(veh, 45, 1, true) 
			SetVehicleMod(veh, 48, 2, false)
	
	
	
			SetVehicleMod(veh, 15, 3, true)
	
	
			SetVehicleMod(veh, 6, 0, true) 
			SetVehicleMod(veh, 8, 6, true)
			SetVehicleMod(veh, 9, 9, true) 
	
			SetVehicleExtra(veh, 1, toggle)
			SetVehicleExtra(veh, 2, toggle)
			SetVehicleExtra(veh, 3, toggle)
			SetVehicleExtra(veh, 4, toggle)
			SetVehicleExtra(veh, 5, toggle)       
			SetVehicleExtra(veh, 6, toggle)
			SetVehicleExtra(veh, 7, toggle)
			SetVehicleExtra(veh, 8, toggle)
			isAllowedDemon = false
			TriggerEvent("DoLongHudText","You have spawned a Demon.")
		end
	else
		TriggerEvent("DoLongHudText","You already took out 1 Demon today!.",2)
	end
	end
	end)

	

RegisterNetEvent("spawnHeat:StangVariants")
AddEventHandler("spawnHeat:StangVariants", function(data)
	if exports["isPed"]:GroupRank("heat") >= 1 then
		if isAllowedStang == true then
		if data.livery == 'SASP' then
		local vehHash = GetHashKey("npolstang")
		RequestModel(vehHash)
		while not HasModelLoaded(vehHash) do
			RequestModel(vehHash)
			Citizen.Wait(1)
		end
		local spawnCoord = vector3(462.4992, -1019.523, 28.103)
		local vHeading = 85.538
		CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
		local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
		local vehplate = "HEAT"..math.random(10,99) .. "PD"
		SetVehicleNumberPlateText(veh, vehplate)
		TriggerEvent("keys:addNew",veh, plate)

        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 46, 4, true)	
		
		SetVehicleMod(veh, 42, 2, true)
		SetVehicleMod(veh, 44, 0, true)
		SetVehicleMod(veh, 45, 1, true)

		SetVehicleMod(veh, 48, 3, false)
		
		SetVehicleMod(veh, 6, 0, true)
		SetVehicleMod(veh, 15, 3, true)
		SetVehicleMod(veh, 0, 1, true) 
		SetVehicleMod(veh, 1, 2, true)
		SetVehicleMod(veh, 2, 2, true) 
		SetVehicleMod(veh, 3, 0, true) 
		SetVehicleMod(veh, 7, 4, true) 


		SetVehicleExtra(veh, 1, toggle)
		SetVehicleExtra(veh, 2, toggle)
		SetVehicleExtra(veh, 3, toggle)
		SetVehicleExtra(veh, 4, toggle)
		SetVehicleExtra(veh, 5, toggle)       
		SetVehicleExtra(veh, 6, toggle)
		SetVehicleExtra(veh, 7, toggle)
		SetVehicleExtra(veh, 8, toggle)

		isAllowedStang = false
		TriggerEvent("DoLongHudText","You have spawned a Mustang.")

	elseif data.livery == 'BCSO' then 
		local vehHash = GetHashKey("npolstang")
		RequestModel(vehHash)
		while not HasModelLoaded(vehHash) do
			RequestModel(vehHash)
			Citizen.Wait(1)
		end
		local spawnCoord = vector3(462.4992, -1019.523, 28.103)
		local vHeading = 85.538
		CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
		local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
		local vehplate = "HEAT"..math.random(10,99) .. "PD"
		SetVehicleNumberPlateText(veh, vehplate)
		TriggerEvent("keys:addNew",veh, plate)


        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 46, 4, true)	

		SetVehicleMod(veh, 42, 4, true)
		SetVehicleMod(veh, 44, 2, true)
		SetVehicleMod(veh, 45, 0, true)

		SetVehicleMod(veh, 48, 1, false)
		
		SetVehicleMod(veh, 6, 0, true)
		SetVehicleMod(veh, 15, 3, true)
		SetVehicleMod(veh, 0, 1, true) 
		SetVehicleMod(veh, 1, 2, true)
		SetVehicleMod(veh, 2, 2, true) 
		SetVehicleMod(veh, 3, 0, true) 
		SetVehicleMod(veh, 7, 4, true) 


		SetVehicleExtra(veh, 1, toggle)
		SetVehicleExtra(veh, 2, toggle)
		SetVehicleExtra(veh, 3, toggle)
		SetVehicleExtra(veh, 4, toggle)
		SetVehicleExtra(veh, 5, toggle)       
		SetVehicleExtra(veh, 6, toggle)
		SetVehicleExtra(veh, 7, toggle)
		SetVehicleExtra(veh, 8, toggle)

		isAllowedStang = false
		TriggerEvent("DoLongHudText","You have spawned a Mustang.")
	elseif data.livery == 'LSPD' then 
		local vehHash = GetHashKey("npolstang")
		RequestModel(vehHash)
		while not HasModelLoaded(vehHash) do
			RequestModel(vehHash)
			Citizen.Wait(1)
		end
		local spawnCoord = vector3(462.4992, -1019.523, 28.103)
		local vHeading = 85.538
		CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
		local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
		local vehplate = "HEAT"..math.random(10,99) .. "PD"
		SetVehicleNumberPlateText(veh, vehplate)
		TriggerEvent("keys:addNew",veh, plate)


        SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 46, 4, true)	
		SetVehicleMod(veh, 42, 1, true)
		SetVehicleMod(veh, 44, 0, true)
		SetVehicleMod(veh, 45, 1, true)

        SetVehicleMod(veh, 48, 2, false) 
		
		SetVehicleMod(veh, 6, 0, true)
		SetVehicleMod(veh, 15, 3, true)
		SetVehicleMod(veh, 0, 1, true) 
		SetVehicleMod(veh, 1, 2, true)
		SetVehicleMod(veh, 2, 2, true) 
		SetVehicleMod(veh, 3, 0, true) 
		SetVehicleMod(veh, 7, 4, true) 


		SetVehicleExtra(veh, 1, toggle)
		SetVehicleExtra(veh, 2, toggle)
		SetVehicleExtra(veh, 3, toggle)
		SetVehicleExtra(veh, 4, toggle)
		SetVehicleExtra(veh, 5, toggle)       
		SetVehicleExtra(veh, 6, toggle)
		SetVehicleExtra(veh, 7, toggle)
		SetVehicleExtra(veh, 8, toggle)

		isAllowedStang = false
		TriggerEvent("DoLongHudText","You have spawned a Mustang.")
	end
else
	TriggerEvent("DoLongHudText","You already took out 1 Mustang today!.",2)
end
end
end)



RegisterNetEvent("spawnHeat:VetteVariants")
AddEventHandler("spawnHeat:VetteVariants", function(data)
	if exports["isPed"]:GroupRank("heat") >= 1 then
		if isAllowedVette == true then
		if data.livery == 'SASP' then
		local vehHash = GetHashKey("npolvette")
		RequestModel(vehHash)
		while not HasModelLoaded(vehHash) do
			RequestModel(vehHash)
			Citizen.Wait(1)
		end
		local spawnCoord = vector3(462.4992, -1019.523, 28.103)
		local vHeading = 85.538
		CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
		local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
		local vehplate = "HEAT"..math.random(10,99) .. "PD"
		SetVehicleNumberPlateText(veh, vehplate)
		TriggerEvent("keys:addNew",veh, plate)

		SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 46, 4, true)


		SetVehicleMod(veh, 0, 2, true)

		SetVehicleMod(veh, 6, 0, true)
		SetVehicleMod(veh, 15, 3, true)
		SetVehicleMod(veh, 1, 1, true)
		SetVehicleMod(veh, 3, 1, true)
			

		SetVehicleMod(veh, 42, 2, true) 
		SetVehicleMod(veh, 44, 0, true)
		SetVehicleMod(veh, 45, 6, true) 

        SetVehicleMod(veh, 48, 3, false)

		SetVehicleExtra(veh, 1, toggle)
		SetVehicleExtra(veh, 2, toggle)
		SetVehicleExtra(veh, 3, toggle)
		SetVehicleExtra(veh, 4, toggle)
		SetVehicleExtra(veh, 5, toggle)       
		SetVehicleExtra(veh, 6, toggle)
		SetVehicleExtra(veh, 7, toggle)
		SetVehicleExtra(veh, 8, toggle)
		isAllowedVette = false
		TriggerEvent("DoLongHudText","You have spawned a Corvette.")

	elseif data.livery == 'BCSO' then 
		local vehHash = GetHashKey("npolvette")
		RequestModel(vehHash)
		while not HasModelLoaded(vehHash) do
			RequestModel(vehHash)
			Citizen.Wait(1)
		end
		local spawnCoord = vector3(462.4992, -1019.523, 28.103)
		local vHeading = 85.538
		CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
		local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
		local vehplate = "HEAT"..math.random(10,99) .. "PD"
		SetVehicleNumberPlateText(veh, vehplate)
		TriggerEvent("keys:addNew",veh, plate)

		SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 46, 4, true)


		SetVehicleMod(veh, 0, 2, true)

		SetVehicleMod(veh, 6, 0, true)
		SetVehicleMod(veh, 15, 3, true)
		SetVehicleMod(veh, 1, 1, true)
		SetVehicleMod(veh, 3, 1, true)
			


		SetVehicleMod(veh, 42, 3, true) 
		SetVehicleMod(veh, 44, 0, true)
		SetVehicleMod(veh, 45, 1, true) 

        SetVehicleMod(veh, 48,1, false)

		SetVehicleExtra(veh, 1, toggle)
		SetVehicleExtra(veh, 2, toggle)
		SetVehicleExtra(veh, 3, toggle)
		SetVehicleExtra(veh, 4, toggle)
		SetVehicleExtra(veh, 5, toggle)       
		SetVehicleExtra(veh, 6, toggle)
		SetVehicleExtra(veh, 7, toggle)
		SetVehicleExtra(veh, 8, toggle)
		isAllowedVette = false
		TriggerEvent("DoLongHudText","You have spawned a Corvette.")
	elseif data.livery == 'LSPD' then 
		local vehHash = GetHashKey("npolvette")
		RequestModel(vehHash)
		while not HasModelLoaded(vehHash) do
			RequestModel(vehHash)
			Citizen.Wait(1)
		end
		local spawnCoord = vector3(462.4992, -1019.523, 28.103)
		local vHeading = 85.538
		CreateVehicle(vehHash ,spawnCoord.x, spawnCoord.y, spawnCoord.z, vHeading, true, false) 
		local veh = GetClosestVehicle(spawnCoord.x, spawnCoord.y, spawnCoord.z, 3.0, 0, 127)
		local vehplate = "HEAT"..math.random(10,99) .. "PD"
		SetVehicleNumberPlateText(veh, vehplate)
		TriggerEvent("keys:addNew",veh, plate)

		SetVehicleModKit(veh, 0)
        SetVehicleMod(veh, 46, 4, true)


		SetVehicleMod(veh, 0, 2, true)

		SetVehicleMod(veh, 6, 0, true)
		SetVehicleMod(veh, 15, 3, true)
		SetVehicleMod(veh, 1, 1, true)
		SetVehicleMod(veh, 3, 1, true)
			

		SetVehicleMod(veh, 42, 1, true) 
		SetVehicleMod(veh, 44, 0, true)
		SetVehicleMod(veh, 45, 2, true) 

        SetVehicleMod(veh, 48, 2, false)

		SetVehicleExtra(veh, 1, toggle)
		SetVehicleExtra(veh, 2, toggle)
		SetVehicleExtra(veh, 3, toggle)
		SetVehicleExtra(veh, 4, toggle)
		SetVehicleExtra(veh, 5, toggle)       
		SetVehicleExtra(veh, 6, toggle)
		SetVehicleExtra(veh, 7, toggle)
		SetVehicleExtra(veh, 8, toggle)
		isAllowedVette = false
		TriggerEvent("DoLongHudText","You have spawned a Corvette.")
	end
else
	TriggerEvent("DoLongHudText","You already took out 1 Corvette today!.",2)
end
end
end)




	



-----Humane Lab ---------------------------

RegisterNetEvent('humane:lowerFloorTp')
AddEventHandler('humane:lowerFloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),3540.403, 3674.875, 20.9918)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('humane:upperFloorTp')
AddEventHandler('humane:upperFloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),3540.722, 3675.159, 28.12114)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

-----FIB building ---------------------------

RegisterNetEvent('fib:47FloorTp')
AddEventHandler('fib:47FloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),136.2636, -761.9683, 234.152)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('fib:GroundFloorTp')
AddEventHandler('fib:GroundFloorTp', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),136.1349, -761.8865, 45.75204)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

--// Evidence Room

local isNearRoyalPDEvidence = false

Citizen.CreateThread(function()
    exports["drp-polyzone"]:AddPolyZone("royal_evidence_spot", {
		vector2(473.7106628418, -992.21002197266),
		vector2(471.94668579102, -991.03723144532),
		vector2(472.0480041504, -997.73699951172),
		vector2(475.8786315918, -997.87292480468),
		vector2(476.12368774414, -992.79260253906),
		vector2(473.22244262696, -992.83972167968)
	  }, {
		name="royal_evidence_spot",
		minZ = 25.273416519166,
		maxZ = 27.273460388184
	  })
end)


RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "royal_evidence_spot" then
		isNearRoyalPDEvidence = true
		openMRPDEvidence()
		exports['drp-textui']:showInteraction('[E] Open Evidence Locker')
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "royal_evidence_spot" then
        isNearRoyalPDEvidence = false
    end
	exports['drp-textui']:hideInteraction()
end)

function openMRPDEvidence()
	Citizen.CreateThread(function()
        while isNearRoyalPDEvidence do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent("server-inventory-open", "1", "mrpdevidence")
			end
		end
	end)
end

local FIBEvidenceNear = false -- I FUCKING HATE LUA fjkoldsfjhoiüdfoujpgdiofkjiopöfghbipjuoiphoujbgcfnv
local RangerEvidence = false
local SandyEvidence = false
local PaletoEvidence = false


-- idk why I add it here lmao
local rockeyScrapYard = false

--Name: rockeystash | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("rockeystash", {
		vector2(2402.2155761718, 3078.7412109375),
		vector2(2402.1706542968, 3081.0559082032),
		vector2(2399.8823242188, 3080.91796875),
		vector2(2400.0600585938, 3078.7158203125)
	  }, {
		name="rockeystash",
		minZ = 50.81632232666,
		maxZ = 52.838470458984
	  })	  
end)


RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "rockeystash" then
		rockeyScrapYard = true
        RockeyStashO()
		exports['drp-textui']:showInteraction('[E] Open Stash')
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "rockeystash" then
        rockeyScrapYard = false
    end
	exports['drp-textui']:hideInteraction()
end)

function RockeyStashO()
	Citizen.CreateThread(function()
        while rockeyScrapYard do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				if exports["drp-inventory"]:hasEnoughOfItem("warehousekey6",1,false) then
					TriggerEvent("server-inventory-open", "1", "WAREHOUSE - rockey")
				else
					TriggerEvent("DoLongHudText","This is locked.",2)
				end
			end
		end
	end)
end

--Name: mrpdnewevidence | 2022-04-17T21:41:27Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("mrpdnewevidence", {
	vector2(424.6575012207, -1000.2319335938),
	vector2(424.8567199707, -988.12438964844),
	vector2(433.79968261718, -988.12768554688),
	vector2(434.27682495118, -977.07543945312),
	vector2(437.62002563476, -977.21075439454),
	vector2(437.96047973632, -970.78900146484),
	vector2(447.77130126954, -971.07598876954),
	vector2(459.150390625, -971.35040283204),
	vector2(459.17459106446, -968.70391845704),
	vector2(472.43530273438, -969.41381835938),
	vector2(471.99758911132, -978.41479492188),
	vector2(482.96606445312, -978.73547363282),
	vector2(483.19750976562, -982.48657226562),
	vector2(489.3889465332, -982.60595703125),
	vector2(488.82434082032, -1017.2877197266),
	vector2(471.14498901368, -1017.5462646484),
	vector2(471.11071777344, -1014.3736572266),
	vector2(467.1098022461, -1014.6069335938),
	vector2(459.0510559082, -1012.6098632812),
	vector2(459.43914794922, -1001.324584961),
	vector2(450.75845336914, -1001.0828857422),
	vector2(450.79470825196, -999.10052490234),
	vector2(425.3712463379, -999.11450195312)
  }, {
	name="mrpdnewevidence",
	--minZ = 27.69356918335,
	--maxZ = 32.64236831665
  })
end)
  
local mrpdnewevidence = false

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "mrpdnewevidence" then
		mrpdnewevidence = true
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "mrpdnewevidence" then
        mrpdnewevidence = false
    end
	exports['drp-textui']:hideInteraction()
end)


--Name: fibevidence | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("paletopdevidence", {
		vector2(-455.51608276368, 6003.904296875),
		vector2(-457.11755371094, 6001.5678710938),
		vector2(-452.4178161621, 5996.4350585938),
		vector2(-449.90124511718, 5999.0786132812)
	  }, {
		name="paletopdevidence",
		minZ = 36.995677947998,
		maxZ = 37.00838470459
	  })
end)


RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "paletopdevidence" then
		PaletoEvidence = true
        PaletoEvidenceR()
		exports['drp-textui']:showInteraction('[E] Open Evidence Locker')
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "paletopdevidence" then
        PaletoEvidence = false
    end
	exports['drp-textui']:hideInteraction()
end)

function PaletoEvidenceR()
	Citizen.CreateThread(function()
        while PaletoEvidence do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				
				local job = exports["isPed"]:isPed("myjob")
				if job == 'police' or job == 'state' or job == 'sheriff' then
					TriggerEvent("server-inventory-open", "1", "paletoevidence")
				end
			end
		end
	end)
end

--Name: fibevidence | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fibevidence", {
		vector2(1858.1328125, 3692.6838378906),
		vector2(1854.7012939454, 3690.841796875),
		vector2(1856.2200927734, 3688.4880371094),
		vector2(1859.8682861328, 3690.296875)
	  }, {
		name="sandypdevidence",
		minZ = 28.818534851074,
		maxZ = 30.828960418702
	  })
end)


RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "sandypdevidence" then
		SandyEvidence = true
        SandyEvidenceR()
		exports['drp-textui']:showInteraction('[E] Open Evidence Locker')
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "sandypdevidence" then
        SandyEvidence = false
    end
	exports['drp-textui']:hideInteraction()
end)

function SandyEvidenceR()
	Citizen.CreateThread(function()
        while SandyEvidence do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent("server-inventory-open", "1", "sandyevidence")
			end
		end
	end)
end


--Name: fibevidence | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fibevidence", {
		vector2(386.04348754882, 800.0947265625),
		vector2(386.15148925782, 799.0736694336),
		vector2(387.67163085938, 799.12219238282),
		vector2(388.16729736328, 800.1937866211)
	  }, {
		name="rangerevidence",
		minZ = 186,
		maxZ = 188
	  })
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "rangerevidence" then
		RangerEvidence = true
        RangerEvidenceR()
		exports['drp-textui']:showInteraction('[E] Open Evidence Locker')
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "rangerevidence" then
        RangerEvidence = false
    end
	exports['drp-textui']:hideInteraction()
end)

function RangerEvidenceR()
	Citizen.CreateThread(function()
        while RangerEvidence do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent("server-inventory-open", "1", "rangerevidence")
			end
		end
	end)
end



RegisterCommand("evidence", function(source, args)
	local job = exports["isPed"]:isPed("myjob")
	if job == 'police' or job == 'state' or job == 'sheriff' then
		if FIBEvidenceNear or isNearRoyalPDEvidence or RangerEvidence or SandyEvidence or PaletoEvidence or mrpdnewevidence then
			TriggerEvent("server-inventory-open", "1", "CASE ID: "..args[1])
		else
			TriggerEvent("DoLongHudText", "You are not near the evidence spot!", 2)
		end
	end
end)

--// Personal PD Lockers

RegisterNetEvent('drp-personal-pd-locker')
AddEventHandler('drp-personal-pd-locker', function()
	local cid = exports["isPed"]:isPed("cid")
	TriggerEvent("server-inventory-open", "1", "personalMRPD-"..cid)
end)

RegisterNetEvent('drp-pd-options')
AddEventHandler('drp-pd-options', function()
	TriggerEvent('drp-context:sendMenu', {
		{
            id = 1,
            header = "Personal PD Locker",
			txt = "Personal 🔒",
			params = {
                event = "drp-personal-pd-locker",
            }
        },
		{
            id = 2,
            header = "Clothing Shop",
			txt = "New Drip",
			params = {
                event = "royal:clothing:admin",
            }
        },
    })
end)

local isNearPersonalOrClothing = false

Citizen.CreateThread(function()
    exports["drp-polyzone"]:AddBoxZone("royal_mrpd_clothing_or_locker", vector3(461.5, -997.7, 30.69), 4.9, 5.0, {
		name="royal_mrpd_clothing_or_locker",
		heading=0,
		--debugPoly=true,
		minZ=28.69,
		maxZ=32.69
    }) 
end)


RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "royal_mrpd_clothing_or_locker" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "police" or job == "sheriff" or job == "state"then
			RoyalPDShit()
            isNearPersonalOrClothing = true
			exports['drp-textui']:showInteraction('[E] Police Changing Room')
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "royal_mrpd_clothing_or_locker" then
        isNearPersonalOrClothing = false
    end
	exports['drp-textui']:hideInteraction()
end)

function RoyalPDShit()
	Citizen.CreateThread(function()
        while isNearPersonalOrClothing do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('drp-pd-options')
			end
		end
	end)
end

-- Armory

ArmoryCuzzy = false

Citizen.CreateThread(function()
    exports["drp-polyzone"]:AddBoxZone("police_armory_royal_rp", vector3(482.66, -995.69, 31.67), 2, 1.6, {
        name="police_armory_royal_rp",
        heading=270,
		--debugPoly=true,
		minZ=27.67,
		maxZ=31.67
    })
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "police_armory_royal_rp" then
        ArmoryCuzzy = true     
		local myJob = exports["isPed"]:isPed("myJob")
		if myJob == 'police' or myJob == 'state' or myJob == 'sheriff' then
			ArmoryPD()
            exports['drp-textui']:showInteraction("[E] Armory")
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "police_armory_royal_rp" then
        ArmoryCuzzy = false
        exports['drp-textui']:hideInteraction()
    end
end)

function ArmoryPD()
	Citizen.CreateThread(function()
        while ArmoryCuzzy do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('police:general')
			end
		end
	end)
end

-- Ped

--function SetPoliceHeliPed()
--    modelHash = GetHashKey("s_m_y_dockwork_01")
--    RequestModel(modelHash)
--    while not HasModelLoaded(modelHash) do
--        Wait(1)
--    end
--    created_ped = CreatePed(0, modelHash , 441.92965698242, -974.62414550781, 43.686401367188  -1, true)
--    FreezeEntityPosition(created_ped, true)
--    SetEntityHeading(created_ped, 232.44094848633)
--    SetEntityInvincible(created_ped, true)
--    SetBlockingOfNonTemporaryEvents(created_ped, true)
--    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
--
--	modelHash = GetHashKey("s_m_y_dockwork_01")
--    RequestModel(modelHash)
--    while not HasModelLoaded(modelHash) do
--        Wait(1)
--    end
--    created_ped = CreatePed(0, modelHash , 340.49670410156, -582.72528076172, 28.791259765625  -1, true)
--    FreezeEntityPosition(created_ped, true)
--    SetEntityHeading(created_ped, 70.866142272949)
--    SetEntityInvincible(created_ped, true)
--    SetBlockingOfNonTemporaryEvents(created_ped, true)
--    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
--
--	modelHash = GetHashKey("s_m_y_dockwork_01")
--    RequestModel(modelHash)
--    while not HasModelLoaded(modelHash) do
--        Wait(1)
--    end
--    created_ped = CreatePed(0, modelHash , 351.24395751953, -575.05053710938, 74.15087890625  -1, true)
--    FreezeEntityPosition(created_ped, true)
--    SetEntityHeading(created_ped, 192.75592041016)
--    SetEntityInvincible(created_ped, true)
--    SetBlockingOfNonTemporaryEvents(created_ped, true)
--    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
--end

--Citizen.CreateThread(function()
--    SetPoliceHeliPed()
--end)

-- // FIB 

local isNearFIBelevator1 = false
local isNearFIBelevator2 = false

--Name: fib_1_1 | 2022-04-15T18:56:04Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fib_elevator", {
		vector2(2506.1201171875, -342.17779541016),
		vector2(2502.0617675782, -338.1072692871),
		vector2(2500.3286132812, -339.90768432618),
		vector2(2504.408203125, -343.92883300782)
  	}, {
	name="fib_elevator",
	minZ = 0,
	maxZ = 108,
  	})
end)
  
--Name: fib_elevator_2 | 2022-04-15T18:58:59Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fib_elevator", {
		vector2(2497.2722167968, -350.96731567382),
		vector2(2498.9291992188, -349.21697998046),
		vector2(2494.8630371094, -345.1694946289),
		vector2(2493.3669433594, -347.08865356446)
	}, {
	name="fib_elevator",
	minZ = 0,
	maxZ = 108
	})
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
	if name == "fib_elevator" then
	fibelevator()
	isNearFIBelevator1 = true
	exports['drp-textui']:showInteraction('[E] Use Elevator')
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
	if name == "fib_elevator" then
	isNearFIBelevator1 = false
	end
	exports['drp-textui']:hideInteraction()
end)

function fibelevator()
	Citizen.CreateThread(function()
		while isNearFIBelevator1 do
			Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('fib:elevatorMenu')
			end
		end
	end)
end

AddEventHandler("fib:elevatorMenu", function()
	TriggerEvent('drp-context:sendMenu', {
		{
            id = 1,
            header = "Level 1",
			txt = "Ground Floor",
			params = {
                event = "fib:level1",
            }
        },
		{
            id = 2,
            header = "Level 2",
			txt = "Locked 🔒",
			params = {
                event = "",
            }
        },
		{
            id = 3,
            header = "Level 3",
			txt = "Research & Armory",
			params = {
                event = "fib:level3",
            }
        },
		{
            id = 4,
            header = "Level 4",
			txt = "Cell Block",
			params = {
                event = "fib:level4",
            }
        },
    })

end)


AddEventHandler("fib:level1", function()
	local finished = exports['drp-taskbar']:taskBar(3333, "Using the Elevator")
	if finished then
		SetEntityCoords(GetPlayerPed(-1), 2497.0510, -349.6439, 94.0922)
	end
end)

AddEventHandler("fib:level3", function()
	local finished = exports['drp-taskbar']:taskBar(3333, "Using the Elevator")
	if finished then
		SetEntityCoords(GetPlayerPed(-1), 2496.9773, -349.5313, 101.8933)
	end
end)

AddEventHandler("fib:level4", function()
	local finished = exports['drp-taskbar']:taskBar(3333, "Using the Elevator")
	if finished then
		SetEntityCoords(GetPlayerPed(-1), 2497.0757, -349.6602, 105.6905)
	end
end)

  


RegisterNetEvent("drp-fib:elevator:2:up")
AddEventHandler("drp-fib:elevator:2:up", function()
	SetEntityCoords(GetPlayerPed(-1), 2504.8184, -432.9658, 106.9193)
end)

RegisterNetEvent("drp-fib:elevator:2:down")
AddEventHandler("drp-fib:elevator:2:down", function()
	SetEntityCoords(GetPlayerPed(-1), 2504.8184, -432.9569, 99.1067)
end)
  

local paletoarmor = false
--Name: fib_armor | 2022-04-15T09:43:33Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("paletopdarmory", {
		vector2(-448.04263305664, 6012.2802734375),
		vector2(-450.61328125, 6014.3208007812),
		vector2(-444.98977661132, 6019.765625),
		vector2(-442.36618041992, 6017.5229492188),
		vector2(-443.69580078125, 6016.212890625),
		vector2(-445.26385498046, 6017.544921875),
		vector2(-449.28353881836, 6014.1909179688)
	  }, {
		name="paletopdarmory",
		minZ = 35.995677947998,
		maxZ = 37.995677947998
	  })
end)



RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "paletopdarmory" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "police" or job == "sheriff" or job == "state" then
			PaletoArmor()
            paletoarmor = true
			exports['drp-textui']:showInteraction('[E] Armory')
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "paletopdarmory" then
        paletoarmor = false
    end
	exports['drp-textui']:hideInteraction()
end)

function PaletoArmor()
	Citizen.CreateThread(function()
        while paletoarmor do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('police:general')
			end
		end
	end)
end

local paletoclothes = false
--Name: fib_armor | 2022-04-15T09:43:33Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("paletoclothes", {
		vector2(-441.7126159668, 6010.1142578125),
		vector2(-439.00833129882, 6007.134765625),
		vector2(-435.42608642578, 6010.5341796875),
		vector2(-438.05227661132, 6013.0864257812)
	  }, {
		name="paletoclothes",
		minZ = 35.99564743042,
		maxZ = 37.99564743042
	  })
end)



RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "paletoclothes" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "police" or job == "sheriff" or job == "state" then
			PaletoClothes()
            paletoclothes = true
			exports['drp-textui']:showInteraction('[E] Clothes')
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "paletoclothes" then
        paletoclothes = false
    end
	exports['drp-textui']:hideInteraction()
end)

function PaletoClothes()
	Citizen.CreateThread(function()
        while paletoclothes do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('drp-pd-options')
			end
		end
	end)
end



local fibarmor = false
--Name: fib_armor | 2022-04-15T09:43:33Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fib_armor", {
		vector2(2531.365234375, -337.46981811524),
		vector2(2528.3024902344, -334.5863647461),
		vector2(2527.318359375, -335.78854370118),
		vector2(2528.9682617188, -337.67422485352),
		vector2(2525.7941894532, -341.0033569336),
		vector2(2523.7214355468, -339.01052856446),
		vector2(2522.5231933594, -340.0705871582),
		vector2(2525.7587890625, -343.1944885254)
	  }, {
		name="fib_armor",
		minZ = 99.89339447022,
		maxZ = 102.89339447022
	  })
end)
  
  
  

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "fib_armor" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "police" or job == "sheriff" or job == "state" then
			FIBArmor()
            fibarmor = true
			exports['drp-textui']:showInteraction('[E] Armory')
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "fib_armor" then
        fibarmor = false
    end
	exports['drp-textui']:hideInteraction()
end)

function FIBArmor()
	Citizen.CreateThread(function()
        while fibarmor do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('police:general')
			end
		end
	end)
end


--Name: fibevidence | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fibevidence", {
		vector2(2520.0314941406, -328.64779663086),
		vector2(2528.732421875, -318.73489379882),
		vector2(2525.5834960938, -315.86575317382),
		vector2(2523.4619140625, -315.23907470704),
		vector2(2522.2236328125, -316.66052246094),
		vector2(2526.265625, -321.0698852539),
		vector2(2522.8312988282, -324.6100769043),
		vector2(2519.2468261718, -321.28884887696),
		vector2(2516.4299316406, -324.4839477539)
	  }, {
		name="fibevidence",
		-- debugPoly=true,
		minZ = 100.89334869384,
		maxZ = 102.89334869384
	  })
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "fibevidence" then
		FIBEvidenceNear = true
        FIBEvidencee()
		exports['drp-textui']:showInteraction('[E] Open Evidence Locker')
	end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "fibevidence" then
        FIBEvidenceNear = false
    end
	exports['drp-textui']:hideInteraction()
end)

function FIBEvidencee()
	Citizen.CreateThread(function()
        while FIBEvidenceNear do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent("server-inventory-open", "1", "fibevidence")
			end
		end
	end)
end


local StateFIBLockerORClothing = false
--Name: fibclothes | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fib_clothes", {
		vector2(2522.2561035156, -328.91961669922),
		vector2(2518.5419921875, -332.94735717774),
		vector2(2520.3610839844, -334.99298095704),
		vector2(2520.6462402344, -334.2940979004),
		vector2(2519.5622558594, -332.88241577148),
		vector2(2522.1262207032, -329.83950805664),
		vector2(2523.083984375, -330.92446899414),
		vector2(2521.0063476562, -332.74523925782),
		vector2(2526.2751464844, -338.09149169922),
		vector2(2528.3771972656, -335.6382446289)
	  }, {
		name="fibclothingeg",
		minZ = 92.09220123291,
		maxZ = 95.09220123291
	  })
	  
end)

--Name: fibclothes | 2022-04-15T08:19:20Z
Citizen.CreateThread(function()
	exports["drp-polyzone"]:AddPolyZone("fib_clothes", {
		vector2(2514.8962402344, -341.27600097656),
		vector2(2517.1118164062, -338.22024536132),
		vector2(2519.3515625, -340.63858032226),
		vector2(2516.2763671875, -343.63650512696),
		vector2(2519.4326171875, -345.9057006836),
		vector2(2516.2783203125, -348.81466674804),
		vector2(2511.7846679688, -343.7023010254),
		vector2(2512.501953125, -343.28442382812),
		vector2(2515.0607910156, -345.7599182129),
		vector2(2514.9396972656, -345.0166015625),
		vector2(2516.6540527344, -343.25216674804)
	  }, {
		name="fib_clothes",
		minZ = 100.89330291748,
		maxZ = 103.14609527588
	  })
	  
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "fib_clothes" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "police" or job == "sheriff" or job == "state" then
			RoyalFIBPdShit()
            StateFIBLockerORClothing = true
			exports['drp-textui']:showInteraction('[E] Changing Room')
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "fib_clothes" then
        StateFIBLockerORClothing = false
    end
	exports['drp-textui']:hideInteraction()
end)

function RoyalFIBPdShit()
	Citizen.CreateThread(function()
        while StateFIBLockerORClothing do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('drp-pd-options')
			end
		end
	end)
end
  


-- // State HQ

local StateHQLockerORClothing = false

Citizen.CreateThread(function()
    exports["drp-polyzone"]:AddBoxZone("royal_state_hq_locker", vector3(361.75, -1593.02, 25.45), 3, 2.6, {
		name="royal_state_hq_locker",
		heading=320,
		--debugPoly=true,
		minZ=23.45,
		maxZ=27.45
    }) 
end)


RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "royal_state_hq_locker" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "police" or job == "sheriff" or job == "state"then
			RoyalHQPdShit()
            StateHQLockerORClothing = true
			exports['drp-textui']:showInteraction('[E] Police Changing Room')
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "royal_state_hq_locker" then
        StateHQLockerORClothing = false
    end
	exports['drp-textui']:hideInteraction()
end)

function RoyalHQPdShit()
	Citizen.CreateThread(function()
        while StateHQLockerORClothing do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('drp-pd-options')
			end
		end
	end)
end

--// State HQ Armory

ArmoryCuzzy = false

Citizen.CreateThread(function()
    exports["drp-polyzone"]:AddBoxZone("police_armory_royal_rp_2", vector3(364.16, -1603.62, 25.45), 2, 2, {
        name="police_armory_royal_rp_2",
		heading=320,
		--debugPoly=true,
		minZ=22.65,
		maxZ=26.65
    })
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
    if name == "police_armory_royal_rp_2" then
        ArmoryCuzzy2 = true     
		local myJob = exports["isPed"]:isPed("myJob")
		if myJob == 'police' or myJob == 'state' or myJob == 'sheriff' then
			ArmoryPD2()
            exports['drp-textui']:showInteraction("[E] Armory")
        end
    end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "police_armory_royal_rp_2" then
        ArmoryCuzzy2 = false
        exports['drp-textui']:hideInteraction()
    end
end)

function ArmoryPD2()
	Citizen.CreateThread(function()
        while ArmoryCuzzy2 do
            Citizen.Wait(5)
			if IsControlJustReleased(0, 38) then
				TriggerEvent('police:general')
			end
		end
	end)
end





--// METAL DETECTOR FOR COURT ROOM LOL bored man

local WalkedTrough = true

Citizen.CreateThread(function()
    exports["drp-polyzone"]:AddBoxZone("metaldetect_court:1", vector3(241.3, -1079.17, 29.29), 1.0, 1.2, {
        name="metaldetect_court:1",
		heading=271,
		--debugPoly=true,

    })

	exports["drp-polyzone"]:AddBoxZone("metaldetect_court:2", vector3(245.65, -1079.15, 29.29), 1.0, 1.0, {
        name="metaldetect_court:2",
		heading=271,
		--debugPoly=true,

    })
end)

RegisterNetEvent('drp-polyzone:enter')
AddEventHandler('drp-polyzone:enter', function(name)
	local mycid = exports["isPed"]:isPed("cid")

    if name == "metaldetect_court:1" or name == "metaldetect_court:2" and WalkedTrough == true then
		    WalkedTrough = false  
			print('In metal detector : Remove weapons')
			TriggerEvent('InteractSound_CL:PlayOnOne', 'metaldetector', 0.1)
			TriggerServerEvent('server-jail-item', 'ply-'..mycid, true)
			Wait(5000)
			TriggerEvent('DoLongHudText' , "Your Item's have been placed in a bag , Collect them on the way out ! ",2)
			WalkedTrough = true  
        end
end)

RegisterNetEvent('drp-polyzone:exit')
AddEventHandler('drp-polyzone:exit', function(name)
    if name == "metaldetect_court:1" or name == "metaldetect_court:2"  then
		Wait(5000)
		WalkedTrough = true 
    end
end)

RegisterNetEvent('courthouse:getitems')
AddEventHandler('courthouse:getitems', function(table)
    local mycid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("server-jail-item", 'ply-'..mycid, false)
    TriggerEvent("DoLongHudText", "You Retrieved Your Item's.")
end)

