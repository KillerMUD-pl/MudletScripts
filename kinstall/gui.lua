module("kinstall/gui", package.seeall)
setfenv(1, getfenv(2));

kgui = kgui or {}
kgui.ui = {}
kgui.uiState = kinstall:loadJsonFile(getMudletHomeDir() .. '/kguiSettings.json')
kgui.resizingEventHandler = kgui.resizingEventHandler or nil
kgui.resizingFinishEventHandler = kgui.resizingFinishEventHandler or nil
kgui.resizedElement = nil
kgui.resizingUpdateTimer = nil
kgui.vDragTimer = kgui.vDragTimer or nil

--
-- TODO
--

function kgui:init()
  kgui.uiState.main = kgui.uiState.main or {}
  local width = '530px'
  local x = '-550px'
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

  kinstall:restartGmcpWatch()

  if kgui.resizingEventHandler ~= nil then killAnonymousEventHandler(kgui.resizingEventHandler) end
  kgui.resizingEventHandler = registerAnonymousEventHandler(
    'AdjustableContainerReposition',
    function(_, labelName, _, _, _, _, mouseAdjustment)
      if mouseAdjustment == true and labelName ~= nil then        
        kgui.resizedElement = labelName:gsub("Wrapper", "")
        kgui.resizingUpdateTimer = tempTimer(0.1, function()
          kgui:updateState()
          kgui:update()
        end)
      end
    end
  )
  if kgui.resizingFinishEventHandler ~= nil then killAnonymousEventHandler(kgui.resizingFinishEventHandler) end
  kgui.resizingFinishEventHandler = registerAnonymousEventHandler(
    'AdjustableContainerRepositionFinish',
    function(_, labelName)
      kgui.resizedElement = nil
      if kgui.resizingUpdateTimer ~= nil then killTimer(kgui.resizingUpdateTimer) end
      local name = labelName:gsub("Wrapper", "")
      tempTimer(0.1, function()
        kgui:saveState()
        kgui:update()
      end)
      if kgui.ui[name] ~= nil and kgui.ui[name].wrapper ~= nil then
        tempTimer(0.2, function()
          kgui.ui[name].wrapper:lowerAll()
        end)
      end
    end
  )
end

function kgui:addBox(name, height, title, closeCallback)
  kgui.ui[name] = {}
  kgui.uiState[name] = kgui.uiState[name] or {}
  local wrapperHeight = kgui.uiState[name].height or height;
  local y = kgui.uiState[name].y or kgui:findBottom()

  -- tworzenie glownego kontenera boxa
  kgui.ui[name]['wrapper'] = kgui.ui[name]['wrapper'] or Adjustable2.Container:new({
    name = name .. 'Wrapper',
    titleText = "",
    x = "0px",
    y = y,
    width = "100%",
    height = wrapperHeight .. "px",
    buttonsize = 0
  }, kgui.mainContainer)

  -- dostosowywanie glownego kontenera boxa
  kgui.ui[name]['wrapper']:setPadding(0)
  kgui.ui[name]['wrapper']:disableAutoSave()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperexitLabel']:hide()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperminimizeLabel']:hide()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperadjLabel']:setStyleSheet([[
    QLabel {
      border: 2px solid rgba(40,40,40,0);
      background-color: rgba(0,0,0,0);
    }
    QLabel::hover {
      border: 2px solid rgba(40,40,40,255);
    }
  ]])
  kgui.ui[name]['wrapper']:show()

  -- minimalizowanie tresci ktora dopiero bedzie dodana do okienka
  if kgui.uiState[name] and kgui.uiState[name].minimized == true then
    tempTimer(0, function()
      if kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name] then
        kgui:minimize(name)
      end
    end)
  end

  -- pasek okienka
  kgui.ui[name]['title'] = kgui.ui[name]['title'] or Geyser.Label:new({
    name = name .. 'Title',
    x = "2px",
    y = "2px",
    width="100%-4px",
    height="20px",
    message=title
  }, kgui.ui[name]['wrapper'])

  -- dostosowywanie paska okienka
  kgui.ui[name]['title']:setStyleSheet([[
    QLabel {
      qproperty-alignment: 'AlignLeft | AlignTop';
      padding-left: 2px;
      background-color: rgba(0,0,0,230);
      font-size: 12px;
      font-family: 'Marcellus';
      border-bottom: 2px solid rgb(80,80,80);
    }
    QLabel::hover {
      background-color: rgba(80,80,80,255);
    }
  ]])
  kgui.ui[name]['title']:enableClickthrough()

  -- przycisk zamykania
  kgui.ui[name]['close'] = kgui.ui[name]['close'] or Geyser.Label:new({
    name = name .. 'Close',
    x = "-22px",
    y = "0px",
    width="20px",
    height="20px",
    message=[[<center>×</center>]]
  }, kgui.ui[name]['wrapper'])

  -- dostosowywanie przyciski zamykania
  kgui.ui[name]['close']:setStyleSheet([[
    QLabel {
      background-color: rgba(60,60,60,0);
      color: #eeeeee;
      font-size: 12px;
      border-radius: 10px;
    }
    QLabel::hover {
      background-color: rgba(60,60,60,255);
    }
  ]])
  kgui.ui[name]['close']:setFontSize(16)
  kgui.ui[name]['close']:setCursor("PointingHand")
  kgui.ui[name]['close']:setClickCallback(closeCallback)

  -- przycisk minimlizacji
  kgui.ui[name]['min'] = kgui.ui[name]['min'] or Geyser.Label:new({
    name = name .. 'Min',
    x = "-44px",
    y = "0px",
    width="20px",
    height="20px",
    message=[[<center>-</center>]]
  }, kgui.ui[name]['wrapper'])

  kgui.ui[name]['min']:setStyleSheet([[
    QLabel {
      background-color: rgba(60,60,60,0);
      color: #eeeeee;
      font-size: 12px;
      border-radius: 10px;
    }
    QLabel::hover {
      background-color: rgba(60,60,60,255);
    }
  ]])
  kgui.ui[name]['min']:setFontSize(16)
  kgui.ui[name]['min']:setCursor("PointingHand")
  kgui.ui[name]['min']:setClickCallback(function()
    if kgui.uiState[name].minimized == true then
      kgui:unminimize(name)
    else
      kgui:minimize(name)
    end
  end)

  return kgui.ui[name]['wrapper']
end

function kgui:minimize(name)
  if kgui.uiState[name] == nil then kgui.uiState[name] = {} end
  kgui.uiState[name].minimized = true
  kgui.uiState[name].height = kgui.ui[name]['wrapper']:get_height()
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name]:hide()
  kgui:update()
  kgui:saveState()
end

function kgui:unminimize(name)
  if kgui.uiState[name] == nil then kgui.uiState[name] = {} end
  kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name]:show()
  kgui.ui[name]['wrapper']:resize('100%', kgui.uiState[name].height)
  kgui.uiState[name].minimized = false
  kgui:update()
  kgui:saveState()
end

function kgui:removeBox(name)
  if kgui.ui[name] ~= nil and kgui.ui[name]['wrapper'] ~= nil then
    kgui.ui[name]['wrapper']:hide()
    kgui.uiState[name] = nil
    kgui.update()
  end
end

function kgui:newBoxContent(name, content, wordWrap)
  kgui.ui[name]['content'] = kgui.ui[name]['content'] or Geyser.Label:new({
    name = name,
    x = 2,
    y = 20,
    width = "100%-4px",
    height = 0,
    message = formatText(content),
  }, kgui.ui[name]['wrapper'])
  if wordWrap ~= nil then wordWrap = "true" else wordWrap = "false" end
  kgui.ui[name]['content']:setStyleSheet("padding: 10px;background-color: rgba(30,30,30,230);border-bottom-radius: 4px;qproperty-wordWrap: ".. wordWrap ..";")
end

function formatText(content)
  return "<span style=\"color: #f0f0f0; font-size: " .. 13  .. "px; font-family: 'Marcellus'\">" .. content .. "</span>"
end

function kgui:setBoxContent(name, content, height)
  if kgui.ui[name] == nil then return end
  if kgui.ui[name]['content'] == nil then
    kgui:newBoxContent(name, content, height ~= nil)
  else
    local formatted = formatText(content)
    kgui.ui[name]['content']:rawEcho(formatted)
    kgui.ui[name]['content'].message = formatted
  end
  kgui.ui[name]['content']:resize('100%-4px', "100%-22px")
  kgui.ui[name]['content'].contentHeight = height
  kgui:update()
  return kgui.ui[name]['content']
end

function kgui:calculateBoxSize(name, content)
  local fontSize = kgui.ui[name]['content'].fontSize
  local _, count = string.gsub(content, "<br>", "")
  local _, count2 = string.gsub(content, "<tr>", "")
  local _, count3 = string.gsub(content, "<meta>", "")
  local _, height = calcFontSize(16)
  return height * ( 1 + count + count2 + count3 ) + 20
end

function kgui:isMinimized(name)
  if kgui.ui[name]['content'] == nil
  and kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'] ~= nil
  and kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name] ~= nil
  and kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name].hidden == true then
    return true
  else
    if kgui.ui[name]['content'] ~= nil and kgui.ui[name]['content'].hidden == true then
      return true
    end
  end
  return false
end

function kgui:updateWrapperSize(name)
  local height = 0
  if kgui:isMinimized(name) == false then
    if kgui.ui[name]['content'] == nil then
        height = kgui.ui[name]['wrapper'].windowList[name .. 'WrapperInsideContainer'].windowList[name].get_height();
    end
    if kgui.ui[name]['content'] ~= nil and kgui.ui[name]['content'].hidden == false then
      if kgui.ui[name]['content'].contentHeight == nil then
        height = kgui:calculateBoxSize(name, kgui.ui[name]['content'].message)
      else
        height = kgui.ui[name]['content'].contentHeight
      end
    end
  end
  if height ~= nil then
    kgui.ui[name]['wrapper']:resize('100%', height + 22)
  end
end

function kgui:updateState()
  kgui.uiState.main.width = kgui.main.get_width()
  for name, _ in pairs(kgui.ui) do
    if kgui.uiState[name] == nil then kgui.uiState[name] = {} end
    kgui.uiState[name].y = kgui.ui[name].wrapper.get_y()
    local minimized = kgui:isMinimized(name)
    if minimized == false then
      kgui.uiState[name].height = kgui.ui[name].wrapper.get_height()
    end
    kgui.uiState[name].minimized = minimized
  end
end
function kgui:saveState()
  kgui:updateState()
  kinstall:saveJsonFile(getMudletHomeDir() .. '/kguiSettings.json', kgui.uiState)
end

function kgui:update()
  local boxes = {}
  for name, data in pairs(kgui.uiState) do
    if kgui.ui[name] ~= nil and kgui.ui[name]['wrapper'] ~= nil and kgui.ui[name]['wrapper'].hidden == false then
      local y = data.y or kgui:findBottom()
      if kgui.ui[name] ~= nil then
        table.insert(boxes, { ["name"] = name, ["y"] = y })
      else
        kgui.uiState[name] = nil
      end
    end
  end
  table.sort(boxes, function(a,b)
    local yA = a.y or 0
    local yB = b.y or 0
    return yA < yB
  end)
  local currentY = 0
  for _, data in pairs(boxes) do
    if data.name ~= kgui.resizedElement then
      kgui:updateWrapperSize(data.name)
      kgui.ui[data.name]['wrapper']:move(0, currentY)
    end
    if data.minimized == nil or data.minimized == false then
      currentY = currentY + 10 + kgui.ui[data.name]['wrapper']:get_height()
    else
      currentY = currentY + 32
    end
  end
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
  if kgui.vDragTimer == nil then
    kgui.vDragTimer = tempTimer(0.016, [[ kgui:onHDragTimer() ]], true)
  end
end

function kgui:onHDragRelease()
  if kgui.vDragTimer ~= nil then
    killTimer(kgui.vDragTimer)
    kgui.vDragTimer = nil
  end
  if kgui.ui.mapper and kgui.ui.mapper.wrapper then
    tempTimer(0.2, function()
      kgui.ui.mapper.wrapper:lowerAll()
    end)
  end
  kgui:update()
  kgui:saveState()
end

--
-- Uproszczone przesylanie tekstu do okienek
--

function kgui:toWindow(name, title, content)
  kgui.boxes = kgui.boxes or {}
  if kgui.boxes[name] == nil then
    kgui.boxes[name] = kgui:addBox(name, 0, title, function() kgui.boxes[name]:hide() end)
  end
  kgui.boxes[name]:show()
  kgui:setBoxContent(name, content)
end