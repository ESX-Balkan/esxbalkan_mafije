
local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, playerInService, Pretrazivan = false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false

ESX = nil


CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
	while ESX.GetPlayerData().job == nil do Wait(10) end
	PlayerData = ESX.GetPlayerData()
end)

local Poslovi = PlayerData.job.name == 'zemunski' or PlayerData.job.name == 'yakuza' or PlayerData.job.name == 'vagos' or PlayerData.job.name == 'peaky' or PlayerData.job.name == 'ludisrbi' or PlayerData.job.name == 'lcn' or PlayerData.job.name == 'lazarevacki' or PlayerData.job.name == 'juzniv' or PlayerData.job.name == 'gsf' or PlayerData.job.name == 'favela' or PlayerData.job.name == 'camorra' or PlayerData.job.name == 'ballas'  or PlayerData.job.name == 'automafija'  or PlayerData.job.name == 'stikla'


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)
-----------------------
-------FUNKCIJE--------
-----------------------
ocistiIgraca = function(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

ObrisiVozilo = function()
	local playerPed = PlayerPedId()
	local vozilo =GetVehiclePedIsIn(playerPed,false)
        local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
	local igracbrzina = math.floor((GetEntitySpeed(GetVehiclePedIsIn(playerPed, false))*3.6))
	if(igracbrzina > 45) then
		FreezeEntityPosition(vozilo, true)
		TaskLeaveVehicle(playerPed, vozilo, 0)
		while IsPedInVehicle(playerPed, vozilo, true) do Wait(0) end
		Citizen.Wait(500)
		NetworkFadeOutEntity(vozilo, true, true)
		Citizen.Wait(100)
		ESX.Game.DeleteVehicle(vozilo)
	elseif (igracbrzina < 10) then
		TaskLeaveVehicle(playerPed, vozilo, 0)
		while IsPedInVehicle(playerPed, vozilo, true) do Wait(0) end
		Citizen.Wait(500)
		NetworkFadeOutEntity(vozilo, true, true)
		Citizen.Wait(100)
		ESX.Game.DeleteVehicle(vozilo)
		ESX.ShowNotification("Uspiješno si parkirao ~b~vozilo~s~ u garažu.")
	end
end

--Sef Menu --
function OpenArmoryMenu(station)
	local elements = {{label = 'Kupi oružje | 🔫', value = 'buy_weapons'}}
	table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
	table.insert(elements, {label = _U('put_weapon'),value = 'put_weapon'})
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  			if closestPlayer ~= -1 and closestDistance > 3.0 then
			OpenGetWeaponMenu()
			elseif GetNumberOfPlayers() == 1 then
			OpenGetWeaponMenu()
		  else
    			ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
		end
		elseif data.current.value == 'put_weapon' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  			if closestPlayer ~= -1 and closestDistance > 3.0 then
			OpenPutWeaponMenu()
			elseif GetNumberOfPlayers() == 1 then
			OpenGetWeaponMenu()
		else
    			ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~recite ljudima da se odmaknu malo od sefa!')
		end
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		end

	end, function(data, menu)
		menu.close()
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

StvoriVozilo = function(vozilo)
	for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
		a = (Config.Mafije[PlayerData.job.name]['MeniVozila'][vozilo])
		break
	end
	TriggerEvent('esx:spawnVehicle', a)
end

OtvoriAutoSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni',{
            title = 'Izaberi Vozilo | 🚗',
            elements = {
            	{label = Config.Mafije[PlayerData.job.name]['MeniVozila'].Vozilo1 .. ' | 🚗', value = 'primo2'},
		{label = Config.Mafije[PlayerData.job.name]['MeniVozila'].Vozilo2 .. ' | 🚗', value = 'seminole'},
		{label = Config.Mafije[PlayerData.job.name]['MeniVozila'].Vozilo3 .. ' | 🚗', value = 'enduro'},
            }},function(data, menu)
            if data.current.value == 'primo2' then
				StvoriVozilo('Vozilo1')
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seminole' then
				StvoriVozilo('Vozilo2')
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'enduro' then
				StvoriVozilo('Vozilo3')
            end
        end,
        function(data, menu)
          menu.close()
     end)
end

OtvoriHeliSpawnMenu = function(type, station, part, partNum)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vozila_meni',{
        	css      = 'vagos',
            title    = 'Izaberi Vozilo | 🚗',
            elements = {
            	{label = 'Brodovi2 | 🚗', value = 'fxho'},
				{label = 'Brodovi | 🚗', value = 'seashark'},
            }},function(data, menu)
            local playerPed = PlayerPedId()
            if data.current.value == 'fxho' then
				ESX.Game.SpawnVehicle("supervolito2", vector3(-2320.86, -658.25, 13.48), 266.92, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					SetVehicleCurrentRpm(vehicle, 3000)
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
					SetVehicleCurrentRpm(vehicle, 3000)
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
					SetVehicleCurrentRpm(vehicle, 3000)
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
					SetVehicleCurrentRpm(vehicle, 3000)
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
				css      = 'vagos',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
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
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			css      = 'vagos',
			title    = _U('search'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('esxbalkan_mafije:oduzmiItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				PretrazivanjeIgraca(player)
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
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helikopter' then
		CurrentAction     = 'Helikopter'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Brodovi' then
		CurrentAction     = 'Brodovi'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif part == 'ParkirajAuto' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

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
	CreateThread(function()
		if isHandcuffed then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Wait(100)
			end

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
		Wait(1)
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
			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Wait(2000)
		end
	end
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

CreateThread(function()
    local wejtara = 1000
	while true do
		Wait(wejtara)
        for k,v in pairs(Config.Mafije) do
            if PlayerData.job and PlayerData.job.name == k then
            wejtara = 5
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum
			for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
					for i=1, #Config.Mafije[PlayerData.job.name]['Armories'], 1 do
						local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['Armories'][i], true)
						if distance < Config.DrawDistance then
							DrawMarker(21, Config.Mafije[PlayerData.job.name]['Armories'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end
	
						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
						end
					end
				for i=1, #Config.Mafije[PlayerData.job.name]['ParkirajAuto'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, Config.Mafije[PlayerData.job.name]['ParkirajAuto'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 255, 0, 0, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerAuto.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ParkirajAuto', i
					end
				end

				for i=1, #Config.Mafije[PlayerData.job.name]['Vehicles'], 1 do
					local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['Vehicles'][i], true)

					if distance < Config.DrawDistance then
						DrawMarker(36, Config.Mafije[PlayerData.job.name]['Vehicles'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end

				if PlayerData.job.grade_name == 'boss' then
					for i=1, #Config.Mafije[PlayerData.job.name]['BossActions'], 1 do
						local distance = GetDistanceBetweenCoords(coords, Config.Mafije[PlayerData.job.name]['BossActions'][i], true)

						if distance < Config.DrawDistance then
							DrawMarker(22, Config.Mafije[PlayerData.job.name]['BossActions'][i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esxbalkan_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esxbalkan_mafije:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esxbalkan_mafije:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Wait(2000)
			end

		    else
			    Wait(2000)
		    end
        end
	end
end)

RegisterKeyMapping('+mafijameni', 'Mafia meni', 'keyboard', 'F6')
RegisterCommand('+mafijameni', function()
        if not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
	for k,v in pairs(Config.Mafije) do
            if PlayerData.job and PlayerData.job.name == k and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions')  then
		OtvoriPosaoMenu()
		end
            end
	end
end, false)
RegisterCommand('-mafijameni', function()
end, false)

-- Trenutna akcija za markere i key kontrole--
CreateThread(function()
	while true do
		Wait(8)
		if CurrentAction and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38)  then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer ~= -1 and closestDistance > 2.0 then
                                OpenArmoryMenu(CurrentActionData.station)
                                elseif GetNumberOfPlayers() == 1 then
                                OpenArmoryMenu(CurrentActionData.station)
                                else
                                ESX.ShowNotification('~y~Ne mozete pristupiti sefu, ~r~neko vec gleda u sef!')
                                end
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
					TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
					menu.close()
					CurrentAction  = 'menu_boss_actions'
					CurrentActionMsg  = _U('open_bossmenu')
					CurrentActionData = {}
					end, { wash = false }) 
				end
				CurrentAction = nil
			end
		else
			Wait(2000)
		end -- CurrentAction end
	end
end)
AddEventHandler('playerSpawned', function(spawn) isDead = false end)
AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
---------------------------------------------------
-- /////////////////////////////////////////////////
--		FUNCKIJE OD POLICEJOBA ZA ARMORYA -
-- ////////////////////////////////////////////////
function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esxbalkan_mafije:dbGettajPuske', function(weapons)
		local elements = {}
		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title = 'Uzmi oružje',
			align  = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esxbalkan_mafije:izvadiIzOruzarnice', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()
	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)
		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title = 'Ostavi oružje',
		align  = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback('esxbalkan_mafije:staviUoruzarnicu', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	for k,v in ipairs(Config.Oruzje[PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)
		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)
					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, 'Već imaš taj dodatak')
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, '$'..ESX.Math.GroupDigits(v.components[i]))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, 'Besplatno!')
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, 'Već imaš tu pušku!')
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, "$"..ESX.Math.GroupDigits(v.price))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, 'Besplatno!')
			end
		end
		
		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title  = 'Oružarnica',
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esxbalkan_mafije:kupiOruzje', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification('Kupio si ' ..  data.current.weaponLabel .. ' za ~g~$' .. ESX.Math.GroupDigits(data.current.price))
					end
					menu.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title = _U('armory_componenttitle'),
		align = 'top-left',
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esxbalkan_mafije:kupiOruzje', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification('Kupio si ' ..  data.current.componentLabel .. ' za ~g~$' .. ESX.Math.GroupDigits(data.current.price))
					end
					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then TriggerEvent('esxbalkan_mafije:odvezivanje') end
end)

