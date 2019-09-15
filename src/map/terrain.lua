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
        x = params.noiseOffset and params.noiseOffset.x or math.random(),
        y = params.noiseOffset and params.noiseOffset.y or math.random()
    }
    inst.noiseScale = params.noiseScale or defaults.scale
    inst.octaves = params.octaves or 4

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
            self.height[x][y] = 0
        end
    end
    for i = 1, self.octaves do
        for x = 1, self.size.x do
            for y = 1, self.size.y do
                local height = love.math.noise(x * self.noiseScale * i + self.noiseOffset.x, y * self.noiseScale * i + self.noiseOffset.y)
                self.height[x][y] = self.height[x][y] + (height / i)
                if self.height[x][y] < self.minHeight then self.minHeight = self.height[x][y] end
                if self.height[x][y] > self.maxHeight then self.maxHeight = self.height[x][y] end
            end
        end
    end
end

function Terrain:normalise()
    local low, high = self.minHeight, self.maxHeight
    local range = high - low
    local multiplier = 1 / range
    self.minHeight, self.maxHeight = 1, 0
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            self.height[x][y] = (self.height[x][y] - low) * multiplier
            if self.height[x][y] < self.minHeight then self.minHeight = self.height[x][y] end
            if self.height[x][y] > self.maxHeight then self.maxHeight = self.height[x][y] end
        end
    end
end

return Terrain