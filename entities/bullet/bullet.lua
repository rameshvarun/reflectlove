Bullet = class('Bullet')
Bullet:include(stateful) -- Stateful object

local BULLET_IMAGE_DIR = "graphics/bullets/"
local BULLET_TYPES = {
  shu = { 
    name = "shu", 
    imagePath = BULLET_IMAGE_DIR .. "bullet_shu.png",
    speed = 300
  },
  tefnut = { 
    name = "tefnut", 
    imagePath = BULLET_IMAGE_DIR .. "bullet_tefnut.png",
    speed = 300
  }
}

function Bullet:initialize(pos, velocity, typeName)
  self.layer = 1
  self.tag = "bullet"
  self.pos = pos
  self.velocity = velocity

  local bulletType = BULLET_TYPES[typeName]
  self.name = bulletType.name
  self.image = getImage(bulletType.imagePath)
  self.speed = bulletType.speed
end

-- Called on first frame where entity is active
function Bullet:start()
  self.collider = self.gamestate.collider:addCircle(0,0,8)
  self.collider.entity = self
end

function Bullet:draw()
  love.graphics.setColor( 255, 255, 255, 255)
  drawCenter(self.image, self.pos.x, self.pos.y)
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
  self.pos = self.pos + self.velocity * self.speed * dt
  self.collider:moveTo(self.pos.x, self.pos.y)
end
