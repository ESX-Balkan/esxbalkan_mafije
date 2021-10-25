fx_version 'cerulean'
game 'gta5'
name 'esxbalkan_mafije'
author 'ESX-Balkan'
url 'https://github.com/ESX-Balkan/esxbalkan_mafije'
version "1.9.3"
use_fxv2_oal 'yes'
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
	'/server:4500', -- potrebno je da bar imate recommended build za server 4500
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore',
	'esx_society'
}
