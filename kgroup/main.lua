module("kgroup", package.seeall)
setfenv(1, getfenv(2));

kgroup = kgroup or {}
kgroup.group_box = nil
kgroup.enabled = false
kgroup.immoGroup = kinstall:getConfig('immoGroup') or 'n'
kgroup.immoHideCharms = kinstall:getConfig('immoHideCharms') or 'n'

function kgroup:doGroup()
  local param = kinstall.params[1]
  if param == 'immo' then
    if kgroup.immoGroup == 't' then
      cecho('<gold>Wyłączono tryb immo panelu grupy.\n\n')
      kinstall:setConfig('immoGroup', 'n')
      kgroup.immoGroup = 'n'
      else
      cecho('<gold>Włączono tryb immo panelu grupy.\n\n')
      kinstall:setConfig('immoGroup', 't')
      kgroup.immoGroup = 't'
    end
    return
  end
  if param == 'charms' then
    if kgroup.immoHideCharms == 't' then
      cecho('<gold>Włączono pokazywanie charmów w grupie.\n\n')
      kinstall:setConfig('immoHideCharms', 'n')
      kgroup.immoHideCharms = 'n'
    else
      cecho('<gold>Wyłączono pokazywanie charmów w grupie.\n\n')
      kinstall:setConfig('immoHideCharms', 't')
      kgroup.immoHideCharms = 't'
    end
    return
  end
  if param ~= "silent" then
    cecho('<gold>Włączam panel grupy\n')
  end
  kgroup:addBox()
  kinstall:setConfig('group', 't')
  kgroup.enabled = true
end

function kgroup:undoGroup()
  local param = kinstall.params[1]
  if param ~= 'silent' then
    cecho('<gold>Wyłączam panel grupy\n')
  end
  kgroup:removeBox()
  kinstall:setConfig('group', 'n')
  kgroup.enabled = false
end

function kgroup:doUninstall()
  kgroup:unregister()
end

function kgroup:doInit()
  kgroup.forceUiUpdate = true
  kgroup:register()
  if kinstall:getConfig('group') == 't' then
    kinstall.params[1] = 'silent'
    kgroup:doGroup()
  end
end

function kgroup:doUpdate()
  kgroup.forceUiUpdate = true
  kgroup:charInfoEventHandler()
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
  kgui:addBox('group', 0, "Grupa", "group")
  kgroup.group_box = kgui:setBoxContent('group', '<center>Zaloguj się do gry lub włącz GMCP</center>')
  kgroup.group_box:setDoubleClickCallback(function(event)
    if kgroup.immoGroup ~= 't' then return end
    local y = math.ceil((event.y - 14) / 20)
    local group = kgroup:filterCharms(gmcp.Char.Group)
    local char = group.members[y]
    send('goto ' .. char.room)
  end)
end

--
-- Usuwa informacje z okienka
--
function kgroup:removeBox()
  kgui:removeBox('group')
  kgui:update()
end


function kgroup:checkGmcp()
  if kinstall.receivingGmcp == false then
    kgui:setBoxContent('group', '<center>Zaloguj się do gry lub włącz GMCP</center>')
  end
end

--
-- Wyswietla informacje do okienka
--
function kgroup:charInfoEventHandler()
  if kgroup.enabled == false or gmcp.Char == nil then
    return
  end

  group = gmcp.Char.Group or {}

  -- sprawdzamy czy mamy informacje o grupie
  if group[1] ~= nil and group[1].unavailable ~= nil then
    kgui:setBoxContent('group', '<center>' .. kgui:transliterate(group[1].unavailable) .. '</center>')
    return
  end

  if group.members == nil then return end

  -- sparsowanie do jsona i porownanie dwoch stringow jest szybkie bo to natywne instrukcje
  -- jesli poprzednie dane gmcp niczym sie nie roznia - olewamy wyswietlanie
  -- chyba ze trzeba uaktualnic UI
  --if kgroup.forceUiUpdate == false and kgroup.lastGmcpInfo == yajl.to_string(gmcp.Char.Group) then return end
  --kgroup.forceUiUpdate = false

  group = kgroup:filterCharms(group)

  local playerSymbols = { "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪", "⑫", "⑬", "⑭", "⑮", "⑯", "⑰", "⑱", "⑲", "②"}
  local playerId = 1
  local hasMap = false
  if kgui.uiState ~= nil and kgui.uiState.mapper ~= nil and #group.members > 1 then
    hasMap = true
  end

  local txt = '<table width="100%" align="left" cellspacing="0" cellpadding="0" border="0">'
  local fontSize = kgui.baseFontHeight
  local lineHeight = kgui.baseFontHeightPx
  for _, ch in ipairs(group.members) do
    --local padSize = 20
    local color = "#f0f0f0"
    local name = kgui:transliterate(ch.name)
    if ch.is_npc == true then
      name = '&nbsp;&nbsp;' .. name
      color = "#aaaaaa"
      if hasMap == true then
        name = '&nbsp;&nbsp;' .. name
      end
    else
      if hasMap == true then
        name =  '<span style="color:#777777">' .. playerSymbols[playerId] .. '</span>&nbsp;' .. name
      end
      playerId = playerId + 1
    end
    txt = txt .. '<tr style="height:' .. lineHeight .. 'px;line-height:' .. lineHeight .. 'px;max-height:' .. lineHeight .. 'px">'
    -- NAZWA
    txt = txt .. '<td height="' .. lineHeight .. '" valign="center" style="line-height:' .. lineHeight .. 'px;white-space:nowrap;color:' .. color .. ';font-size: ' .. fontSize .. 'px">&nbsp;' .. kgui:transliterate(name) ..'&nbsp;&nbsp;</td>'
    -- HP
    txt = txt .. '<td height="' .. lineHeight .. '" valign="center" style="line-height:' .. lineHeight .. 'px;white-space:nowrap;">hp: <span style="line-height:' .. lineHeight .. 'px;font-family:Arial">&nbsp;' .. kgroup:hpBar(kgroup:translateHp(kgroup:normalize(ch.hp))) .. '</span>&nbsp;</td>'
    -- MV
    txt = txt .. '<td height="' .. lineHeight .. '" valign="center" style="line-height:' .. lineHeight .. 'px;white-space:nowrap;">mv: <span style="line-height:' .. lineHeight .. 'px;font-family:Arial">&nbsp;' .. kgroup:mvBar(kgroup:translateMv(kgroup:normalize(ch.mv))) .. '</span>&nbsp;</td>'
    -- POS
    txt = txt .. '<td height="' .. lineHeight .. '" valign="center" style="line-height:' .. lineHeight .. 'px;white-space:nowrap;"><span style="font-size:' .. fontSize .. 'px">' .. kgui:transliterate(ch.pos) .. '</span>&nbsp;</td>'
    -- MEM
    if ch.mem > 0 then
      txt = txt .. '<td height="' .. lineHeight .. '" valign="center" style="line-height:' .. lineHeight .. 'px;white-space:nowrap;">&nbsp;' .. ch.mem .. ' mem&nbsp;</td>'
    else
      txt = txt .. '<td height="' .. lineHeight .. '" valign="center" style="line-height:' .. lineHeight .. 'px;white-space:nowrap;">&nbsp;</td>'
    end
    --
    txt = txt .. '</tr>'
  end
  txt = txt .. '</table>'

  kgui:setBoxContent('group', txt, #group.members * lineHeight)
  --kgroup.lastGmcpInfo = yajl.to_string(gmcp.Char.Group)
  kgui:update()
end

function kgroup:filterCharms(group)
  if kgroup.immoHideCharms == "t" then
    local members = {}
    for _, member in ipairs(group.members) do
      if member.is_npc ~= true then
        table.insert(members, member)
      end
    end
    group.members = members
  end
  return group
end

function kgroup:pad(str, len)
  if #str >= len then return utf8.sub(str, 1, len) end
  return str .. string.rep("&nbsp;", len - #str)
end

function kgroup:translateHp(text)
  local hpTable = {
    ["zadnych sladow"] = 7,
    ["zadrapania"] = 6,
    ["lekkie rany"] = 5,
    ["lekkie uszkodzenia"] = 5,
    ["srednie rany"] = 4,
    ["srednie uszkodzenia"] = 4,
    ["ciezkie rany"] = 3,
    ["ciezkie uszkodzenia"] = 3,
    ["ogromne rany"] = 2,
    ["ogromne uszkodzenia"] = 2,
    ["ledwo stoi"] = 1,
    ["umiera"] = 0,
    ["unieruchomiony"] = 0,
  }
  if hpTable[text] ~= nil then
    return hpTable[text]
  else
    return 0
  end
end

function kgroup:translateMv(text)
  local mvTable = {
		["wypoczety"] = 4,
		["wypoczeta"] = 4,
		["lekko zmeczony"] = 3,
		["lekko zmeczona"] = 3,
		["zmeczony"] = 2,
    ["zmeczona"] = 2,
		["bardzo zmeczony"] = 1,
    ["bardzo zmeczona"] = 1,
		["zameczony"] = 0,
    ["zameczona"] = 0,
  }
  if mvTable[text] ~= nil then
    return mvTable[text]
  else
    return 0
  end
end

function kgroup:hpBar(value)
  local fullColors = {
    "#980000", -- umiera
    "#ff0000", -- ledwo stoi
    "#ff4100", -- ogromne rany
    "#ff9900", -- ciezkie rany
    "#eeee00", -- srednie rany
    "#7dcb00", -- lekkie rany
    "#57e001", -- zadrapania
    "#00ee00", -- zadnych sladow
  }
  local emptyColors = {
    "#980000", -- umiera
    "#950000", -- ledwo stoi
    "#9d2800", -- ogromne rany
    "#905600", -- ciezkie rany
    "#767600", -- srednie rany
    "#538700", -- lekkie rany
    "#368c00", -- zadrapania
    "#00ee00", -- zadnych sladow
  }
  local max = 7
  --local fullBoxes = value * 2
  local fullBoxes = value
  --if fullBoxes > 13 then fullBoxes = 13 end
  if fullBoxes > 7 then fullBoxes = 7 end
  --local emptyBoxes = (max - value) * 2 - 1
  local emptyBoxes = (max - value)
  if emptyBoxes < 0 then emptyBoxes = 0 end
  return '<span style="color:' .. fullColors[value+1] .. '">' .. string.rep("█", fullBoxes) .. '</span>' ..
    '<span style="color:' .. emptyColors[value+1] .. '">' .. string.rep("█", emptyBoxes) .. '</span>'
end

function kgroup:mvBar(value)
  local fullColors = {
    "#9d2800", -- zameczona
    "#ff9900", -- bardzo zmeczony
    "#eeee00", -- zmeczony
    "#7dcb00", -- lekko zmeczony
    "#00ee00", -- wypoczety
  }
  local emptyColors = {
    "#9d2800", -- zameczona
    "#905600", -- bardzo zmeczony
    "#767600", -- zmeczony
    "#538700", -- lekko zmeczony
    "#00ee00", -- wypoczety
  }
  local max = 4
  --local fullBoxes = value * 2
  local fullBoxes = value
  --if fullBoxes > 8 then fullBoxes = 8 end
  --local emptyBoxes = (max - value) * 2
  if fullBoxes > 4 then fullBoxes = 4 end
  local emptyBoxes = (max - value)
  return '<span style="color:' .. fullColors[value+1] .. '">' .. string.rep("█", fullBoxes) .. '</span>' ..
    '<span style="color:' .. emptyColors[value+1] .. '">' .. string.rep("█", emptyBoxes) .. '</span>'
end

function kgroup:normalize(text)
  text = kgui:transliterate(text)
  if type(text) ~= "string" then return "" end
  text = utf8.gsub(text, 'ą', 'a')
  text = utf8.gsub(text, 'ć', 'c')
  text = utf8.gsub(text, 'ę', 'e')
  text = utf8.gsub(text, 'ł', 'l')
  text = utf8.gsub(text, 'ń', 'n')
  text = utf8.gsub(text, 'ó', 'o')
  text = utf8.gsub(text, 'ś', 's')
  text = utf8.gsub(text, 'ż', 'z')
  text = utf8.gsub(text, 'ź', 'z')
  return text
end
