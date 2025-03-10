--[=[
	@class CurrencyService
]=]

local require = require(script.Parent.loader).load(script)

local SUBSTORE_KEY = "Money"

local Maid = require("Maid")
local PlayerDataStoreService = require("PlayerDataStoreService")
local RxPlayerUtils = require("RxPlayerUtils")
local CurrencyData = require("CurrencyData")
local CurrencyConstants = require("CurrencyConstants")

local CurrencyService = {}
CurrencyService.ServiceName = "CrateService"

function CurrencyService:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._playerDataStoreService = serviceBag:GetService(PlayerDataStoreService)

	self._maid = Maid.new()
end

function CurrencyService:Start()
	self._maid:GiveTask(RxPlayerUtils.observePlayersBrio():Subscribe(function(brio)
		self:_handlePlayer(brio:ToMaidAndValue())
	end))
end

function CurrencyService:_handlePlayer(maid, player: Player)
	maid:GivePromise(self._playerDataStoreService:PromiseDataStore(player)):Then(function(root)
		local leaderstats = Instance.new("Folder")
		leaderstats.Archivable = false
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player

		leaderstats:AddTag(CurrencyConstants.LEADERSTAT_TAG)

		local currencyStore = root:GetSubStore(SUBSTORE_KEY)

		for name, _data in CurrencyData do
			local intValue = Instance.new("IntValue")
			intValue.Name = name
			intValue.Parent = leaderstats

			maid:GivePromise(currencyStore:Load(name)):Then(function(storedAmount)
				intValue.Value = storedAmount or 0
			end)
			maid:GiveTask(currencyStore:StoreOnValueChange(name, intValue))
		end
	end)
end



function CurrencyService:Destroy()
	self._maid:DoCleaning()
end

return CurrencyService
