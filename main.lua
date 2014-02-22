require 'paddle'
require 'ball'
paddles = {}
balls = {}
-- setmetatable(balls, {__index = {filter=filter}})

local fake_joystick = {
  axis_map = {
    [2] = {up='w', down='s'},
    [5] = {up='up', down='down'}
  },
  getAxis = function(self, axis)
    local dirs = self.axis_map[axis]
    if love.keyboard.isDown(dirs.up) then
      return -1
    elseif love.keyboard.isDown(dirs.down) then
      return 1
    end
    return 0
  end
}

function love.load()
  win_w,win_h = love.window.getDimensions()
  joystick = love.joystick.getJoysticks()[1] or fake_joystick
  local height = win_h / 2 - Paddle.h / 2
  local x_off = 20
  paddles[1] = Paddle:new(x_off, height, 2)
  paddles[2] = Paddle:new(win_w - Paddle.w - x_off, height, 5)
  balls[1] = Ball:new()
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.setColor(255,255,255)
end

function love.update(dt)
  for i in ipairs(paddles) do paddles[i]:update(dt) end
  local bl,br = 0,0 -- keep track of new balls to add

  -- simultaneously filter and update balls
  balls = filter(balls, function(b)
    b:update(dt)
    if b.destroyed then
      if b.destroyed == 'left' then
        paddles[2]:score_up(); bl = bl + 1
      else
        paddles[1]:score_up(); br = br + 1
      end
      return false
    end
    return true
  end)

  -- add a ball for each one lost
  for i = 1, bl do balls[#balls+1] = Ball:new() end
  for i = 1, br do balls[#balls+1] = Ball:new(Ball.default_speed, Ball.default_dx * -1) end
end

function love.draw()
  for _,p in ipairs(paddles) do p:draw() end
  for _,b in ipairs(balls) do b:draw() end
  love.graphics.print(paddles[1].score..' : '..paddles[2].score, win_w/2, 25)
end

function filter(array, func)
  local filtered = {}
  for _,v in ipairs(array) do
    if func(v) then
      filtered[#filtered+1] = v
    end
  end
  return filtered
end
