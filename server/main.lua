ESX = nil
local nmafija = 0
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(Config.Mafije) do
	TriggerEvent('esx_society:registerSociety', k, k, 'society_' .. k, 'society_'..k, 'society_'..k, {type = 'public'})
	nmafija = nmafija + 1
end

print('[^1esxbalkan_mafias^0]: Developed by ^5ESX-Balkan Developer Team^0 | Loaded ^4' .. nmafija .. '^0 mafias')
--[[local Posao = {
	[0] = '',
	[1] = ''

}

RegistrujPosao = function(posao) do


end
--]]
-----------------------
-----CALLBACKOVI-------
-----------------------
ESX.RegisterServerCallback('esxbalkan_mafije:getOtherPlayerData', function(source, cb, target)
		local xPlayer = ESX.GetPlayerFromId(target)
		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout
		}
		cb(data)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

-----------------------
-------EVENTOVI--------
-----------------------
RegisterNetEvent('esxbalkan_mafije:oduzmiItem')
AddEventHandler('esxbalkan_mafije:oduzmiItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- provera kolicine
		if targetItem.count > 0 and targetItem.count <= amount then

			-- da li moze da nosi stvari
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterNetEvent('esxbalkan_mafije:vezivanje')
AddEventHandler('esxbalkan_mafije:vezivanje', function(target)
	local xPlayer = ESX.GetPlayerFromId(source) 
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
		TriggerClientEvent('esxbalkan_mafije:vezivanje', target)
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterNetEvent('esxbalkan_mafije:vuci')
AddEventHandler('esxbalkan_mafije:vuci', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
		TriggerClientEvent('esxbalkan_mafije:vuci', target, source)
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterNetEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esxbalkan_mafije:staviUVozilo', target)
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterNetEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esxbalkan_mafije:staviVanVozila', target)
		if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterNetEvent('esxbalkan_mafije:poruka')
AddEventHandler('esxbalkan_mafije:poruka', function(target, msg)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
	TriggerClientEvent('esx:showNotification', target, msg)
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)
