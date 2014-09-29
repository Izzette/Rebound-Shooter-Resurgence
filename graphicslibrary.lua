function initGraphics()
  graphics = {}
  graphics.fonts = {}
  graphics.newFont = function(self, fontname, filename)
    for i = 6,36 do
      local font = {fontname = fontname, size = i, data = love.graphics.newFont(filename, i)}
      table.insert(self.fonts, font)
    end
  end
  graphics.setFont = function(self, fontname, size)
    for i,v in ipairs(self.fonts) do
      if v.fontname == fontname and v.size == size then
        love.graphics.setFont(v.data)
        break
      end
    end
  end
  graphics.addText = function(self, string, x, y, width, fontname, size)
    local text = {string = string, x = x, y = y, width = width, fontname = fontname, size = size, align = "left", red = 255, green = 255, blue = 255, mousepressed = function(self, x, y, key) end}
    text.draw = function(self, x, y)
      graphics:setFont(self.fontname, self.size)
      love.graphics.setColor(self.red, self.green, self.blue, 255)
      love.graphics.printf(self.string, self.x, self.y, self.width, self.align)
    end
    text.setAlign = function(self, align)
      self.align = align
    end
    text.setColor = function(self, red, green, blue)
      self.red = red
      self.green = green
      self.blue = blue
    end
    return text
  end
  graphics.addButton = function(self, x, y, width, height, clickthrough)
    local button = {x = x, y = y, width = width, height = height, clickthrough = clickthrough}
    button.text = {draw = function(self, x, y) end}
    button.draw = function(self, x, y)
      if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end
      self.text:draw(x, y)
    end
    button.addText = function(self, string, fontname, size)
      self.text = graphics:addText(string, self.x, self.y + (0.5 * self.height) - (0.5 * size), self.width, fontname, size)
      self.text:setAlign("center")
    end
    button.setTextColor = function(self, red, green, blue)
      self.text:setColor(red, green, blue)
    end
    button.mousepressed = function(self, x, y, key)
      if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
        self:clickthrough()
      end
    end
    return button
  end
  graphics.addParent = function(self, x, y, width, height)
    local parent = {x = x, y = y, width = width, height = height}
    parent.objects = {}
    parent.draw = function(self, x, y)
      love.graphics.setColor(0, 0, 0, 150)
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      for i,v in ipairs(self.objects) do
        v:draw(x, y)
      end
    end
    parent.mousepressed = function(self, x, y, key)
      for i,v in ipairs(self.objects) do
        v:mousepressed(x, y)
      end
    end
    parent.addText = function(self, string, x, y, width, fontname, size)
      local text = graphics:addText(string, x + self.x, y + self.y, width, fontname, size)
      table.insert(self.objects, text)
    end
    parent.setTextAlign = function(self, align)
      self.objects[#self.objects]:setAlign(align)
    end
    parent.setTextColor = function(self, red, green, blue)
      self.objects[#self.objects]:setColor(red, green, blue)
    end
    parent.addButton = function(self, x, y, width, height, clickthrough)
      local button = graphics:addButton(x + self.x, y + self.y, width, height, clickthrough)
      table.insert(self.objects, button)
    end
    parent.addButtonText = function(self, string, fontname, size)
      self.objects[#self.objects]:addText(string, fontname, size)
    end
    parent.setButtonTextColor = function(self, red, green, blue)
      self.objects[#self.objects]:setTextColor(red, green, blue)
    end
    parent.addImage = function(self, filename, x, y, width, height)
      local image = graphics:addImage(filename, self.x + x, self.y + y, width, height)
      table.insert(self.objects, image)
    end
    return parent
  end
  graphics.addImage = function(self, filename, x, y, width, height)
    local image = {image = love.graphics.newImage(filename), x = x, y = y, width = width, height = height}
    if 0 == width then
      image.sy = height / image.image:getHeight()
      image.sx = image.sy
    elseif 0 == height then
      image.sx = width / image.image:getWidth()
      image.sy = image.sx
    else
      image.sx = width / image.image:getWidth()
      image.sy = height / image.image:getHeight()
    end
    image.draw = function(self, x, y)
      love.graphics.setColor(255, 255, 255, 225)
      love.graphics.draw(self.image, self.x, self.y, 0, self.sx, self.sy)
    end
    image.mousepressed = function(self, x, y, key) end
    return image
  end
end