fx_version "adamant"
game "gta5"

shared_scripts {
	'@es_extended/imports.lua',
	'shared/config.lua',
	'shared/lang.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	'client/teleport.lua'
}