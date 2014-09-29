PD = require "playerdata"  -- load playerdata
HC = require "hardoncollider"  -- require hardonHC
function initPlayer()
  player = {}  -- create player
  player.objects = {}  -- holds all player objects
  local ship = refShip()  -- call refShip for all ship data
  player.objects.ship = ship  -- create the ship
  local shield = refShield()  -- call refShield for all shield data
  player.objects.shield = shield  -- create shield
  local bullets = refBullets()
  player.objects.bullets = bullets
  player.update = function(self, dt)  -- create update function
    local s = 150 * dt
    local x = 0
    local y = 0
    local ship = self.objects.ship
    if 50 < ship.x and love.keyboard.isDown("a") then
      x = -s
    elseif 400 > ship.x and love.keyboard.isDown("d") then
      x = s
    elseif 50 > ship.x then
      x = 50 - ship.x
    elseif 400 < ship.x then
      x = 400 - ship.x
    end
    if 150 < ship.y and love.keyboard.isDown("w") then
      y = -s
    elseif 500 > ship.y and love.keyboard.isDown("s") then
      y = s
    elseif 150 > ship.y then
      y = 150 - ship.y
    elseif 500 < ship.y then
      y = 500 - ship.y
    end
    for k,v in pairs(self.objects) do  -- update player objects, ship, sheild
      v.shape:move(x, y)
      v.x, v.y = v.shape:center()
      v:update(dt)  -- call update functions
    end
  end
  player.draw = function(self)
    if nil ~= self.objects.ship then
      self.objects.ship:draw()
    end
    self.objects.bullets:draw()
    if nil ~= self.objects.shield then
      self.objects.shield:draw()
    end
  end
  player.keypressed = function(self, key)
    for k,v in pairs(self.objects) do -- key for all player objects
      v:keypressed(key)
    end
  end
end