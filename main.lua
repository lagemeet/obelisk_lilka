lilka.show_fps = true
position_of_cube = 241
local direction = 1 
local min_value = 240
local max_value = 320

function lilka.update(delta)
    state = controller.get_state()
    if not state.d.pressed then
        position_of_cube = position_of_cube + direction
        if position_of_cube >= max_value then
            direction = -5
        elseif position_of_cube <= min_value then
            direction = 5
        end
    end
end

function display_cube(size,display_x,display_y,color)

    local square_cords = {
    {0-size,0-size},
    {size,0-size,},
    {size,size},
    {0-size,size},
    {0-size,0-size}
    }
    local iso_square = {}
    function to_isometric(point)
        local x, y = point[1], point[2]
        local iso_x = x - y
        local iso_y = (x + y) / 2
        return {iso_x, iso_y}
    end

    for i, point in ipairs(square_cords) do
        iso_square[i] = to_isometric(point)
    end

    transformed_points = {}
    for i = 1, #iso_square - 1 do
        local p1 = iso_square[i]
        local p2 = iso_square[i + 1]
    
        local x1, y1 = display_x/2 + p1[1], display_y/2 + p1[2]
        local x2, y2 = display_x/2 + p2[1], display_y/2 + p2[2]

        table.insert(transformed_points, {x1, y1, x2, y2})
    end
    for i, point in ipairs(transformed_points) do
        display.draw_line(point[1],point[2],point[3],point[4],color)
        if(i > 1) then
            display.draw_line(point[1],point[2],point[1],point[2]+10,color);
            
        end
        if(i < 4)then
            if(i > 1) then
                display.draw_line(point[1],point[2]+10,point[3],point[4]+10,color)

            end
        end
        
    end
end

function display_stock_cube(size,display_x,display_y,color)

    local square_cords = {
    {0-size,0-size},
    {size,0-size,},
    {size,size},
    {0-size,size},
    {0-size,0-size}
    }
    local iso_square = {}
    function to_isometric(point)
        local x, y = point[1], point[2]
        local iso_x = x - y
        local iso_y = (x + y) / 2
        return {iso_x, iso_y}
    end

    for i, point in ipairs(square_cords) do
        iso_square[i] = to_isometric(point)
    end

    transformed_points = {}
    for i = 1, #iso_square - 1 do
        local p1 = iso_square[i]
        local p2 = iso_square[i + 1]
    
        local x1, y1 = display_x/2 + p1[1], display_y/2 + p1[2]
        local x2, y2 = display_x/2 + p2[1], display_y/2 + p2[2]

        table.insert(transformed_points, {x1, y1, x2, y2})
    end
    for i, point in ipairs(transformed_points) do
        if(i > 1) then
            display.draw_line(point[1],point[2],point[1],point[2]+10,color);
            
        end
        if(i < 4)then
            if(i > 1) then
                display.set_cursor(point[1],point[2])
                display.draw_line(point[1],point[2]+10,point[3],point[4]+10,color)
            end
        end
        
    end
end

function lilka.draw()   
    display.fill_screen(display.color565(0, 0, 0))
    display_stock_cube(20,280,420,display.color565(0, 255, 0))
    display_stock_cube(20,280,400,display.color565(0, 255, 255))
    display_cube(20,280,380,display.color565(255, 0, 0))
    
    display_cube(20,5,position_of_cube,360,display.color565(255, 255, 255))


    if state.a.pressed then
        util.exit()
    end
    
end

function lilka.init()
    
end