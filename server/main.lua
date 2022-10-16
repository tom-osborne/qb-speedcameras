local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-speedcamera:PayBill', function(amount)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.RemoveMoney("bank", amount)
end)


RegisterServerEvent('qb-speedcamera:openGUI', function()
	TriggerClientEvent('qb-speedcamera:openGUI', source)
end)

RegisterServerEvent('qb-speedcamera:closeGUI', function()
	TriggerClientEvent('qb-speedcamera:closeGUI', source)
end)

QBCore.Functions.CreateCallback("qb-speedcameras:server:checkOwnership", function(source, cb, plate)
	local src = source
    local pData = QBCore.Functions.GetPlayer(src)
	MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ?', {pData.PlayerData.citizenid, plate}, function(result)
		if result[1] then
			cb(true)
		else
			cb(false)
		end
	end)
end)