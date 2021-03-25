local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, playerInService = false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false

ESX = nil


CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(250) end
	while ESX.GetPlayerData().job == nil do Wait(100) end
	PlayerData = ESX.GetPlayerData()
end)


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
    	local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
	local igracbrzina = math.floor((GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))*3.6))
	if(igracbrzina > 45) then
		ESX.ShowNotification("Voziš pre brzo ~b~vozilo~s~, uspori!")
	elseif (igracbrzina < 45) then
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		ESX.ShowNotification("Uspiješno si parkirao ~b~vozilo~s~ u garažu.")
	end
end

--Sef Menu --
OpenArmoryMenu = function(station)
	local elements = {
		{label = 'Sef | 📷', value = 'sef'},
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		css      = 'mafia',
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'sef' then
			TriggerServerEvent("mercury_sefovi:povuciInv", PlayerData.job.name)
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
				ESX.Game.SpawnVehicle("fxho", vector3(-2273.91, -662.05, 0.5),  159.25, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'seashark' then
				ESX.Game.SpawnVehicle("yacht2", vector3(-2273.91, -662.05, 0.5),  159.25, function(vehicle) -- 
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				end)
				Wait(200)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleDirtLevel(vehicle, 0.0)
                exports["balkankings_gorivo"]:SetFuel(vehicle, 100)
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
						TriggerServerEvent('esxbalkan_mafije:poruka', GetPlayerServerId(closestPlayer), _U('being_searched'))
						PretrazivanjeIgraca(closestPlayer)
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
	if not isHandcuffed then
		return
	end
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
	if not isHandcuffed then
		return
	end
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
			Wait(1000)
		end
	end
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-------Begi prave se markeri----------
CreateThread(function()
	while true do
		Wait(5)
		if PlayerData.job and (PlayerData.job.name == 'zemunski' or PlayerData.job.name == 'yakuza' or PlayerData.job.name == 'vagos' or PlayerData.job.name == 'peaky' or PlayerData.job.name == 'ludisrbi' or PlayerData.job.name == 'lcn' or PlayerData.job.name == 'lazarevacki' or PlayerData.job.name == 'juzniv' or PlayerData.job.name == 'gsf' or PlayerData.job.name == 'favela' or PlayerData.job.name == 'camorra' or PlayerData.job.name == 'ballas'  or PlayerData.job.name == 'automafija'  or PlayerData.job.name == 'stikla' ) then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum
			for k,v in pairs(Config.Mafije[PlayerData.job.name]) do
				if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'savetnik' then
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
end)

-- Trenutna akcija za markere i key kontrole--
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38)  then
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
					TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
						menu.close()
						
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) 
				end

				CurrentAction = nil
			end
		end -- CurrentAction end

		if PlayerData.job and (PlayerData.job.name == 'zemunski' or PlayerData.job.name == 'yakuza' or PlayerData.job.name == 'vagos' or PlayerData.job.name == 'peaky' or PlayerData.job.name == 'ludisrbi' or PlayerData.job.name == 'lcn' or PlayerData.job.name == 'lazarevacki' or PlayerData.job.name == 'juzniv' or PlayerData.job.name == 'gsf' or PlayerData.job.name == 'favela' or PlayerData.job.name == 'camorra' or PlayerData.job.name == 'ballas'  or PlayerData.job.name == 'automafija'  or PlayerData.job.name == 'stikla' ) then
				if IsControlJustReleased(0, 167) and not isDead and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
					OtvoriPosaoMenu()
				end
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esxbalkan_mafije:odvezivanje')
	end
end)
