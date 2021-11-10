module("template", package.seeall)
setfenv(1, getfenv(2))

template = template or {}
template.enabled = false

--
-- Funkcje wymagane przez kinstall
--

-- Wykonywane przed odinstalowaniem modułu
function template:doUninstall()
  template:unregister()
end

-- Wykonywane przy starcie mudleta
function template:doInit()
  template:register()
  if kinstall:getConfig('template') == 't' then
    kinstall.params[1] = 'silent'
    template:doTest()
  end
end

-- Wykonywane kiedy zmienia sie rozmiar okna - trzeba wtedy przerysować treść, bo może zwęzić się panel
function template:doUpdate()
  template:render()
end

--
-- Obsługa komend
--
-- Nazwy funkcji muszą być skonstruowane jako: <do/undo><nazwa komendy z duzej litery>
--
-- Na przykład, komenda +test modułu template odpali funkcję template:doTest,
-- a komenda -test odpali funkcję template:undoTest 
--
function template:doTest()
  -- zmienna kinstall.params przechowuje parametry przekazane  do komendy, np. komenda +test foo bar
  -- będzie miała: kinstall.params = { "foo", "bar" }
  local param = kinstall.params[1]
  -- przy odpalaniu okienek przy starcie Mudleta, kinstall wysyła zawsze pierwszy parametr "silent"
  -- co oznacza po prostu cichy start, żeby po każdym właczeniu nie spamować "Właczono panel ..."
  if param ~= "silent" then
    cecho('<gold>Włączam przykładowy panel\n')
  end
  -- dodajemy okienko
  template:addBox()
  -- zaznaczamy zmienną i wartość w konfiguracji, że nasze okienko jest właczone
  template.enabled = true
  kinstall:setConfig('template', 't')
end

function template:undoTest()
  local param = kinstall.params[1]
  if param ~= 'silent' then
    cecho('<gold>Wyłączam przykładowy panel\n')
  end
  -- usuwamy okienko
  template:removeBox()
  -- zaznaczamy zmienną i wartość w konfiguracji, że nasze okienko jest wyłączone
  kinstall:setConfig('template', 'n')
  template.enabled = false
end

-- rejestracja eventów i timerów
function template:register()
  template:unregister()
  template.gmcpEvent = registerAnonymousEventHandler("gmcp.Char", "template:render")
  template.receivingGmcpTimer = tempTimer(2, [[ template:checkGmcp() ]], true)
end

-- wyrejestrowanie eventów i timerów
function template:unregister()
  if template.gmcpEvent then killAnonymousEventHandler(template.gmcpEvent) end
  if template.receivingGmcpTimer then killTimer(template.receivingGmcpTimer) end
end

--
-- Dodawanie okienka template
--
function template:addBox()
  kgui:addBox('template', 0, "Template", "test")
  kgui:setBoxContent('template', '<center>Zaloguj się do gry lub włącz GMCP</center>')
end

--
-- Sprawdzanie czy gmcp podaje dane
--
function template:checkGmcp()
  if kinstall.receivingGmcp == false then
    kgui:setBoxContent('template', '<center>Zaloguj się do gry lub włącz GMCP</center>')
  end
end

--
-- Usuwanie okienka template
--
function template:removeBox()
  kgui:removeBox('template')
  kgui:update()
end

--
-- Wyświetlanie treści okienka
--
function template:render()
  if template.enabled == false then return end

  -- upewniamy sie ze wszystko jest na swoim miejscu
  if kgui.ui.template == nil or kgui.ui.template.wrapper == nil then return end

  -- dobrą praktyką jest sprawdzenie czy dane z GMCP istnieją, w tym przypadku czytamy "gmcp.Char"
  local char = gmcp.Char
  if char == nil then return end

  txt = "Cześć " .. char.Vitals.name .. "<br>"
  txt = txt .. "HP: " .. char.Vitals.hp .. '&nbsp;/&nbsp;' .. char.Vitals.max_hp

  kgui:setBoxContent('template', txt)
  kgui:update()
end
