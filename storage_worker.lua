-- Constants
local HEIGHT = 2  -- Maximum height of the chest stack
local SLOTS = 16  -- Number of inventory slots in the turtle

-- Item to forward position mapping
local itemToForwardMapping = {
    ["minecraft:wheat"] = 1,
    ["minecraft:wheat_seeds"] = 2,
    ["minecraft:iron_ore"] = 3
}

-- Function to move the turtle to the target position
local function goToPosition(forwardIndex)
    -- Get out of the starting position
    turtle.forward()
    turtle.forward()

    for i = 1, forwardIndex do
        turtle.forward()
    end
end

-- Function to return the turtle to the starting position
local function returnToStart(forwardIndex, heightIndex)
    for i = 1, heightIndex do
        turtle.down()
    end
    for i = 1, forwardIndex do
        turtle.forward()
    end
end

-- Check if the turtle can deposit items in the chest at its side
local function canDeposit(side)
    local chest = peripheral.wrap(side)
    --TODO: check if chest has any space
    return chest and chest.size() > 0
end

-- Deposit items into the appropriate chest
local function depositItem(item)
    local forwardIndex = itemToForwardMapping[item]
    if not forwardIndex then
        print("Unmapped item: " .. item)
        return
    end

    local heightIndex = 0
    local deposited = false

    -- Move to the correct forward position
    goToPosition(forwardIndex)

    while not deposited and heightIndex < HEIGHT do
        if canDeposit("left") then
            turtle.turnLeft()
            turtle.drop()
            turtle.turnLeft()
            deposited = true
        elseif canDeposit("right") then
            turtle.turnRight()
            turtle.drop()
            turtle.turnRight()
            deposited = true
        else
            -- Move up and continue checking
            turtle.up()
            heightIndex = heightIndex + 1
        end
    end

    if not deposited then
        print("Chest overflow for item: " .. item)
    else
        returnToStart(forwardIndex, heightIndex)
    end
end

-- Main loop
while true do
    -- Simulate the turtle having an inventory with "wheat_seeds"
    -- Normally you would go through the turtle's actual inventory
    depositItem("minecraft:wheat_seeds")

    -- Delay to prevent overwhelming the system
    os.sleep(2)
end
