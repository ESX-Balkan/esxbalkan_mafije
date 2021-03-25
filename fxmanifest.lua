fx_version 'cerulean'
game 'gta5'

shader_scripts {
	'@es_extended/locale.lua',
	'config.lua,
	'prevod/en.lua',
}

server_scripts {
	'@mysql_async/lib/MySQL.lua',
	'server/main.lua'
}

client_script 'client/main.lua'
