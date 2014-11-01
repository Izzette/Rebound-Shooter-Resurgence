
  ===================================
      Rebound Shooter: Resurgence
  ===================================

  An open-source Lua project made for LÖVE 0.9.1.
  version beta 1.1.0
  By Isabell Cowan and Waabanang Hermes-Roach
  
  "Rebound Shooter: Resurgence" is an arcade-like space shooter.
  The player in this game controls a ship and shield, and defends themselves from alien spaceships.
  The shield is capable of collect and protect the ship from bullets fired by the alien spaceships.
  The collected bullets can later be refired offensively.

  Contains:
   -- Libraries (Third-Party):
       -- hardoncollider folder
          Hardon Collider
          A collision detection library by Matthias Richter
          Sub-Modules:
           -- class.lua
           -- gjk.lua
           -- init.lua
           -- polygon.lua
           -- shapes.lua
           -- spatialhash.lua
           -- vector-light.lua
           -- README.txt
       -- fonts folder
           -- abduction folder
              Abduction Font
               -- Abduction.ttf
               -- Abduction.txt
                  Contains author and copyright information
	   -- datacontrol folder
              Data Control Font
	       -- data-unifon.ttf
	       -- data-latin.ttfinformation
       -- images folder
           -- scooty.jpg
              Brinki licensed under CC BY-SA 2.0 (modified)
           -- octo.jpg
              Jean-Pierre licensed under CC BY-SA 2.0 (modified)
           -- tri.jpg
           -- spiral.jpg
              Credits can be found in image properties
           -- icon.png
   -- Files:
       -- main.lua
          Operates all other files, excluding playerdata.lua and computerdata.lua.
          Run by LÖVE
       -- player.lua
          Handles all player objects
          Accesses playerdata.lua to spawn these objects.
       -- playerdata.lua
          player prototype
       -- computer.lua
          Handles all computer objects, enemies, bullets, etc.
          Accesses computerdata.lua to spawn these objects.
       -- computerdata.lua
          PC prototype
       -- gui.lua
          Handles GUI
       -- graphicslibrary.lua
          Simple library for GUI
       -- README.txt
          This file, silly :P
       -- Rebound-Shooter-Resurgence.zip/.love
          Compressed runable form

  Documentation:
   -- Rebound Shooter: Resurgence
      github.com/Izzette/Rebound-Shooter-Resurgence
      github.com/Izzette/Rebound-Shooter-Resurgence/wiki
   -- LÖVE
      love2d.org
   -- HardonCollider
      vrld.github.io/HardonCollider/index.html
      github.com/vrld/HardonCollider

  Installation:
   -- Download Rebound Shooter: Resurgence
      Download the ".zip" from github.com/Izzette/Rebound-Shooter-Resurgence
      Extract the ".zip" (it contains another ".zip")
      if running something other than windows change the extention of the file named "Rebound Shooter Resurgence.zip" to the ".love"
      Compatible with win32, win64, and macosx-x64, ubutu-14.04
   -- Download LÖVE v.0.9.1
      Download v.0.9.1 for your OS from bitbucket.org/rude/love/downloads
   -- Install LÖVE v.0.9.1
   -- Optional; create shortcut on desktop to c:/../Rebound Shooter Resurgence.
   -- To run; open c:/../Rebound Shooter Resurgence.love with LÖVE v.0.9.1

  Submit Bugs, Make Revisions:
   -- Create a new issue at github.com/Izzette/Rebound-Shooter-Resurgence/issues to report bugs
   -- Revisions can be made through the creation of a pull-request at github.com/Izzette/Rebound-Shooter-Resurgence/pulls

  Older-Versions:
   -- The abandoned Rebound Shooter version alpha 1.0.0 through alpha 1.1.27 can be found at github.com/Waabanang/rebound-shooter
