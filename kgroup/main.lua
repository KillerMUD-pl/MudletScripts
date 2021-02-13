module("kgroup", package.seeall)
setfenv(1, getfenv(2));

kgroup = kgroup or {}
kgroup.group_box = nil
kgroup.enabled = false

function kgroup:doGroup()
  cecho('<gold>Włączam panel grupy\n')
  kgroup:addBox()
  kinstall:setConfig('group', 't')
  kgroup.enabled = true
end

function kgroup:undoGroup()
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
  kgroup.group_box = kgui:setBoxContent('group', '<center><b>Zaloguj się do gry.</b><br>Oczekiwanie na informacje z GMCP...</center>')
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
  --local group = gmcp.Char.Group
  local group = {
    ["members"] = {
      {
        ["name"] = "Zeddicus",
        ["hp"] = "żadnych śladów",
        ["mv"] = "wypoczęty",
        ["is_npc"] = false,
      },
      {
        ["name"] = "Pomniejszy cień",
        ["hp"] = "zadrapania",
        ["mv"] = "wypoczęty",
        ["is_npc"] = true,
      },
      {
        ["name"] = "Vorid",
        ["hp"] = "lekkie rany",
        ["mv"] = "lekko zmęczony",
        ["is_npc"] = false,
      },
      {
        ["name"] = "Ąęćłńśóżź",
        ["hp"] = "średnie rany",
        ["mv"] = "bardzo zmeczony",
        ["is_npc"] = false,
      },
      {
        ["name"] = "Grywhsnywns",
        ["hp"] = "ciężkie rany",
        ["mv"] = "zameczony",
        ["is_npc"] = false,
      },
      {
        ["name"] = "Gigantyczna anakonda",
        ["hp"] = "ogromne rany",
        ["mv"] = "lekko zmęczona",
        ["is_npc"] = true,
      },
      {
        ["name"] = "Elitarny gwardzista",
        ["hp"] = "ledwo stoi",
        ["mv"] = "zmęczony",
        ["is_npc"] = true,
      },
      {
        ["name"] = "Alalslaldlslalt",
        ["hp"] = "umiera",
        ["mv"] = "wypoczęty",
        ["is_npc"] = false,
      },
    }
  }
  group = gmcp.Char.Group or {}

  -- sprawdzamy czy mamy informacje o grupie
  if group[1] ~= nil and group[1].unavailable ~= nil then
    kgui:setBoxContent('group', '<center>' .. group[1].unavailable .. '</center>')
    return
  end

  if group.members == nil then return end

  local txt = '<table width="100%" align="left" cellspacing="0" cellpadding="0" border="0">'
  for _, ch in ipairs(group.members) do
    local fontSize = 16
    local padSize = 20
    local color = "#f0f0f0"
    if ch.is_npc == true then
      ch.name = '-&nbsp;' .. ch.name
      fontSize = 14
      padSize = 27
      color = "#aaaaaa"
    end
    txt = txt .. '<tr>'
    -- NAZWA
    txt = txt .. '<td height="20" valign="center" style="line-height:20px;white-space:nowrap;color:' .. color .. ';font-size: ' .. fontSize .. 'px">' .. kgroup:pad(ch.name, padSize) ..'</td>'
    -- HP
    txt = txt .. '<td width="30" height="20" valign="center" style="line-height:20px;white-space:nowrap;">hp: <span style="line-height:20px;font-family:Arial">' .. kgroup:hpBar(kgroup:translateHp(kgroup:normalize(ch.hp))) .. '</span></td>'
    --
    txt = txt .. '</tr>'
  end
  txt = txt .. '</table>'

  kgui:setBoxContent('group', txt)
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
  local fullBoxes = value * 2
  if fullBoxes > 13 then fullBoxes = 13 end
  local emptyBoxes = (max - value) * 2 - 1
  if emptyBoxes < 0 then emptyBoxes = 0 end
  return '<span style="color:' .. fullColors[value+1] .. '">' .. string.rep("█", fullBoxes) .. '</span>' ..
    '<span style="color:' .. emptyColors[value+1] .. '">' .. string.rep("█", emptyBoxes) .. '</span>'
end

function kgroup:normalize(text)
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