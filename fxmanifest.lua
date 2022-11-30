fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

data_file 'EVENTS_OVERRIDE_FILE' 'events.meta'
data_file 'DLC_POP_GROUPS' 'popgroups.ymt'

files {
    'events.meta',
    'popgroups.ymt',
    'relationships.dat'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'