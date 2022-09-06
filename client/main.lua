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
end

local function createBlips()
    if not Config.useBlips then return end
    for camera_speed, camera_data in pairs(Config.Cameras) do
        local camera_title = "Speed Camera [" .. tostring(camera_speed) .. speedUnit .. "]"
        for _, camera_location in pairs(camera_data.locations) do
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

local function checkJob()
  local playerJob = PlayerData.job
  if playerJob then
    for _, job in pairs(Config.ignoredJobs) do
      if playerJob.name == job and playerJob.onduty then
        return true
      end
    end
  end
  return false
end

local function OnPoliceAlert(message)
    TriggerServerEvent("police:server:policeAlert", message)
end

RegisterNetEvent('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PlayerData = QBCore.Functions.GetPlayerData()
        createBlips()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    createBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('qb-speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)

RegisterNetEvent('qb-speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)

CreateThread(function()
    while true do
        Wait(100)
        local playerPed = PlayerPedId()
        local playerCar = GetVehiclePedIsIn(playerPed, false)

        for maxSpeed, camera_data in pairs(Config.Cameras) do
            for _, camera_location in pairs(camera_data.locations) do
                local plyCoords = GetEntityCoords(playerPed, false)
                local dist = #(plyCoords - camera_location)
                local vehSpeed = GetEntitySpeed(playerPed) * speedCoeff

                if dist <= 20.0 and vehSpeed > maxSpeed and IsPedInAnyVehicle(playerPed, false) and (GetPedInVehicleSeat(playerCar, -1) == playerPed) and hasBeenCaught == false then
                    if not checkJob() then

                        -- ALERT POLICE (START)
                        if Config.alertPolice and vehSpeed > Config.alertSpeed then
                            OnPoliceAlert(Lang:t('alert.caught_speeding', {
                                vehicle_plate = GetVehicleNumberPlateText(playerCar),
                                veh_speed = tostring(vehSpeed),
                                max_speed = tostring(maxSpeed),
                                speedUnit = speedUnit
                                })
                            )
                        end

                        if Config.useFlashingScreen then
                            TriggerServerEvent('qb-speedcamera:openGUI')

                            if Config.useCameraSound then
                                TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
                            end

                            Wait(200)
                            TriggerServerEvent('qb-speedcamera:closeGUI')
                        end

                        if Config.useBilling then
                            local msg = Lang:t('info.mail_msg', {
                                fineAmount = tostring(camera_data.fineAmount),
                                maxSpeed = tostring(maxSpeed),
                                speedUnit = speedUnit
                            })

                            if Config.showNotification then
                                QBCore.Functions.Notify(msg, "error")
                            end

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
                        Wait(5000)
                    end
                end
            end
            hasBeenCaught = false
            Wait(5000)
        end
    end
end)
