fx_version 'cerulean'
game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'prevod/*.lua',
	'config.lua',
	'client/*.lua'
}

dependencies {
	'es_extended',
	'esx_datastore'
}
