collider = require "hardoncollider"  -- load hardonHC library
PL = require "player"  -- load player.lua
CP = require "computer"  -- load computer.lua
GI = require "gui" -- load GUI
function love.load()  -- love2d handles loading
  love.window.setMode(450, 550)  -- set window size
  love.window.setTitle("Rebound Shooter: Resurgence")
  initLevels()
  initGui()  -- load game graphics
  HC = collider.new(50)
  gui:setState("mainmenu")
  play = false  -- defines game is running
end
function love.update(dt)  -- love2d handles updating
  HC:update(dt)  -- update hardonHC
  if play then  -- if play is true, the game runs
    cTime = cTime + dt  -- update current in-game time
    player:update(dt)  -- update the player, ship
    manager:update(dt)
    computer:update(dt)  -- update computer
  end
end
function love.draw()  -- love2d handles drawing
  if gui.state == "game" or gui.state == "pause" then
    love.graphics.setColor(255, 255, 255, 200)
    love.graphics.draw(manager.background, 0, 0)
  end
  if play then
    computer:draw()  -- draw computer
    player:draw()  -- draw player, ship
  end
  gui:draw()  -- draw graphics
end
function love.keypressed(key)  -- when keys are pressed
  if play then
    player:keypressed(key)  -- passes player keypressed information
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
  manager = nil
  LV = nil
  MG = nil
  HC = nil
  PL = nil
  PD = nil
  CP = nil
  CD = nil
  play = nil
  GL = nil
  gui = nil
  love.event.quit()
end