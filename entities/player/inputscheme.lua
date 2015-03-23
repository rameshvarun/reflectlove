DEAD_ZONE = 0.2

local to_int = function(boolean)
  if boolean then return 1 else return -1 end
end

function moveVector()
  local move_vectors = _.map(love.joystick.getJoysticks(), function(joystick)
    local move = vector(joystick:getGamepadAxis("leftx"),
    joystick:getGamepadAxis("lefty"))
    if move:len() > DEAD_ZONE then return move
    else return vector(0,0) end
  end)

  -- Keyboard controls
  keyboard_move = vector(
    to_int(love.keyboard.isDown('d')) - to_int(love.keyboard.isDown('a')),
    to_int(love.keyboard.isDown('s')) - to_int(love.keyboard.isDown('w'))
  )
  _.push(move_vectors, keyboard_move:normalized())

  return _.max(move_vectors, function(vec) return vec:len() end)
end

function aimVector()
  local move_vectors = _.map(love.joystick.getJoysticks(), function(joystick)
    local move = vector(joystick:getGamepadAxis("rightx"),
    joystick:getGamepadAxis("righty"))
    if move:len() > DEAD_ZONE then return move
    else return vector(0,0) end
  end)

  return _.max(move_vectors, function(vec) return vec:len() end)
end
