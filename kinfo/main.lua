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
  if char == nil then return end

  local vitals = char.Vitals
  if vitals == nil then return end

  local txt = '<span style="font-size:25px;">' .. vitals.name .. '</span>'
  local sex = 'mężczyzna'
  if vitals.sex == 'F' then sex = 'kobieta' end
  txt = txt .. '<span style="font-size:16px;">, ' .. sex .. ', lev. ' .. vitals.level .. '</span><br>'
  txt = txt .. '<table height="1px"><tr></tr></table>'
  txt = txt .. '<span style="font-size:16px;">' .. kinfo:translatePos(vitals.pos) .. '</span>'
  kgui:setBoxContent('info', txt)
  kgui:update()
end

function kinfo:translatePos(text)
  if text == "dead" then return '<span style="color:#ff0000">martwy</span>' end
  if text == "mortally wounded" then return '<span style="color:#ff0000">umierający</span>' end
  if text == "incapacitated" then return '<span style="color:#ff0000">unieruchomiony</span>' end
  if text == "stunned" then return '<span style="color:#ff8800">oszołomiony</span>' end
  if text == "sleeping" then return '<span style="color:#cccc00">śpisz</span>' end
  if text == "resting" then return '<span style="color:#00cc00">odpoczywasz</span>' end
  if text == "sitting" then return '<span style="color:#ffff00">siedzisz</span>' end
  if text == "figthing" then return '<span style="color:#ff8800">figthing</span>' end
  if text == "standing" then return '<span style="color:#00cc00">stoisz</span>' end
  return text
end