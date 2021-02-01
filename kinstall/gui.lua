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
      titleText = "Przeciągnij brzegi aby zmienić pozycję",
      x="-30%",
      y="0px",
      width="29%",
      height="100%",
      adjLabelstyle="border: 1px dashed rgb(80,80,80); background-color:rgba(0,0,0,0);",
      buttonstyle=[[
        QLabel{ border-radius: 3px; background-color: rgba(140,140,140,100%);}
        QLabel::hover{ background-color: rgba(160,160,160,50%);}
      ]],
    });
  kinstall.gui.mainCointainer:show()
  --kinstall.gui.mainCointainer:lockContainer('light')

  kinstall.gui.moduleContainers.kmap = {}
  kinstall.gui.moduleContainers.kmap['wrapper'] = Adjustable.Container:new({
    name = "kmap",
    titleText = "Mapa",
    x = "0px",
    y = "0px",
    width = "100%",
    height = "300px",
    titleTxtColor="#ffffff",
    buttonFontSize = 10,
    adjLabelstyle="font-size: 14px; color: #fff; border: 1px solid rgb(80,80,80);",
    h_policy = Geyser.Fixed
  }, kinstall.gui.mainCointainer)
  kinstall.gui.moduleContainers.kmap['wrapper']:show()

  closeMapWidget();
  kinstall.gui.moduleContainers.kmap['mapper'] = Geyser.Mapper:new({
    embedded = true,
    name = "mapper",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    adjLabelstyle="padding: 0px; margin: 0px;",
  }, kinstall.gui.moduleContainers.kmap['wrapper'])
  kinstall.gui.moduleContainers.kmap['mapper']:show()
end
