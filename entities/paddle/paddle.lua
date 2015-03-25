Paddle = class('Paddle')
Paddle:include(stateful) -- Stateful object

PADDLE_DISTANCE = 30

local PADDLE_IMAGE_DIR = "graphics/paddle/"
local PADDLE_DIRECTIONS = {
  right = {
    offsetDirection = vector(1, 0),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_right.png"),
    shape = {{30,4}, {30,28}, {25,28}, {25,4}}
  },
  left = {
    offsetDirection = vector(-1, 0),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_left.png"),
    shape = {{1,4}, {1,28}, {6,28}, {6,4}}
  },
  up = {
    offsetDirection = vector(0, -1),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_up.png"),
    shape = {{4,8}, {5,0}, {26,0}, {27,8}}
  },
  down = {
    offsetDirection = vector(0, 1),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_down.png"),
    shape = {{2,28}, {3,18}, {28,18}, {29,28}}
  },
  downright = {
    offsetDirection = vector(1,1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_downright.png"),
    shape = {{26,9}, {28,17}, {9,30}, {7,20}}
  },
  downleft = {
    offsetDirection = vector(-1,1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_downleft.png"),
    shape = {{6,8}, {3,17}, {22,29}, {25,20}}
  },
  upleft = {
    offsetDirection = vector(-1,-1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_upleft.png"),
    shape = {{0,12}, {4,20}, {20,10}, {18,2}}
  },
  upright = {
    offsetDirection = vector(1,-1):normalized(),
    image = getImage(PADDLE_IMAGE_DIR .. "paddle_upright.png"),
    shape = {{14,2}, {32,12}, {27,20}, {11,10}}
  }
}

function Paddle:initialize(x, y)
  self.layer = 1
  self.tag = "paddle"
  self.pos = vector(x, y)
  self.horizontalKeysHeld = {}
  self.verticalKeysHeld = {}
  self.enabled = false
  self:changeDirection(nil)
end

function Paddle:setPosition(x, y)
  self.pos.x = x
  self.pos.y = y

  if self.collider ~= nil then
    self.collider:moveTo(x, y)
  end
end

function Paddle:onCollide(other, dx, dy)
  if other.tag == "bullet" then
    other.velocity = other.velocity * -1
    other.pos.x = other.pos.x - dx
    other.pos.y = other.pos.y - dy
  end
end

function Paddle:start()
end

function Paddle:draw()
  if self.enabled then
    drawCenter(self.image, self.offset.x+self.pos.x, self.offset.y+self.pos.y)
  end
end

function Paddle:debug()
  if self.enabled then
    love.graphics.setColor( 0, 255, 0, 255 )
    love.graphics.point( (self.pos + self.offset):unpack() )

    if self.collider ~= nil then self.collider:draw('line', 16) end
  end
end

function Paddle:overlay()
end

function Paddle:update(dt)
  self:changeDirection(self:computeDirection())
  if self.collider ~= nil then
    self.collider:moveTo(self.pos.x+self.offset.x, self.pos.y+self.offset.y)
  end
  local count = 0
  for shape in self.gamestate.collider:activeShapes() do
    count = count+1
  end
end

function Paddle:handleInput(key, state)
  if state == 1 then
    if key == "left" or key == "right" then
      _.unshift(self.horizontalKeysHeld, key)
    end
    if key == "up" or key == "down" then
      _.unshift(self.verticalKeysHeld, key)
    end
  elseif state == -1 then
    if key == "left" or key == "right" then
      self.horizontalKeysHeld = _.reject(self.horizontalKeysHeld, function (i) return i == key end)
    end
    if key == "up" or key == "down" then
      self.verticalKeysHeld = _.reject(self.verticalKeysHeld, function (i) return i == key end)
    end
  end
end

function Paddle:changeDirection(direction)
  if self.direction ~= direction then
    self.direction = direction
    if self.collider ~= nil then
      self.gamestate.collider:remove(self.collider)
      self.collider = nil
    end
    if direction == nil then
      self.enabled = false
    else
      self.enabled = true
      self.image = PADDLE_DIRECTIONS[direction].image
      self.shape = PADDLE_DIRECTIONS[direction].shape
      self.offset = PADDLE_DISTANCE*PADDLE_DIRECTIONS[direction].offsetDirection
      self.collider = self.gamestate.collider:addPolygon(unpack(_.flatten(self.shape)))
      self.collider.entity = self
    end
  end
end

function Paddle:computeDirection()
  hkey = _.first(self.horizontalKeysHeld)
  vkey = _.first(self.verticalKeysHeld)
  if hkey == "right" and vkey == nil then
    return "right"
  elseif hkey == "left" and vkey == nil then
    return "left"
  elseif hkey == nil and vkey == "up" then
    return "up"
  elseif hkey == nil and vkey == "down" then
    return "down"
  elseif hkey == "right" and vkey == "up" then
    return "upright"
  elseif hkey == "left" and vkey == "up" then
    return "upleft"
  elseif hkey == "right" and vkey == "down" then
    return "downright"
  elseif hkey == "left" and vkey == "down" then
    return "downleft"
  else
    return nil
  end
end
