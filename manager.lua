LV = require "levels"
function initManager()
  manager = {}
  manager.objects = {}
  manager.update = function(self, dt)
    for i,v in ipairs(self.objects) do
      v:update(i, dt)
    end
  end
  manager.initLevel = function(self, levelname)
    local level = levels:loadLevel(levelname)
    self.objects = level.objects
    self.background = level.background
  end
end