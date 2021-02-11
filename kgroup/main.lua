module("kgroup", package.seeall)
setfenv(1, getfenv(2));

kgroup = kgroup or {}
kgroup.group_box = nil
kgroup.enabled = false

function kgroup:doInfo()
  cecho('<gold>Włączam panel grupy\n')
  kgroup:addBox()
  kinstall:setConfig('group', 't')
  kgroup.enabled = true
end

function kgroup:undoInfo()
  cecho('<gold>Wyłączam panel grupy\n')
  kgroup:removeBox()
  kinstall:setConfig('mapa', 'n')
  kgroup.enabled = false
end

function kgroup:doUninstall()
  kgroup:unregister()
end

function kgroup:doInit()
  kgroup:register()
  if kinstall:getConfig('group') == 't' then
    kgroup:doGroup()
  end
end

--
--
--

function kgroup:register()
  kgroup:unregister()
  kgroup.charInfoEvent = registerAnonymousEventHandler("gmcp.Char", "kgroup:charInfoEventHandler")
  kgroup.receivingGmcpTimer = tempTimer(2, [[ kgroup:checkGmcp() ]], true)
end

function kgroup:unregister()
  if kgroup.charInfoEvent then killAnonymousEventHandler(kgroup.charInfoEvent) end
  if kgroup.receivingGmcpTimer then killTimer(kgroup.receivingGmcpTimer) end
end

--
-- Wyswietla informacje o graczy i grupie w okienku
--
function kgroup:addBox()
  kgui:addBox('group', 0, "Grupa", function() kgroup:undoInfo() end)
  kgroup.group_box = kgui:setBoxContent('group', '<center><b>Zaloguj się do gry.</b><br>Oczekiwanie na grouprmacje z GMCP...</center>')
end

--
-- Usuwa informacje z okienka
--
function kgroup:removeBox()
  kgui:removeBox('group')
  kgui:update()
end


function kgroup:checkGmcp()
  if kgroup.messageBox == nil then return end
  if kinstall.receivingGmcp == false then
    kgui:setBoxContent('group', '<center>Zaloguj się do gry, lub wpisz <code>config gmcp</code> jeśli już jesteś w grze.<br>Oczekiwanie na informacje z GMCP...</center>')
  end
end

--
-- Wyswietla informacje do okienka
--
function kgroup:charInfoEventHandler()
  if kgroup.enabled == false then
    return
  end
  local group = gmcp.Char.Group

  -- sprawdzamy czy mamy informacje o grupie
  if group[1] ~= nil and group[1].unavailable ~= nil then
    kgui:setBoxContent('group', '<center>' .. group[1].unavailable .. '</center>')
    return
  end

  kgroup.messageBox:hide()

  local txt = "Pracuję nad tym..."
  kgui:setBoxContent('group', txt)
end
