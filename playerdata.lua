function refShip()
  local ref = {x = 225, y = 490}
  ref.hp = 100  -- hp is 100
  ref.shape = HC:addPolygon(225, 475, 215, 505, 235, 505)  -- icosolis triangle, 30 high, 20 wide
  ref.life = 3
  ref.updateLib = {{},{},{}}
  ref.updateLib[1] = function(self, dt)  -- called every frame, this one is just the on spawn function
    HC:addToGroup("player", self.shape)  -- add to player
    HC:setPassive(self.shape) -- active collison detection is programed into this object in the update[2] function
    self.update = self.updateLib[2]  -- redefine ship.update
  end
  ref.updateLib[2] = function(self, dt)
    for i,v in ipairs(computer.objects) do
      if self.shape:collidesWith(v.shape) then  -- active collison detection, that shape's object is passed
        v:onCollide(self)  -- calls other objects collison method
        v.hp = 0  -- set obj.hp to zero, will be removed when obj.update next called
      end
    end
    if self.hp <= 0 then  -- on death
      for i,v in ipairs(player.objects.bullets.objects) do
        local shot = addEntity("shot", v.x, v.y)
        local theta = math.random() * 2 * math.pi
        shot.speed.x = math.abs(math.sin(theta) * 200)
        shot.speed.y = math.abs(math.cos(theta) * 200)
        table.remove(player.objects.bullets.objects, i)
      end
      player.objects.shield = nil  -- delete shield
      self.draw = function(self)
        for i = 1,self.life do
          local x = 435 - (20 * i)  -- x pos for each individually
          love.graphics.setColor(255, 255, 255)  -- white
          love.graphics.rectangle("fill", x, 25, 10, 10) -- small squares
        end
      end  -- stop drawing
      self.time = cTime + 2  -- set respawn time
      self.life = self.life - 1
      if self.life <= 0 then  -- if that was the last life
        for i,v in ipairs(computer.objects) do
          v = nil
        end
        play = false
        gui:setState("mainmenu")
        for k,v in pairs(player.objects) do
          v = nil
        end
      else
        local ship = self.updateLib[3]  -- redefine ship.update to the death and respawn phase
        self.update = ship
      end
    end
  end
  ref.updateLib[3] = function(self, dt)
    if cTime >= self.time then  -- when spawn time is reached
      self.time = nil -- don't need that variable anymore
      local shield = refShield()
      player.objects.shield = shield  -- recreate shield
      local ship = refShip()
      self.hp = ship.hp
      self.draw = ship.draw
      self.shape = ship.shape
      self.x, self.y = self.shape:center()
      self.update = self.updateLib[1]
    end
  end
  ref.update = ref.updateLib[1]
  ref.draw = function(self)
    love.graphics.setColor(10, 255, 0)  -- lime green
    self.shape:draw("fill")  -- ship
    love.graphics.setColor(0, 245, 10)  -- deep green
    love.graphics.rectangle("fill", 15, 15, self.hp, 20) -- HP bar
    for i = 1,self.life do
      local x = 435 - (20 * i)  -- x pos for each individually
      love.graphics.setColor(255, 255, 255)  -- white
      love.graphics.rectangle("fill", x, 25, 10, 10) -- small squares
    end
  end
  ref.keypressed = function(self, key) end
  return ref
end
function refShield()
  local ref = {x = 225, y = 492}
  ref.hp = 100  -- hp is 100
  ref.shape = HC:addCircle(225, 492, 25) -- circle with radius of 25
  ref.updateLib = {{},{},{}}
  ref.updateLib[1] = function(self, dt)  -- on spawn update function
    HC:setPassive(self.shape)  -- turn off active collison checks with the HC
    HC:addToGroup("player", self.shape) -- add to group "player" ship and shield will not collide
    self.update = self.updateLib[2]  -- redefine update
  end
  ref.updateLib[2] = function(self, dt)
    if love.keyboard.isDown(" ") and (self.hp - (40 * dt)) >= 0 then
      self.hp = self.hp - (40 * dt)
      for i,v in ipairs(computer.objects) do  -- does not call v:
        if self.shape:collidesWith(v.shape) then
          v:onCollide(self)
          v.hp = 0  -- hp to zero, will be deleted in next v.update call
        end
      end
    elseif love.keyboard.isDown(" ") and (self.hp - (40 * dt)) < 0 then
      self.hp = 0
    elseif self.hp <= (100 - (15 * dt)) then  -- if not and not within grounds of going over 100
      self.hp = self.hp + (15 * dt)  -- recharge slowly
    else  -- otherwise
      self.hp = 100  -- full charge
    end
    if self.hp <= 0 then  -- upon full drain
      self.draw = self.drawLib[2]  -- redefine draw function
      self.keypressed = function(self, key) end
      self.update = self.updateLib[3]
    end
  end
  ref.updateLib[3] = function(self, dt)
    self.hp = self.hp + (15 * dt)  -- recharge slowly
    if self.hp >= 50 then  -- when halfway
      self.draw = self.drawLib[1]  -- restart draw
      local shield = refShield()  -- call sheild data
      self.keypressed = shield.keypressed  -- restart keypressed
      self.update = self.updateLib[2]
    end
  end
  ref.update = ref.updateLib[1]
  ref.drawLib = {{},{}}
  ref.drawLib[1] = function(self)
    if love.keyboard.isDown(" ") and play then
      love.graphics.setColor(255, 255, 255)  -- white
      self.shape:draw("line")  -- circle
    end
    if self.hp >= 50 then
      love.graphics.setColor(0, 0, 255)  -- blue
    else
      local red = 255 - (5 * self.hp)
      local blue = 255 - red
      love.graphics.setColor(red, 0, blue)
    end
    love.graphics.rectangle("fill", 15, 50, self.hp, 20) -- shield charge bar
  end
  ref.drawLib[2] = function(self)
    if math.floor(cTime * 4) % 2 == 0 then
      love.graphics.setColor(255 - self.hp, 0 , self.hp, 255)
    else
      love.graphics.setColor(255 - self.hp, 0, self.hp, 50)
    end
    love.graphics.rectangle("fill", 15, 50, self.hp, 20) -- shield charge bar
    local opacity = 255 - (5 * self.hp)  -- opacity calculation
    love.graphics.setColor(255, 0, 0, opacity)  -- set color to translucent ret
    graphics:setFont("abduct", 10)
    love.graphics.printf("Recharge!", self.x - 50, self.y + 30, 100, "center")  -- print recharge bellow shield
  end
  ref.draw = ref.drawLib[1]
  ref.keypressed = function(self, key) end
  return ref
end
function refBullets()
  local ref = {x = 0, y = 0}
  ref.hp = 0
  ref.objects = {}
  ref.shape = {}
  ref.shape.move = function(self, x, y)
    for i,v in ipairs(player.objects.bullets.objects) do
      v:move(x, y)
    end
  end
  ref.shape.center = function(self)
    for i,v in ipairs(player.objects.bullets.objects) do
      return 0, 0
    end
  end
  ref.objects = {}
  ref.update = function(self, dt)
    for i,v in ipairs(self.objects) do
      v:update(i, dt)
    end
  end
  ref.draw = function(self)
    for i,v in ipairs(self.objects) do
      v:draw()
    end
  end
  ref.keypressed = function(self, key)
    if "j" == key and 1 <= #self.objects then
      local shot = addEntity("shot", player.objects.ship.x, player.objects.ship.y - 30)
      table.insert(computer.objects, shot)
      table.remove(self.objects, 1)
    end
  end
  return ref
end
function refRound(x, y)
  local ref = {}
  ref.hp = 0
  ref.x = x
  ref.y = y
  ref.velocity = {x = 0, y = 0}
  ref.move = function(self, x, y)
    self.x = self.x + x
    self.y = self.y + y
  end
  ref.update = function(self, i, dt)
    local ship = player.objects.ship
    local h = math.sqrt(((ship.x - self.x) ^ 2) + ((ship.y - self.y) ^ 2))
    if 25 < h then
      self.velocity.x = 4 * (ship.x - self.x) + math.random(-10, 10)
      self.velocity.y = 4 * (ship.y - self.y) + math.random(-10, 10)
    end
    self:move(self.velocity.x * dt , self.velocity.y * dt)
  end
  ref.draw = function(self)
    love.graphics.setColor(255, 255, 255, 200)
    love.graphics.rectangle("fill", self.x - 1, self.y - 3, 2, 6)
    love.graphics.setColor(0, 255, 255, 125)
    love.graphics.rectangle("line", self.x - 2, self.y - 4, 4, 8)
  end
  return ref
end