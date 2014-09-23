function loadGraphics()  -- load graphics
  graphics = {}
  graphics.objects = {}
  graphics.draw = function(self)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    for i,v in ipairs(self.objects) do
      v:draw(x, y)
    end
  end
  graphics.mousepressed = function(self, x, y, key)
    for i,v in ipairs(self.objects) do
      v:mousepressed(x, y, key)
    end
  end
  graphics.setGraphics = function(self, str)
      if str == "mainmenu" then
        self.objects = {}
        local mainmenu = {}
        mainmenu.objects = {}
        mainmenu.draw = function(self, x, y)
          love.graphics.setColor(0, 0, 0)
          love.graphics.rectangle("fill", 0, 0, 450, 550)
          love.graphics.setColor(0, 255, 0)
          love.graphics.printf("Rebound Shooter: Resurgence", 25, 100, 400, "center", 0, 1.5, 1.5)
          for i,v in ipairs(self.objects) do
            v:draw(x, y)
          end
        end
        mainmenu.mousepressed = function(self, x, y, key)
          for i,v in ipairs(self.objects) do
            v:mousepressed(x, y, key)
          end
        end
        local action = function(self)
          play = true
          cTime = love.timer.getTime()  -- define startup time
          loadComputer()
          loadPlayer()
          graphics:setGraphics("game")
        end
        obj = self:addButton("Play", 100, 250, 3, 250, 0, 0, 255, 200, action)
        table.insert(mainmenu.objects, obj)
        action = function(self)
          -- graphics:setGraphics("credits")
        end
        obj = self:addButton("Credits", 100, 325, 3, 250, 0, 0, 255, 200, action)
        table.insert(mainmenu.objects, obj)
        action = function(self)
          love.event.quit()
        end
        obj = self:addButton("Exit Game", 100, 400, 3, 250, 0, 0, 255, 200, action)
        table.insert(mainmenu.objects, obj)
        table.insert(self.objects, mainmenu)
      elseif str == "game" then
        self.objects = {}
        local obj = {}
        obj.image = love.graphics.newImage("spiral.jpg")
        obj.draw = function(self, x, y)
          love.graphics.reset()
          love.graphics.draw(self.image, 0, 0)
          love.graphics.setColor(0, 0, 0, 50)
          love.graphics.rectangle("fill", 0, 0, 450, 550)
        end
        obj.mousepressed = function(self, x, y, key) end
        table.insert(self.objects, obj)
      elseif str == "pause" then
        graphics:setGraphics("game")
        local pause = {}
        pause.objects = {}
        pause.draw = function(self, x, y)
          love.graphics.setColor(0, 0, 0, 200)
          love.graphics.rectangle("fill", 100, 125, 250, 300)
          love.graphics.setColor(255, 255, 255, 255)
          love.graphics.printf("Pause", 125, 175, 200, "center", 0, 1.25, 1.25)
          for i,v in ipairs(self.objects) do
            v:draw(x, y)
          end
        end
        pause.mousepressed = function(self, x, y, key)
          for i,v in ipairs(self.objects) do
            v:mousepressed(x, y, key)
          end
        end
        local action = function(self)
          play = true
          graphics:setGraphics("game")
        end
        local obj = self:addButton("Resume", 125, 250, 2, 200, 0, 0, 255, 200, action)
        table.insert(pause.objects, obj)
        action = function(self)
          graphics:setGraphics("toMain")
        end
        obj = self:addButton("Mainmenu", 125, 300, 2, 200, 0, 0, 255, 200, action)
        table.insert(pause.objects, obj)
        action = function(self)
          graphics:setGraphics("toQuit")
        end
        obj = self:addButton("Exit Game", 125, 350, 2, 200, 0, 0, 255, 200, action)
        table.insert(pause.objects, obj)
        table.insert(self.objects, pause)
      elseif str == "toMain" then
        graphics:setGraphics("game")
        local toMain = {}
        toMain.objects = {}
        toMain.draw = function(self, x, y)
          love.graphics.setColor(0, 0, 0, 200)
          love.graphics.rectangle("fill", 100, 125, 200, 300)
          love.graphics.setColor(0, 255, 0)
          love.graphics.printf("Progress will be Lost", 125, 200, 200, "center", 0, 1.25, 1.25)
          for i,v in ipairs(self.objects) do
            v:draw(x, y)
          end
        end
        toMain.mousepressed = function(self, x, y, key)
          for i,v in ipairs(self.objects) do
            v:mousepressed(x, y, key)
          end
        end
        local action = function(self)
          graphics:setGraphics("pause")
        end
        local obj = self:addButton("Cancel", 125, 375, 2, 85, 255, 255, 255, 200, action)
        table.insert(toMain.objects, obj)
        action = function(self)
          player.objects = {}
          computer.objects = {}
          graphics:setGraphics("mainmenu")
        end
        obj = self:addButton("Ok", 240, 375, 2, 85, 255, 0, 0, 200, action)
        table.insert(toMain.objects, obj)
        table.insert(graphics.objects, toMain)
      elseif str == "toQuit" then
        graphics:setGraphics("game")
        local toQuit = {}
        toQuit.objects = {}
        toQuit.draw = function(self, x, y)
          love.graphics.setColor(0, 0, 0, 200)
          love.graphics.rectangle("fill", 125, 125, 200, 300)
          love.graphics.setColor(0, 255, 0)
          love.graphics.printf("Progress will be Lost", 125, 200, 200, "center", 0, 1.25, 1.25)
          for i,v in ipairs(self.objects) do
            v:draw(x, y)
          end
        end
        toQuit.mousepressed = function(self, x, y, key)
          for i,v in ipairs(self.objects) do
            v:mousepressed(x, y, key)
          end
        end
        local action = function(self)
          graphics:setGraphics("pause")
        end
        local obj = self:addButton("Cancel", 125, 375, 2, 85, 255, 255, 255, 200, action)
        table.insert(toQuit.objects, obj)
        action = function(self)
          love.event.quit()
        end
        obj = self:addButton("Ok", 240, 375, 2, 85, 255, 0, 0, 200, action)
        table.insert(toQuit.objects, obj)
        table.insert(graphics.objects, toQuit)
      end
    end
  graphics.addButton = function(self, str, x, y, size, width, r, g, b, opacity, action)
    local obj = {}
    obj.string = str
    obj.x = x
    obj.y = y
    obj.size = size
    obj.width = width
    obj.red = r
    obj.green = g
    obj.blue = b
    obj.opacity = opacity
    obj.action = action
    obj.draw = function(self, x, y)
      if x > self.x and x < self.x + self.width and y > self.y and y < self.y + (20 * self.size) then
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.rectangle("fill", self.x, self.y - (10 * self.size), self.width, (20 * self.size))
        love.graphics.setColor(self.red, self.green, self.blue, 255)
      else
        love.graphics.setColor(self.red, self.green, self.blue, self.opacity)
      end
      love.graphics.printf(self.string, self.x, self.y, self.width / ((0.125 * self.size) + 0.875), "center", 0, ((0.125 * self.size) + 0.875), ((0.125 * self.size) + 0.875))
    end
    obj.mousepressed = function(self, x, y, key)
      if x > self.x and x < self.x + self.width and y > self.y and y < self.y + (20 * self.size) and key == "l" then
        self:action()
      end
    end
    return obj
  end
end
