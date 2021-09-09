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

function kspeedwalk:init()
  local path = kinstall:getConfig('highlight')
  kspeedwalk:unhighlight(path)
  kinstall:setConfig('highlight', {})
end

--
-- Rozpoczyna speedwalk wedlug sciezki podanej przez Mudleta
--
function kspeedwalk:start()
  kspeedwalk:unhighlight(kspeedwalk.roomIdQueue)
  kspeedwalk.dirQueue = speedWalkDir
  kspeedwalk.roomIdQueue = speedWalkPath
  local targetRoomId = kspeedwalk.roomIdQueue[#kspeedwalk.roomIdQueue]
  local targetRoomName = getRoomUserData(targetRoomId, 'name')
  local success, cost = getPath(getPlayerRoom(), targetRoomId)
  if success ~= true then
    cecho('\n<red>Nie znaleziono ścieżki do tego miejsca')
    return nil
  end
  kspeedwalk:highlight(kspeedwalk.roomIdQueue)
  cecho('\n<gold>Ścieżka do <green>' .. targetRoomName .. ' (id: ' .. targetRoomId .. ')<gold> znaleziona.\nSzacowana ilość punktów ruchu: <green>'.. cost ..'\n<gold>Wpisz <green>+walk<gold> by rozpocząć, <green>+stop<gold> by zakończyć.\n')
end

function kspeedwalk:highlight(path)
  for _, roomId in ipairs(path) do
    highlightRoom(roomId, 255, 255, 255, 0, 0, 0, 1, 255, 0)
  end
  kinstall:setConfig('highlight', path)
end

function kspeedwalk:unhighlight(path)
  for _, roomId in ipairs(path) do
    unHighlightRoom(roomId)
  end
  kinstall:setConfig('highlight', {})
end

function kspeedwalk:walk()
  cecho('\n<gold>Rozpoczęto podróż.\n')
  kspeedwalk.walking = true
  kspeedwalk:step()
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
    kspeedwalk.lastRoomId = currentRoomId
    send(next)
  end
end

function kspeedwalk:findExit(fromRoomId, toRoomId, toDir)
  toDir = string.lower(toDir)
  local roomData = getAllRoomUserData(fromRoomId)
  local roomExits = getRoomExits(fromRoomId)
  local namedDir = kmapper.swapDirTable[toDir]
  local normalExit = roomExits[namedDir]
  local specialExit = roomData[toDir];

  local closedDoor = kspeedwalk:checkDoor()
  if closedDoor ~= nil then
    send('open ' .. closedDoor)
  end
  if specialExit ~= nil then
    specialExit = yajl.to_value(specialExit)
    if specialExit.command ~= nil then
      return specialExit.command
    end
  end
  if normalExit ~= nil then
    return toDir
  end
  return nil
end

function kspeedwalk:checkDoor()
  if gmcp == nil or gmcp.Room == nil or gmcp.Room.Info == nil or gmcp.Room.Info.exits == nil then
    return nil
  end
  local exits = gmcp.Room.Info.exits
  local foundExit = nil
  for _, v in ipairs(exits) do
    if v ~= nil and v.closed == true then
      local doorName = v.dir
      if v.name ~= "" then
        doorName = v.name
      end
      return doorName
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
