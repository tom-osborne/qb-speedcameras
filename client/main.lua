QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local inVehicle = false
local hasBeenCaught = false

local speedCoeff = 3.6
local speedUnit = " KPH"

if Config.MPH then
    speedCoeff = 2.236936
    speedUnit = " MPH"
end

---Dummy function for users to modify when they dont want to use the standard billing function provided
local function nonbilling()
    -- Insert code here to execute when player is caught by speedcamera and you don't want to fine them
end

---Creates map blips for speed camera locations. Requires config.useBlips to be enabled.
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

---Checks whether the player's job is in the Config.ignoredJobs table.
---@return boolean
local function checkJob()
    local playerJob = PlayerData.job
    if not playerJob then return false end
    for _, job in pairs(Config.ignoredJobs) do
        if playerJob.name == job and playerJob.onduty then return true end
    end
    return false
end

---Sends a bill to the client for the configured amount.
---@param camera_data table
---@param maxSpeed number
---@param units string
local function billPlayer(camera_data, maxSpeed, units)
    local msg = Lang:t('info.mail_msg', {
        fineAmount = tostring(camera_data.fineAmount),
        maxSpeed = tostring(maxSpeed),
        speedUnit = units
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
    TriggerServerEvent('qb-speedcameras:server:PayBill', camera_data.fineAmount)
end

---Handles billing logic when player is caught speeding if enabled in config
---@param playerCar number
---@param camera_data table
---@param maxSpeed number
local function handleBilling(playerCar, camera_data, maxSpeed)
    if not Config.useBilling then nonbilling() return end
    if not Config.OnlyBillIfOwned then billPlayer(camera_data, maxSpeed, speedUnit) return end

    local plate = QBCore.Functions.GetPlate(playerCar)
    QBCore.Functions.TriggerCallback("qb-speedcameras:server:checkOwnership", function(result)
        if result then
            billPlayer(camera_data, maxSpeed, speedUnit)
        end
    end, plate)

end

---Sends a police alert if enabled in config
local function policeAlert(vehSpeed, maxSpeed, playerCar)
    if not Config.alertPolice and vehSpeed > Config.alertSpeed then return end

    local message = Lang:t('alert.caught_speeding', {
        vehicle_plate = GetVehicleNumberPlateText(playerCar),
        veh_speed = tostring(vehSpeed),
        max_speed = tostring(maxSpeed),
        speedUnit = speedUnit
    })

    TriggerServerEvent("police:server:policeAlert", message)
end

---Displays a flash and camera sound for player when caught if enabled in config
local function cameraFlash()
    if Config.useFlashingScreen then
        TriggerServerEvent('qb-speedcameras:server:openGUI')

        if Config.useCameraSound then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
        end

        Wait(200)
        TriggerServerEvent('qb-speedcameras:server:closeGUI')
    end
end

---Main loop to check player speed when in vehicle and detect when caught speeding
local function monitorSpeed()
    inVehicle = true
    local sleep = 0
    if checkJob() then return end
    while inVehicle do
        local playerPed = PlayerPedId()
        local playerCar = GetVehiclePedIsIn(playerPed, false)

        if not IsPedInAnyVehicle(playerPed, false) then return end
        if GetPedInVehicleSeat(playerCar, -1) ~= playerPed then sleep = 5000 goto continue end

        for maxSpeed, camera_data in pairs(Config.Cameras) do
            for _, camera_location in pairs(camera_data.locations) do
                local plyCoords = GetEntityCoords(playerPed, false)
                local dist = #(plyCoords - camera_location)
                local vehSpeed = GetEntitySpeed(playerPed) * speedCoeff

                if dist > 20.0 then goto next end
                if vehSpeed < maxSpeed then goto continue end
                if hasBeenCaught then goto continue end

                policeAlert(vehSpeed, maxSpeed, playerCar)

                cameraFlash()

                handleBilling(playerCar, camera_data, maxSpeed)

                hasBeenCaught = true

                -- API calls
                TriggerEvent("qb-speedcameras:client:caught", playerCar, camera_location)
                TriggerServerEvent("qb-speedcameras:server:caught", NetworkGetNetworkIdFromEntity(playerCar), camera_location)

                Wait(5000)
                ::next::
            end
            hasBeenCaught = false
            Wait(5000)
        end
        ::continue::
        Wait(sleep)
    end
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

RegisterNetEvent('qb-speedcameras:client:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)

RegisterNetEvent('qb-speedcameras:client:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)

RegisterNetEvent("QBCore:Client:EnteredVehicle", function()
    monitorSpeed()
end)

RegisterNetEvent("QBCore:Client:LeftVehicle", function()
    inVehicle = false
end)