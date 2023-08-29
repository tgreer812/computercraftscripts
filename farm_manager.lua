-- Initialize chest peripheral
local chest = peripheral.wrap("right")

-- Function to manage turtle's inventory
function manageTurtleInventory()
    print("Turtle docked. Managing inventory...")
    local turtle = peripheral.wrap("back")

    print(turtle.size())
  
    --[[
    -- Move all items from turtle to chest
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop()
    end
    ]]--

    -- Refill seeds and fuel in turtle from the chest
    local seedSlot = chest.findItem("minecraft:wheat_seeds")
    local fuelSlot = chest.findItem("minecraft:kelp_block")
  
    if seedSlot then
        chest.pushItems("front", seedSlot, 64, 1)  -- Fill seeds to turtle's first slot
    end
  
    if fuelSlot then
        chest.pushItems("front", fuelSlot, 64, 16)  -- Fill fuel to turtle's 16th slot
    end
  
    print("Inventory management complete.")
end

-- Main function
function main()
    local event, side = os.pullEvent("peripheral")
    if side == "back" then
        manageTurtleInventory()
    end
end

main()
