module("kinstall/gui", package.seeall)
setfenv(1, getfenv(2))

kgui = kgui or {}
kgui.ui = {}
kgui.settingsFile = getMudletHomeDir() .. '/kguiSettings.json'
kgui.uiState = kinstall:loadJsonFile(kgui.settingsFile)
kgui.resizingEventHandler = kgui.resizingEventHandler or nil
kgui.resizingFinishEventHandler = kgui.resizingFinishEventHandler or nil
kgui.resizedElement = nil
kgui.resizingUpdateTimer = nil
kgui.vRightDragTimer = kgui.vRightDragTimer or nil
kgui.vLeftDragTimer = kgui.vLeftDragTimer or nil
kgui.extraBorderBottom = kgui.extraBorderBottom or nil
kgui.extraBorderLeft = kgui.extraBorderLeft or nil

function kgui:init()
  kgui:calculateSizes()
  kgui.uiState.mainRight = kgui.uiState.mainRight or {}
  kgui.uiState.mainLeft = kgui.uiState.mainLeft or {}
  local screenWidth = getMainWindowSize()
  local widthRight = screenWidth / 3
  local widthLeft = screenWidth / 3
  local x = '-' .. widthRight .. 'px'
  if kgui.uiState.mainRight.width ~= nil then
    widthRight = (kgui.uiState.mainRight.width-20) .. 'px'
    x = -(kgui.uiState.mainRight.width) .. 'px'
  end
  if kgui.uiState.mainLeft.width ~= nil then
    widthLeft = (kgui.uiState.mainLeft.width-20) .. 'px'
  end

  kgui.mainBottom = kgui.mainBottom or
    Geyser.Container:new({
      name = "KGuiMainBottom",
      x=x,
      y=-1,
      width="100%",
      height=0,
    })

  kgui.mainRight = kgui.mainRight or
    Geyser.Container:new({
      name = "KGuiMainRight",
      x=x,
      y="0px",
      width=widthRight,
      height="100%",
    })

  kgui.mainLeft = kgui.mainLeft or
    Geyser.Container:new({
      name = "KGuiMainLeft",
      x=0,
      y="0px",
      width=widthLeft,
      height="100%",
    })

  kgui.mainRightContainer = kgui.mainRightContainer or
    Geyser.Container:new({
      name = "KGuiMainRightContainer",
      x="10px",
      y="2px",
      width="100%-10px",
      height="100%-2px",
    }, kgui.mainRight)

  kgui.mainLeftContainer = kgui.mainLeftContainer or
    Geyser.Container:new({
      name = "KGuiMainLeftContainer",
      x="2px",
      y="2px",
      width="100%-20px",
      height="100%-2px",
    }, kgui.mainLeft)

  -- prawy pasek do przesuwania
  kgui.mainRightDrag = kgui.mainRightDrag or Geyser.Label:new({
    name = "KGuiMainRightDrag",
    x = "0px",
    y = "0px",
    width="10px",
    height="100%",
    message=""
  }, kgui.mainRight)
  kgui.mainRightDrag:setStyleSheet([[
    QLabel { background-color: rgba(0,0,0,0%) }
    QLabel::hover {background-color: rgba(60,60,60,100%) }
  ]])
  kgui.mainRightDrag:setCursor("ResizeHorizontal")
  setLabelClickCallback("KGuiMainRightDrag", 'kgui:onRightHDragClick')
  setLabelReleaseCallback("KGuiMainRightDrag", 'kgui:onRightHDragRelease')

  -- pasek do przesuwania
  kgui.mainLeftDrag = kgui.mainLeftDrag or Geyser.Label:new({
    name = "KGuiMainLeftDrag",
    x = "100%-10px",
    y = "0px",
    width="10px",
    height="100%",
    message=""
  }, kgui.mainLeft)
  kgui.mainLeftDrag:setStyleSheet([[
    QLabel { background-color: rgba(0,0,0,0%) }
    QLabel::hover {background-color: rgba(60,60,60,100%) }
  ]])
  kgui.mainLeftDrag:setCursor("ResizeHorizontal")
  setLabelClickCallback("KGuiMainLeftDrag", 'kgui:onLeftHDragClick')
  setLabelReleaseCallback("KGuiMainLeftDrag", 'kgui:onLeftHDragRelease')

  kinstall:restartGmcpWatch()

  if kgui.resizingEventHandler ~= nil then killAnonymousEventHandler(kgui.resizingEventHandler) end
  kgui.resizingEventHandler = registerAnonymousEventHandler(
    'AdjustableContainerReposition',
    function(_, labelName, _, _, _, _, mouseAdjustment)
      if mouseAdjustment == true and labelName ~= nil then
        kgui.resizedElement = labelName:gsub("Wrapper", "")
        if kgui.resizingUpdateTimer == nil then
          kgui.resizingUpdateTimer = tempTimer(0.5, function()
            kgui:updateState()
            kgui:update()
            kgui.resizingUpdateTimer = nil
          end)
        end
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

function kgui:addBox(name, height, title, commandName)
  kgui.ui[name] = {}
  kgui.uiState[name] = kgui.uiState[name] or {}
  local wrapperHeight = kgui.uiState[name].height or height
  if wrapperHeight < kgui.baseFontHeightPx + 10 then
    wrapperHeight = kgui.baseFontHeightPx + 10
  end
  local socket = kgui.uiState[name].socket or "topRight"
  local y = kgui.uiState[name].y or kgui:findBottom()
  if kgui.uiState[name].y == nil and kgui.uiState[name].socket and string.starts(kgui.uiState[name].socket, "bottom") then
    y = kgui:findTop()
  end
  local container = nil
  if socket == 'topLeft' or socket == 'bottomLeft' then
    container = kgui.mainLeftContainer
  elseif socket ~= "bottomBar" then
    container = kgui.mainRightContainer
  else
    container = kgui.mainBottom
  end

  -- tworzenie glownego kontenera boxa
  if socket ~= "bottomBar" then
    kgui.ui[name]['wrapper'] = kgui.ui[name]['wrapper'] or Adjustable2.Container:new({
      name = name .. 'Wrapper',
      titleText = "",
      x = "0px",
      y = y,
      width = "100%",
      height = wrapperHeight .. "px",
      buttonsize = 0
    },container)

    -- dostosowywanie glownego kontenera boxa
    kgui.ui[name]['wrapper'].socket = socket
    kgui.ui[name]['wrapper']:setPadding(0)
    kgui.ui[name]['wrapper']:disableAutoSave()
    kgui.ui[name]['wrapper'].windowList[name .. 'WrapperexitLabel']:hide()
    kgui.ui[name]['wrapper'].windowList[name .. 'WrapperminimizeLabel']:hide()
    kgui.ui[name]['wrapper'].windowList[name .. 'WrapperadjLabel']:setStyleSheet([[
      QLabel {
        padding: ]]..kgui.boxPadding..[[px;
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
      height=kgui.baseFontHeightPx + 2 .. "px"
    }, kgui.ui[name]['wrapper'])

    -- dostosowywanie paska okienka
    kgui.ui[name]['title']:setStyleSheet([[
      QLabel {
        qproperty-alignment: 'AlignLeft|AlignTop';
        padding-left: 2px;
        background-color: rgba(0,0,0,230);
        font-family: 'Marcellus';
        font-size: ]] .. kgui.baseFontHeight - 2 .. [[px;
        color: #eeeeee;
        border-bottom: 2px solid rgb(80,80,80);
      }
      QLabel::hover {
        background-color: rgba(80,80,80,255);
      }
    ]])
    kgui.ui[name]['title']:rawEcho(title);
    kgui.ui[name]['title']:enableClickthrough()

  else
    -- uproszczony kontener dla dolnego socketa
    kgui.ui[name]['wrapper'] = kgui.ui[name]['wrapper'] or Geyser.Container:new({
      name = name .. 'Wrapper',
      titleText = "",
      x = "0px",
      y = y,
      width = "100%",
      height = wrapperHeight .. "px"
    },container)
    kgui.ui[name]['wrapper'].socket = socket
  end

  -- przycisk zamykania
  kgui.ui[name]['close'] = kgui.ui[name]['close'] or Geyser.Label:new({
    name = name .. 'Close',
    x = "-22px",
    y = "0px",
    width="20px",
    height=kgui.baseFontHeight + 4 .. "px",
  }, kgui.ui[name]['wrapper'])

  kgui.ui[name]['close']:setStyleSheet([[
    QLabel {
      qproperty-alignment: 'AlignCenter|AlignTop';
      background-color: rgba(60,60,60,0);
      color: #aaaaaa;
      font-family: "sans-serif";
      font-size: ]] .. kgui.baseFontHeight .. [[px;
      border-radius: 10px;
    }
    QLabel::hover {
      background-color: rgba(60,60,60,255);
      color: #eeeeee;
    }
  ]])
  kgui.ui[name]['close']:setFontSize(kgui.baseFontHeight)
  kgui.ui[name]['close']:setCursor("PointingHand")
  kgui.ui[name]['close']:rawEcho("<center>×</center>")
  kgui.ui[name]['close']:setClickCallback(function()
    kinstall:runCmd('-', commandName, false)
  end)

  if socket ~= "bottomBar" then
    -- przycisk minimalizacji
    kgui.ui[name]['min'] = kgui.ui[name]['min'] or Geyser.Label:new({
      name = name .. 'Min',
      x = "-44px",
      y = "0px",
      width="20px",
      height=kgui.baseFontHeight + 4 .. "px",
    }, kgui.ui[name]['wrapper'])

    kgui.ui[name]['min']:setStyleSheet([[
      QLabel {
        qproperty-alignment: 'AlignCenter|AlignTop';
        background-color: rgba(60,60,60,0);
        color: #aaaaaa;
        font-family: "sans-serif";
        font-size: ]] .. kgui.baseFontHeight .. [[px;
        border-radius: 10px;
      }
      QLabel::hover {
        background-color: rgba(60,60,60,255);
        color: #eeeeee;
      }
    ]])
    kgui.ui[name]['min']:setFontSize(kgui.baseFontHeight)
    kgui.ui[name]['min']:setCursor("PointingHand")
    kgui.ui[name]['min']:rawEcho("<center>-</center>")
    kgui.ui[name]['min']:setClickCallback(function()
      if kgui.uiState[name].minimized == true then
        kgui:unminimize(name)
      else
        kgui:minimize(name)
      end
    end)

    -- przycisk prawo/lewo
    local labelka = "←"
    if socket == 'topLeft' or socket == 'bottomLeft' then
      labelka = "→"
    end

    kgui.ui[name]['leftright'] = kgui.ui[name]['leftright'] or Geyser.Label:new({
      name = name .. 'Leftright',
      x = "-66px",
      y = "0px",
      width="20px",
      height=kgui.baseFontHeight + 4 .. "px",
    }, kgui.ui[name]['wrapper'])

    kgui.ui[name]['leftright']:setStyleSheet([[
      QLabel {
        qproperty-alignment: 'AlignCenter|AlignTop';
        background-color: rgba(60,60,60,0);
        color: #aaaaaa;
        font-family: "sans-serif";
        font-size: ]] .. kgui.baseFontHeight .. [[px;
        border-radius: 10px;
      }
      QLabel::hover {
        background-color: rgba(60,60,60,255);
        color: #eeeeee;
      }
    ]])
    kgui.ui[name]['leftright']:setFontSize(kgui.baseFontHeight)
    kgui.ui[name]['leftright']:setCursor("PointingHand")
    kgui.ui[name]['leftright']:rawEcho("<center>" .. labelka .. "</center>")
    kgui.ui[name]['leftright']:setClickCallback(function()
      kgui:moveLeftRight(name, commandName)
    end)

    -- przycisk gora/dol
    local labelkaUpDown = "↓"
    if socket == 'bottomLeft' or socket == 'bottomRight' then
      labelkaUpDown = "↑"
    end

    kgui.ui[name]['topbottom'] = kgui.ui[name]['topbottom'] or Geyser.Label:new({
      name = name .. 'Topbottom',
      x = "-88px",
      y = "0px",
      width="20px",
      height=kgui.baseFontHeight + 4 .. "px",
    }, kgui.ui[name]['wrapper'])

    kgui.ui[name]['topbottom']:setStyleSheet([[
      QLabel {
        qproperty-alignment: 'AlignCenter|AlignTop';
        background-color: rgba(60,60,60,0);
        color: #aaaaaa;
        font-family: "sans-serif";
        font-size: ]] .. kgui.baseFontHeight .. [[px;
        border-radius: 10px;
      }
      QLabel::hover {
        background-color: rgba(60,60,60,255);
        color: #eeeeee;
      }
    ]])
    kgui.ui[name]['topbottom']:setFontSize(kgui.baseFontHeight)
    kgui.ui[name]['topbottom']:setCursor("PointingHand")
    kgui.ui[name]['topbottom']:rawEcho("<center>" .. labelkaUpDown .. "</center>")
    kgui.ui[name]['topbottom']:setClickCallback(function()
      kgui:moveTopBottom(name, commandName)
    end)
  end

  -- przycisk bottom bar
  if name == "info" then
    local labelkaBottomBar = "_"
    local labelX = "-110px"
    if socket == 'bottomBar' then
      labelkaBottomBar = "↑"
      labelX = "-44px"
    end

    kgui.ui[name]['bottombarbtn'] = kgui.ui[name]['bottombarbtn'] or Geyser.Label:new({
      name = name .. 'BottomBarBtn',
      x = labelX,
      y = "0px",
      width="20px",
      height=kgui.baseFontHeight + 4 .. "px",
    }, kgui.ui[name]['wrapper'])

    kgui.ui[name]['bottombarbtn']:setStyleSheet([[
      QLabel {
        qproperty-alignment: 'AlignCenter|AlignTop';
        background-color: rgba(60,60,60,0);
        color: #aaaaaa;
        font-family: "sans-serif";
        font-size: ]] .. kgui.baseFontHeight .. [[px;
        border-radius: 10px;
      }
      QLabel::hover {
        background-color: rgba(60,60,60,255);
        color: #eeeeee;
      }
    ]])
    kgui.ui[name]['bottombarbtn']:setFontSize(kgui.baseFontHeight)
    kgui.ui[name]['bottombarbtn']:setCursor("PointingHand")
    kgui.ui[name]['bottombarbtn']:rawEcho("<center>" .. labelkaBottomBar .. "</center>")
    kgui.ui[name]['bottombarbtn']:setClickCallback(function()
      kgui:moveToBottomBar(name, commandName)
    end)
  end
  return kgui.ui[name]['wrapper']
end

function kgui:moveLeftRight(name, commandName)
  if kgui.uiState[name] == nil then return end
  local topOrBottom = 'top'
  if kgui.uiState[name].socket and string.starts(kgui.uiState[name].socket, "bottom") then
    topOrBottom = 'bottom'
  end
  local leftOrRight = 'Left'
  if kgui.uiState[name].socket and string.ends(kgui.uiState[name].socket, "Left") then
    leftOrRight = 'Right'
  end
  kgui.ui[name]['wrapper'].socket = topOrBottom .. leftOrRight
  kgui.uiState[name].socket = kgui.ui[name]['wrapper'].socket
  kinstall:runCmd('-', commandName, true)
  kgui.updateRateLimiterTimer = nil
  kgui:update()
  tempTimer(0.2, function()
    kinstall:runCmd('+', commandName, true)
    kgui.updateRateLimiterTimer = nil
    kgui:update()
  end)
end

function kgui:moveTopBottom(name, commandName)
  if kgui.uiState[name] == nil then return end
  local topOrBottom = 'top'
  if kgui.uiState[name].socket and string.starts(kgui.uiState[name].socket, "top") then
    topOrBottom = 'bottom'
  end
  local leftOrRight = 'Right'
  if kgui.uiState[name].socket and string.ends(kgui.uiState[name].socket, "Left") then
    leftOrRight = 'Left'
  end
  kgui.ui[name]['wrapper'].socket = topOrBottom .. leftOrRight
  kgui.uiState[name].socket = kgui.ui[name]['wrapper'].socket
  kinstall:runCmd('-', commandName, true)
  kgui.updateRateLimiterTimer = nil
  kgui:update()
  tempTimer(0.2, function()
    kinstall:runCmd('+', commandName, true)
    kgui.updateRateLimiterTimer = nil
    kgui:update()
  end)
end

function kgui:moveToBottomBar(name, commandName)
  if kgui.uiState[name] == nil then return end
  local bottomOrNot = 'bottomBar'
  if kgui.uiState[name].socket == 'bottomBar' then
    bottomOrNot = 'topRight'
  end
  kgui.ui[name]['wrapper'].socket = bottomOrNot
  kgui.uiState[name].socket = bottomOrNot
  kinstall:runCmd('-', commandName, true)
  kgui.updateRateLimiterTimer = nil
  kgui:update()
  tempTimer(0.2, function()
    kinstall:runCmd('+', commandName, true)
    kgui.updateRateLimiterTimer = nil
    kgui:update()
  end)
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
    kgui.ui[name]['wrapper'].container:remove(kgui.ui[name]['wrapper'])
    kgui.uiState[name] = nil
    kgui.update()
  end
end

function kgui:newBoxContent(name, content)
  local y = kgui.baseFontHeightPx + 4 .. "px"
  local x = 2
  local padding = kgui.boxPadding
  local goesOnBottom = false
  local bg = "rgb(30,30,30)"
  local borderTop = "0px"
  if kgui.uiState[name] ~= nil and kgui.uiState[name].socket == "bottomBar" then
    x = 0
    y = 0
    padding = 5
    goesOnBottom = true
    bg="rgb(0,0,0)"
    borderTop="1px solid #555555"
  end
  kgui.ui[name]['content'] = kgui.ui[name]['content'] or Geyser.Label:new({
    name = name,
    x = x,
    y = y,
    width = "100%-"..(2*x).."px",
    height = 0,
    message = formatText(content),
  }, kgui.ui[name]['wrapper'])
  kgui.ui[name]['content']:setStyleSheet([[
    QLabel {
      background-color: ]]..bg..[[;
      border-top: ]]..borderTop..[[;
      padding-left: ]].. padding ..[[px;
      padding-right: ]].. padding ..[[px;
      qproperty-wordWrap: true;
    }
  ]])
  if goesOnBottom == true then
    kgui.ui[name]['content']:lowerAll()
  end
end

function formatText(content)
  return "<span style=\"color: #f0f0f0; font-size: " .. kgui.baseFontHeight .. "px; font-family: 'Marcellus'\">" .. content .. "</span>"
end

function kgui:setBoxContent(name, content, height)
  if kgui.ui[name] == nil then return end
  if kgui.ui[name]['content'] == nil then
    kgui:newBoxContent(name, content)
  else
    local formatted = formatText(content)
    kgui.ui[name]['content']:rawEcho(formatted)
    kgui.ui[name]['content'].message = formatted
  end
  if kgui.uiState[name] ~= nil and kgui.uiState[name].socket == "bottomBar" then
    kgui.ui[name]['content']:resize('100%', '100%')
    kgui.ui[name]['content'].contentHeight = height
  else
    kgui.ui[name]['content']:resize('100%-4px', "100%-".. kgui.baseFontHeightPx + 6 .."px")
    kgui.ui[name]['content'].contentHeight = height
  end
  kgui:update()
  return kgui.ui[name]['content']
end

function kgui:calculateBoxSize(content)
  local _, count = string.gsub(content, "<br>", "")
  local _, count2 = string.gsub(content, "<tr>", "")
  local _, count3 = string.gsub(content, "<meta>", "")
  return kgui.baseFontHeightPx * ( 1 + count + count2 + count3 )
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

function kgui:isClosed(name)
  if kgui.ui[name] and kgui.ui[name]['wrapper'] and kgui.ui[name]['wrapper'].hidden then
    return true
  end
  return false
end

function kgui:updateWrapperSize(name)
  local height = 0
  if kgui:isMinimized(name) == false then
    if kgui.ui[name]['content'] == nil then
      height = kgui.ui[name]['wrapper'].get_height()
    end
    if kgui.ui[name]['content'] ~= nil and kgui.ui[name]['content'].hidden == false then
      if kgui.ui[name]['content'].contentHeight == nil then
        height = kgui:calculateBoxSize(kgui.ui[name]['content'].message) + 4
      else
        height = kgui.ui[name]['content'].contentHeight
      end
      if kgui.uiState[name] == nil or kgui.uiState[name].socket ~= "bottomBar" then
        height = height + kgui.baseFontHeightPx * 2 + 4
      else
        height = height + 10
      end
   end
  end
  if height ~= nil then
    if height < kgui.baseFontHeight + 6 then
      height = kgui.baseFontHeight + 6
    end
    kgui.ui[name]['wrapper']:resize('100%', height)
  end
end

function kgui:updateState()
  kgui.uiState.mainRight.width = kgui.mainRight.get_width()
  kgui.uiState.mainLeft.width = kgui.mainLeft.get_width()
  for name, _ in pairs(kgui.ui) do
    if kgui.uiState[name] == nil then kgui.uiState[name] = {} end
    if kgui.ui[name].wrapper == nil then return nil end
    kgui.uiState[name].y = kgui.ui[name].wrapper.get_y()
    local minimized = kgui:isMinimized(name)
    if minimized == false then
      local height = kgui.ui[name].wrapper.get_height()
      if height > kgui.baseFontHeightPx + 10 then
        kgui.uiState[name].height = kgui.ui[name].wrapper.get_height()
      end
    end
    kgui.uiState[name].minimized = minimized
    kgui.uiState[name].socket = kgui.ui[name]['wrapper'].socket
  end
end

function kgui:saveState()
  kgui:updateState()
  kinstall:saveJsonFile(kgui.settingsFile, kgui.uiState)
end

function kgui:update()
  -- nie chcemy update czesciej niz 4 razy na sekunde
  if kgui.updateRateLimiterTimer ~= nil then return end
  kgui.updateRateLimiterTimer = tempTimer(0.25, function()
    kgui.updateRateLimiterTimer = nil
  end)

  kgui:updateBottomBar()

  -- przypisanie do jednego z rogow oraz czyszczenie jesli panel zostal zamkniety
  local topLeft = {}
  local bottomLeft = {}
  local topRight = {}
  local bottomRight = {}
  for name, data in pairs(kgui.uiState) do
    if kgui.ui[name] ~= nil and kgui.ui[name]['wrapper'] ~= nil and kgui.ui[name]['wrapper'].hidden == false then
      data['name'] = name
      if data.socket == "topLeft" then
        table.insert(topLeft, data)
      elseif data.socket == "bottomLeft" then
        table.insert(bottomLeft, data)
      elseif data.socket == "bottomRight" then
        table.insert(bottomRight, data)
      elseif data.socket ~= "bottomBar" then
        table.insert(topRight, data)
      end
    end
  end

  -- uaktualnianie lewego bordera
  if #topLeft == 0 and #bottomLeft == 0 and getBorderLeft() ~= 0 then
    tempTimer(0.2, function()
      kgui.ui.mapper.wrapper:lowerAll()
    end)
    setBorderLeft(kgui.extraBorderLeft)
  end
  if (#topLeft ~= 0 or #bottomLeft ~= 0) and getBorderLeft() ~= kgui.mainLeft.get_width() then
    if kgui.mainLeft.hidden == true then
      kgui.mainLeft:show()
      tempTimer(0.2, function()
        kgui.ui.mapper.wrapper:lowerAll()
      end)
    end
    setBorderLeft(kgui.extraBorderLeft + kgui.mainLeft.get_width())
  end

  -- obliczanie polozenia paneli
  local boxesTL = {}
  local boxesTR = {}
  local boxesBL = {}
  local boxesBR = {}
  for name, data in pairs(kgui.uiState) do
    if kgui.ui[name] ~= nil and kgui.ui[name]['wrapper'] ~= nil and kgui.ui[name]['wrapper'].hidden == false then
      local y = 0
      if data.socket == "bottomLeft" then
        y = data.y or kgui:findTop()
        table.insert(boxesBL, { ["name"] = name, ["y"] = y })
      elseif data.socket == "bottomRight" then
        y = data.y or kgui:findTop()
        table.insert(boxesBR, { ["name"] = name, ["y"] = y })
      elseif data.socket == "topLeft" then
        y = data.y or kgui:findBottom()
        table.insert(boxesTL, { ["name"] = name, ["y"] = y })
      elseif data.socket ~= "bottomBar" then
        y = data.y or kgui:findBottom()
        table.insert(boxesTR, { ["name"] = name, ["y"] = y })
      end
    end
  end
  -- sortowanie
  local sortByYAsc = function(a,b)
    local yA = a.y or 0
    local yB = b.y or 0
    return yA < yB
  end
  local sortByYDesc = function(a,b)
    local yA = a.y or 0
    local yB = b.y or 0
    return yA > yB
  end
  table.sort(boxesTL, sortByYAsc)
  table.sort(boxesTR, sortByYAsc)
  table.sort(boxesBL, sortByYDesc)
  table.sort(boxesBR, sortByYDesc)
  -- wyswietlanie
  local positionFromTop = function(boxes)
    local currentY = 0
    for _, data in pairs(boxes) do
      if data.name ~= kgui.resizedElement then
        kgui:updateWrapperSize(data.name)
        kgui.ui[data.name]['wrapper']:move(0, currentY)
      end
      if data.minimized == nil or data.minimized == false then
        currentY = currentY + 5 + kgui.ui[data.name]['wrapper']:get_height()
      else
        currentY = currentY + kgui.baseFontHeightPx + 15
      end
    end
  end
  positionFromTop(boxesTL)
  positionFromTop(boxesTR)

  local positionFromBottom = function(boxes, maxHeight)
    local currentY = maxHeight
    for _, data in pairs(boxes) do
      if data.minimized == nil or data.minimized == false then
        currentY = currentY - 2 - kgui.ui[data.name]['wrapper']:get_height()
      else
        currentY = currentY - 24
      end
      if data.name ~= kgui.resizedElement then
        kgui:updateWrapperSize(data.name)
        kgui.ui[data.name]['wrapper']:move(0, currentY)
      end
    end
  end
  positionFromBottom(boxesBL, kgui.mainLeft.get_height())
  positionFromBottom(boxesBR, kgui.mainRight.get_height())
end

function kgui:updateBottomBar()
  local _, windowHeight = getMainWindowSize()
  if kgui.uiState.info == nil
  or kgui.uiState.info.socket ~= 'bottomBar'
  or kgui.ui.info == nil
  or kgui.ui.info.content == nil
  or kgui:isClosed('info')
  then
    if kgui.mainBottom.get_height() > 0 then
      kgui.mainBottom:resize("100%", 0)
      kgui.mainBottom:move(0, windowHeight)
      kgui:updateMainContainers()
    end
    if getBorderBottom() > 0 then
      setBorderBottom(0 + kgui.extraBorderBottom)
    end
    return
  end
  kgui:updateWrapperSize('info')
  local height = kgui.ui.info.wrapper.get_height()
  if getBorderBottom() ~= height + 6 + kgui.extraBorderBottom then
    local height2 = height + math.floor(kgui.boxPadding/2)
    kgui.mainBottom:move(0, "100%-" .. (height2 + 6) .. "px")
    kgui.mainBottom:resize("100%", height2)
    kgui:updateMainContainers()
    kgui.ui.info.wrapper:move(0, 6)
    kgui.ui.info.wrapper:resize("100%", height2)
    setBorderBottom(height + 6 + kgui.extraBorderBottom)
  end
end

function kgui:updateMainContainers()
  local height = kgui.mainBottom:get_height()
  kgui.mainLeft:resize(kgui.mainLeft.get_width(), "100%-".. (height + kgui.extraBorderBottom) .. "px")
  kgui.mainRight:resize(kgui.mainRight.get_width(), "100%-".. (height + kgui.extraBorderBottom) .. "px")
end

function kgui:updateAll()
  for name in pairs(kinstall.modules) do
    if name ~= 'kinstall' then
      local func = _G[name]['doUpdate']
      if func ~= nil and type(func) == "function" then
        func()
      end
    end
  end
end

function kgui:findBottom()
  local _, windowHeight = getMainWindowSize()
  return windowHeight
end

function kgui:findTop()
  return 0
end

function kgui:setBorderBottom(val)
  kgui.extraBorderBottom = tonumber(val)
  kgui:updateBottomBar()
  kinstall:setConfig('extraBorderBottom', kgui.extraBorderBottom)
end

function kgui:setBorderLeft(val)
  kgui.extraBorderLeft = tonumber(val)
  setBorderLeft(kgui.extraBorderLeft)
  kgui:update()
  kinstall:setConfig('extraBorderLeft', kgui.extraBorderLeft)
end

--
-- Przeciaganie glownego kontenera
--

function kgui:onRightHDragTimer()
  local x, y = getMousePosition()
  local screenWidth = getMainWindowSize()
  local height = kgui.mainBottom:get_height()
  if x < 5 then 
    kgui.mainRight:move(5, 0)
    kgui.mainRight:resize('100%-' .. (kgui.mainRight.get_x() + 20) .. 'px' ,'100%-'..(height + kgui.extraBorderBottom)..'px')
    return
  end
  if x > screenWidth - 25 then 
    kgui.mainRight:move(screenWidth - 25, 0)
    kgui.mainRight:resize('0px' ,'100%-'..(height + kgui.extraBorderBottom)..'px')
    return
  end
  kgui.mainRight:move(x - 5, 0)
  kgui.mainRight:resize('100%-' .. (kgui.mainRight.get_x() + 20) .. 'px' ,'100%-'..(height + kgui.extraBorderBottom)..'px')
end

function kgui:onRightHDragClick()
  if kgui.vRightDragTimer == nil then
    kgui.vRightDragTimer = tempTimer(0.016, [[ kgui:onRightHDragTimer() ]], true)
  end
end

function kgui:onRightHDragRelease()
  if kgui.vRightDragTimer ~= nil then
    killTimer(kgui.vRightDragTimer)
    kgui.vRightDragTimer = nil
  end
  if kgui.ui.mapper and kgui.ui.mapper.wrapper then
    tempTimer(0.2, function()
      kgui.ui.mapper.wrapper:lowerAll()
    end)
  end
  kgui:update()
  kgui:saveState()
end

function kgui:onLeftHDragTimer()
  local x = getMousePosition()
  local screenWidth = getMainWindowSize()
  local height = kgui.mainBottom:get_height()
  kgui.mainLeft:move(0, 0)
  if x < 6 + kgui.extraBorderLeft then
    kgui.mainLeft:resize('10px', '100%-'..(height + kgui.extraBorderBottom)..'px')
    return
  end
  if x > screenWidth - 25 then
    kgui.mainLeft:resize(screenWidth - 25 - kgui.extraBorderLeft, '100%-'..(height + kgui.extraBorderBottom)..'px')
    return
  end
  kgui.mainLeft:resize(x + 5 - kgui.extraBorderLeft, '100%-'..(height + kgui.extraBorderBottom)..'px')
end

function kgui:onLeftHDragClick()
  if kgui.vLeftDragTimer == nil then
    kgui.vLeftDragTimer = tempTimer(0.016, [[ kgui:onLeftHDragTimer() ]], true)
  end
end

function kgui:onLeftHDragRelease()
  if kgui.vLeftDragTimer ~= nil then
    killTimer(kgui.vLeftDragTimer)
    kgui.vLeftDragTimer = nil
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
-- Obsluga zmianu rozmiaru okna
--

function kgui:handleWindowResize()
  if kgui.windowResizeEventDebounce ~= nil then killTimer(kgui.windowResizeEventDebounce) end
  kgui.windowResizeEventDebounce = tempTimer(0.2, function()
    kgui:updateAll()
    kgui.windowResizeEventDebounce = nil
  end)
end

if kgui.onWindowResize ~= nil then killAnonymousEventHandler(kgui.onWindowResize) end
kgui.onWindowResize = registerAnonymousEventHandler("", "kgui:handleWindowResize")

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

function kgui:transliterate(text)
  local utfCodes = {
    ["±"] = "ą",
    ["¶"] = "ś",
    ["Ľ"] = "ź",
    ["ˇ"] = "Ą",
    ["¦"] = "Ś",
    ["¬"] = "Ź",
  }
  local out = ""
  for i = 1, #text do
    local c = utf8.sub(text, i, i)
    local s = utfCodes[c]
    if s == nil then out = out .. c else out = out .. s end
  end
  return out
end

function kgui:calculateSizes()
  kgui.extraBorderBottom = kinstall:getConfig('extraBorderBottom')
  kgui.extraBorderLeft = kinstall:getConfig('extraBorderLeft')
  if kgui.extraBorderBottom == nil or kgui.extraBorderBottom == false or kgui.extraBorderBottom == '' then kgui.extraBorderBottom = 0 end
  if kgui.extraBorderLeft == nil or kgui.extraBorderLeft == false or kgui.extraBorderLeft == '' then kgui.extraBorderLeft = 0 end
  local storedFontSize = kinstall:getConfig('fontSize')
  local _, targetPixelHeight = calcFontSize(getFontSize())
  if storedFontSize ~= nil and storedFontSize ~= false and storedFontSize ~= "" and tonumber(storedFontSize) > 0 then
    _, targetPixelHeight = calcFontSize(tonumber(storedFontSize))
  end
  -- o ile chcemy zmienić wielkość czcionki w UI
  targetPixelHeight = targetPixelHeight
  local previousCandidate = 0
  local previousI = 8
  for i = 8, 50 do
    local _, candidate = calcFontSize(i, 'Marcellus')
    if candidate == targetPixelHeight then
      kgui.baseFontHeight = i
      kgui.baseFontHeightPx = candidate
      kgui.boxPadding = math.ceil(kgui.baseFontHeightPx/2)
      return
    end
    if candidate > targetPixelHeight and previousCandidate < targetPixelHeight then
      kgui.baseFontHeight = previousI
      kgui.baseFontHeightPx = previousCandidate
      kgui.boxPadding = math.ceil(kgui.baseFontHeightPx/2)
      return
    end
    previousCandidate = candidate
    previousI = i
  end
  kgui.baseFontHeight = getFontSize()
  local _, h = calcFontSize(getFontSize())
  kgui.baseFontHeightPx = h
  kgui.boxPadding = math.ceil(kgui.baseFontHeightPx/2)
end