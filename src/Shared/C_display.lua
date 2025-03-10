local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local blend = require(game.ReplicatedStorage.Shared.blend.Shared.Blend.Blend)
local CurrencyData = require(ReplicatedStorage.Shared.CurrencyData)
local CurrencyConstants = require(ReplicatedStorage.Shared.CurrencyConstants)

local function currencyDisplay(player)
    local leaderstats = player:WaitForChild(CurrencyConstants.LEADERSTAT_TAG, 5)
    if not leaderstats then
        warn("leaderstats not found for player", player.Name)
        return
    end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 220, 0, 60 *  # (1))
    container.Position = UDim2.new(0, 20, 0, 20)
    container.BackgroundTransparency = 1
    container.Parent = player:WaitForChild("PlayerGui")

    local counter = 0
    for currencyName, currencyInfo in pairs(CurrencyData) do
        counter = counter + 1
        local intValue = leaderstats:FindFirstChild(currencyName)
        if intValue then
            local label = blend.New("TextLabel") {
                Size = UDim2.new(1, 0, 0, 50),
                Position = UDim2.new(0, 0, 0, 55 * (counter - 1)),
                BackgroundTransparency = 0.5,
                TextScaled = true,
                TextColor3 = currencyInfo.Color,
                Text = blend.Computed(
                    intValue:GetPropertyChangedSignal("Value"),
                    function()
                        return currencyInfo.Symbol .. " " .. (intValue.Value or 0)
                    end
                )
            }
            label.Parent = container
        else
            warn("IntValue for currency", currencyName, "not found in leaderstats")
        end
    end
    container.Size = UDim2.new(0, 220, 0, 55 * counter)
end

return currencyDisplay
