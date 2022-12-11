--[[ FX Infromacije ]]--
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
games        { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

--[[ Skripta Infromacije ]]--
name         'esxbalkan_mafije'
author       'ESX-Balkan'
version      '2.1.6'
license      'LGPL-3.0-or-later'
repository   'https://github.com/ESX-Balkan/esxbalkan_mafije'
description  'Skripta za mafije koja je optimizirana najbolje i protekctovana od cheatera i najlaksa za postavljanje.'

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
