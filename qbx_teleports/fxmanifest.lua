--[[ FX Information ]]--
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--
version '2.0.0'
license 'GPL-3.0-or-later'
description 'Teleportation between doors'
repository 'https://github.com/Qbox-project/qbx_smallresources'

--[[ Manifest ]]--
dependencies {
	'ox_lib',
	'qbx_core'
}

file 'config.json'

shared_scripts {
	'@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua'
}

client_script 'client.lua'
