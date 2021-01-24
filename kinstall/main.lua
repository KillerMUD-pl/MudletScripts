kinstall = kinstall or {}
kinstall.version = 1
kinstall.tmpFolder = getMudletHomeDir() .. '/kinstall/tmp'
kinstall.versions = {}
kinstall.modules = {}
kinstall.updateList = {}
kinstall.cmdCache = {}
kinstall.autoUpdate = kinstall.autoUpdate or 'n'
kinstall.repoName = 'https://www.mudlet.org/download';
kinstall.repoPath = 'https://raw.githubusercontent.com/ktunkiewicz/KillerMUDScripts/main/';

-- załącza kod od gui
package.loaded['kinstall/gui'] = nil
require('kinstall/gui')

-- pobiera plik z wersjami pakietow
function kinstall:fetchVersions()
  lfs.mkdir(kinstall.tmpFolder)
  downloadFile(
    kinstall.tmpFolder .. '/modules.json',
    kinstall.repoPath .. 'modules.json'
  )
end

function kinstall:welcomeScreen()
  cecho('\n')
  cecho('<gold>----------------------------------------\n')
  cecho('<gold>KillerMUDScripts <DimGrey>(v.' .. kinstall.version .. ')\n')
  cecho('<gold>----------------------------------------\n')
  cecho('Skrypty do Killer MUD rozwijane na:\n')
  echoLink(kinstall.repoName, [[ openWebPage(kinstall.repoName) ]], 'Kliknij by otworzyć')
  echo('\n\n')
  cecho('Wpisz <cyan>+install <grey>by zobaczyć dostępne moduły.\n')
  echo('\n\n')
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
  -- sprawdzanie zmiennych globalnych
  for moduleName, data in pairs(kinstall.versions) do
    local checkedMod = _G[moduleName];
    if checkedMod ~= nil then
      if checkedMod.version == nil or not tonumber(checkedMod.version) then
        -- UWAGA! zmienna globalna o nazwie takiej jak w versions jest używana
        -- co najprawdopodobniej oznacza stary skrypt mappera
        -- Wywalamy fatal error!
        kinstall.state = 'error'
        cecho('<red>\nUWAGA! Pakiet kinstall wykrył że zmienna globalna "' .. moduleName .. '" już istnieje,\n')
        cecho('<red>i nie jest ona modułem zgodnym z kinstall. Najprawdopodobniej masz\n')
        cecho('<red>zainstalowany stary skrypt mappera, bądź inny skrypt który używa\n')
        cecho('<red>takiej zmiennej.\n\n')
        cecho('<red>Zalecam usunięcie wszystkich skryptów które używają zmiennych globalnych\n')
        cecho('<red>zaczynających się na małe "k", typu "kmap" itd.\n\n')
        cecho('<red>NIE KORZYSTAJ z komend +<tekst> do czasu usunięcia tych skryptów.\n\n')
        cecho('<red>Stary pakiet "kmap" jest teraz częścią kinstall, instaluje się go wydając \n')
        cecho('<red>komendę "+map".\n\n')
        _G[moduleName] = nil
      end
    end
  end
  -- sprawdzanie systemu plikow w poszukiwaniu pakietów i sprawdzanie ich wersji
  local path = getMudletHomeDir()
  for name in lfs.dir(path) do
    if lfs.attributes(path .. '/' .. name, "mode") == "directory"
    and kinstall:fileExists(path .. '/' .. name .. '/module.json') then
      -- znaleziono moduł na dysku
      moduleFile = kinstall:loadJsonFile(path .. '/' .. name .. '/module.json')
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
    cecho('\n<gold>Znaleziono aktualizacje pakietów!\n')
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
    moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/' .. moduleName .. '/module.json')
    cecho('- <gold>' .. moduleFile.name .. ' - <gray>' .. moduleFile.shortDesc)
    cecho('<DimGrey>, wersja: ' .. moduleFile.version .. ', komendy:')
    local cmds = '';
    for _, cmd in ipairs(moduleFile.commands) do
      cmds = cmds .. ', ' .. cmd
    end
    cecho('<DimGrey>' .. string.sub(cmds, 2) .. '\n')
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
      local cmds = '';
      for _, cmd in ipairs(data.commands) do
        cmds = cmds .. ', ' .. cmd
      end
      cecho('<DimGrey>' .. string.sub(cmds, 2) .. '\n')
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
  if mudletOlderThan(4, 10, 1) then
    cecho('<red>Twoja wersja Mudleta jest starsza niż 4.10.1.\n')
    cecho('<red>Aby używać skryptów KillerMUDScripts musz zaktualizować Mudleta.\n')
    cecho('<red>Strona z aktualną wersją Mudleta: ')
    echoLink('https://www.mudlet.org/download/', [[ openWebPage('https://www.mudlet.org/download/') ]], 'Kliknij by otworzyć')
    echo('\n\n')
    return false
  end
  return true
end

-- update z repozytorium
function kinstall:update()
  for moduleName, _ in pairs(kinstall.updateList) do
    kinstall:fetchAndInstall(moduleName)
  end
end

-- instalowanie z repozytorium
function kinstall:fetchAndInstall(moduleName)
  if kinstall.versions[moduleName] == nil then
    cecho('<red>Nie znaleziono modułu ' .. moduleName .. '\n\n')
    return
  end
  data = kinstall.versions[moduleName]
  cecho('<gold>Instalowanie pakietu ' .. moduleName .. ' w wersji ' .. kinstall.versions[moduleName].version .. ' ... ')
  downloadFile(
    kinstall.tmpFolder .. '/' .. moduleName .. '.zip',
    data.url
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
  moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/' .. moduleName .. '/module.json')
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
    package.loaded[moduleFile.name .. '/main'] = nil
    require(moduleFile.name .. '/main')
  end)
  if err ~= nil then
    display(err)
  end
end

-- KOMENDY

kinstall.doInstall = function(param)
  if param == nil or string.trim(param) == '' then
    kinstall:installedModules()
    kinstall:availableModules()
    kinstall:usageHelp()
    return
  end
  kinstall:fetchAndInstall(param)
end

kinstall.doUpdate = function(param)
  if kinstall.autoUpdate == 'n' then
    kinstall.autoUpdate = 'y'
    cecho('<gold>Włączono auto-aktualizację\n\n')
  else
    kinstall.autoUpdate = 'n'
    cecho('<gold>Wyłączono auto-aktualizację\n\n')
  end
end

kinstall.doRemove = function(param)
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
      display(err)
      return
    end
  end
  _G[param] = nil
  kinstall.modules[param] = nil
  kinstall:removeDir(getMudletHomeDir() .. '/' .. param)
  cecho('<gold>Usunięto moduł ' .. param .. '.\n\n')
end

-- HANDLERY

-- handler eventu kinstallLoaded
function kinstall:kinstallLoaded(_, filename)
  if kinstall:checkSystem() == true then
    moduleFile = kinstall:loadJsonFile(getMudletHomeDir() .. '/kinstall/module.json')
    kinstall.modules[moduleFile.name] = moduleFile
    for _, cmd in ipairs(moduleFile.commands) do
      kinstall.cmdCache[cmd] = moduleFile.name
    end
    if kinstall:fileExists(getMudletHomeDir() .. "/kinstallInstalled.txt") == false then
      file = io.open(getMudletHomeDir() .. "/kinstallInstalled.txt", "w")
      file:write('1')
      file:close()
      kinstall:welcomeScreen()
    end
    kinstall:fetchVersions()
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
  if string.find(error, '/modules.json') ~= nil then
    cecho('<red>Mudlet nie może ściągnąć pliku z repozytorium!\nSprawdź czy repozytorium istnieje i spróbuj uruchomić Mudleta ponownie.\n')
    cecho('<red>Link do repozytorium: ')
    echoLink(kinstall.repoName, [[ openWebPage(kinstall.repoName) ]], 'Kliknij by otworzyć')
    echo('\n\n')
    return
  end
  cecho('<red>Nieoczekiwany błąd przy ściąganiu pliku!\n')
  display(error)
end
if kinstall.sysDownloadErrorId ~= nil then killAnonymousEventHandler(kinstall.sysDownloadErrorId) end
kinstall.sysDownloadErrorId = registerAnonymousEventHandler("sysDownloadError", "kinstall:sysDownloadError", false)

-- handler eventu sysUnzipDone
function kinstall:sysUnzipDone(_, filename)
  local name = filename:match("([^/]+).zip$")
  cecho('<green>zainstalowano.\n\n')
  kinstall:initModule(name)
end
if kinstall.sysUnzipDoneId ~= nil then killAnonymousEventHandler(kinstall.sysUnzipDoneId) end
kinstall.sysUnzipDoneId = registerAnonymousEventHandler("sysUnzipDone", "kinstall:sysUnzipDone", false)

-- handler eventu sysUnzipDone
function kinstall:sysUnzipError(_, filename)
  local name = filename:match("([^/]+).zip$")
  cecho('<red>Nie udało się rozpakować modułu ' .. name .. '!\n')
end
if kinstall.sysUnzipErrorId ~= nil then killAnonymousEventHandler(kinstall.sysUnzipErrorId) end
kinstall.sysUnzipErrorId = registerAnonymousEventHandler("sysUnzipError", "kinstall:sysUnzipError", false)

-- ALIASY

-- przechwytywanie komend "+" i "-"
function kinstall:catchAlias()
  local mode = matches[2]
  local cmd = matches[3]
  local params = {}
  params[1], params[2] = cmd:match("(%w+)(.*)")
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
      cecho('<red>Coś jest nie tak z modułem... Powinien obsługiwać komendę ' .. mode .. cmd .. ' jednak brakuje mu tej funkcji.\n;')
      return
    end
    local func = _G[moduleName][prefix .. funcName]
    local _, err = pcall(func, string.trim(params[2]))
    if err ~= nil then
      display(err)
    end
  else
    cecho('<yellow>Nie zaimplementowane.\n')
  end
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
  lines = ''
  for line in io.lines(filename) do
    lines = lines .. line .. '\n'
  end
  return yajl.to_value(lines)
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