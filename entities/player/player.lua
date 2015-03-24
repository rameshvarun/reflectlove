Player = class('Player')
Player:include(stateful) -- Stateful object

PLAYER_RUN_SPEED = 200
PLAYER_WALK_SPEED = 100
SHIELD_DISTANCE = 30

function Player:initialize(x, y)
  self.layer = 1
  self.tag = "player"
  self.pos = vector(x, y)

  self.image = getImage("entities/player/pharaoh.png")
  self.shadow = getImage("entities/player/shadow.png")

  self.shieldSpawned = false
  self.shieldOffset = vector(0, 0)
end

function Player:setPosition(x, y)
  self.pos.x = x
  self.pos.y = y

  if self.collider ~= nil then
    self.collider:moveTo(x, y)
  end
end

function Player:start()
  self.collider = self.gamestate.collider:addCircle(self.pos.x,self.pos.y, 8)
  self.collider.entity = self
  self.collider.type = "moveable"
end

local PADDLE_DIR = "entities/player/paddle/"
local PADDLE_DIRECTIONS = {
  {
    dir = vector(1, 0),
    image = getImage(PADDLE_DIR .. "paddle_right.png"),
    shape = {{29, 4}, {29, 28}}
  },
  {
    dir = vector(-1, 0),
    image = getImage(PADDLE_DIR .. "paddle_left.png"),
    shape = {{2, 4}, {2, 28}}
  },
  {
    dir = vector(0, -1),
    image = getImage(PADDLE_DIR .. "paddle_top.png"),
    shape = {{5, 1}, {26, 1}}
  },
  {
    dir = vector(0, 1),
    image = getImage(PADDLE_DIR .. "paddle_bottom.png"),
    shape = {{2, 26}, {29, 26}}
  },
  {
    dir = vector(1,1):normalized(),
    image = getImage(PADDLE_DIR .. "paddle_bottomright.png"),
    shape = {{9, 27}, {28, 16}}
  },
  {
    dir = vector(-1,1):normalized(),
    image = getImage(PADDLE_DIR .. "paddle_bottomleft.png"),
    shape = {{3, 15}, {22, 26}}
  },
  {
    dir = vector(-1,-1):normalized(),
    image = getImage(PADDLE_DIR .. "paddle_topleft.png"),
    shape = {{1, 13}, {18, 3}}
  },
  {
    dir = vector(1,-1):normalized(),
    image = getImage(PADDLE_DIR .. "paddle_topright.png"),
    shape = {{30, 13}, {13, 3}}
  }
}

function Player:draw()
  love.graphics.setColor( 255, 255, 255, 255)

  love.graphics.draw(self.shadow, self.pos.x, self.pos.y, 0, 1, 1, self.shadow:getWidth()/2, self.shadow:getHeight()/2)
  love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())

  if self.shieldSpawned then
    local paddle_dir = _.min(PADDLE_DIRECTIONS, function(dir) return math.abs(self.shieldOffset:angleTo(dir.dir)) end)
    local paddle_img = paddle_dir.image
    love.graphics.draw(paddle_img, self.pos.x + self.shieldOffset.x, self.pos.y + self.shieldOffset.y, 0, 1, 1, paddle_img:getWidth()/2, paddle_img:getHeight()/2)
    self.paddle_dir = paddle_dir
  end
end

function Player:debug()
  --Mark location with point
  love.graphics.setPointSize(5)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point( self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end

  if self.shieldSpawned then
    love.graphics.point( (self.pos + self.shieldOffset):unpack() )

    local points = _.map(self.paddle_dir.shape, function(point)
      return {self.pos.x + point[1] + self.shieldOffset.x - self.paddle_dir.image:getWidth() / 2,
      self.pos.y + point[2] + self.shieldOffset.y - self.paddle_dir.image:getHeight() / 2}
    end)
    love.graphics.line(unpack(_.flatten(points)))
  end
end

function Player:overlay()
end

function Player:update(dt)
  -- Register self as point of interest
  self.gamestate.points_of_interest[self.pos] = 1

  local is_aiming, aim_dir = aimInput()
  if is_aiming and not self.shieldSpawned then
    self.shieldSpawned = true
    self.shieldOffset = SHIELD_DISTANCE*aim_dir
  end

  if is_aiming and self.shieldSpawned then
    self.shieldOffset = lume.slerp(self.shieldOffset, SHIELD_DISTANCE*aim_dir, 10.0*dt)
  end

  if not is_aiming and self.shieldSpawned then
    self.shieldSpawned = false
  end

  local speed = is_aiming and PLAYER_WALK_SPEED or PLAYER_RUN_SPEED
  local delta = moveVector() * speed * dt
  self.collider:move(delta.x, delta.y)

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy
end