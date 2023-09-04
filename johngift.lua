local url = "http://127.0.0.1:8000/give/gift/DavillaMaster"

-- Make the GET request
local response = http.get(url)

-- Check if the request was successful
if response then
  -- Read the response and print it
  local content = response.readAll()
  print("Server said: " .. content)
  
  -- Close the response to free resources
  response.close()
else
  print("Failed to contact server.")
end