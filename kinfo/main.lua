module("kinfo", package.seeall)

kinfo = kinfo or {}
kinfo.info_box = nil
kinfo.enabled = false

kinfo.doInfo = function(params)
  cecho('<gold>Włączam panel postaci\n')
  kinfo:addBox()
  kinstall:setConfig('info', 't')
  kinfo.enabled = true
end

kinfo.undoInfo = function(params)
  cecho('<gold>Wyłączam panel postaci\n')
  kinfo:removeBox()
  kinstall:setConfig('mapa', 'n')
  kinfo.enabled = false
end

kinfo.doUninstall = function()
  kinfo:unregister()
end

kinfo.doInit = function()
  kinfo:register()
  if kinstall:getConfig('info') == 't' then
    kinfo.doInfo()
  end
end

--
--
--

function kinfo:register()
  kinfo:unregister()
  kinfo.charInfoEvent = registerAnonymousEventHandler("gmcp.Room.Info", "kinfo:charInfoEventHandler")
end

function kinfo:unregister()
  if kinfo.charInfoEvent then killAnonymousEventHandler(kinfo.charInfoEvent) end
end

--
-- Wyswietla informacje o graczy i grupie w okienku
--
function kinfo:addBox()
  kgui:addBox('info', 0,"Gracz", 2, kinfo.undoInfo)
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
  local txt = yajl.to_string(gmcp.Char);
  txt = string.gsub(txt, ",", "<br>")
  txt = string.gsub(txt, "}", "<br>")
  kgui:setBoxContent('info', txt)
end