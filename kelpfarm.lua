-- version 1.0.0

local args = {...}
turn_right = true

-- If there is one argument, the turtle should turn left instead of right
if #args == 1 then
    turn_right = false
    print("Turning left when depositing.")
else
    print("Turning right when depositing.")
end

-- Most Basic Kelp Harvesting Script
numKelpHarvested = 0

-- Function to deposit kelp into a chest
function deposit()
    -- check if turn_right is true to determine which direction to turn
    if turn_right then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end

    turtle.drop()  -- Drop the item into the chest

    -- check if turn_right is true to determine which direction to turn
    if turn_right then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end
end

while true do
    -- Check if there is a block in front (assuming kelp)
    if turtle.detect() then
        print("Kelp detected! Harvesting...")
        turtle.dig()      -- Dig the block, breaking the kelp
        deposit()         -- Deposit the kelp into a chest next to the turtle        
        numKelpHarvested = numKelpHarvested + 1
        print("Harvested " .. numKelpHarvested .. " kelp so far.")
    end

    sleep(10)
end
