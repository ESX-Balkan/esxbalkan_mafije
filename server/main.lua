--[[
EEEEEEEEEEEEEEEEEEEEEE   SSSSSSSSSSSSSSS XXXXXXX       XXXXXXX     BBBBBBBBBBBBBBBBB               AAA               LLLLLLLLLLL             KKKKKKKKK    KKKKKKK               AAA               NNNNNNNN        NNNNNNNN
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
local nmafija, Pretrazivan = 0, {}
local getajresourcename = GetCurrentResourceName()
Vozila = {
    Izvucena = {}
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function loadFile()
    local file = LoadResourceFile(getajresourcename, "level.json")
    levelTabela = json.decode(file)
end

loadFile()

function saveFile(data)
    SaveResourceFile(getajresourcename, "level.json", json.encode(data, { indent = true }), -1)
end

teleportujSeDoBaze = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not Config.Mafije[xPlayer.job.name] then return TriggerClientEvent('esx:showNotification', source, ('Nemate setanu mafiju!')) end
    for mafijoze = 1, #Config.Mafije[xPlayer.job.name]['Vehicles'], 1 do
        local lokacija = Config.Mafije[xPlayer.job.name]['Vehicles'][mafijoze]
        SetEntityCoords(GetPlayerPed(source), lokacija)
        TriggerClientEvent('esx:showNotification', source, ('Teleportani ste do baze od - ' .. xPlayer.job.label))
    end
end

RegisterCommand('tpdobaze', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local grupa = xPlayer.getGroup()
	  if Config.Permisije[grupa] then
        teleportujSeDoBaze(source)
    else
        TriggerClientEvent('esx:showNotification', source, ('Ne mozete koristiti ovu komandu, niste admin!'))
    end
end)

if Config.OxInventory then
    for k, v in pairs(Config.Mafije) do
        exports.ox_inventory:RegisterStash('society_' .. k, 'society_' .. k, 50, 200000)
    end
end

for k, v in pairs(Config.Mafije) do
    TriggerEvent('esx_society:registerSociety', k, k, 'society_' .. k, 'society_' .. k, 'society_' .. k, { type = 'public' })
    nmafija = nmafija + 1
end

print('[^1esxbalkan_mafije^0]: Napravio tim ^5ESX-Balkan^0 | Ucitano ^4' .. nmafija .. '^0 mafia')

function sendToDiscord3(name, message)
    local embeds = {
        ["title"] = message,
        ["type"] = "rich",
        ["color"] = 2061822,
        ["footer"] = {
            ["text"] = "ESX Balkan Mafije",
        },
    }
    if message == nil or message == '' then return false end
    PerformHttpRequest(Config.Webhuk, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('esxbalkan_mafije:proveriVozila', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local posao = xPlayer.job.name
    if xPlayer and posao then
        if Vozila.Izvucena[posao] then
            cb(Vozila.Izvucena[posao])
        else
            Vozila.Izvucena[posao] = {}
            cb(Vozila.Izvucena[posao])
        end
    end
end)

RegisterNetEvent('esxbalkan_mafije:updateVozila')
AddEventHandler('esxbalkan_mafije:updateVozila', function(voziloID, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    local posao = xPlayer.job.name
    if state then
        insertuj(Vozila.Izvucena[posao], voziloID)
    else
        table.remove(Vozila.Izvucena[posao])
    end
end)

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

RegisterNetEvent('esxbalkan_mafije:oduzmiItem')
AddEventHandler('esxbalkan_mafije:oduzmiItem', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
    if not targetXPlayer then return end
    if not sourceXPlayer then return end
    local udaljenost = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target)))

    if udaljenost > 3 then
        TriggerClientEvent('esxbalkan_mafije:ugasiga', _source) -- ugasi sve menije..
        TriggerClientEvent('esx:showNotification', _source)
        return
    end

    if targetXPlayer ~= _source then -- jedan fix :)
        if itemType == 'item_standard' then
            local targetItem = targetXPlayer.getInventoryItem(itemName)
            local sourceItem = sourceXPlayer.getInventoryItem(itemName)
            -- provera kolicine
            if targetItem.count > 0 and targetItem.count <= amount then
                if targetItem.count ~= amount then
                    sourceXPlayer.kick('ESX-Balkan Protection | Anti-Glitch') -- fix glich?
                else
                    -- da li moze da nosi stvari
                    if Config.Limit then
                        if (sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit) then
                            TriggerClientEvent('esx:showNotification', _source, ('Nemate dovoljno prostora da nosite taj item'))
                        else
                            targetXPlayer.removeInventoryItem(itemName, amount)
                            sourceXPlayer.addInventoryItem(itemName, amount)
                            TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
                            TriggerClientEvent('esx:showNotification', target, _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
                            sendToDiscord3('Oduzeti Item', sourceXPlayer.name .. ' je oduzeo stvar: ' .. sourceItem.label .. ' od igraca ' .. targetXPlayer.name .. ' kolicine: ' .. amount)
                        end
                    else
                        if not sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
                            sourceXPlayer.showNotification('Nemate dovoljno prostora da nosite taj item')
                        else
                            targetXPlayer.removeInventoryItem(itemName, amount)
                            sourceXPlayer.addInventoryItem(itemName, amount)
                            TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
                            TriggerClientEvent('esx:showNotification', target, _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
                            sendToDiscord3('Oduzeti Item', sourceXPlayer.name .. ' je oduzeo stvar: ' .. sourceItem.label .. ' od igraca ' .. targetXPlayer.name .. ' kolicine: ' .. amount)
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
                sourceXPlayer.addAccountMoney(itemName, amount)
                TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
                TriggerClientEvent('esx:showNotification', target, _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
                sendToDiscord3('Oduzeti prljav novac', sourceXPlayer.name .. ' je oduzeo prljav novac kolicine: $' .. amount .. ' od igraca: ' .. targetXPlayer.name)
            else
                sourceXPlayer.kick('ESX-Balkan Protection | Anti-Glitch')
                print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da glicha!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
            end
        elseif itemType == 'item_weapon' then
            if amount == nil then amount = 0 end
            -- dali ja vec posjedujem to oruzje jos kod sebe?
            if not sourceXPlayer.hasWeapon(itemName) then
                -- dali igrac posjeduje to oruzje jos kod sebe?
                if targetXPlayer.hasWeapon(itemName) then
                    targetXPlayer.removeWeapon(itemName, amount)
                    sourceXPlayer.addWeapon(itemName, amount)
                    TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
                    TriggerClientEvent('esx:showNotification', target, _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
                    sendToDiscord3('Oduzeto oruzje', sourceXPlayer.name .. ' je oduzeo oruzje: ' .. ESX.GetWeaponLabel(itemName) .. ' od igraca: ' .. targetXPlayer.name .. ' kolicine metaka: ' .. amount)
                else
                    sourceXPlayer.kick('ESX-Balkan Protection | Anti-Glitch')
                    print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da glicha!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
                end
            else
                TriggerClientEvent('esx:showNotification', _source, ('Vec posjedujete to oruzje i ~r~imate kod sebe!'))
            end
        end
    else
        TriggerClientEvent('esx:showNotification', _source, ('~r~Ne mozete ~s~sam sebe pretraziti!'))
    end
end)

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
                    return TriggerClientEvent('esxbalkan_mafije:vezivanje', target)
                end
            end
        end
    end
    sendToDiscord3('Mafije Anticheat', xPlayer.name .. ' je cheater i pokusao je veze osobu preko cheata!')
    -- DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch') -- Iskljuceno za sada
    print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da zaveze osobu preko cheata!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
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
            if udaljenost < 8.0 then
                if src ~= target then
                    return TriggerClientEvent('esxbalkan_mafije:vuci', target, src)
                end
            end
        end
    end
    sendToDiscord3('Mafije Anticheat', xPlayer.name .. ' je cheater i pokusao je da vuce osobu preko cheata!')
    -- DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch') -- Iskljuceno za sada
    print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da vuce osobu preko cheata!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
end)

RegisterNetEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xJob = xPlayer.job
    local drugijebeniigrac = ESX.GetPlayerFromId(target)
    local udaljenost = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))
    local vozilonajblize = GetNajblizeVozilo(GetEntityCoords(GetPlayerPed(src)))
    local vozilozakljucan = GetVehicleDoorLockStatus(vozilonajblize)

    if vozilozakljucan ~= 2 then
        if xJob and Config.Mafije[xJob.name] then
            if drugijebeniigrac then -- dali id ove osobe postoji?
                if udaljenost < 8.0 then
                    if src ~= target then
                        return TriggerClientEvent('esxbalkan_mafije:staviUVozilo', target)
                    end
                end
            end
        end
        sendToDiscord3('Mafije Anticheat', xPlayer.name .. ' je cheater i pokusao je da stavi osobu u vozilu preko cheata!')
        -- DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch') -- Iskljuceno za sada
        print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da stavi osobu preko cheata!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
    else
        TriggerClientEvent('esx:showNotification', src, ('Ne mozete da stavite osobu u auto dok je auto zakljucano!'))
    end
end)

RegisterNetEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xJob = xPlayer.job
    local drugijebeniigrac = ESX.GetPlayerFromId(target)
    local udaljenost = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(target)))
    local vozilonajblize = GetNajblizeVozilo(GetEntityCoords(GetPlayerPed(src)))
    local vozilozakljucan = GetVehicleDoorLockStatus(vozilonajblize)
    local vozilo = GetVehiclePedIsIn(GetPlayerPed(target), false)
    if vozilo then
        if vozilozakljucan ~= 2 then
            if xJob and Config.Mafije[xJob.name] then
                if drugijebeniigrac then -- dali id ove osobe postoji?
                    if udaljenost < 8.0 then
                        if src ~= target then
                            TaskLeaveVehicle(GetPlayerPed(target), vozilo, 64)
                            return
                        end
                    end
                end
            end

        DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch')
        print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da izbaci osobu preko cheata!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
    else
        TriggerClientEvent('esx:showNotification', src, ('Ne mozete da izvadite osobu van auta jer je vozilo zakljucano!'))
    end
    else
        TriggerClientEvent('esx:showNotification', src, ('Osoba se ne nalazi u ni jednom vozilu!'))
    end
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
                return TriggerClientEvent('esx:showNotification', target, msg)
            end
        end
    end
    DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch')
    print(('[esxbalkan_mafije] [^3UPOZORENJE^7] %s ^1je pokusao da posalje svakome poruku preko cheata!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
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
        return xPlayer.kick('ESX-Balkan Protection | Anti-Glitch') -- ili log/ban kod
    end

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
        sendToDiscord3("Stavljanje oruzja", GetPlayerName(source) .. " " .. "je ostavio" .. " " .. ESX.GetWeaponLabel(weaponName) .. " sa 100 metaka" .. " u sef")
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. org, function(store)
        local weapons = store.get('weapons') or {}
        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            insertuj(weapons, {
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
        local weaponCount = nil

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weaponCount = weapons[i].count
                if (weapons[i].count > 0) then
                    foundWeapon = true
                    weapons[i].count = weapons[i].count - 1
                end
            end
        end

        if not foundWeapon and weaponCount == nil then
            insertuj(weapons, {
                name = weaponName,
                count = 0
            })
        end

        if foundWeapon then
            xPlayer.addWeapon(weaponName, 100)
            sendToDiscord3("Vadjenje oruzja", GetPlayerName(source) .. " " .. "je izvadio" .. " " .. ESX.GetWeaponLabel(weaponName) .. " sa 100 metaka" .. " iz sef")
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esxbalkan_mafije:kupiOruzje', function(source, cb, weaponName, type, componentNum)
    local xPlayer = ESX.GetPlayerFromId(source)
    local authorizedWeapons, selectedWeapon = Config.Oruzje[xPlayer.job.grade_name]

    for k, v in ipairs(authorizedWeapons) do
        if v.weapon == weaponName then
            selectedWeapon = v
            break
        end
    end

    if not selectedWeapon then
        print(('esxbalkan_mafije: %s je pokusao kupiti krivu pusku!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
        xPlayer.kick('ESX-Balkan Protection | Anti-Glitch')
        cb(false)
    else
        if type == 1 then
            if xPlayer.getMoney() >= selectedWeapon.price then
                xPlayer.removeMoney(selectedWeapon.price)
                xPlayer.addWeapon(weaponName, 100)
                sendToDiscord3('Kupovina oruzja', xPlayer.name .. ' je kupio ' .. ESX.GetWeaponLabel(weaponName) .. ' ' .. ' za ' .. selectedWeapon.price)
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
                print(('esxbalkan_mafije: %s je pokusao kupiti krivi dodatak.'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
                xPlayer.kick('ESX-Balkan Protection | Anti-Glitch')
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
    if Config.Mafije[org] then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' ..org, function(inventory)
            local inventoryItem = inventory.getItem(itemName)
            if Config.Limit then
                if (sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit) then
                    return TriggerClientEvent('esx:showNotification', _source, _U('no_space'))
                end
            else
                if not xPlayer.canCarryItem(sourceItem.name, sourceItem.count) then
                    return xPlayer.showNotification(_U('no_space'))
                end
            end

            if count > 0 and inventoryItem.count >= count then
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
                sendToDiscord3('Uzimanje Itema', xPlayer.name .. ' je izvadio ' .. inventoryItem.label .. ' ' .. count)
            else
                TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
            end
        end)
    else
        print(('esxbalkan_mafije: %s je da izvadi item iz org a nije u organizaciji!'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
        DropPlayer(_source, 'ESX-Balkan Protection | Anti-Glitch')
    end
end)

RegisterNetEvent('esxbalkan_mafije:putStockItems')
AddEventHandler('esxbalkan_mafije:putStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)
    local org = xPlayer.job.name
    if xPlayer then
        if Config.Mafije[org] then
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
        else
            print(('esxbalkan_mafije: %s je da stavi item u org a nije u organizaciji!.'):format(xPlayer.identifier..' | '..GetPlayerName(xPlayer.source)))
            DropPlayer(source, 'ESX-Balkan Protection | Anti-Glitch')
        end
    end
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
    cb({ items = items })
end)

---------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------- L E V E L I -------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('esxbalkan_mafije:updateLvL1')
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
                TriggerClientEvent('esx:showNotification', src, ('Uspješno ste unaprijedili organizaciju na Level 1!'))
                sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu ' .. org .. ' na Level 1')
            else
                TriggerClientEvent('esx:showNotification', src, ('Imate vec maksimalan level!'))
            end
        else
            TriggerClientEvent('esx:showNotification', src, ('Nemate dovoljno novca!'))
        end
    else
        DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch')
    end
end)

RegisterNetEvent('esxbalkan_mafije:updateLvL2')
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
                TriggerClientEvent('esx:showNotification', src, ('Uspješno ste unaprijedili organizaciju na Level 2!'))
                sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu ' .. org .. ' na Level 2')
            else
                TriggerClientEvent('esx:showNotification', src, ('Imate vec maksimalan level!'))
            end
        else
            TriggerClientEvent('esx:showNotification', src, ('Nemate dovoljno novca!'))
        end
    else
        DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch')
    end
end)

RegisterNetEvent('esxbalkan_mafije:updateLvL3')
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
                TriggerClientEvent('esx:showNotification', src, ('Uspješno ste unaprijedili organizaciju na Level 3!'))
                sendToDiscord3('Levelanje Baze', xPlayer.name .. ' je unaprijedio bazu ' .. org .. ' na Level 3')
            else
                TriggerClientEvent('esx:showNotification', src, ('Imate vec maksimalan level!'))
            end
        else
            TriggerClientEvent('esx:showNotification', src, ('Nemate dovoljno novca!'))
        end
    else
        DropPlayer(src, 'ESX-Balkan Protection | Anti-Glitch')
    end
end)

RegisterCommand('setlvl', function(source, args)
    job = args[1]
    level = tonumber(args[2])
    local xPlayer = ESX.GetPlayerFromId(source)
    local grupa = xPlayer.getGroup()
    if source == 0 or Config.Permisije[grupa] then
        if args[1] ~= nil and args[2] ~= nil then
            setLevel(job, level, broj)
            print("^5Mafija ^0" .. job .. "^5 je postavljena na level: ^7" .. level .. "")
            sendToDiscord3('Unapredjene Baze', xPlayer.name .. ' je postavio ' .. levelTabela[job].stats.level .. ' ' .. 'level na ' .. job)
        end
    else
        TriggerClientEvent('esx:showNotification', source, ('Ne mozete koristiti ovu komandu, niste admin!'))
    end
end)

setLevel = function(job, broj)
    levelTabela[job].stats.level = level
    saveFile(levelTabela)
    TriggerClientEvent('esxbalkan_mafije:updateHouse', -1, 'Mafija: ~r~' .. job .. '~s~je postavljena na level: ' .. levelTabela[job].stats.level)
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

local function getClosestEntity(entities, coords, modelFilter, isPed)
    local distance, closestEntity, closestCoords = maxDistance or 100, nil, nil
    coords = type(coords) == 'number' and GetEntityCoords(GetPlayerPed(coords)) or vector3(coords.x, coords.y, coords.z)

    for _, entity in pairs(entities) do
        if not isPed or (isPed and not IsPedAPlayer(entity)) then
            if not modelFilter or modelFilter[GetEntityModel(entity)] then
                local entityCoords = GetEntityCoords(entity)
                local dist = #(coords - entityCoords)
                if dist < distance then
                    closestEntity, distance, closestCoords = entity, dist, entityCoords
                end
            end
        end
    end
    return NetworkGetNetworkIdFromEntity(closestEntity), distance, closestCoords
end

function GetNajblizeVozilo(coords, modelFilter)
    return getClosestEntity(GetAllObjects(), coords, modelFilter)
end

CreateThread(function()
    -- Provjeri jeli startane ove skripte:
    while GetResourceState('esx_datastore') ~= 'started' do
        Wait(1000)
        print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA esx_datastore nije startana na serveru! Ukoliko vec imate tu skriptu, provjerite ime.')
    end
    while GetResourceState('esx_addonaccount') ~= 'started' do
        Wait(1000)
        print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA esx_addonaccount nije startana na serveru! Ukoliko vec imate tu skriptu, provjerite ime.')
    end
    while GetResourceState('esx_addoninventory') ~= 'started' do
        Wait(1000)
        print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA esx_addoninventory nije startana na serveru! Ukoliko vec imate tu skriptu, provjerite ime.')
    end
    while GetResourceState('esx_society') ~= 'started' do
        Wait(1000)
        print('ESX BALKAN MAFIJE ERROR, GRESKA: SKRIPTA esx_society nije startana na serveru! Ukoliko vec imate tu skriptu, provjerite ime.')
    end
    if GetResourceState('esx_society') == 'started' and GetResourceState('esx_datastore') == 'started' and GetResourceState('esx_addonaccount') == 'started' and GetResourceState('esx_addoninventory') == 'started' then
        print('[^1esxbalkan_mafije^0]: Uspjesno ucitane sve potrebne skripte!')
    end
end)

---------------------------------------------------------------------NE DIRAJTE!-------------------------------------------------------------------------------------
if Config.ProveraVerzije then
    function provjeraverzije()
        local verzija = GetResourceMetadata(GetCurrentResourceName(), 'version') -- proverava trenutnu verziju u fxmanifest
        PerformHttpRequest('https://api.github.com/repos/ESX-Balkan/esxbalkan_mafije/releases/latest',
            function(code, res, headers)
                if code == 200 then
                    local povuceno = json.decode(res)
                    local s = 'https://github.com/ESX-Balkan/esxbalkan_mafije/releases/latest'
                    if povuceno.tag_name ~= verzija then -- ako verzija povucena na githubu nije ista kao trenutna onda da baca ovo sranje da ga update
                        print("^0[^1Obavestenje^0] " .. GetCurrentResourceName() .. " koristi stariju verziju!")
                        print("^0[^1Obavestenje^0] Vasa verzija: ^2" .. verzija .. "^0")
                        print("^0[^1Obavestenje^0] Nova verzija: ^2" .. povuceno.tag_name .. "^0")
                        print("^0[^1Obavestenje^0] Preuzmite novu verziju: ^2" .. s .. "^0")
                    else
                        print("^3[esxbalkan_mafije] ^2Skripta koristi najnoviju verziju. Verzija: " .. (verzija) .. ".^7")
                    end
                end
            end, 'GET')
    end

    -- Provjerite verziju novu dok server radi..
    CreateThread(function()
        while 1 do
            provjeraverzije()
	    Wait(3600000)
        end
    end)
end

if getajresourcename ~= "esxbalkan_mafije" then
    print("                                             #")
    print("                                             ###")
    print("###### ###### ###### ###### ######  ##############")
    print("#      #    # #    # #    # #    #  ################    Promijenite '" ..
        getajresourcename .. "' u 'esxbalkan_mafije'")
    print("###    ###### ###### #    # ######  ##################  ili skripta nece raditi!")
    print("#      # ##   # ##   #    # # ##    ################    Ostavite ime skripte kako je i bilo.")
    print("###### #   ## #   ## ###### #   ##  ##############")
    print("                                             ###")
    print("                                             #")
    StopResource(getajresourcename)
    Wait(5000)
    os.exit(69)
    CreateThread(function()
        while 1 do
            -- Vazan dio skripte, ne dirajte!
        end
    end)
end
