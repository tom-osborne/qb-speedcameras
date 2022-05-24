# qb-speedcameras
Originally converted fromm an esx script by WEEZOOKA - Re-written & Optimised by Stan

- Has a few pre-setup cameras. Additional camera locations can be added easily in to the config.lua. 
- Will not fine police or EMS. Additional jobs can be added into the client.lua. I may move this to the config soon.

## Requirements
QB-PHONE | https://github.com/qbcore-framework/qb-phone  
QB-BANKING | https://github.com/qbcore-framework/qb-banking  

## Config
```lua
Config = {}

Config.MPH = true                 -- false for KMH / true for MPH
Config.useCameraSound = true      
Config.useFlashingScreen = true
Config.useBlips = true
Config.alertPolice = true     
Config.alertSpeed = 130           -- Alerts police when caught above this speed
Config.useBilling = true

Config.Cameras = {
  -- [Speed] = ...
  [60] = {
    fineAmount = 50,
    blipColour = 5,
    blipSprite = 184,
    blipSize = 0.9,
    locations = {
      vector3(-524.2645, -1776.3569, 21.3384)
    }
  },
  [80] = {
    fineAmount = 75,
    blipColour = 17,
    blipSprite = 184,
    blipSize = 0.9,
    locations = {
      vector3(2506.0671, 4145.2431, 38.1054)
    }
  },
  [120] = {
    fineAmount = 100,
    blipColour = 1,
    blipSprite = 184,
    blipSize = 0.9,
    locations = {
      vector3(1584.9281, -993.4557, 59.3923),
      vector3(2442.2006, -134.6004, 59.3923),
      vector3(2871.7951, 3540.5795, 53.0930),
      vector3(2636.5, 474.12, 95.53)
    }
  }


}
```