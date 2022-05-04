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
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'shared/*.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/vehicles.lua',
	'server/functions.lua',
	'server/events.lua',
	'server/main.lua',
}

client_scripts {
	'client/functions.lua',
	'client/utils.lua',
	'client/events.lua',


	--[[ Comment out what u dont need ]]
	'client/garage.lua',
	'client/commands.lua',
	'client/carlock.lua',
	'client/radialmenu.lua',
	--[[ ---------------------------- ]]


	'client/main.lua',
}