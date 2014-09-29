GL = require "graphicslibrary"
LV = require "levels"
MG = require "manager"
CR = require "credits"
function initGui()
  initGraphics()
  graphics:newFont("abduct", "fonts/abduction/Abduction.ttf")
  graphics:newFont("roentgen", "fonts/roentgen/RENT_0.ttf")
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
      mainmenu.draw = function(self, x, y)
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
        manager:initLevel("levelone")
        gui.objects.mainmenu = nil
      end
      parent:addButton(50, 45, 200, 50, clickthrough)
      parent.objects[#parent.objects]:addText("Play Game", "abduct", 16)
      parent.objects[#parent.objects].text:setColor(0, 255, 0, 255)
      clickthrough = function()
        gui:setState("credits")
        gui.objects.mainmenu = nil
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
    end
    if "credits" == statename then
      local credits = {}
      credits.objects = {}
      credits.draw = function(self, x, y)
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      credits.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local parent = graphics:addParent(0, 0, 450, 550)
      local height = 50
      parent:addText("Credits:", 25, height, 400, "abduct", 20)
      height = height + 50
      local text = creditsText()
      for i,v in ipairs(text) do
        parent:addText(v.string, 50, height, 350, "roentgen", v.size)
        height = height + v.height
      end
      local clickthrough = function()
        gui:setState("mainmenu")
        gui.objects.credits = nil
      end
      parent:addButton(275, 500, 150, 40, clickthrough)
      parent:addButtonText("Main Menu", "abduct", 12)
      table.insert(credits.objects, parent)
      self.objects.credits = credits
    end
    if "pausemenu" == statename then
      self.state = "pause"
      local pausemenu = {}
      if self.objects.incmessage ~= nil then
        pausemenu.incmessage = self.objects.incmessage
        self.objects.incmessage = nil
      end
      if self.objects.rcvmessage ~= nil then
        pausemenu.rcvmessage = self.objects.rcvmessage
        self.objects.incmessage = nil
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
        if self.incmessage ~= nil then
          gui.objects.incmessage = self.incmessage
        end
        if self.rcvmessage ~= nil then
          gui.objects.rcvmessage = self.rcvmessage
        end
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
        computer.objects = {}
        player.objects = {}
        manager.objects = {}
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
      local incmessage = {internal = manager.internal}
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
      local obj = {}
      obj.draw = function(self, x, y) end
      obj.mousepressed = function(self, x, y, key)
        gui:setState("rcvmessage")
        gui.objects.incmessage = nil
      end
      table.insert(incmessage.objects, obj)
      local string = ""
      if incmessage.internal then
        string = "Receiving INTERNAL message . . ."
      else
        string = "Receiving REMOTE message . . ."
      end
      local parent = graphics:addParent(0, 350, 450, 200)
      parent:addText(string, 0, 90, 450, "abduct", 12)  -- change to unicode when added
      parent:setTextAlign("center")
      parent:addText("< click-to-continue >", 310, 160, 125, "abduct", 6)
      parent:setTextAlign("center")
      table.insert(incmessage.objects, parent)
      self.objects.incmessage = incmessage
    end
    if "rcvmessage" == statename then
      local rcvmessage = {}
      rcvmessage.time = love.timer.getTime()
      rcvmessage.objects = {}
      rcvmessage.draw = function(self, x, y)
        if love.timer.getTime() > self.time + 0.1 then
          self.draw = function(self, x, y)
            for i,v in ipairs(self.objects) do
              v:draw(x, y)
            end
          end
          self.mousepressed = function(self, x, y, key)
            for i,v in ipairs(self.objects) do
              v:mousepressed(x, y, key)
            end
          end
          self.time = nil
        end
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      rcvmessage.mousepressed = function(self, x, y, key) end
      local obj = {}
      obj.draw = function(self, x, y) end
      obj.mousepressed = function(self, x, y, key)
        manager.internal = nil
        manager.sender = nil
        manager.photo = nil
        manager.message = nil
        play = true
        gui.objects.rcvmessage = nil
      end
      table.insert(rcvmessage.objects, obj)
      local parent = graphics:addParent(0, 350, 450, 200)
      parent:addImage(manager.photo, 25, 25, 0, 150)
      parent:addText(manager.sender, 170, 20, 165, "roentgen", 14)
      parent:addText(manager.message, 175, 55, 250, "roentgen", 12)
      parent:addText("< click-to-continue >", 310, 160, 125, "abduct", 6)
      parent:setTextAlign("center")
      table.insert(rcvmessage.objects, parent)
      self.objects.rcvmessage = rcvmessage
    end
    if "gameover" == statename then
      local gameover = {}
      gameover.objects = {}
      gameover.draw = function(self, x, y)
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      gameover.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local parent = graphics:addParent(100, 100, 250, 350)
      parent:addText("Game Over", 25, 50, 200, "abduct", 18)
      parent:setTextAlign("center")
      local clickthrough = function()
        computer.objects = {}
        initPlayer()
        math.randomseed(love.mouse.getX() + love.mouse.getY() + math.random(9000) + love.timer.getTime())
        manager:initLevel("levelone")
        cTime = 0
        play = true
        gui.objects.gameover = nil
      end
      parent:addButton(25, 150, 200, 40, clickthrough)
      parent:addButtonText("Play Again", "abduct", 14)
      parent:setButtonTextColor(0, 255, 0, 255)
      clickthrough = function()
        gui:setState("mainmenu")
        computer.objects = {}
        player.objects = {}
        manager.objects = {}
        gui.objects.gameover = nil
      end
      parent:addButton(25, 200, 200, 40, clickthrough)
      parent:addButtonText("Mainmenu", "abduct", 14)
      parent:setButtonTextColor(0, 0, 255, 255)
      clickthrough = function()
        endGame()
      end
      parent:addButton(25, 250, 200, 40, clickthrough)
      parent:addButtonText("Quit Game", "abduct", 14)
      parent:setButtonTextColor(255, 0, 0, 255)
      table.insert(gameover.objects, parent)
      self.objects.gameover = gameover
    end
    if "levelcomp" == statename then
      local levelcomp = {}
      levelcomp.objects = {}
      levelcomp.draw = function(self, x, y)
        for i,v in ipairs(self.objects) do
          v:draw(x, y)
        end
      end
      levelcomp.mousepressed = function(self, x, y, key)
        for i,v in ipairs(self.objects) do
          v:mousepressed(x, y, key)
        end
      end
      local parent = graphics:addParent(100, 100, 250, 350)
      parent:addText("Level Complete!", 25, 50, 200, "abduct", 18)
      parent:setTextAlign("center")
      local clickthrough = function()
        computer.objects = {}
        initPlayer()
        math.randomseed(love.mouse.getX() + love.mouse.getY() + math.random(9000) + love.timer.getTime())
        manager:initLevel("levelone")
        cTime = 0
        play = true
        gui.objects.levelcomp = nil
      end
      parent:addButton(25, 150, 200, 40, clickthrough)
      parent:addButtonText("Play Again", "abduct", 14)
      parent:setButtonTextColor(0, 255, 0, 255)
      clickthrough = function()
        gui:setState("mainmenu")
        computer.objects = {}
        player.objects = {}
        manager.objects = {}
        gui.objects.levelcomp = nil
      end
      parent:addButton(25, 200, 200, 40, clickthrough)
      parent:addButtonText("Mainmenu", "abduct", 14)
      parent:setButtonTextColor(0, 0, 255, 255)
      clickthrough = function()
        endGame()
      end
      parent:addButton(25, 250, 200, 40, clickthrough)
      parent:addButtonText("Quit Game", "abduct", 14)
      parent:setButtonTextColor(255, 0, 0, 255)
      table.insert(levelcomp.objects, parent)
      self.objects.levelcomp = levelcomp
    end
  end
end