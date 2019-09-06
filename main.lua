local Wheel = require('src.car.wheel')


function love.load()
    wheel1 = Wheel:new{
        pos = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2
        }
    }
end

function love.update(dt)

end

function love.draw()
    love.graphics.setBackgroundColor(0.75, 0.75, 0.75)
    wheel1:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end