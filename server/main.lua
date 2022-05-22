local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-speedcamera:PayBill')
AddEventHandler('qb-speedcamera:PayBill', function(amount)
	print("Amount:", amount)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.RemoveMoney("bank", amount)
end)


RegisterServerEvent('qb-speedcamera:openGUI')
AddEventHandler('qb-speedcamera:openGUI', function()
	TriggerClientEvent('qb-speedcamera:openGUI', source)
end)

RegisterServerEvent('qb-speedcamera:closeGUI')
AddEventHandler('qb-speedcamera:closeGUI', function()
	TriggerClientEvent('qb-speedcamera:closeGUI', source)
end)
