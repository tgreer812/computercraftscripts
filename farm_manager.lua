-- Initialize chest peripheral
local chest = peripheral.wrap("left")
local monitor = peripheral.wrap("right")

-- Function to clear the monitor screen
function clearMonitor()
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Function to update the monitor
function updateMonitor()
    clearMonitor()
    local seedCount = 0
    local fuelCount = 0
    local wheatCount = 0
    local items = chest.list()
    
    for slot, item in pairs(items) do
        if item["name"] == "minecraft:wheat_seeds" then
            seedCount = seedCount + item["count"]
        end
        if item["name"] == "minecraft:dried_kelp_block" then
            fuelCount = fuelCount + item["count"]
        end
        if item["name"] == "minecraft:wheat" then
            wheatCount = wheatCount + item["count"]
        end
    end

    monitor.write("Status:")
    monitor.setCursorPos(1, 2)
    monitor.write("Wheat: " .. wheatCount)
    monitor.setCursorPos(1, 3)
    monitor.write("Seeds: " .. seedCount)
    monitor.setCursorPos(1, 4)
    monitor.write("Fuel: " .. fuelCount)
end

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
    updateMonitor()  -- Update the monitor after inventory management
end

-- Main function
function main()
    updateMonitor()

    while true do
        local event, side = os.pullEvent("peripheral")
        if side == "back" then
            manageTurtleInventory()
        end
        os.sleep(5)
    end
end

main()
