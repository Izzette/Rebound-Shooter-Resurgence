function initLevels()
  levels = {}
  levels.backgrounds = {{filename = "/images/spiral.jpg", levelname = "levelone"}}
  levels.loadLevel = function(self, levelname)
    if "levelone" == levelname then
      local level = {}
      level.objects = {}
      for i,v in ipairs(self.backgrounds) do
        if levelname == v.levelname then
          level.background = love.graphics.newImage(v.filename)
        end
      end
      local obj = {}
      obj.update = function(self, i, dt)
        if 1.5 < cTime then
          play = false
          manager.internal = true
          manager.sender = "Scooty:"
          manager.photo = "/images/scooty.jpg"
          manager.message = "Captain, we are receiving data that we are inevitably heading into a very large asteroid field.  Use the 'aswd' keys to control the craft.  Hold the space bar to power up the shield and protect the ship."
          gui:setState("incmessage")
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.update = function(self, i, dt)
        if 2.5 < cTime then
          for i = 6,50 do
            local randomx = math.random(-10, 10)
            local randomy = math.random(-750, -50)
            local rock = addEntity("rock", math.floor(i * 8) + randomx, randomy, -2)
            table.insert(computer.objects, rock)
          end
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.time = -1
      obj.number = 0
      obj.update = function(self, i, dt)
        if #computer.objects == 0 and 1 == i then
          self.time = self.time + dt
          self.update = function(self, i, dt)
            self.time = self.time + dt
            if 1 <= self.time then
              local square = addEntity("square", 75, 25)
              table.insert(computer.objects, square)
              self.time = 0
              self.number = self.number + 1
              if 5 <= self.number then
                table.remove(manager.objects, i)
              end
            end
          end
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.time = 0
      obj.update = function(self, i, dt)
        if nil ~= computer.objects[1] and "square" == computer.objects[1].entityname and 2 == i then
          self.time = self.time + dt
          if 2 <= self.time then
            play = false
            manager.internal = true
            manager.sender = "Dr. Octogon:"
            manager.photo = "/images/octo.jpg"
            manager.message = "Captain, the pirates bullets have a unique signature.  I believe that you might be able to use the shield to catch them.  Then, using the 'j' key, you should be able to fire back."
            gui:setState("incmessage")
            table.remove(manager.objects, i)
          end
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.time = 0
      obj.update = function(self, i, dt)
        if #computer.objects == 0 and 1 == i then
          self.time = self.time + dt
          self.update = function(self, i, dt)
            self.time = self.time + dt
            if 2 <= self.time then
              play = false
              manager.internal = false
              manager.sender = "Comander Iscocolis:"
              manager.photo = "/images/tri.jpg"
              manager.message = "Cargo Transport 0420, it is of vital importance that I speak with your Captain immediately!!"
              gui:setState("incmessage")
              table.remove(manager.objects, i)
            end
          end
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.update = function(self, i, dt)
        if 1 == i then
          self.update = function(self, i, dt)
            if play then
              play = false
              manager.internal = false
              manager.sender = "Commander Iscosceles:"
              manager.photo = "/images/tri.jpg"
              manager.message = "I see ... I am speaking to the Captain.  Those ships you encountered earlier were not pirates.  Those were Westerners, humanity's ancient alien nemesis."
              gui:setState("rcvmessage")
              table.remove(manager.objects, i)
            end
          end
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.update = function(self, i, dt)
        if 1 == i then
          self.update = function(self, i, dt)
            if play then
              play = false
              manager.internal = false
              manager.sender = "Comander Iscocolis:"
              manager.photo = "/images/tri.jpg"
              manager.message = "We need you to report to us immediately so we can learn how and why they're here.  You can find our base in the center of the Lemon Crack Cluster.  Please hurry!"
              gui:setState("rcvmessage")
              table.remove(manager.objects, i)
            end
          end
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.time = 0
      obj.update = function(self, i, dt)
        if 1 == i and play then
          gui:setState("levelcomp")
          play = false
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.update = function(self, i, dt)
        if nil ~= player.objects.shield and 0 >= player.objects.shield.hp then
          play = false
          manager.internal = true
          manager.sender = "Scooty:"
          manager.photo = "/images/scooty.jpg"
          manager.message = "Try not to run the shield down to zero charge.  The engines can't handle it, Captain.  If you do we will need to shut down the shield for a little bit to protect the engines.  If we had more crystals, this wouldn't be such a problem."
          gui:setState("incmessage")
          table.remove(manager.objects, i)
        end
      end
      table.insert(level.objects, obj)
      obj = {}
      obj.time = 0
      obj.update = function(self, i, dt)
        if 0 >= player.objects.ship.life then
          gui:setState("gameover")
          self.time = self.time + dt
          self.update = function(self, i, dt)
            self.time = self.time + dt
            if 2 <= self.time then
              play = false
              table.remove(manager.objects, i)
            end
          end
        end
      end
      table.insert(level.objects, obj)
      return level
    end
  end
end