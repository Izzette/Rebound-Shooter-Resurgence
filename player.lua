PD = require "playerdata"  -- load playerdata **
function loadplayer()
  player = {}  -- create player
  player.update = function(dt)  -- create update function
    for k,v in pairs(player.objects) do
      v:update(dt)
    end
  end
  player.draw = function()
    for k,v in pairs(player.objects) do
      v:draw()
    end
  end
  player.keypressed = function(key)
    for k,v in pairs(player.objects) do
      v:keypressed(key)
    end
  end
  player.objects = {}
  local ref = refPlayer()
  player.objects.ship = ref
  ref = refSheild()
  player.objects.sheild = ref
  collider:addToGroup(player.objects.ship, player.objects.ship.shape, player.objects.sheild.shape)  -- sheild doesn't collide with ship
end
