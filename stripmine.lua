-- Strip mine turtle script
local args = {...}
if #args < 1 then
    print("Usage: strip_mine <distance>")
    return
end

local distance = tonumber(args[1])
local blockSlot = 0  -- Initialize variable for block slot

-- Function to scan inventory for usable blocks
function scanForBlocks()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item then
            if not item.name:find("coal") then  -- Exclude coal for fuel
                blockSlot = i
                return true
            end
        end
    end
    return false
end

-- Function to check if a block is underneath and place one if not
function checkAndPlaceBlockBelow()
    local success, block = turtle.inspectDown()
    if not success then
        turtle.select(blockSlot)
        turtle.placeDown()
    end
end

-- Main script
if not scanForBlocks() then
    print("No usable blocks found in inventory. Exiting.")
    return
end

for i = 1, distance do
    -- Dig forward and move
    turtle.dig()
    turtle.forward()

    -- Dig the block above
    turtle.digUp()

    -- Check for a block underneath and place one if not
    checkAndPlaceBlockBelow()
end

print("Strip mining complete!")
