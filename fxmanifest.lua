fx_version 'cerulean'
game 'gta5'
name 'esxbalkan_mafije'
author 'ESX-Balkan'
url 'https://github.com/ESX-Balkan/esxbalkan_mafije'
version "v2.1.5"
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
	'/server:5849', -- Server treba da ima updejtovane artifactove bar na 5849 verziju..           
	'/onesync',
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore',
	'esx_society'
}
