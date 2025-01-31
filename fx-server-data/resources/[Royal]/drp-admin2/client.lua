local devmodeToggle = false

RegisterNetEvent('RecieveActivePlayers')
AddEventHandler('RecieveActivePlayers', function(players)
  SendNUIMessage({action = "playerretrieve", players = players})
end)

RegisterNetEvent('drp:openmodmenu')
AddEventHandler('drp:openmodmenu', function()
  SendNUIMessage({action = "openadmin"})
  SetNuiFocus(true, true)

  local localIdFromPed = NetworkGetPlayerIndexFromPed(PlayerPedId())
  local localId = PlayerId()

  TriggerServerEvent('getallplayers', source)
end)

RegisterNetEvent('drp-adminmenu:CloseMouse')
AddEventHandler('drp-adminmenu:CloseMouse', function()
  SetNuiFocus(false, false)
end)

RegisterNUICallback('getplayercoords', function(data, cb)
  -- TriggerEvent('DoLongHudText', 'Players Current Coordinates Saved To [coords.txt]', 1)
  ExecuteCommand('coords')
end)

RegisterNUICallback('closenui', function(data, cb)
  SetNuiFocus(false, false)
end)

RegisterNUICallback('tptomarker', function(data, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({action = "closenui"})
  -- TriggerEvent("closenui")
  teleportMarker(nil)
end)

RegisterNUICallback('jobvu', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "entertainer")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobgallery', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "gallery")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobsrs', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "tuner_mech")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobpdm', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "car_shop")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobburgershot', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "burger_shot")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobcluckinbell', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "cluckin_bell")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobtokyos', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "rooster_rest")
  TriggerEvent("DoLongHudText","Job changed.")
end) 


RegisterNUICallback('jobrecords', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "records")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobharmony', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "repairs_harmony")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobhayes', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "auto_bodies")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobmamas', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "bahama_mamas")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobesate', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "real_estate")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobadmin', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "drp_Admin")
  TriggerEvent("DoLongHudText","Job changed.")
end) 

RegisterNUICallback('jobems', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "ems")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobleo', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "police")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('jobleo2', function(data, cb)
  TriggerServerEvent("jobssystem:jobs", "sheriff")
  TriggerEvent("DoLongHudText","Job changed.")
end)

RegisterNUICallback('maxstats', function(data, cb)
  TriggerEvent('drp-admin:maxstats')
end)

RegisterNUICallback('spawncar', function(data, cb)
  TriggerEvent('drp-adminmenu:runSpawnCommand', data.carname)
end)

RegisterNUICallback('sendAnnouncement', function(data, cb)
  TriggerServerEvent('drp-adminmenu:sendAnnoucement', data.message)
end)

RegisterNUICallback('spawnitem', function(data, cb)
  if data.itemamount == "" then
    TriggerEvent('player:receiveItem', data.itemname, 1)
  else
    TriggerEvent('player:receiveItem', data.itemname, data.itemamount)
  end
end)

RegisterNUICallback('drp-admin:update:vehicle:cl', function(data, cb)
  TriggerServerEvent('drp-admin:update:vehicle', source, data.licenseplate, data.garagename)
end)

RegisterNUICallback('viewentity', function(data, cb)
  TriggerServerEvent('drp-adminmenu:entviewtoggle',source, true, "All")
end)


RegisterNUICallback('devmode', function(data, cb)
  TriggerEvent('drp-admin:currentDevmode', data.returnvalue)
  devmodeToggle = data.returnvalue
end)

RegisterNUICallback('debugmode', function(data, cb)
  TriggerEvent('drp-admin:currentDebug', data.returnvalue)
end)

RegisterNUICallback('godmode', function(data, cb)
  SetPlayerInvincible(PlayerId(), data.returnvalue)
end)

RegisterNUICallback('invisible', function(data, cb)
  local setvisible = not data.returnvalue
  SetEntityVisible(PlayerPedId(), setvisible, 0)
end)

RegisterNUICallback('heal', function(data, cb)
  TriggerEvent("heal", PlayerPedId())
  TriggerEvent("Hospital:HealInjuries", PlayerPedId(),true) 
end)

RegisterNUICallback('revivepersonal', function(data, cb)
  TriggerEvent("drp-admin:ReviveInDistance")
end)

RegisterNUICallback('spectateplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  local player = GetPlayerFromServerId(data.selectedplayer)
  TriggerServerEvent("txAdmin:menu:spectatePlayer", player)
  print(data.selectedplayer)

end)

RegisterNUICallback('deletevehicle', function(data, cb)
  TriggerEvent( "wk:deleteVehicle" )
end)

RegisterNUICallback('bringplayer', function(data, cb)
  local player = data.selectedplayer
  print("Player Id from JS:" ..data.selectedplayer)
  local me = GetPlayerServerId(PlayerId())
  local coords = GetEntityCoords(GetPlayerFromServerId(PlayerPedId()))
  TriggerServerEvent('admin:bringPlayer', me, player)
end)

RegisterNUICallback('teleporttoplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  local player = data.selectedplayer
  local me = GetPlayerServerId(PlayerId())
  local coords = GetEntityCoords(GetPlayerFromServerId(PlayerPedId()))
  TriggerServerEvent('admin:teleportToPlayer', player)
end)

RegisterNUICallback('reviveplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  TriggerServerEvent("drp-death:reviveSV", data.selectedplayer)
  TriggerServerEvent("reviveGranted", data.selectedplayer)
  TriggerServerEvent("ems:healplayer",data.selectedplayer)
end)

RegisterNUICallback('healplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  TriggerEvent("heal", data.selectedplayer)
end)

RegisterNUICallback('removestress', function(data, cb)
  TriggerEvent("drp-hud:updateStress",false,5000)
end)

RegisterNUICallback('ViewEntities', function(data, cb)
  TriggerEvent('drp-admin:currentDebug')
end)

RegisterNUICallback('AYO', function(data, cb)
  TriggerEvent("DoLongHudText", 'AYOOOOOOOOO YOU CLICKED THE CUM MENU',2)
end)

RegisterCommand("lights", function()
  if exports["drp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then
dark = false
if dark == false then
    dark = true
    SetBlackout(true)
else
  dark = false
  SetBlackout(false)
end
end
end)

RegisterCommand("model", function()
  if exports["drp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then

    local model = exports["drp-applications"]:KeyboardInput({
        header = "Become Model",
        rows = {
        {
            id = 0,
            txt = "Enter Model Spawn"
        }}
    })
    if model[1] ~= nil then
        TriggerEvent('raid_clothes:AdminSetModel', model[1].input)
        TriggerEvent('drp-admin:raid_clothes:model', model[1].input)
    end
end
 --- IM LAZY AS FUCK
end)

RegisterCommand("debug", function()
if exports["drp-base"]:getModule("LocalPlayer"):getVar("rank") == ('dev' or 'admin' or 'superadmin' or 'mod' or 'owner') then

  debugmodeToggle = not debugmodeToggle
  if debugmodeToggle then
      TriggerEvent('DoLongHudText', 'Debug Enabled!', 1)
  else
      TriggerEvent('DoLongHudText', 'Debug Disabled!', 1)
  end
  TriggerEvent('drp-admin:currentDebug', debugmodeToggle)
end -- HERE TOO LOL
end)

Citizen.CreateThread( function()

  while true do 
      
      Citizen.Wait(1)
      
      if debugmodeToggle == true then
          local pos = GetEntityCoords(GetPlayerPed(-1))

          local forPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
          local backPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
          local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
          local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 

          local forPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
          local backPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
          local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
          local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    

          local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
          local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
          currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

          drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(GetPlayerPed(-1)), 55, 155, 55, 255)
          drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
          drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(GetPlayerPed(-1)), 55, 155, 55, 255)
          drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(GetPlayerPed(-1)), 55, 155, 55, 255)
          drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(GetPlayerPed(-1)), 55, 155, 55, 255)
          drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(GetPlayerPed(-1)), 55, 155, 55, 255)
          drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(GetPlayerPed(-1)), 55, 155, 55, 255)
          drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
          drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)
          
          
          DrawLine(pos,forPos, 255,0,0,115)
          DrawLine(pos,backPos, 255,0,0,115)

          DrawLine(pos,LPos, 255,255,0,115)
          DrawLine(pos,RPos, 255,255,0,115)           

          DrawLine(forPos,forPos2, 255,0,255,115)
          DrawLine(backPos,backPos2, 255,0,255,115)

          DrawLine(LPos,LPos2, 255,255,255,115)
          DrawLine(RPos,RPos2, 255,255,255,115)     

          local nearped = getNPC()

          local veh = GetVehicle()

          local nearobj = GetObject()

          if IsControlJustReleased(0, 38) then
              if inFreeze then
                  inFreeze = false
                  TriggerEvent("DoShortHudText",'Freeze Disabled',3)          
              else
                  inFreeze = true             
                  TriggerEvent("DoShortHudText",'Freeze Enabled',3)               
              end
          end

          if IsControlJustReleased(0, 47) then
              if lowGrav then
                  lowGrav = false
                  TriggerEvent("DoShortHudText",'Low Grav Disabled',3)            
              else
                  lowGrav = true              
                  TriggerEvent("DoShortHudText",'Low Grav Enabled',3)                 
              end
          end

      else
          Citizen.Wait(5000)
      end
  end
end)


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(0.25, 0.25)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end


function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNUICallback('clothingmenuplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  TriggerServerEvent("raid_clothes:openClothing2", data.selectedplayer)    
end)

-- TriggerEvent("raid_clothes:openClothing", true, true)

-- RegisterNUICallback('clothingmenu', function(data, cb)
--   TriggerEvent("raid_clothes:openClothing") 
-- end)

RegisterNUICallback('fixcarpersonal', function(data, cb)
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if not vehicle then return end
  SetVehicleFixed(vehicle)
  SetVehiclePetrolTankHealth(vehicle, 4000.0)
end)

RegisterNUICallback('tptocoords', function(data, cb)
        tptocoords()
end)


function tptocoords()
  if coords[1] ~= nil and coords[2] ~= nil and coords[3] ~= nil then
    local pos = vector3(tonumber(coords[1].input),tonumber(coords[2].input),tonumber(coords[3].input))
    local ped = PlayerPedId()

    Citizen.CreateThread(function()
        RequestCollisionAtCoord(pos)
        SetPedCoordsKeepVehicle(ped, pos)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(ped) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(PlayerId(), false)
    end)
  end
end


RegisterNUICallback('fixcarplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  TriggerServerEvent("drp:fixplayercar", data.selectedplayer)
end) 

RegisterNUICallback('searchinventoryplayer', function(data, cb)
  print("Player Id from JS:" ..data.selectedplayer)
  TriggerServerEvent('drp-adminmenu:CheckInventory', data.selectedplayer)
  SetNuiFocus(false,false)
  --local player = GetPlayerFromServerId(data.selectedplayer)
  --local player = GetPlayerFromServerId(player)
end)

RegisterNUICallback('viewinformationplayer', function(data, cb)
    -- marvin will do this one
end)

RegisterNetEvent('drp:fixcar')
AddEventHandler('drp:fixcar', function(playerreturn)  
    local playerIdx = GetPlayerFromServerId(playerreturn)
    local ped = GetPlayerPed(playerIdx)
    
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then return end
    
    SetVehicleFixed(vehicle)
    SetVehiclePetrolTankHealth(vehicle, 4000.0)
end)

RegisterNetEvent('drp:fixclothes')
AddEventHandler('drp:fixclothes', function(playerreturn)  
    local playerIdx = GetPlayerFromServerId(playerreturn)
    local ped = GetPlayerPed(playerIdx)
    TriggerEvent("raid_clothes:openClothing",ped)
    
end)

 RegisterNetEvent('drp:fixstress2')
 AddEventHandler('drp:fixstress2', function(playerreturn)  
     local playerIdx = GetPlayerFromServerId(playerreturn)
     local ped = GetPlayerPed(playerIdx)
     TriggerEvent("client:newStress",ped,false,10000)
 end)

function teleportMarker()

    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end
            Citizen.Wait(5)
        end
    else
        TriggerEvent("DoLongHudText", 'Failed to find marker.',2)
    end
end

local LastVehicle = nil
RegisterNetEvent("drp-adminmenu:runSpawnCommand")
AddEventHandler("drp-adminmenu:runSpawnCommand", function(model, livery)
    Citizen.CreateThread(function()

        local hash = GetHashKey(model)

        if not IsModelAVehicle(hash) then return end
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
        
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end

        local localped = PlayerPedId()
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)

        local heading = GetEntityHeading(localped)
        local vehicle = CreateVehicle(hash, coords, heading, true, false)

        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, 3, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 4, false)


        if model == "pol1" then
            SetVehicleExtra(vehicle, 5, 0)
        end

        if model == "police" then
            SetVehicleWheelType(vehicle, 2)
            SetVehicleMod(vehicle, 23, 10, false)
            SetVehicleColours(vehicle, 0, false)
            SetVehicleExtraColours(vehicle, 0, false)
        end

        if model == "pol7" then
            SetVehicleColours(vehicle,0)
            SetVehicleExtraColours(vehicle,0)
        end

        if model == "pol5" or model == "pol6" then
            SetVehicleExtra(vehicle, 1, -1)
        end


        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerEvent("keys:addNew",vehicle,plate)
        TriggerServerEvent('garages:addJobPlate', plate)
        SetModelAsNoLongerNeeded(hash)
        TaskWarpPedIntoVehicle(localped, vehicle, -1)
        
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleWindowTint(vehicle, 0)

        if livery ~= nil then
            SetVehicleLivery(vehicle, tonumber(livery))
        end
        LastVehicle = vehicle
    end)
end)

function GetPlayers()
  local players = {}

  for i = 0, 255 do
      if NetworkIsPlayerActive(i) then
          players[#players+1]= i
      end
  end

  return players
end

RegisterNetEvent("drp-admin:ReviveInDistance")
AddEventHandler("drp-admin:ReviveInDistance", function()
    local playerList = {}
    local players = GetPlayers()
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)


    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if(distance < 50) then
            playerList[index] = GetPlayerServerId(value)
        end
    end

    if playerList ~= {} and playerList ~= nil then
        TriggerServerEvent("admin:reviveAreaFromClient",playerList)

        for k,v in pairs(playerList) do
            TriggerServerEvent("reviveGranted", v)
            TriggerEvent("Hospital:HealInjuries",true) 
            TriggerServerEvent("ems:healplayer", v)
            TriggerEvent("heal")
        end
    end
    
end)

RegisterNetEvent("drp-admin:bringPlayer")
AddEventHandler("drp-admin:bringPlayer", function(targPos)
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(targPos.x, targPos.y, targPos.z)
        SetEntityCoordsNoOffset(PlayerPedId(), targPos.x, targPos.y, targPos.z, 0, 0, 2.0)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)    
end)

RegisterNetEvent('event:control:adminDev')
AddEventHandler('event:control:adminDev', function(useID)
    if not devmodeToggle then return end
    if useID == 1 then
        TriggerEvent("drp:openmodmenu")
    elseif useID == 2 then
        local bool = not isInNoclip
        RunNclp(nil,bool)
        TriggerEvent("drp-admin:noClipToggle",bool)
    elseif useID == 4 then
        teleportMarker(nil)
    end
end)


function RunNclp(self,bool)
    local cmd = {}
    cmd = {
        vars = {}
    }
    
    if bool and isInNoclip then return end
    isInNoclip = bool
    
    TriggerEvent("drp-admin:noClipToggle", isInNoclip)
end



local noClipEnabled = false
local noClipCam = nil

local speed = 1.0
local maxSpeed = 32.0
local minY, maxY = -89.0, 89.0

local inputRotEnabled = false

function toggleNoclip()
  CreateThread(function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local inVehicle = false

    Citizen.Wait(100)
    if veh ~= 0 then
      inVehicle = true
      ent = veh
    else
      ent = ped
    end

    local pos = GetEntityCoords(ent)
    local rot = GetEntityRotation(ent)

    noClipCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos, 0.0, 0.0, rot.z, 75.0, true, 2)
    AttachCamToEntity(noClipCam, ent, 0.0, 0.0, 0.0, true)
    RenderScriptCams(true, false, 3000, true, false)

    FreezeEntityPosition(ent, true)
    SetEntityCollision(ent, false, false)
    SetEntityAlpha(ent, 0)
    SetPedCanRagdoll(ped, false)
    SetEntityVisible(ent, false)
    ClearPedTasksImmediately(ped)

    if inVehicle then
      FreezeEntityPosition(ped, true)
      SetEntityCollision(ped, false, false)
      SetEntityAlpha(ped, 0)
      SetEntityVisible(ped, false)
    end

    while noClipEnabled do

      local rv, fv, uv, campos = GetCamMatrix(noClipCam)

      if IsDisabledControlPressed(2, 17) then -- MWheelUp
        speed = math.min(speed + 0.1, maxSpeed)
      elseif IsDisabledControlPressed(2, 16) then -- MWheelDown
        speed = math.max(0.1, speed - 0.1)
      end

      local multiplier = 1.0;

      if IsDisabledControlPressed(2, 209) then
        multiplier = 2.0
      elseif IsDisabledControlPressed(2, 19) then
        multiplier = 4.0
      elseif IsDisabledControlPressed(2, 36) then
        multiplier = 0.25
      end

      -- Forward and Backward
      if IsDisabledControlPressed(2, 32) then -- W
        local setpos = GetEntityCoords(ent) + fv * (speed * multiplier)
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      elseif IsDisabledControlPressed(2, 33) then -- S
        local setpos = GetEntityCoords(ent) - fv * (speed * multiplier)
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      end

      -- Left and Right
      if IsDisabledControlPressed(2, 34) then -- A
        local setpos = GetOffsetFromEntityInWorldCoords(ent, -speed * multiplier, 0.0, 0.0)
        SetEntityCoordsNoOffset(ent, setpos.x, setpos.y, GetEntityCoords(ent).z)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos.x, setpos.y, GetEntityCoords(ent).z)
        end
      elseif IsDisabledControlPressed(2, 35) then -- D
        local setpos = GetOffsetFromEntityInWorldCoords(ent, speed * multiplier, 0.0, 0.0)
        SetEntityCoordsNoOffset(ent, setpos.x, setpos.y, GetEntityCoords(ent).z)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos.x, setpos.y, GetEntityCoords(ent).z)
        end
      end

      -- Up and Down
      if IsDisabledControlPressed(2, 51) then -- E
        local setpos = GetOffsetFromEntityInWorldCoords(ent, 0.0, 0.0, multiplier * speed / 2)
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      elseif IsDisabledControlPressed(2, 52) then
        local setpos = GetOffsetFromEntityInWorldCoords(ent, 0.0, 0.0, multiplier * -speed / 2) -- Q
        SetEntityCoordsNoOffset(ent, setpos)
        if inVehicle then
          SetEntityCoordsNoOffset(ped, setpos)
        end
      end

      local camrot = GetCamRot(noClipCam, 2)
      SetEntityHeading(ent, (360 + camrot.z) % 360.0)

      SetEntityVisible(ent, false)
      if inVehicle then
        SetEntityVisible(ped, false)
      end

      DisableControlAction(2, 32, true)
      DisableControlAction(2, 33, true)
      DisableControlAction(2, 34, true)
      DisableControlAction(2, 35, true)
      DisableControlAction(2, 36, true)
      DisableControlAction(2, 12, true)
      DisableControlAction(2, 13, true)
      DisableControlAction(2, 14, true)
      DisableControlAction(2, 15, true)
      DisableControlAction(2, 16, true)
      DisableControlAction(2, 17, true)

      DisablePlayerFiring(PlayerId(), true)
      Wait(0)
    end

    DestroyCam(noClipCam, false)
    noClipCam = nil
    RenderScriptCams(false, false, 3000, true, false)
    FreezeEntityPosition(ent, false)
    SetEntityCollision(ent, true, true)
    SetEntityAlpha(ent, 255)
    SetPedCanRagdoll(ped, true)
    SetEntityVisible(ent, true)
    ClearPedTasksImmediately(ped)

    if inVehicle then
      FreezeEntityPosition(ped, false)
      SetEntityCollision(ped, true, true)
      SetEntityAlpha(ped, 255)
      SetEntityVisible(ped, true)
      SetPedIntoVehicle(ped, ent, -1)
    end
  end)
end

function checkInputRotation()
  CreateThread(function()
    while inputRotEnabled do
      while noClipCam == nil do
        Wait(0)
      end

      local rightAxisX = GetDisabledControlNormal(0, 220)
      local rightAxisY = GetDisabledControlNormal(0, 221)

      if (math.abs(rightAxisX) > 0) and (math.abs(rightAxisY) > 0) then
        local rotation = GetCamRot(noClipCam, 2)
        rotz = rotation.z + rightAxisX * -10.0

        local yValue = rightAxisY * -5.0

        rotx = rotation.x

        if rotx + yValue > minY and rotx + yValue < maxY then
          rotx = rotation.x + yValue
        end

        SetCamRot(noClipCam, rotx, rotation.y, rotz, 2)
      end

      Wait(0)
    end
  end)
end

AddEventHandler("drp-admin:noClipToggle", function(pIsEnabled)
  noClipEnabled = pIsEnabled
  inputRotEnabled = pIsEnabled

  if noClipEnabled and inputRotEnabled then
    toggleNoclip()
    checkInputRotation()
  end
end)


-- The distance to check in front of the player for a vehicle   
local distanceToCheck = 5.0

-- The number of times to retry deleting a vehicle if it fails the first time 
local numRetries = 5

-- Add an event handler for the deleteVehicle event. Gets called when a user types in /dv in chat
RegisterNetEvent( "wk:deleteVehicle" )
AddEventHandler( "wk:deleteVehicle", function()
  local ped = GetPlayerPed( -1 )

  if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
      local pos = GetEntityCoords( ped )

      if ( IsPedSittingInAnyVehicle( ped ) ) then 
          local vehicle = GetVehiclePedIsIn( ped, false )

          if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
              DeleteGivenVehicle( vehicle, numRetries )
          else 
            TriggerEvent("DoLongHudText","You must be in the driver's seat!")
          end 
      else
          local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
          local vehicle = GetVehicleInDirection( ped, pos, inFrontOfPlayer )

          if ( DoesEntityExist( vehicle ) ) then 
              DeleteGivenVehicle( vehicle, numRetries )
          else 
              TriggerEvent("DoLongHudText","You must be in or near a vehicle to delete it.")
          end 
      end 
  end 
end )

function DeleteGivenVehicle( veh, timeoutMax )
  local timeout = 0 

  SetEntityAsMissionEntity( veh, true, true )
  DeleteVehicle( veh )

  if ( DoesEntityExist( veh ) ) then
      TriggerEvent("DoLongHudText","Failed to delete vehicle, trying again...")

      -- Fallback if the vehicle doesn't get deleted
      while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
          DeleteVehicle( veh )

          -- The vehicle has been banished from the face of the Earth!
          if ( not DoesEntityExist( veh ) ) then 
              TriggerEvent("DoLongHudText","Vehicle deleted.")
          end 

          -- Increase the timeout counter and make the system wait
          timeout = timeout + 1 
          Citizen.Wait( 500 )

          -- We've timed out and the vehicle still hasn't been deleted. 
          if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
              TriggerEvent("DoLongHudText","Failed.")
          end 
      end 
  else 
      TriggerEvent("DoLongHudText","Vehicle deleted.")
  end 
end 
function GetVehicle()
  local playerped = GetPlayerPed(-1)
  local playerCoords = GetEntityCoords(playerped)
  local handle, ped = FindFirstVehicle()
  local success
  local rped = nil
  local distanceFrom
  repeat
      local pos = GetEntityCoords(ped)
      local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
      if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
          distanceFrom = distance
          rped = ped
         -- FreezeEntityPosition(ped, inFreeze)
      if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
        DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
      else
        DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
      end
          if lowGrav then
            SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+5.0)
          end
      end
      success, ped = FindNextVehicle(handle)
  until not success
  EndFindVehicle(handle)
  return rped
end

function GetObject()
  local playerped = GetPlayerPed(-1)
  local playerCoords = GetEntityCoords(playerped)
  local handle, ped = FindFirstObject()
  local success
  local rped = nil
  local distanceFrom
  repeat
      local pos = GetEntityCoords(ped)
      local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
      if distance < 10.0 then
          distanceFrom = distance
          rped = ped
          --FreezeEntityPosition(ped, inFreeze)
      if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
        DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
      else
        DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
      end

          if lowGrav then
            --ActivatePhysics(ped)
            SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            FreezeEntityPosition(ped, false)
          end
      end

      success, ped = FindNextObject(handle)
  until not success
  EndFindObject(handle)
  return rped
end

function getNPC()
  local playerped = GetPlayerPed(-1)
  local playerCoords = GetEntityCoords(playerped)
  local handle, ped = FindFirstPed()
  local success
  local rped = nil
  local distanceFrom
  repeat
      local pos = GetEntityCoords(ped)
      local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
      if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
          distanceFrom = distance
          rped = ped

      if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
        DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
      else
        DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
      end

          FreezeEntityPosition(ped, inFreeze)
          if lowGrav then
            SetPedToRagdoll(ped, 511, 511, 0, 0, 0, 0)
            SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
          end
      end
      success, ped = FindNextPed(handle)
  until not success
  EndFindPed(handle)
  return rped
end

function canPedBeUsed(ped)
  if ped == nil then
      return false
  end
  if ped == GetPlayerPed(-1) then
      return false
  end
  if not DoesEntityExist(ped) then
      return false
  end
  return true
end



-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( entFrom, coordFrom, coordTo )
local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
  local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
  
  if ( IsEntityAVehicle( vehicle ) ) then 
      return vehicle
  end 
end
