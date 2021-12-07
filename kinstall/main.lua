kinstall = kinstall or {}
kinstall.tmpFolder = getMudletHomeDir() .. '/kinstall/tmp'
kinstall.versions = {}
kinstall.modules = {}
kinstall.updateList = {}
kinstall.runList = {}
kinstall.cmdCache = {}
kinstall.autoUpdate = kinstall.autoUpdate or 'y'
kinstall.repoName = 'https://github.com/KillerMUD-pl/MudletScripts'
kinstall.repoPath = 'https://raw.githubusercontent.com/KillerMUD-pl/MudletScripts/main/'
kinstall.readmeLink = "https://github.com/KillerMUD-pl/MudletScripts#komendy"
kinstall.configFile = getMudletHomeDir() .. '/kinstall.config.json'
kinstall.receivingGmcpTimer = kinstall.receivingGmcpTimer or nil
kinstall.receivingGmcp = false
kinstall.gmcpHandler = kinstall.gmcpHandler or nil
kinstall.params = {}
kinstall.duringConfig = false
kinstall.firstGmcpWatch = nil

-- pobiera plik z wersjami pakietow
function kinstall:fetchVersions()
  lfs.mkdir(kinstall.tmpFolder)
  downloadFile(
    kinstall.tmpFolder .. '/modules.json',
    kinstall.repoPath .. 'modules.json'
  )
end

function kinstall:welcomeScreen()
  local moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/kinstall/module.json')
  cecho('\n')
  cecho('<gold>----------------------------------------\n')
  cecho('<gold>KillerMUDScripts <DimGrey>(v.' .. moduleFile.version .. ')\n')
  cecho('<gold>----------------------------------------\n')
  cecho('Skrypty do Killer MUD rozwijane na:\n')
  echoLink(kinstall.repoName, [[ openWebPage(kinstall.repoName) ]], 'Kliknij by otworzyć')
  echo('\n\n')
  cecho('Wpisz <cyan>+config <grey>aby skonfigurować wymagane przez skrypty opcje w grze (musisz być zalogowany/a)\n')
  echo('\n\n')
end

function kinstall:getModuleDotJsonFile(moduleName)
  local path = getMudletHomeDir()
  return kinstall:loadJsonFile(path .. '/' .. moduleName .. '/module.json')
end

-- sprawdzanie wersji zainstalowanych pakietów i odświeżanie informacji o pakietach
function kinstall:checkVersions(filename)
  -- ładowanie pliku modules.json
  if filename == nil and kinstall:fileExists(kinstall.tmpFolder .. '/modules.json') then
    filename = kinstall.tmpFolder .. '/modules.json'
  end
  if filename == nil then
    cecho('<red>Brak pliku modules.json. Uruchom Mudleta ponownie by kinstall ściągnął plik modules.json z githuba.')
    return
  end
  kinstall.versions = kinstall:loadJsonFile(filename)
  -- sprawdzanie systemu plikow w poszukiwaniu pakietów i sprawdzanie ich wersji
  local path = getMudletHomeDir()
  for name in lfs.dir(path) do
    if lfs.attributes(path .. '/' .. name, "mode") == "directory"
    and kinstall:fileExists(path .. '/' .. name .. '/module.json') then
      -- znaleziono moduł na dysku
      local moduleFile = kinstall:getModuleDotJsonFile(name)
      if moduleFile.version ~= nil and moduleFile.name ~= nil then
        local moduleName = moduleFile.name
        -- uruchamianie modulu
        kinstall:initModule(moduleName)
        -- sprawdzanie wersji modułu
        if kinstall.versions[moduleName] ~= nil
        and kinstall.versions[moduleName].version > moduleFile.version then
          -- dodanie do listy modulow do aktualizacji
          kinstall.updateList[moduleName] = kinstall.versions[moduleName]
        end
      end
    end
  end
  -- jesli są jakieś pakiety do zainstalowania, pokaż listę i odnośniki
  local hasUpdates = false
  if next(kinstall.updateList) ~= nil then
    cecho('\n<gold>KILLER - Znaleziono aktualizacje pakietów!\n')
    for moduleName, data in pairs(kinstall.updateList) do
      hasUpdates = true
      local desc = data.shortDesc or '(brak opisu)'
      cecho('- ' .. moduleName .. ': ' .. desc .. ' <DimGrey>(posiadasz wersję: ' .. kinstall.modules[moduleName].version .. ', nowa wersja: ' .. data.version .. ')\n')
    end
  end
  -- auto update
  if hasUpdates == true then
    if kinstall.autoUpdate == 'y' then
      echo('\n')
      kinstall:update()
    else
      cecho('\n<gold>Wpisz <cyan>+update <gold>by zaktualizować pakiety.\n\n')
    end
  end
end

-- listowanie zainstalowanych pakietow
function kinstall:installedModules()
  cecho('\n<gold>Lista włączonych modułów:\n')
  for moduleName, data in pairs(kinstall.modules) do
    local moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/' .. moduleName .. '/module.json')
    cecho('- <gold>' .. moduleFile.name .. ' - <gray>' .. moduleFile.shortDesc)
    cecho('<DimGrey>, wersja: ' .. moduleFile.version .. ', komendy:')
    local cmds = ''
    for _, cmd in ipairs(moduleFile.commands) do
      cmds = cmds .. ', ' .. cmd
    end
    cecho('<DimGrey>' .. utf8.sub(cmds, 2) .. '\n')
  end
end

-- listowanie możliwych do zainstalowanie modułów
function kinstall:availableModules()
  cecho('\n<gold>Dostępne do zainstalowania moduły:\n')
  local count = 0
  for moduleName, data in pairs(kinstall.versions) do
    if kinstall.modules[moduleName] == nil then
      count = count + 1
      cecho('- <gold>' .. moduleName .. ' - <gray>' .. data.shortDesc .. ' ')
      cecho('<DimGrey>wersja: ' .. data.version .. ', komendy:')
      local cmds = ''
      for _, cmd in ipairs(data.commands) do
        cmds = cmds .. '<gray>, <cyan>+' .. cmd
      end
      cecho(utf8.sub(cmds, 8) .. '\n')
    end
  end
  if count == 0 then
    cecho('<DimGrey>Brak dostępnych modułów\n')
  end
end

-- help do kinstall
function kinstall:usageHelp()
  cecho('\n<gold>Komendy:\n')
  cecho('<cyan>+install <grey>- pokazuje zainstalowane i dostępne moduły.\n')
  cecho('<cyan>+install <nazwa_modułu> <grey>- instaluje/uaktualnia moduł.\n')
  cecho('<cyan>+update <grey>- włącza/wyłącza auto-aktualizację modułów.\n')
  cecho('<cyan>+remove <nazwa modułu> - <grey>usuwa wybrany moduł.\n\n')
  cecho('<gray>Pro-tip: wystarczy wydać komendę jednego z dostepnych modułów, np. +map\n')
  cecho('<gray>a odpowiedni moduł zostanie zainstalowany i uruchomiony automatycznie.\n\n')
end

-- sprawdzanie systemu
function kinstall:checkSystem()
  if mudletOlderThan(4, 13) then
    cecho('\n<red>Twoja wersja Mudleta jest starsza niż 4.13.\n')
    cecho('<red>Aby używać skryptów KillerMUDScripts musz zaktualizować Mudleta.\n')
    cecho('<red>Strona z aktualną wersją Mudleta: ')
    echoLink('https://www.mudlet.org/download/', [[ openWebPage('https://www.mudlet.org/download/') ]], 'Kliknij by otworzyć')
    echo('\n\n')
    return false
  end
  return true
end

-- instalowanie czcionek
function kinstall:installFonts()
  if io.exists(getMudletHomeDir() .. '/../../fonts/Marcellus-Regular.ttf') == false then
    unzipAsync(getMudletHomeDir() .. '/kinstall/fonts/Marcellus-Regular.ttf.zip', getMudletHomeDir() .. '/../../fonts')
  end
end

-- update z repozytorium
function kinstall:update()
  for moduleName, _ in pairs(kinstall.updateList) do
    kinstall:fetchAndInstall(moduleName)
  end
end

-- instalowanie z repozytorium
function kinstall:fetchAndInstall(moduleName)
  local beta = false
  if string.ends(moduleName, '-beta') then
    beta = true
  end
  local shortModuleName = moduleName
  if beta == true then
    shortModuleName = utf8.gsub(moduleName, '-beta', '')
  end
  if kinstall.versions[shortModuleName] == nil then
    cecho('<red>Nie znaleziono modułu ' .. shortModuleName .. '\n\n')
    return
  end
  local data = kinstall.versions[shortModuleName]
  local version = data.version
  local url = data.url
  if beta == true then
    version = 'beta'
    url = utf8.gsub(url, shortModuleName, moduleName)
  end
  cecho('<gold>Instalowanie pakietu ' .. shortModuleName .. ' w wersji ' .. version .. ' ... ')
  downloadFile(
    kinstall.tmpFolder .. '/' .. shortModuleName .. '.zip',
    url
  )
end

-- instalowanie z pliku zip
function kinstall:install(filename)
  local name = filename:match("([^/]+).zip$")
  unzipAsync(filename, getMudletHomeDir() .. '/' .. name)
end

-- uruchamianie pakietu
function kinstall:initModule(moduleName)
  if moduleName == 'kinstall' then
    return
  end
  local moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/' .. moduleName .. '/module.json')
  if moduleFile.name == nil then
    cecho('<red>Nie udało się załadować modułu ' .. moduleName .. '. Brak pliku lub niepoprawny module.json w module.\n')
    return
  end
  kinstall.modules[moduleFile.name] = moduleFile
  -- cache komend
  if type(moduleFile.commands) == 'table' then
    for _, cmd in ipairs(moduleFile.commands) do
      kinstall.cmdCache[cmd] = moduleFile.name
    end
  end
  -- uruchamianie skryptu
  local _, err = pcall(function()
    kinstall:require(moduleFile.name .. '/main')
    if _G[moduleFile.name] ~= nil and _G[moduleFile.name]['doInit'] ~= nil then
      tempTimer(0, function()
        kinstall.params[1] = 'silent'
        _G[moduleFile.name]['doInit']()
      end)
    end
  end)
  if err ~= nil then
    display({"kinstall:initModule", moduleName, err})
  end
end

-- KOMENDY

function kinstall:doInstall()
  local param = kinstall.params[1]
  if param == nil or string.trim(param) == '' then
    kinstall:installedModules()
    kinstall:availableModules()
    kinstall:usageHelp()
    return
  end
  kinstall:fetchAndInstall(param)
end

function kinstall:doUpdate()
  local param = kinstall.params[1]
  if param == "" then
    cecho('<gold>Sprawdzam aktualizacje. Jeśli coś znajdę, zainstaluje je automatycznie.\n\n')
    kinstall:fetchVersions()
    return
  end
  if param == 'off' then
    kinstall.autoUpdate = 'n'
    cecho('<gold>Wyłączono auto-aktualizację\n\n')
  else
    kinstall.autoUpdate = 'y'
    cecho('<gold>Włączono auto-aktualizację\n\n')
  end
end

function kinstall:doRemove()
  local param = kinstall.params[1]
  if param == nil or string.trim(param) == '' then
    cecho('<red>Podaj nazwę moduł do usunięcia.\n\n')
    return
  end
  if string.trim(param) == 'kinstall' then
    cecho('<red>Nie możesz odinstalować instalatora...\n\n')
    return
  end
  if kinstall.modules[param] == nil then
    cecho('<red>Moduł ' .. param .. ' nie jest zainstalowany.\n\n')
    return
  end
  if _G[param] ~= nil and _G[param]['doUninstall'] ~= nil then
    local func = _G[param]['doUninstall']
    local _, err = pcall(func)
    if err ~= nil then
      cecho('<red>Wystąpił błąd przy usuwaniu modułu ' .. param .. '.\n\n')
      return
    end
  end
  _G[param] = nil
  kinstall.modules[param] = nil
  kinstall:removeDir(getMudletHomeDir() .. '/' .. param)
  cecho('<gold>Usunięto moduł ' .. param .. '.\n\n')
end

function kinstall:setMudletEncodingIso()
  tempTimer(0.9, [[ cecho('\n<gold>Ustawiam kodowanie ISO-8859-2 w Mudlecie.\n\n') ]])
  setServerEncoding('ISO 8859-2')
end

function kinstall:setMudletEncodingWin()
  tempTimer(0.9, [[ cecho('\n<gold>Ustawiam kodowanie WINDOWS-1250 w Mudlecie.\n\n' ]])
  setServerEncoding('WINDOWS-1250')
end

function kinstall:welcomePartTwo()
  cecho('\n<gold>Wszystko powinno już działać jak należy!\n\n')
  cecho('Wpisz <cyan>+gui <grey>aby włączyć wszystkie dostępne panele.\n\n')
  cecho('<dim_gray>Panele można przesuwać, niektóre z nich obsługują także zmianę rozmiaru.\n')
  cecho('<dim_gray>Dostępne są prawy i lewy slot, oraz przyciąganie do góry lub do dołu. Użyj ikonek na pasku panelu by dostosować ich położenie.\n')
  cecho('<dim_gray>Niektóre panele można też przypinać do dolnego slotu, tuż nad linią poleceń, służy do tego ikonka z symbolem "podkreślnika".\n')
  cecho('<dim_gray>Panele można także zamknąć. Mudlet będzie pamiętał ustawienie paneli.".\n\n')
  cecho('<dim_gray>Jeżeli coś pójdzie nie tak, użyj komendy <gray>+reset<dim_gray> by zresetować ułożenie okien.\n\n')
  cecho('<dim_gray>Pełna lista instrukcji i możliwości poszczególnych paneli dostępna jest tutaj:\n')
  cechoLink('<gray>' .. kinstall.readmeLink, [[ openWebPage(kinstall.readmeLink) ]], 'Kliknij by otworzyć')
  echo('\n\n')
end

function kinstall:doConfig()
  local param = kinstall.params[1]
  if param ~= "tak" and string.starts(line, '<') == false then
    cecho('\n<gold>Wygląda na to że nie jesteś zalogowany do gry. Zaloguj się i poczekaj aż skrypt automatycznie wykona komendę "config"\n')
    cecho('<dim_gray>Jeżeli jesteś zalogowany, a po prostu nie udało mi się wykryć Twojego prompta, wpisz <gray>+config tak\n')
    cecho('<dim_gray>Zalecane jest używanie < jako pierwszego znaku prompta, bez tego niektóre funkcje którą wymagają wykrywania prompta mogą nie działać poprawnie\n\n')
    echo(line .. '\n')
    tempRegexTrigger("^<", kinstall.doConfig, 1)
    return
  end
  tempRegexTrigger('^gmcp\\s+\\[-\\]', [[ send('config gmcp') ]], 1)
  tempRegexTrigger('^Standard kodowania polskich liter: ISO-8859-2\\.', kinstall.setMudletEncodingIso, 1)
  tempRegexTrigger('^Standard kodowania polskich liter: CP-1250 \\(Windows\\)\\.', kinstall.setMudletEncodingWin, 1)
  if kinstall.receivingGmcp == false then
    if kinstall.firstGmcpWatch then killAnonymousEventHandler(kinstall.firstGmcpWatch) end
    kinstall.firstGmcpWatch = registerAnonymousEventHandler("gmcp.Char", function()
      tempTimer(1.1, [[ kinstall:welcomePartTwo() ]])
      killAnonymousEventHandler(kinstall.firstGmcpWatch)
    end)
  else
    tempTimer(0.5, [[ kinstall:welcomePartTwo() ]])
  end
  send('config')
end

function kinstall:doGui()
  local param = kinstall.params[1]
  if param == 'font' then
    local size = kinstall.params[2]
    if tonumber(size) < 10 then
      cecho('<red>Czcionka używana w skryptach nie obsługuje rozmiarów mniejszych niż 10\n')
      return
    end
    kinstall:setConfig('fontSize', tonumber(size))
    kgui:init()
    kinstall:checkVersions()
    return
  end

  cecho('<gold>Właczam GUI\n\n')
  tempTimer(0.5, function() kinstall:runCmd('+', 'map', true) end)
  tempTimer(0.6, function() kinstall:runCmd('+', 'info', true) end)
  tempTimer(0.7, function() kinstall:runCmd('+', 'group', true) end)
  tempTimer(0.8, function() kinstall:runCmd('+', 'chat', true) end)
end

function kinstall:undoGui()
  cecho('<gold>Wyłaczam GUI\n\n')
  tempTimer(0.4, function() kinstall:runCmd('-', 'chat', true) end)
  tempTimer(0.5, function() kinstall:runCmd('-', 'group', true) end)
  tempTimer(0.6, function() kinstall:runCmd('-', 'info', true) end)
  tempTimer(0.7, function() kinstall:runCmd('-', 'map', true) end)
end

function kinstall:doReset()
  cecho('\n<gold>Resetuje ustawienia\n\n')
  local poi = kinstall:getConfig('poi', nil)
  os.remove(kinstall.configFile)
  os.remove(kgui.settingsFile)
  kinstall:setConfig('poi', poi)
  resetProfile()
  raiseEvent("kinstallInit")
  tempTimer(0.5, function() kinstall:runCmd('+', 'gui', true) end)
end

function kinstall:runCmd(mode, cmd, isAutoRun)
  local params = {}
  params[1], params[2] = cmd:match("(%w+)(.*)")
  if params[2] == '' and isAutoRun == true then
    params[2] = 'silent'
  end
  -- sprawdzanie czy plus-komenda nalezy do modulu
  local moduleName = kinstall.cmdCache[params[1]]
  if moduleName ~= nil then
    if kinstall.modules[moduleName] == nil then
      cecho('<red>Coś jest nie tak z listą załadowanych mudułów... Uruchom Mudleta ponownie.')
      return
    end
    local funcName = string.title(params[1])
    local prefix = mode == '-' and 'undo' or 'do'
    if (_G[moduleName] == nil or _G[moduleName][prefix .. funcName] == nil) then
      cecho('<red>Coś jest nie tak z modułem... Powinien obsługiwać komendę ' .. mode .. cmd .. ' jednak brakuje mu tej funkcji.\n')
      return
    end
    local func = _G[moduleName][prefix .. funcName]
    kinstall.params = string.trim(params[2]):split(' ')
    local _, err = pcall(func)
    if err ~= nil then
      display({"kinstall:runCmd", mode, cmd, isAutoRun, err})
    end
    kgui:saveState()
  else
    local foundModule = nil
    for name, data in pairs(kinstall.versions) do
      if table.contains(data.commands, params[1]) then
        foundModule = name
      end
    end
    if foundModule then
      kinstall.runList[foundModule] = {mode = mode, cmd = cmd }
      kinstall:fetchAndInstall(foundModule)
    else
      cecho('<gold>Nie znam takiej komendy.\n')
    end
  end
end

-- HANDLERY

-- handler eventu kinstallLoaded
function kinstall:kinstallLoaded(_, filename)
  if kinstall:checkSystem() == true then
    local moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/kinstall/module.json')
    kinstall.modules[moduleFile.name] = moduleFile
    for _, cmd in ipairs(moduleFile.commands) do
      kinstall.cmdCache[cmd] = moduleFile.name
    end
    if kinstall:getConfig('welcomed') ~= true then
      kinstall:setConfig('welcomed', true)
      kinstall:welcomeScreen()
    else
      cecho('<goldenrod>[ KILLER ] - Sprawdzanie aktualizacji w tle.\n')
    end
    if kinstall:getConfig('fontsInstalled') ~= true then
      kinstall:setConfig('fontsInstalled', true)
      kinstall:installFonts()
    end
    if table.contains(getModules(),"generic_mapper") then
      uninstallModule('generic_mapper')
    end
    if table.contains(getPackages(),"generic_mapper") then
      uninstallPackage('generic_mapper')
    end
    kinstall:fetchVersions()
    -- załącza kod od gui
    kinstall:require('kinstall/gui')
    kinstall:require('kinstall/adjustable2')

    if kinstall.gmcpHandler then killAnonymousEventHandler(kinstall.gmcpHandler) end
    kinstall.gmcpHandler = registerAnonymousEventHandler("gmcp.Char", function()
      kinstall.receivingGmcp = true
      kinstall:restartGmcpWatch()
    end)
    kgui:init()
  end
end
if kinstall.kinstallLoadedId ~= nil then killAnonymousEventHandler(kinstall.kinstallLoadedId) end
kinstall.kinstallLoadedId = registerAnonymousEventHandler("kinstallLoaded", "kinstall:kinstallLoaded", false)

-- handler eventu sysDownloadDone
function kinstall:sysDownloadDone(_, filename)
  if string.ends(filename, '/modules.json') then
    kinstall:checkVersions(filename)
  end
  local name = filename:match("([^/]+).zip$")
  if kinstall.versions[name] ~= nil then
    kinstall:install(filename)
  end
end
if kinstall.sysDownloadDoneId ~= nil then killAnonymousEventHandler(kinstall.sysDownloadDoneId) end
kinstall.sysDownloadDoneId = registerAnonymousEventHandler("sysDownloadDone", "kinstall:sysDownloadDone", false)

-- handler eventu sysDownloadError
function kinstall:sysDownloadError(_, error)
  if error == 'failureToWriteLocalFile' then
    cecho('<red>Mudlet nie może zapisać na dysk ściągniętego plik! Spróbuj uruchomić go ponownie.\n\n')
    return
  end
  if utf8.find(error, '/modules.json') ~= nil then
    cecho('<red>Mudlet nie może ściągnąć pliku z repozytorium!\nSprawdź czy repozytorium istnieje i spróbuj uruchomić Mudleta ponownie.\n')
    cecho('<red>Link do repozytorium: ')
    echoLink(kinstall.repoName, [[ openWebPage(kinstall.repoName) ]], 'Kliknij by otworzyć')
    echo('\n\n')
    return
  end
  cecho('<red>Nieoczekiwany błąd przy ściąganiu pliku!\n')
  display({"sysDownloadError", _, error})
end
if kinstall.sysDownloadErrorId ~= nil then killAnonymousEventHandler(kinstall.sysDownloadErrorId) end
kinstall.sysDownloadErrorId = registerAnonymousEventHandler("sysDownloadError", "kinstall:sysDownloadError", false)

-- handler eventu sysUnzipDone
function kinstall:sysUnzipDone(_, filename)
  local name = filename:match("(k[^/]+).zip$")
  if name == nil or name == '' then return end
  cecho('<green>zainstalowano.\n\n')
  kinstall:initModule(name)
  if name == 'kinstall' then
    tempTimer(1, function() raiseEvent('kinstallInit') end)
    return
  end
  if _G[name] ~= nil and _G[name]['doInstall'] ~= nil then
    local func = _G[name]['doInstall']
    local _, err = pcall(func)
    if err ~= nil then
      cecho('<red>Wystąpił błąd przy instalowaniu modułu ' .. name .. '.\n\n')
      display({"sysDownloadError", _, filename})
      return
    end
  end
  -- sprawdzanie czy komenda ze skryptu powinna byc natychmiast odpalona
  if kinstall.runList[name] ~= nil then
    tempTimer(0, function()
      kinstall:runCmd(kinstall.runList[name].mode, kinstall.runList[name].cmd, true)
      kinstall.runList[name] = nil
    end)
  end
end
if kinstall.sysUnzipDoneId ~= nil then killAnonymousEventHandler(kinstall.sysUnzipDoneId) end
kinstall.sysUnzipDoneId = registerAnonymousEventHandler("sysUnzipDone", "kinstall:sysUnzipDone", false)

-- handler eventu sysUnzipError
function kinstall:sysUnzipError(_, filename)
  local name = filename:match("([^/]+).zip$")
  cecho('<red>Nie udało się rozpakować modułu ' .. name .. '!\n')
end
if kinstall.sysUnzipErrorId ~= nil then killAnonymousEventHandler(kinstall.sysUnzipErrorId) end
kinstall.sysUnzipErrorId = registerAnonymousEventHandler("sysUnzipError", "kinstall:sysUnzipError", false)

-- odświeżanie timera pilnującego GMCP
function kinstall:restartGmcpWatch()
  if kinstall.receivingGmcpTimer ~= nil then killTimer(kinstall.receivingGmcpTimer) end
  kinstall.receivingGmcpTimer = tempTimer(3, function()
    kinstall.receivingGmcp = false
  end)
end

-- ALIASY

-- przechwytywanie komend "+" i "-"
function kinstall:catchAlias()
  local mode = matches[2]
  local cmd = matches[3]
  kinstall:runCmd(mode, cmd, false)
end
if kinstall.catchAliasId ~= nil then killAlias(kinstall.catchAliasId) end
kinstall.catchAliasId = tempAlias("^(\\+|-)(.+)$", [[ kinstall:catchAlias() ]])

-- NARZĘDZIA

function kinstall:fileExists(filename)
  local f = io.open(filename, "rb")
  if f then f:close() end
  return f ~= nil
end

function kinstall:loadJsonFile(filename)
  if not kinstall:fileExists(filename) then return {} end
  local lines = ''
  for line in io.lines(filename) do
    lines = lines .. line .. '\n'
  end
  return yajl.to_value(lines)
end

function kinstall:saveJsonFile(filename, value)
  local file = io.open(filename, "w")
  if file then
    local contents = yajl.to_string(value)
    file:write( contents )
    io.close( file )
    return true
  else
    return false
  end
end

function kinstall:removeDir(dir)
  for file in lfs.dir(dir) do
    local file_path = dir..'/'..file
    if file ~= "." and file ~= ".." then
        if lfs.attributes(file_path, 'mode') == 'file' then
            os.remove(file_path)
        elseif lfs.attributes(file_path, 'mode') == 'directory' then
            kinstall:removeDir(file_path)
        end
    end
  end
  lfs.rmdir(dir)
end

function kinstall:getConfig(name, default)
  if default == nil then
    default = false
  end
  local config = kinstall:loadJsonFile(kinstall.configFile)
  if config[name] ~= nil then
    return config[name]
  else
    kinstall:setConfig(name, default)
    return default
  end
end

function kinstall:setConfig(name, value)
  local config = kinstall:loadJsonFile(kinstall.configFile)
  config[name] = value
  kinstall:saveJsonFile(kinstall.configFile, config)
end

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = utf8.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, utf8.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = utf8.find( self, delimiter, from  )
  end
  table.insert( result, utf8.sub( self, from  ) )
  return result
end

-- porównuje dwa stringi, ale tylko najkrótszą wspólną część na początku, ignorując wielkość znaków i ogonki
function string:areLooselySame(aStr, bStr)
  local a = string.trim(strip_accents(string.lower(aStr)))
  local b = string.trim(strip_accents(string.lower(bStr)))
  local width = string.len(a)
  if string.len(b) < width then
    width = string.len(b)
  end
  a = string.cut(a, width)
  b = string.cut(b, width)
  return a == b
end

function kinstall:require(moduleName)
  package.loaded[moduleName] = nil
  require(moduleName)
end
