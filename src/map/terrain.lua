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

    inst.minHeight = 1
    inst.maxHeight = 0

    
    inst.draw = self.draw
    inst.initialise = self.initialise
    inst.normalise = self.normalise
    
    self.generate(inst)
    
    return inst
end

function Terrain:generate()
    self.height = {}
    self:initialise()
    self:normalise()
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
            if height < self.minHeight then self.minHeight = height end
            if height > self.maxHeight then self.maxHeight = height end
            self.height[x][y] = height
        end
    end
end

function Terrain:normalise()
    local range = self.maxHeight - self.minHeight
    local multiplier = 1 / range
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            self.height[x][y] = (self.height[x][y] - self.minHeight) * multiplier
            if self.height[x][y] < self.minHeight then self.minHeight = self.height[x][y] end
            if self.height[x][y] > self.maxHeight then self.maxHeight = self.height[x][y] end
        end
    end
end

return Terrain