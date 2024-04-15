--[[ FX Information ]]--
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--
version '2.0.0'
license 'GPL-3.0-or-later'
description 'The player ped lies on the ground for few seconds'
repository 'https://github.com/Qbox-project/qbx_smallresources'

--[[ Manifest ]]--
dependency 'ox_lib'

shared_script '@ox_lib/init.lua'

client_script 'client.lua'
