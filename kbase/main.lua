module("kbase", package.seeall)
setfenv(1, getfenv(2));

kbase = kbase or {}
local open = io.open
local spells = nil
local teachers = nil
local regions = { }
local classes = { }

local availableRegions = { 'Arras', 'Forteca', 'Carrallak', 'Easterial', 'Silea', 'Nowy Kontynent', 'Karakris' }
local availableClasses = { 'Wojownik', 'Złodziej', 'Barbarzyńca', 'Czarny Rycerz', 'Nomad', 'Mag', 'Druid', 'Kleryk', 'Paladyn' }
local lastFilterValue = nil

local icon_locked = '🗝️'
local icon_notes = '‼'
local icon_boss = '💀️'
local icon_dungerous = '⚔'
local icon_roaming = '🥾'

function kbase:doUninstall()
end

function kbase:doInit()
  if kinstall:getConfig('lookupKlasy') == 't' then
    classes = yajl.to_value(kinstall:getConfig('lookupKlasy', {}))
    regions = yajl.to_value(kinstall:getConfig('lookupRegiony', {}))
  end
end

function kbase:doLookup()

  local param = kinstall.params[1]
  local phrase = table.concat(kinstall.params, ' ', 2)

  if param == nil or string.trim(param) == '' or phrase == nil or string.trim(phrase) == '' then
    kbase:printLookupHelp()
    return
  end

  if string.trim(param) == 'spell' then
    kbase:searchSpells(phrase)
    return
  end

  if string.trim(param) == 'skill' then
    kbase:searchTeachers(phrase)
    return
  end

  if string.trim(param) == 'region' then
    kbase:setRegionFilter(phrase)
    return
  end

  if string.trim(param) == 'class' then
    kbase:setClassFilter(phrase)
    return
  end

  -- W przypadku, gdyby wyszukiwać po innym kluczu niż dopuszczalne można wyświetlić helpa
  kbase:printLookupHelp()
end

function kbase:setRegionFilter(phrase)
  if string.trim(phrase) == 'all' or string.trim(phrase) == 'clear' then
    regions = { }
    cecho('<cyan>Usuwanie filtrów regionów.\n')
    return
  end

  if kbase:filterMatcher(phrase, availableRegions) then
    local matchedIdx = table.index_of(regions, lastFilterValue)
    if matchedIdx ~= nil then
      cecho(string.format('Usuwanie filtrowania po regionie: <green>%s\n', lastFilterValue))
      table.remove(regions, matchedIdx)
    else
      cecho(string.format('Ustawienie filtrowania po regionie: <green>%s\n', lastFilterValue))
      table.insert(regions, lastFilterValue)
    end
    kinstall:setConfig('lookupRegiony', yajl.to_string(regions))
    return
  else
    cecho(string.format('Filtrowanie nieudane, nie rozpoznano regionu: <red>%s\n', phrase))
    cecho(string.format('<green>Dostępne regiony:<cyan> %s\n', table.concat(availableRegions, ", ")))
    return
  end
end

function kbase:setClassFilter(phrase)
  if string.trim(phrase) == 'all' or string.trim(phrase) == 'clear' then
    classes = { }
    kinstall:setConfig('lookupKlasy', yajl.to_string(classes))
    cecho('<cyan>Usuwanie filtrów klas.\n')
    return
  end

  if kbase:filterMatcher(phrase, availableClasses) then
    local matchedIdx = table.index_of(classes, lastFilterValue)
    if matchedIdx ~= nil then
      cecho(string.format('Usuwanie filtrowania po klasie: <green>%s\n', lastFilterValue))
      table.remove(classes, matchedIdx)
    else
      cecho(string.format('Ustawienie filtrowania po klasie: <green>%s\n', lastFilterValue))
      table.insert(classes, lastFilterValue)
    end
    kinstall:setConfig('lookupKlasy', yajl.to_string(classes))
    return
  else
    cecho(string.format('Filtrowanie nieudane, nie rozpoznano klasy: <red>%s\n', phrase))
    cecho(string.format('<green>Dostępne klasy:<cyan> %s\n', table.concat(availableClasses, ", ")))
    return
  end
end

function kbase:printLookupHelp()
  cecho('<gold>Dostępne komendy:\n')
  cecho('<cyan>+lookup skill <nazwa skilla>   <grey>- wyszukuje nauczycieli danego skilla.\n')
  cecho('<cyan>+lookup spell <nazwa spella>   <grey>- wyszukuje księgi z danym czarem.\n')
  cecho('<cyan>+lookup spell all              <grey>- pokazuje wszystkie moby z księgami.\n')
  cecho('<cyan>+lookup region <nazwa regionu> <grey>- dodaje region do listy filtrów.\n')
  cecho('<cyan>+lookup region <all/clear>     <grey>- czyści filtr regionów.\n')
  cecho('<cyan>+lookup class <nazwa klasy>    <grey>- dodaje klasę do listy filtrów.\n')
  cecho('<cyan>+lookup class <all/clear>      <grey>- czyści filtr klas.\n')
  cecho('<cyan>+lookup                        <grey>- pokazuje helpa i aktywne filtry.\n\n')
  kbase:echoFilterInfo(true)
  cecho(string.format('<gold>Dostępne klasy:  <cyan> %s\n', table.concat(availableClasses, ", ")))
  cecho(string.format('<gold>Dostępne regiony:<cyan> %s\n\n', table.concat(availableRegions, ", ")))
  cecho(string.format('<gold>Legenda Ikon:\n'))
  cecho(string.format('<cyan>%s - Mob znajduje się za zamkniętymi drzwiami lub w innym trudno dostępnym miejscu\n', icon_locked))
  cecho(string.format('<cyan>%s  - Mob znajduje się w kraince z agresywnymi mobami lub sam jest agresywny\n', icon_dungerous))
  cecho(string.format('<cyan>%s - Mob jest bossem lub wymaga pokonania bossa by się do niego dostać\n', icon_boss))
  cecho(string.format('<cyan>%s - Mob chodzi po krainie lub wielu krainach, nawigacja prowadzi do krainy\n', icon_roaming))
  cecho(string.format('<DimGrey>%s<cyan>  - Dodatkowe informacje wyświetlające się w toolipie po najechaniu na moba\n', icon_notes))
end

function kbase:decodeSpells()
  local text = kbase:read_file(getMudletHomeDir() .. '/kbase/spells.json', "r")
  spells = yajl.to_value(text)
end

function kbase:searchSpells(phrase)

    if spells == nil then
        kbase:decodeSpells()
    end

    cecho(string.format('<gold>Wyszukiwanie ksiąg z czarem: <cyan>%s\n', phrase))
    kbase:echoFilterInfo()

    for value in kbase:values(spells) do
        if kbase:satisfiesSpellFilters(value) then
          local text = kbase:formatSpellEntry(value)
            if phrase == 'all' then
              kbase:printEntry(value, text)
            else
                for spell in kbase:values(value.spells) do
                    if (string.lower(spell) == string.lower(phrase)) then
                        kbase:printEntry(value, text)
                        break
                    end
                end
            end
        end
    end
    cecho('<gold>Wyszukiwanie zakończone\n')
end

function kbase:decodeTeachers()
  local text = kbase:read_file(getMudletHomeDir() .. '/kbase/teachers.json', "r")
  teachers = yajl.to_value(text)
end

function kbase:searchTeachers(phrase)

  if teachers == nil then
    kbase:decodeTeachers()
  end

  cecho(string.format('<gold>Wyszukiwanie nauczycieli umiejętność: <cyan>%s\n', phrase))
  kbase:echoFilterInfo()

  local teachersList = { }

  for _, teacher in pairs(teachers) do

    if kbase:satisfiesTeacherFilters(teacher) then
      for skill in kbase:values(teacher.skills) do
        if skill.name == phrase then
          local key = string.format('<green>%s<grey>: uczy %s<grey>-%s %s', teacher.mob, tostring(skill.min), tostring(skill.max), kbase:paidInfo(skill))
          teachersList[key] = {max = skill.max, item = teacher}
          break
        end
      end
    end
  end

  for k, v in spairs(teachersList, function(t,a,b) return t[b].max > t[a].max end) do
    kbase:printEntry(v.item, k)
  end

  cecho('<gold>Wyszukiwanie zakończone\n')
end

function kbase:printEntry(item, text)
    local notes, dangerous, boss, locked, roaming, fullNotes
    if item.notes ~= nil then
      notes = icon_notes
      fullNotes = item.notes
    else notes = '' end
    if item.dangerous ~= nil then dangerous = icon_dungerous else dangerous = '' end
    if item.isBoss ~= nil then boss = icon_boss else boss = '' end
    if item.locked ~= nil then locked = icon_locked else locked = '' end
    if item.roaming ~= nil then roaming = icon_roaming else roaming = '' end

    if notes ~= '' or dangerous ~= '' or boss ~= '' or locked ~= '' or roaming ~= '' then
      text = text .. string.format(' <DimGrey>[%s%s%s%s%s]', notes, dangerous, boss, locked, roaming)
    end

    local tooltip = ''
    if fullNotes ~= nil then tooltip = string.format('%s %s\n', icon_notes, fullNotes) end
    tooltip = tooltip .. string.format("Kliknij by wyznaczyć ściężke do: %s!", item.mob)

    if item.roomVnum ~= nil then
      cechoLink('<white>(+) ' .. text .. '\n', string.format([[ kbase:speedwalkToVnum(%s) ]], item.roomVnum), tooltip, true)
    elseif fullNotes ~= nil then
      cechoLink('<DimGrey>(*) ' .. text .. '\n', '', tooltip, true)
    else
      cecho('<DimGrey>(*) ' .. text .. '\n')
  end
end

function kbase:satisfiesTeacherFilters(teacher)
  if not(kbase:isEmpty(regions)) and table.contains(regions, teacher.region) then
    return false
  elseif not(kbase:isEmpty(classes)) and not(kbase:forAny(teacher.classes, classes)) then
    return false
  else
    return true
  end
end

function kbase:satisfiesSpellFilters(spell)
    if not(kbase:isEmpty(regions)) and table.contains(regions, spell.region) then
        return false
    elseif not(kbase:isEmpty(classes)) and not(table.contains(classes, spell.class)) then
        return false
    else
        return true
    end
end

function kbase:read_file(path)
  local file = open(path, "r")
  if not file then return nil end
  local content = file:read "*a"
  file:close()
  return content
end

function kbase:printSpellsTable(tbl)
  local spells = ""
  for k, v in ipairs(tbl) do
    if (k == 1) then
      spells = string.lower(v)
    else
      spells = string.format("%s, %s", spells, string.lower(v))
    end
  end
  return spells
end

function kbase:formatSpellEntry(entry)
  return string.format("<green>%s<white>: %s - %s", entry.class, entry.mob, kbase:printSpellsTable(entry.spells))
end

function kbase:applySpellFilter(item)
  if item == nil then return false end
  if not(kbase:isEmpty(regions)) and not(table.contains(regions, item.region)) then return false end
  if not(kbase:isEmpty(classes)) and not(table.contains(classes, item.class)) then return false end
  return true
end

function kbase:speedwalkToVnum(vnum)
  local roomId = kmap.vnumToRoomIdCache[tonumber(vnum)]
  if roomId == nil then
    return
  end
  getPath(getPlayerRoom(), roomId)
  if #speedWalkPath == 0 then
    cecho('\n<red>Uh... ciężka sprawa, nie wiem jak tam dojść z miejsca w którym się znajdujesz...\n')
    return nil
  end
  local targetRoomName, targetRoomId, cost = kspeedwalk:prepare()
  cecho('\n<gold>Ścieżka do <green>' .. targetRoomName .. ' (id: ' .. targetRoomId .. ')<gold> znaleziona.\nSzacowana ilość punktów ruchu: <green>'.. cost ..'\n<gold>Wpisz <green>+walk<gold> by rozpocząć, <green>+stop<gold> by zakończyć.\n')
end

function kbase:forAny(t1, t2)
  for _, value in pairs(t1) do
    if table.contains(t2, value) then
      return true
    end
  end
  return false
end

function kbase:echoFilterInfo(showCommand)
  if not(kbase:isEmpty(regions)) and not(kbase:isEmpty(classes)) then
    cecho(string.format('<DimGrey>(Filtry) Regiony: <green>%s<grey> Klasy: <green>%s<grey>\n', table.concat(regions, ", "), table.concat(classes, ", ")))
  elseif not(kbase:isEmpty(regions)) and kbase:isEmpty(classes) then
    cecho(string.format('<DimGrey>(Filtry) Regiony: <green>%s<grey>\n', table.concat(regions, ", ")))
  elseif kbase:isEmpty(regions) and not(kbase:isEmpty(classes)) then
    cecho(string.format('<DimGrey>(Filtry) Klasy: <green>%s<grey>\n', table.concat(classes, ", ")))
  elseif showCommand ~= nil then
    cecho('<DimGrey>(Filtry) <cyan>Brak ustawionych filtrów!\n')
  end
end

function kbase:filterMatcher(phrase, t)
  if table.contains(t, phrase) then
    lastFilterValue = phrase
    return true
  end

  for keyword in kbase:values(t) do
    if string:areLooselySame(phrase, keyword) then
      lastFilterValue = keyword
      return true
    end
  end

  return false
end

function kbase:paidInfo(skill)
  if skill.reqSkill ~= nil and skill.reqSkill ~= 0 and skill.max >= skill.reqSkill then
    return string.format('<cyan>(Płatne od: <grey>%s%s)', kbase:max(skill.min, skill.reqSkill), kbase:discount(skill))
  end
  return ''
end

function kbase:discount(skill)
  if skill.price ~= nil and skill.price ~= 0 then
    if skill.price < 25 then
      return string.format("<cyan>, <PaleGreen>%s<cyan>", "prawie za darmo")
    elseif skill.price < 40 then
      return string.format("<cyan>, <dark_green>%s<cyan>", "dobra cena")
    elseif skill.price < 60 then
      return string.format("<cyan>, <YellowGreen>%s<cyan>", "cena okazjonalna")
    elseif skill.price < 80 then
      return string.format("<cyan>, <yellow>%s<cyan>", "mały upust")
    elseif skill.price < 99 then
      return string.format("<cyan>, <orange>%s<cyan>", "zwykła cena")
    elseif skill.price < 105 then
      return string.format("<cyan>, <DarkOrange>%s<cyan>", "trochę drożej")
    elseif skill.price < 115 then
      return string.format("<cyan>, <OrangeRed>%s<cyan>", "drogo")
    elseif skill.price < 130 then
      return string.format("<cyan>, <red>%s<cyan>", "rabunek w biały dzień")
    else
      return string.format("<cyan>, <ansiRed>%s<cyan>", "jak w krasnoludzkim banku")
    end
  else return ""
  end
end

function kbase:max(v1, v2)
  if (v1 > v2) then
    return v1
  end
  return v2
end

function kbase:values(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end

function kbase:isEmpty(t)
  if next(t) == nil then
    return true
  end
  return false
end
