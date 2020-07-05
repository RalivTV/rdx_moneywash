fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '0.0.1'

server_scripts {
	'@redm_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
}

client_scripts {
	'@redm_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'redm_extended',
}