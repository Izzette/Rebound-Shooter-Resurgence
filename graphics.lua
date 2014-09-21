function loadGraphics()  -- load graphics
  graphics = {}
  graphics.backgroundImage = love.graphics.newImage("spiral.jpg")  -- makes file drawable
  graphics.objects = {}
  graphics.draw = function(self)
    if play then
      love.graphics.draw(self.backgroundImage, 0, 0)
      love.graphics.setColor(0, 0, 0, 50)
      love.graphics.rectangle("fill", 0, 0, 450, 550)
    else
      love.graphics.setBackgroundColor(0, 0, 0)  -- black background
    end
  end
  graphics.mousepressed = function(x, y, key)
    for i,v in ipairs(graphics.objects) do
      v:mousepressed(x, y, key)
    end
  end
end