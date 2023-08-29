while true do
    local peripherals = peripheral.getNames()
    for _, name in pairs(peripherals) do
        print(name)
        print(peripheral.getType(name))
        if peripheral.getType(name) == "YourTurtleNameHere" then
            manageTurtleInventory()
        end
    end
    sleep(1)
end
