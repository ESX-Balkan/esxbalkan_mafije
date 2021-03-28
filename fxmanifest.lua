fx_version 'cerulean'
game 'gta5'

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
	'esx_datastore'
}
