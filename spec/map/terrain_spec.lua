local Terrain = require('src.map.terrain')

describe('Terrain tests', function()

    setup('Initialising terrain', function()
        testTerrain = Terrain:new{}
    end)

    it('should have near 0 and near 1 minHeight and maxHeight respectively', function() 
        assert.is_true(math.abs(testTerrain.minHeight) < 0.001, 'MinHeight: ' .. testTerrain.minHeight)
        assert.is_true(math.abs(testTerrain.maxHeight - 1) < 0.001)
    end)
end)