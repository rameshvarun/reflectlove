Player = class('Player')
Player:include(stateful) -- Stateful object

PLAYER_BASE_SPEED = 500

function Player:initialize(x, y)
  self.layer = 1
  self.tag = "player"
  self.pos = vector(x, y)

  self.image = getImage("entities/player/player.png")
end

function Player:setPosition(x, y)
  self.pos.x = x
  self.pos.y = y

  if self.collider ~= nil then
    self.collider:moveTo(x, y)
  end
end

function Player:start()
  self.collider = self.gamestate.collider:addCircle(self.pos.x,self.pos.y, 25)
  self.collider.entity = self
  self.collider.type = "moveable"
end

function Player:diffuse()
  love.graphics.setColor( 255, 255, 255, 255)
  love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())
end

function Player:debug()
  --Mark location with point
  love.graphics.setPointSize(10)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point( self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end
end

function Player:glow()
end

function Player:overlay()
end

function Player:update(dt)
  -- Register self as point of interest
  self.gamestate.points_of_interest[self.pos] = 1

  local speed = PLAYER_BASE_SPEED
  local delta = moveVector() * speed * dt
  self.collider:move(delta.x, delta.y)

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy
end
