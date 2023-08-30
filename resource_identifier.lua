local STATION_ID = "farm_1"

local modem = peripheral.find("modem")
local generalChannel = 69

-- Attach to the chest on the right
local chest = peripheral.wrap("right")

-- Open the general channel for communication
modem.open(generalChannel)

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

            -- Create a response object containing stationID and resources in and out
            local response = {
                stationID = STATION_ID,
                resourcesIn = {},
                resourcesOut = {"wheat", "wheat_seeds"}
            }

            -- Transmit the response back to the turtle
            modem.transmit(replyChannel, generalChannel, textutils.serialize(response))

            -- Logic to push items to the turtle based on `inventoryStatus`
            for slot, item in pairs(response.resourcesOut) do
                local itemSlot = chest.findItem("minecraft:"..item)
                if itemSlot and (not inventoryStatus[slot] or inventoryStatus[slot].name == item) then
                    chest.pushItems("front", itemSlot, 64, slot)
                end
            end
            
            -- Once all is done, send a 'done' message back to the turtle to signal completion
            modem.transmit(replyChannel, generalChannel, "done")
        end
    end
end
