fx_version 'cerulean'
game 'gta5'
version "1.9"

lua54 'yes'

shared_scripts {
	'@es_extended/locale.lua',
	'prevod/*',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*'
}

client_script 'client/*'

dependencies {
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore',
	'esx_society',
	'mysql-async'
}
