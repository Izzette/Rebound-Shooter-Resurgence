function refShip(var)
  local ref = {}
  if var == nil then -- if no parameter is used
    ref.hp = 100  -- hp is 100
    ref.shape = collider:addPolygon(225, 475, 215, 505, 235, 505)  -- icosolis triangle, 30 high, 20 wide
    ref.update = function(self, dt)  -- called every frame, this one is just the on spawn function
      collider:addToGroup("player", self.shape)  -- add to player
      collider:setPassive(self.shape) -- active collison detection is programed into this object in the update function
      for i,v in ipairs(computer.objects) do  -- ^^ here it is ^^
        if self:collidesWith(v.shape) then  -- called when collides with other shape, that shape's object is passed
          v:onCollide(self) -- call other collision
          v.hp = 0  -- set obj.hp to zero, will be removed when obj.update next called
        end
      end
      local ship = refShip("update[2]")  -- redefine ship.update
      self.update = ship
    end
    ref.move = function(self, dir, dt)  -- move function
      self.x, self.y = self.shape:center()  -- find center
      if self.x > 10 and dir == "left" then  -- left, world borders
        self.shape:move(-150 * dt, 0)
      elseif self.x < 440 and dir == "right" then  -- right, world borders
        self.shape:move(150 * dt, 0)
      end
      if self.y > 100 and dir == "up" then  -- up
        self.shape:move(0, -150 * dt)
      elseif self.y < 535 and dir == "down" then  -- down
        self.shape:move(0, 150 * dt)
      end
    end
    ref.draw = function(self)
      love.graphics.setColor(10, 255, 0)  -- lime green
      self.shape:draw("fill")  -- ship
      love.graphics.setColor(0, 245, 10)  -- deep green
      love.graphics.rectangle("fill", 15, 15, self.hp, 20) -- HP bar
    end
    ref.keypressed = function(self, key) end
  elseif var == "update[2]" then
    ref = function(self, dt) -- will be update function
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
        self.draw = function(self) end  -- stop drawing
        self.time = cTime + 2  -- set respawn time
        table.remove(player.life, #player.life) -- remove a life
        if #player.life <= 0 then  -- if that was the last life
          table.remove(player.objects, ship)  -- remove ship
          -- include removal of computer objects, and bring to main menu
        else
          local ship = refShip("update[3]")  -- redefine ship.update to the death and respawn phase
          self.update = ship
        end
      end
    end
  elseif var == "update[3]" then
    ref = function(self, dt)  -- after death update phase
      if cTime >= self.time then  -- when spawn time is reached
        self.time = nil -- don't need that variable anymore
        local shield = refShield()
        player.objects.shield = shield  -- recreate shield
        local ship = refShip()  -- recreate player from master copy
        self = ship
      end
    end
  end
  return ref
end
function refShield(var)
  local ref = {}
  if var == nil then
    ref.hp = 100  -- hp is 100
    ref.shape = collider:addCircle(225, 492, 25) -- circle with radius of 25
    ref.bullets = {} -- bullets directory
    ref.update = function(self, dt)  -- on spawn update function
      collider:setPassive(self.shape)  -- turn off active collison checks with the collider
      collider:addToGroup("player", self.shape) -- add to group "player" ship and shield will not collide
      if love.keyboard.isDown(" ") then
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
      end
      local shield = refShield("update[2]")  -- redefine update
      self.update = shield
    end
    ref.move = function(self, dir, dt)  -- move function
      self.x, self.y = self.shape:center()  -- find center
      if self.x > 10 and dir == "left" then  -- left, world borders
        self.shape:move(-150 * dt, 0) -- move self
        for i,v in ipairs(self.bullets) do  -- move bullets
          v.shape:move(-100 * dt, 0)
        end
      elseif self.x < 440 and dir == "right" then  -- right, world borders
        self.shape:move(150 * dt, 0)
        for i,v in ipairs(self.bullets) do
          v.shape:move(100 * dt, 0)
        end
      end
      if self.y > 100 and dir == "up" then  -- up
        self.shape:move(0, -150 * dt)
        for i,v in ipairs(self.bullets) do
          v.shape:move(0, -100 * dt)
        end
      elseif self.y < 535 and dir == "down" then  -- down
        self.shape:move(0, 150 * dt)
        for i,v in ipairs(self.bullets) do
          v.shape:move(0, 100 * dt)
        end
      end
      for i,v in ipairs(self.bullets) do  -- independant movement
        v:move(dt)
      end
      self.x, self.y = self.shape:center() -- update center
    end
    ref.draw = function(self)
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
    ref.keypressed = function(self, key)
      if key == "j" then
        -- create bullet --
        table.remove(self.bullets, 1)
      end
    end
  elseif var == "update[2]" then  -- second update phase, main phase
    ref = function(self, dt)
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
      if self.hp <= 0 then  -- upon full drain
        local shield = refShield("draw[2]")  -- redefine draw function
        self.draw = shield
        self.keypressed = function(self, key) end
        shield = refShield("update[3]")  -- third recharge update phase
        self.update = shield
      end
    end
  elseif var == "update[3]" then -- full drain then recharge update phase
    ref = function(self, dt)
      self.hp = self.hp + (15 * dt)  -- recharge slowly
      if self.hp >= 50 then  -- when halfway
        if love.keyboard.isDown(" ") then
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
        end
        local shield = refShield()  -- call sheild data
        self.draw = shield.draw  -- restart draw
        self.keypressed = shield.keypressed  -- restart keypressed
        shield = refShield("update[2]")  -- back to main update phase
        self.update = shield
      end
    end
  elseif var == "draw[2]" then  -- recharge draw phase
    ref = function(self)
      love.graphics.setColor(0, 0, 255)  -- blue
      love.graphics.rectangle("fill", 15, 50, self.hp, 20) -- shield charge bar
      local opacity = 255 - (5 * self.hp)  -- opacity calculation
      love.graphics.setColor(255, 0, 0, opacity)  -- set color to translucent ret
      love.graphics.print("Recharge!", self.x - 30, self.y + 30)  -- print recharge bellow shield
    end
  end
  return ref
end
