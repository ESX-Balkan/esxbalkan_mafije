resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.1'

server_scripts {
	'@dizel_mysql/lib/MySQL.lua',
	'@dizel_framework/locale.lua',
	'prevod/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@dizel_framework/locale.lua',
	'prevod/en.lua',
	'config.lua',
	'client/main.lua'
}