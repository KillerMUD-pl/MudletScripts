module("ktemplate", package.seeall)
setfenv(1, getfenv(2));

ktemplate = ktemplate or {}
ktemplate.enabled = false

--
-- Funkcje wymagane przez kinstall
--

-- Wykonywane przed odinstalowaniem modułu
function ktemplate:doUninstall()
  ktemplate:unregister()
end

-- Wykonywane przy starcie mudleta
function ktemplate:doInit()
  ktemplate:register()
  if kinstall:getConfig('mem') == 't' then
    kinstall.params[1] = 'silent'
    ktemplate:doTest()
  end
end

function ktemplate:doUpdate()
  ktemplate:memInfoEventHandler()
end

--
-- Funkcje obsługi komend
-- Nazwy funkcji muszą być skonstruowane jako: <do/undo><nazwa komendy z duzej litery>
--
-- Na przykład, komenda +test modułu ktemplate odpali funkcję ktemplate:doTest,
-- a komenda -test odpali funkcję ktemplate:undoTest 
--
function ktemplate:doTest()
  -- zmienna kinstall.params przechowuje parametry przekazane  do komendy, np. komenda +test foo bar
  -- będzie miała: kinstall.params = { "foo", "bar" }
  local param = kinstall.params[1]
  -- przy odpalaniu okienek przy starcie Mudleta, kinstall wysyła zawsze pierwszy parametr "silent"
  -- co oznacza po prostu cichy start, żeby po każdym właczeniu nie spamować "Właczono panel ..."
  if param ~= "silent" then
    cecho('<gold>Włączam przykładowy panel\n')
  end
  ktemplate:addBox()
  ktemplate.enabled = true
  kinstall:setConfig('template', 't')
end

function ktemplate:undoTest()
  local param = kinstall.params[1]
  if param ~= 'silent' then
    cecho('<gold>Wyłączam przykładowy panel\n')
  end
  ktemplate:removeBox()
  kinstall:setConfig('template', 'n')
  ktemplate.enabled = false
end


function ktemplate:register()
  ktemplate:unregister()
  ktemplate.memInfoEvent = registerAnonymousEventHandler("gmcp.Char", "ktemplate:memInfoEventHandler")
  ktemplate.receivingGmcpTimer = tempTimer(2, [[ ktemplate:checkGmcp() ]], true)
end

function ktemplate:unregister()
  if ktemplate.memInfoEvent then killAnonymousEventHandler(ktemplate.memInfoEvent) end
  if ktemplate.receivingGmcpTimer then killTimer(ktemplate.receivingGmcpTimer) end
end

--
-- Wyswietla informacje o zapamiętywanych czarach w okienku
--
function ktemplate:addBox()
  kgui:addBox('mem', 0, "Mem", "mem")
  kgui:setBoxContent('mem', '<center>Zaloguj się do gry lub włącz GMCP</center>')
end

--
-- Info o braku danych
--
function ktemplate:checkGmcp()
  if kinstall.receivingGmcp == false then
    kgui:setBoxContent('mem', '<center>Zaloguj się do gry lub włącz GMCP</center>')
  end
end

--
-- Usuwa informacje z okienka
--
function ktemplate:removeBox()
  kgui:removeBox('mem')
  kgui:update()
end

--
-- Wyswietla informacje do okienka
--
function ktemplate:memInfoEventHandler()
  if ktemplate.enabled == false then
    return
  end

  local char = gmcp.Char
  if char == nil then return end

  local memSlots = char.MemFreeSlot
  if memSlots == nil then return end

  local mems = char.MemSpell
  if mems == nil then return end

  if kgui.ui.mem == nil or kgui.ui.mem.wrapper == nil then return end

  -- sparsowanie do jsona i porownanie dwoch stringow jest szybkie bo to natywne instrukcje
  -- jesli poprzednie dane gmcp niczym sie nie roznia - olewamy wyswietlanie
  -- chyba ze trzeba uaktualnic UI
  --if ktemplate.forceUiUpdate == false and ktemplate.lastGmcpInfo == yajl.to_string(gmcp.Char) then return end
  --ktemplate.forceUiUpdate = false

  -- porzadkowanie po kregach
  local circles = {}
  local queue = {}
  local fontSize = kgui.baseFontHeight * 0.8
  local fontSizePx = kgui.baseFontHeightPx * 0.8

  for _, mem in pairs(mems) do
    if mem.memed == true then
      if circles[mem.circle] == nil then circles[mem.circle] = {} end
      if circles[mem.circle][mem.name] == nil then
        mem.count = 1
        circles[mem.circle][mem.name] = mem
      else
        circles[mem.circle][mem.name].count = circles[mem.circle][mem.name].count + 1
      end
    else
      table.insert(queue, mem)
    end
  end

  local txt = '<table width="100%" style="color:#dddddd;font-size:'..fontSize..'px;font-family:\''..getFont()..'\'">'
  local height = 1
  txt = txt .. '<tr><td >Aktualnie zapamiętane:</td><td width="100" style="padding-left:4px;border-left:1px dotted #cccccc">Kolejka:</td></tr><tr><td>'

  txt = txt .. '<table width="100%">'
  local memHeight = 0
  if #circles == 0 then txt = txt .. '<tr><td><span style="color:#888888">brak</span></td></tr>' end
  for circle, circleItems in pairs(circles) do
    local circleShown = false
    local keys = table.keys(circleItems)
    local n = #keys
    if n % 2 == 1 then n = n + 1 end
    for i = 1, n, 2 do
      memHeight = memHeight + 1
      local firstName = circleItems[keys[i]].name
      local first = string.gsub('(' .. circleItems[keys[i]].count .. ') ' .. firstName, ' ', '&nbsp;')
      local secondName = ''
      local second = circleItems[keys[i+1]]
      if second == nil then
        second = ''
      else
        secondName = second.name
        second = string.gsub('(' .. second.count .. ') ' .. secondName, ' ', '&nbsp;')
      end
      height = height + 1
      txt = txt .. '<tr>'
      if circleShown == false then
        txt = txt .. '<td style="font-weight:bold;color:#666666;padding-right:4px;">' .. circle .. ':</td>'
        circleShown = true
      else
        txt = txt .. '<td></td>'
      end
      txt = txt .. '<td width="50%" style="width:50%;padding-right:6px;color:'..ktemplate:memColorUp(firstName)..'">' .. first .. '</td><td width="50%" style="color:'..ktemplate:memColorUp(secondName)..'">' .. second .. '</td></tr>'
    end
  end
  txt = txt .. '</table>'
  txt = txt .. '</td><td style="padding-left:4px;border-left:1px dotted #cccccc">'
  local queueLines = memHeight
  if queueLines < 5 then queueLines = 5 end
  if #queue == 0 or queue[0] == 'none' then
    txt = txt .. '<span style="color:#888888">pusta</span>'
    queueLines = 0
  end
  for i, item in ipairs(queue) do
    if item == 'none' then break end
    queueLines = queueLines - 1
    if queueLines == -1 then
      txt = txt .. '...'
      break
    end
    txt = txt .. '<span style="color:'..ktemplate:memColorDown(item.name)..'">' .. item.name .. '</span>'
    if  i ~= #queue then txt = txt .. '<br>' end
  end
  txt = txt .. '</td></tr><tr><td colspan="2" style="padding-top:6px">'
  for _, item in pairs(memSlots) do
    txt = txt .. item.circle .. '-' .. item.free .. ' '
  end
  txt = txt .. '</td></tr></table>'

  if height < #queue then height = #queue end

  kgui:setBoxContent('mem', txt, height * fontSizePx + kgui.baseFontHeightPx + kgui.boxPadding * 2 + 4)
  --ktemplate.lastGmcpInfo = yajl.to_string(gmcp.Char)
  kgui:update()
end

function ktemplate:memColorUp(mem)
  if kinfo ~= nil and kinfo.colors ~= nil then
    for name, color in pairs(kinfo.colors) do
      if name == mem then return 'rgba(' .. color[1] .. ',' .. color[2] .. ',' .. color[3] .. ')' end
    end
  end
  return "#44aa44"
end

function ktemplate:memColorDown(mem)
  if kinfo ~= nil and kinfo.colors ~= nil then
    for name, color in pairs(kinfo.colors) do
      if name == mem then return 'rgba(' .. color[1] .. ',' .. color[2] .. ',' .. color[3] .. ')' end
    end
  end
  return "#dd0000"
end
