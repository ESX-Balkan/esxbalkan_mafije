fx_version 'cerulean'
game {'gta5'}

lua54 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'prevod/*',
	'config.lua',
	'server/*'
}

client_scripts {
	'@es_extended/locale.lua',
	'prevod/*',
	'config.lua',
	'client/*'
}

dependencies {
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore',
	'esx_society',
	'mysql-async'
}
