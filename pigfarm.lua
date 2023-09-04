-- Constants for fuel
local MAX_MEAT_COUNT = 3

-- Deposit all items except seeds and fuel
function depositItems()
    for i = 1, 16 do
        turtle.select(i)
        local itemDetail = turtle.getItemDetail()
        if itemDetail then
            turtle.drop()
        end
    end
end

-- Inspect and take action based on the block below the turtle
function action(routine)

    if routine == "Cull" then
        print("Culling.")
        turtle.attackDown()

        -- Before we do anything else, check if we have enough meat

        local meat_count = 0;
        for i = 1,16 do
            meat_count = meat_count + turtle.getItemCount(i)
        end

        if meat_count >= MAX_MEAT_COUNT then
            print("Cull successful.")
            return "Return"
        else
            return "Cull"
        end
    else
        return routine
    end
end

function reset(routine)
    if routine == "Return" then
        local success, data = turtle.inspect()
        if success and data.name == "minecraft:chest" then
            depositItems()
            print("Return successful.")
            turtle.turnLeft()
            os.sleep()
            return "End"
        else
            return "Return"
        end
    else
        print("Searching.")
        return routine
    end
end
-- Move the turtle based on its mode
function move()
    local success, data = turtle.inspect()
    if success then
        turtle.turnLeft()
        success, data = turtle.inspect()
        if success then
            turtle.turnLeft()
            return
        else
            return
        end
    else
        turtle.forward()
        return
    end
end

-- Main function to orchestrate farming
function main()
    rednet.open("left")  -- Replace "side" with the side where the modem is placed.

    while true do
        local senderID, message = rednet.receive()
        print("Received message from" .. senderID .. ": " .. message)

        local routine = message

        while routine == "Cull" do
            move()
            routine = action(routine)
        end

        while routine == "Return" do
            move()
            routine = reset(routine)
        end
    end

    rednet.close()
end

-- Start the farming
main()
