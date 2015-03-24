Tefnut = class('Tefnut')
Tefnut:include(stateful) -- Stateful object

function Tefnut:initialize(x, y)
  self.layer = 1
  self.tag = "enemy"
  self.pos = vector(x, y)

  self.image = getImage("entities/tefnutandshu/tefnut.png")
  self.shadow = getImage("entities/tefnutandshu/shadow.png")
end

-- Called on first frame where entity is active
function Tefnut:start()
  self.shape = ovalShape(80, 20, 10)
  self.collider = self.gamestate.collider:addPolygon(unpack(_.flatten(self.shape)))
  self.collider.entity = self
  self.collider.type = "moveable"
end

function Tefnut:draw()
  love.graphics.setColor( 255, 255, 255, 255)

  love.graphics.draw(self.shadow, self.pos.x, self.pos.y, 0, 1, 1, self.shadow:getWidth()/2, self.shadow:getHeight()/2 - 3)
  love.graphics.draw(self.image, self.pos.x + 10, self.pos.y + 15, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())
end

function Tefnut:debug()
  --Mark location with point
  love.graphics.setPointSize(10)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point( self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end
end

function Tefnut:overlay()
end

function Tefnut:update(dt)
  -- Register self as point of interest
  self.gamestate.points_of_interest[self.pos] = 1

  -- Update position from collider
  local cx, cy = self.collider:center()
  self.pos.x = cx
  self.pos.y = cy
end
