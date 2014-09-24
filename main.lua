HC = require "hardoncollider"  -- load hardoncollider library
PL = require "player"  -- load player.lua
CP = require "computer"  -- load computer.lua
GI = require "gui" -- load GUI
MG = require "manager"
function love.load()  -- love2d handles loading
  love.window.setMode(450, 550)  -- set window size
	collider = HC(100, on_collide)  -- initialize hardoncollider
  initGui()  -- load game graphics
  initManager()
  gui:setState("mainmenu")
  play = false  -- defines game is running
end
function love.update(dt)  -- love2d handles updating
  collider:update(dt)  -- update hardoncollider
  if play then  -- if play is true, the game runs
    cTime = cTime + dt  -- update current in-game time
    player.update(dt)  -- update the player, ship
    computer.update(dt)  -- update computer
  end
end
function love.draw()  -- love2d handles drawing
  gui:draw()  -- draw graphics
  if play then
    computer.draw()  -- draw computer
    player.draw()  -- draw player, ship
  end
end
function love.keypressed(key)  -- when keys are pressed
  if play then
    player.keypressed(key)  -- passes player keypressed information
    if key == "p" then
      play = false
      gui:setState("pausemenu")
    end
  end
end
function love.mousepressed(x, y, key)
  gui:mousepressed(x, y, key)
end
function endGame()
  player = nil
  computer = nil
  graphics = nil
  collider = nil
  HC = nil
  PL = nil
  PD = nil
  CP = nil
  CD = nil
  play = nil
  GL = nil
  gui = nil
  manager = nil
  levels = nil
  love.event.quit()
end