function creditsText()
  local credits = {}
  local string = "'Rebound Shooter: Resurgence' developers: Isabell Cowan and Waabanang Hermes."
  local height = 75
  local size = 18
  local paragraph = {string = string, size = size, height = height}
  table.insert(credits, paragraph)
  string = "Special thanks to: David Ball, Chris Jandro, Libby Bergman, Jacob Cowan, Siara Frazier, and Evan Tang."
  height = 55
  size = 14
  paragraph = {string = string, size = size, height = height}
  table.insert(credits, paragraph)
  string = "Made with: LÖVE by 'rude'; ZeroBraneStudio by Paul Kulchenko; HardonCollider by Matthias Richter; Abduction by R. Gast; Roentgen NBP by Nate Halley; and M106 Spiral Galaxy by Robert Gendler, JayBany; and Git by Linus Torvalds, Junio Hamano, many others (github.com/git/git/graphs/contributors); Lua by Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes.  Image credits in README.txt."
  height = 175
  size = 14
  paragraph = {string = string, size = size, height = height}
  table.insert(credits, paragraph)
  string = "v.b.0.0.0"
  height = 15
  size = 12
  paragraph = {string = string, size = size, height = height}
  table.insert(credits, paragraph)
  return credits
end