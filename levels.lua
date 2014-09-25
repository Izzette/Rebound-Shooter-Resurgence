function loadLevel(levelname)
  if "testlevel" == levelname then
    local level = {}
    level.objects = {}
    level.background = "spiral.jpg"
    local obj = {}
    obj.update = function(self, i, dt)
      if 1 < cTime then
        local rock = addEntity("rock", 225, 0)
        table.insert(computer.objects, rock)
        table.remove(manager.objects, i)
      end
    end
    table.insert(level.objects, obj)
    return level
  end
end
function loadBackgrounds()
  local backgrounds = {}
  table.insert(backgrounds, love.graphics.newImage("spiral.jpg"))
  return backgrounds
end