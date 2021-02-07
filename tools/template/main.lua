module("template", package.seeall)

ktemplate = ktemplate or {}

--
-- funkcja wykonywana po wydaniu komendy +test
--
function ktemplate:doTest(params)
  cecho('<gold>Włączam testowy moduł\n')
  kinstall:setConfig('template', 't')
  ktemplate:addBox(params)
end

--
-- funkcja wykonywana po wydaniu komendy -test
--
function ktemplate.undoTest(params)
  cecho('<gold>Wyłączam testowy moduł\n')
  kinstall:setConfig('template', 'n')
  kgui:removeBox('template')
  kgui:update()
end

--
-- funkcja wykonywana przy odpaleniu mudleta
--
function ktemplate.doInit()
  if kinstall:getConfig('template') == 't' then
    ktemplate:addBox()
  end
end

--
-- funkcja wykonywana jednorazowo przed odinstalowaniem pakietu
--
function ktemplate.doUninstall()
  ktemplate:unregister()
end


--
-- funkcja wykonywana jednorazowo po zainstalowaniu pakietu
--
function ktemplate.doInstall()
  cecho("<gold>Testowy moduł jest zainstalowany, możesz edytować jego kod w katalogu twojego profilu\n\n")
end

--
-- Właściwy kod odpalany przy włączaniu się okienka modułu
--
function ktemplate:addBox(params)
  -- przykładowy kod ktory wyswietla cos w okienku
  kgui:toWindow('template', 'Przykładowy tytuł', 'Pzykładowa treść')
end
