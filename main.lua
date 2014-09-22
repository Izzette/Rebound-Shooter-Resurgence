HC = require "hardoncollider"  -- load hardoncollider library
PL = require "player"  -- load player.lua
CP = require "computer"  -- load computer.lua
GI = require "graphics" -- load graphics
function love.load()  -- love2d handles loading
  love.window.setMode(450, 550)  -- set window size
	collider = HC(100, on_collide)  -- initialize hardoncollider
  loadGraphics()  -- load game graphics
  graphics:setGraphics("mainmenu")
  play = false  -- defines game is running
end
function love.update(dt)  -- love2d handles updating
  collider:update(dt)  -- update hardoncollider
  graphics:hover()  -- for mouse hover
  if play then  -- if play is true, the game runs
    cTime = cTime + dt  -- update current in-game time
    player.update(dt)  -- update the player, ship
    computer.update(dt)  -- update computer
  end
end
function love.draw()  -- love2d handles drawing
  graphics:draw()  -- draw graphics
  computer.draw()  -- draw computer
  player.draw()  -- draw player, ship
end
function love.keypressed(key)  -- when keys are pressed
  player.keypressed(key)  -- passes player keypressed information
end
function love.mousepressed(x, y, key)
  graphics:mousepressed(x, y, key)
end
