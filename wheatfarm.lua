-- farm an arbitrarily large, walled off wheat field

function farmBlock()
    local success, data = turtle.inspectDown()
    if not success then
        return
    end
  
    -- If block below is farmland
    if data.name == "minecraft:farmland" then
        print("farmland")
    elseif data.name == "minecraft:wheat" then
        print("wheat")
    end
end

function main()
    farmBlock()
    farmBlock()
    farmBlock()
end

main()