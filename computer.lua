CD = require "computerdata"
function initComputer()
  computer = {}
  computer.objects = {}
  computer.update = function(self, dt)
    for i,v in ipairs(self.objects) do
      v:update(i, dt)
    end
  end
  computer.draw = function(self)
    for i,v in ipairs(self.objects) do
      v:draw()
    end
  end
end