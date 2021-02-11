# KillerMUDScripts

Skrypty do Killer MUDa.

Aktualna lista:
- kmap - moduł mapy

Wpisz tą komendę do Mudleta aby zainstalować:

```
lua function d(a,b) installPackage(b)os.remove(b) end registerAnonymousEventHandler("sysDownloadDone","d",true)downloadFile(getMudletHomeDir().."/kinstall.zip","https://raw.githubusercontent.com/ktunkiewicz/KillerMUDScripts/main/dist/kinstall.zip")
```

**Zaznacz całą linię od początku do końca, skopiuj, wklej do linii poleceń w Mudlecie i wciśnij enter**

Ta metoda zakłada że nie usunąłeś/aś domyślnie zainstalowanego w Mudlecie skryptu "run-lua-code". Jeśli go nie posiadasz, przewiń poniżej następnego obrazka, by zobaczyć drugą metodę.

Po wpisaniu komendy, ekran w mudlecie powinien wyglądać podobnie do tego:

![Screenshot](https://github.com/ktunkiewicz/KillerMUDScripts/blob/master/screenshot.png?raw=true)

Jeżeli masz wyłączone/usunięte alias "run-lua-code", i powyższy kod nic nie robi, ściągnij tą paczkę: 
https://github.com/ktunkiewicz/KillerMUDScripts/raw/master/dist/kinstall.zip
i zainstaluj ją "tradycyjnie" (czyli albo przeciągając na okno mudleta, albo przez ikonkę "Import" w skryptach).

Pamiętaj żeby **nie zmienić nazwy ściągniętego pliku**, tzn. plik po ściągnięciu musi się nazywać `kinstall.zip` a nie naprzykład `kinstall (1).zip` albo `kinstall Kopia.zip`
