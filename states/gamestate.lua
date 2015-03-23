GameState = class('GameState', BaseState)

function GameState:initialize()
  BaseState.initialize(self)

  self.collider = hardoncollider(1000) -- Collision system

  -- Add teleporter and, bring in players
  self:add(Player(0,0))
  self:add(TestBoss(0,0))

  -- Ability to slow down time
  self.timescale = 1

  -- Collision dispatch functions
  self.collider:setCallbacks(function(...)
    self:handleCollision(...)
  end, function(dt, a, b, dx, dy)
  end)
end

function GameState:handleCollision(dt, a, b, dx, dy)
  if a.type == "solid" and b.type == "moveable" then
    b:move(-dx, -dy)
  end
  if a.type == "moveable" and b.type == "solid" then
    a:move(dx, dy)
  end
  if a.type == "moveable" and b.type == "moveable" then
    a:move(dx/2, dy/2)
    b:move(-dx/2, -dy/2)
  end
end

function GameState:destroy() end

function GameState:update(dt)
  local scaled = dt * self.timescale
  self.points_of_interest = {} -- Used for camera position calculation

  --Update all gameobjects
	for _,entity in pairs(self.entities) do
    if entity.started ~= true then
      if entity.start ~= nil then entity:start() end
      entity.started = true
    end

		entity:update(scaled)
	end

  --Find camera bounds
  local min = nil
  local max = nil

  for point,value in pairs(self.points_of_interest) do
    if min == nil then min = point:clone() end
    if max == nil then max = point:clone() end

    if point.x < min.x then min.x = point.x end
    if point.x > max.x then max.x = point.x end

    if point.y < min.y then min.y = point.y end
    if point.y > max.y then max.y = point.y end
  end

  if not (min == nil or max == nil) then
    local WIDTH_BUFFER = 500
    local HEIGHT_BUFFER = 500

    local center = (min + max)/2
    local zoomx = ((max.x - min.x) + WIDTH_BUFFER)/love.window.getWidth()
    local zoomy = ((max.y - min.y) + HEIGHT_BUFFER)/love.window.getHeight()

    local zoom = zoomx > zoomy and zoomx or zoomy
    if zoom < 1 then zoom = 1 end

    local lerpTime = dt*3
    self.cam:zoomTo(lume.lerp(self.cam.scale, 1/zoom, lerpTime))
    self.cam:lookAt(lume.lerp(self.cam.x, center.x, lerpTime), lume.lerp(self.cam.y, center.y, lerpTime))
  end

  self.timer:update(dt) -- Preform callbacks and tweening
  self.collider:update() -- Detect collisions
end

function GameState:prescene(dt)
  self.cam:attach() -- Push camera transform onto stack
  _.sort(self.entities, drawOrder) --Sort by layer and y-ordering
end

function GameState:postscene(dt)
  self.cam:detach() -- Pop camera transform
end

function GameState:draw()
  _.invoke(self.entities, "draw")
  if DEBUG_DRAW then _.invoke(self.entities, "debug") end
end

function GameState:overlay()
  for _, entity in ipairs(self.entities) do
    if entity.overlay ~= nil then entity:overlay() end
  end
end

-- Draw order for entities
function drawOrder(a, b)
	if a.layer == b.layer then
		return a.pos.y < b.pos.y
	else
		return a.layer < b.layer
	end

	return false
end
