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
    self.generate(inst)

    inst.draw = self.draw

    return inst
end

function Terrain:generate()
    self.height = {}
    local maxHeight, minHeight = 0, 1
    for x = 1, self.size.x do
        self.height[x] = {}
        for y = 1, self.size.y do
            local height = love.math.noise(x * self.noiseScale + self.noiseOffset.x, y * self.noiseScale + self.noiseOffset.y)
            if height < minHeight then minHeight = height end
            if height > maxHeight then maxHeight = height end
            self.height[x][y] = height
        end
    end
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

return Terrain