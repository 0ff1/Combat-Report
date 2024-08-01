fx_version 'cerulean'
game 'gta5'

author '0ff'
description 'Winsvue Task - Combat Report'
version '1.0'

dependencies { '/onesync', 'ox_lib' }

files { 'src/client/classes/**/*' }

shared_scripts { '@ox_lib/init.lua' }
client_scripts { 'src/client/client.lua' }
server_scripts { 'src/server/server.lua' }

lua54 'yes'
