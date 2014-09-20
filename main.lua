HC = require "hardoncollider"  -- load hardoncollider library
LF = require "loveframes"  -- load loveframes library
PL = require "player"  -- load player
function love.load()  -- love2d handles loading
  love.window.setMode(450, 550)  -- set window size
	collider = HC(100, on_collide)  -- initialize hardoncollider
  loadPlayer()  -- loads player
  play = true  -- defines game is running
	cTime = love.timer.getTime()  -- define startup time
end
function love.update(dt)  -- love2d handles updating
  collider:update(dt)  -- update hardoncollider
  loveframes.update(dt)  -- update loveframes
	if play then  -- if play is true, the game runs
    cTime = cTime + dt  -- update current in-game time
    player.update(dt)  -- update the player, ship
  end
end
function love.draw()  -- love2d handles drawing
  loveframes.draw()  -- draw GUI
  if play then  -- if game is running
    player.draw()  -- draw player, ship **
  end
end
function love.keypressed(key)  -- when keys are pressed
  player.keypressed(key)  -- passes player keypressed information **
  loveframes.keypressed(key) -- passes loveframes key
end
function love.keyreleased(key) -- when keys are released
  player.keyreleased(key)  -- passes player key
  loveframes.keyreleased(key)  -- passes loveframes key
end
function love.mousepressed(x, y, button)  -- when mouse is pressed
  loveframes.mousepressed(x, y, button)  -- passes loveframes mousepressed
end
function love.mousereleased(x, y, button)  -- when mouse is released
  loveframes.mousereleased(x, y, button)  -- passes loveframes mousereleased
end
function on_collide(dt, shape_a, shape_b) -- called by hardon on collide
end