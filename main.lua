HC = require "hardoncollider"  -- load hardoncollider
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
