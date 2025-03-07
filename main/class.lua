local state = require("state")
local class = {}


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Enums | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Person stages.
class.CHILD = 1
class.YOUTH = 2
class.ADULT = 3


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- https://stackoverflow.com/questions/5837572
function rand_in_circle(x_origin, y_origin, radius)
  r = radius * math.sqrt(love.math.random())
  theta = love.math.random() * 2 * math.pi
  x = x_origin + r * math.cos(theta)
  y = y_origin + r * math.sin(theta)
  return x, y
end

function distance(x1, y1, x2, y2)
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Object | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.object = {}

function class.object.new(radius)
  local object = {}
  object.x = nil
  object.y = nil
  object.radius = radius
  setmetatable(object, {__index = class.object})
  return object
end

-- override
function class.object:draw(fade)
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Person | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.person = {}

function class.person.new(stage)
  local person = class.object.new(10.0)
  person.stage = stage
  setmetatable(person, {__index = class.person})
  return person
end

function class.person:draw(fade)
  love.graphics.push("all")
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0.8, 0.4, 0.4, fade)
  if self.stage == class.CHILD or self.stage == class.CHILD then
    love.graphics.line(self.x - 2, self.y + 3, self.x + 0, self.y - 1)
    love.graphics.line(self.x - 0, self.y - 1, self.x + 2, self.y + 3)
    love.graphics.circle("line", self.x, self.y - 7, 2)
  elseif self.stage == class.YOUTH then
    love.graphics.line(self.x - 2, self.y + 3, self.x + 0, self.y - 1)
    love.graphics.line(self.x - 0, self.y - 1, self.x + 2, self.y + 3)
    love.graphics.circle("line", self.x, self.y - 7, 2)
  elseif self.stage == class.ADULT then
    love.graphics.line(self.x - 2, self.y + 3, self.x + 0, self.y - 1)
    love.graphics.line(self.x - 0, self.y - 1, self.x + 2, self.y + 3)
    love.graphics.circle("line", self.x, self.y - 7, 3)
  end
  love.graphics.pop()
end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Table | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.table = {}

function class.table.new()
  local table = class.object.new(20.0)
  setmetatable(table, {__index = class.table})
  return table
end

function class.table:draw(fade)
  love.graphics.push("all")
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0.7, 0.3, 0.3, fade)
  love.graphics.line(self.x - 8, self.y - 4, self.x - 8, self.y + 3)
  love.graphics.line(self.x + 8, self.y - 4, self.x + 8, self.y + 3)
  love.graphics.line(self.x - 3, self.y + 0, self.x - 3, self.y + 3)
  love.graphics.line(self.x - 3, self.y + 0, self.x + 3, self.y + 0)
  love.graphics.line(self.x + 3, self.y + 0, self.x + 3, self.y + 3)
  love.graphics.pop()
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Bubble | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.bubble = {}

function class.bubble.new(x, y, radius)
  local bubble = {}
  if #state.audioFiles > 0 then
    local audioIndex = love.math.random(#state.audioFiles)
    bubble.audioPath = state.audioFiles[audioIndex]
    table.remove(state.audioFiles, audioIndex)
    bubble.audioSource = love.audio.newSource(bubble.audioPath, "static")
    bubble.audioSource:setVolume(0.0)
    bubble.audioSource:setLooping(true)
    bubble.audioSource:play()
  else
    bubble.audioPath = nil
    bubble.audioSource = nil
  end
  bubble.fade = 0.0
  bubble.pop = 0.0
  bubble.destroyed = false
  bubble.x = x
  bubble.y = y
  bubble.radius = radius
  bubble.objects = {}
  bubble.personCount = 0
  bubble.tableCount = 0
  setmetatable(bubble, {__index = class.bubble})
  bubble:spawn()
  return bubble
end

function class.bubble:update(dt)
  if not self.destroyed then
    self.fade = math.min(self.fade + dt * 3.0, 1.0)
  else
    self.fade = math.max(self.fade - dt * 3.0, 0)
  end
  self.pop = math.max(self.pop - dt * 2.0, 0)
  if #state.audioFiles > 0 then
    if self.audioSource ~= nil then
      self.audioSource:setVolume(self.fade)
    end
  end
end

function class.bubble:draw()
  if self.destroyed and self.pop > 0.0 then
    love.graphics.push("all")
    love.graphics.setLineWidth(4)
    love.graphics.setColor(0.35, 0.1, 0.15, self.pop)
    love.graphics.line(self.x - 25, self.y + 25, self.x - 30, self.y + 30)
    love.graphics.line(self.x +  0, self.y + 35, self.x +  0, self.y + 50)
    love.graphics.line(self.x + 25, self.y + 25, self.x + 30, self.y + 30)
    love.graphics.line(self.x + 35, self.y +  0, self.x + 50, self.y +  0)
    love.graphics.line(self.x + 25, self.y - 25, self.x + 30, self.y - 30)
    love.graphics.line(self.x +  0, self.y - 35, self.x +  0, self.y - 50)
    love.graphics.line(self.x - 25, self.y - 25, self.x - 30, self.y - 30)
    love.graphics.line(self.x - 35, self.y +  0, self.x - 50, self.y +  0)
    love.graphics.pop()
  end
  if self.fade > 0.0 or not self.destroyed then
    love.graphics.push("all")
    love.graphics.setColor(0.35, 0.1, 0.15, self.fade * 1.2)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", self.x, self.y, self.radius + 6)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.pop()
  end
end

function class.bubble:destroy()
  self.pop = 1.5
  self.destroyed = true
  if self.audioPath ~= nil then
    self.fade = 1.0
    table.insert(state.audioFiles, self.audioPath)
  end
end

function class.bubble:drawObjects()
  if self.fade > 0.0 or not self.destroyed then
    for i=1,#self.objects do
      self.objects[i]:draw(self.fade * 1.2)
    end
  end
end

function class.bubble:spawn()
  self:addObject(class.person.new(class.ADULT))
  self:addObject(class.person.new(class.ADULT))
  self:addObject(class.table.new())
  self.personCount = 2
  self.tableCount = 1
end

function class.bubble:step()
  local adultCount = 0
  if #self.objects > 100 then return end
  for _, object in pairs(self.objects) do
    if object.stage ~= nil then
      if object.stage ~= class.ADULT then
        object.stage = object.stage + 1
      end
      adultCount = adultCount + 1
    end
  end
  -- print(adultCount)
  for i=1,math.floor(adultCount / 2) do
    self:addObject(class.person.new(class.CHILD))
    self.personCount = self.personCount + 1
  end
  for i=1,math.floor(self.personCount - self.tableCount * 4) do
    self:addObject(class.table.new())
    self.tableCount = self.tableCount + 1
  end
end

-- Adds objects to a random space on the bubble, with spacing where possible.
function class.bubble:addObject(object)
  local x, y = rand_in_circle(self.x, self.y, self.radius - object.radius)
  local padding = object.radius
  while true do
    local overlapping = false
    for _, o in pairs(self.objects) do
      local dist = distance(x, y, o.x, o.y)
      if dist < padding then
        padding = padding - 1
        overlapping = true
        x, y = rand_in_circle(self.x, self.y, self.radius)
        break
      end
    end
    if not overlapping then
      break
    end
  end
  object.x = x
  object.y = y
  table.insert(self.objects, object)
end

return class
