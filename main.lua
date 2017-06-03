local circles = {}

local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

for i = 1, 20 do
    table.insert(circles, {
        x = math.random(window_width),
        y = math.random(window_height),
        v_x = (math.random() - 0.5) * 50,
        v_y = (math.random() - 0.5) * 50,
        r = math.random(40) + 12
    })
end

function love.update(dt)
    for i, circle in ipairs(circles) do
        circle.x = circle.x + circle.v_x * dt
        circle.y = circle.y + circle.v_y * dt
    end
end

function love.draw()
    for i, circle in ipairs(circles) do
        love.graphics.circle("fill", circle.x, circle.y, circle.r)
    end
end
