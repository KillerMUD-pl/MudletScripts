module("kinstall/gui", package.seeall)

kinstall.gui = kinstall.gui or {}
kinstall.gui.moduleContainers = kinstall.gui.moduleContainers or {}

--
-- TODO
--

function kinstall:guiInit()
  kinstall.gui.mainCointainer = kinstall.gui.mainCointainer or
    Adjustable.Container:new({
      name = "MainContainer",
      titleText = "",
      x="-300px",
      y="0px",
      width="275px",
      height="100%",
      h_policy=Geyser.Fixed,
      adjLabelstyle="background-color:rgba(80,80,80,0%);",
    });
  kinstall.gui.mainCointainer:show()
  kinstall.gui.mainCointainer:lockContainer('light')

  kinstall.gui.moduleContainers.kmap = {}
  kinstall.gui.moduleContainers.kmap['wrapper'] = Adjustable.Container:new({
    name = "kmap",
    titleText = "Mapa",
    x = "0px",
    y = "0px",
    width = "100%",
    height = "100px",
    h_policy = Geyser.Fixed
  }, kinstall.gui.mainCointainer)

  kinstall.gui.moduleContainers.kmap['mapper'] = Geyser.Mapper:new({
    name = "mapper",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%"
  }, kinstall.gui.moduleContainers.kmap['wrapper'])
end
