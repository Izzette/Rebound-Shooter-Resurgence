function initLevels()
  levels = {}
  levels.backgrounds = {{filename = "spiral.jpg", levelname = "testlevel"}}
  levels.loadLevel = function(self, levelname)
    if "testlevel" == levelname then
      local level = {}
      level.objects = {}
      for i,v in ipairs(self.backgrounds) do
        if levelname == v.levelname then
          level.background = love.graphics.newImage(v.filename)
        end
      end
      local obj = {}
      obj.update = function(self, i, dt)
        if 1.5 < cTime then
          play = false
          manager.internal = true
          manager.sender = "Scooty:"
          manager.photo = "spiral.jpg"
          manager.message = "Captin, we are receiving data that we are inevitably heading into a very large asteriod field.  Use the a, s, d, w keys to control the craft.  Hold the space bar to power up the shield and protect the ship."
          gui:setState("incmessage")
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.update = function(self, i, dt)
        if 2.5 < cTime then
          for i = 1, 112 do
            local randomx = math.random(-5, 5)
            local randomy = math.random(-1000, -50)
            local rock = addEntity("rock", (i * 4) + randomx, randomy)
            table.insert(computer.objects, rock)
          end
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      return level
    end
  end
end