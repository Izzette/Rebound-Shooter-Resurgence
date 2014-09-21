PD = require "playerdata"  -- load playerdata
HC = require "hardoncollider"  -- require hardoncollider
function loadPlayer()
  player = {}  -- create player
  player.objects = {}  -- holds all player objects
  local ship = refShip()  -- call refShip for all ship data
  player.objects.ship = ship  -- create the ship
  local shield = refShield()  -- call refShield for all shield data
  player.objects.shield = shield  -- create shield
  player.update = function(dt)  -- create update function
    for k,v in pairs(player.objects) do  -- update player objects, ship, sheild
      v:update(dt)  -- call update functions
    end
  end
  player.draw = function()
    for k,v in pairs(player.objects) do  -- draw player objects
      v:draw()
    end
  end
  player.keypressed = function(key)
    for k,v in pairs(player.objects) do -- key for all player objects
      v:keypressed(key)
    end
  end
end