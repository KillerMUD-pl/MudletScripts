module("kinfo", package.seeall)
setfenv(1, getfenv(2));

kinfo = kinfo or {}
kinfo.enabled = false
kinfo.colors = kinfo.colors or {}

function kinfo:doInfo()
  local param = kinstall.params[1]
  if param == 'color' then
    local cmd = table.concat(kinstall.params, ' ', 2)
    if string.trim(cmd) == '' then
      cecho('\n<gold>Kolory afektów:\n')
      for name, color in pairs(kinfo.colors) do
        decho('<'..color[1]..','..color[2]..','..color[3]..'>'.. name ..' ')
      end
      echo('\n\n')
      return
    end
    local parts = string.split(cmd, "=")
    local affName = string.trim(parts[1])
    if #parts == 1 then
      clearCmdLine()
      printCmdLine('+info color ' .. affName .. ' = ')
      showColors()
      cecho('\n<gold>Wybierz kolor klikając go, następnie wcisnij enter\n')
      return
    end
    local color = string.trim(parts[2])
    cecho('\n<gold>Ustawiono kolor dla '.. affName ..' na ' .. color .. '\n')
    kinfo.colors[affName] = color_table[color]
    kinstall:setConfig('kinfoColors', yajl.to_string(kinfo.colors))
    return
  end
  if param ~= "silent" then
    cecho('<gold>Włączam panel postaci\n')
  end
  kinfo:addBox()
  kinstall:setConfig('info', 't')
  kinfo.enabled = true
end

function kinfo:undoInfo()
  local param = kinstall.params[1]
  if param ~= 'silent' then
    cecho('<gold>Wyłączam panel postaci\n')
  end
  kinfo:removeBox()
  kinstall:setConfig('info', 'n')
  kinfo.enabled = false
end

function kinfo:doUninstall()
  kinfo:unregister()
end

function kinfo:doInit()
  local colors = kinstall:getConfig('kinfoColors')
  if colors == nil or colors == "" or colors == false then colors = "{}" end
  kinfo.colors = yajl.to_value(colors)
  if kinstall:getConfig('info') == 't' then
    kinfo:register()
    kinfo:doInfo()
  end
end

function kinfo:doUpdate()
  kinfo:charInfoEventHandler()
end

--
--
--

function kinfo:register()
  kinfo:unregister()
  kinfo.charInfoEvent = registerAnonymousEventHandler("gmcp.Char", "kinfo:charInfoEventHandler")
  kinfo.receivingGmcpTimer = tempTimer(2, [[ kinfo:checkGmcp() ]], true)
end

function kinfo:unregister()
  if kinfo.charInfoEvent then killAnonymousEventHandler(kinfo.charInfoEvent) end
  if kinfo.receivingGmcpTimer then killTimer(kinfo.receivingGmcpTimer) end
end

--
-- Wyswietla informacje o graczy i grupie w okienku
--
function kinfo:addBox()
  kgui:addBox('info', 0, "Gracz", "info")
  kgui:setBoxContent('info', '<center>Zaloguj się do gry lub włącz GMCP</center>')
end

--
-- Info o braku danych
--
function kinfo:checkGmcp()
  if kinstall.receivingGmcp == false then
    kgui:setBoxContent('info', '<center>Zaloguj się do gry lub włącz GMCP</center>')
  end
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

  local cond = char.Condition
  if cond == nil then return end

  local affs = char.Affects
  if affs == nil then return end

  if kgui.ui.info == nil or kgui.ui.info.wrapper == nil then return end

  local fontSize = kgui.baseFontHeight
  local compact = false
  local titleFontSizePx = math.floor(kgui.baseFontHeightPx * 1.5)
  local titleFontSize = math.floor(fontSize * 1.5)
  local infoFontSizePx = kgui.baseFontHeightPx
  local infoFontSize = fontSize

  if kgui.uiState.info ~= nil and kgui.uiState.info.socket == "bottomBar" then
    compact = true
    titleFontSizePx = kgui.baseFontHeightPx
    titleFontSize = fontSize
    infoFontSizePx = math.ceil(titleFontSizePx * 0.8)
    infoFontSize = math.ceil(titleFontSize*0.8)
  end

  local txt = '<span style="white-space:nowrap;height:' .. titleFontSizePx .. 'px;line-height:' .. titleFontSizePx .. 'px"><span style="font-size:' .. titleFontSize .. 'px;">' .. kgui:transliterate(vitals.name) .. '</span>'
  local sex = 'mężczyzna'
  if vitals.sex == 'F' then sex = 'kobieta' end
  txt = txt .. '<span style="font-size:' .. fontSize .. 'px;">, ' .. sex .. ', lev. ' .. vitals.level .. '</span></span>\n'
  local list = {}
  local height = titleFontSizePx
  local posText = kinfo:translatePos(vitals.pos)
  table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;">' .. posText .. '</span>')
  if cond.smoking == true then
    local s = "ćmisz&nbsp;fajkę"
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#dd0000">'..s..'</span>')
  end
  if cond.hungry == true then
    local s = "jesteś&nbsp;głodny"
    if vitals.sex == "F" then s = "Jesteś głodna" end
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#dd0000">'..s..'</span>')
  end
  if cond.thirsty == true then
    local s = "jesteś&nbsp;spragniony"
    if vitals.sex == "F" then s = "Jesteś spragniona" end
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#dd0000">'..s..'</span>')
  end
  if cond.sleepy == true then
    local s = "jesteś&nbsp;śpiący"
    if vitals.sex == "F" then s = "Jesteś śpiąca" end
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#dd0000">'..s..'</span>')
  end
  if cond.overweight == true then
    local s = "jesteś&nbsp;przeciążony"
    if vitals.sex == "F" then s = "Jesteś przeciążona" end
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#dd0000">'..s..'</span>')
  end
  if cond.drunk == true then
    local s = "jesteś&nbsp;pijany"
    if vitals.sex == "F" then s = "Jesteś pijana" end
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#ff8800">'..s..'</span>')
  end
  if cond.halucinations == true then
    local s = "jesteś&nbsp;na&nbsp;haju"
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#ff8800">'..s..'</span>')
  end
  if cond.bleedingWound == true then
    local s = "twoje&nbsp;rany&nbsp;krwawią"
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#ff0000">'..s..'</span>')
  end
  if cond.bleed == true then
    local s = "jesteś&nbsp;okaleczony"
    if vitals.sex == "F" then s = "Jesteś okaleczona" end
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#ff0000">'..s..'</span>')
  end
  if cond.thighJab == true then
    local s = "krwawisz&nbsp;z&nbsp;uda"
    table.insert(list, '<span style="font-size:' .. infoFontSize .. 'px;color:#ff0000">'..s..'</span>')
  end

  local cond = table.concat(list, ", ")
  if compact == false then
    txt = txt .. '<div style="font-family:\''..getFont()..'\';white-space:wrap;width:100%">' .. cond .. '</div>'
    height = height + kinfo:calculateTextHeight(cond, kgui.ui.info.wrapper:get_width() - kgui.boxPadding * 2 - 4, infoFontSize, infoFontSizePx)
  else
    txt = txt .. ', <span style="font-family:\''..getFont()..'\';white-space:wrap">' .. cond .. '</span>'
    height = kinfo:calculateTextHeight(cond, kgui.ui.info.wrapper:get_width() - kgui.boxPadding * 2 - 4, infoFontSize, infoFontSizePx)
  end

  -- AFEKTY

  -- sprawdzamy czy mamy informacje o afektach
  if affs[1] ~= nil and affs[1].unavailable ~= nil then
    height = height + kgui.baseFontHeightPx
    kgui:setBoxContent('info', txt .. '<center>' .. kgui:transliterate(affs[1].unavailable) .. '</center>', height)
    kgui:update()
    return
  end

  if #affs > 0 and compact == false then
    txt = txt .. '<div style="height:'..math.floor(fontSize * 0.5)..'px;font-size:'..math.floor(fontSize * 0.5)..'px;line-height:'..math.floor(fontSize * 0.5)..'px">&nbsp;</div>'
    height = height + math.floor(fontSize * 0.5)
  end

  txt = txt .. '\n'

  -- wykrywamy czy postac jest czarujaca
  isMage = false
  for _, aff in ipairs(affs) do
    if aff.name ~= '' then isMage = true end
  end

  if isMage == true then
    -- wersja dla magow, same nazwy czarow
    -- oraz jesli affekt nie jest czarem i nie ma nazwy - jako tekstu
    local rawAffs = {}
    for _, aff in ipairs(affs) do
      if aff.name == '' then table.insert(rawAffs, aff) end
    end
    height = height + infoFontSizePx * #rawAffs
    for _, rawAff in ipairs(rawAffs) do
      local color = "#44aa44"
      if rawAff.negative == true then
        color = "#dd0000"
      end
      local customColor = kinfo.colors[kgui:transliterate(rawAff.desc)]
      if customColor ~= nil then color = 'rgb(' .. customColor[1] .. ',' .. customColor[2] .. ',' .. customColor[3] .. ')' end
      local desc = utf8.gsub(kgui:transliterate(rawAff.desc), ' ', '&nbsp;')
      if type(rawAff.extraValue) == 'string' or type(rawAff.extraValue) == 'number' then desc = '(' .. utf8.gsub(rawAff.extraValue, ' ', '&nbsp;' ) .. ') ' .. desc end
      local bgColor = 'rgba(0,0,0,0)';
      if rawAff.ending ~= nil and rawAff.ending == true then bgColor = 'rgba(80,0,0,255)' end
      txt = txt .. '<div style="line-height:' .. infoFontSize .. 'px;background-color:'..bgColor..';font-size:'..infoFontSize..'px;color:'.. color ..'">' .. desc .. '</div>'
    end
    -- same nazwy afektow w formie word-wrap
    local list = {}
    for _, aff in ipairs(affs) do
      if aff.name ~= '' then
        local color = "#44aa44"
        if aff.negative == true then
          color = "#dd0000"
        end
        local customColor = kinfo.colors[kgui:transliterate(aff.name)]
        if customColor ~= nil then color = 'rgb(' .. customColor[1] .. ',' .. customColor[2] .. ',' .. customColor[3] .. ')' end
        local affName = utf8.gsub(kgui:transliterate(aff.name), ' ', '&nbsp;')
        if type(aff.extraValue) == 'string' or type(aff.extraValue) == 'number' then affName = '(' .. utf8.gsub(aff.extraValue, ' ', '&nbsp;') .. ') ' .. affName end
        local bgColor = 'rgba(0,0,0,0)';
        if aff.ending ~= nil and aff.ending == true then bgColor = 'rgba(80,0,0,255)' end
        table.insert(list, '<span style="background-color:'..bgColor..';font-size:'..infoFontSize..'px;color:'..color..'">'..affName..'</span>')
      end
    end
    if #list > 0 then
      local afekty = table.concat(list, ", ")
      txt = txt .. '<div style="line-height:' .. infoFontSize .. 'px;white-space:wrap;width:100%;font-family:\''..getFont()..'\'">' .. afekty .. '</div>'
      height = height + kinfo:calculateTextHeight(afekty, kgui.ui.info.wrapper:get_width() - kgui.boxPadding * 2 - 4, infoFontSize, infoFontSizePx)
    end
  else
    -- wersja z opisami, dla nie czarujacych
    if #affs > 6 then infoFontSize = math.floor(infoFontSize * 0.85) end
    if #affs > 8 then infoFontSize = math.floor(infoFontSize * 0.75) end
    height = height + infoFontSizePx * #affs
    for _, aff in ipairs(affs) do
      local color = "#44aa44"
      if aff.negative == true then
        color = "#dd0000"
      end
      local customColor = kinfo.colors[kgui:transliterate(aff.desc)]
      if customColor ~= nil then color = 'rgb(' .. customColor[1] .. ',' .. customColor[2] .. ',' .. customColor[3] .. ')' end
      local desc = utf8.gsub(kgui:transliterate(aff.desc), ' ', '&nbsp;')
      if type(aff.extraValue) == 'string' or type(aff.extraValue) == 'number' then desc = '(' .. utf8.gsub(aff.extraValue, ' ', '&nbsp;') .. ') ' .. desc end
      local bgColor = 'rgba(0,0,0,0)';
      if aff.ending ~= nil and aff.ending == true then bgColor = 'rgba(80,0,0,255)' end
      txt = txt .. '<div style="line-height:'..infoFontSize..'px;background-color:'..bgColor..';font-size:'..infoFontSize..'px;color:'.. color ..'">' .. desc .. '</div>'
    end
  end

  kgui:setBoxContent('info', txt, height)
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
  if text == "fighting" then return '<span style="color:#ff8800">walczysz</span>' end
  if text == "standing" then return '<span style="color:#00cc00">stoisz</span>' end
  return text
end

function kinfo:calculateTextHeight(txt, maxWidth, fontSize, lineHeight)
  local fontWidth = calcFontSize(fontSize, getFont())
  local text = utf8.gsub(utf8.gsub(txt, '&nbsp;', '-'), '\<[^>]+\>', '')
  local wrapped = kinfo:textwrap(text, math.floor(maxWidth/fontWidth))
  local linesCount  = select(2, wrapped:gsub('\n', '\n'))
  return (1 + linesCount) * lineHeight
end

function kinfo:splittokens(s)
  local res = {}
  for w in s:gmatch("%S+") do
      res[#res+1] = w
  end
  return res
end

function kinfo:textwrap(text, linewidth)
  if not linewidth then
      linewidth = 75
  end

  local spaceleft = linewidth
  local res = {}
  local line = {}

  for _, word in ipairs(kinfo:splittokens(text)) do
      if #word + 1 > spaceleft then
          table.insert(res, table.concat(line, ' '))
          line = {word}
          spaceleft = linewidth - #word
      else
          table.insert(line, word)
          spaceleft = spaceleft - (#word + 1)
      end
  end

  table.insert(res, table.concat(line, ' '))
  return table.concat(res, '\n')
end