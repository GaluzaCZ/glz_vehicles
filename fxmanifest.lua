fx_version 'cerulean'
game 'gta5'

name "glz_vehicles"
description "Vehicle framework for better working with vehicles"
author "GalužaCZ#8828"
repository 'https://github.com/GaluzaCZ/glz_vehicles'
version "0.1"

lua54 'yes'

dependencies {
	"mysql-async",
	"es_extended"
}

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'shared/*.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/vehicles.lua',
	'server/main.lua',
	'server/events.lua'
}

client_scripts {
	'client/utils.lua',
	'client/garage.lua',
	'client/main.lua',
	'client/events.lua',
	'client/commands.lua',
	'client/carlock.lua'
}