Config  = {}
Config.CheckPointovi = false -- Ukoliko zelite stalno 0.01ms :D i opsjednuti ste optimizacijom, # BETA JOS NIJE TESTIRANO DA VALJA!
Config.DrawDistance = 20.0 -- 20 je savim dovoljno ne treb ni manje ni preko 20..
Config.MarkerSize  = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerHelikopter   = { x = 6.0, y = 6.0, z = 2.5 }
Config.MarkerAuto = { x = 3.0, y = 3.0, z = 3.0 }
Config.MarkerColor  = { r = 50, g = 50, b = 204 }
Config.EnableESXIdentity  = true -- ako koristite esx_identity
Config.Limit = false -- Dali koristite limit? ako je true onda ce biti limit u sefovima i u pretrazivanju igraca, ako je false onda je tezina itema!
Config.Webhuk = "" -- Ovdje dodajete svoj wehuk za mafije da imate logove itd :)
Config.UkljuciPranje = true -- Ovdje mozete iskljuciti pranje novca kao sef...
Config.Locale  = 'hr'
Config.Levelanje = false -- Ovo stavite na true ako želite da mafije idu po levelima
Config.Webhuk = "https://discord.com/api/webhooks/915984376221802566/o6m70ZdezJODlP2DFnyCVf3q-JGoI2g3ZTqqklcfj_SEr07a7Pix67SII16kp0Caoowk" -- Ovdje dodajete svoj wehuk za mafije da imate logove itd :)
Config.lvl1 = 25000 -- ovo je cijena za upgrade na lvl 1, otkljucava sef
Config.lvl2 = 50000 -- ovo je cijena za upgrade na lvl 2, shop za oruzija
Config.lvl3 = 75000 -- ovo je cijena za upgrade na lvl 3, shop za oruzija
Config.MarkerTypes = {
	Brodovi = 35,
	BossMeni = 31,
	SpawnAuta = 36,
	ObicanMarker = 27,
	Helikopteri = 34,
	VracanjeAuta = 1,
	Oruzarnica = 21
}

-- OVDJE DODAJETE NOVE POSLOVE SVE
Config.Mafije = {
	zemunski = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(1394.69, 1149.95, 114.33)},
		Vehicles = {vector3(1392.33, 1118.33, 114.84)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(1395.4, 1159.86, 114.33)},
		ParkirajAuto = {vector3(1409.85, 1118.93, 114.84)},
	},
	yakuza = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(-85.6, 997.42, 229.90)},
		Vehicles = {vector3(-130.69, 1001.11, 235.74)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(-60.26, 982.09, 233.65)},
		ParkirajAuto = {vector3(-124.36, 1007.92, 234.80)},
	},
	vagos = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(332.04, -2013.37, 21.60)},
		Vehicles = {vector3(334.74, -2033.02, 21.99)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(362.51, -2039.68, 24.71)},
		ParkirajAuto = {vector3(336.02, -2040.49, 20.40)},
	},
	peaky = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(-1519.24, 115.44, 49.05)},
		Vehicles = {vector3(-1528.4, 81.32, 56.63)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(-1498.29, 128.96, 54.97)},
		ParkirajAuto = {vector3(-1520.91, 82.05, 55.75)},
	},
	ludisrbi = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(-811.85, 175.21, 76.75)},
		Vehicles = {vector3(-828.68, 173.1, 70.52)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(-811.47, 180.73, 76.74)},
		ParkirajAuto = {vector3(-812.41, 187.05, 72.47)},
	},
	lcn = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(-6.96, 530.61, 174.30)},
		Vehicles = {vector3(1.7, 542.41, 173.82)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(0.13, 524.47, 173.90)},
		ParkirajAuto = {vector3(22.08, 544.82, 175.30)},
	},
	lazarevacki = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(-110.24, -14.13, 70.52)},
		Vehicles = {vector3(-81.09, -22.75, 66.32)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(-113.43, -12.1, 70.52)},
		ParkirajAuto = {vector3(-85.12, -28.92, 66.32)},
	},
	juzniv = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(889.09, -1027.04, 35.11)},
		Vehicles = {vector3(900.19, -1032.13, 34.97)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(909.92, -1025.6, 38.15)},
		ParkirajAuto = {vector3(894.7, -1018.52, 34.97)},
	},
	gsf = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(106.11, -1981.43, 20.20)},
		Vehicles = {vector3(107.04, -1942.11, 21.08)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(122.22, -1971.89, 20.55)},
		ParkirajAuto = {vector3(102.56, -1963.89, 20.00)},
	},
	favela = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(2163.19, -17.04, 233.80)},
		Vehicles = {vector3(1998.31, -71.97, 211.92)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(2048.04, -144.84, 270.29)},
		ParkirajAuto = {vector3(1990.85, -75.19, 211.1)},
	},
	camorra = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(2175.6, 3909.81, 37.08)},
		Vehicles = {vector3(2170.93, 3897.4, 32.87)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(2180.36, 3910.1, 36.51)},
		ParkirajAuto = {vector3(2170.93, 3897.4, 32.87)},
	},
	ballas = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(-19.85, -1404.84, 29.34)},
		Vehicles = {vector3(-17.21, -1408.78, 29.31)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(-19.28, -1412.47, 29.31)},
		ParkirajAuto = {vector3(-11.75, -1408.63, 29.31)},
	},
	automafija = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(728.2, -1064.17, 21.80)},
		Vehicles = {vector3(714.21, -1089.14, 22.38)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		BossActions = {vector3(727.04, -1066.75, 28.31)},
		ParkirajAuto = {vector3(728.83, -1088.96, 21.71)},
	},
	stikla = {
		--Cloakrooms = {vector3(0,0,0)},
		Armories = {vector3(108.56, -1305.95, 28.77)},
		Vehicles = {vector3(147.61, -1278.39, 29.08)},
		MeniVozila = {
			['g65amg'] = 'G Wagon',
			['sanchez'] = 'Sanchez',
			['sultan'] = 'Sultan'
		},
		Helikopter = {vector3(-2048.67, -517.63, 9.16)}, 
		MeniHelikoptera = {
			Heli1 = 'supervolito',
			Heli2 = 'seasparrow',
		},
		Brodovi = {vector3(-2293.19, -658.06, 3.96)},
		BrodoviMenu = {
			Brod1 = 'fxho',
			Brod2 = 'seashark',
		},
		--Ako treba nekom helihopter/brod evo vam
		BossActions = {vector3(95.38, -1293.58, 29.27)},
		ParkirajAuto = {vector3(141.32, -1267.27, 28.25)},
	}
}

Config.Oruzje = {
	novi = {
		{weapon = 'WEAPON_APPISTOL', components = {5000, 5000, 2000, 4000, nil}, price = 25000}
	},
	radnik = {
		{weapon = 'WEAPON_APPISTOL', components = {2000, 2000, 1000, 4000, nil}, price = 1},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {2000, 6000, 1000, 4000, 8000, nil}, price = 501000},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {2000, 6000, nil}, price = 1}
	},
	zamenik = {
		{weapon = 'WEAPON_APPISTOL', components = {2500, 2000, 1000, 4000, nil}, price = 25000},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {8500, 6000, 1000, 4000, 8000, nil}, price = 125000},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {6500, 6000, nil}, price = 75000}
	},
	boss = {
		{weapon = 'WEAPON_APPISTOL', components = {2500, 2000, 1000, 4000, nil}, price = 25000},
		{weapon = 'WEAPON_ADVANCEDRIFLE', components = {8500, 6000, 1000, 4000, 8000, nil}, price = 125000},
		{weapon = 'WEAPON_PUMPSHOTGUN', components = {6500, 6000, nil}, price = 75000}
	}
}
