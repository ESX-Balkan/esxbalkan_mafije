ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'automafija', 'automafija', 'society_automafija', 'society_automafija', 'society_automafija', {type = 'public'})

TriggerEvent('esx_society:registerSociety', 'ballas', 'ballas', 'society_ballas', 'society_ballas', 'society_ballas', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'camorra', 'camorra', 'society_camorra', 'society_camorra', 'society_camorra', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'favela', 'favela', 'society_favela', 'society_favela', 'society_favela', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'gsf', 'gsf', 'society_gsf', 'society_gsf', 'society_gsf', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'juzniv', 'juzniv', 'society_juzniv', 'society_juzniv', 'society_juzniv', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'lazarevacki', 'lazarevacki', 'society_lazarevacki', 'society_lazarevacki', 'society_automafija', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'lcn', 'lcn', 'society_lcn', 'society_lcn', 'society_lcn', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'ludisrbi', 'ludisrbi', 'society_ludisrbi', 'society_ludisrbi', 'society_ludisrbi', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'peaky', 'peaky', 'society_peaky', 'society_peaky', 'society_peaky', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'stikla', 'stikla', 'society_stikla', 'society_stikla', 'society_stikla', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'vagos', 'vagos', 'society_vagos', 'society_vagos', 'society_vagos', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'yakuza', 'yakuza', 'society_ayakuza', 'society_ayakuza', 'society_ayakuza', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'zemunski', 'zemunski', 'society_zemunski', 'society_zemunski', 'society_zemunski', {type = 'public'})
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
RegisterServerEvent('esxbalkan_mafije:oduzmiItem')
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

RegisterServerEvent('esxbalkan_mafije:vezivanje')
AddEventHandler('esxbalkan_mafije:vezivanje', function(target)
	local xPlayer = ESX.GetPlayerFromId(source) 
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
		TriggerClientEvent('esxbalkan_mafije:vezivanje', target)
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterServerEvent('esxbalkan_mafije:vuci')
AddEventHandler('esxbalkan_mafije:vuci', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
		TriggerClientEvent('esxbalkan_mafije:vuci', target, source)
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterServerEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esxbalkan_mafije:staviUVozilo', target)
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterServerEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esxbalkan_mafije:staviVanVozila', target)
		if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)

RegisterServerEvent('esxbalkan_mafije:poruka')
AddEventHandler('esxbalkan_mafije:poruka', function(target, msg)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ballas' or xPlayer.job.name == 'camorra' or xPlayer.job.name == 'favela' or xPlayer.job.name == 'gsf' or xPlayer.job.name == 'juzniv' or xPlayer.job.name == 'lazarevacki' or xPlayer.job.name == 'lcn' or xPlayer.job.name == 'ludisrbi' or xPlayer.job.name == 'peaky' or xPlayer.job.name == 'stikla' or xPlayer.job.name == 'vagos' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'zemunski' then
	TriggerClientEvent('esx:showNotification', target, msg)
	else
		DropPlayer(source, 'Zasto pokusavas da citujes. Nije lepo to :)')
	end
end)
