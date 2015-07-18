local class = require "lib.middleclass"

local Faction = require "states.game.Faction"
local Card = require "states.game.Card"
local Carry = require "states.game.Carry"
local cards = require "states.game.cards"
local zones = require "states.game.zones"


local Game = class("Game")

function Game:initialize(net)
    self.factions = {
        dryad = Faction:new("dryad"),
        gearpunk = Faction:new("gearpunk"),
        ice = Faction:new("ice"),
        minotaur = Faction:new("minotaur")
    }
    self.factionsByNumber = {
        self.factions.dryad,
        self.factions.gearpunk,
        self.factions.ice,
        self.factions.minotaur
    }

    self.net = net

    self.hidden = {}
    self.carry = Carry:new(net)

    self.viewing = self.factions.dryad
    self.sitting = nil
end

function Game:addToDeck(update)
    card = Card:new(cards[update.template], update.card)
    self.factions[update.faction].deck:addCard(card)
end

function Game:processUpdate(update)
    if update.action == "addToDeck" then
        self:addToDeck(update)
    end
end

function Game:processUpdates(updates)
    for _, update in ipairs(updates) do
        self:processUpdate(update)
    end
end

function Game:draw()
    sitting = self.sitting == self.viewing
    self.viewing:draw(sitting)
    self.carry:draw()
end

function Game:mouseMoved(x, y)
    self.carry:mouseMoved(x, y)
    self.mouse = {x=x, y=y}
end

function Game:leftpressed(x, y)
    if self.viewing.deck:isClicked(x, y) then
        self.viewing.deck:from(self.carry)
        self.net:send{action="toCarry", card=card.id}
    elseif self.viewing.hand:isClicked(x, y) then
        self.viewing.hand:fromAt(x, y, self.carry)
        self.net:send{action="toCarry", card=card.id}
    elseif self.viewing.field:getCardAt(x, y) then
        self.viewing.field:fromAt(x, y, self.carry)
        self.net:send{action="toCarry", card=card.id}
    end
end

function Game:leftreleased(x, y)
    if self.carry:hasCard() then
        if self.viewing.hand:isClicked(x, y) then
            self.carry:to(self.viewing.hand)
            self.net:send{action="toHand", card=card.id, viewing=self.viewing.name}
        else
            self.carry:to(self.viewing.field)
            self.net:send{action="toField", card=card.id, viewing=self.viewing.name, x=x, y=y}
        end
    end
end

function Game:flip()
    card = self.viewing.field:getCardAt(self.mouse.x, self.mouse.y)
    if card then
        card:flip()
        self.net:send{action="flip", card=card.id}
    end
end

function Game:use()
    card = self.viewing.field:getCardAt(self.mouse.x, self.mouse.y)
    if card then
        card:toggleUsed()
        self.net:send{action="use", card=card.id}
    end
end

function Game:switchView(view)
    self.viewing = self.factionsByNumber[view]
end

function Game:sit()
    self.sitting = self.viewing
end

return Game
