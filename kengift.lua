-- Define the URL to make the GET request
local url = "http://localhost:8000/give/xp/xxing28"

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
