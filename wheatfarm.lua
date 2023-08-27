-- Constants for fuel
local FUEL_THRESHOLD = 10
local REFUEL_SLOT = 16

-- Function to check and refuel the turtle
function checkFuel()
    if turtle.getFuelLevel() < FUEL_THRESHOLD then
        print("Low fuel! Attempting to refuel...")
        turtle.select(REFUEL_SLOT)
        while turtle.getFuelLevel() < FUEL_THRESHOLD do
            -- refuel as much as possible
            turtle.refuel()
            os.sleep(10)
        end
        print("Refueled!")
    end
end

-- Inspect and take action based on the block below the turtle
function inspect()
    -- Check fuel before any action
    checkFuel()

    local success, data = turtle.inspectDown()

    if success and data.name == "minecraft:wheat" then
        print("Harvesting...")
        if data.metadata == 7 then
            turtle.digDown()
        end
        turtle.select(1)
        turtle.placeDown()

        return
    end

    -- Before we do anything else, check if we have wheat to plant
    if turtle.getItemCount(1) == 0 then
        print("Out of wheat!")
        return
    end

    -- Attempt to plant a seed if there is no wheat
    local success = turtle.placeDown()
    if success then
        return
    end

    -- Attempt to till the ground if there is no seed
    turtle.down()
    success, data = turtle.inspectDown()
    if success and (data.name == "minecraft:dirt" or data.name == "minecraft:grass_block") then
        print("Tilling and planting...")
        turtle.up()
        turtle.digDown()
        turtle.select(1)
        turtle.placeDown()
        return
    else
        turtle.up()
    end
end

-- Move the turtle based on its mode
function move(mode)
    -- Check fuel before moving
    checkFuel()

    local success, data = turtle.inspect()
    
    if success and data.name == "minecraft:cobblestone" then
        if mode == "forward" then
            turtle.turnRight()
            success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnRight()
                return "backward"
            else
                turtle.forward()
                turtle.turnRight()
                return "backward"
            end
        elseif mode == "backward" then
            turtle.turnLeft()
            success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnRight()
                turtle.turnRight()
                print("Returning to start")
                return "returning"
            else
                turtle.forward()
                turtle.turnLeft()
                return "forward"
            end
        elseif mode == "returning" then
            print("Returning to start")
            success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnRight()
                print("Farm complete. Restarting in 60s")
                os.sleep(60)
                return "forward"
            else
                turtle.forward()
                return "returning"
            end
        end
    else
        turtle.forward()
        return mode
    end
end

-- Main function to orchestrate farming
function main()
    local mode = "forward"
    while true do
        inspect()
        mode = move(mode)
    end
end

-- Start the farming
main()
