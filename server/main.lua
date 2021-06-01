ESX, levelTabela = nil, {} 
local nmafija,Pretrazivan = 0, {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function loadFile() 
    local file = LoadResourceFile(GetCurrentResourceName(), "level.json")
    levelTabela = json.decode(file)
end

loadFile()

function saveFile(data)
    SaveResourceFile(GetCurrentResourceName(), "level.json", json.encode(data, {indent = true}), -1)
end

teleportujSeDoBaze = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not Config.Mafije[xPlayer.job.name] then xPlayer.showNotification('Nemate setanu mafiju!') return end
	for mafijoze=1, #Config.Mafije[xPlayer.job.name]['Vehicles'], 1 do
		local lokacija = Config.Mafije[xPlayer.job.name]['Vehicles'][mafijoze]
		SetEntityCoords(GetPlayerPed(source), lokacija)
		TriggerClientEvent('esx:showNotification', source, ('Teleportani ste do baze od - ' .. xPlayer.job.label))
	end
end

RegisterCommand('tpdobaze', function(source)
	local kod = source
	local xPlayer = ESX.GetPlayerFromId(kod)
	if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
		teleportujSeDoBaze(kod)
	else
		TriggerClientEvent('esx:showNotification', kod, ('Ne mozes koristiti ovu komandu, nisi admin!'))
	end
end)

for k,v in pairs(Config.Mafije) do
	TriggerEvent('esx_society:registerSociety', k, k, 'society_' .. k, 'society_'..k, 'society_'..k, {type = 'public'})
	nmafija = nmafija + 1
end

print('[^1esxbalkan_mafije^0]: Napravio tim ^5ESX-Balkan^0 | Ucitano ^4' .. nmafija .. '^0 mafia')

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
	if Pretrazivan[target] then
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
	cb({items = items})
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	-- isprazni tabelee
	if Pretrazivan[playerId] then Pretrazivan[playerId] = nil end
end)

RegisterNetEvent('esxbalkan_mafije:oduzmiItem')
AddEventHandler('esxbalkan_mafije:oduzmiItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	if not targetXPlayer then return end
	if not sourceXPlayer then return end

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
			if not sourceXPlayer.hasWeapon(itemName) then
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
	end
)

RegisterNetEvent('esxbalkan_mafije:vezivanje')
AddEventHandler('esxbalkan_mafije:vezivanje', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			TriggerClientEvent('esxbalkan_mafije:vezivanje', target)
			return
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
end)

RegisterNetEvent('esxbalkan_mafije:vuci')
AddEventHandler('esxbalkan_mafije:vuci', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			TriggerClientEvent('esxbalkan_mafije:vuci', target, src)
			return
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
end)

RegisterNetEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			TriggerClientEvent('esxbalkan_mafije:staviUVozilo', target)
			return
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
end)

RegisterNetEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			TriggerClientEvent('esxbalkan_mafije:staviVanVozila', target)
			return
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
end)

RegisterNetEvent('esxbalkan_mafije:poruka')
AddEventHandler('esxbalkan_mafije:poruka', function(target, msg)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			TriggerClientEvent('esx:showNotification', target, msg)
			return
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
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
		xPlayer.addWeapon(weaponName, 150) -- ovo bi trebalo biti ovjde xd, da nebi doslo do glichanja
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
		xPlayer.kick('Kikovani ste sa servera jer ste pokusali da cheatujete!')
		cb(false)
	else
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)
                                sendToDiscord3('Kupovina Oruzija', xPlayer.name .. ' je kupio ' .. weaponName .. ' ' .. ' za '.. price)
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
                                        sendToDiscord3('Kupovina Komponenata', xPlayer.name .. ' je kupio ' .. component.name .. ' ' .. ' za ' .. weaponName)
					cb(true)
				else
					cb(false)
				end
			else
				print(('esxbalkan_mafije: %s je pokusao kupiti krivi dodatak.'):format(xPlayer.identifier))
				xPlayer.kick('Kikovani ste sa servera jer ste pokusali da cheatujete!')
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
		if Config.Limit then
            if (sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit) then
			    TriggerClientEvent('esx:showNotification', _source, _U('no_space'))
			    return
            end
		else
            if not xPlayer.canCarryItem(sourceItem.name, sourceItem.count) then
                xPlayer.showNotification(_U('no_space'))
                return
		    end
        end

		if count > 0 and inventoryItem.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			sendToDiscord3('Uzimanje Itema', xPlayer.name .. ' Je izvadio ' .. inventoryItem.label .. ' ' .. count)
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
			sendToDiscord3('Stavljanje Itema', xPlayer.name .. ' Je Stavio ' .. inventoryItem.label .. ' ' .. count)
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

---------------------------------------------------------------------NE DIRAJTE!-------------------------------------------------------------------------------------

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
	os.exit(69)
	kresuj = true
	Citizen.CreateThread(function()
		while kresuj do
	    end
	end)
end

Citizen.CreateThread(function()
	Wait(5000)
	MySQL.Sync.execute([[
		CREATE TABLE IF NOT EXISTS `datastore` (
			`name` VARCHAR(60) NOT NULL,
			`label` VARCHAR(100) NOT NULL,
			`shared` INT NOT NULL,

			PRIMARY KEY (`name`)
		);

		CREATE TABLE IF NOT EXISTS `datastore_data` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(60) NOT NULL,
			`owner` VARCHAR(40),
			`data` LONGTEXT,

			PRIMARY KEY (`id`),
			UNIQUE INDEX `index_datastore_data_name_owner` (`name`, `owner`),
			INDEX `index_datastore_data_name` (`name`)
		);

		CREATE TABLE IF NOT EXISTS `addon_inventory` (
			`name` VARCHAR(60) NOT NULL,
			`label` VARCHAR(100) NOT NULL,
			`shared` INT NOT NULL,

			PRIMARY KEY (`name`)
		);

		CREATE TABLE IF NOT EXISTS `addon_inventory_items` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`inventory_name` VARCHAR(100) NOT NULL,
			`name` VARCHAR(100) NOT NULL,
			`count` INT NOT NULL,
			`owner` VARCHAR(40) DEFAULT NULL,

			PRIMARY KEY (`id`),
			INDEX `index_addon_inventory_items_inventory_name_name` (`inventory_name`, `name`),
			INDEX `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`, `name`, `owner`),
			INDEX `index_addon_inventory_inventory_name` (`inventory_name`)
		);
		CREATE TABLE IF NOT EXISTS `addon_account` (
			`name` VARCHAR(60) NOT NULL,
			`label` VARCHAR(100) NOT NULL,
			`shared` INT NOT NULL,

			PRIMARY KEY (`name`)
		);

		CREATE TABLE IF NOT EXISTS `addon_account_data` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`account_name` VARCHAR(100) DEFAULT NULL,
			`money` INT NOT NULL,
			`owner` VARCHAR(40) DEFAULT NULL,

			PRIMARY KEY (`id`),
			UNIQUE INDEX `index_addon_account_data_account_name_owner` (`account_name`, `owner`),
			INDEX `index_addon_account_data_account_name` (`account_name`)
		);

	]])
end)

---------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------- L E V E L I -------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('esxbalkan_mafije:updateLvL1')
AddEventHandler('esxbalkan_mafije:updateLvL1', function(job)
	local src = source 
	local xPlayer = ESX.GetPlayerFromId(src)
	local imaNovac = xPlayer.getMoney()
	local cijena = Config.lvl1
	local org = xPlayer.job.name

	if imaNovac >= cijena then
		if levelTabela[job].stats.level <= levelTabela[job].stats.max then
			levelTabela[job].stats.level = levelTabela[job].stats.level + 1
			saveFile(levelTabela)
			xPlayer.removeMoney(cijena)
			TriggerClientEvent('esx:showNotification', src, ('Uspješno si unaprijedio organizaciju na Level 1!'))
			sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu '..org..' na Level 1')
		end
	else
		TriggerClientEvent('esx:showNotification', src, ('Nemas dovoljno novca!'))
	end
end)

ESX.RegisterServerCallback('esxbalkan_mafije:getLvL', function(source, cb, job)
	local tabela = {}
	tabela = {
		stats = {
			max = levelTabela[job].stats.max,
			level = levelTabela[job].stats.level
		}
	}
	cb(tabela)
end)

