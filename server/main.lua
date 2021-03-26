ESX = nil
local nmafija = 0
local Pretrazivan = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


for k,v in pairs(Config.Mafije) do
	TriggerEvent('esx_society:registerSociety', k, k, 'society_' .. k, 'society_'..k, 'society_'..k, {type = 'public'})
	nmafija = nmafija + 1
end

print('[^1esxbalkan_mafias^0]: Napravljeno od ^5ESX-Balkan^0 | Ucitano ^4' .. nmafija .. '^0 mafia')

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

RegisterServerEvent('esxbalkan_mafije:PretrazujuMe')
AddEventHandler('esxbalkan_mafije:PretrazujuMe', function(id, br)
	Pretrazivan[id] = br
end)

ESX.RegisterServerCallback('esxbalkan_mafije:JelPretrazivan', function(source, cb, target)
	if Pretrazivan[target] ~= nil then
		if Pretrazivan[target] then
			cb(true)
		else
			cb(false)
		end
	else
		cb(false)
	end
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

ESX.RegisterServerCallback('esxbalkan_mafije:dbGettajPuske', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local org = xPlayer.job.name
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. org, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:staviUoruzarnicu', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local org = xPlayer.job.name

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. org, function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:izvadiIzOruzarnice', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local org = xPlayer.job.name

	xPlayer.addWeapon(weaponName, 150)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. org, function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:kupiOruzje', function(source, cb, weaponName, type, componentNum)
	local xPlayer = ESX.GetPlayerFromId(source)
	local org = xPlayer.job.name
	local authorizedWeapons, selectedWeapon = Config.Oruzje[xPlayer.job.grade_name]

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('esxbalkan_mafije: %s je pokusao kupiti krivu pusku!'):format(xPlayer.identifier))
		xPlayer.kick('You have been kicked from this server for exploiting!')
		cb(false)
	else
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)

				cb(true)
			else
				cb(false)
			end
		elseif type == 2 then
			local price = selectedWeapon.components[componentNum]
			local weaponNum, weapon = ESX.GetWeapon(weaponName)
			local component = weapon.components[componentNum]

			if component then
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price)
					xPlayer.addWeaponComponent(weaponName, component.name)

					cb(true)
				else
					cb(false)
				end
			else
				print(('esxbalkan_mafije: %s je pokusao kupiti krivi dodatak.'):format(xPlayer.identifier))
				xPlayer.kick('You have been kicked from this server for exploiting!')
			end
		end
	end
end)
