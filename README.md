# KillerMUDScripts
Mudlet scripts for Killer MUD text game

Wpisz tą komendę do Mudleta aby zainstalować:

`lua function d(a,b) installPackage(b)os.remove(b) end if kinstall == nil then registerAnonymousEventHandler("sysDownloadDone","d",true)downloadFile(getMudletHomeDir().."/kinstall.zip","https://raw.githubusercontent.com/ktunkiewicz/KillerMUDScripts/main/dist/kinstall.zip") else echo('Skrypt jest już zainstalowwany, wpisz +install') end`
