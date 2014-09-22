function loadGraphics()  -- load graphics
  graphics = {}
  graphics.objects = {}
  graphics.draw = function(self)
    for i,v in ipairs(self.objects) do
      v:draw()
    end
  end
  graphics.hover = function(self)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    for i,v in ipairs(self.objects) do
      v:hover(x, y)
    end
  emd
  graphics.mousepressed = function(self, x, y, key)
    for i,v in ipairs(self.objects) do
      v:mousepressed(x, y, key)
    end
  end
  graphics.setGraphics = function(self, str)
      if str == "game" then
        self.objects = {}
        local obj = {}
        obj.image = love.graphics.newImage("spiral.jpg")
        obj.draw = function(self)
          love.graphics.draw(self.image, 0, 0)
          love.graphics.setColor(0, 0, 0, 50)
          love.graphics.rectangle("fill", 0, 0, 450, 550)
        end
        obj.hover = function(self, x, y) end
        obj.mousepressed = function(self, x, y, key) end
        table.insert(self.objects, obj)
      elseif str == "pause" then
        local pause = {}
        pause.id = "pause"
        pause.objects = {}
        pause.draw = function(self)
          love.graphics.setColor(0, 0, 0, 200)
          love.graphics.rectangle("fill", 125, 125, 200, 300)
          for i,v in ipairs(self.objects) do
            v:draw()
          end
        end
        pause.hover = function(self, x, y)
          for i,v in ipairs(self.objects) do
            v:hover(x, y)
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
        local obj = self:addButton("Resume", 175, 165, 2, 100, 0, 0, 255, 200, action)
        table.insert(pause.objects, obj)
        action = function(self)
          graphics:setGraphics("toMain")
          for i,v in ipairs(graphics.objects) do
            if v.id ~= nil and v.id == "pause" then
              v = nil
              break
            end
          end
        end
        obj = self:addButton("Mainmenu", 175, 215, 2, 100, 0, 0, 255, 200, action)
        table.insert(pause.objects, obj)
        action = function(self)
          graphics:setGraphics("toQuit")
          for i,v in ipairs(graphics.objects) do
            if v.id ~= nil and v.id == "pause" then
              v = nil
              break
            end
          end
        end
        obj = self:addButton("Exit Game", 175, 265, 2, 100, 0, 0, 255, 200, action)
        table.insert(pause.objects, obj)
        table.insert(self.objects, pause)
      elseif str == "mainmenu" then
        self.objects = {}
        local mainmenu = {}
        mainmenu.objects = {}
        mainmenu.draw = function(self)
          love.graphics.setColor(0, 0, 0)
          love.graphics.rectangle("fill", 0, 0, 450, 550)
          love.graphics.setColor(0, 255, 0)
          love.graphics.printf("Rebound Shooter: Resurgence", 50, 100, 350, "center", 5, 5)
          for i,v in ipairs(self.objects) do
            v:draw()
          end
        end
        mainmenu.hover = function(self, x, y)
          for i,v in ipairs(self.objects) do
            v:hover(x, y)
          end
        end
        mainmenu.mousepressed = function(self, x, y, key)
          for i,v in ipairs(self.objects) do
            v:mousepressed(x, y, key)
          end
        end
        local action = function(self)
          play = true
          graphics:setGraphics("game")
        end
        obj = self:addButton("Play", 150, 300, 3, 150, 0, 0, 255, 200, action)
        table.insert(mainmenu.objects, obj)
        action = function(self)
          -- graphics:setGraphics("credits")
        end
        obj = self:addButton("Credits", 150, 375, 3, 150, 0, 0, 255, 200, action)
        table.insert(mainmenu.objects, obj)
        action = function(self)
          love.event.quit()
        end
        obj = self:addButton("Exit Game", 150, 450, 3, 150, 0, 0, 255, 200, action)
        table.insert(mainmenu.objects, obj)
        table.insert(self.objects, mainmenu)
      elseif str == "toMain" then
        local toMain = {}
        toMain.id = "toMain"
        toMain.objects = {}
        toMain.draw = function(self)
          love.graphics.setColor(0, 0, 0, 200)
          love.graphics.rectangle("fill", 125, 125, 200, 300)
          love.graphics.setColor(0, 255, 0)
          love.graphics.printf("Progress will be Lost", 150, 175, 100, "center", 3, 3)
          for i,v in ipairs(self.objects) do
            v:draw()
          end
        end
        toMain.hover = function(self, x, y)
          for i,v in ipairs(self.objects) do
            v:hover(x, y)
          end
        end
        toMain.mousepressed = function(self, x, y, key)
          for i,v in ipairs(self.objects) do
            v:mousepressed(x, y, key)
          end
        end
        local action = function(self)
          graphics:setGraphics("pause")
          for i,v in ipairs(graphics.objects) do
            if v.id ~= nil and v.id == "toMain" then
              v = nil
              break
            end
          end
        end
        local obj = self:addButton("Cancel", 150, 395, 2, 75, 255, 255, 255, 200, action)
        table.insert(toMain.objects, obj)
        action = function(self)
          player.objects = {}
          computer.objects = {}
          graphics:setGraphics("mainmenu")
        end
        obj = self:addButton("Ok", 225, 2, 75, 255, 0, 0, 200, action)
        table.insert(toMain.objects, obj)
        table.insert(graphics.objects, toMain)
      end
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
    obj.draw = function(self)
      love.graphics.setColor(self.green, self.green, self.blue, self.opacity)
      love.graphics.printf(self.string, self.x, self.y, self.width, "center", self.size, self.size)
    end
    obj.hover = function(self, x, y)
      if x > self.x and x < self.x + (self.size * 10) and y > self.y and y < self.y + width then
        self.draw = function(self)
          love.graphics.setColor(self.red, self.green, self.blue, 255)
          love.graphics.printf(self.string, self.x, self.y, 100, "center", 2, 2)
        end
        self.hover = function(self, x, y)
          if x < self.x or x > self.x + 25 or y < self.y or y > self.y + 100 then
            self = graphics:addButton(self.string, self.x, self.y, self.size, self.width, self.red, self.green, self.blue, self.opacity, self.mousepressed)
          end
        end
      end
    end
    obj.mousepressed = function(self, x, y, key)
      if x > self.x and x < self.x + (self.size * 10) and y > self.y and y < self.y + width and key = "l" then
        self:action()
      end
    end
    return obj
  end
end
