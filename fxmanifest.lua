fx_version 'cerulean'
game 'gta5'
author 'Meiiroz'
lua54 'yes'
description 'Post-apo prop looting (trash, bags, lockers, fridges, crates...) : shared random loot (ox_target + ox_inventory)'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
}

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
}
