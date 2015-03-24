Player = class('Player')
Player:include(stateful) -- Stateful object

PLAYER_RUN_SPEED = 200
PLAYER_WALK_SPEED = 100

function Player:initialize(x, y)
  self.layer = 1
  self.tag = "player"
  self.pos = vector(x, y)

  self.image = getImage("entities/player/pharaoh.png")
  self.shadow = getImage("entities/player/shadow.png")
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

function Player:draw()
  love.graphics.setColor( 255, 255, 255, 255)
  
  love.graphics.draw(self.shadow, self.pos.x, self.pos.y, 0, 1, 1, self.shadow:getWidth()/2, self.shadow:getHeight()/2)
  love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())
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

  local is_aiming, aim_dir = aimInput()

  local speed = is_aiming and PLAYER_WALK_SPEED or PLAYER_RUN_SPEED
  local delta = moveVector() * speed * dt
  self.collider:move(delta.x, delta.y)

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy
end
