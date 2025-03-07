local view = require("utils.view")
local class = require("class")
local state = require("state")
local bubbles = {}
local effects = {}

-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function distance(x1, y1, x2, y2)
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

function reset()
  state.reset()
  state.deaths = 0
end


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
  view.setDimensions(800, 800)
  reset()
end

function love.update()
end

function love.mousepressed(_, _, button)
  local x, y = view.getMouseX(), view.getMouseY()
  if button == 1 then
    for i,bubble in pairs(bubbles) do
      if not bubble.destroyed then
        bubble:step()
      end
    end
    table.insert(bubbles, class.bubble.new(x, y, 70))
  elseif button == 2 then
    local bubblesDestroyed = false
    for i,bubble in pairs(bubbles) do
      local dist = distance(x, y, bubble.x, bubble.y)
      dist = dist - bubble.radius
      if dist < 0 and not bubble.destroyed then
        bubblesDestroyed = true
        bubble:destroy()
      end
    end
    if bubblesDestroyed then
      for i,bubble in pairs(bubbles) do
        if not bubble.destroyed then
          bubble:step()
        end
      end
    end
  end
end

function love.keypressed(key)
  if key == "f11" then
    love.window.setFullscreen(not love.window.getFullscreen())
    return
  end
  if key == "escape" then
    love.window.setFullscreen(false)
    return
  end
end

function love.update(dt)
  for _, bubble in pairs(bubbles) do
    bubble:update(dt)
  end
end

function love.draw()
  love.graphics.push("all")
  view.origin()
  for _, bubble in pairs(bubbles) do
    bubble:draw()
  end
  for _, bubble in pairs(bubbles) do
    bubble:drawObjects()
  end
  love.graphics.pop()
end
