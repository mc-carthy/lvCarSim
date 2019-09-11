-- Inspired by http://engineeringdotnet.blogspot.com/2010/04/simple-2d-car-physics-in-games.html

local Car = {}

function Car:new(params)
    local inst = {}
    inst.pos = params.pos or { x = 0, y = 0 }
    inst.size = params.size or { x = 2, y = 4 }
    inst.velocity = params.velocity or { x = 0, y = 0 }
    inst.heading = params.heading or 0
    inst.colour = params.colour or { 0.8, 0, 0 }

    inst.update = self.update
    inst.draw = self.draw

    return inst
end

function Car:update(dt)

end

function Car:draw() 
    love.graphics.setColor(unpack(self.colour))
    love.graphics.rectangle('fill', self.pos.x - self.size.x / 2, self.pos.y - self.size.y / 2, self.size.x, self.size.y)
end

return Car