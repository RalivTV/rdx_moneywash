fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '0.0.1'

server_scripts {
	'@rdx_core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
}

client_scripts {
	'@rdx_core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'rdx_core',
}
