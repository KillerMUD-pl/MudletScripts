module("kchat", package.seeall)
setfenv(1, getfenv(2));

kchat = kchat or {}
kchat.enabled = false
kchat.colors = kchat.colors or {}
kchat.box = nil;

function kchat:doChat()
  local param = kinstall.params[1]
  if param ~= "silent" then
    cecho('<gold>Włączam panel czatu\n')
  end
  kchat:addBox()
  kinstall:setConfig('chat', 't')
  kchat.enabled = true
end

function kchat:undoChat()
  local param = kinstall.params[1]
  if param ~= 'silent' then
    cecho('<gold>Wyłączam panel czatu\n')
  end
  kchat:removeBox()
  kinstall:setConfig('chat', 'n')
  kchat.enabled = false
end

function kchat:doUninstall()
  kchat:unregister()
end

function kchat:doInit()
  local colors = kinstall:getConfig('kchatColors')
  if colors == nil or colors == "" or colors == false then colors = "{}" end
  kchat.colors = yajl.to_value(colors)
  if kinstall:getConfig('chat') == 't' then
    kchat:register()
    kchat:doChat()
  end
end

function kchat:doUpdate()
  kchat:charchatTriggerHandler()
end

--
--
--

function kchat:register()
  kchat:unregister()

  -- [Zeddicus]: Trul napisz cos na kanale immo
  -- [Trul]: e
  -- Trul mówi klanowi 'e'
  -- Mówisz do klanu 'test'
  -- Trul mówi 'e'
  -- Mówisz 'test'
  -- Trul mówi tobie 'test'
  -- Mówisz Trulowi 'test'
  -- Pytasz 'test!?'
  -- Wykrzykujesz 'test!'
  -- Trul pyta 'tesst?'
  -- Trul wykrzykuje 'test!'
  -- Pytasz Trula 'test?'
  -- Wykrzykujesz do Trula 'test!'
  -- Trul pyta się ciebie 'test?'
  -- Trul wykrzykuje w twoim kierunku 'test!'
  -- Trul mówi ci 'test'
  -- Trul krzyczy do ciebie 'test!'
  -- Trul mówi ci 'dest?'
  -- Trul mowi grupie 'test!'
  -- Mowisz do grupy 'test?'
  -- Krzyczysz 'test'
  -- Wrzeszczysz 'test!'
  -- Trul wrzeszczy 'eqwewq!'
  -- Trul krzyczy 'e'
  -- 

  kchat.chatTrigger = tempRegexTrigger("^(\\[(\\w+)\\]:\\s(.+)|(\\w+) m[oó]wi klanowi '(.+)'|()M[oó]wisz do klanu '(.+)'|(\\w+) m[oó]wi '(.+)'|()M[oó]wisz '(.+)'|(\\w+) m[oó]wi tobie '(.+)'|(\\w+) m[oó]wi \\w+ '(.+)'|()M[oó]wisz \\w+ '(.+)'|()Pytasz '(.+)'|()Pytasz \\w+ '(.+)'|()Wykrzykujesz '(.+)'|()Wykrzykujesz do \\w+ '(.+)'|(\\w+) pyta '(.+)'|(\\w+) wykrzykuje '(.+)'|(\\w+) pyta si[eę] ciebie '(.+)'|(\\w+) wykrzykuje w twoim kierunku '(.+)'|(\\w+) krzyczy do ciebie '(.+)'|()M[oó]wisz do grupy '(.+)'|()Krzyczysz '(.+)'|()Wrzeszczysz '(.+)'|(\\w+) wrzeszczy '(.+)'|(\\w+) krzyczy '(.+)')$", kchat.chatTriggerHandler)
end

function kchat:unregister()
  if kchat.chatTrigger then killTrigger(kchat.chatTrigger) end
end

--
-- Wyswietla konsole chatu w okienku
--
function kchat:addBox()
  local wrapper = kgui:addBox('chat', 0, "Czat", "chat")
  kchat.box = kchat.box or Geyser.MiniConsole:new({
    name = "kchatBox",
    x = 4,
    y = kgui.baseFontHeightPx + 4 .. "px",
    width = "100%-6px",
    height = "100%-".. kgui.baseFontHeightPx + 6 .."px",
    scrollBar = true,
    fontSize = kgui.baseFontHeight,
    color = "black",
  }, wrapper)
  kchat.box:echo("\n")
  kgui:update()
end

--
-- Usuwa okienko chatu
--
function kchat:removeBox()
  kgui:removeBox('chat')
  kgui:update()
end

--
-- Dodaje wiadomości z czatu do konsoli w okienku
--
function kchat:chatTriggerHandler()
  if kchat.enabled == false then
    return
  end

  selectCurrentLine()
  copy()
  kchat.box:appendBuffer()

  kgui:update()
end
