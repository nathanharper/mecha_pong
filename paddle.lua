class = class or require 'lib/middleclass'

Paddle = class('Paddle')
Paddle.static.w = 10
Paddle.static.h = 80
Paddle.static.speed = 200

function Paddle:initialize(x, y, axis)
  self.x,self.y,self.axis,self.score = x,y,axis,0
end

function Paddle:draw()
  love.graphics.rectangle('fill', self.x, self.y, Paddle.w, Paddle.h)
end

function Paddle:update(dt)
  local last_y = self.y
  local win_w,win_h = love.window.getDimensions()
  self.y = self.y + Paddle.speed * dt * joystick:getAxis(self.axis)
  if self.y + Paddle.h > win_h then self.y = win_h - Paddle.h end
  if self.y < 0 then self.y = 0 end
end

function Paddle:getBounds()
  return self.x, self.x+Paddle.w, self.y, self.y+Paddle.h
end

function Paddle:score_up() self.score = self.score + 1 end
