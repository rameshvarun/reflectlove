Lion = class('Lion')
Lion:include(stateful) -- Stateful object

local BULLET_INTERVAL = 1.5

function Lion:initialize(x, y, type)
  self.layer = 1
  self.tag = "enemy"
  self.pos = vector(x, y)

  if type == "tefnut" then self.image = getImage("entities/tefnutandshu/tefnut.png") end
  if type == "shu" then self.image = getImage("entities/tefnutandshu/shu.png") end
  self.name = type
  self.bulletTimer = 0

  self.shadow = getImage("entities/tefnutandshu/shadow.png")
end

-- Called on first frame where entity is active
function Lion:start()
  self.shape = ovalShape(80, 20, 10)
  self.collider = self.gamestate.collider:addPolygon(unpack(_.flatten(self.shape)))
  self.collider.entity = self
  self.collider.type = "moveable"
  self.collider:moveTo(self.pos:unpack())
end

function Lion:draw()
  love.graphics.setColor( 255, 255, 255, 255)

  love.graphics.draw(self.shadow, self.pos.x, self.pos.y, 0, 1, 1, self.shadow:getWidth()/2, self.shadow:getHeight()/2 - 3)
  love.graphics.draw(self.image, self.pos.x + 10, self.pos.y + 15, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())
end

function Lion:debug()
  --Mark location with point
  love.graphics.setPointSize(10)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point( self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end
end

function Lion:overlay()
end

function Lion:handleInput(key, state)
end

function Lion:update(dt)
  -- Register self as a point of interest
  self.gamestate.points_of_interest[self.pos] = 1

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy

  -- Bullet stuff
  self.bulletTimer = self.bulletTimer+dt
  if self.bulletTimer >= BULLET_INTERVAL then
    self.bulletTimer = self.bulletTimer - BULLET_INTERVAL
    local player = self.gamestate:getEntityByTag("player")
    self.gamestate:add(Bullet(self.pos, (player.pos - self.pos):normalized(), self.name))
  end
end
