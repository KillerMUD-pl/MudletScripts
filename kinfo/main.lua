module("kinfo", package.seeall)
setfenv(1, getfenv(2));

kinfo = kinfo or {}
kinfo.info_box = nil
kinfo.enabled = false

function kinfo:doInfo()
  local param = kinstall.params[1]
  if param ~= "silent" then
    cecho('<gold>Włączam panel postaci\n')
  end
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
    kinstall.params[1] = 'silent'
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

  local cond = char.Condition
  if cond == nil then return end

  local affs = char.Affects
  if affs == nil then return end

  if kgui.ui.info == nil or kgui.ui.info.wrapper == nil then return end

  local txt = '<div style="white-space:nowrap;"><span style="font-size:25px;">' .. vitals.name .. '</span>'
  local sex = 'mężczyzna'
  if vitals.sex == 'F' then sex = 'kobieta' end
  txt = txt .. '<span style="font-size:16px;">, ' .. sex .. ', lev. ' .. vitals.level .. '</span></div>'
  local list = {}
  local blockWidths = {}
  local height = 50
  local posText, posWidth = kinfo:translatePos(vitals.pos)
  table.insert(list, '<span style="font-size:16px;white-space:nowrap;">' .. posText .. '</span>')
  table.insert(blockWidths, posWidth)
  if cond.smoking == true then
    table.insert(blockWidths, 168)
    local s = "ćmisz fajkę"
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#dd0000">'..s..'</span>')
  end
  if cond.hungry == true then
    table.insert(blockWidths, 200)
    local s = "jesteś głodny"
    if vitals.sex == "F" then s = "Jesteś głodna" end
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#dd0000">'..s..'</span>')
  end
  if cond.thirsty == true then
    table.insert(blockWidths, 256)
    local s = "jesteś spragniony"
    if vitals.sex == "F" then s = "Jesteś spragniona" end
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#dd0000">'..s..'</span>')
  end
  if cond.sleepy == true then
    table.insert(blockWidths, 186)
    local s = "jesteś śpiący"
    if vitals.sex == "F" then s = "Jesteś śpiąca" end
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#dd0000">'..s..'</span>')
  end
  if cond.overweight == true then
    table.insert(blockWidths, 272)
    local s = "jesteś przeciążony"
    if vitals.sex == "F" then s = "Jesteś przeciążona" end
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#dd0000">'..s..'</span>')
  end
  if cond.drunk == true then
    table.insert(blockWidths, 184)
    local s = "jesteś pijany"
    if vitals.sex == "F" then s = "Jesteś pijana" end
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#ff8800">'..s..'</span>')
  end
  if cond.halucinations == true then
    table.insert(blockWidths, 206)
    local s = "jesteś na haju"
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#ff8800">'..s..'</span>')
  end
  if cond.bleedingWound == true then
    table.insert(blockWidths, 292)
    local s = "twoje rany krwawią"
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#ff0000">'..s..'</span>')
  end
  if cond.bleed == true then
    table.insert(blockWidths, 260)
    local s = "jesteś okaleczony"
    if vitals.sex == "F" then s = "Jesteś okaleczona" end
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#ff0000">'..s..'</span>')
  end
  if cond.thighJab == true then
    table.insert(blockWidths, 226)
    local s = "krwawisz z uda"
    table.insert(list, '<span style="white-space:nowrap;font-size:16px;color:#ff0000">'..s..'</span>')
  end
  txt = txt .. '<div style="white-space:wrap;width:100%">' .. table.concat(list, ", ") .. '</div>'
  height = height + kinfo:calculateTextHeight(blockWidths, kgui.ui.info.wrapper:get_width() - 30, 16)

  txt = txt .. '<div style="height:5px;font-size:5px;line-height:5px">&nbsp;</div>'
  height = height + 5

  -- AFEKTY

  local fontSize = 14
  local fontWidth, fontHeight = calcFontSize(fontSize, 'Marcellus')

  -- sprawdzamy czy mamy informacje o grupie
  if affs[1] ~= nil and affs[1].unavailable ~= nil then
    height = height + (fontHeight + 2)
    kgui:setBoxContent('info', txt .. '<center>' .. affs[1].unavailable .. '</center>', height)
    kgui:update()
    return
  end

  -- wykrywamy czy postac jest czarujaca
  isMage = false
  for _, aff in ipairs(affs) do
    if affs.name ~= '' then isMage = true end
  end

  if isMage == true then
    -- wersja dla magow, same nazwy czarow
    -- oraz jesli affekt nie jest czarem i nie ma nazwy - jako tekstu
    local rawAffs = {}
    for _, aff in ipairs(affs) do
      if aff.name == '' then table.insert(rawAffs, aff) end
    end
    height = height + (fontHeight + 2) * #rawAffs
    for _, rawAff in ipairs(rawAffs) do
      color = "#44aa44"
      if rawAff.negative == true then
        color = "#dd0000"
      end
      local desc = rawAff.desc
      if type(rawAff.extraValue) == 'string' or type(rawAff.extraValue) == 'number' then desc = '(' .. rawAff.extraValue .. ') ' .. desc end
      txt = txt .. '<div style="font-size:'..fontSize..'px;white-space:nowrap;color:'.. color ..'">' .. rawAff.desc .. '</div>'
    end
    -- same nazwy afektow w formie word-wrap
    fontSize = 12
    local list = {}
    local blockWidths = {}
    local fontWidth, fontHeight = calcFontSize(fontSize, getFont())
    for _, aff in ipairs(affs) do
      if aff.name ~= '' then
        color = "#44aa44"
        if aff.negative == true then
          color = "#dd0000"
        end
        local affName = aff.name
        if type(aff.extraValue) == 'string' or type(aff.extraValue) == 'number' then affName = '(' .. aff.extraValue .. ') ' .. affName end
        table.insert(blockWidths, utf8.len(affName) * fontWidth + 10)
        table.insert(list, '<span style="white-space:nowrap;font-size:'..fontSize..'px;color:'..color..'">'..affName..'</span>')
      end
    end
    if #list > 0 then
      txt = txt .. '<div style="white-space:wrap;width:100%;font-family:\''..getFont()..'\'">' .. table.concat(list, ", ") .. '</div>'
      height = height + kinfo:calculateTextHeight(blockWidths, kgui.ui.info.wrapper:get_width() - 30, fontHeight + 2)
    end
  else
    -- wersja z opisami, dla nie czarujacych
    local fontSize = 14
    if #affs > 6 then fontSize = 11 end
    if #affs > 8 then fontSize = 10 end
    local fontWidth, fontHeight = calcFontSize(fontSize, 'Marcellus')
    height = height + (fontHeight + 2) * #affs
    for _, aff in ipairs(affs) do
      color = "#44aa44"
      if aff.negative == true then
        color = "#dd0000"
      end
      local desc = aff.desc
      if type(aff.extraValue) == 'string' or type(aff.extraValue) == 'number' then desc = '(' .. aff.extraValue .. ') ' .. desc end
      txt = txt .. '<div style="font-size:'..fontSize..'px;white-space:nowrap;color:'.. color ..'">' .. aff.desc .. '</div>'
    end
  end

  kgui:setBoxContent('info', txt, height)
  kgui:update()
end

function kinfo:translatePos(text)
  local width = 200
  if text == "dead" then return '<span style="color:#ff0000">martwy</span>', 132 end
  if text == "mortally wounded" then return '<span style="color:#ff0000">umierający</span>', 168 end
  if text == "incapacitated" then return '<span style="color:#ff0000">unieruchomiony</span>', 248 end
  if text == "stunned" then return '<span style="color:#ff8800">oszołomiony</span>', 194 end
  if text == "sleeping" then return '<span style="color:#cccc00">śpisz</span>', 78 end
  if text == "resting" then return '<span style="color:#00cc00">odpoczywasz</span>', 202 end
  if text == "sitting" then return '<span style="color:#ffff00">siedzisz</span>', 118 end
  if text == "fighting" then return '<span style="color:#ff8800">walczysz</span>', 132 end
  if text == "standing" then return '<span style="color:#00cc00">stoisz</span>', 98 end
  return text, width
end

function kinfo:calculateTextHeight(blockWidths, maxWidth, fontSize)
  local fontWidth, fontHeight = calcFontSize(fontSize, 'Marcellus')
  local currWidth = 0
  local linesCount = 1
  for _, blockWidth in ipairs(blockWidths) do
    if currWidth + blockWidth > maxWidth then
      currWidth = 0
      linesCount = linesCount + 1
    end
    currWidth = currWidth + blockWidth
  end
  return linesCount * (fontHeight + 2)
end