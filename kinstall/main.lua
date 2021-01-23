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

-- pobiera plik z wersjami pakietow
function kinstall:fetchVersions()
  lfs.mkdir(kinstall.tmpFolder)
  downloadFile(
    kinstall.tmpFolder .. '/modules.json',
    kinstall.repoPath .. 'modules.json'
  )
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
        -- dodawanie do listy włączonych modułow i uzupełnienie cache komend
        kinstall.modules[moduleName] = moduleFile
        if type(moduleFile.commands) == 'table' then
          for _, cmd in ipairs(moduleFile.commands) do
            kinstall.cmdCache[cmd] = moduleName
          end
        end
        -- sprawdzanie wersji modułu
        if kinstall.versions[moduleName] ~= nil
        and kinstall.versions[moduleName].version > moduleFile.version then
          kinstall.updateList[moduleName] = kinstall.versions[moduleName]
        end
      end
    end
  end
  -- jesli są jakieś pakiety do zainstalowania, pokaż listę i odnośniki
  local hasUpdates = false
  if next(kinstall.updateList) ~= nil then
    cecho('\n<yellow>Znaleziono aktualizacje pakietów!\n')
    for moduleName, data in pairs(kinstall.updateList) do
      hasUpdates = true
      local desc = data.shortDesc or '(brak opisu)'
      cecho('- ' .. moduleName .. ': ' .. desc .. ' <DimGrey>(posiadasz wersję: ' .. kinstall.modules[moduleName].version .. ', nowa wersja: ' .. data.version .. ')\n')
    end
  end
  -- auto update
  if hasUpdates == true and kinstall.autoUpdate == 'y' then
    kinstall:update()
  else
    cecho('\n<yellow>Wpisz <cyan>+update <yellow>by zaktualizować pakiety.\n\n')
  end
end

-- sprawdzanie systemu
function kinstall:checkSystem()
  if mudletOlderThan(4, 10, 1) then
    cecho('<red>Twoja wersja Mudleta jest starsza niż 4.10.1.\n')
    cecho('<red>Aby używać skryptów KillerMUDScripts musz zaktualizować Mudleta.\n')
    cecho('<red>Strona z aktualną wersją Mudleta: ')
    echoLink(kinstall.repoName, [[ openWebPage(kinstall.repoName) ]], 'Kliknij by otworzyć')
    echo('\n\n')
    return false
  end
  return true
end

-- update z repozytorium
function kinstall:update()
  for moduleName, data in pairs(kinstall.updateList) do
    downloadFile(
      kinstall.tmpFolder .. '/' .. moduleName .. '.zip',
      kinstall.repoPath .. moduleName .. '/' .. moduleName .. '.zip'
    )
  end
end

-- instalowanie z repozytorium
function kinstall:install(filename)
  local name = filename:match("([^/]+).zip$")
  unzipAsync(filename, getMudletHomeDir() .. '/' .. name)
end

-- HANDLERY

-- handler eventu sysDownloadDone
function kinstall:sysDownloadDone(_, filename)
  if string.ends(filename, '/modules.json') then
    kinstall:checkVersions(filename)
  end
  if string.ends(filename, '.zip') and string.starts(filename, kinstall.tmpFolder) then
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
    echoLink('https://github.com/ktunkiewicz/KillerMUDScripts', [[ openWebPage('https://github.com/ktunkiewicz/KillerMUDScripts') ]], 'Kliknij by otworzyć')
    echo('\n\n')
    return
  end
  cecho('<red>Nieoczekiwany błąd przy ściąganiu pliku!\n')
  display(error)
end
if kinstall.sysDownloadErrorId ~= nil then killAnonymousEventHandler(kinstall.sysDownloadErrorId) end
kinstall.sysDownloadErrorId = registerAnonymousEventHandler("sysDownloadError", "kinstall:sysDownloadError", false)

-- handler eventu sysLuaInstallModule
function kinstall:sysLuaInstallModule(_, module)
  display(module)
end
if kinstall.sysLuaInstallModuleId ~= nil then killAnonymousEventHandler(kinstall.sysLuaInstallModuleId) end
kinstall.sysLuaInstallModuleId = registerAnonymousEventHandler("sysLuaInstallModule", "kinstall:sysLuaInstallModule", false)

-- handler eventu sysLuaInstallModule
function kinstall:sysLuaUninstallModule(_, module)
  display(module)
end
if kinstall.sysLuaUninstallModuleId ~= nil then killAnonymousEventHandler(kinstall.sysLuaUninstallModuleId) end
kinstall.sysLuaUninstallModuleId = registerAnonymousEventHandler("sysLuaUninstallModule", "kinstall:sysLuaUninstallModule", false)

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
