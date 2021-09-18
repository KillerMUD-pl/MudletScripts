module("kinstall/speedwalk", package.seeall)
setfenv(1, getfenv(2));

-- globalne zmienne
kspeedwalk = kspeedwalk or {}
kspeedwalk.dirQueue = {}
kspeedwalk.roomIdQueue = {}
kspeedwalk.walking = false
kspeedwalk.nextId = nil
kspeedwalk.nextDir = nil
kspeedwalk.lastRoomId = nil
kspeedwalk.poi = {}
kspeedwalk.autowalk = false

function kspeedwalk:init()
  local path = kinstall:getConfig('highlight', {})
  kspeedwalk:unhighlight(path)
  kinstall:setConfig('highlight', {})
  kspeedwalk.poi = kinstall:getConfig('poi', {})
  kspeedwalk.autowalk = kinstall:getConfig('autowalk', false)
end

--
-- Rozpoczyna speedwalk wedlug sciezki podanej przez Mudleta
--
function kspeedwalk:start()
  local targetRoomName, targetRoomId, cost = kspeedwalk:prepare()
  if kspeedwalk.autowalk == true then
    kspeedwalk.walking = true
    kspeedwalk:step()
    return nil
  end
  cecho('\n<gold>Ścieżka do <green>' .. targetRoomName .. ' (id: ' .. targetRoomId .. ')<gold> znaleziona.\nSzacowana ilość punktów ruchu: <green>'.. cost ..'\n<gold>Wpisz <green>+walk<gold> by rozpocząć, <green>+stop<gold> by zakończyć.\n')
end

function kspeedwalk:prepare()
  kspeedwalk:unhighlight(kspeedwalk.roomIdQueue)
  kspeedwalk.dirQueue = speedWalkDir
  kspeedwalk.roomIdQueue = speedWalkPath
  kspeedwalk.lastRoomId = nil
  local targetRoomId = kspeedwalk.roomIdQueue[#kspeedwalk.roomIdQueue]
  local targetRoomName = getRoomUserData(targetRoomId, 'name')
  local success, cost = getPath(getPlayerRoom(), targetRoomId)
  if success ~= true then
    cecho('\n<red>Nie znaleziono ścieżki do tego miejsca')
    return nil
  end
  kspeedwalk:highlight(kspeedwalk.roomIdQueue)
  return targetRoomName, targetRoomId, cost
end

function kspeedwalk:highlight(path)
  for _, roomId in ipairs(path) do
    highlightRoom(roomId, 255, 255, 255, 0, 0, 0, 1, 255, 0)
  end
  kinstall:setConfig('highlight', path)
end

function kspeedwalk:unhighlight(path)
  if path == nil or path == false then return nil end
  for _, roomId in ipairs(path) do
    unHighlightRoom(roomId)
  end
  kinstall:setConfig('highlight', {})
end

function kspeedwalk:walk(param)
  if param == "auto" then
    if kspeedwalk.autowalk == false then
      kspeedwalk.autowalk = true
      kinstall:getConfig('autowalk', true)
      cecho('\n<gold>Włączono automatyczne rozpoczynanie podróży po dwu-kliku na mapie\n')
      return nil
    end
    kspeedwalk.autowalk = false
    kinstall:getConfig('autowalk', false)
    cecho('\n<gold>Wyłączono automatyczne rozpoczynanie podróży po dwu-kliku na mapie\n')
    return nil
  end
  if param == "" then
    if #kspeedwalk.roomIdQueue == 0 then
      cecho('\n<red>Chciałbyś gdzieś podróżować, tylko gdzie?')
      cecho('\n<gold>Kliknij dwukrotnie na lokację na mapie by wybrać cel podróży lub użyj instrukcji <green>+poi\n')
      return nil
    end
    cecho('\n<gold>Rozpoczęto podróż.\n')
    kspeedwalk.walking = true
    kspeedwalk.lastRoomId = nil
    kspeedwalk:step()
  else
    local poi = kspeedwalk:findPoi(param)
    if poi == nil then
      cecho('\n<red>Nie znaleziono lokacji <green>'.. param ..'\n')
      return nil
    end
    if kgui:isClosed('mapper') then
      cecho('\n<red>Z powodów technicznych, nie można nawigować do zapisanego punktu kiedy mapa jest zamknięta. Musi być otwarta, lub przynajmniej zminimalizowana.\n')
      return nil
    end
    getPath(getPlayerRoom(), poi.id)
    kspeedwalk:prepare()
    kspeedwalk.walking = true
    kspeedwalk:step()
  end
end

function kspeedwalk:stop()
  kspeedwalk:unhighlight(kspeedwalk.roomIdQueue)
  kspeedwalk.roomIdQueue = {}
  kspeedwalk.dirQueue = {}
  kspeedwalk.walking = false
  kspeedwalk.lastRoomId = nil
  cecho('\n<gold>Zakończono podróż.\n')
end

function kspeedwalk:step()
  local nextId = kspeedwalk.roomIdQueue[1]
  local nextDir = kspeedwalk.dirQueue[1]
  local currentRoomId = getPlayerRoom()
  if currentRoomId == kspeedwalk.lastRoomId then
    return nil
  end

  -- koniec podrozy
  if nextId == nil and kspeedwalk.walking == true then
    kspeedwalk:stop()
    return nil
  end

  if currentRoomId == nil or nextId == nil then
    return nil
  end

  nextId = tonumber(nextId)
  if currentRoomId == nextId then
    table.remove(kspeedwalk.roomIdQueue, 1)
    table.remove(kspeedwalk.dirQueue, 1)
    unHighlightRoom(currentRoomId)
    return kspeedwalk:step()
  end

  if kspeedwalk.walking ~= true then
    return nil
  end
  local next = kspeedwalk:findExit(currentRoomId, nextId, nextDir)
  if next ~= nil and next ~= '' then
    send(next)
    kspeedwalk.lastRoomId = currentRoomId
    return nil
  end

  if kspeedwalk.walking then
    cecho('<red>Zgubiłem droge, przeliczam trasę...\n')
    local targetRoomId = kspeedwalk.roomIdQueue[#kspeedwalk.roomIdQueue]
    local path, cost = getPath(getPlayerRoom(), targetRoomId)
    if cost == 0 then
      cecho('Ojoj... zgubiłem się totalnie...\n')
    end
    kspeedwalk:prepare()
    kspeedwalk:step()
  end
end

function kspeedwalk:findExit(fromRoomId, toRoomId, toDir)
  toDir = string.lower(toDir)
  local roomData = getAllRoomUserData(fromRoomId)
  local roomExits = getRoomExits(fromRoomId)
  local namedDir = kmapper.swapDirTable[toDir]
  local normalExit = roomExits[namedDir]
  local specialExit = roomData[toDir];

  local command = nil
  if normalExit ~= nil and normalExit == toRoomId then
    command = toDir
  end
  if specialExit ~= nil then
    specialExit = yajl.to_value(specialExit)
    if specialExit.command ~= nil and specialExit.id == toRoomId then
      command = specialExit.command
    end
  end
  if command ~= nil then
    local closedDoor = kspeedwalk:checkDoor(command)
    if closedDoor ~= nil then
      send('open ' .. closedDoor)
    end
    return command
  end
  return nil
end

function kspeedwalk:checkDoor(command)
  if gmcp == nil or gmcp.Room == nil or gmcp.Room.Info == nil or gmcp.Room.Info.exits == nil then
    return nil
  end
  local exits = gmcp.Room.Info.exits
  local foundExit = nil
  for _, v in ipairs(exits) do
    local doorName = string.lower(v.dir)
    if v.name ~= "" then
      doorName = v.name
    end
    if v ~= nil and string:areLooselySame(doorName, command) and v.closed == true then
      return command
    end
  end
  return nil
end

function kspeedwalk:markLockedRooms()
  for _, areaId in pairs(getAreaTable()) do
    local roomIds = getAreaRooms(areaId)
    if type(roomIds) ~= 'table' then
      roomIds = {}
    end
    for _, id in pairs(roomIds) do
      local char = getRoomChar(id)
      if char ~= nil and (string.starts(char, "!") or string.starts(char, "‼")) then
        lockRoom(id, true)
      end
    end
  end
end

function kspeedwalk:poiAdd(param)
  if param == "auto" then
    cecho('\nSorki, nie możesz dodać poi o nazwie "auto"\n')
  end
  if param == "" then
    cecho('\n<gold>Zapisane lokacje:\n')
    if #kspeedwalk.poi == 0 then
      cecho('<gray>(brak)\n')
    else
      for _, poi in pairs(kspeedwalk.poi) do
        cecho('<green>' .. poi.phrase .. '<DimGray> - '.. poi.name ..' (vnum: ' .. poi.vnum .. ')')
      end
    end
    cecho('\n\n<gold>Możesz dodac lokacje do tej listy wpisując <green>+poi <nazwa><gold> stojąc w lokacji którą chcesz zapisać')
    cecho('\n<gold>Aby podróżować do danej lokacji, wpisz <green>+walk <nazwa>\n')
  else
    local roomId = getPlayerRoom();
    local vnum = getRoomUserData(roomId, 'vnum')
    if vnum == nil then
      cecho('\n<red>Lokacja w której stoisz nie jest poprawnie zmapowana, brakuje jej vnuma.\n')
      return nil
    end
    local name = getRoomUserData(roomId, 'name')
    if name == nil then
      cecho('\n<red>Lokacja w której stoisz nie jest poprawnie zmapowana, brakuje jej nazwy.\n')
      return nil
    end
    local existingPoi = kspeedwalk:findPoi(param)
    if existingPoi ~= nil then
      cecho('\n<red>Lokacja o takiej nazwie już istnieje: <green>' .. existingPoi.phrase .. '<DimGray> - '.. existingPoi.name ..' (vnum: ' .. existingPoi.vnum .. ')\n')
      return nil
    end
  
    local poi = {}
    poi['name'] = name
    poi['vnum'] = vnum
    poi['phrase'] = param
    poi['id'] = roomId
    table.insert(kspeedwalk.poi, poi)
    kinstall:setConfig('poi', kspeedwalk.poi)
    cecho('\n<gold>Dodano nową lokację: <green>' .. poi.phrase .. '<DimGray> - '.. poi.name ..' (vnum: ' .. poi.vnum .. ')\n')
  end
end

function kspeedwalk:removePoi(param)
  if param == "" then
    cecho('\n<red>Musisz podać lokację do usunięcia\n')
    return nil
  end
  local poi, poiIndex = kspeedwalk:findPoi(param)
  if poiIndex == nil then
    cecho('\n<red>Nie znaleziono lokacji <green>'.. param ..'\n')
    return nil
  end
  cecho('\n<gold>Usunięto lokację: <green>' .. poi.phrase .. '<DimGray> - '.. poi.name ..' (vnum: ' .. poi.vnum .. ')\n')
  table.remove(kspeedwalk.poi, poiIndex)
  kinstall:setConfig('poi', kspeedwalk.poi)
end

function kspeedwalk:findPoi(param)
  for index, item in pairs(kspeedwalk.poi) do
    if item.phrase == param then
      return item, index
    end
  end
  return nil, nil
end