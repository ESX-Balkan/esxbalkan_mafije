fx_version 'cerulean'
game 'gta5'
name 'esxbalkan_mafije'
author 'ESX-Balkan'
url 'https://github.com/ESX-Balkan/esxbalkan_mafije'
version "2.1.0"
lua54 'yes'

shared_scripts {
	'@es_extended/locale.lua',
	'prevod/*',
	'config.lua'
}

server_scripts {
	'server/*'
}

client_script 'client/*'

dependencies {
	'/onesync',
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore',
	'esx_society'
}
