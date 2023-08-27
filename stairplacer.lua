-- Initialize variables
local step_count = 0  -- Count of steps the turtle has moved
local air_count = 0  -- Count of consecutive air blocks detected
local stairSlot = 0  -- Slot containing stairs

-- Function to find the stairs in the inventory
function findStairs()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item and item.name:find("stair") then
            stairSlot = i
            break
        end
    end
end

-- Check for stairs in inventory
findStairs()
if stairSlot == 0 then
    print("No stairs found in inventory. Exiting.")
    return
end

-- Main loop
while true do
    -- Select the slot containing stairs
    turtle.select(stairSlot)

    if turtle.detect() then  -- If there's a block in front of the turtle
        -- Reset the air count because a block is detected
        air_count = 0  

        -- Place the stair
        turtle.place()

        -- Move up one block and forward one block
        turtle.up()
        turtle.forward()

        -- Increment the step_count
        step_count = step_count + 1
    else
        -- An air block is detected, increment air_count
        air_count = air_count + 1
    end

    -- Check for surface based on consecutive air blocks
    if air_count >= 3 then
        print("Surface detected. Stopping.")
        break  -- Turtle has reached the surface, exit loop
    end
end

print("Staircase complete! Moved " .. step_count .. " steps.")
