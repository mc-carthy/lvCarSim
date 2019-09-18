local Terrain = {}

local Simplex = require('lib.simplex')

local defaults = {
    size = 700,
    scale = 0.01
}

function Terrain:new(params)
    math.randomseed(os.time())
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
    inst.borderType = params.borderType or 'circle'

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
    self:createBorder{
        borderType = self.borderType
    }
    self:normalise()
end

function Terrain:draw()
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            local cellSize = 1
            if self.height[x][y] < 0.1 then -- Deep ocean
                love.graphics.setColor(0, 0, 0.5)
            elseif self.height[x][y] < 0.2 then -- Mid ocean
                love.graphics.setColor(0, 0, 1)
            elseif self.height[x][y] < 0.3 then -- Shallow ocean
                love.graphics.setColor(0, 0.6, 0.8)
            elseif self.height[x][y] < 0.375 then -- Light shore
                love.graphics.setColor(0.8, 0.75, 0.5)
            elseif self.height[x][y] < 0.4 then -- Dark shore
                love.graphics.setColor(0.5, 0.4, 0.2)
            elseif self.height[x][y] < 0.5 then -- Light grass
                love.graphics.setColor(0.4, 0.5, 0.2)
            elseif self.height[x][y] < 0.7 then -- Dark grass
                love.graphics.setColor(0.15, 0.25, 0)
            elseif self.height[x][y] < 0.75 then -- Medium grass
                love.graphics.setColor(0.25, 0.4, 0.1)
            elseif self.height[x][y] < 0.80 then -- Light grass
                love.graphics.setColor(0.4, 0.5, 0.2)
            elseif self.height[x][y] < 0.85 then -- Mountain low
                love.graphics.setColor(0.65, 0.65, 0.65)
            elseif self.height[x][y] < 0.95 then -- Mountain mid
                love.graphics.setColor(0.85, 0.85, 0.85)
            else -- Mountain top
                love.graphics.setColor(1, 1, 1)
            end            
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
    local outerBorderDistance
    local innerBorderDistance
    
    for x = 1, self.size.x do
        for y = 1, self.size.y do
            local dist
            local dx = math.abs(x - self.size.x / 2) / self.size.x
            local dy = math.abs(y - self.size.y / 2) / self.size.y
            if borderType == 'circle' then
                dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
                outerBorderDistance = 0.5
                innerBorderDistance = 0.4
            elseif borderType == 'square' then
                outerBorderDistance = 0.5
                innerBorderDistance = 0.3
                dist = math.max(dx, dy)
            elseif borderType == 'squircle' then
                dist = math.pow(math.pow(dx, 4) + math.pow(dy, 4) , 1 / 4)
                outerBorderDistance = 0.5
                innerBorderDistance = 0.4
            end
            local interBorderDistance = outerBorderDistance - innerBorderDistance
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