--[[EEEEEEEEEEEEEEEEEEEEEE   SSSSSSSSSSSSSSS XXXXXXX       XXXXXXX     BBBBBBBBBBBBBBBBB           AAA               LLLLLLLLLLL             KKKKKKKKK    KKKKKKK               AAA               NNNNNNNN        NNNNNNNN
E::::::::::::::::::::E SS:::::::::::::::SX:::::X       X:::::X     B::::::::::::::::B             A:::A              L:::::::::L             K:::::::K    K:::::K              A:::A              N:::::::N       N::::::N
E::::::::::::::::::::ES:::::SSSSSS::::::SX:::::X       X:::::X     B::::::BBBBBB:::::B           A:::::A             L:::::::::L             K:::::::K    K:::::K             A:::::A             N::::::::N      N::::::N
EE::::::EEEEEEEEE::::ES:::::S     SSSSSSSX::::::X     X::::::X     BB:::::B     B:::::B         A:::::::A            LL:::::::LL             K:::::::K   K::::::K            A:::::::A            N:::::::::N     N::::::N
  E:::::E       EEEEEES:::::S            XXX:::::X   X:::::XXX       B::::B     B:::::B        A:::::::::A             L:::::L               KK::::::K  K:::::KKK           A:::::::::A           N::::::::::N    N::::::N
  E:::::E             S:::::S               X:::::X X:::::X          B::::B     B:::::B       A:::::A:::::A            L:::::L                 K:::::K K:::::K             A:::::A:::::A          N:::::::::::N   N::::::N
  E::::::EEEEEEEEEE    S::::SSSS             X:::::X:::::X           B::::BBBBBB:::::B       A:::::A A:::::A           L:::::L                 K::::::K:::::K             A:::::A A:::::A         N:::::::N::::N  N::::::N
  E:::::::::::::::E     SS::::::SSSSS         X:::::::::X            B:::::::::::::BB       A:::::A   A:::::A          L:::::L                 K:::::::::::K             A:::::A   A:::::A        N::::::N N::::N N::::::N
  E:::::::::::::::E       SSS::::::::SS       X:::::::::X            B::::BBBBBB:::::B     A:::::A     A:::::A         L:::::L                 K:::::::::::K            A:::::A     A:::::A       N::::::N  N::::N:::::::N
  E::::::EEEEEEEEEE          SSSSSS::::S     X:::::X:::::X           B::::B     B:::::B   A:::::AAAAAAAAA:::::A        L:::::L                 K::::::K:::::K          A:::::AAAAAAAAA:::::A      N::::::N   N:::::::::::N
  E:::::E                         S:::::S   X:::::X X:::::X          B::::B     B:::::B  A:::::::::::::::::::::A       L:::::L                 K:::::K K:::::K        A:::::::::::::::::::::A     N::::::N    N::::::::::N
  E:::::E       EEEEEE            S:::::SXXX:::::X   X:::::XXX       B::::B     B:::::B A:::::AAAAAAAAAAAAA:::::A      L:::::L         LLLLLLKK::::::K  K:::::KKK    A:::::AAAAAAAAAAAAA:::::A    N::::::N     N:::::::::N
EE::::::EEEEEEEE:::::ESSSSSSS     S:::::SX::::::X     X::::::X     BB:::::BBBBBB::::::BA:::::A             A:::::A   LL:::::::LLLLLLLLL:::::LK:::::::K   K::::::K   A:::::A             A:::::A   N::::::N      N::::::::N
E::::::::::::::::::::ES::::::SSSSSS:::::SX:::::X       X:::::X     B:::::::::::::::::BA:::::A               A:::::A  L::::::::::::::::::::::LK:::::::K    K:::::K  A:::::A               A:::::A  N::::::N       N:::::::N
E::::::::::::::::::::ES:::::::::::::::SS X:::::X       X:::::X     B::::::::::::::::BA:::::A                 A:::::A L::::::::::::::::::::::LK:::::::K    K:::::K A:::::A                 A:::::A N::::::N        N::::::N
EEEEEEEEEEEEEEEEEEEEEE SSSSSSSSSSSSSSS   XXXXXXX       XXXXXXX     BBBBBBBBBBBBBBBBBAAAAAAA                   AAAAAAALLLLLLLLLLLLLLLLLLLLLLLLKKKKKKKKK    KKKKKKKAAAAAAA                   AAAAAAANNNNNNNN         NNNNNNN
]]


ESX, levelTabela = nil, {}
local nmafija,Pretrazivan = 0, {}
local getajresourcename = GetCurrentResourceName()
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


CreateThread(function ()
    -- Provjeri jeli startane ove skripte:
    while GetResourceState('mysql-async') ~= 'started' do
        Citizen.Wait(1000)
	print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA mysql-async nije startana na serveru!!! ili ste promjenili ime skripte?')
    end
    while GetResourceState('esxbalkan_addoninventory') ~= 'started' do
        Citizen.Wait(1000)
	print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA esx_addoninventory nije startana na serveru!!! ili ste promjenili ime skripte?')
    end
    while GetResourceState('esxbalkan_society') ~= 'started' do
        Citizen.Wait(1000)
	print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA esx_society nije startana na serveru!!! ili ste promjenili ime skripte?')
    end
end)

function loadFile() 
    local file = LoadResourceFile(getajresourcename, "level.json")
    levelTabela = json.decode(file)
end

loadFile()

function saveFile(data)
    SaveResourceFile(getajresourcename, "level.json", json.encode(data, {indent = true}), -1)
end

teleportujSeDoBaze = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not Config.Mafije[xPlayer.job.name] then TriggerClientEvent('esx:showNotification', source, ('Nemate setanu mafiju!')) return end
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

print('[^3esxbalkan_mafije^0]: Napravio tim ^5ESX-Balkan^0 | Ucitano ^5' .. nmafija .. '^0 mafia')


function sendToDiscord3 (name,message)
local embeds = {{
	["title"]=message,
	["type"]="rich",
	["color"] =2061822,
	["footer"]=  {
	["text"]= "ESX Balkan Mafije",
},}}

if message == nil or message == '' then return FALSE end PerformHttpRequest(Config.Webhuk, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' }) end

ESX.RegisterServerCallback('esxbalkan_mafije:getOtherPlayerData', function(source, cb, target)
		local xPlayer = ESX.GetPlayerFromId(target)
		local data = {
			name = GetPlayerName(target),
			job  = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts = xPlayer.accounts,
			weapons = xPlayer.loadout
		}
		cb(data)
end)

RegisterNetEvent('esxbalkan_mafije:PretrazujuMe')
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
      if targetItem.count ~= amount then
         sourceXPlayer.kick('Dobar pokusaj da glichas retarde :)')
      else
         if Config.Limit then
            if (sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit) then
               TriggerClientEvent('esx:showNotification', _source, ('Nemate dovoljno prostora da nosite taj item'))
            else
               targetXPlayer.removeInventoryItem(itemName, amount)
               sourceXPlayer.addInventoryItem(itemName, amount)
               TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
               TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
               sendToDiscord3('Oduzeti Item', sourceXPlayer.name ..' je oduzeo stvar: '.. sourceItem.label.. ' od igraca ' ..targetXPlayer.name.. ' kolicine: ' ..amount)
            end
         else
            if not sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
               sourceXPlayer.showNotification('Nemate dovoljno prostora da nosite taj item')
            else
               targetXPlayer.removeInventoryItem(itemName, amount)
               sourceXPlayer.addInventoryItem(itemName, amount)
               TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
               TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
               sendToDiscord3('Oduzeti Item', sourceXPlayer.name ..' je oduzeo stvar: '.. sourceItem.label.. ' od igraca ' ..targetXPlayer.name.. ' kolicine: ' ..amount)
            end
         end
      end
   else
      TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
   end
elseif itemType == 'item_account' then
   local targetAccount = targetXPlayer.getAccount(itemName)
   -- Dali igrac ima dovoljno novca kod sebe?
   if targetAccount.money >= amount then
      targetXPlayer.removeAccountMoney(itemName, amount)
      sourceXPlayer.addAccountMoney (itemName, amount)
      TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
      TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
      sendToDiscord3('Oduzeti prljav novac', sourceXPlayer.name ..' je oduzeo prljav novac kolicine: $'.. amount ..' od igraca: ' ..targetXPlayer.name)
   else
      sourceXPlayer.kick('Dobar pokusaj da glichas retarde! Protected by ESX-Balkan :)')
      print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da glicha!'):format(xPlayer.identifier))
   end
elseif itemType == 'item_weapon' then
   if amount == nil then amount = 0 end
   -- dali ja vec posjedujem to oruzije jos kod sebe?
   if not sourceXPlayer.hasWeapon(itemName) then
      -- dali igrac posjeduje to oruzije jos kod sebe?
      if targetXPlayer.hasWeapon(itemName) then
         targetXPlayer.removeWeapon(itemName, amount)
         sourceXPlayer.addWeapon (itemName, amount)
         TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
         TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
         sendToDiscord3('Oduzeto oruzije', sourceXPlayer.name ..' je oduzeo oruzije: '.. ESX.GetWeaponLabel(itemName) ..' od igraca: ' ..targetXPlayer.name.. ' kolicine metaka: ' ..amount)
      else
         sourceXPlayer.kick('Dobar pokusaj da glichas retarde! Protected by ESX-Balkan :)')
         print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da glicha!'):format(xPlayer.identifier))
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
	local udaljenost = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			if udaljenost < 8.0 then
				if src ~= target then
					TriggerClientEvent('esxbalkan_mafije:vezivanje', target)
					return
				end
			end
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :) Protected by ESX-BALKAN Mafije')
	print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da zaveze osobu preko cheata!'):format(xPlayer.identifier))
end)

RegisterNetEvent('esxbalkan_mafije:vuci')
AddEventHandler('esxbalkan_mafije:vuci', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)
	local udaljenost = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			if src ~= target then
				TriggerClientEvent('esxbalkan_mafije:vuci', target, src)
				return
			end
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da vuce osobu preko cheata!'):format(xPlayer.identifier))
end)

RegisterNetEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)
	local udaljenost = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			if udaljenost < 8.0 then
				if src ~= target then
					TriggerClientEvent('esxbalkan_mafije:staviUVozilo', target)
					return
				end
			end
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da stavi osobu preko cheata!'):format(xPlayer.identifier))
end)

RegisterNetEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function(target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)
	local udaljenost = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			if udaljenost < 8.0 then
				if src ~= target then
					TriggerClientEvent('esxbalkan_mafije:staviVanVozila', target)
					return
				end
			end
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da izbaci osobu preko cheata!'):format(xPlayer.identifier))
end)

RegisterNetEvent('esxbalkan_mafije:poruka')
AddEventHandler('esxbalkan_mafije:poruka', function(target, msg)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xJob = xPlayer.job
	local drugijebeniigrac = ESX.GetPlayerFromId(target)

	if xJob and Config.Mafije[xJob.name] then
		if drugijebeniigrac then -- dali id ove osobe postoji?
			if src ~= target then
				TriggerClientEvent('esx:showNotification', target, msg)
				return
			end
		end
	end

	DropPlayer(src, 'Zasto pokusavas da citujes. Nije lepo to :)')
	print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da posalje svakome poruku preko cheata!'):format(xPlayer.identifier))
end)

ESX.RegisterServerCallback('esxbalkan_mafije:dbGettajPuske', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local org = xPlayer.job.name
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. org, function(store)
		local weapons = store.get('weapons')
		if weapons == nil then weapons = {} end
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
		sendToDiscord3("Stavljanje oruzija", GetPlayerName(source).. " ".. "je ostavio".. " ".. ESX.GetWeaponLabel(weaponName).. " sa 100 metaka".. " u sef")
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
	xPlayer.addWeapon(weaponName, 100)
	sendToDiscord3("Vadjenje oruzija", GetPlayerName(source).. " ".. "je izvadio".. " ".. ESX.GetWeaponLabel(weaponName).. " sa 250 metaka".. " iz sef")
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
		xPlayer.kick('Kikovani ste sa servera jer ste pokusali da cheatujete!')
		cb(false)
	else
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addWeapon(weaponName, 100)
				sendToDiscord3('Kupovina Oruzija', xPlayer.name .. ' je kupio ' .. ESX.GetWeaponLabel(weaponName) .. ' ' .. ' za '.. selectedWeapon.price)
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
					sendToDiscord3('Kupovina Komponenata', xPlayer.name .. ' je kupio ' .. component.name .. ' ' .. ' za ' .. ESX.GetWeaponLabel(weaponName))
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
    local xJob = xPlayer.job

    if xJob and Config.Mafije[xJob.name] then
        if imaNovac >= cijena then
            if levelTabela[job].stats.level <= levelTabela[job].stats.max then
                levelTabela[job].stats.level = levelTabela[job].stats.level + 1
                saveFile(levelTabela)
                xPlayer.removeMoney(cijena)
                TriggerClientEvent('esx:showNotification', src, ('Uspješno si unaprijedio organizaciju na Level 1!'))
                sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu '..org..' na Level 1')
            else
                TriggerClientEvent('esx:showNotification', src, ('Imate vec maksimalan level!'))
            end
        else
            TriggerClientEvent('esx:showNotification', src, ('Nemas dovoljno novca!'))
        end
    else
        DropPlayer(src, '(:')
    end
end)

RegisterServerEvent('esxbalkan_mafije:updateLvL2')
AddEventHandler('esxbalkan_mafije:updateLvL2', function(job)
	local src = source 
	local xPlayer = ESX.GetPlayerFromId(src)
	local imaNovac = xPlayer.getMoney()
	local cijena = Config.lvl2
	local org = xPlayer.job.name
    local xJob = xPlayer.job

    if xJob and Config.Mafije[xJob.name] then
        if imaNovac >= cijena then
            if levelTabela[job].stats.level <= levelTabela[job].stats.max then
                levelTabela[job].stats.level = levelTabela[job].stats.level + 1
                saveFile(levelTabela)
                xPlayer.removeMoney(cijena)
                TriggerClientEvent('esx:showNotification', src, ('Uspješno si unaprijedio organizaciju na Level 2!'))
                sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu '..org..' na Level 2')
            else
                TriggerClientEvent('esx:showNotification', src, ('Imate vec maksimalan level!'))
            end
        else
            TriggerClientEvent('esx:showNotification', src, ('Nemas dovoljno novca!'))
        end
    else
        DropPlayer(src, '(:')
    end
end)

RegisterServerEvent('esxbalkan_mafije:updateLvL3')
AddEventHandler('esxbalkan_mafije:updateLvL3', function(job)
	local src = source 
	local xPlayer = ESX.GetPlayerFromId(src)
	local imaNovac = xPlayer.getMoney()
	local cijena = Config.lvl3
	local org = xPlayer.job.name
    local xJob = xPlayer.job

    if xJob and Config.Mafije[xJob.name] then
        if imaNovac >= cijena then
            if levelTabela[job].stats.level <= levelTabela[job].stats.max then
                levelTabela[job].stats.level = levelTabela[job].stats.level + 1
                saveFile(levelTabela)
                xPlayer.removeMoney(cijena)
                TriggerClientEvent('esx:showNotification', src, ('Uspješno si unaprijedio organizaciju na Level 3!'))
                sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu '..org..' na Level 3')
            else
                TriggerClientEvent('esx:showNotification', src, ('Imate vec maksimalan level!'))
            end
        else
            TriggerClientEvent('esx:showNotification', src, ('Nemas dovoljno novca!'))
        end
    else
        DropPlayer(src, '(:')
    end
end)

RegisterCommand('setlvl', function(source, args)
	job = args[1]
	level = tonumber(args[2])
	local xPlayer = ESX.GetPlayerFromId(source)
	if source == 0 or xPlayer.getGroup() == "superadmin" then
		if args[1] ~= nil and args[2] ~= nil then 
			setLevel(job, level, broj)	
			print("^5Mafija ^0" ..job.. "^5 je unapredjena na level: ^7" ..level.. "")
                        sendToDiscord3('Unapredjene Baze',  xPlayer.name ..' je postavio ' .. levelTabela[job].stats.level .. ' ' .. 'level na '  .. job )
		end
	else
		TriggerClientEvent('esx:showNotification', source, ('Ne mozes koristiti ovu komandu, nisi admin!'))
	end
end)


setLevel = function(job, broj)
	levelTabela[job].stats.level = level
	saveFile(levelTabela)
	TriggerClientEvent('esxbalkan_mafije:updateHouse', -1, 'Gang: ~r~'..job..'~s~\nWas set to level: '..levelTabela[job].stats.level)
end

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



function getAccounts(data, xPlayer)
	local result = {}
	for i=1, #data do
		if(data[i] ~= 'money') then
			if(data[i] == 'black_money') then
				result[i] = nil
			else
				result[i] = xPlayer.getAccount(data[i])['money']
			end

		else
			result[i] = xPlayer.getMoney()
		end
	end
	return result
end

function tableIncludes(table, data)
	for _,v in pairs(table) do
		if v == data then
			return true
		end
	end
	return false
end

local permisije = {
	'boss'
}

ESX.RegisterServerCallback('begijanes', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local money,bank,black_money = table.unpack(getAccounts({'money', 'bank', 'black_money'}, xPlayer))

		local society = nil
		if tableIncludes(permisije, xPlayer.job.grade_name) then
			TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(data)
				if data ~= nil then
					TriggerEvent('esx_addonaccount:getSharedAccount', data.account, function(account)
							society = account['money']
					end)
				end
			end)
		end
	  cb({cash = money, bank = bank, society = society})
	end
end)

local JobGrades = {}
ESX.RegisterServerCallback('esx_society:setJobById', function(source, cb, id, job, grade)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'
	local xTarget = ESX.GetPlayerFromId(id)
	if isBoss then
		if xTarget then
		    if xTarget.getJob().name ~= xPlayer.getJob().name then
		    	if xTarget.getJob().name == 'unemployed' then
		    		xTarget.setJob(job, grade)
					xTarget.showNotification('Dobili ste novi posao!')
					xPlayer.showNotification('Dodali ste clana u organizaciji!')
					local sql = string.format(
						"UPDATE users SET job = '%s', job_grade = 0 WHERE identifier = '%s'",job, ident
					)
						MySQL.Sync.execute(sql, {})
		    	else
					xPlayer.showNotification('Taj igrac je u nekoj drugoj organizaciji')
		    	end
			else
				xPlayer.showNotification('Taj igrac je vec u vasoj organizaciji')
			end
		else
			xPlayer.showNotification('Unijeli ste pogresan ID igraca')
		end
	end
end)

RegisterNetEvent("esx_society:otpustiClana", function(ident)
	local srcPlayer = ESX.GetPlayerFromIdentifier(ident)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getIdentifier() == ident then
	   TriggerClientEvent('esx:showNotification', source, 'Ne mozes sebi dati otkaz')
	else
	if srcPlayer then
		srcPlayer.setJob("unemployed", 0)
		local sql = string.format(
			"UPDATE users SET job = 'unemployed', job_grade = 0 WHERE identifier = '%s'", ident
		)
			MySQL.Sync.execute(sql, {})
	else
		local sql = string.format(
			"UPDATE users SET job = 'unemployed', job_grade = 0 WHERE identifier = '%s'", ident
		)

			MySQL.Sync.execute(sql, {})
			print("do si otkaz frajeru sa identifierom "..ident)
	end
end
end)


RegisterNetEvent("esx_society:downgradexd", function(ident, nowGrade)

	local srcPlayer = ESX.GetPlayerFromIdentifier(ident)
	local xPlayer = ESX.GetPlayerFromId(source)
   if nowGrade == 0 then
	TriggerClientEvent('esx:showNotification', source, 'Clan trenutno ima najmanji rank')
   else
	    if srcPlayer then
	    	if (srcPlayer.getJob().grade - 1) >= 0 then
	    		srcPlayer.setJob(srcPlayer.getJob().name, srcPlayer.getJob().grade - 1)
    
	    		local sql = string.format(
	    			"UPDATE users SET job_grade = job_grade - 1 WHERE identifier = '%s'", ident
	    		)
    
	    		MySQL.Sync.execute(sql, {})
	    	end
	    else
	    		local sql = string.format(
	    			"UPDATE users SET job_grade = job_grade - 1 WHERE identifier = '%s'", ident
	    		)
    
	    		MySQL.Sync.execute(sql, {})
	    end
	end
end)


ESX.RegisterServerCallback('esx_society:downgradelal', function(source, cb, identifier, job, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isBoss = xPlayer.job.grade_name == 'boss'

    if isBoss then
        if not Jobs[job] then print("job ne postoji") return end
        if not Jobs[job][grade] then print("job_grade ne postoji") return end

        local xTarget = ESX.GetPlayerFromIdentifier(identifier)
        if xTarget then
            xTarget.setJob(job, grade)

            if type == 'hire' then
                xTarget.showNotification(_U('you_have_been_hired', job))
            elseif type == 'promote' then
                xTarget.showNotification(_U('you_have_been_promoted'))
            elseif type == 'fire' then
                xTarget.showNotification(_U('you_have_been_fired', xTarget.getJob().label))
            end

            cb()
        else
            MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                ['@job']        = job,
                ['@job_grade']  = grade,
                ['@identifier'] = identifier
            }, function(rowsChanged)
                cb()
            end)
        end
    else
        print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
        cb()
    end
end)



RegisterNetEvent("esx_society:unaprijediClana", function(ident, grade)

	local maxGrade = -1
	local nowGrade = tonumber(grade)

	local aPlayer = ESX.GetPlayerFromIdentifier(ident)
	local xPlayer = ESX.GetPlayerFromId(source)

	if nowGrade == 3 then
		TriggerClientEvent('esx:showNotification', source, 'Maksimalan rank je Sef')
	else
	    if aPlayer then
	    		aPlayer.setJob(aPlayer.getJob().name, nowGrade + 1)
    
	    		local sql = string.format(
	    			"UPDATE users SET job_grade = job_grade + 1 WHERE identifier = '%s'", ident
	    		)
    
	    			MySQL.Sync.execute(sql, {})
	    else
	    		local sql = string.format(
	    			"UPDATE users SET job_grade = job_grade + 1 WHERE identifier = '%s'", ident
	    		)
    
	    			MySQL.Sync.execute(sql, {})
	    end
	end
end)

---------------------------------------------------------------------NE DIRAJTE!-------------------------------------------------------------------------------------

if getajresourcename ~= "esxbalkan_mafije" then
	print("                                             #")
	print("                                             ###")
	print("###### ###### ###### ###### ######  ##############")
	print("#      #    # #    # #    # #    #  ################    Promjeni '" .. getajresourcename .. "' u 'esxbalkan_mafije'")
	print("###    ###### ###### #    # ######  ##################  ili ces dobiti DDOS i SKRIPTA NECE RADITI!")
	print("#      # ##   # ##   #    # # ##    ################    OSTAVI IME SKRIPTE KAKO JE DAJ REKLAMU NA ESX BALKANU !!!")
	print("###### #   ## #   ## ###### #   ##  ##############")
	print("                                             ###")
	print("                                             #")
	StopResource(getajresourcename)
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
