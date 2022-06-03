QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local hasBeenCaught = false

local speedCoeff = 3.6
local speedUnit = " KPH"

if Config.MPH then
  speedCoeff = 2.236936
  speedUnit = " MPH" 
end

local function nonbilling()
  -- Insert code here to execute when player is caught by speedcamera and you don't want to fine them
  print("CAUGHT!!!!")
end

local function createBlips()
  for camera_speed, camera_data in pairs(Config.Cameras) do
    -- Set the blip title
    local camera_title = "Speed Camera [" .. tostring(camera_speed) .. speedUnit .. "]" 
    -- Create blips
    for _, camera_location in pairs(camera_data.locations) do      
      if Config.useBlips == true then
        -- print("Creating Blips for " .. camera_speed .. "mph camera")
        local blip = AddBlipForCoord(camera_location.x, camera_location.y, camera_location.z)
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

local function checkJob()
  local player_job = QBCore.Functions.GetPlayerData().job
  if player_job ~= nil then
    for _, v in pairs(Config.ignoredJobs) do
      if player_job.name == v and player_job.onduty then
        return true
      end
    end
  end
  return false
end

AddEventHandler('onResourceStart', function(resourceName)
  if GetCurrentResourceName() == resourceName then
      PlayerData = QBCore.Functions.GetPlayerData()
      createBlips()
  end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  PlayerData = QBCore.Functions.GetPlayerData()
  createBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
  PlayerData.job = JobInfo
end)


Citizen.CreateThread(function()

  while true do
    Wait(100)

    local playerPed = PlayerPedId()
    local playerCar = GetVehiclePedIsIn(playerPed, false)
    local veh = GetVehiclePedIsIn(playerPed)

    for camera_speed, camera_data in pairs(Config.Cameras) do
      for _, camera_location in pairs(camera_data.locations) do
        
        local plyCoords = GetEntityCoords(playerPed, false)
        local dist = #(plyCoords - camera_location)        
        local Speed = GetEntitySpeed(playerPed)*speedCoeff
        local maxSpeed = camera_speed

        if dist <= 20.0 then
          if Speed > maxSpeed then
            if IsPedInAnyVehicle(playerPed, false) then
              if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                if hasBeenCaught == false then
                  -- Made Job only
                  if checkJob() then
                    -- Do nothing!
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
																	
                    if Config.useBilling then
                      local msg = Lang:t('info.mail_msg', {
                        fineAmount = camera_data.fineAmount,
                        maxSpeed = tostring(maxSpeed),
                        speedUnit = speedUnit 
                      })
                      
                      if Config.showNotification then
                        QBCore.Functions.Notify(msg, "error")
                      end
                      
                      local mail_msg = Lang:t('info.mail_msg') .. "<br />" .. msg
                      if Config.sendEmail then
                        TriggerServerEvent('qb-phone:server:sendNewMail', {
                          sender = Lang:t('info.mail_sender'),
                          subject = Lang:t('info.mail_subject'),
                          message = msg,
                          button = {}
                        })
                      end
                      
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
