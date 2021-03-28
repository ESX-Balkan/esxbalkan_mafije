ESX = nil
local nmafija,Pretrazivan = 0, {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(Config.Mafije) do
	TriggerEvent('esx_society:registerSociety', k, k, 'society_' .. k, 'society_'..k, 'society_'..k, {type = 'public'})
	nmafija = nmafija + 1
end

print('[^1esxbalkan_mafias^0]: Napravljeno od ^5ESX-Balkan^0 | Ucitano ^4' .. nmafija .. '^0 mafia')

function sendToDiscord3 (name,message)
local embeds = {
    {
        ["title"]=message,
        ["type"]="rich",
        ["color"] =2061822,
        ["footer"]=  {
        ["text"]= "ESX Balkan Mafije",
       },
    }
}

if message == nil or message == '' then return FALSE end
  PerformHttpRequest(Config.Webhuk, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

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
	local items = xPlayer.inventory
	cb({ items = items })
end)

RegisterNetEvent('esxbalkan_mafije:oduzmiItem')
AddEventHandler('esxbalkan_mafije:oduzmiItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
		
	if not targetXPlayer then
	   return
    end

	if not sourceXPlayer then
	   return
     end


	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		-- provera kolicine
		if targetItem.count > 0 and targetItem.count <= amount then
			-- da li moze da nosi stvari
			if Config.Limit and (sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit) then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			elseif not Config.Limit and not xPlayer.canCarryItem(sourceItem.name, sourceItem.limit) then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
				sendToDiscord3('Oduzeti Item', sourceXPlayer.name ..' je oduzeo stvar: '.. sourceItem.label.. ' od igraca ' ..targetXPlayer.name.. ' kolicine: ' ..amount)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)
		-- Dali igrac ima dovoljno novca kod sebe?
		if targetAccount.money >= amount then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)
		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
		sendToDiscord3('Oduzeti prljav novac', sourceXPlayer.name ..' je oduzeo prljav novac kolicine: $'.. amount ..' od igraca: ' ..targetXPlayer.name)
	else
		DropPlayer(_source, 'Dobar pokusaj da glichas retarde! Protected by ESX-Balkan :)')
	end
	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		-- dali ja vec posjedujem to oruzije jos kod sebe?
        if sourceXPlayer.hasWeapon(itemName) then
		-- dali igrac posjeduje to oruzije jos kod sebe?
		if targetXPlayer.hasWeapon(itemName) then
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)
		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
		sendToDiscord3('Oduzeto oruzije', sourceXPlayer.name ..' je oduzeo oruzije: '.. ESX.GetWeaponLabel(itemName) ..' od igraca: ' ..targetXPlayer.name.. ' kolicine metaka: ' ..amount)
	else
		DropPlayer(_source, 'Dobar pokusaj da glichas retarde! Protected by ESX-Balkan :)')
	end
	else
		TriggerClientEvent('esx:showNotification', _source, ('~y~Vec posjedujete to oruzije i ~r~imate kod sebe!'))
		end
	end
end)

RegisterNetEvent('esxbalkan_mafije:vezivanje')
AddEventHandler('esxbalkan_mafije:vezivanje', function(target)
    	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    	local drugijebeniigrac = ESX.GetPlayerFromId(target)
	for k,v in pairs(Config.Mafije) do
		if xPlayer.job.name == k then
        		if drugijebeniigrac then -- dali id ove osobe postoji?
				TriggerClientEvent('esxbalkan_mafije:vezivanje', target)
				return -- da ne bi doslo do DropPlayer()
        		end
        	end
    	end
	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
end)

RegisterNetEvent('esxbalkan_mafije:vuci')
AddEventHandler('esxbalkan_mafije:vuci', function(target)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local drugijebeniigrac = ESX.GetPlayerFromId(target)
	for k,v in pairs(Config.Mafije) do
	if xPlayer.job.name == k then
        if drugijebeniigrac then -- dali id ove osobe postoji?
		TriggerClientEvent('esxbalkan_mafije:vuci', target, src)
	else
		DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	    end
        else
         DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
        end
	end
end)

RegisterNetEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function(target)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local drugijebeniigrac = ESX.GetPlayerFromId(target)
	for k,v in pairs(Config.Mafije) do
	if xPlayer.job.name == k then
        if drugijebeniigrac then -- dali id ove osobe postoji?
		TriggerClientEvent('esxbalkan_mafije:staviUVozilo', target)
	else
		DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	   end
    else
        DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
        end
    end
end)

RegisterNetEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function(target)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local drugijebeniigrac = ESX.GetPlayerFromId(target)
	for k,v in pairs(Config.Mafije) do
	if xPlayer.job.name == k then
        if drugijebeniigrac then -- dali id ove osobe postoji?
		TriggerClientEvent('esxbalkan_mafije:staviVanVozila', target)
	else
		DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	  end
    else
        DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
        end
    end
end)

RegisterNetEvent('esxbalkan_mafije:poruka')
AddEventHandler('esxbalkan_mafije:poruka', function(target, msg)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    local drugijebeniigrac = ESX.GetPlayerFromId(target)
	for k,v in pairs(Config.Mafije) do
	if xPlayer.job.name == k then
        if drugijebeniigrac then -- dali id ove osobe postoji?
		TriggerClientEvent('esx:showNotification', target, msg)
	else
		DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	    end
    else
        DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
        end
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
		
	if not xPlayer.hasWeapon(weaponName) then
		xPlayer.kick('Ne glitchuj kidaro') -- ili log/ban kod
		return
	end

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

RegisterNetEvent('esxbalkan_mafije:getStockItem')
AddEventHandler('esxbalkan_mafije:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local org = xPlayer.job.name
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. org, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if Config.Limit and (sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit) then -- commit
			TriggerClientEvent('esx:showNotification', _source, _U('no_space'))
			return
		elseif not Config.Limit and not xPlayer.canCarryItem(sourceItem.name, sourceItem.count) then
			TriggerClientEvent('esx:showNotification', _source, _U('no_space'))
			return
		end

		if count > 0 and inventoryItem.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

RegisterNetEvent('esxbalkan_mafije:putStockItems')
AddEventHandler('esxbalkan_mafije:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local org = xPlayer.job.name
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. org, function(inventory)
		local inventoryItem = inventory.getItem(itemName)
		-- dali igrac ima dovoljno kod sebe?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:getajsveiteme', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local org = xPlayer.job.name
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. org, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:getajigracevinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory
	cb({items = items})
end)

if GetCurrentResourceName() ~= "esxbalkan_mafije" then
	print("                                             #")
	print("                                             ###")
	print("###### ###### ###### ###### ######  ##############")
	print("#      #    # #    # #    # #    #  ################    Promjeni '" .. GetCurrentResourceName() .. "' u 'esxbalkan_mafije'")
	print("###    ###### ###### #    # ######  ##################  ili ces dobiti DDOS i SKRIPTA NECE RADITI!")
	print("#      # ##   # ##   #    # # ##    ################    OSTAVI IME SKRIPTE KAKO JE DAJ REKLAMU NA ESX BALKANU !!!")
	print("###### #   ## #   ## ###### #   ##  ##############")
	print("                                             ###")
	print("                                             #")
        StopResource(GetCurrentResourceName())
	Wait(5000)
	os.exit(69) -- kresuj sve zivo, samo picke ce izbrisati ovaj kod gore
end
