module("kmap", package.seeall)
setfenv(1, getfenv(2));

mudlet.mapper_script = true

kmap = kmap or {}
kmap.mapperBox = kmap.mapperBox or {}
kmap.messageBox = kmap.messageBox or {}
kmap.immoMap = kmap.immoMap or false

function kmap:doMap()
  local param = kinstall.params[1]
  if param == 'reload' then
    kmap:mapLoad(true)
    return
  end
  if param == 'redraw' then
    kmap:mapRedraw(true)
    return
  end
  if param == 'immo' then
    kmap.immoMap = kinstall:getConfig('immoMap')
    if kmap.immoMap == 'y' then
      cecho('<gold>Wyłączono tryb immo mapy.\n\n')
      kinstall:setConfig('immoMap', 'n')
      kmap:unsetImmoMap()
      else
      cecho('<gold>Włączono tryb immo mapy.\n\n')
      kinstall:setConfig('immoMap', 'y')
      kmap:setImmoMap()
    end
    return
  end
  cecho('<gold>Włączam mapę\n')
  kmap:delayedmapLoad();
  kinstall:setConfig('mapa', 't')
end

function kmap:undoMap(params)
  cecho('<gold>Wyłączam mapę\n')
  kmap:removeBox()
  kinstall:setConfig('mapa', 'n')
end

function kmap:doUninstall()
  kmap:undoMap()
  kmap:unregister()
end

function kmap:doInstall()
  cecho('<gold>Odinstalowywanie domyślnego skryptu mappera... ')
  uninstallPackage('generic_mapper')
  uninstallModule('generic_mapper')
  if map ~= nil then
    map.eventHandler = function() end
  end
  cecho('<green>gotowe.\n\n')
  cecho('<orange>=========================\n')
  cecho('<orange>==     PRZECZYTAJ!     ==\n')
  cecho('<orange>=========================\n\n')
  cecho('<orange>Od teraz mapę włącza się komendą <cyan>+map <orange>a wyłącza komendą <cyan>-map\n\n')
  cecho('<orange>Przycisk Map na pasku narzędzi mudleta <red>nie będzie działał<orange>.\n\n')
  cecho('<orange>Postaram się to zmienić w przyszłości, ale w tej chwili nie ma sposobu na przechwycenie faktu\n')
  cecho('<orange>kliknięcia w ten przycisk, być może za jakiś czas się to zmieni.\n\n')
  cecho('<orange>W przypadku problemów z załadowaniem się, lub działaniem mapy spróbuj wpisać\n')
  cecho('<orange><cyan>+map redraw <orange>(przerysowanie obrazków/etykiet) lub <cyan>+map reload <orange>(ponownie załadowanie mapy z dysku)\n\n')
end

function kmap:doInit()
  kmap:register()
  if kinstall:getConfig('mapa') == 't' then
    kmap:doMap()
  end
end

--
--
--

kmap.ids = kmap.ids or {}
kmap.vnumToRoomIdCache = {}

function kmap:register()
  kmap:unregister()
  kmap.ids.roomInfoEvent = registerAnonymousEventHandler("gmcp.Room.Info", "kmap:roomInfoEventHandler")
  kmap.ids.charGroupEvent = registerAnonymousEventHandler("gmcp.Char.Group", "kmap:charGroupEventHandler")
  kmap.ids.sysExitEvent = registerAnonymousEventHandler("sysExitEvent", "kmap:sysExitEvent")
  kmap.ids.receivingGmcpTimer = tempTimer(2, [[ kmap:checkGmcp() ]], true)
end

function kmap:unregister()
  if kmap.ids.roomInfoEvent then killAnonymousEventHandler(kmap.ids.roomInfoEvent) end
  if kmap.ids.charGroupEvent then killAnonymousEventHandler(kmap.ids.charGroupEvent) end
  if kmap.ids.sysExitEvent then killAnonymousEventHandler(kmap.ids.sysExitEvent) end
  if kmap.ids.receivingGmcpTimer then killTimer(kmap.ids.receivingGmcpTimer) end
end

--
-- Wyswietla okienko mapy
--
function kmap:addBox()
  closeMapWidget()
  local wrapper = kgui:addBox('mapper', 300, "Mapa", function() kmap:undoMap() end)
  kmap.mapperBox = Geyser.Label:new({
    name = 'mapper',
    width = "100%-4px",
    height = "100%-22px",
    x = "2px",
    y = "20px"
  }, wrapper)
  wrapper.windowList.mapperWrapperadjLabel:setStyleSheet([[
    QWidget {
      background: rgba(0,0,0,0);
    }
  ]])
  kmap.mapperBox:setStyleSheet([[
    background: rgba(0,0,0,0);
    border: 2px solid (30,30,30,230)
  ]])
  
  kmap.messageBox = Geyser.Label:new({
    name = 'mapperMessage',
    width = "100%",
    height = "40",
    x = "0px",
    y = "0px"
  }, kmap.mapperBox)
  kmap.messageBox:setStyleSheet([[ background: rgba(0,0,0,0.8); color: #e0e0e0; font-size: 12px; font-family: sans-serif; ]])
  kmap.messageBox:enableClickthrough()
  kmap.messageBox:hide()

  kgui:update()
end

--
-- Dodaje mape do okienka
--
function kmap:addMapper()
  local mapper = Geyser.Mapper:new({
    embedded = true,
    name = 'mapperElement',
    width = "100%-4px",
    height = "100%-4px",
    x = "2px",
    y = "2px"
  }, kmap.mapperBox)
  mapper.container:lowerAll()
  kgui:update()
end

--
-- Usuwa okienko mapy
--
function kmap:removeBox()
  closeMapWidget()
  kgui:removeBox('mapper')
  kgui:update()
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
  else
    if kinstall.receivingGmcp == false then
      centerview(18914)
    end
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
      -- nie kasujemy laabelek "?" w Default Area
      if id ~= -1 and text ~= "?" then
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
    local areaLabels = getMapLabels(areaId)
    if areaLabels == nil or type(areaLabels) ~= 'table' then areaLabels = {} end
    for id, txt in pairs(areaLabels) do
      -- specjalny przypadek dla labelek "?" w Default Area
      if id ~= -1 and txt ~= "?" then
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
  end

  if totalLabelsFromJsonCount ~= usedLabelsFromJsonCount then
    shouldRepaint = 1
  end
  
  if shouldRepaint == 0 then
    return
  end
 
  cecho('<gold>Przerysowuje obrazki na mapie\n')
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
  -- przeniesione do group event, poniewaz nastepuje on nieco pozniej, i chcemy uniknac podwojnego odswiezania mappera
end
--
-- nasluchiwanie komunikatow gmcp.Char.Group
--
function kmap:charGroupEventHandler()
  if kmap.mapperBox ~= nil and kgui.ui.mapper ~= nil and kgui.ui.mapper.wrapper.hidden ~= true then
    kmap:drawGroup()
    kmap:mapLocate()
  end
end

--
-- załadowanie mapy
--
function kmap:mapLoad(forceReload)
  if getMapUserData("type") ~= 'killermud' or forceReload then
    cecho('<gold>Ładuje mapę z dysku\n')
    loadMap(getMudletHomeDir() .. '/kmap/mapa.dat')
  end
  kmap:addMapper()
  kmap:vnumCacheRebuild()
  kmap:mapLocate()
  kmap:mapRedraw(false)
  kmap:removeGroup()
  kmap.immoMap = kinstall:getConfig('immoMap')
  if kmap.deleteImageLabelsimmoMap == 'y' then
    kmap:setImmoMap()
  else
    kmap:unsetImmoMap()
  end
  echo('\n')
  updateMap()
end

function kmap:delayedmapLoad()
  kmap:addBox()
  tempTimer(0, function()
    kmap:mapLoad(false)
  end)
end

--
-- usuwanie obrazkow przed zapisaniem mapy
--
function kmap:sysExitEvent()
  kmap:deleteImageLabels()
end

--
-- Usuwanie grupki z mapy
--
function kmap:removeGroup()
    -- usuwanie znaczkow grupy z mapy
    for _, areaId in pairs(getAreaTable()) do
      local labels = getMapLabels(areaId)
      if labels ~= nil and type(labels) == "table" then
        for id, text in ipairs(getMapLabels(areaId)) do
          -- !!! w tych cudzyslowiach jest znak niewidocznej spacji !!!
          if text:starts("​") then
            deleteMapLabel(areaId, id)
          end
        end
      end
    end
end

--
-- Rysowanie grupki na mapie
--
function kmap:drawGroup()
  kmap:removeGroup()

  -- sprawdzamy czy mamy informacje o lokalizacji
  if gmcp.Room.Info[1] ~= nil and gmcp.Room.Info[1].unavailable ~= nil then
    kmap.messageBox:show()
    kmap.messageBox:rawEcho('<center>' .. gmcp.Room.Info[1].unavailable .. '</center>')
    return
  end

  -- sprawdzamy czy mamy informacje o grupie
  local group = gmcp.Char.Group
  if group[1] ~= nil and group[1].unavailable ~= nil then
    kmap.messageBox:show()
    kmap.messageBox:rawEcho('<center>' .. group[1].unavailable .. '</center>')
    return
  end

  if group.members == nil and kgui.ui.info == nil then
    return
  end

  if #group.members == 1 then
    return
  end

  kmap.messageBox:hide()

  -- rysowanie playerow z kolkami zamiast charmow
  local members = {}
  local lastPlayerName = nil
  for _, player in ipairs(group.members) do
    if player.is_npc and lastPlayerName ~= nil and members[lastPlayerName] ~= nil then
      members[lastPlayerName].name = members[lastPlayerName].name .. '•'
    else
      members[player.name] = player
      lastPlayerName = player.name
      members[lastPlayerName].name = string.sub(members[lastPlayerName].name, 1, 3)
    end
  end

  -- grupowanie ludzi wedlug lokalizacji
  local labelForRoom = {}
  local labelCharCountForRoom = {}
  for _, player in pairs(members) do
    local roomLabel = labelForRoom[player.room]
    local playerChar =player.name .. '\n'
    -- !!! w tych cudzyslowiach jest znak niewidocznej spacji !!!
    if roomLabel == nil then roomLabel = "​" end
    labelForRoom[player.room] = roomLabel .. playerChar
    if labelCharCountForRoom[player.room] == nil then labelCharCountForRoom[player.room] = 0 end
    labelCharCountForRoom[player.room] = labelCharCountForRoom[player.room] + 1
  end

  for room, label in pairs(labelForRoom) do
    local roomId = kmap.vnumToRoomIdCache[room]
    if roomId ~= nil then
      local fontW, fontH = calcFontSize(14, "Marcellus")
      --local deltaX = fontW * labelCharCountForRoom[room] / 20
      local deltaX = fontW * 3 / 20  / 2
      local roomX, roomY, roomZ = getRoomCoordinates(roomId)
      createMapLabel(getRoomArea(roomId), label, roomX - deltaX, roomY + 1, roomZ, 240, 240, 240, 0, 0, 0, 30, 14, true, true)
    end
  end

  return
end

function kmap:checkGmcp()
  if kmap == nil or kmap.messageBox == nil or kmap.messageBox.show == nil then return end
  if kinstall.receivingGmcp == false and not (kgui.ui ~= nil and kgui.ui.info ~= nil and kgui.ui.info.wrapper.hidden == false ) then
    kmap.messageBox:show()
    kmap.messageBox:rawEcho('<center>Zaloguj się do gry, lub wpisz <code>config gmcp</code> jeśli już jesteś w grze.<br>Oczekiwanie na informacje z GMCP...</center>')
  end
end

--
-- dodatki dla immo na mapie
--
function kmap:setImmoMap()
  addMapEvent("🧰 Skocz do rooma", "onKMapGoto")
  if kmap.ids.onKMapGotoEvent then killAnonymousEventHandler(kmap.ids.onKMapGotoEvent) end
  kmap.ids.onKMapGotoEvent = registerAnonymousEventHandler("onKMapGoto", "kmap:gotoRoom")
end

function kmap:unsetImmoMap()
  if kmap.ids.onKMapGotoEvent then killAnonymousEventHandler(kmap.ids.onKMapGotoEvent) end
  removeMapEvent("🧰 Skocz do rooma")
end

function kmap:gotoRoom()
  local sel = getMapSelection()["rooms"]
  if sel == nil or #sel == 0 then
    return
  end
  send("goto " .. getRoomUserData(sel[1], "vnum"))
end
