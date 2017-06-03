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

        if circle.x - circle.r < 0 then
            circle.x = 0 + circle.r
            circle.v_x = -circle.v_x
        elseif circle.x + circle.r > window_width then
            circle.x = window_width - circle.r
            circle.v_x = -circle.v_x
        end

        if circle.y - circle.r < 0 then
            circle.y = 0 + circle.r
            circle.v_y = -circle.v_y
        elseif circle.y + circle.r > window_height then
            circle.y = window_height - circle.r
            circle.v_y = -circle.v_y
        end
    end
end

function love.draw()
    for i, circle in ipairs(circles) do
        love.graphics.circle("fill", circle.x, circle.y, circle.r)
    end
end
