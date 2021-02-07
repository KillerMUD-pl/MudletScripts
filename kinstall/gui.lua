module("kinstall/gui", package.seeall)
setfenv(1, getfenv(2));

kgui = kgui or {}
kgui.ui = {}
kgui.uiState = kinstall:loadJsonFile(getMudletHomeDir() .. '/kguiSettings.json')

--
-- TODO
--

function kgui:init()
  kgui.uiState.main = kgui.uiState.main or {}
  local width = '35%-20px'
  local x = '-35%'
  if kgui.uiState.main.width ~= nil then
    width = (kgui.uiState.main.width-20) .. 'px'
    x = -(kgui.uiState.main.width) .. 'px'
  end
  kgui.main = kgui.main or
    Geyser.Container:new({
      name = "KGuiMain",
      x=x,
      y="0px",
      width=width,
      height="100%",
    });

  kgui.mainContainer = kgui.mainContainer or
    Geyser.Container:new({
      name = "KGuiMainContainer",
      x="10px",
      y="10px",
      width="100%-10px",
      height="100%-10px",
    }, kgui.main);

  -- pasek do przesuwania
  kgui.mainDrag = kgui.mainDrag or Geyser.Label:new({
    name = "KGuiMainDrag",
    x = "0px",
    y = "0px",
    width="10px",
    height="100%",
    message=""
  }, kgui.main)
  kgui.mainDrag:setStyleSheet([[
    QLabel { background-color: rgba(0,0,0,0%) }
    QLabel::hover {background-color: rgba(60,60,60,100%) }
  ]])
  kgui.mainDrag:setCursor("ResizeHorizontal")
  setLabelClickCallback("KGuiMainDrag", 'kgui:onHDragClick')
  setLabelReleaseCallback("KGuiMainDrag", 'kgui:onHDragRelease')
end

function kgui:addBox(name, height, title, order, closeCallback)
  kgui.ui[name] = {}
  kgui.uiState[name] = kgui.uiState[name] or {}
  kgui.uiState[name].minimized = kgui.uiState[name].minimized or false
  local wrapperHeight = kgui.uiState[name].height or height;
  kgui.uiState[name].height = wrapperHeight
  kgui.uiState[name].y = kgui.uiState[name].y or kgui:findBottom()
  kgui.uiState[name].order = kgui.uiState[name].order or order

  -- tworzenie glownego kontenera boxa
  kgui.ui[name]['wrapper'] = kgui.ui[name]['wrapper'] or Adjustable.Container:new({
    name = name .. 'Wrapper',
    titleText = "",
    x = "0px",
    y = kgui.uiState[name].y,
    width = "100%",
    height = wrapperHeight .. "px",
    buttonsize = 0,
  }, kgui.mainContainer)

  -- dostosowywanie glownego kontenera boxa
  kgui.ui[name]['wrapper']:setPadding(0)
  kgui.ui[name]['wrapper']:disableAutoSave()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperexitLabel']:hide()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperminimizeLabel']:hide()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperadjLabel']:setStyleSheet('border: 2px solid #555555')
  kgui.ui[name]['wrapper']:show()

  -- pasek okienka
  kgui.ui[name]['title'] = kgui.ui[name]['title'] or Geyser.Label:new({
    name = name .. 'Title',
    x = "0px",
    y = "0px",
    width="100%",
    height="20px",
    message=title
  }, kgui.ui[name]['wrapper'])

  -- dostosowywanie paska okienka
  kgui.ui[name]['title']:setStyleSheet("qproperty-alignment: 'AlignLeft | AlignTop'; padding-left: 2px; background: #666666")
  kgui.ui[name]['title']:setFontSize(12)
  kgui.ui[name]['title']:enableClickthrough()

  -- przycisk zamykania
  kgui.ui[name]['close'] = kgui.ui[name]['close'] or Geyser.Label:new({
    name = name .. 'Close',
    x = "-22px",
    y = "0px",
    width="22px",
    height="20px",
    message=[[<center>×</center>]]
  }, kgui.ui[name]['wrapper'])

  -- dostosowywanie przyciski zamykania
  kgui.ui[name]['close']:setStyleSheet("background: #888888; color: #eeeeee")
  kgui.ui[name]['close']:setFontSize(16)
  kgui.ui[name]['close']:setCursor("PointingHand")
  kgui.ui[name]['close']:setClickCallback(closeCallback)

  -- przycisk minimlizacji
  kgui.ui[name]['min'] = kgui.ui[name]['min'] or Geyser.Label:new({
    name = name .. 'Min',
    x = "-44px",
    y = "0px",
    width="22px",
    height="20px",
    message=[[<center>-</center>]]
  }, kgui.ui[name]['wrapper'])

  kgui.ui[name]['min']:setStyleSheet("background: #888888; color: #eeeeee")
  kgui.ui[name]['min']:setFontSize(16)
  kgui.ui[name]['min']:setCursor("PointingHand")
  kgui.ui[name]['min']:setClickCallback(function()
    if kgui.uiState[name].minimized == true then
      kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name]:show()
      kgui.uiState[name].minimized = false
      kgui:update()
    else
      kgui.uiState[name].minimized = true
      kgui.uiState[name].height = kgui.ui[name]['wrapper']:get_height()
      kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name]:hide()
      kgui:update()
    end
  end)

  return kgui.ui[name]['wrapper']
end

function kgui:removeBox(name)
  if kgui.ui[name]['wrapper'] ~= nil then
    kgui.ui[name]['wrapper']:hide()
    kgui.uiState[name] = nil
  end
end

function kgui:newBoxContent(name, content)
  kgui.ui[name]['content'] = kgui.ui[name]['content'] or Geyser.Label:new({
    name = name,
    x = 2,
    y = 20,
    width = "100%-4px",
    height = 0,
    message = formatText(content),
  }, kgui.ui[name]['wrapper'])
  kgui.ui[name]['content']:setStyleSheet("padding: 10px;")
end

function formatText(content)
  return "<span style=\"color: #f0f0f0; font-size: " .. (getFontSize()-2)  .. "px; font-family: '" .. getFont() .. "'\">" .. content .. "</span>"
end

function kgui:setBoxContent(name, content)
  if kgui.ui[name]['content'] == nil then
    kgui:newBoxContent(name, content)
  else
    local formatted = formatText(content)
    kgui.ui[name]['content']:rawEcho(formatted)
    kgui.ui[name]['content'].message = formatted
  end
  kgui.ui[name]['content']:resize('100%-4px', "100%-22px")
  kgui:update()
end

function kgui:calculateBoxSize(name, content)
  local fontSize = kgui.ui[name]['content'].fontSize
  local _, count = string.gsub(content, "<br>", "")
  local _, height = calcFontSize(14)
  return height * ( 1 + count ) + 20
end

function kgui:updateWrapperSize(name)
  local height = 0
  if kgui.ui[name]['content'] == nil
  and kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'] ~= nil
  and kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name] ~= nil
  and kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name].hidden == false then
    height = kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name];
  else
    if kgui.ui[name]['content'] ~= nil and kgui.ui[name]['content'].hidden == false then
        height = kgui:calculateBoxSize(name, kgui.ui[name]['content'].message)
    end
  end
  kgui.ui[name]['wrapper']:resize('100%', height + 22)
end

function kgui:saveState()
  kinstall:saveJsonFile(getMudletHomeDir() .. '/kguiSettings.json', kgui.uiState)
end

function kgui:update()
  local boxes = {}
  for name, data in pairs(kgui.uiState) do
    if kgui.ui[name] ~= nil and kgui.ui[name]['wrapper'] ~= nil then
      local order = data.order or 0
      table.insert(boxes, { ["name"] = name, ["order"] = order })
    end
  end
  table.sort(boxes, function(a,b)
    local orderA = a.order or 0
    local orderB = b.order or 0
    return orderA < orderB
  end)
  local currentY = 0
  for _, data in pairs(boxes) do
    kgui:updateWrapperSize(data.name)
    kgui.ui[data.name]['wrapper']:move(0, currentY)
    currentY = currentY + 10 + kgui.ui[data.name]['wrapper']:get_height()
  end
  kgui:saveState()
end

function kgui:findBottom()
  local lastBottom = 0
  for _, data in pairs(kgui.ui) do
    if data.wrapper ~= nil then
      local newBottom = data.wrapper:get_y() + data.wrapper:get_height()
      if lastBottom == 0 then lastBottom = newBottom end
      if lastBottom ~= 0 and lastBottom < newBottom then
        lastBottom = newBottom
      end
    end
  end
  local winHeight = kgui.main.container.height
  if lastBottom + 20 > winHeight then
    lastBottom = winHeight - 20
  end
  return lastBottom
end

function kgui:findOrder()
  local order = 0
end

--
-- Przeciaganie glownego kontenera
--

function kgui:onHDragTimer()
  local x
  local y
  x, y = getMousePosition()
  kgui.main:move(x, 0)
  kgui.main:resize('100%-' .. (kgui.main.get_x()+20) .. 'px' ,'100%')
end

function kgui:onHDragClick()
  if exists("kguiHdragTimer", "timer") == 0 then
    vdragtimer = permTimer("kguiHdragTimer", "", .016, [[ kgui:onHDragTimer() ]])
  end
  enableTimer("kguiHdragTimer")
end

function kgui:onHDragRelease()
  disableTimer("kguiHdragTimer")
  kgui.uiState.main.width = kgui.main.get_width()
  kgui:saveState()
end

--
-- Uproszczone przesylanie tekstu do okienek
--

function kgui:toWindow(name, title, content)
  kgui.boxes = kgui.boxes or {}
  if kgui.boxes[name] == nil then
    kgui.boxes[name] = kgui:addBox(name, 0, title, 99, function() kgui.boxes[name]:hide() end)
  end
  kgui.boxes[name]:show()
  kgui:setBoxContent(name, content)
end