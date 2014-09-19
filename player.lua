PD = require "playerdata"  -- load playerdata
HC = require "hardoncollider"  -- require hardoncollider
function loadPlayer()
  player = {}  -- create player
  player.life = {{},{},{}}  -- three lives
  player.update = function(dt)  -- create update function
    for k,v in pairs(player.objects) do  -- update player objects, ship, sheild
      v:update(dt)
    end
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
  player.objects = {}  -- holds all player objects
  local ref = refPlayer()  -- call refPlayer for all player data
  player.objects.ship = ref  -- create the ship
end