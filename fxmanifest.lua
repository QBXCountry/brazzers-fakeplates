fx_version 'cerulean'
game 'gta5'

name "Brazzers Fake Plates"
author "Brazzers Development | MannyOnBrazzers#6826"
version "1.0"

lua54 'yes'

ox_lib 'locale'

shared_scripts { '@ox_lib/init.lua', '@qbx_core/modules/lib.lua', 'locales/*.lua' }
client_scripts { '@qbx_core/modules/playerdata.lua', 'client/*.lua' }
server_scripts { 'server/*.lua', '@oxmysql/lib/MySQL.lua' }

files { 'modules/*.lua', 'locales/*.json' }