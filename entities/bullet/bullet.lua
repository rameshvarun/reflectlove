Bullet = class('Bullet')
Bullet:include(stateful) -- Stateful object

local BULLET_IMAGE_DIR = "graphics/bullets/"
local BULLET_TYPES = {
  shu = { 
    name = "shu", 
    imagePath = BULLET_IMAGE_DIR .. "bullet_shu.png",
    speed = 100
  },
  tefnut = { 
    name = "tefnut", 
    imagePath = BULLET_IMAGE_DIR .. "bullet_tefnut.png",
    speed = 100
  }
}

function Bullet:initialize(pos, vel, typeName)
  self.layer = 1
  self.tag = "bullet"
  self.pos = pos
  self.vel = vel  --velocity

  local bulletType = BULLET_TYPES[typeName]
  self.name = bulletType.name
  self.image = getImage(bulletType.imagePath)
  self.speed = bulletType.speed
end

-- Called on first frame where entity is active
function Bullet:start()
  --[[ 
  self.shape = ovalShape(80, 20, 10)
  self.collider = self.gamestate.collider:addPolygon(unpack(_.flatten(self.shape)))
  self.collider.entity = self
  self.collider.type = "moveable"
  self.collider:moveTo(self.pos:unpack())
  ]]--
end

function Bullet:draw()
  love.graphics.setColor( 255, 255, 255, 255)
  love.graphics.draw(self.image, self.pos.x + 10, self.pos.y + 15, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight())
end

function Bullet:debug()
  --Mark location with point
  love.graphics.setPointSize(10)
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.point(self.pos.x, self.pos.y)

  if self.collider ~= nil then self.collider:draw('line', 16) end
end

function Bullet:overlay()
end

function Bullet:handleInput(key, state)
end

function Bullet:update(dt)
  -- Register self as a point of interest
  self.gamestate.points_of_interest[self.pos] = 1
  self.pos = self.pos + self.vel*self.speed*dt
end
