# KillerMUDScripts

Skrypty do Killer MUDa.

Aktualna lista:
- kmap - moduł mapy

Wpisz tą komendę do Mudleta aby zainstalować:

`lua function d(a,b) installPackage(b)os.remove(b) end registerAnonymousEventHandler("sysDownloadDone","d",true)downloadFile(getMudletHomeDir().."/kinstall.zip","https://raw.githubusercontent.com/ktunkiewicz/KillerMUDScripts/main/dist/kinstall.zip")`

Wygląda to tak:

![Screenshot](https://github.com/ktunkiewicz/KillerMUDScripts/blob/master/screenshot.png?raw=true)

Jeżeli masz wyłączone/usunięte alias "run lua code", i powyższy kod nic nie robi, ściągnij tą paczkę: 
https://github.com/ktunkiewicz/KillerMUDScripts/raw/master/dist/kinstall.zip
i zainstaluj ją "tradycyjnie" (czyli albo przeciągając na okno mudleta, albo przez ikonkę "Import" w skryptach)
