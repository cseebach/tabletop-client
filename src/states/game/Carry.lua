local class = require "lib.middleclass"

local Carry = class("Carry")

function Carry:initialize(net)
    self.card = nil
    self.x = 0
    self.y = 0
    self.net = net
end

function Carry:mouseMoved(newX, newY)
    newX = newX - 375/4
    newY = newY - 525/4
    self.x = newX
    self.y = newY
    if self.card then
        self.card.x = newX
        self.card.y = newY
    end
end

function Carry:hasCard()
    return self.card ~= nil
end

function Carry:draw()
	if self.card then
		self.card:draw(true)
	end
end

function Carry:setCard(card)
    self.card = card
    self.card.x = self.x
    self.card.y = self.y
end

function Carry:to(zone)
    zone:addCard(self.card)
    self.card = nil
end

return Carry
