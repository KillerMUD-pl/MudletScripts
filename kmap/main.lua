module("kmap", package.seeall)
setfenv(1, getfenv(2));

package.loaded['kmap/mapper'] = nil
require('kmap/mapper')

mudlet.mapper_script = true

kmap = kmap or {}
kmap.mapperBox = kmap.mapperBox or {}
kmap.messageBox = kmap.messageBox or {}
kmap.immoMap = kmap.immoMap or false
kmap.editMap = kmap.editMap or false

function kmap:doMap()
  local param = kinstall.params[1]
  if param == 'reload' then
    kmap:mapLoad(true)
    return
  end
  if param == 'symbol' then
    kmap:mapGroupSymbol(param[2])
    return
  end
  if param == 'check' then
    kmapper:mapCheck()
    return
  end
  if param == 'redraw' then
    kmap:mapRedraw(true)
    return
  end
  if param == 'load' then
    kmapper:mapLoad()
    return
  end
  if param == 'info' then
    kmapper:mapInfo(false)
    return
  end
  if param == 'zoom' then
    kmapper:mapZoom(kinstall.params[2])
    return
  end
  if param == 'refresh' then
    kmapper:mapRefresh()
    return
  end
  if param == 'start' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapStart()
    return
  end
  if param == 'stop' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapStop()
    return
  end
  if param == 'area' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapArea(kinstall.params[2])
    return
  end
  if param == 'step' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapStep(kinstall.params[2])
    return
  end
  if param == 'symbol' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapSymbol(kinstall.params[2])
    return
  end
  if param == 'forget' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapForget(false)
    return
  end
  if param == 'special' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapSpecial(kinstall.params[2], kinstall.params[3])
    return
  end
  if param == 'export' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:exportArea(getRoomArea(getPlayerRoom()))
    return
  end
  if param == 'import' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:importArea()
    return
  end
  if param == 'label' then
    if kinstall:getConfig('immoMap') ~= 'y' then cecho('<red>Nie włączyłeś funkcji edytora\n\n') return end
    kmapper:mapLabel(kinstall.params[2])
    return
  end

  if param == 'immo' then
    kmap.immoMap = kinstall:getConfig('immoMap')
    if kmap.immoMap == 'y' then
      cecho('<gold>Wyłączono tryb immo mapy.\n\n')
      kinstall:setConfig('immoMap', 'n')
      kmap.immoMap = 'n'
      kmap:unsetImmoMap()
    else
      cecho('<gold>Włączono tryb immo mapy.\n\n')
      kinstall:setConfig('immoMap', 'y')
      kmap.immoMap = 'y'
      kmap:setImmoMap()
    end
    return
  end
  if param == 'edit' then
    kmap.editMap = kinstall:getConfig('editMap')
    if kmap.editMap == 'y' then
      cecho('<gold>Wyłączono tryb edycji mapy.\n\n')
      kinstall:setConfig('editMap', 'n')
      kmap:unsetEditMap()
      else
      cecho('<gold>Włączono tryb edycji mapy.\n\n')
      kinstall:setConfig('editMap', 'y')
      kmap:setEditMap()
    end
    return
  end
  if param ~= "silent" then
    cecho('<gold>Włączam mapę\n')
  end
  kmap:delayedmapLoad();
  kinstall:setConfig('mapa', 't')
end

function kmap:undoMap()
  local param = kinstall.params[1]
  if param ~= 'silent' then
    cecho('<gold>Wyłączam mapę\n')
  end
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
  if kinstall:getConfig('mapaInfo') ~= 't' then
    cecho('<green>gotowe.\n\n')
    cecho('<orange>=========================\n')
    cecho('<orange>==     PRZECZYTAJ!     ==\n')
    cecho('<orange>=========================\n\n')
    cecho('<orange>Od teraz mapę włącza się komendą <cyan>+map <orange>a wyłącza komendą <cyan>-map\n\n')
    cecho('<orange>Przycisk Map na pasku narzędzi mudleta <red>nie będzie działał<orange>.\n\n')
    cecho('<orange>Postaram się to zmienić w przyszłości, ale w tej chwili nie ma sposobu na przechwycenie faktu\n')
    cecho('<orange>kliknięcia w ten przycisk, być może za jakiś czas się to zmieni.\n\n')
    cecho('<orange>Dodatkowo, jesli od momentu ostatniego uruchomienia Mudleta, do zainstalowania\n')
    cecho('<orange>tych skryptów używałeś już przycisku "Map" na górze ekranu, musisz teraz ponownie\n')
    cecho('<orange>uruchomić Mudleta. Nic na to nie poradze - to bug w Mudlecie.\n')
    cecho('<orange>Po następnym odpaleniu Mudleta będzie już dobrze.\n\n')
    cecho('<orange>W przypadku problemów z załadowaniem się, lub działaniem mapy spróbuj wpisać\n')
    cecho('<orange><cyan>+map redraw <orange>(przerysowanie obrazków/etykiet) lub <cyan>+map reload <orange>(ponownie załadowanie mapy z dysku)\n\n')
    cecho('<orange>Zalecane ustawienia mapki:\n')
    cecho('<orange> - na panelu na dole mapki odznacz "Info"\n')
    cecho('<orange> - zmień cyfrę przy "Rooms" na 8\n')
    cecho('<orange> - kliknij poziomy pasek ze znaczkiem "^" żeby schować panel ustawień\n\n')
  end
  kinstall:setConfig('mapaInfo', 't')
end

function kmap:doInit()
  kmap:register()
  if kinstall:getConfig('mapa') == 't' then
    kinstall.params[1] = 'silent'
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

function kmap:showHelp()
  cecho('<gold>POMOC MODUŁU MAPY')
end

--
-- Wyswietla okienko mapy
--
function kmap:addBox()
  local wrapper = kgui:addBox('mapper', 300, "Mapa", "map")
  kmap.mapperBox = Geyser.Label:new({
    name = 'mapper',
    x = 2,
    y = kgui.baseFontHeightPx + 2 .. "px",
    width = "100%-4px",
    height = "100%-".. kgui.baseFontHeightPx + 4 .."px",
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
    width = "100%-4px",
    height = "40",
    x = "2px",
    y = "2px"
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
    return roomId
  else
    if kinstall.receivingGmcp == false then
      centerview(18914)
    end
  end
  return nil
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
    if kmapper.mapping ~= true then
      kmap:mapLocate()
    end
  end
end

--
-- załadowanie mapy
--
function kmap:mapLoad(forceReload)
  kmap:addMapper()
  if getMapUserData("type") ~= 'killermud' or forceReload then
    cecho('<gold>Ładuje mapę z dysku\n')
    loadMap(getMudletHomeDir() .. '/kmap/mapa.dat')
  end
  kmap:vnumCacheRebuild()
  if gmcp.Room == nil then
    centerview(18914)
  end
  kmap:mapLocate()
  kmap:mapRedraw(false)
  kmap:removeGroup()
  kmap.editMap = kinstall:getConfig('editMap')
  if kmap.editMap == 'y' then
    kmap:setEditMap()
  else
    kmap:unsetEditMap()
  end
  kmap.immoMap = kinstall:getConfig('immoMap')
  if kmap.immoMap == 'y' then
    kmap:setImmoMap()
  else
    kmap:unsetImmoMap()
  end
  updateMap()
end

function kmap:delayedmapLoad()
  closeMapWidget()
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
        for id, text in pairs(getMapLabels(areaId)) do
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
    kmap.messageBox:rawEcho('<center>' .. kgui:transliterate(gmcp.Room.Info[1].unavailable) .. '</center>')
    return
  end

  -- sprawdzamy czy mamy informacje o grupie
  local group = gmcp.Char.Group
  if group[1] ~= nil and group[1].unavailable ~= nil then
    kmap.messageBox:show()
    kmap.messageBox:rawEcho('<center>' .. kgui:transliterate(group[1].unavailable) .. '</center>')
    return
  end

  if group.members == nil and kgui.ui.info == nil then
    return
  end

  if #group.members == 1 then
    return
  end

  kmap.messageBox:hide()

  local symbolMode = "num"
  if kgui:isClosed('group') then symbolMode = "short" end
  if kmap.immoMap == "y" then symbolMode = "name" end

  local playerSymbols = { "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪", "⑫", "⑬", "⑭", "⑮", "⑯", "⑰", "⑱", "⑲", "②"}

  -- rysowanie playerow z kolkami zamiast charmow
  local members = {}
  local lastPlayerId = nil
  local playerId = 1
  local mobId = 1
  for _, player in ipairs(group.members) do
    if player.is_npc and lastPlayerId ~= nil and members[lastPlayerId] ~= nil then
      if members[lastPlayerId] ~= nil and members[lastPlayerId].room == player.room then
        members[lastPlayerId].name = members[lastPlayerId].name .. '°'
      else
        members["m" .. mobId] = {
          ["name"] = "©",
          ["room"] = player.room,
        }
      end
      mobId = mobId + 1
    else
      members[playerId] = {
        ["name"] = player.name,
        ["room"] = player.room,
      }
      lastPlayerId = playerId
      if symbolMode == "num" then
        members[lastPlayerId].name = playerSymbols[playerId]
      end
      if symbolMode == "short" then
        members[lastPlayerId].name = utf8.sub(members[lastPlayerId].name, 1, 3)
      end
    end
    playerId = playerId + 1
  end

  -- grupowanie ludzi wedlug lokalizacji
  local labelForRoom = {}
  local labelCharCountForRoom = {}
  for _, player in pairs(members) do
    local roomLabel = labelForRoom[player.room]
    local playerChar = player.name
    if symbolMode ~= "num" then
      playerChar = kgui:transliterate(player.name) .. '\n'
    end
    -- !!! w tych cudzyslowiach jest znak niewidocznej spacji !!!
    if roomLabel == nil then roomLabel = "​" end
    labelForRoom[player.room] = roomLabel .. playerChar
    if labelCharCountForRoom[player.room] == nil then labelCharCountForRoom[player.room] = 0 end
    labelCharCountForRoom[player.room] = labelCharCountForRoom[player.room] + 1
    if symbolMode == "num" and labelCharCountForRoom[player.room] % 3 == 0 then
      labelForRoom[player.room] = labelForRoom[player.room] .. '\n'
    end
  end

  for room, label in pairs(labelForRoom) do
    local roomId = kmap.vnumToRoomIdCache[room]
    if roomId ~= nil then
      local fontW, fontH = calcFontSize(20, "Marcellus")
      local deltaX = fontW * 3 / 20  / 2
      if symbolMode == "num" then
        local symbolCount = labelCharCountForRoom[room]
        if symbolCount > 3 then symbolCount = 3 end
        deltaX = fontW * symbolCount / 20
      end
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
    kmap.messageBox:rawEcho('<center>Zaloguj się do gry lub włącz GMCPs</center>')
  end
end

--
-- dodatki dla immo na mapie
--
function kmap:setImmoMap()
  addMapEvent('🚀 Skocz tutaj', 'mapJumpTo')
  if kmap.ids.onKMapJumpTo then killAnonymousEventHandler(kmap.ids.onKMapJumpTo) end
  kmap.ids.onKMapJumpTo = registerAnonymousEventHandler("mapJumpTo", function() kmap:jumpTo() end)
end

function kmap:unsetImmoMap()
  if kmap.ids.onKMapJumpTo then killAnonymousEventHandler(kmap.ids.onKMapJumpTo) end
  removeMapEvent('🚀 Skocz tutaj')
end

--
-- dodatki dla edytorow na mapie
--
function kmap:setEditMap()
  addMapEvent('🔍 Info', 'mapInfo')
  addMapEvent('🗑 Wyczyść dane', 'mapForget')
  if kmap.ids.onKMapForget then killAnonymousEventHandler(kmap.ids.onKMapForget) end
  kmap.ids.onKMapForget = registerAnonymousEventHandler("mapForget", function() kmapper:mapForget(true) end)
  if kmap.ids.onKMapInfo then killAnonymousEventHandler(kmap.ids.onKMapInfo) end
  kmap.ids.onKMapInfo = registerAnonymousEventHandler("mapInfo", function() kmapper:mapInfo(true) end)
end

function kmap:unsetEditMap()
  if kmap.ids.onKMapForget then killAnonymousEventHandler(kmap.ids.onKMapForget) end
  if kmap.ids.onKMapInfo then killAnonymousEventHandler(kmap.ids.onKMapInfo) end
  removeMapEvent("🔍 Info")
  removeMapEvent("🗑 Wyczyść dane")
end

--
-- Skakanie po mapie
--
function kmap:jumpTo()
  local selectedRooms = getMapSelection()["rooms"]
  if selectedRooms == nil or #selectedRooms == 0 then
    cecho('\n<red>Najpierw zaznacz room na mapie!\n')
    return
  end
  local roomId = selectedRooms[1];
  local vnum = getRoomUserData(roomId, "vnum")
  send('goto ' .. vnum .. '\n')
  kmap:centerView(roomId)
end
