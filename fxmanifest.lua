fx_version 'cerulean'
game 'gta5'

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'prevod/*.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'es_extended',
	'esx_datastore'
}
