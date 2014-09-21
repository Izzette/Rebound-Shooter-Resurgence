function refShip()
  local ref = {}
  ref.hp = 100  -- hp is 100
  ref.shape = collider:addPolygon(225, 475, 215, 505, 235, 505)  -- icosolis triangle, 30 high, 20 wide
  ref.life = 3
  ref.updateLib = {{},{},{}}
  ref.updateLib[1] = function(self, dt)  -- called every frame, this one is just the on spawn function
    collider:addToGroup("player", self.shape)  -- add to player
    collider:setPassive(self.shape) -- active collison detection is programed into this object in the update[2] function
    self.update = self.updateLib[2]  -- redefine ship.update
  end
  ref.updateLib[2] = function(self, dt)
    for k,v in pairs(player.objects) do
      v.x, v.y = v.shape:center()
    end
    local x = 0
    local y = 0
    local s = 150 * dt
    if love.keyboard.isDown("a") then
      if self.x - s >= 20 then
        x = -s
      else
        x = 20 - self.x
      end
    elseif love.keyboard.isDown("d") then
      if self.x + s <= 430 then
        x = s
      else
        x = 430 - self.x
      end
    end
    if love.keyboard.isDown("w") then
      if self.y - s >= 100 then
        y = -s
      else
        y = 100 - self.y
      end
    elseif love.keyboard.isDown("s") then
      if self.y + s <= 530 then
        y = s
      else
        y = 530 - self.y
      end
    end
    for k,v in pairs(player.objects) do
      v.shape:move(x, y)
      v.x, v.y = v.shape:center()
    end
    for i,v in ipairs(player.objects.shield.bullets) do
      v.shape:move(2 * x / 3, 2 * y / 3)
      v.x, v.y = v.shape:center()
    end
    for i,v in ipairs(computer.objects) do
      if self:collidesWith(v.shape) then  -- active collison detection, that shape's object is passed
        v:onCollide(self)  -- calls other objects collison method
        v.hp = 0  -- set obj.hp to zero, will be removed when obj.update next called
      end
    end
    if self.hp <= 0 then  -- on death
      for i,v in ipairs(player.objects.shield.bullets) do
        -- fire randomly
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
        -- include load main menu
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
      ship.x, ship.y = ship.shape:center()
      self.moveTo(ship.x, ship.y)
      self.update = self.updateLib[2]
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
  local ref = {}
  ref.hp = 100  -- hp is 100
  ref.shape = collider:addCircle(225, 492, 25) -- circle with radius of 25
  ref.bullets = {} -- bullets directory
  ref.updateLib = {{},{},{}}
  ref.updateLib[1] = function(self, dt)  -- on spawn update function
    collider:setPassive(self.shape)  -- turn off active collison checks with the collider
    collider:addToGroup("player", self.shape) -- add to group "player" ship and shield will not collide
    self.update = self.updateLib[2]  -- redefine update
  end
  ref.updateLib[2] = function(self, dt)
    if love.keyboard.isDown(" ") and (self.hp - (40 * dt)) >= 0 then
      self.hp = self.hp - (40 * dt)
      for i,v in ipairs(computer.objects) do  -- does not call v:
        if self:collidesWith(v.shape) and v.typeN ~= nil and v.typeN == "bullet" and #self.bullets < 7 then  -- if the shield is on, the object has a name, that name is bullet, and the number of bullets is less than the capacity, seven
          local bullet = {}  -- create local bullet
          bullet.shape = v.shape  -- copy shape
          bullet.x, bullet.y = v.shape:center()  -- define position
          bullet.velocity.x = ((math.random() - 0.5) * 25) + ((ship.x - self.x) * 3)  -- random, tends towards ship
          bullet.velocity.y = ((math.random() - 0.5) * 25) + ((ship.y - self.y) * 3)
          bullet.move = function(self, dt)  -- independant move function
            self.x, self.y = self.shape:center()  -- find position
            if math.sqrt(((self.x - ship.x) ^ (2)) + ((self.y - ship.y) ^ 2)) > 25 then -- if far from ship
              self.velocity.x = ((math.random() - 0.5) * 25) + ((ship.x - self.x) * 3)  -- tend velocity twoards ship
              self.velocity.y = ((math.random() - 0.5) * 25) + ((ship.y - self.y) * 3)
            end
            self.shape:move(self.velocity.x * dt, self.velocity.y * dt)   -- move based on velocity
          end
          bullet.draw = function(self) -- draw bullet
            love.graphics.setColor(255, 255, 255, 150)  -- ghostly white
            self.shape:draw("fill")
            love.graphics.setColor(0, 255, 255, 100)  -- cyan outline
            self.shape:draw("line")
          end
          table.insert(self.bullets, bullet)  -- add bullet
          collider:setPassive(self.bullets[#self.bullets].shape) -- no need to actively check for collisions
          collider:addToGroup("player", self.bullets[#self.bullets].shape)  -- prevent collisions
        end
        v.hp = 0  -- hp to zero, will be deleted in next v.update call
      end
    elseif love.keyboard.isDown(" ") and (self.hp - (40 * dt)) < 0 then
      self.hp = 0
    elseif self.hp <= (100 - (15 * dt)) then  -- if not and not within grounds of going over 100
      self.hp = self.hp + (15 * dt)  -- recharge slowly
    else  -- otherwise
      self.hp = 100  -- full charge
      end
    for i,v in ipairs(self.bullets) do  -- independant movement
      v:move(dt)
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
    if love.keyboard.isDown(" ") then
      love.graphics.setColor(255, 255, 255)  -- white
      self.shape:draw("line")  -- circle
    end
    love.graphics.setColor(0, 0, 255)  -- blue
    love.graphics.rectangle("fill", 15, 50, self.hp, 20) -- shield charge bar
    for i,v in ipairs(self.bullets) do -- draw bullets
      v:draw()
    end
  end
  ref.drawLib[2] = function(self)
    love.graphics.setColor(0, 0, 255)  -- blue
    love.graphics.rectangle("fill", 15, 50, self.hp, 20) -- shield charge bar
    local opacity = 255 - (5 * self.hp)  -- opacity calculation
    love.graphics.setColor(255, 0, 0, opacity)  -- set color to translucent ret
    love.graphics.print("Recharge!", self.x - 30, self.y + 30)  -- print recharge bellow shield
  end
  ref.draw = ref.drawLib[1]
  ref.keypressed = function(self, key)
    if key == "j" then
      -- create bullet --
      table.remove(self.bullets, 1)
    end
  end
  return ref
end