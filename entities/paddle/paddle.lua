Paddle = class('Paddle')
Paddle:include(stateful) -- Stateful object

SHIELD_DISTANCE = 30

local PADDLE_IMAGE_DIR = "graphics/paddle/"
local PADDLES = {
  {
    dir = vector(1, 0),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_right.png"),
    shape = {{29, 4}, {29, 28}}
  },
  {
    dir = vector(-1, 0),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_left.png"),
    shape = {{2, 4}, {2, 28}}
  },
  {
    dir = vector(0, -1),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_top.png"),
    shape = {{5, 1}, {26, 1}}
  },
  {
    dir = vector(0, 1),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_bottom.png"),
    shape = {{2, 26}, {29, 26}}
  },
  {
    dir = vector(1,1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_bottomright.png"),
    shape = {{9, 27}, {28, 16}}
  },
  {
    dir = vector(-1,1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_bottomleft.png"),
    shape = {{3, 15}, {22, 26}}
  },
  {
    dir = vector(-1,-1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_topleft.png"),
    shape = {{1, 13}, {18, 3}}
  },
  {
    dir = vector(1,-1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_topright.png"),
    shape = {{30, 13}, {13, 3}}
  }
}

function Paddle:initialize(x, y)
  self.layer = 1
  self.tag = "paddle"
  self.pos = vector(x, y)
end

function Paddle:setPosition(x, y)
  self.pos.x = x
  self.pos.y = y

  if self.collider ~= nil then
    self.collider:moveTo(x, y)
  end
end

function Paddle:onCollide(other, dx, dy)
  if other.tag == "enemy" then
    self:die()
  end
end

function Paddle:destroy()
  current_state:remove(self)
end

function Paddle:start()
end

function Paddle:draw()
end

function Paddle:debug()
end

function Paddle:overlay()
end

function Paddle:update(dt)
end

function Paddle:handleInput(key, state)
end