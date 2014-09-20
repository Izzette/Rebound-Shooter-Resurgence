PD = require "playerdata"  -- load playerdata
HC = require "hardoncollider"  -- require hardoncollider
function loadPlayer()
  player = {}  -- create player
  player.life = {{},{},{}}  -- three lives
  player.objects = {}  -- holds all player objects
  local ref = refShip()  -- call refShip for all ship data
  player.objects.ship = ref  -- create the ship
  ref = refShield()  -- call refShield for all shield data
  player.objects.shield = ref  -- create sheild
  player.update = function(dt)  -- create update function
    if love.keyboard.isDown("a") then  -- single keyboard check is neccicary to prevent ship and sheild from slowly migrating away from each other, I think.
      player.moveH = "left"  -- horizontal
    elseif love.keyboard.isDown("d") then
      player.moveH = "right"
    end
    if love.keyboard.isDown("w") then
      player.moveV = "up"  -- vertical
    elseif love.keyboard.isDown("s") then
      player.moveV = "down"
    end
    for k,v in pairs(player.objects) do  -- update player objects, ship, sheild
      v:move(player.moveH, dt)  -- move horizontal
      v:move(player.moveV, dt)  -- move vertical
      v:update(dt)  -- call update functions
    end
    player.moveH = "not"  -- "not" is not reconized by v:move(dir, dt)
    player.moveV = "not"
  end
  player.draw = function()
    for k,v in pairs(player.objects) do  -- draw player objects
      v:draw()
    end
    for i,v in ipairs(player.life) do  -- draw lives
      local x = 450 - (20 * i)  -- x pos for each individually
      love.graphics.setColor(255, 255, 255)  -- white
      love.graphics.rectangle("fill", x, 10, 10, 10) -- small squares
    end
  end
  player.keypressed = function(key)
    for k,v in pairs(player.objects) do -- key for all player objects
      v:keypressed(key)
    end
  end
end