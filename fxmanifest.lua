fx_version 'cerulean'
game 'gta5'

description 'Collection of small scripts'
repository 'https://github.com/Qbox-project/qbx_smallresources'
version '1.1.0'

ox_lib 'locale'

shared_scripts {
	'@ox_lib/init.lua',
	'@qbx_core/modules/lib.lua',
}

client_scripts {
	'@qbx_core/modules/playerdata.lua',
	'client/*.lua'
}

server_script 'server/*.lua'

files {
	'locales/*.json',
	'config/client.lua',
	'config/shared.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
