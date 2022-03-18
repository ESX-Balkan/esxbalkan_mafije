fx_version 'cerulean'
game 'gta5'
version "1.9.3"

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
	'esxbalkan_addonaccount',
	'esxbalkan_addoninventory',
	'esxbalkan_datastore',
	'esxbalkan_society',
	'mysql-async'
}
ui_page 'html/index.html'
files {
    "html/*.png",
    "html/index.html",
    "html/style.css",
    "html/jos-neki-js.js.js",
    "html/app.js",
	"html/assets/*.png"
}
