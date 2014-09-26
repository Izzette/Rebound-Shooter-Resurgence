GL = require "graphicslibrary"
LV = require "levels"
MG = require "manager"
function initGui()
  initGraphics()
  graphics:newFont("abduct", "abduction/Abduction.ttf")
  gui = {}
  gui.objects = {}
  gui.state = "main"
  gui.time = cTime
  gui.draw = function(self)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    for k,v in pairs(self.objects) do
      v:draw(x, y)
    end
  end
  gui.mousepressed = function(self, x, y, key)
    for k,v in pairs(self.objects) do
      v:mousepressed(x, y, key)
    end
  end
  gui.loadBackground = function(self, background)
    self.background = {{love.graphics.newImage(background)}}
  end
  gui.setState = function(self, statename)
    if "game" == statename then
      self.state = "game"
    end
    if "mainmenu" == statename then
      self.state = "main"
      local mainmenu = {}
      mainmenu.time = love.timer.getTime()
      mainmenu.backgrounds = levels.backgrounds
      if #mainmenu.backgrounds > 1 then
        for i = 1,2 do
          mainmenu.backgrounds[i].image = love.graphics.newImage(mainmenu.backgrounds[i].filename)
        end
      else
        mainmenu.backgrounds[1].image = love.graphics.newImage(mainmenu.backgrounds[1].filename)
      end
      mainmenu.objects = {}
      mainmenu.draw = function(self)
        local time = love.timer.getTime()
        if #self.backgrounds > 1 and time > self.time + 1.5 then
          love.graphics.setColor(255, 255, 255, (255 * (self.time - time)) + 255)
          love.graphics.draw(self.backgrounds[1], 0, 0)
          love.graphics.setColor(255, 255, 255, 255 * (time - self.time))
          if time >= self.time + 2.5 then
            self.backgrounds[1].image = nil
            table.insert(self.backgrounds, self.backgrounds[1])
            table.remove(self.backgrounds, 1)
            self.backgrounds[2].image = love.graphics.newImage(self.backgrounds[2].filename)
            self.time = time
          end
        elseif #self.backgrounds == 1 then
          love.graphics.setColor(255, 255, 255, 255)
          love.graphics.draw(self.backgrounds[1].image, 0, 0)
        end
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
        gui:setState("game")
        play = true
        cTime = 0
        initPlayer()
        initManager()
        initComputer()
        manager:initLevel("testlevel")
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
      self.state = "pause"
      local pausemenu = {}
      if self.objects.com ~= nil then
        pausemenu.com = self.objects.com
        self.objects.com = nil
      end
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
        if self.com ~= nil then
          gui.objects.com = self.com
        end
        gui.objects.pausemenu = nil
      end
      parent:addButton(25, 150, 200, 40, clickthrough)
      parent:addButtonText("Resume", "abduct", 14)
      parent:setButtonTextColor(0, 255, 0, 255)
      clickthrough = function()
        gui:setState("toMain")
        gui.objects.background = nil
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
        manager:initLevel("none")
        gui.objects.background = nil
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
    if "incmessage" == statename then
      local incmessage = {internal = manager.internal, sender = manager.sender, image = love.graphics.newImage(manager.photo), message = manager.message}
      incmessage.objects = {}
      incmessage.draw = function(self, x, y)
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      incmessage.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local string = ""
      if incmessage.internal then
        string = "Receiving INTERNAL message . . ."
      else
        string = "Receiving REMOTE message . . ."
      end
      local parent = graphics:addParent(0, 350, 450, 200)
      parent:addText(string, 0, 90, 450, "abduct", 12)  -- change to unicode when added
      parent:setTextAlign("center")
      local clickthrough = function()
        gui:setState("rcvmessage")
        gui.objects.incmessage = nil
      end
      parent:addButton(315, 150, 100, 30, clickthrough)
      parent:addButtonText("< click-mouse >", "abduct", 8)
      table.insert(incmessage.objects, parent)
      self.objects.incmessage = incmessage
    end
  end
end