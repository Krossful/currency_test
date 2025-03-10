local binder = require(game.ReplicatedStorage.Shared.binder.Shared.Binder)

return binder.new("Currency", function(currencyValue) --- im guessing you would require this in your UI to call its methods (like :Bind() or :Start()) on the relevant instances.
    return {
        GetCurrency = function()
            return currencyValue.Value
        end
    }
end)
