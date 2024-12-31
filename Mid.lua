local HttpService = game:GetService("HttpService")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Window = Library:NewWindow("arbix")

local PurchaseSection = Window:NewSection("Dev Product")
local dnames = {}
local dproductIds = {}

local function fetchDeveloperProducts()
    local currentPage = 1
    repeat
        local response = game:HttpGet("https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" .. tostring(game.GameId) .. "&page=" .. tostring(currentPage))
        local decodedResponse = HttpService:JSONDecode(response)
        local developerProducts = decodedResponse.DeveloperProducts

        if developerProducts then
            for _, developerProduct in pairs(developerProducts) do
                table.insert(dnames, developerProduct.Name)
                table.insert(dproductIds, developerProduct.ProductId)
            end
        end

        currentPage = currentPage + 1
    until decodedResponse.FinalPage
end

pcall(fetchDeveloperProducts)

local index
PurchaseSection:CreateDropdown("Select a Dev Product", dnames, function(selectedName)
    index = nil
    for i, name in ipairs(dnames) do
        if name == selectedName then
            index = i
            break
        end
    end
end)

getgenv().wyvernlooppurchases = false
PurchaseSection:CreateToggle("Loop", function(bool)
    getgenv().wyvernlooppurchases = bool
    while getgenv().wyvernlooppurchases and task.wait() do
        if index then
            local product = dproductIds[index]
            pcall(function()
                stealth_call('MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' .. product .. ', true)')
            end)
        end
    end
end)

PurchaseSection:CreateButton("Fire", function()
    if index then
        local product = dproductIds[index]
        pcall(function()
            stealth_call('MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' .. product .. ', true)')
        end)
        print("Fired PromptProductPurchaseFinished signal for productId: " .. tostring(product))
    else
        print("Error: No product selected.")
    end
end)

-- Add Game Passes Section
local GamePassSection = Window:NewSection("Game Passes")
local gnames = {}
local gproductIds = {}

local function fetchGamePasses()
    local response = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.GameId .. "/game-passes?limit=100&sortOrder=1"))
    for _, v in pairs(response.data) do
        table.insert(gnames, v.name)
        table.insert(gproductIds, v.id)
    end
end

pcall(fetchGamePasses)

local gindex
GamePassSection:CreateDropdown("Select a Game Pass", gnames, function(selectedName)
    gindex = nil
    for i, name in ipairs(gnames) do
        if name == selectedName then
            gindex = i
            break
        end
    end
 end)

GamePassSection:CreateButton("Fire Game Pass", function()
    if gindex then
        local product = gproductIds[gindex]
        pcall(function()
            stealth_call('MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' .. product .. ', true)')
        end)
        print("Fired PromptProductPurchaseFinished signal for game passId: " .. tostring(product))
    else
        print("Error: No game pass selected.")
    end
end)

getgenv().wyvernlooppurchases2 = false
GamePassSection:CreateToggle("Loop All Game Passes", function(bool)
    getgenv().wyvernlooppurchases2 = bool
    while getgenv().wyvernlooppurchases2 and task.wait() do
        for i, product in pairs(gproductIds) do
            task.spawn(function()
                pcall(function()
                    stealth_call('MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' .. product .. ', true)')
                end)
            end)
            task.wait()
        end
    end
end)

GamePassSection:Seperator()
