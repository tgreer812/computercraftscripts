-- Initialize chest peripheral
local chest = peripheral.wrap("left")
local monitor = peripheral.wrap("right")

-- Function to find specific item slot in chest
function findItem(itemName)
    local items = chest.list()
    for slot, item in pairs(items) do
        if item["name"] == itemName then
            return slot
        end
    end
    return nil
end

-- Function to manage turtle's inventory
function manageTurtleInventory()
    print("Turtle docked. Managing inventory...")
    -- We assume that the turtle is on the "back" side, but you can adjust as needed.

    -- Find slots containing seeds and fuel in the chest
    local seedSlot = findItem("minecraft:wheat_seeds")
    local fuelSlot = findItem("minecraft:dried_kelp_block")

    -- Refill seeds and fuel in turtle from the chest
    if seedSlot then
        chest.pushItems("back", seedSlot, 64, 1)  -- Fill seeds to turtle's first slot
    end
  
    if fuelSlot then
        chest.pushItems("back", fuelSlot, 64, 16)  -- Fill fuel to turtle's 16th slot
    end
  
    print("Inventory management complete.")
end

-- Main function
function main()
    while true do
        local event, side = os.pullEvent("peripheral")
        if side == "back" then
            manageTurtleInventory()
        end
        os.sleep(5)
    end
end

main()
