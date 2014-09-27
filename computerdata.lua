function addEntity(entityname, x, y, sizemod)
  if "rock" == entityname then
    local rock = {}
    math.randomseed(x + y + math.random(9000) + love.timer.getTime() + cTime + love.mouse.getX() + love.mouse.getY())
    local size = math.random(5, 25)
    if sizemod ~= nil then
      size = size + sizemod
    end
    rock.hp = size
    rock.speed = {x = math.random(-10, 10), y = math.random(30, 200)}
    rock.rotate = math.random() - 0.5
    rock.update = function(self, i, dt)
      HC:setPassive(self.shape)
      self.update = function(self, i, dt)
        self.x, self.y = self.shape:center()
        self.shape:move(self.speed.x * dt, self.speed.y * dt)
        self.shape:rotate(self.rotate * dt)
        self.x, self.y = self.shape:center()
        if self.x < 0 or self.x > 450 or self.y > 550 or 0 >= self.hp then
          table.remove(computer.objects, i)
        end
      end
    end
    local points = {}
    local number = 5
    for i = 1,number do
      math.randomseed((math.random(1000) * i) + 1000)
      local h = math.sqrt((math.random(1, 2 * size) ^ 2) + (math.random(1, 2 * size) ^ 2))
      local theta = (2 * math.pi) * (i / number)
      local x = math.floor(math.cos(theta) * h)
      local y = math.floor(math.sin(theta) * h)
      table.insert(points, x)
      table.insert(points, y)
    end
    rock.shape = HC:addPolygon(points[1], points[2], points[3], points[4], points[5], points[6], points[7], points[8], points[9], points[10])
    rock.shape:moveTo(x, y)
    rock.x, rock.y = rock.shape:center()
    rock.draw = function(self)
      love.graphics.setColor(225, 255, 200, 255)
      self.shape:draw("fill")
      love.graphics.setColor(255, 255, 255, 255)
      self.shape:draw("line")
    end
    rock.damage = size
    rock.onCollide = function(self, obj)
      obj.hp = obj.hp - self.hp
    end
    return rock
  end
end