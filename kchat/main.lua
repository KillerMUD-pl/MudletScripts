module("kchat", package.seeall)
setfenv(1, getfenv(2))

kchat = kchat or {}
kchat.enabled = false
kchat.colors = kchat.colors or {}
kchat.box = nil
kchat.console = nil
kchat.silent = kchat.silent or 'n'

function kchat:doChat()
  local param = kinstall.params[1]
  if param ~= "silent" then
    cecho('<gold>Włączam panel czatu\n')
  end
  if param == 'silent' then
    kchat.silent = kinstall:getConfig('chatSilent')
    if kchat.silent == 'y' then
      cecho('<gold>Włączono powiadamianie o nowych wiadomościach.\n\n')
      kinstall:setConfig('chatSilent', 'n')
      kchat.silent = 'n'
    else
      cecho('<gold>Wyłączono powiadamianie o nowych wiadomościach.\n\n')
      kinstall:setConfig('chatSilent', 'y')
      kchat.silent = 'y'
    end
    return
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
  --
end

--
--
--

function kchat:register()
  kchat:unregister()
  kchat.chatTrigger = tempRegexTrigger("^((\\w+) (m[oó]wi|nuci|dudni|grzmi|piszczy|warczy|miauczy|szczeka|ryczy|syczy|[sś]piewa|zawodzi|wydaje d[zź]wi[ęe]k|pieje|skrzeczy).*'(.+)'|(\\w+) (pyta|nuci|dudni|piszczy|warczy|miauczy|szczeka|ryczy|syczy|[sś]piewa|pieje|skrzeczy).*'(.+)'|()(M[oó]wisz|Nucisz|Dudnisz|Grzmisz|Piszczysz|Warczysz|Miauczysz|Szczekasz|Ryczysz|Syczysz|[ŚS]piewasz|Zawodzisz|Wydajesz d[zź]wi[eę]k|Piejesz|[ŚS]piewasz).*'(.+)'|()Pytasz.*'(.+)'|()Wykrzykujesz.*'(.+)'|()Krzyczysz '(.+)'|()Wrzeszczysz '(.+)'|(\\w+) wrzeszczy '(.+)'|(\\w+) krzyczy.*'(.+)'|(\\w+) wykrzykuje.*'(.+)'|\\[(\\w+)\\]:\\s(.+))$", kchat.chatTriggerHandler)
end

function kchat:unregister()
  if kchat.chatTrigger then killTrigger(kchat.chatTrigger) end
end

--
-- Wyswietla konsole chatu w okienku
--
function kchat:addBox()
  local wrapper = kgui:addBox('chat', 200, "Czat", "chat")
  kchat.box = Geyser.Label:new({
    name = "chat",
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
    fontSize = kgui.baseFontHeight,
  }, kchat.box)
  kchat.console:setColor(33, 33, 33)
  kchat.console:enableAutoWrap()
  -- upewniamy sie ze wszystko jest odpowiednio przypiete i nie schowane
  kchat.box:add(kchat.console)
  kchat.box:raiseAll()
  kchat.box:show()
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

  if kchat.silent ~= 'y' and not hasFocus() then
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
