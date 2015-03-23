function create_canvases()
  -- Initialize various output channel canvases
  diffuse_canvas = love.graphics.newCanvas()
  normal_canvas = love.graphics.newCanvas()
  glow_canvas = love.graphics.newCanvas()
  distortion_canvas = love.graphics.newCanvas()
  overlay_canvas = love.graphics.newCanvas()

  extra_canvas1 = love.graphics.newCanvas()
end

-- All possible draw modes
DRAW_MODE_ALL = 0
DRAW_MODE_DIFFUSE = 1
DRAW_MODE_NORMAL = 2
DRAW_MODE_GLOW = 3
DRAW_MODE_DISTORTION = 4

-- The current draw mode
draw_mode = DRAW_MODE_DIFFUSE

local horizontalblur = getShader("rendering/horizontalblur.frag")
local verticalblur = getShader("rendering/verticalblur.frag")

-- Glow Parameters
GLOW_SCALE = 5
GLOW_REPS = 9
GLOW_ALPHA = 255

DRAW_MODES = {
  [DRAW_MODE_ALL] = function()

    -- Start by rendering all channels
    current_state:prescene()
    love.graphics.setShader()

    --Render diffuse buffer
  	love.graphics.setCanvas(diffuse_canvas)
  	diffuse_canvas:clear()
    current_state:diffuse()

    --Render Glow buffer
    love.graphics.setCanvas(glow_canvas)
    glow_canvas:clear()
    current_state:glow()

    -- Done rendering all channels
    current_state:postscene()

    --Render diffuse to screen
    love.graphics.setColor( 255, 255, 255, 255 )
    love.graphics.setCanvas()
    love.graphics.draw(diffuse_canvas, 0, 0)

    horizontalblur:send("width", love.window.getWidth())
    verticalblur:send("height", love.window.getHeight())

    horizontalblur:send("scale", GLOW_SCALE * 3)
    verticalblur:send("scale", GLOW_SCALE)

    for i=1,GLOW_REPS do
      love.graphics.setShader(horizontalblur)
      love.graphics.setCanvas(extra_canvas1)
      extra_canvas1:clear()
      love.graphics.draw(glow_canvas, 0, 0)


      love.graphics.setShader(verticalblur)
      love.graphics.setCanvas(glow_canvas)
      glow_canvas:clear()
      love.graphics.draw(extra_canvas1, 0, 0)
    end

    -- Render glow on top
    love.graphics.setCanvas()
    love.graphics.setShader()
    love.graphics.setColor( 255, 255, 255, GLOW_ALPHA )
    love.graphics.setBlendMode("additive")
    love.graphics.draw(extra_canvas1, 0, 0)
    love.graphics.setBlendMode("alpha")

  end,

  -- Ability to view individual channels
  [DRAW_MODE_DIFFUSE] = function()
    current_state:prescene()
    current_state:draw()
    current_state:postscene()
  end,
  [DRAW_MODE_NORMAL] = function()
    current_state:prescene()
    current_state:normal()
    current_state:postscene()
  end,
  [DRAW_MODE_GLOW] = function()
    current_state:prescene()
    current_state:glow()
    current_state:postscene()
  end,
  [DRAW_MODE_DISTORTION] = function()
    current_state:prescene()
    current_state:distortion()
    current_state:postscene()
  end
}

local info_font = love.graphics.newFont(20)
function love.draw()
  if current_state ~= nil then
    DRAW_MODES[draw_mode]()

    current_state:overlay()

    if DEBUG_DRAW then
      love.graphics.setColor(255, 0, 0, 255)
      love.graphics.setFont(info_font)

      love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0, 0, 1, 1)
      love.graphics.print('Draw Mode: ' .. draw_mode, 0, 20, 0, 1, 1)

      love.graphics.print('Game Version: ' .. GAME_VERSION, 0, love.window.getHeight() - 25, 0, 1, 1)
    end
  end

end
