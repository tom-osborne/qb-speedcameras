# qb-speedcameras
Originally an esx script that was "converted" to QBCore even though the files weren't using qbcore calls and were instead using nvcore
Has pre-setup cameras already and should be reasonably self explanatory for adding new cameras (go into client.lua) if anyone posts an issue about adding cameras I will add instructions here.


## Requirements
QB-PHONE | https://github.com/qbcore-framework/qb-phone
QB-BANKING | https://github.com/qbcore-framework/qb-banking
not sure about any other requirements

## Testing Results
Tested on WEEZOOKA'S RP and passed tests with flying colours even managing to fine players who were above the speed limit and caught by cameras

## If you don't want to fine the player
There is a function near the top of client/main.lua which you can put all of the code you want to have executed when the player
triggers a speedcamera
you must also change the useBilling = false variable at the top of the file to useBilling = true in order to use the function.

## Want to lower/raise fines?
Go into server/main.lua and there should be some notation outlining what to change if you want to change the fines for each type of speedcamera
