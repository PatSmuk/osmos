local circles = {}

local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()
local spawn_timer = 12

-- Initialize 20 circles with random parameters.
for i = 1, 20 do
    table.insert(circles, {
        x = math.random(window_width),      -- 1..(window width)
        y = math.random(window_height),     -- 1..(window height)
        v_x = (math.random() - 0.5) * 50,   -- (-25)..25
        v_y = (math.random() - 0.5) * 50,   -- (-25)..25
        r = math.random(40) + 12,           -- 13..53
        intersects = false
    })
end

function intersectionAmount(c1, c2)
    local dist = math.sqrt(math.pow(c1.x - c2.x, 2) + math.pow(c1.y - c2.y, 2))
    return math.max(c1.r + c2.r - dist, 0)
end

function love.update(dt)
    if love.keyboard.isDown("space") then
        table.insert(circles, {
            x = math.random(window_width),      -- 1..(window width)
            y = math.random(window_height),     -- 1..(window height)
            v_x = (math.random() - 0.5) * 50,   -- (-25)..25
            v_y = (math.random() - 0.5) * 50,   -- (-25)..25
            r = math.random(40) + 12,           -- 13..53
            intersects = false
        })
    end

    if spawn_timer > 0 then
        spawn_timer = spawn_timer - 1
    else
        table.insert(circles, {
            x = math.random(window_width),      -- 1..(window width)
            y = math.random(window_height),     -- 1..(window height)
            v_x = (math.random() - 0.5) * 50,   -- (-25)..25
            v_y = (math.random() - 0.5) * 50,   -- (-25)..25
            r = math.random(40) + 12,           -- 13..53
            intersects = false
        })
        spawn_timer = 12
    end

    -- For each circle...
    for i, circle in ipairs(circles) do
        -- Reset the intersection status to false.
        circle.intersects = false

        -- Update the position.
        circle.x = circle.x + circle.v_x * dt
        circle.y = circle.y + circle.v_y * dt

        -- If we're too far left, put it back in the screen and move to the right.
        if circle.x - circle.r < 0 then
            circle.x = 0 + circle.r
            circle.v_x = -circle.v_x
        -- If we're too far right...
        elseif circle.x + circle.r > window_width then
            circle.x = window_width - circle.r
            circle.v_x = -circle.v_x
        end

        -- If we're too far up...
        if circle.y - circle.r < 0 then
            circle.y = 0 + circle.r
            circle.v_y = -circle.v_y
        -- If we're too far down...
        elseif circle.y + circle.r > window_height then
            circle.y = window_height - circle.r
            circle.v_y = -circle.v_y
        end

        -- For each circle (again)...
        for other_i, other_circle in ipairs(circles) do
            -- Make sure this is one of the circles that comes before this one (so it doesn't get reset later).
            if other_i < i then
                -- If they intersect, set the intersection status for this circle and the other.
                -- Don't care if it's already intersecting a third circle here.
                local intersection = intersectionAmount(circle, other_circle)
                if intersection > 0 then
                    circle.intersects = true
                    other_circle.intersects = true

                    if circle.r > other_circle.r then
                        other_circle.r = math.max(other_circle.r - intersection, 0)
                    else
                        circle.r = math.max(circle.r - intersection, 0)
                    end
                end
            end
        end
    end

    -- For each circle (backwards)...
    for i = #circles, 1, -1 do
        -- If the circle has radius 0...
        if circles[i].r == 0 then
            -- Get rid of it!
            table.remove(circles, i)
        end
    end
end

function love.draw()
    -- For each circle...
    for i, circle in ipairs(circles) do
        -- If it intersects another draw it red.
        if circle.intersects then
            love.graphics.setColor(239, 67, 67)
        else
            -- Otherwise make it white.
            love.graphics.setColor(255, 255, 255)
        end
        -- Draw the circle.
        love.graphics.circle("fill", circle.x, circle.y, circle.r)
    end
end
