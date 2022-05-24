QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local hasBeenCaught = false

local speedUnit = " KPH"
if Config.MPH then
  speedUnit = " MPH"
end

function nonbilling()
  -- Insert code here to execute when player is caught by speedcamera and you don't want to fine them
end

AddEventHandler('onResourceStart', function(resourceName)
  -- handles script restarts
  if GetCurrentResourceName() == resourceName then
      createBlips()
  end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  QBCore.Functions.GetPlayerData(function(PlayerData)
    PlayerJob = PlayerData.job
    PlayerData = QBCore.Functions.GetPlayerData()
  end)
  createBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
  PlayerData.job = JobInfo
end)

function hintToDisplay(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function createBlips()
  for camera_speed, camera_data in pairs(Config.Cameras) do
    -- Set the blip title
    local camera_title = "Speed Camera [" .. tostring(camera_speed) .. speedUnit .. "]" 
    -- Create blips
    for _, camera_location in pairs(camera_data.locations) do      
      if Config.useBlips == true then
        blip = AddBlipForCoord(camera_location.x, camera_location.y, camera_location.z)
        SetBlipSprite(blip, camera_data.blipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, camera_data.blipSize)
        SetBlipColour(blip, camera_data.blipColour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(camera_title)
        EndTextCommandSetBlipName(blip)
      end
    end
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(200)
    local playerPed = PlayerPedId()
    local playerCar = GetVehiclePedIsIn(playerPed, false)
    local veh = GetVehiclePedIsIn(playerPed)
    local maxSpeed = camera_speed
    local speedCoeff = 3.6
    local Speed = GetEntitySpeed(playerPed)*speedCoeff
    local plyCoords = GetEntityCoords(playerPed), false)

    if Config.MPH then
      speedCoeff = 2.236936
    end

    for camera_speed, camera_data in pairs(Config.Cameras) do
      for _, camera_location in pairs(camera_data.locations) do
        
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, camera_location.x, camera_location.y, camera_location.z)

        if dist <= 20.0 then
          if Speed > maxSpeed then
            if IsPedInAnyVehicle(playerPed, false) then
              if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                if hasBeenCaught == false then
                  -- Made Job only
                  if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
                    --if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
                    --elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
                  else
                    -- ALERT POLICE (START)
                    if Config.alertPolice then
                      if Speed > Config.alertSpeed then						
                        local playerPed = PlayerPedId()
                          PedPosition = GetEntityCoords(playerPed)
                          local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
                      end
                    end

                    if Config.useFlashingScreen then
                      TriggerServerEvent('qb-speedcamera:openGUI')
									
                      if Config.useCameraSound then
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
                      end
							
                      Citizen.Wait(200)
                      TriggerServerEvent('qb-speedcamera:closeGUI')
                    end
								
                    QBCore.Functions.Notify("You were fined $" .. camera_data.fineAmount .. " for speeding! Speed limit: " .. tostring(maxSpeed) .. speedUnit, "error")
									
                    if Config.useBilling then
                      TriggerServerEvent('qb-speedcamera:PayBill', camera_data.fineAmount)
                    else
                      nonbilling()
                    end
										
                    hasBeenCaught = true
                    Citizen.Wait(5000)
                  end
                end
              end
            end
            hasBeenCaught = false
            Citizen.Wait(5000) 
          end
        end
      end
    end
  end
end)

RegisterNetEvent('qb-speedcamera:openGUI')
AddEventHandler('qb-speedcamera:openGUI', function()
  SetNuiFocus(false,false)
  SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('qb-speedcamera:closeGUI')
AddEventHandler('qb-speedcamera:closeGUI', function()
  SendNUIMessage({type = 'closeSpeedcamera'})
end)
