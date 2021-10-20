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
  cecho(string.format('<gold>Dostępne regiony:<cyan> %s\n', table.concat(availableRegions, ", ")))
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

  local filteredSpells = table.n_collect(spells, kbase.applySpellFilter)

  if phrase ~= 'all' then
    for value in kbase:values(filteredSpells) do
      for spell in kbase:values(value.spells) do
        if (string.lower(spell) == string.lower(phrase)) then
          cechoLink(kbase:formatSpellEntry(value), string.format([[ kbase:speedwalkToVnum(%s) ]], value.vnum), string.format("Kliknij by wyznaczyć ściężke do %s!", value.mob), true)
          break
        end
      end
    end
  else
    for value in kbase:values(filteredSpells) do
        cechoLink(kbase:formatSpellEntry(value), string.format([[ kbase:speedwalkToVnum(%s) ]], value.vnum), string.format("Kliknij by wyznaczyć ściężke do %s!", value.mob), true)
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

    if kbase:satisfiesFilters(teacher) then
      for skill in kbase:values(teacher.skills) do
        if skill.name == phrase then
          local key = string.format('<green>%s<grey>: uczy %s-%s <cyan>%s <red>%s', teacher.mob, skill.min, skill.max, kbase:paidFrom(skill), kbase:learnCost(skill))
          local wayText = string.format("Kliknij by wyznaczyć ściężke do: %s!", teacher.mob)
          local roomVnum = teacher.roomVnum
          local notes = teacher.notes
          teachersList[key] = {max = skill.max, linkText = wayText, roomVnum = roomVnum, notes = notes}
          break
        end
      end
    end
  end

  for k, v in spairs(teachersList, function(t,a,b) return t[b].max > t[a].max end) do

    if v.notes ~= nil then
      v.notes = string.format('\n   <grey>[%s]', v.notes)
    else
      v.notes = ''
    end

    if v.roomVnum ~= nil then
      local text = string.format('<white>(+) %s %s\n', k, v.notes)
      cechoLink(text, string.format([[ kbase:speedwalkToVnum(%s) ]], v.roomVnum), v.linkText, true)
    else
      local text = string.format('<DimGrey>(*) %s %s\n', k, v.notes)
      cecho(text)
    end
  end

  cecho('<gold>Wyszukiwanie zakończone\n')
end

function kbase:satisfiesFilters(teacher)
  if not(kbase:isEmpty(regions)) and table.contains(regions, teacher.region) then
    return false
  elseif not(kbase:isEmpty(classes)) and not(kbase:forAny(teacher.classes, classes)) then
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
  if entry.notes ~= nil then
    return string.format("<green>%s<white>: %s - %s [<gold>%s<white>]\n", entry.class, entry.mob, kbase:printSpellsTable(entry.spells), entry.notes)
  end
  return string.format("<green>%s<white>: %s - %s\n", entry.class, entry.mob, kbase:printSpellsTable(entry.spells))
end

function kbase:applySpellFilter(item)
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
  speedwalk:prepare()
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

  local lowerPhrase = string.sub(string.lower(phrase), 1,3)

  for keyword in kbase:values(t) do
    local lowerKeyword = string.sub(string.lower(keyword), 1,3)
    if (lowerPhrase == lowerKeyword) then
      lastFilterValue = keyword
      return true
    end
  end

  return false
end

function kbase:paidFrom(skill)
  if skill.reqSkill ~= nil and skill.reqSkill ~= 0 then
    return string.format('(Płatne od: %s)', tostring(skill.reqSkill))
  end
  return ''
end

function kbase:learnCost(skill)
  if skill.price ~= nil and skill.price ~= 0 then
    return string.format('(Cena: %s)', tostring(skill.price))
  end
  return ''
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
