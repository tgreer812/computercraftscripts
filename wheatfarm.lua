-- Farming Script for CC:Tweaked Turtle in 
-- an Arbitrarily Large Wheat Field surrounded
-- by a Cobblestone Wall

function inspect()
    local success, data = turtle.inspectDown()

    -- If the block is wheat, check if it's fully grown
    if success and data.name == "minecraft:wheat" then
        print("wheat")
        if data.metadata == 7 then
            turtle.digDown()
        end
        turtle.select(1)
        turtle.placeDown()
        return
    end

    -- Otherwise, go down and check if it's dirt
    turtle.down()
    success, data = turtle.inspectDown()
    if success and data.name == "minecraft:dirt" then
        print("dirt")
        turtle.digDown()
        turtle.select(1)
        turtle.placeDown()
    end
    turtle.up()
end

function move(mode)
    local success, data = turtle.inspect()
    
    if success and data.name == "minecraft:cobblestone" then
        if mode == "forward" then
            print("Turning right from forward mode")
            turtle.turnRight()
            
            success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnRight()
                print("Moving to backward mode")
                return "backward"
            else
                turtle.forward()
                turtle.turnRight()
                return "backward"
            end

        elseif mode == "backward" then
            print("Turning left from backward mode")
            turtle.turnLeft()
            
            success, data = turtle.inspect()
            if success and data.name == "minecraft:cobblestone" then
                turtle.turnRight()
                print("Completed the farm, moving to returning mode")
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
                print("Reached the start, moving to forward mode")
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

function main()
    local mode = "forward"
    while true do
        inspect()
        mode = move(mode)
    end
end

main()
