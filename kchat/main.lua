module("kchat", package.seeall)
setfenv(1, getfenv(2));

kchat = kchat or {}
kchat.enabled = false
kchat.colors = kchat.colors or {}
kchat.box = nil;
kchat.console = nil;

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
  kchat.console:reposition()
end

--
--
--

function kchat:register()
  kchat:unregister()
  kchat.chatTrigger = tempRegexTrigger("(^(\\[(\\w+)\\]:\\s(.+)|(\\w+) m[oó]wi klanowi '(.+)'|()M[oó]wisz do klanu '(.+)'|(\\w+) m[oó]wi '(.+)'|()M[oó]wisz '(.+)'|(\\w+) m[oó]wi tobie '(.+)'|(\\w+) m[oó]wi \\w+ '(.+)'|()M[oó]wisz \\w+ '(.+)'|()Pytasz '(.+)'|()Pytasz \\w+ '(.+)'|()Wykrzykujesz '(.+)'|()Wykrzykujesz do \\w+ '(.+)'|(\\w+) pyta '(.+)'|(\\w+) wykrzykuje '(.+)'|(\\w+) pyta si[eę] ciebie '(.+)'|(\\w+) wykrzykuje w twoim kierunku '(.+)'|(\\w+) krzyczy do ciebie '(.+)'|()M[oó]wisz do grupy '(.+)'|()Krzyczysz '(.+)'|()Wrzeszczysz '(.+)'|(\\w+) wrzeszczy '(.+)'|(\\w+) krzyczy '(.+)')$)", kchat.chatTriggerHandler)
end

function kchat:unregister()
  if kchat.chatTrigger then killTrigger(kchat.chatTrigger) end
end

--
-- Wyswietla konsole chatu w okienku
--
function kchat:addBox()
  local wrapper = kgui:addBox('chat', 0, "Czat", "chat")
  kchat.box = Geyser.Label:new({
    x = 2,
    y = kgui.baseFontHeightPx + 4 .. "px",
    width = "100%-4px",
    height = "100%-".. kgui.baseFontHeightPx + 6 .."px",
  }, wrapper)
  kchat.console = kchat.console or Geyser.MiniConsole:new({
    name = "chatConsole",
    width = "100%-6px",
    height = "100%-4px",
    x = "4px",
    y = "2px",
    scrollBar = true,
    fontSize = kgui.baseFontHeight,
  }, kchat.box)
  kchat.console:setColor(33, 33, 33)
  kchat.console:echo("\n")
  kchat.console:enableAutoWrap()
  kgui:update()
end

--
-- Usuwa okienko chatu
--
function kchat:removeBox()
  kgui.console = nil
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

  if not hasFocus() then
    alert(5)
  end

  selectCurrentLine()
  local formattedText = copy2decho()
  -- usuwanie tla
  formattedText = string.gsub(formattedText, ":%d+,%d+,%d+>", ">")
  -- poprawka buga w copy2echo
  formattedText = utf8.gsub(formattedText, "<r><%d+,%d+,%d+>(.)'<r>$", "%1'<r>")
  kchat.console:decho(formattedText .. "\n")

  kgui:update()
end
