local Wheel = {}

function Wheel:new(params)
    local inst = {}
    inst.pos = params.pos or { x = 0, y = 0 }
    inst.size = params.size or { x = 0.2, y = 0.5 }
    inst.velocity = params.velocity or { x = 0, y = 0 }
    inst.heading = params.heading or 0

    inst.draw = self.draw

    return inst
end

function Wheel:draw()
    love.graphics.setColor(0.25, 0.25, 0.25)
    love.graphics.rectangle('fill', self.pos.x - self.size.x / 2, self.pos.y - self.size.y / 2, self.size.x, self.size.y)
end

return Wheel