local Wheel = require('src.car.wheel')

describe('Wheel tests', function()

    setup('Initialising wheel', function()
        testWheel = Wheel:new{}
    end)

    before_each('Reset wheel params', function()
        testWheel.pos = { x = 0, y = 0 }
        testWheel.velocity = { x = 0, y = 0 }
    end)
    
    it('should move according to current speed/angle', function()
        testWheel.velocity = { x = 0, y = 0.1 }
        for i = 1, 5 do
            testWheel:update(1 / 60)
        end
        assert.are.equal(testWheel.pos.y, 0.1 * 5 / 60)
    end)

    it('should slow over time due to friction/resistance', function() 
        testWheel.velocity = { x = 0, y = 1 }
        for i = 1, 5 do
            testWheel:update(1 / 60)
        end
        assert.is_true(testWheel.velocity.y < 1)
    end)
end)