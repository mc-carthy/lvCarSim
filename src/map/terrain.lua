local Terrain = {}

local defaults = {
    size = 700,
    scale = 0.01
}

function Terrain:new(params)
    local inst = {}

    inst.size = {
        x = params.size and params.size.x or defaults.size,
        y = params.size and params.size.y or defaults.size
    }
    inst.noiseOffset = {
        x = params.noiseOffset and params.noiseOffset.x or love.math.random(),
        y = params.noiseOffset and params.noiseOffset.y or love.math.random()
    }
    inst.noiseScale = params.noiseScale or defaults.scale
    
    inst.draw = self.draw
    inst.initialise = self.initialise
    
    self.generate(inst)
    
    return inst
end

function Terrain:generate()
    self.height = {}
    self:initialise()
end

function Terrain:draw()
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            local g = self.height[x][y]
            local cellSize = 1
            love.graphics.setColor(g, g, g)
            love.graphics.rectangle('fill', x * cellSize, y * cellSize, cellSize, cellSize)
        end
    end
end

function Terrain:initialise()
    for x = 1, self.size.x do
        self.height[x] = {}
        for y = 1, self.size.y do
            local height = love.math.noise(x * self.noiseScale + self.noiseOffset.x, y * self.noiseScale + self.noiseOffset.y)
            self.height[x][y] = height
        end
    end
end

return Terrain