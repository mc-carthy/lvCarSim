local Terrain = {}

local Simplex = require('lib.simplex')

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
    inst.createBorder = self.createBorder
    
    self.generate(inst)

    return inst
end

function Terrain:generate()
    self.height = {}
    self:initialise()
    self:normalise()
    self:createBorder{}
    self:normalise()
end

function Terrain:draw()
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            local g = self.height[x][y]
            local cellSize = 1
            love.graphics.setColor(g, g, g)
            love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellSize, cellSize)
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
                -- local height = love.math.noise(x * self.noiseScale * i + self.noiseOffset.x, y * self.noiseScale * i + self.noiseOffset.y)
                local height = Simplex(x * self.noiseScale * i + self.noiseOffset.x, y * self.noiseScale * i + self.noiseOffset.y)
                self.height[x][y] = self.height[x][y] + (height / i)
            end
        end
    end
end

function Terrain:createBorder(params)
    local borderType = params.borderType or 'circle'
    local outerBorderDistance = params.outerBorderDistance or math.min(self.size.x / 2, self.size.y / 2)
    local innerBorderDistance = params.innerBorderDistance or outerBorderDistance * 0.5
    local interBorderDistance = outerBorderDistance - innerBorderDistance
    
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            local dist = math.sqrt(math.pow((x - self.size.x / 2), 2) + math.pow((y - self.size.y / 2), 2))
            if dist > innerBorderDistance then
                local maskRatio = 1 - math.min((dist - innerBorderDistance) / interBorderDistance, 1)
                self.height[x][y] = self.height[x][y] * maskRatio
            end
        end
    end
end

function Terrain:normalise()
    self.minHeight, self.maxHeight = 1, 0
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            if self.height[x][y] < self.minHeight then self.minHeight = self.height[x][y] end
            if self.height[x][y] > self.maxHeight then self.maxHeight = self.height[x][y] end
        end
    end
    
    local low, high = self.minHeight, self.maxHeight
    self.minHeight, self.maxHeight = 1, 0
    local range = high - low
    local multiplier = 1 / range
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            self.height[x][y] = (self.height[x][y] - low) * multiplier
            if self.height[x][y] < self.minHeight then self.minHeight = self.height[x][y] end
            if self.height[x][y] > self.maxHeight then self.maxHeight = self.height[x][y] end
        end
    end
end

return Terrain