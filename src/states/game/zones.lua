local utils = require "utils"
local class = require "lib/middleclass"

local Zone = class("Zone")

function Zone:isClicked(mouseX, mouseY)
	local x = utils.within(self.x, self.width, mouseX)
	local y = utils.within(self.y, self.height, mouseY)
	return x and y
end 

function Zone:cardAdded(card)
    card.x = self.x
    card.y = self.y
end 

function Zone:addCard(card)
	table.insert(self.cards, card)
    self:cardAdded(card)
end

function Zone:setCards(cards)
    for i, card in ipairs(cards) do
        table.insert(self.cards, card)
        self:cardAdded(card)
    end
end 

function Zone:removeTop()
	return table.remove(self.cards, 1)
end 

function Zone:getCardAt(x, y)
    local last = 0
    for i, card in ipairs(self.cards) do
        if card:inside(x, y) then return card end
    end
    return nil
end

function Zone:removeCardAt(x, y)
    local last = 0
    for i, card in ipairs(self.cards) do
        if card:inside(x, y) then return table.remove(self.cards, i) end
    end
end

--- deck: where cards are drawn from
local Deck = class("Deck", Zone)

function Deck:initialize()
    self.x=1505
    self.y=740
    self.width=375/2
    self.height=525/2
    
    self.cards = {}
end

function Deck:draw()
    if self.cards[1] then
        self.cards[1]:draw()
    end
	love.graphics.printf(tostring(#self.cards), self.x, self.y, 12)
end

-- carry: cards that are being moved somewhere else
local Carry = class("Carry", Zone)

function Carry:initialize()
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.cards = {}
end

function Carry:mouseMoved(newX, newY)
    newX = newX - 375/4
    newY = newY - 525/4
    self.x = newX
    self.y = newY
    if self.cards[1] then
        self.cards[1].x = newX
        self.cards[1].y = newY
    end
end

function Carry:hasCards()
    return #self.cards > 0
end

function Carry:draw()
	if #self.cards > 0 then
		self.cards[1]:draw(true)
	end 
end

-- hand: cards that you can play
local Hand = class("Hand", Zone)

function Hand:initialize()
	self.cards = {}
	self.x=50
    self.y=740
	self.width=1360
    self.height=280
end

function Hand:cardAdded(card)
    card.faceDown = false
    local x = self.x
	for _, card in ipairs(self.cards) do
		card.x = x
        card.y = self.y
		x = x + 120
	end
end

function Hand:draw()
	for _, card in ipairs(self.cards) do
		card:draw()
	end
end

function Hand:getCardIndexAt(x, y)
	local numCards = #self.cards
    for i=numCards-1,0,-1 do 
        local xOffset = i*120
    end 
end

-- field: cards in play
local Field = class("Field", Zone)

function Field:initialize()
    self.cards = {}
    self.x = 0
    self.y = 0
    self.width = 1920
    self.height = 1080
end

function Field:cardAdded(card)
    
end

function Field:draw()
	for _, card in ipairs(self.cards) do
		card:draw()
	end
end 

return {Deck=Deck, Carry=Carry, Hand=Hand, Field=Field}
