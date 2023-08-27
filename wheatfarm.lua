-- Farming Script for CC:Tweaked Turtle in 
-- an Arbitrarily Large Wheat Field surrounded
-- by a Cobblestone Wall

function inspect()
    local success, data = turtle.inspectDown()

    if not success then
        return
    end

    -- If block below is wheat
    if data.name == "minecraft:wheat" then
        print("Inspecting wheat...")
        -- If wheat is fully grown, harvest it
        if data.metadata == 7 then
            turtle.digDown()
        end
        turtle.select(1)  -- Seeds are assumed to be in slot 1
        turtle.placeDown()  -- Plant a seed if space is empty
        return
    end

    -- Otherwise, descend and check the block below
    turtle.down()
    local success, data = turtle.inspectDown()
    if success and data.name == "minecraft:dirt" then
        print("Inspecting dirt...")
        turtle.digDown()  -- Till the soil
        turtle.select(1)  -- Seeds are assumed to be in slot 1
        turtle.placeDown()  -- Plant a seed
    end
    turtle.up()  -- Ascend back to hover level
end

function move(mode)
    local success, data = turtle.inspect()
    
    if success and data.name == "minecraft:cobblestone" then
        if mode == "forward" then
            turtle.turnRight()
            
            local success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnRight()
                return "backward"
            else
                turtle.forward()
                turtle.turnRight()
                return "backward"
            end
        else
            turtle.turnLeft()
            
            local success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnLeft()
                return "forward"
            else
                turtle.forward()
                turtle.turnLeft()
                return "forward"
            end
        end
    else
        turtle.forward()
        return mode
    end
end

function main()
    local mode = "forward"

    while true do  -- Infinite loop for continuous farming
        -- Call inspect and move forward until hitting a cobblestone wall
        inspect()
        mode = move(mode)
    end
end

-- Run the main function
main()
