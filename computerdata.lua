function addEntity(entityname, x, y, sizemod)
  if "rock" == entityname then
    local rock = {x = x, y = y, entityname = entityname}
    math.randomseed(x + y + math.random(9000) + love.timer.getTime() + cTime + love.mouse.getX() + love.mouse.getY())
    local size = math.random(5, 25)
    if sizemod ~= nil then
      size = size + sizemod
    end
    rock.size = size
    rock.hp = size
    rock.speed = {x = math.random(-10, 10), y = math.random(50, 200)}
    rock.rotate = math.random() - 0.5
    rock.update = function(self, i, dt)
      HC:setPassive(self.shape)
      self.update = function(self, i, dt)
        self.x, self.y = self.shape:center()
        self.shape:move(self.speed.x * dt, self.speed.y * dt)
        self.shape:rotate(self.rotate * dt)
        self.x, self.y = self.shape:center()
        if self.x < 0 - (2 * self.size) or self.x > 450 + (2 * self.size) or self.y > 550 + (2 * self.size) or 0 >= self.hp then
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
  if "square" == entityname then
    local square = {x = x, y = y, entityname = entityname}
    square.hp = 20
    square.shape = HC:addRectangle(x - 15, y - 15, 30, 30)
    square.time = -0.5
    square.speed = {x = 100, y = 0}
    square.update = function(self, i, dt)
      HC:setPassive(self.shape)
      self.update = function(self, i, dt)
        self.shape:move(self.speed.x * dt, self.speed.y * dt)
        self.x, self.y = self.shape:center()
        if 475 < self.x then
          self.shape:moveTo(475, self.y + 60)
          self.speed.x = -self.speed.x
        elseif -25 > self.x then
          self.shape:moveTo(-25, self.y + 60)
          self.speed.x = -self.speed.x
        end
        self.time = self.time + dt
        if 0.5 <= self.time then
          local bullet = addEntity("bullet", self.x, self.y + 20)
          table.insert(computer.objects, bullet)
          self.time = 0
        end
        if 565 < self.y  or 0 >= self.hp then
          table.remove(computer.objects, i)
        end
      end
    end
    square.draw = function(self)
      love.graphics.setColor(255, 0, 0, 255)
      self.shape:draw("fill")
    end
    square.onCollide = function(self, obj)
      obj.hp = obj.hp - self.hp
    end
    return square
  end
  if "bullet" == entityname then
    local bullet = {x = x, y = y, entityname = entityname}
    bullet.hp = 10
    bullet.shape = HC:addRectangle(x - 2, y - 4, 4, 8)
    bullet.speed = {x = 0, y = 200, entityname = entityname}
    bullet.updateLib = {{},{}}
    bullet.updateLib[1] = function(self, i, dt)
      HC:setPassive(self.shape)
      self.update = self.updateLib[2]
    end
    bullet.updateLib[2] = function(self, i, dt)
      self.shape:move(self.speed.x * dt, self.speed.y * dt)
      self.x, self.y = self.shape:center()
      if 554 < self.y or 0 >= self.hp then
        table.remove(computer.objects, i)
      end
    end
    bullet.update = bullet.updateLib[1]
    bullet.draw = function(self)
      love.graphics.setColor(255, 255, 255, 255)
      self.shape:draw("fill")
    end
    bullet.onCollide = function(self, obj)
      obj.hp = obj.hp - self.hp
      if player.objects.shield == obj and 10 > #player.objects.bullets.objects then
        local round = refRound(self.x, self.y)
        table.insert(player.objects.bullets.objects, round)
      end
    end
    return bullet
  end
  if "shot" == entityname then
    local shot = {x = x, y = y, entityname = entityname}
    shot.hp = 10
    shot.shape = HC:addRectangle(x - 2, y - 4, 4, 8)
    shot.speed = {x = 0, y = -200, entityname = entityname}
    shot.updateLib = {{},{}}
    shot.updateLib[1] = function(self, i, dt)
      HC:setPassive(self.shape)
      self.update = self.updateLib[2]
    end
    shot.updateLib[2] = function(self, i, dt)
      self.shape:move(self.speed.x * dt, self.speed.y * dt)
      self.x, self.y = self.shape:center()
      for i,v in ipairs(computer.objects) do
        if self.shape:collidesWith(v.shape) and "shot" ~= v.entityname and "bullet" ~= v.entityname then  -- active collison detection, that shape's object is passed
          local dmg = self.hp
          v:onCollide(self)  -- calls other objects collison method
          v.hp = v.hp - dmg -- set obj.hp to zero, will be removed when obj.update next called
        end
      end
      if -4 > self.y or 0 >= self.hp then
        table.remove(computer.objects, i)
      end
    end
    shot.update = shot.updateLib[1]
    shot.draw = function(self)
      love.graphics.setColor(255, 255, 255, 255)
      self.shape:draw("fill")
    end
    shot.onCollide = function(self, obj)
      obj.hp = obj.hp - self.hp
      if player.objects.shield == obj then
        local round = refRound(self.x, self.y)
        table.insert(player.objects.bullets.objects, round)
      end
    end
    return shot
  end
end