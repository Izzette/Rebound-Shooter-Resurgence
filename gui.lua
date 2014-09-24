GE = require "graphicsengine"
function initGui()
  initGraphics()
  graphics:newFont("abduct", "abduction/Abduction.ttf")
  gui = {}
  gui.objects = {}
  gui.draw = function(self)
    for k,v in pairs(self.objects) do
      v:draw()
    end
  end
  gui.mousepressed = function(self, x, y, key)
    for k,v in pairs(self.objects) do
      v:mousepressed(x, y, key)
    end
  end
  gui.setState = function(self, statename)
    if "mainmenu" == statename then
      local mainmenu = {}
      mainmenu.objects = {}
      mainmenu.draw = function(self)
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      mainmenu.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local title = graphics:addText("Rebound Shooter:", 25, 100, 400, "abduct", 22)
      title:setAlign("center")
      table.insert(mainmenu.objects, title)
      local subtitle = graphics:addText("Resurgence", 25, 150, 400, "abduct", 28)
      subtitle:setAlign("center")
      subtitle:setColor(0, 255, 0)
      table.insert(mainmenu.objects, subtitle)
      local parent = graphics:addParent(75, 220, 300, 280)
      local clickthrough = function()
        play = true
        cTime = 0
        loadPlayer()
        loadComputer()
        gui.objects.mainmenu = nil
      end
      parent:addButton(50, 45, 200, 50, clickthrough)
      parent.objects[#parent.objects]:addText("Play Game", "abduct", 16)
      parent.objects[#parent.objects].text:setColor(0, 255, 0, 255)
      clickthrough = function()
        -- gui:setstate("credits")
        -- gui.objects.mainmenu = nil
      end
      parent:addButton(50, 115, 200, 50, clickthrough)
      parent.objects[#parent.objects]:addText("Credits", "abduct", 16)
      parent.objects[#parent.objects].text:setColor(0, 0, 255, 255)
      clickthrough = function()
        love.event.quit()
      end
      parent:addButton(50, 185, 200, 50, clickthrough)
      parent.objects[#parent.objects]:addText("Quit Game", "abduct", 16)
      parent.objects[#parent.objects].text:setColor(255, 0, 0, 255)
      table.insert(mainmenu.objects, parent)
      self.objects.mainmenu = mainmenu
    -- elseif "credits" == statename then
      --
    -- elseif "pausemenu" == statename then
      --
    -- elseif "toMain" == statename then
     --
    -- elseif "toQuit" == statename then
      --
    end
  end
end