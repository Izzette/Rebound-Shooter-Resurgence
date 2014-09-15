HC = require "hardoncollider"  -- load hardoncollider library
LF = require "loveframes"  -- load loveframes library
PL = require "player"  -- load player **
CP = require "computer"  -- load computer objects **
UI = require "gui"
function love.load()  -- love2d handles loading
  love.window.setMode(600, 450)  -- set window size
	collider = HC(100, on_collide)  -- initialize hardoncollider
	mainmenu()  -- call main menu in GUI **
	play = false  -- set boolean play false, defines whether the game is playing or not
	cTime = love.timer.getTime()  -- define startup time
end
function love.update(dt)  -- love2d handles updating
  collider:update(dt)  -- update hardoncollider
  loveframes.update(dt)  -- update loveframes
	if play then  -- if play is true, the game runs
    cTime = cTime + dt  -- update current in-game time
    player.update(dt)  -- update the player, ship **
    computer.update(dt)  -- update the computers objects, enemies, bullets, powerups, ect. **
  end
end
function love.draw()  -- love2d handles drawing
  loveframes.draw()  -- draw GUI
  if play then  -- if game is running
    player.draw()  -- draw player, ship **
    computer.draw()  -- draw other objects **
  end
end
function love.keypressed(key)  -- when keys are pressed
  player.keypressed(key)  -- passes player keypressed information **
  computer.keypressed(key) -- passes objects key **
  loveframes.keypressed(key) -- passes loveframes key
end
function love.keyreleased(key) -- when keys are released
  loveframes.keyreleased(key)  -- passes loveframes key
end
function love.mousepressed(x, y, button)  -- when mouse is pressed
  loveframes.mousepressed(x, y, button)  -- passes loveframes mousepressed
end
function love.mousereleased(x, y, button)  -- when mouse is released
  loveframes.mousereleased(x, y, button)  -- passes loveframes mousereleased
end
function on_collide(dt, shape_a, shape_b)  -- when collider detects collisions
  local check = false  -- set check to false, defines whether or not the two objects have been identified and passed collide info
  for i,v in ipairs(computer.objects) do  -- for all computer.objects  **
    for ip,vp in pairs(player.objects) do  -- first check to see if other object is a player object, player objects should never do anything when they collide **
      if shape_a == v.shape and shape_b == vp.shape then  -- compare shapes to objects
        v:onCollide(vp)  -- pass collide info
        vp:onCollide(v)  -- pass collide info
        check = true  -- set check true, will cause break at end of loops
      elseif shape_a == vp.shape and shape_b == v.shape then  -- incase of other
        v:onCollide(vp)
        vp:onCollide(v)
        check = true
      end
      if check then  -- breaks after we found the two objects
        break
      end
    end
    for ic,vc in ipairs(computer.objects) do  -- if it's another computer object **
      if shape_a == v.shape and shape_b == vc.shape then  -- compares shapes to objects, like before
        v:onCollide(vc)
        vc:onCollide(v)
        check = true
      elseif shape_a = vc.shape and shape_b == v.shape then
        v:onCollide(vc)
        vc:onCollide(v)
        check = true
      end
      if check then  -- break this one too, even if the other object is a player.object
        break
      end
    end
    if check then  -- break if check
      break
    end
  end
end
