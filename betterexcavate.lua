-- Modified excavate to take length, width, and height as command line arguments
local tArgs = { ... }
if #tArgs ~= 3 then
    print("Usage: excavate <length> <width> <height>")
    return
end

local length = tonumber(tArgs[1])
local width = tonumber(tArgs[2])
local height = tonumber(tArgs[3])

local depth = 0
local unloaded = 0
local collected = 0

local xPos, zPos = 0, 0
local xDir, zDir = 0, 1

-- (the rest of the utility functions like unload, collect, refuel, tryForwards, etc can stay the same)
local function unload( _bKeepOneFuelStack )
	print( "Unloading items..." )
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount > 0 then
			turtle.select(n)			
			local bDrop = true
			if _bKeepOneFuelStack and turtle.refuel(0) then
				bDrop = false
				_bKeepOneFuelStack = false
			end			
			if bDrop then
				turtle.drop()
				unloaded = unloaded + nCount
			end
		end
	end
	collected = 0
	turtle.select(1)
end

local function returnSupplies()
	local x,y,z,xd,zd = xPos,depth,zPos,xDir,zDir
	print( "Returning to surface..." )
	goTo( 0,0,0,0,-1 )
	
	local fuelNeeded = 2*(x+y+z) + 1
	if not refuel( fuelNeeded ) then
		unload( true )
		print( "Waiting for fuel" )
		while not refuel( fuelNeeded ) do
			os.pullEvent( "turtle_inventory" )
		end
	else
		unload( true )	
	end
	
	print( "Resuming mining..." )
	goTo( x,y,z,xd,zd )
end

local function collect()	
	local bFull = true
	local nTotalItems = 0
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			bFull = false
		end
		nTotalItems = nTotalItems + nCount
	end
	
	if nTotalItems > collected then
		collected = nTotalItems
		if math.fmod(collected + unloaded, 50) == 0 then
			print( "Mined "..(collected + unloaded).." items." )
		end
	end
	
	if bFull then
		print( "No empty slots left." )
		return false
	end
	return true
end

function refuel( ammount )
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" then
		return true
	end
	
	local needed = ammount or (xPos + zPos + depth + 2)
	if turtle.getFuelLevel() < needed then
		local fueled = false
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < needed do
						turtle.refuel(1)
					end
					if turtle.getFuelLevel() >= needed then
						turtle.select(1)
						return true
					end
				end
			end
		end
		turtle.select(1)
		return false
	end
	
	return true
end

local function tryForwards()
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
	
	while not turtle.forward() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end
	
	xPos = xPos + xDir
	zPos = zPos + zDir
	return true
end

local function tryDown()
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
	
	while not turtle.down() do
		if turtle.detectDown() then
			if turtle.digDown() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attackDown() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end

	depth = depth + 1
	if math.fmod( depth, 10 ) == 0 then
		print( "Descended "..depth.." metres." )
	end

	return true
end

local function turnLeft()
	turtle.turnLeft()
	xDir, zDir = -zDir, xDir
end

local function turnRight()
	turtle.turnRight()
	xDir, zDir = zDir, -xDir
end

function goTo( x, y, z, xd, zd )
	while depth > y do
		if turtle.up() then
			depth = depth - 1
		elseif turtle.digUp() or turtle.attackUp() then
			collect()
		else
			sleep( 0.5 )
		end
	end

	if xPos > x then
		while xDir ~= -1 do
			turnLeft()
		end
		while xPos > x do
			if turtle.forward() then
				xPos = xPos - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif xPos < x then
		while xDir ~= 1 do
			turnLeft()
		end
		while xPos < x do
			if turtle.forward() then
				xPos = xPos + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	end
	
	if zPos > z then
		while zDir ~= -1 do
			turnLeft()
		end
		while zPos > z do
			if turtle.forward() then
				zPos = zPos - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif zPos < z then
		while zDir ~= 1 do
			turnLeft()
		end
		while zPos < z do
			if turtle.forward() then
				zPos = zPos + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while depth < y do
		if turtle.down() then
			depth = depth + 1
		elseif turtle.digDown() or turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	
	while zDir ~= zd or xDir ~= xd do
		turnLeft()
	end
end

print("Excavating with dimensions " .. length .. "x" .. width .. "x" .. height)

local done = false
for h = 1, height do
    for w = 1, width do
        for l = 1, length do
            if not tryForwards() then
                done = true
                break
            end
        end
        if done then break end
        
        if w < width then
            turnRight()
            if not tryForwards() then
                done = true
                break
            end
            turnLeft()
        end
    end
    if done then break end
    
    -- Return to starting point for this layer
    turnLeft()
    for l = 1, length do
        if not tryForwards() then
            done = true
            break
        end
    end
    turnRight()
    for w = 1, width - 1 do
        if not tryForwards() then
            done = true
            break
        end
    end
    turnRight()

    if h < height then
        if not tryDown() then
            done = true
            break
        end
    end
end


-- (Returning to the surface and unloading code can remain the same)
print( "Returning to surface..." )

-- Return to where we started
goTo( 0,0,0,0,-1 )
unload( false )
goTo( 0,0,0,0,1 )

-- Seal the hole
if reseal then
	turtle.placeDown()
end

print( "Mined "..(collected + unloaded).." items total." )