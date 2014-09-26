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
        if 1 < cTime then
          manager.internal = true
          manager.sender = "irrelevent"
          manager.photo = "spiral.jpg"
          manager.message = "irrelevent"
          gui:setState("textmessage")
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      return level
    end
  end
end