module("kbase", package.seeall)
setfenv(1, getfenv(2));

kbase = kbase or {}
kbase.enabled = false

local open = io.open
local spells = nil
local teachers = nil
local region = nil
local classes = nil

local availableRegions = { 'Arras', 'Forteca', 'Carrallak', 'Easterial', 'Silea', 'Nowy Kontynent' }
local availableClasses = { 'Wojownik', 'Złodziej', 'Barbarzyńca', 'Czarny Rycerz', 'Nomad', 'Mag', 'Druid', 'Kleryk', 'Paladyn' }
local lastFilterValue = nil
--
-- Funkcje wymagane przez kinstall
--

-- Wykonywane przed odinstalowaniem modułu
function kbase:doUninstall()
end

-- Wykonywane przy starcie mudleta
function kbase:doInit()
  if kinstall:getConfig('kbase') == 't' then
    kinstall.params[1] = 'silent'
  end
end

--
-- Obsługa komend
--
function kbase:doLookup()

  local param = kinstall.params[1]
  local phrase = table.concat(kinstall.params, ' ', 2)

  if param == nil or string.trim(param) == '' or phrase == nil or string.trim(phrase) == '' then
    printLookupHelp()
    return
  end

  if string.trim(param) == 'spell' then
    searchSpells(phrase)
    return
  end

  if string.trim(param) == 'skill' then
    searchTeachers(phrase)
    return
  end

  -- W przypadku, gdyby wyszukiwać po innym kluczu niż 'spell' lub 'skill' można wyświetlić helpa
  printLookupHelp()
end

--sets or remove region/class filter
function kbase:doFilter()

  local param = kinstall.params[1]
  local phrase = table.concat(kinstall.params, ' ', 2)

  if param == nil or string.trim(param) == '' then
    printFilterHelp()
    return
  end

  if string.trim(param) == 'clear' then
    class = nil
    region = nil
    cecho('<cyan>Usuwanie wszystkich filtrów.\n')
    return
  end

  if string.trim(param) == 'show' then
    if class == nil and region == nil then cecho('<gold>Brak ustawionego filtrowania\n') return end
    if class ~= nil then cecho(string.format('<gold>Filtrowanie po klasie: <cyan>%s\n', class)) end
    if region ~= nil then cecho(string.format('<gold>Filtrowanie po regionie: <cyan>%s\n', region)) end
    return
  end

  if  phrase == nil or string.trim(phrase) == '' then
    printFilterHelp()
    return
  end

  if string.trim(param) == 'class' then

    if filterMatch(phrase, availableClasses, class) then
      cecho(string.format('Ustawienie filtrowania po klasie: <green>%s\n', lastFilterValue))
      return
    else
      cecho(string.format('Filtrowanie nieudane, nie rozpoznano klasy: <red>%s\n', phrase))
      cecho('<green>Dostępne klasy:<cyan> Druid, Mag, Kapłan, Paladyn \n')
      return
    end
  elseif string.trim(param) == 'region' then
    if filterMatch(phrase, availableRegions, region) then
      cecho(string.format('Ustawienie filtrowania po regionie: <green>%s\n', lastFilterValue))
      return
    else
      cecho(string.format('Filtrowanie nieudane, nie rozpoznano regionu: <red>%s\n', phrase))
      cecho('<green>Dostępne regiony:<cyan> Arras, Forteca, Carrallak, Easterial, Silea, Nowy Kontynent \n')
      return
    end
  end
end

function printLookupHelp()
  cecho('<grey>Lookup Help\n')
  cecho('<gold>Dostępne komendy:\n\n')
  cecho('<cyan>+lookup <spell/skill> <nazwa skilla>\n')
  cecho('<gold>Pozwala wyszukać nauczycieli którzy uczą danego skilla lub \n')
  cecho('<gold>moba w księdze której losuje się dany spell.\n\n')
  cecho('<cyan>+lookup <spell/skill> all\n')
  cecho('<gold>Pozwala wyszukac wszystkich mobów z ksiegami \n')
  cecho('<gold>lub nauczycieli (Polecam korzystać z komendy <cyan>+filter<gold>).\n')
  cecho('<grey>(hint: jeśli nie pamiętasz dokładnej nazwy szukanego czaru,\n')
  cecho('<grey>możesz użyć komendy: <green>spells all<grey>)\n\n')
  cecho('<gold>Przykłady:\n')
  cecho('<cyan>+lookup spell cone of cold\n')
  cecho('<cyan>+lookup spell all\n')
  cecho('<cyan>+lookup skill dualwield style\n')
end

function printFilterHelp()
  cecho('<grey>Filter Help\n')
  cecho('<gold>Dostępne komendy:\n\n')
  cecho('<cyan>+filter show\n')
  cecho('<gold>Komenda pokazuje aktywnie ustawione filtry. \n')
  cecho('<cyan>+filter <class/region> <wartość>\n')
  cecho('<gold>Komenda ogranicza jakie wyniki zostaną wyświetlone przez komendę <cyan>+lookup<gold>. \n')
  cecho('<gold>Przykładowe użycie: <cyan>+filtera class paladyn\n')
  cecho('<cyan>+filter clear\n')
  cecho('<gold>Komenda pozwala usunąć wszystkie filtry.\n\n')
  cecho('<gold>Dostępne wartości:\n')
  cecho('<green>Klasa:<cyan> Druid, Mag, Kleryk, Paladyn \n')
  cecho('<green>Region:<cyan> Arras, Forteca, Carrallak, Easterial, Silea, Nowy Kontynent \n')
end

function decodeSpells()
  local text = read_file(getMudletHomeDir() .. '/kbase/spells.json', "r")
  spells = yajl.to_value(text)
end

function searchSpells(phrase)

  if spells == nil then
    decodeSpells()
  end

  cecho(string.format('<gold>Wyszukiwanie ksiąg z czarem: <cyan>%s\n', phrase))
  filterInfo()

  local filteredSpells = table.n_collect(spells, applyFilters)

  if phrase ~= 'all' then
    for value in values(filteredSpells) do
      for spell in values(value.spells) do
        if (string.lower(spell) == string.lower(phrase)) then
          cechoLink(formatSpellEntry(value), string.format([[ kbase:speedwalkToVnum(%s) ]], value.vnum), string.format("Kliknij by wyznaczyć ściężke do %s!", value.mob), true)
          break
        end
      end
    end
  else
    for value in values(filteredSpells) do
        cechoLink(formatSpellEntry(value), string.format([[ kbase:speedwalkToVnum(%s) ]], value.vnum), string.format("Kliknij by wyznaczyć ściężke do %s!", value.mob), true)
      end
  end

  cecho(string.format('<gold>Wyszukiwanie zakończone\n', phrase))
end

function decodeTeachers()
  local text = read_file(getMudletHomeDir() .. '/kbase/teachers.json', "r")
  teachers = yajl.to_value(text)
  display(teachers)
end

function searchTeachers(phrase)

  if teachers == nil then
    decodeTeachers()
  end

  cecho(string.format('<gold>Wyszukiwanie nauczycieli umiejętność: <cyan>%s\n', phrase))
  filterInfo()

  local filteredTeachers = table.n_collect(teachers, applyFilters)

end

function read_file(path)
  local file = open(path, "r")
  if not file then return nil end
  local content = file:read "*a"
  file:close()
  return content
end

function printSpellsTable(tbl)
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

function formatSpellEntry(entry)
  if entry.notes ~= nil then
    return string.format("<green>%s<white>: %s - %s [<gold>%s<white>]\n", entry.class, entry.mob, printSpellsTable(entry.spells), entry.notes)
  end
  return string.format("<green>%s<white>: %s - %s\n", entry.class, entry.mob, printSpellsTable(entry.spells))
end

function applyFilters(item)
  if region ~= nil and item.region ~= region then return false end
  if class ~= nil and item.class ~= table and item.class ~= class then return false end
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

function filterInfo()
  if class ~= nil and region ~= nil then
    cecho(string.format('(<grey>Ustawione filtry: <cyan>%s<grey>)\n', table.concat({class, region}, ", ")))
  elseif class ~= nil and region == nil then
    cecho(string.format('(<grey>Ustawione filtry: <cyan>%s<grey>)\n', class, ", "))
  elseif class == nil and region ~= nil then
    cecho(string.format('(<grey>Ustawione filtry: <cyan>%s<grey>)\n', region, ", "))
  end
end

function filterMatch(phrase, t, v)
  if table.contains(t, phrase) then
    if (v == 'class') then
      class = phrase
    elseif (v == 'region') then
      region = phrase
    end
    lastFilterValue = phrase
    return true
  end

  local lowerPhrase = string.sub(string.lower(phrase), 1,3)

  for keyword in values(t) do
    local lowerKeyword = string.sub(string.lower(keyword), 1,3)
    if (lowerPhrase == lowerKeyword) then
      if (v == 'class') then
        class = phrase
      elseif (v == 'region') then
        region = phrase
      end
      lastFilterValue = keyword
      return true
    end
  end

  return false
end

function values(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end
