-- Table containing the raw GitHub URLs of the scripts to update
local githubURLs = {
    "https://raw.githubusercontent.com/tgreer812/computercraftscripts/main/minerscript.lua",
    "https://raw.githubusercontent.com/tgreer812/computercraftscripts/main/updatescripts.lua",
    "https://raw.githubusercontent.com/tgreer812/computercraftscripts/main/stairplacer.lua"
    -- Add more URLs as needed
}

-- Function to extract the script name from a GitHub URL
local function extractScriptName(url)
    local _, _, scriptName = string.find(url, "/([^/]+)$")
    return scriptName or "unknown.lua"
end

-- Function to update a single script
local function updateScript(url)
    local scriptName = extractScriptName(url)
    print("Updating " .. scriptName .. "...")

    local ok, err = shell.run("wget " .. url .. " " .. scriptName)
    if not ok then
        print("Failed to update " .. scriptName .. ": " .. tostring(err))
    end
end

-- Main loop to update all scripts
for _, url in ipairs(githubURLs) do
    updateScript(url)
end

print("Update complete.")
