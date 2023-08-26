-- Advanced mining turtle
local args = {...}
if #args < 2 then
    print("Usage: mining_turtle <initial_elevation> <target_y>")
    return
end

local initialElevation = tonumber(args[1])
local targetY = tonumber(args[2])
if targetY < -58 then
    print("Target Y capped at -58")
    targetY = -58
end

local currentElevation = initialElevation
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
    if turtle.getFuelLevel() < math.abs(currentElevation - initialElevation) + 10 then
        print("Low fuel! Resurfacing.")
        resurface()
    else
        refuel()
    end
end

function resurface()
    while currentElevation ~= initialElevation do
        if currentElevation < initialElevation then
            turtle.up()
            currentElevation = currentElevation + 1
        else
            turtle.down()
            currentElevation = currentElevation - 1
        end
        turtle.forward()
    end
end

if not checkInventory() then
    print("Missing essential items (ladder or blocks). Exiting.")
    return
end

while true do
    checkFuel()

    -- Dig the main shaft
    turtle.digDown()
    turtle.down()
    currentElevation = currentElevation - 1

    -- Move to the side shaft
    turtle.forward()
    
    -- Dig the side shaft
    turtle.digDown()
    turtle.down()
    currentElevation = currentElevation - 1

    -- Place the ladder in the main shaft
    turtle.back()
    if not turtle.detectDown() then
        turtle.select(blockSlot)
        turtle.placeDown()
    end
    turtle.select(ladderSlot)
    turtle.placeUp()
    
    if currentElevation <= targetY then
        print("Target depth reached. Resurfacing.")
        resurface()
        break
    end

    print("Current elevation: " .. currentElevation)
end

print("Mining complete!")
