# qb-speedcameras
Originally converted from an esx script by WEEZOOKA - Re-written & Optimised  
**Original script** >> [esx_speedcamera](https://github.com/P4NDAzzGaming/esx_speedcamera)

- Has a few pre-setup cameras. Additional camera locations can be added easily in to the config.lua. 
- Will not fine police or EMS. Additional jobs can be added into the client.lua.

## Requirements
[qb-phone](https://github.com/qbcore-framework/qb-phone)  
[qb-banking](https://github.com/qbcore-framework/qb-banking)

## Config
```lua
Config = {}

Config.MPH = true                 -- false for KMH / true for MPH
Config.useCameraSound = true      -- Makes a camera shutter sound effect
Config.useFlashingScreen = true   -- Flashes screen white for a brief moment
Config.useBlips = true            -- Turns blips on/off
Config.alertPolice = true         -- Whether to alert police above certain speed
Config.alertSpeed = 130           -- Alerts police when caught above this speed
Config.useBilling = true          -- Bills player by fineAmount automatically if true - Only change if you know what you're doing
Config.showNotification = false   -- Shows a notification when caught
Config.sendEmail = true           -- Sends an email when caught, false shows a notification

Config.ignoredJobs = {}           -- Table of jobs that wll not get fined by the cameras when on duty
Config.Cameras = {}               -- List of cameras
```
