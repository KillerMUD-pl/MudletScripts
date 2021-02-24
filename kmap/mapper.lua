module("kinstall/mapper", package.seeall)
setfenv(1, getfenv(2));

-- globalne zmienne
kmapper = kmapper or {}
kmapper.previousRoom = kmapper.previousRoom or {}
kmapper.previousRoom.num = 0;
kmapper.ids = kmapper.ids or {}
kmapper.mapping = false
kmapper.cmdQueue = {}
kmapper.runningCmd = false
kmapper.targetRoomId = nil
kmapper.originatingRoomId = nil
kmapper.originatingExit = nil
kmapper.askingForDirection = false
kmapper.selectedDir = nil
kmapper.step = 2
kmapper.msgBox = nil

kmapper.dirTable = {}
kmapper.dirTable['north'] = 'n'
kmapper.dirTable['south'] = 's'
kmapper.dirTable['west'] = 'w'
kmapper.dirTable['east'] = 'e'
kmapper.dirTable['southeast'] = 'se'
kmapper.dirTable['southwest'] = 'sw'
kmapper.dirTable['northeast'] = 'ne'
kmapper.dirTable['northwest'] = 'nw'

kmapper.dirOpposite = {}
kmapper.dirOpposite['n'] = 's'
kmapper.dirOpposite['s'] = 'n'
kmapper.dirOpposite['w'] = 'e'
kmapper.dirOpposite['e'] = 'w'
kmapper.dirOpposite['u'] = 'd'
kmapper.dirOpposite['d'] = 'u'
kmapper.dirOpposite['nw'] = 'se'
kmapper.dirOpposite['ne'] = 'sw'
kmapper.dirOpposite['sw'] = 'ne'
kmapper.dirOpposite['se'] = 'nw'

kmapper.labelMap = {}

--
-- Sprawdza czy string jest nazwą kierunku. Potrzebne do wykrywania metadanych kierunków w UserData
--
function kmapper:isDirName(text)
  local t = utf8.lower(text)
  if t == 'n' or t == 's'
  or t == 'w' or t == 'e'
  or t == 'nw' or t == 'ne'
  or t == 'sw' or t == 'se'
  or t == 'u' or t == 'd'
  then
    return true
  end
  return false
end

--
-- Sprawdza czy w meta roomu jest wyjscie do roomu o danym id
--
function kmapper:checkIfMetaExitExists(fromId, toId)
  local meta = getAllRoomUserData(fromId)
  for dir, valueStr in pairs(meta) do
    if valueStr ~= 'block' and kmapper:isDirName(dir) then
      local value = yajl.to_value(valueStr)
      if tonumber(value.id) == toId then
        return true
      end
    end
  end
  return false
end

--
-- tworzenie nowego roomu
-- ta komenda uruchamia sie juz PO przejsciu do nowego, prawdopodobnie nie zmapowanego roomu
--
function kmapper:createNewRoom()
  if kmapper.askingForDirection == true then
    return
  end
  local areaId = -1
  if kmapper.originatingRoomId ~= nil then
    areaId = getRoomArea(getPlayerRoom())
  end
  
  -- jesli room nie jest zmapowany, tworzymy go
  local targetRoomId = kmap.vnumToRoomIdCache[gmcp.Room.Info.num]
  local isNewRoom = targetRoomId == nil or not roomExists(targetRoomId)

  if isNewRoom == true then
    targetRoomId = createRoomID()
    addRoom(targetRoomId)
    setRoomArea(targetRoomId, areaId)
  end

  local selectedDir = utf8.lower(kmapper.originatingExit.dir)

  -- jesli przeszlismy do roomu przez wyjscie, ustawiamy przejscia standardowe
  if kmapper.originatingExit ~= nil then
    if selectedDir == 'n' then
      setExit(kmapper.originatingRoomId, targetRoomId, 'n')
      setExit(targetRoomId, kmapper.originatingRoomId, 's')
    end
    if selectedDir == 's' then
      setExit(kmapper.originatingRoomId, targetRoomId, 's')
      setExit(targetRoomId, kmapper.originatingRoomId, 'n')
    end
    if selectedDir == 'w' then
      setExit(kmapper.originatingRoomId, targetRoomId, 'w')
      setExit(targetRoomId, kmapper.originatingRoomId, 'e')
    end
    if selectedDir == 'e' then
      setExit(kmapper.originatingRoomId, targetRoomId, 'e')
      setExit(targetRoomId, kmapper.originatingRoomId, 'w')
    end
    if selectedDir == 'u' or selectedDir == 'd' then
      selectedDir = kmapper.selectedDir or 'nw'
      local oppSelectedDir = kmapper.dirOpposite[selectedDir]
      setExit(kmapper.originatingRoomId, targetRoomId, selectedDir)
      setExit(targetRoomId, kmapper.originatingRoomId, oppSelectedDir)
    end
  end

  -- jesli room jest nowy, i przeszlismy do niego przez wyjscie, obliczamy jego polozenie
  if isNewRoom == true and kmapper.originatingExit ~= nil then
    local x,y,z = getRoomCoordinates(kmapper.originatingRoomId)
    if selectedDir == 'n' then
      setRoomCoordinates(targetRoomId, x, y + kmapper.step, z)
    end
    if selectedDir == 's' then
      setRoomCoordinates(targetRoomId, x, y - kmapper.step, z)
    end
    if selectedDir == 'w' then
      setRoomCoordinates(targetRoomId, x - kmapper.step, y, z)
    end
    if selectedDir == 'e' then
      setRoomCoordinates(targetRoomId, x + kmapper.step, y, z)
    end
    if selectedDir == 'nw' then
      setRoomCoordinates(targetRoomId, x - kmapper.step, y + kmapper.step, z)
    end
    if selectedDir == 'ne' then
      setRoomCoordinates(targetRoomId, x + kmapper.step, y + kmapper.step, z)
    end
    if selectedDir == 'sw' then
      setRoomCoordinates(targetRoomId, x - kmapper.step, y - kmapper.step, z)
    end
    if selectedDir == 'se' then
      setRoomCoordinates(targetRoomId, x + kmapper.step, y - kmapper.step, z)
    end
  end
  
  selectedDir = utf8.lower(kmapper.originatingExit.dir);
  if selectedDir == 'u' or selectedDir == 'd' then
    selectedDir = kmapper.selectedDir or 'nw'
  end
  
  -- jesli uzylismy wejscie zeby przejsc do rooma, lazymy wyjscia
  if kmapper.originatingExit ~= nil then
    -- ustawianie tekstowego wyjscia roomowi z ktorego wychodzimy 
    if kmapper.originatingExit.name ~= ''
    or selectedDir == 'ne'
    or selectedDir == 'nw'
    or selectedDir == 'se'
    or selectedDir == 'sw'
    then
      local meta = {}
      local dir = kmapper.originatingExit.dir
      if kmapper.originatingExit.name ~= '' then
        dir = kmapper.originatingExit.name
      end
      meta['command'] = utf8.lower(strip_accents(dir))
      meta['id'] = targetRoomId
      setRoomUserData(kmapper.originatingRoomId, selectedDir, yajl.to_string(meta))
    end
    
    -- ustawianie tekstowego wyjscia spowrotem roomowi do ktorego weszlismy
    -- tylko jesli juz nie istnieje, i jesli fizycznie jest wyjscie w przeciwnym
    -- kierunku niz weszlismy
    if kmapper:checkIfMetaExitExists(targetRoomId, kmapper.originatingRoomId) == false then
      for _, exit in ipairs(gmcp.Room.Info.exits) do
        if utf8.lower(exit.dir) == kmapper.dirOpposite[utf8.lower(kmapper.originatingExit.dir)] then
          if exit.name ~= '' or exit.dir == 'U' or exit.dir == 'D' then
            local meta = {}
            local dir = exit.dir
            if exit.name ~= '' then
              dir = exit.name
            end
            meta['command'] = utf8.lower(strip_accents(dir))
            meta['id'] = kmapper.originatingRoomId
            setRoomUserData(targetRoomId, kmapper.dirOpposite[selectedDir], yajl.to_string(meta))
          end
        end
      end
    end

    kmapper.targetRoomId = targetRoomId
    kmapper.selectedDir = nil
  end
  kmap:centerView(targetRoomId)
end

--
-- jesli zostal ustawiony room do ktorego po komendzie gracz powinien
-- wejsc, sprawdzamy czy to sie zgadza
--
function kmapper:checkIfMoveCommandWasExecuted()
  if kmapper.targetRoomId == nil then
    return false
  end

  if kmapper.targetRoomId == 'new' and kmapper.originatingRoomId ~= nil and kmapper.originatingExit ~= nil then
    if kmapper.selectedDir == nil and ( kmapper.originatingExit.dir == 'U' or kmapper.originatingExit.dir == 'D' ) then
      kmapper:askForExitDirection()
      return false 
    end
    kmapper:createNewRoom()
  end

  kmap:centerView(kmapper.targetRoomId)
  kmapper.targetRoomId = nil

  local typ = strip_accents(gmcp.Room.Info.sector);

  kmap.vnumToRoomIdCache[gmcp.Room.Info.num] = getPlayerRoom()
  
  kmapper:colourRoom(getPlayerRoom(), typ)
  
  setRoomUserData(getPlayerRoom(), 'vnum', gmcp.Room.Info.num)
  setRoomUserData(getPlayerRoom(), 'sector', typ)
  setRoomUserData(getPlayerRoom(), 'name', strip_accents(gmcp.Room.Info.name))
  
  -- dopisywanie drzwi do mapy
  for _, value in ipairs(gmcp.Room.Info.exits) do
    if value.door == true then
      s = utf8.lower(value.dir)
      local doorsIntoDir = s
      if value.name ~= '' then
        s = utf8.lower(value.name)
      end

      local meta = getAllRoomUserData(getPlayerRoom())
      for key, valueStr in pairs(meta) do
        if valueStr ~= 'block' and kmapper:isDirName(key) then
          local value = yajl.to_value(valueStr)
          local cmd = value.command
          if cmd == 'up' then cmd = 'u' end
          if cmd == 'down' then cmd = 'd' end
          if cmd == s then
            doorsIntoDir = key
          end
        end
      end
      setDoor(getPlayerRoom(), doorsIntoDir, 2)
    end
  end
  
  local exits = getRoomExits(mapRoomId)
  for dir, value in pairs(exits) do
    cmd = kmapper.dirTable[dir]
    local meta = getRoomUserData(getPlayerRoom(), cmd)
    if meta ~= '' and meta ~= 'block' then
      metaObj = yajl.to_value(meta)
      if metaObj.command == 'up' then
        cmd = "u"
      elseif metaObj.command == 'down' then
        cmd = "d"
      else
        cmd = metaObj.command
      end
    end
    
  end
end

function kmapper:colourRoom(roomId, sector)
  local sectorToEnv = {
    ["ruchome piaski"] = 100,
    ["podziemne jezioro"] = 101,
    ["droga"] = 102,
    ["gorska sciezka"] = 103,
    ["step"] = 104,
    ["bagno"] = 105,
    ["ciemna woda"] = 106,
    ["pole"] = 107,
    ["kopalnia"] = 108,
    ["podziemia naturalne"] = 109,
    ["ocean"] = 110,
    ["plac"] = 111,
    ["wydmy"] = 112,
    ["pustynna droga"] = 113,
    ["pustynia"] = 114,
    ["wzgorza"] = 115,
    ["woda niep"] = 116,
    ["podziemia"] = 117,
    ["powietrze"] = 118,
    ["las"] = 119,
    ["plaza"] = 120,
    ["eden"] = 121,
    ["morze"] = 122,
    ["wewnatrz"] = 123,
    ["park"] = 124,
    ["pod woda"] = 125,
    ["puszcza"] = 126,
    ["tundra"] = 127,
    ["ruiny"] = 128,
    ["miasto"] = 129,
    ["blotna sciezka"] = 130,
    ["jezioro"] = 131,
    ["laka"] = 132,
    ["podziemna droga"] = 133,
    ["lodowiec"] = 134,
    ["rzeka"] = 135,
    ["wys gory"] = 136,
    ["sciezka"] = 137,
    ["nieuzywany"] = 138,
    ["gory"] = 139,
    ["jaskinia"] = 140,
    ["gorace zrodla"] = 141,
    ["arktyczny lad"] = 142,
    ["woda plyw"] = 143,
    ["stroma sciezka"] = 144,
    ["trawa"] = 145,
    ["sawanna"] = 146,
    ["arena"] = 147,
    ["lawa"] = 148
  }
  local sectorToWeight = {
    ["ruchome piaski"] = 9,
    ["podziemne jezioro"] = 5,
    ["droga"] = 1,
    ["gorska sciezka"] = 4,
    ["step"] = 2,
    ["bagno"] = 5,
    ["ciemna woda"] = 6,
    ["pole"] = 2,
    ["kopalnia"] = 4,
    ["podziemia naturalne"] = 3,
    ["ocean"] = 5,
    ["plac"] = 2,
    ["wydmy"] = 3,
    ["pustynna droga"] = 3,
    ["pustynia"] = 7,
    ["wzgorza"] = 4,
    ["woda niep"] = 6,
    ["podziemia"] = 3,
    ["powietrze"] = 3,
    ["las"] = 3,
    ["plaza"] = 3,
    ["eden"] = 1,
    ["morze"] = 5,
    ["wewnatrz"] = 1,
    ["park"] = 2,
    ["pod woda"] = 6,
    ["puszcza"] = 6,
    ["tundra"] = 5,
    ["ruiny"] = 4,
    ["miasto"] = 1,
    ["blotna sciezka"] = 4,
    ["jezioro"] = 5,
    ["laka"] = 2,
    ["podziemna droga"] = 1,
    ["lodowiec"] = 7,
    ["rzeka"] = 3,
    ["wys gory"] = 8,
    ["sciezka"] = 2,
    ["nieuzywany"] = 1,
    ["gory"] = 6,
    ["jaskinia"] = 3,
    ["gorace zrodla"] = 3,
    ["arktyczny lad"] = 5,
    ["woda plyw"] = 4,
    ["stroma sciezka"] = 3,
    ["trawa"] = 3,
    ["sawanna"] = 3,
    ["arena"] = 1,
    ["lawa"] = 8
  }
  local env = sectorToEnv[sector]
  if env == nil then env = 138 end
  setRoomEnv(roomId, env)
  local weight = sectorToWeight[sector]
  if weight == nil then weight = 1 end
  setRoomWeight(roomId, weight)
end

--
-- sprawdza i zwraca wyjscia z rooma (przy okazji poprawiajac bledy w mapie)
--
function kmapper:findExits(mapRoomId)
  local availableDirs = {}

  local specialDirIds = {}
  --cecho('<yellow>RoomId: ' .. mapRoomId .. ', vnum: ' .. gmcp.Room.Info.num .. ', room meta:' .. yajl.to_string(getAllRoomUserData(getPlayerRoom())) )
  local meta = getAllRoomUserData(mapRoomId)
  if meta == nil then meta = {} end

  for key, valueStr in pairs(meta) do
    if valueStr ~= 'block' and kmapper:isDirName(key) then
      local value = yajl.to_value(valueStr)
      if value.id ~= 'new' and roomExists(value.id) == false then
        -- czyszczenie niepoprawnych specjalnych przejsc z meta
        clearRoomUserDataItem(mapRoomId, key)
        cecho('\n<red>Wyczyszczono specjalne przejscie na ' .. key .. 'z rooma, poniewaz prowadzilo do nie istniejącego rooma\n')
        kmapper:addToMapLog(
          'room id:' .. mapRoomId ..
          '\nWyczyszczono przejscie na ' .. key .. 'z rooma, poniewaz prowadzilo do nie istniejącego rooma' ..
          '\nUserData: ' .. yajl.to_string(getAllRoomUserData(mapRoomId)) ..
          '\nGMCP Data: ' .. yajl.to_string(gmcp.Room.Info) .. '\n'
        )
      elseif value.id ~= 'new' and value.id == mapRoomId then
      -- czyszczenie zapetlonych specjalnych wyjsc
      clearRoomUserDataItem(mapRoomId, key)
      cecho('\n<red>Wyczyszczono zapetlone specjalne przejscie na ' .. dir .. 'z rooma\n')
      kmapper:addToMapLog(
        'room id:' .. mapRoomId ..
        '\nWyczyszczono zapetlone specjalne przejscie na ' .. dir .. 'z rooma' ..
        '\nUserData: ' .. yajl.to_string(getAllRoomUserData(mapRoomId)) ..
        '\nGMCP Data: ' .. yajl.to_string(gmcp.Room.Info) .. '\n'
      )
      else
        local cmd = value.command
        if cmd == 'up' then cmd = 'u' end
        if cmd == 'down' then cmd = 'd' end
        availableDirs[cmd] = value.id
        table.insert(specialDirIds, value.id)
      end
    end
  end

  local exits = getRoomExits(mapRoomId) or {}
  for dir, value in pairs(exits) do
    if roomExists(value) == false  then
      -- czyszczenie niepoprawnych normalnych wyjsc
      setExit(mapRoomId, -1, dir)
      cecho('\n<red>Wyczyszczono przejscie na ' .. dir .. 'z rooma, poniewaz prowadzilo do nie istniejącego rooma\n')
      kmapper:addToMapLog(
        'room id:' .. mapRoomId ..
        '\nWyczyszczono przejscie na ' .. dir .. 'z rooma, poniewaz prowadzilo do nie istniejącego rooma' ..
        '\nUserData: ' .. yajl.to_string(getAllRoomUserData(mapRoomId)) ..
        '\nGMCP Data: ' .. yajl.to_string(gmcp.Room.Info) .. '\n'
      )
    elseif value == mapRoomId then
      -- czyszczenie zapetlonych normalnych wyjsc
      setExit(mapRoomId, -1, dir)
      cecho('\n<red>Wyczyszczono zapetlone przejscie na ' .. dir .. 'z rooma\n')
      kmapper:addToMapLog(
        'room id:' .. mapRoomId ..
        '\nWyczyszczono zapetlone przejscie na ' .. dir .. 'z rooma' ..
        '\nUserData: ' .. yajl.to_string(getAllRoomUserData(mapRoomId)) ..
        '\nGMCP Data: ' .. yajl.to_string(gmcp.Room.Info) .. '\n'
      )
    else
      if table.contains(specialDirIds, value) == false then
        availableDirs[kmapper.dirTable[dir]] = value
      end
    end
  end
  
  --
  -- sprawdzanie czy instrukcja jest do wyjscia nowym wyjsciem
  --
  local unmapped = ''
  for _, value in ipairs(gmcp.Room.Info.exits) do
    s = utf8.lower(value.dir)
    if value.name ~= '' then
      s = utf8.lower(strip_accents(value.name))
    end
    if availableDirs[s] == nil then
      availableDirs[s] = 'new'
      unmapped = unmapped .. ' ' .. s
    end
  end
  if unmapped ~= '' then
    cecho('<blue:yellow>--- Nie zmapowane wyjścia na:' .. unmapped .. ' ---\n')
  end

  --
  -- sprawdzenie poprawnosci mapy wzgledem danych z gmcp
  --
  errors = ''
  gmcpDirs = {}
  for _, value in ipairs(gmcp.Room.Info.exits) do
    s = utf8.lower(value.dir)
    if value.name ~= '' then
      s = utf8.lower(strip_accents(value.name))
    end
    gmcpDirs[s] = value
  end

  for dir, _ in pairs(availableDirs) do
    if gmcpDirs[dir] ~= nil and getRoomUserData(mapRoomId, dir) == nil then
      errors = errors .. '<red>Kierunek ' .. dir .. ' istnieje na mapie ale NIE na mudzie. Mapa jest nieaktualna.\n'
    end
  end
  if errors ~= '' then
    kmapper:addToMapLog(
      'room id:' .. mapRoomId ..
      '\n' .. errors ..
      '\nUserData: ' .. yajl.to_string(getAllRoomUserData(mapRoomId)) ..
      '\nGMCP Data: ' .. yajl.to_string(gmcp.Room.Info) .. '\n'
    )
    echo('\n')
    cecho('<yellow>****************************************\n');
    cecho('<yellow>**        Meh, sie pojebało!          **\n');
    cecho('<yellow>****************************************\n');
    cecho(errors)
    echo('\n')
  end
  
  return availableDirs, gmcpDirs
end

--
-- wykonywanie dozwolonych komend
--
function kmapper:isMappingCommand(input)
  inputCmd = utf8.lower(input)
  kmapper.originatingRoomId = nil
  kmapper.originatingExit = nil

  kmap:mapLocate()

  mapRoomId = getPlayerRoom()
  if mapRoomId == nil then
    cecho('<red>NIE JESTEŚ NA MAPIE!\n')
    cecho('<red>Ustawiam cie na plac w Arras!\n')
    send('goto 6000')
    kmap:centerView(44)
  end

  if input == 'l' or input == 'look' then
    kmapper.targetRoomId = mapRoomId
    return input
  end
  if string.starts(input, 'open ')
  or string.starts(input, 'close ')
  or string.starts(input, 'say ')
  or string.starts(input, 'tell ')
  or string.starts(input, 'reply ')
  or string.starts(input, 'imm ')
  or input == 'map'
  or input == 'who'
  or input == 'redit'
  or input == 'rplist'
  or input == 'rpdump'
  or input == 'oplist'
  or input == 'opdump'
  or input == 'mplist'
  or input == 'mpdump'
  or input == 'purge'
  or input == 'stat room'
  or input == 'stat mob' then
    return input
  end
  if string.starts(input, 'map s')
  or string.starts(input, 'map f')
  or string.starts(input, 'map i')
  or string.starts(input, 'map a')
  or string.starts(input, 'map e') then
    return false
  end

  local availableDirs, gmcpDirs = kmapper:findExits(mapRoomId)

  for key, value in pairs(availableDirs) do
    if utf8.len(inputCmd) > 1 and utf8.len(key) > 1 and string.starts(key, inputCmd) then
      kmapper.targetRoomId = value
      kmapper.originatingRoomId = getPlayerRoom()
      kmapper.originatingExit = gmcpDirs[key]
      return key
    end
    if utf8.len(inputCmd) == 1 and utf8.len(key) == 1 and inputCmd == key then
      kmapper.targetRoomId = value
      kmapper.originatingRoomId = getPlayerRoom()
      kmapper.originatingExit = gmcpDirs[key]
      return key
    end
  end

  cecho('<red>Niepoprawna komenda. Wyjścia: ')
  for key, value in pairs(availableDirs) do
    cecho('<red>"' .. key .. '" ')
  end
  echo('\n')
  return false
end

function kmapper:parseQueue()
  if kmapper.mapping == false then
    kmapper:stopCmdCapture()
    for _, cmd in ipairs(kmapper.cmdQueue) do
      send(cmd)
    end
    return
  end
  t = table.remove(kmapper.cmdQueue, 1)
  if t ~= nil then
    t = kmapper:isMappingCommand(t)
    if t == false then
      kmapper:parseQueue()
      return
    end
    kmapper.runningCmd = true
    send(t, false)
    -- od tego miejsca wykonywanie kolejnych komend z kolejki jest wstrzymane
    -- do momentu otrzymania nastepnego prompta przez kmapper:receivedLookCommand
  end
end

--
-- przechwytywanie komend kiedy w trybie mapowania
--
function kmapper:stopCmdCapture()
  if kmapper.ids.cmdCaptureAlias then killAlias(kmapper.ids.cmdCaptureAlias) end
  kmapper.cmdQueue = {}
end

function kmapper:startCmdCapture()
  kmapper:stopCmdCapture()
  kmapper.ids.cmdCaptureAlias = tempAlias("^(.*)$", [[ kmapper:captureCommand() ]])
  kmapper.cmdQueue = {}
end

function kmapper:captureCommand()
  if kmapper.askingForDirection == true then
    return
  end
  table.insert(kmapper.cmdQueue, matches[2])
  if kmapper.runningCmd == false then
    kmapper:parseQueue()
  end
end

--
-- nasluchiwanie komunikatow gmcp.Room.Info
--
function kmapper:receivedLookCommand()
  if kmapper.mapping ~= true then return end
  kmapper.runningCmd = false
  local roomId = kmap:mapLocate()
  if roomId ~= nil then
    kmapper:findExits(roomId)
  end
  kmapper:checkIfMoveCommandWasExecuted()
  if kmapper.targetRoomId == nil then
    kmapper:parseQueue()
  end
end

if kmapper.ids.roomInfoEvent then killTrigger(kmapper.ids.roomInfoEvent) end
kmapper.ids.roomInfoEvent = tempRegexTrigger("^\\[Wyj.cia:.*", [[ kmapper:receivedLookCommand() ]])

--
-- start/stop mapowania
--
function kmapper:mapStart()
  if kmapper.mapping == true then
    cecho('\n<red>Mapowanie jest już włączone\n');
  else
    openMapWidget()
    kmap:vnumCacheRebuild()
    kmap:mapLocate()
    kmapper.mapping = true
    kmapper.runningCmd = false
    kmapper:startCmdCapture()
    cecho('\n<red>**************************************************\n');
    cecho('<red>**         WŁĄCZONO TRYB TWORZENIA MAPY         **\n');
    cecho('<red>**************************************************\n');
    cecho('<red>** Ten tryb służy wyłącznie do pracy nad mapą.  **\n');
    cecho('<red>** NIE używaj go do normalnej gry.              **\n');
    cecho('<red>** Ten tryb BLOKUJE wszystkie komendy oprócz    **\n');
    cecho('<red>** tych potrzebnych do poruszania się.          **\n');
    cecho('<red>**                                              **\n');
    cecho('<red>** Dozwolone komendy                            **\n');
    cecho('<red>** - kierunki                                   **\n');
    cecho('<red>** - look lub l                                 **\n');
    cecho('<red>** - open (pelna komenda)                       **\n');
    cecho('<red>** - close (pelna komenda)                      **\n');
    cecho('<red>**                                              **\n');
    cecho('<red>** Aby wyłączyć tryb mapowania wpisz:           **\n');
    cecho('<red>** <yellow>map stop<red>                                     **\n');
    cecho('<red>**************************************************\n\n');
  end
end

function kmapper:mapStop(showInfo)
  kmapper.mapping = false
  kmapper.askingForDirection = false
  kmapper.originatingExit = nil
  kmapper.targetRoomId = nil
  kmapper:stopCmdCapture()
  kmap:vnumCacheRebuild()
  kmapper:msgBoxHide()
  if showInfo == false then
    return
  end
  if kmapper.mapping == false then
    cecho('\n<green>Mapowanie jest już wyłączone\n');
  else
    cecho('\n<green>****************************************\n');
    cecho('<green>**   WYŁĄCZONO TRYB TWORZENIA MAPY    **\n');
    cecho('<green>****************************************\n');
  end
end

function kmapper:mapStep(step)
  kmapper.step = step
  cecho('\n<green>Odleglość między nowymi roomami ustawiona na ' .. step .. '\n')
end

--
-- narzedzia
--
function kmapper:forgetRoom(roomId)
  clearRoomUserDataItem(roomId, 'vnum')
  clearRoomUserDataItem(roomId, 'sector')
  setRoomChar(roomId, '')
  cecho('<green>Wyczyszczono room ' .. roomId .. '\n')
end

function kmapper:mapForget(fromMapper)
  if fromMapper == true then
    if getMapSelection() ~= nil then
      local selectedRooms = getMapSelection()["rooms"]
      if selectedRooms ~= nil and #selectedRooms > 0 then
        for _, id in ipairs(selectedRooms) do
          kmapper:forgetRoom(id)
        end
      else
        cecho('<red>Najpierw zaznacz room(y) na mapie')
      end
    else
      cecho('<red>Najpierw zaznacz room(y) na mapie')
      return
    end
  else
    local roomId = getPlayerRoom()
    kmapper:forgetRoom(roomId)
  end
  kmap:vnumCacheRebuild()
  if kmapper.mapping == true then
    cecho('\n<red>Wyłączam też tworzenie mapy, przenieś się w miejsce ktore jest poprawnie zmapowane i zrob <yellow>map start<red> ponownie.\n\n')
    kmapper:mapStop(false)
  end
  send('\n')
end

--
-- importowanie mapy
--
function kmapper:mapLoad()
  cecho('\n<red>*******************************************\n');
  cecho('<red>** UWAGA!! To nadpisze CAŁĄ twoją pracę! **\n');
  cecho('<red>** Mozesz kiknąć "Anuluj" w okienku      **\n');
  cecho('<red>** wyboru pliku aby nie nadpisywać mapy  **\n');
  cecho('<red>**                                       **\n');
  cecho('<red>** czy nie chciałeś przypadkiem użyć     **\n');
  cecho('<red>** <yellow>map import<red>                            **\n');
  cecho('<red>** by "zaimportować" coś do istniejącej  **\n');
  cecho('<red>** już mapy?                             **\n');
  cecho('<red>*******************************************\n');
  local path = invokeFileDialog(true, "Wybierz NOWY PLIK mapy do załadowania")
  if path == "" then
    cecho('<yellow>Anulowano ładowanie nowej mapy.')
    return nil
  end
  if loadMap(path) == false then
    cecho('<red>Ładowanie mapy nie powiodło się.')
    return nil
  end
  cecho('<green>Załadowano nową mapę.')
  kmap:vnumCacheRebuild()
  kmapper:mapStop(false)
end

--
-- dialog wyboru kierunku wyjscia
--
function kmapper:askForExitDirection()
  kmapper.askingForDirection = true
  kmapper:msgBoxShow()
  if kmapper.ids.askDirectionAlias then killAlias(kmapper.ids.askDirectionAlias) end
  kmapper.ids.askDirectionAlias = tempAlias("^(n|s|e|w|ne|nw|se|sw)$", [[ kmapper:listenForExitDirection() ]])
end

function kmapper:listenForExitDirection()
  kmapper.selectedDir = matches[2]
  kmapper.askingForDirection = false
  kmapper:msgBoxHide()
  kmapper:checkIfMoveCommandWasExecuted()
  killAlias(kmapper.ids.askDirectionAlias)
end

--
-- EXPORT
--

function kmapper:fixCustomLines(lineObj)
    for k,v in pairs(lineObj) do
        local tempPoints = {}
        for i,j in pairs(v.points) do
            table.insert(tempPoints, math.max(1, tonumber(i)), j)
        end
        v.points = tempPoints
    end
    return lineObj
end

function kmapper:exportArea(areaId)
  local areaId = tonumber(areaId)
  local rooms = getAreaRooms(areaId)
  local labelIds = getMapLabels(areaId)

  labels = {}
  if type(labelIds) == "table" then
      for k,v in pairs(labelIds) do
          local label = getMapLabel(areaId, k)
          label.id = k
          table.insert(labels, label)
      end
  end

  local i = 0
  local areaRooms = {
      areaId = areaId,
      areaName = getRoomAreaName(areaId),
      rooms = {},
      labels = labels
  }
  for k, v in pairs(rooms) do
      local x,y,z = getRoomCoordinates(v)
      local userDataKeys = getRoomUserDataKeys(v)
      local userData = {}
      for _,key in ipairs(userDataKeys) do
          userData[key] = getRoomUserData(v,key)
      end
      local roomInfo = {
          id = v,
          x = x,
          y = y,
          z = z,
          name = getRoomName(v),
          exits = getRoomExits(v),
          env = getRoomEnv(v),
          roomChar = getRoomChar(v),
          doors = getDoors(v),
          customLines = kmapper:fixCustomLines(getCustomLines(v)),
          specialExits = getSpecialExitsSwap(v),
          stubs = getExitStubs1(v),
          userData = table.size(userData) > 0 and userData or nil
      }
      table.insert(areaRooms.rooms, roomInfo)
  end


  echo('\n')
  cecho('<green>****************************************\n');
  cecho('<green>** Wybierz FOLDER do zapisania pliku  **\n');
  cecho('<green>****************************************\n');
    
  local path = invokeFileDialog(false, "Wybierz miejsce do zapisania krainki")
  if path == "" then
    cecho('<yellow>Anulowano eksport krainki')
    return nil
  end

  local areas = getAreaTableSwap()
  local fileName = path .. "/" .. areas[areaId] .. ".json"
  file = io.open (fileName, "w+")
  file:write(yajl.to_string(areaRooms))
  file:close()
  
  cecho('\n<green>Wyksportowano krainkę do pliku '.. fileName ..'\n');
end

function kmapper:importArea()
  echo('\n')
  cecho('<green>****************************************\n');
  cecho('<green>**   Wybierz PLIK do zaimportowania   **\n');
  cecho('<green>****************************************\n');

  local path = invokeFileDialog(true, "Wybierz plik mapy do zaimportowania")
  if path == "" then
    cecho('<yellow>Anulowano import krainki')
    return nil
  end
  
  local f = assert(io.open(path, "r"))
  local content = f:read("*all")
  f:close()
  
  local data = yajl.to_value(content)
  
  local areaName = "import " .. data.areaName .. " " .. os.date ("%c")
  local areaId = addAreaName(areaName)
  
  for _, label in ipairs(data.labels) do
    createMapLabel(
      areaId,
      label.Text,
      label.X,
      label.Y,
      label.Z,
      225,
      255,
      255,
      0,
      0,
      0, 
      100,
      12, 
      false
    )
  end
  
  local roomMap = {}
  for _, room in ipairs(data.rooms) do
    newRoomId = createRoomID()
    roomMap[tonumber(room.id)] = newRoomId
    addRoom(newRoomId)
    setRoomArea(newRoomId, areaId)
    setRoomCoordinates(newRoomId, room.x, room.y, room.z)
    setRoomName(newRoomId, room.name)
    setRoomChar(newRoomId, room.roomChar)
    setRoomEnv(newRoomId, room.env)
  end
  
  for _, room in ipairs(data.rooms) do
    roomId = roomMap[tonumber(room.id)]
    for key, value in pairs(room.exits) do
      if roomMap[tonumber(value)] ~= nil then
        setExit(roomId, roomMap[tonumber(value)], kmapper.dirTable[key])
      end
    end
    for key, value in pairs(room.specialExits) do
      if roomMap[tonumber(value)] ~= nil then
        addSpecialExit(roomId, roomMap[tonumber(value)], key)
      end
    end
    for key, value in pairs(room.doors) do
      setDoor(roomId, key, value)
    end
    for key, value in pairs(room.customLines) do
      if type(value.points) == 'table' and value.points[1] ~= nil then
        local points = {}
        for i, j in ipairs(value.points) do
          local p = {}
          table.insert(p, j["x"])
          table.insert(p, j["y"])
          table.insert(p, 0)
          table.insert(points, p)
        end 
        addCustomLine(roomId, points, key, value.attributes.style, value.attributes.color, value.attributes.arrow)
      end
    end
    if room.userData ~= nil then
      for key, value in pairs(room.userData) do
        -- przepisywanie id roomow wyjsc specjalnych
        if kmapper:isDirName(key) and value ~= 'block' then
          local valueObj = yajl.to_value(value)
          if valueObj.id ~= nil and roomMap[valueObj.id] ~= nil then
            valueObj.id = roomMap[valueObj.id]
          end
          value = yajl.to_string(valueObj)
        end
        setRoomUserData(roomId, key, value)
      end
    end
  end
  
  cecho('\n<green>Zaimportowano krainkę "' .. areaName .. '"\n')
  
  kmapper:mapRefresh()
end

--
-- BIBLIOTEKI
--

function split (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in utf8.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function strip_accents( str )
  local tableAccents = {}
    tableAccents["ą"] = "a"
    tableAccents["Ą"] = "A"
    tableAccents["ć"] = "c"
    tableAccents["Ć"] = "C"
    tableAccents["ę"] = "e"
    tableAccents["Ę"] = "E"
    tableAccents["ł"] = "l"
    tableAccents["Ł"] = "L"
    tableAccents["ń"] = "n"
    tableAccents["Ń"] = "N"
    tableAccents["ó"] = "o"
    tableAccents["Ó"] = "O"
    tableAccents["ś"] = "s"
    tableAccents["Ś"] = "S"
    tableAccents["Ź"] = "Z"
    tableAccents["ź"] = "z"
    tableAccents["Ż"] = "Z"
    tableAccents["ż"] = "z"     
  local normalizedString = ""
  for strChar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
    if tableAccents[strChar] ~= nil then
      normalizedString = normalizedString..tableAccents[strChar]
    else
      normalizedString = normalizedString..strChar
    end
  end      
  return normalizedString
end

--
-- okienko decyzji
--
function kmapper:msgBoxShow()
  local title = "test1"
  local message = "test2"
  kmapper.msgBox = Geyser.Label:new({
    name="promptDecision",
		message="<center>Podaj w którym kierunku na mapie<br> narysować to wyjście:<br><br>ne, nw, se, sw, n, s, w, e</center>",
		x="20px",
		y="20px",
		width = "100%-20px",
		height = "200px"
  })
  kmapper.msgBox:setFontSize(20)
	kmapper.msgBox:setStyleSheet([[ background-color: rgb(30, 30, 30) ]])
end
function kmapper:msgBoxHide()
  if kmapper.msgBox ~= nil then
	  kmapper.msgBox:hide()
  end
end

function kmapper:addToMapLog(txt)
  file = io.open(getMudletHomeDir() .. "/mapLog.txt", "a+")
  file:write('[' .. os.date('%c') .. ']: ' .. txt .. '\n')
  file:close()
end

function kmapper:mapLog()
  echo('\n')
  cecho('<green>*******************************************\n');
  cecho('<green>** Wybierz FOLDER do zapisania loga mapy **\n');
  cecho('<green>*******************************************\n');

  local path = invokeFileDialog(false, "Wybierz folder do zapisania loga mapy")
  if path == "" then
    cecho('<yellow>Anulowano zapis loga mapy')
    return nil
  end

  local fileName = path .. "/mapLog.json"
  file1 = io.open(getMudletHomeDir() .. "/mapLog.txt", "r")
  file2 = io.open(path .. "/mapLog.txt", "w+")
    for line in file1:lines() do
      file2:write(line .. '\n')
    end
  file1:close()
  file2:close()
end

--
-- Tworzenie nowych krainek
--

function kmapper:mapArea(areaName)
  if kmapper.mapping == true then
    cecho("\n<red>Najpierw wyłącz mapowanie\n")
    return
  end
  if areaName == '' or areaName == nil then
    cecho("\n<red>Nie podałeś nazwy krainki\n")
    return
  end
  areaId = addAreaName(areaName)
  roomId = createRoomID()
  addRoom(roomId)
  setRoomArea(roomId, areaId)
  kmap:centerView(roomId)
end

--
-- Dodawanie symboli
--

function kmapper:mapSymbol(symbol)
  if symbol == '' or symbol == nil then
    cecho("\n<red>map symbol + <green>- dla nauczycieli, sklepów, questów")
    cecho("\n<red>map symbol !! <green>- dla pułapek")
    cecho("\n<red>map symbol R <green>- dla renta")
    cecho("\n<red>map symbol @ <green>- dla fontanny")
    cecho("\n<red>map symbol ! <green>- dla agresywnych mobow")
    return
  end
  if symbol == '!!' then symbol = '‼' end
  roomId = getPlayerRoom()
  setRoomChar(roomId, symbol)
  cecho('\n<green>Ustawiono symbol rooma na ' .. symbol .. '\n')
  updateMap()
end

--
-- Informacja o roomie
--

function kmapper:mapInfo(fromMapper)
  local roomId = getPlayerRoom()
  if fromMapper == true then
    if getMapSelection() ~= nil then
      local selectedRooms = getMapSelection()["rooms"]
      if selectedRooms ~= nil and #selectedRooms > 0 then
        roomId = selectedRooms[1]
      end
    else
      cecho('<red>Najpierw zaznacz room na mapie')
      return
    end
  end
  cecho('\n<green>Informacje o roomie:\n');
  echo('Id roomu: ' .. roomId .. '\n')
  echo('W area: ' .. getRoomAreaName(getRoomArea(getPlayerRoom())) .. '\n')
  echo('Meta:\n')
  display(getAllRoomUserData(roomId))
  echo('Wyjscia:\n')
  display(getRoomExits(roomId))
  echo('\n')
  echo('-------------\n')
  local vcount = 0
  for _ in pairs(kmap.vnumToRoomIdCache) do vcount = vcount + 1 end
  echo('Łącznie roomów z vnumami: ' .. vcount .. '\n')
  local rcount = 0
  for _ in pairs(getRooms()) do rcount = rcount + 1 end
  echo('Łącznie roomów na mapie: ' .. rcount .. '\n')
  echo('Procent roomów z vnumami: ' .. string.format("%.2f", (vcount/rcount)*100) .. '\n')
end

--
-- Map zoom
--
function kmapper:mapZoom(level)
  setMapZoom(tonumber(level))
end

--
-- Map reset
--
function kmapper:mapRefresh()
  kmap:vnumCacheRebuild()
  kmap:mapLocate()
  cecho('\n<yellow>Odświeżono vnumy i odświeżono mapę.\n')
end

--
-- Wyjscia specjalne
--

function kmapper:mapSpecial(dir, cmd)
  if dir == nil or dir == '' or cmd == nil or cmd == '' then
    cecho('\n<yellow>Składnia: map special <kierunek> <tekst>\n')
    cecho('<yellow>Kierunki: n, s, w, e, nw, ne, sw, se\n')
    cecho('\n<yellow>Komenda <cyan>map special <kierunek> -1<yellow> powoduje usuniecie specjalnego przejscia\n')
    return
  end
  if cmd == '-1' then
    clearRoomUserDataItem(getPlayerRoom(), dir)
    cecho('\n<green>Usunięto wyjscie w kierunku na ' .. dir .. '\n')
    return
  end 
  --exit = {}
  --exit["command"] = cmd
  --exit["id"] = 'new'
  --setRoomUserData(getPlayerRoom(), dir, yajl.to_string(exit))
  exit = {}
  exit['door'] = false
  exit['closed'] = false
  exit['name'] = cmd
  exit['dir'] = dir
  kmapper.targetRoomId = 'new'
  kmapper.originatingRoomId = getPlayerRoom()
  kmapper.originatingExit = exit
  kmapper.runningCmd = true
  cecho('\n<green>Dodano wyjscie ' .. cmd .. ' w kierunku na ' .. dir .. '\n')
  send(cmd)
end

--
-- Map cleanup
--
function kmapper:mapCheck()
  kmap:vnumCacheRebuild()
  kmap:mapLocate()
  for id, name in pairs(getRooms()) do
    local symbol = getRoomChar(id)
    if getRoomUserData(id, 'vnum') == nil then
      echo('Room ' .. id .. ' nie ma vnumu\n')
    end
  end
end

--
-- Map label
--
function kmapper:mapLabel(label)
  local size = 20
  local icon = nil
  if string.starts(label, '###') then
    size = 160
    label = utf8.sub(label, 4)
  elseif string.starts(label, '##') then
    size = 80
    label = utf8.sub(label, 3)
  elseif string.starts(label, '#') then
    size = 40
    label = utf8.sub(label, 2)
  end
  if string.ends(label, '!') then
    icon = '☠'
    label = utf8.sub(label, 1, utf8.len(label) - 1)
  end
  label = string.title(string.trim(label))
  if icon ~= nil then
    label = icon .. label
  end
  local roomId = getPlayerRoom()
  local areaId = getRoomArea(roomId)
  local x,y,z = getRoomCoordinates(roomId)
  createMapLabel(areaId, label, x+0.5, y+1.3, z, 230,230,230, 0,0,0, 30, size, false, false)
end

function kmapper:setupColors()
  local colors = {
    ["ruchome piaski"] = "#8a6602",
    ["droga"] = "#7c2202",
    ["gorska sciezka"] = "#c49e5b",
    ["step"] = "#289401",
    ["bagno"] = "#1d4f3d",
    ["pole"] = "#289401",
    ["kopalnia"] = "#312332",
    ["podziemia naturalne"] = "#352f28",
    ["ocean"] = "#2001c7",
    ["plac"] = "#a40802",
    ["wydmy"] = "#968d3c",
    ["pustynna droga"] = "#8b8000",
    ["pustynia"] = "#e3cb00",
    ["wzgorza"] = "#969e4a",
    ["podziemia"] = "#352f28",
    ["powietrze"] = "#7bafde",
    ["lawa"] = "#f70003",
    ["arena"] = "#a44003",
    ["tundra"] = "#354f29",
    ["stroma sciezka"] = "#323f02",
    ["wewnatrz"] = "#cd8803",
    ["puszcza"] = "#053912",
    ["pod woda"] = "#05006f",
    ["eden"] = "#06d400",
    ["trawa"] = "#039900",
    ["ruiny"] = "#922e30",
    ["miasto"] = "#983602",
    ["blotna sciezka"] = "#398669",
    ["jezioro"] = "#0a30fb",
    ["laka"] = "#289401",
    ["podziemna droga"] = "#737373",
    ["woda plyw"] = "#0039c9",
    ["rzeka"] = "#146be3",
    ["gorace zrodla"] = "#09c3c9",
    ["sciezka"] = "#697202",
    ["nieuzywany"] = "#820146",
    ["gory"] = "#6a522a",
    ["jaskinia"] = "#352f28",
    ["wys gory"] = "#3e290c",
    ["arktyczny lad"] = "#cacaca",
    ["lodowiec"] = "#efefef",
    ["park"] = "#039900",
    ["morze"] = "#1300c6",
    ["sawanna"] = "#517741",
    ["plaza"] = "#d2be5c",
    ["las"] = "#035703",
    ["ciemna woda"] = "#05006f",
    ["podziemne jezioro"] = "#0519a4",
    ["woda niep"] = "#08088e"
  }
  local i = 0
  for name, color in pairs(colors) do
    local r,g,b = kmapper:HEXtoRGB(color)
    setCustomEnvColor(100 + i, r, g, b, 255)
    --echo('["'..name..'"] = '..100+i..',\n')
    i = i + 1
  end
end

function kmapper:HEXtoRGB(hexArg)

	hexArg = hexArg:gsub('#','')

	if(string.len(hexArg) == 3) then
		return tonumber('0x'..hexArg:sub(1,1)) * 17, tonumber('0x'..hexArg:sub(2,2)) * 17, tonumber('0x'..hexArg:sub(3,3)) * 17
	elseif(string.len(hexArg) == 6) then
		return tonumber('0x'..hexArg:sub(1,2)), tonumber('0x'..hexArg:sub(3,4)), tonumber('0x'..hexArg:sub(5,6))
	else
		return 0, 0, 0
	end

end

--
-- INIT
--

kmapper:setupColors()