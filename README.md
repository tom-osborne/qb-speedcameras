# qb-speedcameras
Originally an esx script that was "converted" to QBCore even though the files weren't using qbcore calls and were instead using nvcore.

- Heavily modified code
- Added config

Has pre-setup cameras already and should be reasonably self explanatory for adding new cameras (go into cofig.lua) if anyone posts an issue about adding cameras I will add instructions here.


## Requirements
QB-PHONE | https://github.com/qbcore-framework/qb-phone  
QB-BANKING | https://github.com/qbcore-framework/qb-banking  
not sure about any other requirements


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