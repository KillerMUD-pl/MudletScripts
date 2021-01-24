module("kinstall/gui", package.seeall)

kinstall.gui = kinstall.gui or {}
kinstall.gui.containers = {}

function kinstall:guiInit()
  kinstall.gui.mainCointainer = kinstall.gui.mainCointainer or
    Adjustable.Container:new({
      name = "HelloWorldContainer",
      titleText = "Container with a command line"
    })
end
