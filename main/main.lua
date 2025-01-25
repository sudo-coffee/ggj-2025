local view = require("utils.view")


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", 300, 300, 50, 100) -- Draw white circle with 100 segments.
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", 300, 300, 50, 5)   -- Draw red circle with five segments.
end
