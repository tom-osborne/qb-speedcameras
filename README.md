# qb-speedcameras
A simple resource to add speed cameras around the city.
- Some pre-configured camera locations provided.
- Additional camera locations can be easily added using the template shown in the config.lua. 
- Jobs can be exempt from being caught. By default this is set to 'police' and 'ambulance' jobs.
- Can bill any player or be set to only bill if the player owns the car they are driving.

## Dependencies
[qb-core](https://github.com/qbcore-framework/qb-core)  
[qb-phone](https://github.com/qbcore-framework/qb-phone)  
[qb-banking](https://github.com/qbcore-framework/qb-banking)  

## Installation
- Download from latest releases
- Extract files
- Rename folder to `qb-speedcameras`
- Make any changes you wish to the `config.lua`
- Drag folder into your `resources/[qb]` folder
- Ensure folder (`resources/[qb]` folder is ensured by default)
- Restart server

## Config
```lua
Config = {}

Config.MPH = true                 -- bool: false for KMH / true for MPH
Config.useCameraSound = true      -- bool: Makes a camera shutter sound effect
Config.useFlashingScreen = true   -- bool: Flashes screen white for a brief moment
Config.useBlips = true            -- bool: Turns blips on/off
Config.alertPolice = true         -- bool: Whether to alert police above certain speed
Config.alertSpeed = 130           -- number: Alerts police when caught above this speed
Config.useBilling = true          -- bool: Bills player by fineAmount automatically if true - Only change if you know what you're doing
Config.OnlyBillIfOwned = false    -- bool: Only bill the player if they own the vehicle they are driving
Config.showNotification = false   -- bool: Shows a notification when caught
Config.sendEmail = true           -- bool: Sends an email when caught, false shows a notification

Config.ignoredJobs = {}            -- table: Table of jobs that wll not get fined by the cameras when on duty
Config.Cameras = {}               -- table: List of cameras
```

# Developers

## Client Events
> ## `qb-speedcameras:client:caught`
> Usage:
> ```lua
> RegisterNetEvent("qb-speedcameras:client:caught", function(playerCar, camera_location)
>     -- Event handler code
> end)
> ```
> Triggered upon player being caught  
> - `playerCar` **number** The vehicle the player was in at the time of being caught.
> - `camera_location` **vec3** The camera location that caught the player.


## Server Events
> ## `qb-speedcameras:server:caught`
> Usage:
> ```lua
> RegisterNetEvent("qb-speedcameras:server:caught", function(netID, camera_location)
>     -- Event handler code
> end)
> ```
> Triggered upon player being caught  
> - `netID` **number** The network ID of the vehicle the player was in at the time of being caught.
> - `camera_location` **vec3** The camera location that caught the player.

## Credits
[esx_speedcamera](https://github.com/P4NDAzzGaming/esx_speedcamera)
