function refPlayer()
  local ref = {}
  ref.hp = 100  -- hp is 100
  ref.shape = collider:addPolygon(225, 475, 215, 505, 235, 505)    -- icosolis triangle, 30 high, 20 wide
  ref.update = function(self, dt)
    self.x, self.y = self.shape:center()  -- find center
    if self.x > 10 and love.keyboard.isDown("a") then  -- left, world borders
      self.shape:move(-150 * dt, 0)
    elseif self.x < 440 and love.keyboard.isDown("d") then  -- right, world borders
      self.shape:move(150 * dt, 0)
    end
    if self.y > 45 and love.keyboard.isDown("w") then  -- up
      self.shape:move(0, -150 * dt)
    elseif self.y < 535 and love.keyboard.isDown("s") then  -- down
      self.shape:move(0, 150 * dt)
    end
    if self.hp <= 0 then  -- on death
      self.shape = nil  -- remove shape
      self.draw = function(self) end  -- stop drawing, prevent error for nil shape
      self.keypressed = function(self, key) end -- stop keypress, spawn sheild
      self.time = cTime + 2  -- set respawn time
      table.remove(player.life, #player.life) -- remove a life
      if #player.life <= 0 then  -- if that was the last life
        table.remove(player.objects, ship)  -- remove ship
        -- include removal of computer objects, and bring to main menu
      end
      self.update = function(self, dt)  -- redefine update
        if cTime >= self.time then  -- when spawn time is reached
          local ref = refPlayer()  -- recreate player from master copy
          self = ref
        end
      end
    end
  end
  ref.draw = function(self)
    love.graphics.setColor(10, 255, 0)  -- lime green
    self.shape:draw("fill")  -- ship
    love.graphics.setColor(0, 245, 10)  -- deep green
    love.graphics.rectangle("fill", 15, 15, self.hp, 20) -- HP bar
  end
  ref.keypressed = function(self, key) end
  ref.onCollide = function(self, obj)
    obj.hp = 0
  end
  return ref
end