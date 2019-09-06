local Wheel = require('src.car.wheel')

describe('Wheel tests', function()

    setup('Initialising wheel', function()
        testWheel = Wheel:new()
    end)

    before_each('Reset wheel params', function()
    
    end)
    
    describe('should move according to current speed/angle', function()
    
    end)

    describe('should slow over time due to friction/resistance', function() 
        
    end)
end)