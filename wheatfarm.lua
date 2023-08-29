-- Constants for fuel
local FUEL_THRESHOLD = 10
local REFUEL_SLOT = 16

-- Function to check and refuel the turtle
function checkFuel()
    -- Check for fuel mode
    if turtle.getFuelLevel() == "unlimited" then
        return
    end

    if turtle.getFuelLevel() < FUEL_THRESHOLD then
        print("Waiting for fuel...")
        turtle.select(REFUEL_SLOT)
        while turtle.getFuelLevel() < FUEL_THRESHOLD do
            -- refuel as much as possible
            turtle.refuel()
            os.sleep(10)
        end
        print("Refueled to " .. turtle.getFuelLevel())
    end
end

-- Function to move seeds to the first slot after harvesting
function moveSeedsToFirstSlot()
    for i = 2, 16 do  -- Skip the first slot, search through slots 2-16
        turtle.select(i)
        local itemDetail = turtle.getItemDetail()
        if itemDetail and itemDetail.name == "minecraft:wheat_seeds" then
            turtle.transferTo(1)  -- Move seeds to the first slot
            break
        end
    end
end

-- Deposit all items except seeds
function depositItems()
    for i = 1, 16 do
        turtle.select(i)
        local itemDetail = turtle.getItemDetail()
        if itemDetail and itemDetail.name ~= "minecraft:wheat_seeds" then
            turtle.drop()
        end
    end
end

-- Inspect and take action based on the block below the turtle
function inspect()
    -- Check fuel before any action
    checkFuel()

    local success, data = turtle.inspectDown()

    if success and data.name == "minecraft:wheat" then
        if data.state.age == 7 then
            -- Before harvesting, select the 2nd slot
            turtle.select(2)
            turtle.digDown()

            -- Then, move seeds to the first slot and reselect
            moveSeedsToFirstSlot()
            turtle.select(1)
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
    
    if success then
        if mode == "forward" then
            turtle.turnRight()
            success, data = turtle.inspect()
            if success then
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
            if success then
                turtle.turnRight()
                turtle.turnRight()
                return "returning"
            else
                turtle.forward()
                turtle.turnLeft()
                return "forward"
            end
        elseif mode == "returning" then
            print("Returning to start")
            success, data = turtle.inspect()
            if success then
                -- Deposit items
                -- Moving this to the inventory management system
                --turtle.turnLeft()
                --depositItems()
                --turtle.turnRight()
                turtle.turnRight()

                print("Farm complete. Restarting in 180s")
                print("Fuel level: " .. turtle.getFuelLevel())
                os.sleep(180)

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
