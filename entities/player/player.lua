Player = class('Player')
Player:include(stateful) -- Stateful object

PLAYER_RUN_SPEED = 200
PLAYER_WALK_SPEED = 100
PLAYER_ANIMATION_SPEED = 0.05

local PLAYER_DIRECTIONS = { 
  left = { 
    key = 'a',
    frames = getImage("graphics/player/player_left.png")
  },
  right = { 
    key = 'd',
    frames = getImage("graphics/player/player_right.png")
  }, 
  up = { 
    key = 'w',
    frames = getImage("graphics/player/player_up.png")
  },
  down = { 
    key = 's',
    frames = getImage("graphics/player/player_down.png")
  }
}

function Player:initialize(x, y)
  self.layer = 1
  self.tag = "player"
  self.pos = vector(x, y)

  local g = anim8.newGrid(32, 32, 128, 32)
  self.animation = anim8.newAnimation(g('1-4', 1), PLAYER_ANIMATION_SPEED)
  self.frames = PLAYER_DIRECTIONS.down.frames
  self.shadow = getImage("graphics/player/shadow.png")
  -- array storing order in which directional keys are pressed
  self.directionalKeysHeld = {}
end

function Player:setPosition(x, y)
  self.pos.x = x
  self.pos.y = y

  if self.collider ~= nil then
    self.collider:moveTo(x, y)
  end
end

function Player:onCollide(other, dx, dy)
  if other.tag == "enemy" then
    self:die()
  end
end

function Player:die()
  next_state = GameState()
end

function Player:start()
  self.collider = self.gamestate.collider:addCircle(self.pos.x,self.pos.y, 8)
  self.collider.entity = self
  self.collider.type = "moveable"
  self.paddle = Paddle(self.pos.x, self.pos.y)
  self.gamestate:add(self.paddle) 
end

function Player:draw()
  love.graphics.setColor(255, 255, 255, 255)

  love.graphics.draw(self.shadow, self.pos.x, self.pos.y, 0, 1, 1, self.shadow:getWidth()/2, self.shadow:getHeight()/2)
  self.animation:draw(self.frames, self.pos.x-16, self.pos.y-32)
end

function Player:debug()
  --Mark location with point
  love.graphics.setPointSize(5)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point( self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end
end

function Player:overlay()
end

function Player:update(dt)
  -- Register self as point of interest
  self.gamestate.points_of_interest[self.pos] = 1

  local speed = self.paddle.enabled and PLAYER_WALK_SPEED or PLAYER_RUN_SPEED
  local delta = moveVector() * speed * dt
  self.collider:move(delta.x, delta.y)

  -- Update animation if moving
  if delta.x == 0 and delta.y == 0 then
    self.animation:gotoFrame(1)
  else
    self.animation:update(dt)
  end

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy
  self.paddle.pos = self.pos
end

function Player:handleInput(key, state)
  if state == 1 then
    for _, direction in pairs(PLAYER_DIRECTIONS) do
      if key == direction.key then
        self:addDirectionalKey(direction)
      end
    end
  elseif state == -1 then
    for _, direction in pairs(PLAYER_DIRECTIONS) do
      if key == direction.key then
        self:removeDirectionalKey(direction)
      end
    end
  end
end

function Player:addDirectionalKey(direction)
  if _.first(self.directionalKeysHeld) == nil then
    self:changeDirection(direction)
  end
  _.push(self.directionalKeysHeld, direction)
end

function Player:removeDirectionalKey(direction)
  local newKeys = _.reject(self.directionalKeysHeld, function (d) return d == direction end)
  if _.first(self.directionalKeysHeld) == direction and _.first(newKeys) ~= nil then
    self:changeDirection(_.first(newKeys))
  end
  self.directionalKeysHeld = newKeys
end

function Player:changeDirection(direction)
  self.frames = direction.frames
  self.animation:gotoFrame(1)
end