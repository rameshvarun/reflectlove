BaseState = class('BaseState')

function BaseState:initialize()
  self.cam = camera(0, 0) -- Camera
  self.lights = {} -- Used to light scene in deferred rendering
  self.entities = {} -- List of all entities in the game

  self.timer = timer:new() -- Register callbacks and tweening
  self.signals = signals:new() -- Signals/Slots registry
end

-- Add an entity to the list
function BaseState:add(entity)
  entity.gamestate = self
  entity.started = false
  _.push(self.entities, entity)
end

-- Remove an entity
function BaseState:remove(entity)
  entity:destroy()
  self.entities = _.reject(self.entities, function(e)
    return e == entity
  end)
end

-- Get an entity by its tag string value
function BaseState:getEntityByTag(tag)
  for _,entity in pairs(self.entities) do
    if entity.tag == tag then return entity end
  end
  return nil
end
