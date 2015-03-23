TestBoss = class('TestBoss')
TestBoss:include(stateful) -- Stateful object

function TestBoss:initialize(x, y)
  self.layer = 1
  self.tag = "enemy"
  self.pos = vector(x, y)

  self.image = getImage("entities/testboss/boss.png")
end

-- Called on first frame where entity is active
function TestBoss:start()
  self.collider = self.gamestate.collider:addCircle(self.pos.x,self.pos.y, 25)
  self.collider.entity = self
  self.collider.type = "moveable"
end

function TestBoss:draw()
  love.graphics.setColor( 255, 255, 255, 255)
  love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())
end

function TestBoss:debug()
  --Mark location with point
  love.graphics.setPointSize(10)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point( self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end
end

function TestBoss:overlay()
end

function TestBoss:update(dt)
  -- Register self as point of interest
  self.gamestate.points_of_interest[self.pos] = 1

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy
end
