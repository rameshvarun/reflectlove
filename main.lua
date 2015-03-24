-- Release mode / Debug draw flags
RELEASE = false
DEBUG_DRAW = not RELEASE
GAME_VERSION = "0.0.1"
PAUSE_ON_UNFOCUS = false

-- Util
require 'util'

-- Load dependencies into Global scope
vector = require "vendor.vector" -- Vector class
class = require "vendor.middleclass" -- Object orientated programming in lua
stateful = require "vendor.stateful"
camera = require "vendor.camera"
lume = require "vendor.lume"
anim8 = require "vendor.anim8"
_ = require 'vendor.underscore'
timer = require 'vendor.timer'
signals = require 'vendor.signal'
hardoncollider = require 'vendor.hardoncollider'

-- Entities
require_dir "entities"

-- Game States
require_dir "states"

if not RELEASE then
  -- Load Web development console
  lovebird = require "vendor.lovebird"
  lovebird.update()

  lurker = require "vendor.lurker" -- Live reloading system
end

-- Current gamestate starts as nil
current_state = nil
next_state = nil

-- Code related to drawing and post-processing
require_dir "rendering"

function love.load()
  love.mouse.setVisible(false) -- Make cursor invisible
  create_canvases() -- Creates all the intermediate rendering canvases

  current_state = GameState()
end

function love.update(dt)
  if not RELEASE then
    lovebird.update() -- Web dev console
    lurker.update() -- Live reload system
  end

  -- Only simulate game if window has focus
  if (PAUSE_ON_UNFOCUS and love.window.hasFocus()) or not PAUSE_ON_UNFOCUS then
    if current_state ~= nil then current_state:update(dt) end
  end

  if next_state ~= nil then
    current_state:destroy()
    current_state = next_state
    next_state = nil
  end
end

function love.keypressed(key, isrepeat)
  current_state:handleInput(key, 1)
end

function love.keyreleased(key, unicode)
  if key == "f1" then
    if not RELEASE then
      DEBUG_DRAW = not DEBUG_DRAW
      print("Toggled debug draw.")
    end
  end

  if current_state ~= nil and current_state.keyreleased ~= nil then
    current_state:keyreleased(key, unicode)
  end

  current_state:handleInput(key, -1)
end
