-- Advanced mining turtle
local args = {...}
if #args < 2 then
    print("Usage: minerscript <initial_elevation> <target_y>")
    return
end

local initialElevation = tonumber(args[1])
local targetY = tonumber(args[2])

if targetY < -58 then
    print("Target Y capped at -58")
    targetY = -58
end

local delta = initialElevation - targetY
local moved = 0
local ladderSlot, blockSlot, coalSlot = 0, 0, 0

function checkInventory()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item then
            if item.name:find("ladder") then
                ladderSlot = i
            elseif item.name:find("coal") then
                coalSlot = i
            else
                blockSlot = i
            end
        end
    end
    return ladderSlot > 0 and blockSlot > 0
end

function refuel()
    if coalSlot > 0 then
        turtle.select(coalSlot)
        turtle.refuel(1)
        print("Refueled. Current fuel level: " .. turtle.getFuelLevel())
    end
end

function checkFuel()
    if turtle.getFuelLevel() < (moved + 1) * 2 + 10 then
        print("Low fuel! Resurfacing.")
        resurface(moved)
        return false
    else
        refuel()
        return true
    end
end

function resurface(blocksToMove)
    -- Turn right, move to the second shaft
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()

    -- Move up the second shaft
    for i = 1, blocksToMove + 1 do
        turtle.up()
    end
end

if not checkInventory() then
    print("Missing essential items (ladder or blocks). Exiting.")
    return
end

while moved < delta do
    if not checkFuel() then
        print("Resurfaced due to low fuel. Exiting.")
        break
    end

    -- Dig down in Shaft 1
    turtle.digDown()

    -- Move down so it's in shaft 1
    turtle.down()
    moved = moved + 1

    -- Turn right so it's facing shaft 2
    turtle.turnRight()

    -- Dig block in shaft 2
    turtle.dig()

    -- Turn left to face the wall the ladders will be placed on
    turtle.turnLeft()

    -- Place a block in front if no block exists
    if not turtle.detect() then
        turtle.select(blockSlot)
        turtle.place()
    end

    -- Place the ladder above it in shaft 1
    turtle.select(ladderSlot)
    turtle.placeUp()

    if moved >= delta then
        print("Target depth reached. Resurfacing.")
        resurface(moved)
        break
    end

    print("Blocks moved: " .. moved)
end

print("Mining complete!")
