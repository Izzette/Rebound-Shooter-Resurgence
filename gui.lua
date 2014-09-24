GE = require "graphicslibrary"
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
        initPlayer()
        initComputer()
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
        endGame()
      end
      parent:addButton(50, 185, 200, 50, clickthrough)
      parent.objects[#parent.objects]:addText("Quit Game", "abduct", 16)
      parent.objects[#parent.objects].text:setColor(255, 0, 0, 255)
      table.insert(mainmenu.objects, parent)
      self.objects.mainmenu = mainmenu
    -- if "credits" == statename then
      --
    -- end
    end
    if "pausemenu" == statename then
      local pausemenu = {}
      pausemenu.objects = {}
      pausemenu.draw = function(self)
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      pausemenu.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local parent = graphics:addParent(100, 100, 250, 350)
      parent:addText("Paused", 25, 75, 200, "abduct", 18)
      parent:setTextAlign("center")
      local clickthrough = function()
        play = true
        gui.objects.pausemenu = nil
      end
      parent:addButton(25, 150, 200, 40, clickthrough)
      parent:addButtonText("Resume", "abduct", 14)
      parent:setButtonTextColor(0, 255, 0, 255)
      clickthrough = function()
        gui:setState("toMain")
        gui.objects.pausemenu = nil
      end
      parent:addButton(25, 200, 200, 40, clickthrough)
      parent:addButtonText("Mainmenu", "abduct", 14)
      parent:setButtonTextColor(0, 0, 255, 255)
      clickthrough = function()
        gui:setState("toQuit")
        gui.objects.pausemenu = nil
      end
      parent:addButton(25, 250, 200, 40, clickthrough)
      parent:addButtonText("Quit Game", "abduct", 14)
      parent:setButtonTextColor(255, 0, 0, 255)
      table.insert(pausemenu.objects, parent)
      self.objects.pausemenu = pausemenu
    end
    if "toMain" == statename then
      local toMain = {}
      toMain.objects = {}
      toMain.draw = function(self)
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      toMain.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local parent = graphics:addParent(100, 100, 250, 350)
      parent:addText("Progress Will Be Lost", 25, 75, 200, "abduct", 16)
      parent:setTextAlign("center")
      parent:addText("Are you sure?", 25, 125, 200, "abduct", 18)
      parent:setTextAlign("center")
      local clickthrough = function()
        gui:setState("pausemenu")
        gui.objects.toMain = nil
      end
      parent:addButton(20, 290, 100, 40, clickthrough)
      parent:addButtonText("Cancel", "abduct", 12)
      clickthrough = function()
        gui:setState("mainmenu")
        gui.objects.toMain = nil
      end
      parent:addButton(130, 290, 100, 40, clickthrough)
      parent:addButtonText("End Game", "abduct", 12)
      parent:setButtonTextColor(255, 0, 0)
      table.insert(toMain.objects, parent)
      self.objects.toMain = toMain
    end
    if "toQuit" == statename then
      local toQuit = {}
      toQuit.objects = {}
      toQuit.draw = function(self)
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      toQuit.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local parent = graphics:addParent(100, 100, 250, 350)
      parent:addText("Progress Will Be Lost", 25, 75, 200, "abduct", 16)
      parent:setTextAlign("center")
      parent:addText("Are you sure?", 25, 125, 200, "abduct", 18)
      parent:setTextAlign("center")
      local clickthrough = function()
        gui:setState("pausemenu")
        gui.objects.toQuit = nil
      end
      parent:addButton(20, 290, 100, 40, clickthrough)
      parent:addButtonText("Cancel", "abduct", 12)
      clickthrough = function()
        endGame()
      end
      parent:addButton(130, 290, 100, 40, clickthrough)
      parent:addButtonText("Exit Game", "abduct", 12)
      parent:setButtonTextColor(255, 0, 0)
      table.insert(toQuit.objects, parent)
      self.objects.toQuit = toQuit
    end
  end
end