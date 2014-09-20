
  ===================================
    Rebound Shooter: Resurgence
  ===================================

  An open-source Lua project made for L�VE 0.9.0.
  Version alpha 2.0.9
  By Isabell Cowan, Wesley Smith, and Waabanang Hermes-Roach
  
  "Rebound Shooter: Resurgence" is an arcade-like space shooter.
  The player in this game controls a ship and shield, and defends themselves from alien spaceships.
  The shield is capable of collect and protect the ship from bullets fired by the alien spaceships.
  The collected bullets can later be refired offensively.

  Contains:
   -- 
   -- Libraries (Third-Party):
       -- hardoncollider folder
          Hardon Collider
          A collison detection library by Matthias Richter
          Sub-Moduals:
           -- class.lua
           -- gjk.lua
           -- init.lua
           -- polygon.lua
           -- shapes.lua
           -- spatialhash.lua
           -- vector-light.lua
           -- README.txt
       -- loveframes folder
          L�ve Frames
          A GUI library by Kenny Shields
          Sub-Moduals:
           -- libraries folder
           -- objects folder
           -- skins folder
           -- templates folder
           -- third-party folder
           -- init.lua
           -- readme.md
           -- changelog.txt
           -- liscense.txt
   -- Files (First-Party):
       -- main.lua
          Operates all other files, exculding playerdata.lua and computerdata.lua.
          Run by L�VE
       -- player.lua
          Operates all player objects
          Accesses playerdata.lua to spawn these objects.
       -- playerdata.lua
          Contains all information about spawn state of player objects, as well as some of the changes these objects make to themselves.
       -- computer.lua
          Operates all computer objects, enemies, bullets, ect.
          Accesses computerdata.lua to spawn these objects.
       -- computerdata.lua
          Contains all information about spawn state of computer objects, as well as some changes these objects make to themselves.
       -- README.txt
          This file, silly :P
       -- Rebound Shooter Resurgence.love
          Compressed runable form

  Doccumentation:
   -- Rebound Shooter: Resurgence
      github.com/Izzette/Rebound-Shooter-Resurgence
   -- L�VE
      love2d.org
   -- HardonCollider
      vrld.github.io/HardonCollider/index.html
      github.com/vrld/HardonCollider
   -- L�ve Frames
      nikolairesokav.com/projects.loveframes
      github.com/NikolaiResokav/LoveFrames

  Installation:
   -- Download Rebound Shooter: Resurgence
      github.com/Izzette/Rebound-Shooter-Resurgence
      Compatable with win32, win64, and macosx-x64
   -- Download L�VE 0.9.0
      bitbucket.org/rude/love/downloads
      Published 12-13-2013 and 12-14-2013
      Versions for win64, win32, linux-src, i386, amd64, and macosx-x64
   -- Install L�VE 0.9.0
   -- Optional; create shortcut on desktop to c:/../Rebound Shooter Resurgence.love
   -- To run; open c:/../Rebound Shooter Resurgence.love with L�VE 0.9.0

  Submit Bugs, Make Revisions:
   -- Create a new issue at github.com/Izzette/Rebound-Shooter-Resurgence/issues to report bugs
   -- Revisions can be made through the creation of a pull-request at github.com/Izzette/Rebound-Shooter-Resurgence/pulls

  Olderversions:
   -- The abandoned Rebound Shooter version alpha 1.0.0 through alpha 1.1.27 can be found at github.com/Waabanang/rebound-shooter