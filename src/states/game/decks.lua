local cards = require "cards"
local Card = require "Card"

local decks = {}

decks.data = {
	igor={
		{"mine", 20},
		{"uranium_purifier", 8}
	}
}

local function addCard(deckEntry, deck)
    cardName, quantity = unpack(deckEntry)
    cardData = cards[cardName]
    for i=1,quantity do 
        table.insert(deck, Card:new(cardData))
    end
end 

function decks.load(name)
    local deck = {}
    for _, deckEntry in ipairs(decks.data[name]) do
        addCard(deckEntry, deck)
    end
    return deck
end

return decks