-- version 1.0.0

local args = {...}
if #args < 3 then
    print("Usage: flatten <Width> <Length> <Height>")
    return
end

local turn_right = true
local width = tonumber(args[1])
local length = tonumber(args[2])
local height = tonumber(args[3])

local search_for_blocks = true
local blockNames = {"minecraft:dirt", "minecraft:grass", "minecraft:cobblestone", "minecraft:stone"}

local function hasBlock(name)
    if not search_for_blocks then return false end
    
    for slot = 1, 16 do
        turtle.select(slot)
        local data = turtle.getItemDetail()
        if data and data.name == name then
            return true
        end
    end
    return false
end

local function placeBlock()
    for _, name in ipairs(blockNames) do
        if hasBlock(name) then
            turtle.placeDown()
            return true
        end
    end
    search_for_blocks = false
    return false
end

local function forward()
    if turtle.dig() then
        search_for_blocks = true
    end
    while not turtle.forward() do
        turtle.attack()
        sleep(0.5)
    end
end

local function up()
    while not turtle.up() do
        turtle.digUp()
        sleep(0.5)
    end
end

local function turn_around()
    if turn_right then
        turtle.turnRight()
        turtle.dig()
        forward()
        turtle.turnRight()
        turn_right = false
    else    
        turtle.turnLeft()
        turtle.dig()
        forward()
        turtle.turnLeft()
        turn_right = true      
    end
end

local function reset()
    turtle.turnRight()
    if turn_right then
        turtle.turnRight()
        for z = 1, length, 1 do
            forward()
        end
        turtle.turnRight()
    end
    for x = 1, width - 1, 1 do
        forward()
    end
    turtle.turnRight()
    turtle.digUp()
    up()
end

print("Flattening initiated...")
for y = 1, height do
    turtle.select(1)
    turtle.refuel()
    turn_right = true
    for x = 1, width, 1 do
        for z = 1, length, 1 do
            turtle.dig()
            forward()
            if y == 1 then
                placeBlock()
            end
        end
        if x < width then
            turn_around()
        else
            reset()
        end
    end
    print("Layer completed, " .. height - y .." left to go.")
end

print("Flattening complete.")
