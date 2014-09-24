CD = require "computerdata"
function initComputer()
  computer = {}
  computer.objects = {}
  computer.update = function(dt)
    for i,v in ipairs(computer.objects) do
      v:update(dt)
    end
  end
  computer.draw = function()
    for i,v in ipairs(computer.objects) do
      v:draw()
    end
  end
end