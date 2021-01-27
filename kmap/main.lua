module("kmap", package.seeall)

mudlet.mapper_script = true

kmap = kmap or {}
kmap.version = 3

kmap.doMap = function(params)
  if params == 'redraw' then
    kmap:mapRedraw(true)
  end
  kmap:delayedEventMapLoaded();
end

kmap.undoMap = function(params)
  closeMapWidget()
end

kmap.doUninstall = function()
  kmap:unregister()
end

kmap.doInstall = function()
  cecho('<gold>Odinstalowywanie domyślnego skryptu mappera... \n')
  uninstallPackage('generic_mapper')
  cecho('<green>gotowe.\n\n')
end

kmap.doInit = function()
  kmap:register()
end

--
--
--

kmap.ids = kmap.ids or {}
kmap.vnumToRoomIdCache = {}
kmap.mapLoaded = kmap.mapLoaded or false

function kmap:register()
  kmap:unregister()
  kmap.ids.roomInfoEvent = registerAnonymousEventHandler("gmcp.Room.Info", "kmap:roomInfoEventHandler")
  kmap.ids.sysExitEvent = registerAnonymousEventHandler("sysExitEvent", "kmap:sysExitEvent")
  kmap.ids.mapOpenEvent = registerAnonymousEventHandler("mapOpenEvent", "kmap:mapOpenEvent")
end

function kmap:unregister()
  if kmap.ids.roomInfoEvent then killAnonymousEventHandler(kmap.ids.roomInfoEvent) end
  if kmap.ids.sysExitEvent then killAnonymousEventHandler(kmap.ids.sysExitEvent) end
  if kmap.ids.mapOpenEvent then killAnonymousEventHandler(kmap.ids.mapOpenEvent) end
end

--
-- Centruje mape tylko jesli gracz juz nie stoi na danym roomie
--
function kmap:centerView(roomId)
  if getPlayerRoom() ~= roomId then
    centerview(roomId)
  end
end

--
-- Buduje cache roomów
--
function kmap:vnumCacheRebuild()
  kmap.vnumToRoomIdCache = {}
  for id,name in pairs(getRooms()) do
    local vnum = getRoomUserData(id, "vnum")
    if vnum ~= "" then
      if kmap.vnumToRoomIdCache[tonumber(vnum)] ~= nil then
        cecho('<red>UWAGA! Masz na mapie dwa roomy o takim samym vnumie! Room A: ' .. id .. ' Room B: ' .. kmap.vnumToRoomIdCache[tonumber(vnum)] .. '.\nRoom o wyższym roomId został zignowany i mapa nie będzie to niego skakała.\n')
      else
        kmap.vnumToRoomIdCache[tonumber(vnum)] = id
      end
    end
  end
end

--
-- Odnajdywanie lokacji na mapie
--
function kmap:mapLocate()
  if gmcp.Room == nil then
    return
  end
  local cachedRoomId = kmap.vnumToRoomIdCache[gmcp.Room.Info.num];
  if cachedRoomId ~= nil and not roomExists(cachedRoomId) then
    kmap:vnumCacheRebuild()
    kmap:mapLocate()
  end
  if cachedRoomId ~= nil and roomExists(cachedRoomId) then
    local roomId = kmap.vnumToRoomIdCache[gmcp.Room.Info.num]
    kmap:centerView(roomId)
  end
end

-- kasowanie labelek obrazkowych
function kmap:deleteImageLabels()
  for _, areaId in pairs(getAreaTable()) do
    local labels = getMapLabels(areaId)
    if type(labels) ~= 'table' then 
      labels = {}
    end
    for id, text in pairs(labels) do
      if text == 'no text' or text == '' or text == nil then
        deleteMapLabel(areaId, id)
      end
    end
  end
end

--
-- Map redraw
--
function kmap:mapRedraw(forceReload)
  if forceReload or kmap.labelsMap == nil then
    local f = assert(io.open(getMudletHomeDir() .. '/kmap/img/labelmap.json', "r"))
    local labelsFile = f:read("*all")
    f:close()
    kmap.labelsMap = yajl.to_value(labelsFile)
  end

  --czy trzeba przerysowac
  local shouldRepaint = 0
  local imageHashes = {}
  local totalLabelsFromJsonCount = 0
  for areaId, labels in pairs(kmap.labelsMap) do
    for id, label in pairs(labels) do
      imageHashes[string.format("%.3f", label.Width) .. string.format("%.3f", label.Height)] = label
      totalLabelsFromJsonCount = totalLabelsFromJsonCount + 1
    end
  end
  local usedLabelsFromJsonCount = 0
  for areaId, labels in pairs(kmap.labelsMap) do
    for id, _ in pairs(getMapLabels(areaId)) do
      local existing = getMapLabel(areaId, id)
      local label = imageHashes[string.format("%.3f", existing.Width) .. string.format("%.3f", existing.Height)]
      if label ~= nil then
        usedLabelsFromJsonCount = usedLabelsFromJsonCount + 1
      end
      if label == nil or label.X ~= existing.X or label.Y ~= existing.Y then
        shouldRepaint = 1
      end
    end
  end

  if totalLabelsFromJsonCount ~= usedLabelsFromJsonCount then
    shouldRepaint = 1
  end
  
  if shouldRepaint == 0 then
    return
  end
 
  kmap:deleteImageLabels()

  -- rysowanie ich od nowa
  for areaId, labels in pairs(kmap.labelsMap) do
    for _, label in pairs(labels) do
      createMapImageLabel(
        areaId,
        getMudletHomeDir() .. '/kmap/img/' .. label.File .. '.png',
        label.X,
        label.Y,
        0,
        label.Width,
        label.Height,
        50,
        false
      )
    end
  end
end

--
-- nasluchiwanie komunikatow gmcp.Room.Info
--
function kmap:roomInfoEventHandler()
  kmap:mapLocate()
end

--
-- załadowanie mapy
--
function kmap:eventMapLoaded()
  if kinstall:getConfig('mapLoaded') == false then
    kinstall:setConfig('mapLoaded', true)
    loadMap(getMudletHomeDir() .. '/kmap/mapa.dat')
  end
  openMapWidget()
  kmap:vnumCacheRebuild()
  kmap:mapLocate()
  kmap:mapRedraw(false)
  updateMap()
end

function kmap:delayedEventMapLoaded()
  tempTimer(0, function()
    kmap:eventMapLoaded()
  end)
end

--
-- usuwanie obrazkow przed zapisaniem mapy
--
function kmap:sysExitEvent()
  kmap:deleteImageLabels()
end

--
-- obsluga otwierania mapy przyciskiem z menu
--
function kmap:mapOpenEvent()
  kmap.doMap()
end
