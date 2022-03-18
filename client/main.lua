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


local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles, levelTabela = {}, {}, {}, {}, {}, {}, {}, nil
local HasAlreadyEnteredMarker, isDead, isHandcuffed, Pretrazivan = false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
ESX = nil

CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(250) end
	while ESX.GetPlayerData().job == nil do Wait(250) end
	PlayerData = ESX.GetPlayerData()
	Wait(1000)
	getajLevel()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	levelTabela = nil
	PlayerData.job = job
	getajLevel()
end)

ocistiIgraca = function(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

RegisterNetEvent('esxbalkan_mafije:updateHouse')
AddEventHandler('esxbalkan_mafije:updateHouse', function(text)
	getajLevel()
	ESX.ShowNotification(text)
end)

getajLevel = function ()
	if Config.Levelanje then
		if Config.Mafije[PlayerData.job.name] ~= nil then
			ESX.TriggerServerCallback('esxbalkan_mafije:getLvL', function(data)
				levelTabela = data 
			end, PlayerData.job.name)
		end
	end
end

function LvL()
	local elements = {}
	if Config.Levelanje then 
		if levelTabela.stats.level == 0 then 
			table.insert(elements, { label = 'Level 1 (25 000$)', value = 'lvl1' })		
		elseif levelTabela.stats.level == 1 then 
			table.insert(elements, { label = 'Level 2 (50 000$)', value = 'lvl2' })		
        	elseif levelTabela.stats.level == 2 then
            		table.insert(elements, { label = 'Level 3 (75 000$)', value = 'lvl3' })
       		 end
    	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lvl', {
		title    = 'Odaberi level',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'lvl1' then
			TriggerServerEvent("esxbalkan_mafije:updateLvL1", PlayerData.job.name)
			menu.close()
			getajLevel()
		end
	if data.current.value == 'lvl2' then
		TriggerServerEvent("esxbalkan_mafije:updateLvL2", PlayerData.job.name)
		menu.close()
		getajLevel()
	end
	if data.current.value == 'lvl3' then
		TriggerServerEvent("esxbalkan_mafije:updateLvL3", PlayerData.job.name)
		menu.close()
		getajLevel()
	end
  end, function(data, menu)
    menu.close()
	end)
end

--Sef Menu --
function OpenArmoryMenu(station)
	local elements = {}
	if PlayerData.job.grade_name == 'boss' and Config.Levelanje then table.insert(elements, {label = 'Levelanje Baze | 💼', value = 'level'}) end 
	if Config.Levelanje then
		if levelTabela.stats.level  == 1 then
			--table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
			--table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
			table.insert(elements, {label = _U('remove_object'),value = 'get_stock'})
			table.insert(elements, {label = _U('deposit_object'),value = 'put_stock'})
		elseif levelTabela.stats.level == 2 then 
			--table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
			--table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
			table.insert(elements, {label = _U('remove_object'),value = 'get_stock'})
			table.insert(elements, {label = _U('deposit_object'),value = 'put_stock'})
			table.insert(elements, {label = _U('buy_weapons'),value = 'buy_weapons'})
        	elseif levelTabela.stats.level == 3 then
           	--	table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
            --		table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
            		table.insert(elements, {label = _U('remove_object'),value = 'get_stock'})
            		table.insert(elements, {label = _U('deposit_object'),value = 'put_stock'})
            		--table.insert(elements, {label = _U('buy_weapons'),value = 'buy_weapons'})
            		table.insert(elements, {label = 'Uzimanje Pancira | 💣',value = 'pancir'})
        	end
   	 else
        --	table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
        --	table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
        	table.insert(elements, {label = _U('remove_object'),value = 'get_stock'})
        	table.insert(elements, {label = _U('deposit_object'),value = 'put_stock'})
        	--table.insert(elements, {label = _U('buy_weapons'),value = 'buy_weapons'})
        	table.insert(elements, {label = 'Uzimanje Pancira | 💣',value = 'pancir'})
	end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title = _U('armory'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if data.current.value == 'get_weapon' then
	    if closestPlayer ~= -1 and closestDistance > 3.5 then
                OpenGetWeaponMenu()
            elseif GetNumberOfPlayers() == 1 then
                OpenGetWeaponMenu()
            else
                ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
            end
        elseif data.current.value == 'put_weapon' then
            if closestPlayer ~= -1 and closestDistance > 3.5 then
                OpenPutWeaponMenu()
            elseif GetNumberOfPlayers() == 1 then
                OpenPutWeaponMenu()
            else
                ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
            end
		elseif data.current.value == 'put_stock' then
            if closestPlayer ~= -1 and closestDistance > 3.0 then
                OpenPutStocksMenu()
            elseif GetNumberOfPlayers() == 1 then
                OpenPutStocksMenu()
            else
                ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
            end
		elseif data.current.value == 'get_stock' then
            if closestPlayer ~= -1 and closestDistance > 3.0 then
                OpenGetStocksMenu()
            elseif GetNumberOfPlayers() == 1 then
                OpenGetStocksMenu()
            else
                ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
            end
        elseif data.current.value == 'buy_weapons' then
            OpenBuyWeaponsMenu()
        elseif data.current.value == 'pancir' then
            SetPedArmour(PlayerPedId(), 100)
	elseif data.current.value == 'level' then
	     LvL()
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_armory'
        CurrentActionMsg = _U('open_armory')
        CurrentActionData = {station = station}
    end)
end
StvoriVozilo = function(vozilo)
	local ped = PlayerPedId()
	ESX.Game.SpawnVehicle(vozilo, Config.Mafije[PlayerData.job.name]["Vehicles"][1], GetEntityHeading(ped), function(veh)
		NetworkFadeInEntity(veh, true, true)
		SetVehicleEngineOn(veh, true, true, false)
		SetModelAsNoLongerNeeded(veh)  -- oslobodi memoryu :)
		TaskWarpPedIntoVehicle(ped, veh, -1)
		SetVehicleFuelLevel(veh, 100.0)
		SetVehicleOilLevel(veh, 10.0) -- eto da ima full ulje, ne znam jeli ovo ista znaci :)
		DecorSetFloat(veh, "_FUEL_LEVEL", GetVehicleFuelLevel(veh))
	end)
end

ObrisiVozilo = function()
	local playerPed = PlayerPedId()
	local vozilo =GetVehiclePedIsIn(playerPed,false)
	local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
	local vehicleSpeed = math.floor((GetEntitySpeed(GetVehiclePedIsIn(playerPed, false))*3.6))
	if (vehicleSpeed > 45) then FreezeEntityPosition(vozilo, true) end
	TaskLeaveVehicle(playerPed, vozilo, 0)
	while IsPedInVehicle(playerPed, vozilo, true) do Wait(0) end
	Citizen.Wait(500)
	NetworkFadeOutEntity(vozilo, true, true)
	Citizen.Wait(100)
	ESX.Game.DeleteVehicle(vozilo)
	ESX.ShowNotification("Uspiješno si parkirao ~b~vozilo~s~ u garažu.")
end

OtvoriAutoSpawnMenu = function(type, station, part, partNum)
    local elements = {}

    for model, label in pairs(Config.Mafije[PlayerData.job.name]["MeniVozila"]) do
    	table.insert(elements, {label = '🚗 | ' .. label, value = model})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni',{
        title = 'Izaberi Vozilo | 🚗',
        align = 'left',
        elements = elements
    },function(data, menu)
	StvoriVozilo(data.current.value)
        menu.close()
    end,

    function(data, menu)
        menu.close()
	CurrentAction = 'menu_vehicle_spawner' --commit
	CurrentActionMsg = _U('garage_prompt')
	CurrentActionData = {}
    end)
end

OtvoriHeliSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni',{
        	css      = 'vagos',
            title    = 'Izaberi Vozilo | 🚗',
            elements = {
            	{label = 'Heli | 🚗', value = 'fxho'},
		{label = 'Heli2 | 🚗', value = 'seashark'},
            }},function(data, menu)
            local playerPed = PlayerPedId()
            if data.current.value == 'fxho' then
				ESX.Game.SpawnVehicle("supervolito2", vector3(-2320.86, -658.25, 13.48), 266.92, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleEngineOn(vehicle, true, true, false)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
               			SetVehicleFuelLevel(vehicle, 100.0)
				DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))

				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seashark' then
				ESX.Game.SpawnVehicle("seasparrow", vector3(-2320.86, -658.25, 13.48), 266.92, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleEngineOn(vehicle, true, true, false)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                		SetVehicleFuelLevel(vehicle, 100.0)
				DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

OtvoriBrodSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni',{
            title    = 'Izaberi Vozilo | 🚗',
            elements = {
            	{label = 'JetSkki | 🚗', value = 'fxho'},
		{label = 'Jahta | 🚗', value = 'seashark'},
            }},function(data, menu)
        	local playerPed = PlayerPedId()
            if data.current.value == 'fxho' then
				ESX.Game.SpawnVehicle("fxho", vector3(-2273.91, -662.05, 0.5),  159.25, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleEngineOn(vehicle, true, true, false)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                		SetVehicleFuelLevel(vehicle, 100.0)
				DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seashark' then
				ESX.Game.SpawnVehicle("yacht2", vector3(-2273.91, -662.05, 0.5),  159.25, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleEngineOn(vehicle, true, true, false)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
               			SetVehicleFuelLevel(vehicle, 100.0)
				DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

OtvoriPosaoMenu = function()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'panteri_actions', {
		title = 'Mafija Meni | 🎩',
		align  = 'top-left',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'), value = 'body_search'},
				{label = _U('handcuff'), value = 'handcuff'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css  = 'vagos',
				title = _U('citizen_interaction'),
				align = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value
					if action == 'body_search' then
						ESX.TriggerServerCallback('esxbalkan_mafije:JelPretrazivan', function(br)
							if not br then
						TriggerServerEvent('esxbalkan_mafije:poruka', GetPlayerServerId(closestPlayer), _U('being_searched'))
						PretrazivanjeIgraca(closestPlayer)
						else
							ESX.ShowNotification("~y~Tu osobu vec ~r~netko pretrazuje!")
						end
					end)
					elseif action == 'handcuff' then
						TriggerServerEvent('esxbalkan_mafije:vezivanje', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esxbalkan_mafije:vuci', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esxbalkan_mafije:staviUVozilo', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esxbalkan_mafije:staviVanVozila', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

PretrazivanjeIgraca = function(player)
	ESX.TriggerServerCallback('esxbalkan_mafije:getOtherPlayerData', function(data)
		TriggerServerEvent("esxbalkan_mafije:PretrazujuMe", GetPlayerServerId(player), true)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value  = 'black_money',
					itemType = 'item_account',
					amount = data.accounts[i].money
				})

				break
			end
		end

		-- table.insert(elements, {label = _U('guns_label')})

		-- for i=1, #data.weapons, 1 do
		-- 	table.insert(elements, {
		-- 		label = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
		-- 		value = data.weapons[i].name,
		-- 		itemType = 'item_weapon',
		-- 		amount = data.weapons[i].ammo
		-- 	})
		-- end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			css  = 'vagos',
			title = _U('search'),
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				local najbliziigrac, distancenajblizi = ESX.Game.GetClosestPlayer()
				local pretrazenigrac = GetPlayerPed(najbliziigrac)
				if najbliziigrac ~= -1 and distancenajblizi < 2.5 then -- fixan bug sitni :)
					TriggerServerEvent('esxbalkan_mafije:oduzmiItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
					PretrazivanjeIgraca(player)
				else
					ESX.ShowNotification('~y~Ne mozete oduzeti stvari jer ste se ~r~udaljili mnogo')
					TriggerServerEvent("esxbalkan_mafije:PretrazujuMe", GetPlayerServerId(player), false)
					ESX.UI.Menu.CloseAll()-- ugasi sve menije
				end
			end
		end, function(data, menu)
			TriggerServerEvent("esxbalkan_mafije:PretrazujuMe", GetPlayerServerId(player), false)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

-----------------------------
---------EVENTOVI------------
-----------------------------
AddEventHandler('esxbalkan_mafije:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helikopter' then
		CurrentAction  = 'Helikopter'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Brodovi' then
		CurrentAction  = 'Brodovi'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif part == 'ParkirajAuto' then
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'ParkirajAuto'
			CurrentActionMsg  = 'Pritisnite ~INPUT_CONTEXT~ da ~b~parkirate~s~ vozilo u garažu.'
			CurrentActionData = { vehicle = vehicle }
		end
	end
end)

AddEventHandler('esxbalkan_mafije:hasExitedMarker', function(station, part, partNum)
    ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esxbalkan_mafije:vezivanje')
AddEventHandler('esxbalkan_mafije:vezivanje', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()
		if isHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do Wait(0) end
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		FreezeEntityPosition(playerPed, true)
		DisplayRadar(false)
	else
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('esxbalkan_mafije:odvezivanje')
AddEventHandler('esxbalkan_mafije:odvezivanje', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('esxbalkan_mafije:vuci')
AddEventHandler('esxbalkan_mafije:vuci', function(copId)
	if not isHandcuffed then return end
	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

CreateThread(function()
	local playerPed
	local targetPed
	while true do
		Wait(5)
		if isHandcuffed then
			playerPed = PlayerPedId()
			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
				-- Odvezi ako je igrac u autu
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end
				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end
			else
				DetachEntity(playerPed, true, false)
			end
		else
			Wait(2000)
		end
	end
end)

RegisterNetEvent('esxbalkan_mafije:staviUVozilo')
AddEventHandler('esxbalkan_mafije:staviUVozilo', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if not isHandcuffed then return end
	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('esxbalkan_mafije:staviVanVozila')
AddEventHandler('esxbalkan_mafije:staviVanVozila', function()
	local playerPed = PlayerPedId()
	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
		TriggerEvent('esxbalkan_mafije:odvezivanje')
	else
		ESX.ShowNotification('Osoba nije u vozilu i ne mozete je izvaditi van vozila!')
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Wait(2000)
		end
	end
end)
if not Config.CheckPointovi then
CreateThread(function()
	Wait(1000)
	local wejtara = 1000
	print("esxbalkan_mafije: Skripta je uspjesno loadovana i ucitana bez errora..")
	while true do
		Wait(wejtara)
		local jobName = PlayerData.job.name
		if PlayerData.job and Config.Mafije[jobName] then
			wejtara = 800
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum
			for k,v in pairs(Config.Mafije[jobName]) do
				for i=1, #Config.Mafije[jobName]['Armories'], 1 do
					local distance = #(coords - Config.Mafije[jobName]['Armories'][i])
					if distance < Config.DrawDistance then
						DrawMarker(Config.MarkerTypes.Oruzarnica, Config.Mafije[jobName]['Armories'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						wejtara = 5
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

				for i=1, #Config.Mafije[jobName]['ParkirajAuto'], 1 do
					local distance = #(coords - Config.Mafije[jobName]['ParkirajAuto'][i])
					local vehicle = GetVehiclePedIsIn(playerPed, false)
					if distance < Config.DrawDistance then
						if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
							wejtara = 5
							letSleep = false
							DrawMarker(Config.MarkerTypes.VracanjeAuta, Config.Mafije[jobName]['ParkirajAuto'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 20, false, true, 2, true, false, false, false)
						end
					end

					if distance < Config.MarkerAuto.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ParkirajAuto', i
					end
				end

				for i=1, #Config.Mafije[jobName]['Vehicles'], 1 do
					local distance = #(coords - Config.Mafije[jobName]['Vehicles'][i])

					if distance < Config.DrawDistance then
						if not IsPedInAnyVehicle(playerPed, false) then
							wejtara = 5
							letSleep = false
							DrawMarker(Config.MarkerTypes.SpawnAuta, Config.Mafije[jobName]['Vehicles'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						end
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end

				if PlayerData.job.grade_name == 'boss' then
					for i=1, #Config.Mafije[jobName]['BossActions'], 1 do
						local distance = #(coords - Config.Mafije[jobName]['BossActions'][i])

						if distance < Config.DrawDistance then
							wejtara = 5
							DrawMarker(Config.MarkerTypes.BossMeni, Config.Mafije[jobName]['BossActions'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					TriggerEvent('esxbalkan_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end
				HasAlreadyEnteredMarker = true
 				LastStation = currentStation
				LastPart = currentPart
				LastPartNum  = currentPartNum
				TriggerEvent('esxbalkan_mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esxbalkan_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
			if letSleep then wejtara = 5000 end
		else
			wejtara = 5000
		end
	end
end)
else
CreateThread(function()
	Wait(1000)
	local wejtara = 1000
	print("esxbalkan_mafije: Skripta je uspjesno loadovana i ucitana bez errora..")
	local tablica = {}
	while true do
		Wait(wejtara)
		local jobName = PlayerData.job.name
		if PlayerData.job and Config.Mafije[jobName] then
			wejtara = 800
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum
			for i = 1, #tablica do
				DeleteCheckpoint(tablica[i])
			end
			for k,v in pairs(Config.Mafije[jobName]) do
				for i=1, #Config.Mafije[jobName]['Armories'], 1 do
					local distance = #(coords - Config.Mafije[jobName]['Armories'][i])
					if distance < Config.DrawDistance then
						local armory = CreateCheckpoint(47,Config.Mafije[jobName]['Armories'][i] - 1, v, 2.0, 0, 0, 255, 200, 0)
						SetCheckpointCylinderHeight(armory, 2.0, 2.0, 2.0)
						table.insert(tablica, armory)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

				for i=1, #Config.Mafije[jobName]['ParkirajAuto'], 1 do
					local distance = #(coords - Config.Mafije[jobName]['ParkirajAuto'][i])
					local vehicle = GetVehiclePedIsIn(playerPed, false)
					if distance < Config.DrawDistance then
						if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
							local parkirajvozilo = CreateCheckpoint(47, Config.Mafije[jobName]['ParkirajAuto'][i] - 1, v, 2.0, 0, 0, 255, 200, 0)
							SetCheckpointCylinderHeight(parkirajvozilo, 2.0, 2.0, 2.0)
							table.insert(tablica, parkirajvozilo)
							letSleep = false
						end
					end

					if distance < Config.MarkerAuto.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ParkirajAuto', i
					end
				end

				for i=1, #Config.Mafije[jobName]['Vehicles'], 1 do
					local distance = #(coords - Config.Mafije[jobName]['Vehicles'][i])

					if distance < Config.DrawDistance then
						if not IsPedInAnyVehicle(playerPed, false) then
							local vozila = CreateCheckpoint(47, Config.Mafije[jobName]['Vehicles'][i] - 1, v, 2.0, 0, 0, 255, 200, 0)
							SetCheckpointCylinderHeight(vozila, 2.0, 2.0, 2.0)
							table.insert(tablica, vozila)
							letSleep = false
						end
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end

				if PlayerData.job.grade_name == 'boss' then
					for i=1, #Config.Mafije[jobName]['BossActions'], 1 do
						local distance = #(coords - Config.Mafije[jobName]['BossActions'][i])

						if distance < Config.DrawDistance then
							local bossmeni = CreateCheckpoint(47, Config.Mafije[jobName]['BossActions'][i] - 1, v, 2.0, 0, 0, 255, 200, 0)
							SetCheckpointCylinderHeight(bossmeni, 2.0, 2.0, 2.0)
							table.insert(tablica, bossmeni)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					TriggerEvent('esxbalkan_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end
				HasAlreadyEnteredMarker = true
 				LastStation = currentStation
				LastPart = currentPart
				LastPartNum  = currentPartNum

				TriggerEvent('esxbalkan_mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esxbalkan_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
			if letSleep then wejtara = 5000 end
		else
			wejtara = 5000
		end
	end
end)
end

RegisterKeyMapping('+mafijameni', 'Mafia meni', 'keyboard', 'F6')
RegisterCommand('+mafijameni', function()
	if not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
		if PlayerData.job and Config.Mafije[PlayerData.job.name] then
			OtvoriPosaoMenu()
		end
	end
end, false)

RegisterCommand('-mafijameni', function()
	-- ovo mora biti prazno!
end, false)

-- Trenutna akcija za markere i key kontrole--
CreateThread(function()
	while true do
		Wait(20)
		if CurrentAction and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
			pokazi3dtinky(GetEntityCoords(PlayerPedId()), CurrentActionMsg, 250)
			if IsControlPressed(0,38) then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					OpenArmoryMenu(CurrentActionData.station)
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OtvoriAutoSpawnMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
				elseif CurrentAction == 'ParkirajAuto' then
					ObrisiVozilo()
				elseif CurrentAction == 'Helikopter' then
					OtvoriHeliSpawnMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
				elseif CurrentAction == 'Brodovi' then
					OtvoriBrodSpawnMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					if Config.KoristiNUI == true then
					    SetNuiFocus(true, true)
							ESX.TriggerServerCallback('begijanes', function(data)
							
							SendNUIMessage({type = 'open', 
							organizacija = PlayerData.job.label, 
							organizacijarank = PlayerData.job.grade_label, 
							pareKes = data.cash, 
							pareFirma = data.society, 
							pareBanka = data.bank,
							radnici = elementi, 
							imeRadnika = identifier,
							radnicirank = PlayerData.job.grade_label,
							})
						end)
				    else
						TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
							menu.close()
							CurrentAction  = 'menu_boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
							end, { wash = Config.UkljuciPranje })
					end
				end
				CurrentAction = nil		
			end
		else
			Wait(1000)
		end
	end
end)

pokazi3dtinky = function(pos, text)
	local pocni = text
    local pocetak, kraj = string.find(text, '~([^~]+)~')
    if pocetak then
        pocetak = pocetak - 2
        kraj = kraj + 2
        pocni = ''
        pocni = pocni .. string.sub(text, 0, pocetak) .. '   '.. string.sub(text, pocetak+2, kraj-2) .. string.sub(text, kraj, #text)
    end
    AddTextEntry(GetCurrentResourceName(), pocni)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)
    SetFloatingHelpTextWorldPosition(1, pos + vector3(0.0, 0.0, 1.0))
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end
AddEventHandler('playerSpawned', function(spawn) isDead = false end)
AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
---------------------------------------------------
-- /////////////////////////////////////////////////
--		FUNCKIJE OD POLICEJOBA ZA ARMORYA -
-- ////////////////////////////////////////////////
-- function OpenGetWeaponMenu()
-- 	ESX.TriggerServerCallback('esxbalkan_mafije:dbGettajPuske', function(weapons)
-- 		local elements = {}
-- 		for i=1, #weapons, 1 do
-- 			if weapons[i].count > 0 then
-- 				table.insert(elements, {
-- 					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
-- 					value = weapons[i].name
-- 				})
-- 			end
-- 		end
-- 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
-- 			title = 'Uzmi oružje',
-- 			align  = 'top-left',
-- 			elements = elements
-- 		}, function(data, menu)
-- 			local oruzije = data.current.value
-- 			if oruzije then
-- 				menu.close()
-- 				ESX.TriggerServerCallback('esxbalkan_mafije:izvadiIzOruzarnice', function()
-- 			        OpenGetWeaponMenu()
-- 				end, data.current.value)
-- 			end
-- 		end, function(data, menu)
-- 			menu.close()
-- 		end)
-- 	end)
-- end

-- function OpenPutWeaponMenu()
-- 	local elements = {}
-- 	local playerPed  = PlayerPedId()
-- 	local weaponList = ESX.GetWeaponList()
-- 	for i=1, #weaponList, 1 do
-- 		local weaponHash = GetHashKey(weaponList[i].name)
-- 		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
-- 			table.insert(elements, {
-- 				label = weaponList[i].label,
-- 				value = weaponList[i].name
-- 			})
-- 		end
-- 	end
-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
-- 		title = 'Ostavi oružje',
-- 		align  = 'top-left',
-- 		elements = elements
-- 	}, function(data, menu)
-- 		menu.close()
-- 		ESX.TriggerServerCallback('esxbalkan_mafije:staviUoruzarnicu', function()
-- 			OpenPutWeaponMenu()
-- 		end, data.current.value, true)
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

-- function OpenBuyWeaponsMenu()
-- 	local elements = {}
-- 	local playerPed = PlayerPedId()
-- 	for k,v in pairs(Config.Oruzje[PlayerData.job.grade_name]) do
-- 		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
-- 		local components, label = {}
-- 		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)
-- 		if v.components then
-- 			for i=1, #v.components do
-- 				if v.components[i] then
-- 					local component = weapon.components[i]
-- 					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)
-- 					if hasComponent then
-- 						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, 'Već imaš taj dodatak')
-- 					else
-- 						if v.components[i] > 0 then
-- 							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, '$'..ESX.Math.GroupDigits(v.components[i]))
-- 						else
-- 							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, 'Besplatno!')
-- 						end
-- 					end

-- 					table.insert(components, {
-- 						label = label,
-- 						componentLabel = component.label,
-- 						hash = component.hash,
-- 						name = component.name,
-- 						price = v.components[i],
-- 						hasComponent = hasComponent,
-- 						componentNum = i
-- 					})
-- 				end
-- 			end
-- 		end

-- 		if hasWeapon and v.components then
-- 			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
-- 		elseif hasWeapon and not v.components then
-- 			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, 'Već imaš tu pušku!')
-- 		else
-- 			if v.price > 0 then
-- 				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, "$"..ESX.Math.GroupDigits(v.price))
-- 			else
-- 				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, 'Besplatno!')
-- 			end
-- 		end
		
-- 		table.insert(elements, {
-- 			label = label,
-- 			weaponLabel = weapon.label,
-- 			name = weapon.name,
-- 			components = components,
-- 			price = v.price,
-- 			hasWeapon = hasWeapon
-- 		})
-- 	end

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
-- 		title  = 'Oružarnica',
-- 		align = 'top-left',
-- 		elements = elements
-- 	}, function(data, menu)
-- 		if data.current.hasWeapon then
-- 			if #data.current.components > 0 then
-- 				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
-- 			end
-- 		else
-- 			ESX.TriggerServerCallback('esxbalkan_mafije:kupiOruzje', function(bought)
-- 				if bought then
-- 					if data.current.price > 0 then
-- 						ESX.ShowNotification('Kupio si ' ..  data.current.weaponLabel .. ' za ~g~$' .. ESX.Math.GroupDigits(data.current.price))
-- 					end
-- 					menu.close()
-- 					OpenBuyWeaponsMenu()
-- 				else
-- 					ESX.ShowNotification(_U('armory_money'))
-- 				end
-- 			end, data.current.name, 1)
-- 		end
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

-- function OpenWeaponComponentShop(components, weaponName, parentShop)
-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
-- 		title = _U('armory_componenttitle'),
-- 		align = 'top-left',
-- 		elements = components
-- 	}, function(data, menu)
-- 		if data.current.hasComponent then
-- 			ESX.ShowNotification(_U('armory_hascomponent'))
-- 		else
-- 			ESX.TriggerServerCallback('esxbalkan_mafije:kupiOruzje', function(bought)
-- 				if bought then
-- 					if data.current.price > 0 then
-- 						ESX.ShowNotification('Kupio si ' ..  data.current.componentLabel .. ' za ~g~$' .. ESX.Math.GroupDigits(data.current.price))
-- 					end
-- 					menu.close()
-- 					parentShop.close()
-- 					OpenBuyWeaponsMenu()
-- 				else
-- 					ESX.ShowNotification(_U('armory_money'))
-- 				end
-- 			end, weaponName, 2, data.current.componentNum)
-- 		end
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esxbalkan_mafije:getajsveiteme', function(items)
		local elements = {}

		for i=1, #items, 1 do
			local item = items[i]
			if item.count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].name,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Mafia Stvari',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if not count then
					ESX.ShowNotification('Ova kolicina je nevazeca!')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esxbalkan_mafije:getStockItem', itemName, count)
					Wait(50)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esxbalkan_mafije:getajigracevinventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title = 'Inventory',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('Ova kolicina je nevazeca!')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esxbalkan_mafije:putStockItems', itemName, count)
					Wait(50)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end


RegisterNUICallback("zatvori", function(data)
    SetNuiFocus(false, false)
    print("zatvorio")
end)

function refresh()
	ESX.TriggerServerCallback('begijanes', function(data)
		SendNUIMessage({type = 'open', 
		organizacija = ESX.PlayerData.job.label, 
		organizacijarank = ESX.PlayerData.job.grade_label,
		pareKes = data.cash, 
		pareFirma = data.society, 
		pareBanka = data.bank,
		})
	end)
end


RegisterNUICallback("unaprijediClana", function(data)
	local ident = data.identifier
	local grade = tonumber(data.nowGrade)
	TriggerServerEvent("esx_society:unaprijediClana", data.identifier, grade)
end)


RegisterNUICallback("degradirajClana", function(data)
	local ident = data.identifier
	local nowGrade = tonumber(data.nowGrade)
    TriggerServerEvent("esx_society:downgradexd", ident, nowGrade)
end)

RegisterNUICallback("otkaz", function(data)
	local ident = data.identifier
	TriggerServerEvent("esx_society:otpustiClana", ident)
end)




RegisterNUICallback("stavinovac", function(data)
	pare = tonumber(data.kolicinastavljanja)
	if pare == nil then
		ESX.ShowNotification("Niste unijeli kolicinu")
	else
		TriggerServerEvent('esx_society:depositMoney', PlayerData.job.name, pare)
		refresh()
	end
end)

RegisterNUICallback("izvadinovac", function(data)
	kolicinavadjenja = tonumber(data.kolicinavadjenja)
	if kolicinavadjenja == nil then
		ESX.ShowNotification("Niste unijeli kolicinu")
	else
		TriggerServerEvent('esx_society:withdrawMoney', PlayerData.job.name, kolicinavadjenja)
		refresh()
	end
end)


RegisterNUICallback("listaclanovaopn", function(data)

	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			SendNUIMessage({type = 'listazaposlenih', 
			firstname = employees[i].name,
			lastname = employees[i].lastname,
            grade_label = gradeLabel,
			rod = employees[i].rod,
			rank_label = employees[i].job.grade_label,
			employeescount = #employees,
			identifier = employees[i].identifier,
			grade_number = employees[i].job.grade,
			brojtelefona = employees[i].brojtelefona,
			})
		end
	end, PlayerData.job.name)
end)



RegisterNUICallback("zaposliIgraca", function(data)
	id = tonumber(data.id)
	if id == nil then
		ESX.ShowNotification("Nisi unio ID")
	else
		ESX.TriggerServerCallback('esx_society:setJobById', function()
		   end, id, PlayerData.job.name, 0) --id, job, rank
		   Core.SaveAll()
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then 
	TriggerEvent('esxbalkan_mafije:odvezivanje')
	SetNuiFocus(false, false)
	end
end)
