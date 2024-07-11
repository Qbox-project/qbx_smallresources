fx_version 'cerulean'
game 'gta5'

name 'qbx_smallresources'
description 'Collection of small scripts'
repository 'https://github.com/Qbox-project/qbx_smallresources'
version '0.1.1'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    '**/client.lua'
}

server_script '**/server.lua'

files {
    'locales/*.json',
    '**/config.json',
    '**/config.lua'
}

dependencies {
    'ox_lib',
    'qbx_core'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
