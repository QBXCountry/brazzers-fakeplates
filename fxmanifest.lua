fx_version 'cerulean'
game 'gta5'

name "Brazzers Fake Plates"
author "Brazzers Development | MannyOnBrazzers#6826"
version "1.0"

lua54 'yes'

modules { 'qbx_core:utils', 'qbx_core:playerdata' }
shared_scripts { '@ox_lib/init.lua', '@bx_core/import.lua', 'locales/*.lua', 'shared/*.lua' }
client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua', '@oxmysql/lib/MySQL.lua' }

files { 'modules/*.lua' }