resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'QBCore Speedcamera script | Properly converted by WEEZOOKA'

version '0.0.1'

shared_scripts {
  'config.lua'
}
server_scripts {
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}

ui_page('html/index.html')

files {
    'html/index.html'
}







