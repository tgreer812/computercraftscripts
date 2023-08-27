-- Stair creation script for a Turtle
local stairSlot = 0

-- Function to find stairs in the inventory
function findStairs()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item and item.name:find("stairs") then
            stairSlot = i
            return true
        end
    end
    return false
end

-- Function to detect if the turtle has reached the surface
function atSurface()
    local airCount = 0
    for i = 1, 5 do
        local success, data = turtle.inspectUp()
        if not success then
            airCount = airCount + 1
        end
    end
    return airCount >= 4
end

-- Main execution starts here
if not findStairs() then
    print("No stairs in inventory. Exiting.")
    return
end

while true do
    if atSurface() then
        print("Surface reached. Staircase completed.")
        break
    else
        turtle.up()
        turtle.select(stairSlot)
        turtle.placeDown()
        turtle.forward()
    end
end
