function love.conf(t)
  t.identity = nil
  t.version = "0.9.1"
  t.window.title = "Rebound Shooter: Resurgence"
  t.window.icon = "/images/icon.png"
  t.window.width = 450
  t.window.height = 550
  t.window.borderless = false
  t.window.resizable = false
  t.window.fullscreen = false
  t.window.display = 1
  t.modules.audio = false
  t.modules.event = true
  t.modules.graphics = true
  t.modules.image = true
  t.modules.joystick = false
  t.modules.keyboard = true
  t.modules.math = true
  t.modules.mouse = true
  t.modules.physics = false
  t.modules.sound = false
  t.modules.system = true
  t.modules.timer = true
  t.modules.window = true
end