STATION_ID = "farm_1"

local modem = peripheral.find("modem")
local generalChannel = 69

-- Attach to the chest on the right
local chest = peripheral.wrap("right")

-- Open the general channel for communication
modem.open(generalChannel)

-- Helper function to check if a value exists in a table
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

while true do
    -- Wait for a modem message
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    
    -- Check if the distance is <= 3
    if distance <= 3 then
        -- Deserialize the incoming message to get the command and inventory status
        local request = textutils.unserialize(message)

        if request.command == "ping" then
            -- Inventory status of the turtle
            local inventoryStatus = request.inventory

            print("Inventory Status:")
            for i, v in pairs(inventoryStatus) do
                print(i, v)
            end


            -- Create a response object containing stationID and resources in and out
            local response = {
                stationID = STATION_ID,
                resourcesIn = {},
                resourcesOut = {"minecraft:wheat", "minecraft:wheat_seeds"}
            }

            print("Resources out:")
            for i, v in pairs(response.resourcesOut) do
                print(i, v)
            end


            -- Transmit the response back to the turtle
            modem.transmit(replyChannel, generalChannel, textutils.serialize(response))
            
            -- Logic to push items to the turtle based on `inventoryStatus`
            local nextEmptySlot = 1
            print("chest size is " .. chest.size())
            for slot = 1, chest.size() do
                local itemDetail = chest.getItemDetail(slot)
                if itemDetail then
                    print("Found item in slot: " .. slot .. " Name: " .. itemDetail.name)
                end
                if itemDetail and table.contains(response.resourcesOut, itemDetail.name) then
                    -- Find the next empty slot in the turtle's inventory
                    while inventoryStatus[nextEmptySlot] do
                        nextEmptySlot = nextEmptySlot + 1
                    end
                    -- If nextEmptySlot exceeds 16, the turtle is full
                    if nextEmptySlot > 16 then
                        break
                    end
                    chest.pushItems("front", slot, 64, nextEmptySlot)
                    inventoryStatus[nextEmptySlot] = itemDetail
                end
            end
            
            -- Once all is done, send a 'done' message back to the turtle to signal completion
            modem.transmit(replyChannel, generalChannel, "done")
        end
    end
end
