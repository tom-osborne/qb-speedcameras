QBCore = exports['qb-core']:GetCoreObject()

local useBilling = false -- OPTIONS: (true/false) Do not change this unless you know what you are doing
local useCameraSound = true -- OPTIONS: (true/false)
local useFlashingScreen = true -- OPTIONS: (true/false)
local useBlips = true -- OPTIONS: (true/false)
local alertPolice = true -- OPTIONS: (true/false)
local alertSpeed = 130 -- OPTIONS: (1-5000 KMH)

local speedUnit = " KPH"
if Config.MPH then
  speedUnit = " MPH"
end

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData = {}
local hasBeenCaught = false

function nonbilling()
	-- Insert code here to execute when player is caught by speedcamera and you don't want to fine them
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  QBCore.Functions.GetPlayerData(function(PlayerData)
    PlayerJob = PlayerData.job
    PlayerData = QBCore.Functions.GetPlayerData()
  end)  
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

Citizen.CreateThread(function()
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
end)

-- -- Blips
-- local Speedcamera60Zone = {
--     {x = -524.2645,y = -1776.3569,z = 21.3384}
-- }

-- local Speedcamera80Zone = {
--     {x = 2506.0671,y = 4145.2431,z = 38.1054}
-- }

-- local Speedcamera120Zone = {
--     {x = 1584.9281,y = -993.4557,z = 59.3923},
--     {x = 2442.2006,y = -134.6004,z = 88.7765},
--     {x = 2871.7951,y = 3540.5795,z = 53.0930}
-- }

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    for camera_speed, camera_data in pairs(Config.Cameras) do
      for _, camera_location in pairs(camera_data.locations) do

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, camera_location.x, camera_location.y, camera_location.z)

        if dist <= 20.0 then
          local playerPed = GetPlayerPed(-1)
          local playerCar = GetVehiclePedIsIn(playerPed, false)
          local veh = GetVehiclePedIsIn(playerPed)
          local maxSpeed = camera_speed
          local speedCoeff = 3.6
        
          if Config.MPH then
            speedCoeff = 2.236936
          end

          local Speed = GetEntitySpeed(playerPed)*speedCoeff
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
                    if alertPolice == true then
                      if Speed > alertSpeed then						
                        local playerPed = PlayerPedId()
                          PedPosition = GetEntityCoords(playerPed)
                          local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
                      end
                    end

                    if useFlashingScreen == true then
                      TriggerServerEvent('qb-speedcamera:openGUI')
                    end
									
                    if useCameraSound == true then
                      TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
                    end
									
                    if useFlashingScreen == true then
                      Citizen.Wait(200)
                      TriggerServerEvent('qb-speedcamera:closeGUI')
                    end
								
                    QBCore.Functions.Notify("You were fined " .. camera_data.fineAmount .. "for speeding! Speed limit exceeded: " .. tostring(maxSpeed) .. speedUnit, "error")
									
                    if useBilling == true then
                      nonbilling()
                    else
                      TriggerServerEvent('qb-speedcamera:PayBill', camera_data.fineAmount)
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
