fx_version 'cerulean'
game 'gta5'

name "glz_vehicles"
description "Vehicle system for better working with vehicles"
author "GalužaCZ#8828"
version "1.0"

dependencies {
	"es_extended",
}

shared_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'shared/*.lua'
}

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}
