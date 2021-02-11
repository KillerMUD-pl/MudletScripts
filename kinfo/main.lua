module("kinfo", package.seeall)
setfenv(1, getfenv(2));

kinfo = kinfo or {}
kinfo.info_box = nil
kinfo.enabled = false

function kinfo:doInfo()
  cecho('<gold>Włączam panel postaci\n')
  kinfo:addBox()
  kinstall:setConfig('info', 't')
  kinfo.enabled = true
end

function kinfo:undoInfo()
  cecho('<gold>Wyłączam panel postaci\n')
  kinfo:removeBox()
  kinstall:setConfig('mapa', 'n')
  kinfo.enabled = false
end

function kinfo:doUninstall()
  kinfo:unregister()
end

function kinfo:doInit()
  kinfo:register()
  if kinstall:getConfig('info') == 't' then
    kinfo:doInfo()
  end
end

--
--
--

function kinfo:register()
  kinfo:unregister()
  kinfo.charInfoEvent = registerAnonymousEventHandler("gmcp.Char", "kinfo:charInfoEventHandler")
end

function kinfo:unregister()
  if kinfo.charInfoEvent then killAnonymousEventHandler(kinfo.charInfoEvent) end
end

--
-- Wyswietla informacje o graczy i grupie w okienku
--
function kinfo:addBox()
  kgui:addBox('info', 0, "Gracz", function() kinfo:undoInfo() end)
  kinfo.info_box = kgui:setBoxContent('info', '<center><b>Zaloguj się do gry.</b><br>Oczekiwanie na informacje z GMCP...</center>')
end

--
-- Usuwa info z okienka
--
function kinfo:removeBox()
  kgui:removeBox('info')
  kgui:update()
end

--
-- Wyswietla informacje do okienka
--
function kinfo:charInfoEventHandler()
  if kinfo.enabled == false then
    return
  end
  local char = gmcp.Char
  local txt = "Pracuję nad tym..."
  kgui:setBoxContent('info', txt)
end