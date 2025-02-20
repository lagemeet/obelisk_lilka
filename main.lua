lilka.show_fps = true
debug = false
score = 0
stock_position = 280
stack = {
    {280,280,40,255,0,0},
    {280,300,40,0,255,0},
    {280,320,40,0,0,255},
    {280,340,40,255,0,255}
    -- {280,280,40,255,0,0},
    -- {280,300,40,0,255,0},
    -- {280,320,40,0,0,255},
    -- {280,340,40,255,255,255}

    }

position_of_cube = 160
local direction = 5
local min_value = 160
local max_value = 400

function lilka.update(delta)
    state = controller.get_state()

    if not state.d.just_pressed then
        position_of_cube = position_of_cube + direction
        if position_of_cube >= max_value then
            direction = -5
        elseif position_of_cube <= min_value then
            direction = 5
        end
    else
        place_block()
    end

    if state.a.pressed then
        util.exit()
    end
    
end


function push_and_trim(tbl, newElement)

    table.insert(tbl, newElement)
    table.remove(tbl, 1)

end

function update_y_axes()
    for i = 1, #stack do
        curr_x, curr_y, curr_w, r, g, b = table.unpack(stack[i])
        curr_y = 280 + (20*i)
        stack[i][2] = curr_y
    end 
end


function display_cube(L, W, H, display_x, display_y,color)
    local function to_isometric(x, y, z)
        local x_i = x - y
        local y_i = (z / 2) + (x + y) / 2
        return x_i, y_i
    end
    local vertices = {
        {0, 0, 0},
        {L, 0, 0},
        {L, W, 0},
        {0, W, 0},
        {0, 0, H},
        {L, 0, H},
        {L, W, H},
        {0, W, H}
    }
    
    local projected_vertices = {}
    for i, v in ipairs(vertices) do
        local x_i, y_i = to_isometric(v[1], v[2], v[3])
        table.insert(projected_vertices, {x_i, y_i})
    end

    local edges = {
        {1, 2}, {2, 3}, {3, 4}, {4, 1},  -- Bottom 
        {5, 6}, {6, 7}, {7, 8}, {8, 5},  -- Top 
        {1, 5}, {2, 6}, {3, 7}, {4, 8}   -- Vertical
    }

    for _, edge in ipairs(edges) do
        local x1, y1 = display_x/2 + projected_vertices[edge[1]][1], display_y/2 + projected_vertices[edge[1]][2]
        local x2, y2 = display_x/2 + projected_vertices[edge[2]][1], display_y/2 + projected_vertices[edge[2]][2]
        if (debug) then
            display.set_cursor(x1,y1)
            display.print(_)
        end
        display.draw_line(x1, y1, x2, y2, color)
    end
end

    --{280,340,40,math.random(120, 255),math.random(120, 255),math.random(120, 255)}

function place_block()
    
    prev_x, prev_y, prev_w = table.unpack(stack[2])
    -- curr_x, curr_y, curr_w = table.unpack(stack[#stack])
    if (position_of_cube < prev_x) then
        if not (score > 0) then
            curr_w=40
        end
            overlap = position_of_cube + curr_w - prev_x
            if (debug) then
                print(overlap)
            end
            if (overlap <= 0) then
                util.exit()
            else
                score = score + 1
            end
        local new_block = {position_of_cube,stock_position,overlap,math.random(120, 255),math.random(120, 255),math.random(120, 255)}
        push_and_trim(stack,new_block)
        update_y_axes()

            position_of_cube = 160

    elseif (position_of_cube > prev_x) then
        overlap = prev_x + prev_w - position_of_cube

            if (overlap <= 0) then
                util.exit()
            else
                score = score + 1
            end
        local new_block = {position_of_cube,stock_position,overlap,math.random(120, 255),math.random(120, 255),math.random(120, 255)}
        if (debug) then
            print(overlap)
        end
        if (score >= 1) then    -- {280,300,40,0,255,0},
            -- {280,320,40,0,0,255},
            -- {280,340,40,255,255,255}
        
            curr_w = overlap
        end
        push_and_trim(stack,new_block)
        update_y_axes()

            position_of_cube = 160

    
    end
 

end



function lilka.draw()   
    display.fill_screen(display.color565(0, 0, 0))
    display.set_cursor(200,200)
    display.print(score)

    for i=#stack,2,-1 do 
        curr_x, curr_y, curr_w, r, g, b = table.unpack(stack[i])
        display_cube(curr_w,40,20,curr_x,curr_y,display.color565(r,g,b))
        i = i - 1
    end
    curr_x, curr_y, curr_w, r, g, b = table.unpack(stack[4])    
    display_cube(40,curr_w,20,position_of_cube,stock_position,display.color565(255,255,255))


end

function lilka.init()
    
end