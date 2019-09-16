-- Inspired by http://engineeringdotnet.blogspot.com/2010/04/simple-2d-car-physics-in-games.html

local Car = {}

function Car:new(params)
    local inst = {}
    inst.pos = params.pos or { x = 0, y = 0 }
    inst.size = params.size or { x = 2, y = 4 }
    inst.speed = params.speed or 15
    inst.steeringAngle = params.steeringAngle or 0.5
    inst.heading = params.heading or 0
    inst.wheelbase = params.wheelbase or inst.size.y
    inst.frontWheelPos = params.frontWheelPos or { x = inst.pos.x, y = inst.pos.y - inst.wheelbase / 2}
    inst.rearWheelPos = params.rearWheelPos or { x = inst.pos.x, y = inst.pos.y + inst.wheelbase / 2}
    inst.colour = params.colour or { 0.8, 0, 0 }

    inst.update = self.update
    inst.draw = self.draw

    return inst
end

function Car:update(dt)
    if love.keyboard.isDown('left') then
        self.steeringAngle = self.steeringAngle - 1 * dt
    end
    if love.keyboard.isDown('right') then
        self.steeringAngle = self.steeringAngle + 1 * dt
    end

    if love.keyboard.isDown('up') then
        self.speed = self.speed + 10 * dt
    end
    if love.keyboard.isDown('down') then
        self.speed = self.speed - 10 * dt
    end

    self.steeringAngle = math.min(math.max(self.steeringAngle, -1), 1)

    self.frontWheel = {
        x = self.pos.x + ((self.wheelbase / 2) * math.cos(self.heading)),
        y = self.pos.y + ((self.wheelbase / 2) * math.sin(self.heading))
    }
    self.rearWheel = {
        x = self.pos.x - ((self.wheelbase / 2) * math.cos(self.heading)),
        y = self.pos.y - ((self.wheelbase / 2) * math.sin(self.heading))
    }

    self.frontWheel.x = self.frontWheel.x + self.speed * dt * math.cos(self.heading + self.steeringAngle);
    self.frontWheel.y = self.frontWheel.y + self.speed * dt * math.sin(self.heading + self.steeringAngle);
    self.rearWheel.x = self.rearWheel.x + self.speed * dt * math.cos(self.heading);
    self.rearWheel.y = self.rearWheel.y + self.speed * dt * math.sin(self.heading);

    self.pos.x = (self.frontWheel.x + self.rearWheel.x) / 2
    self.pos.y = (self.frontWheel.y + self.rearWheel.y) / 2

    self.heading = math.atan2(self.frontWheel.y - self.rearWheel.y, self.frontWheel.x - self.rearWheel.x)
end

function Car:draw() 
    love.graphics.setColor(unpack(self.colour))
    -- love.graphics.rectangle('fill', self.pos.x - self.size.x / 2, self.pos.y - self.size.y / 2, self.size.x, self.size.y)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('fill', self.frontWheel.x, self.frontWheel.y, 0.5)
    love.graphics.circle('fill', self.rearWheel.x, self.rearWheel.y, 0.5)
end

return Car