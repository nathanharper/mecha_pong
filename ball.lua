class = class or require 'lib/middleclass'

Ball = class('Ball')
Ball.static.radius = 10
Ball.static.default_dx = -200
Ball.static.default_dy = 60
Ball.static.speed_increment = 10

function Ball:initialize(speed, dx, dy, x, y)
  local win_x,win_h = love.window.getDimensions()
  self.x = x or win_x / 2
  self.y = y or win_h / 2
  self.dx = dx or Ball.default_dx
  self.dy = dy or Ball.default_dy
end

function Ball:draw()
  love.graphics.circle('fill', self.x, self.y, Ball.radius)
end

function Ball:update(dt)
  self.x = self.dx * dt + self.x
  self.y = self.dy * dt + self.y

  -- window collision check
  local win_x,win_h = love.window.getDimensions()
  if self.y - Ball.radius < 0 then
    self.y = Ball.radius; self.dy = self.dy*-1
  elseif self.y + Ball.radius > win_h then
    self.y = win_h - Ball.radius; self.dy = self.dy*-1
  end

  -- paddle collision check
  local xl,xr,yt,yb
  local left = self.x - Ball.radius
  local right = self.x + Ball.radius
  for _,p in ipairs(paddles) do
    xl,xr,yt,yb = p:getBounds()
    if self.y >= yt and self.y <= yb then 
      if self.dx < 0 and left >= xl and left < xr then
        self.x = xr + Ball.radius; self:reverse()
      elseif self.dx > 0 and right <= xr and right > xl then
        self.x = xl - Ball.radius; self:reverse()
      end
    end
  end

  -- out-of-bounds check
  if self.x + Ball.radius < 1 then
    self:destroy 'left'
  elseif self.x - Ball.radius > win_x then
    self:destroy 'right'
  end
end

function Ball:reverse()
  -- up the speed a wee bit every time the ball bounces off a paddle
  local inc = self.dx > 0 and Ball.speed_increment or Ball.speed_increment * -1
  self.dx = (inc + self.dx) * -1
end

function Ball:destroy(side) self.destroyed = side end
