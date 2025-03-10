local function Currency(symbol, color)
    return {
        Symbol = symbol,
        Color = color,
    }
end

return {
    Kash = Currency("K$", Color3.new(0, 1, 0)),
    Points = Currency("P$", Color3.new(1, 0, 1)),
}