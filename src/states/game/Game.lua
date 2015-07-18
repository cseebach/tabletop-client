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

    self.carried = {}
    self.carry = Carry:new(net)

    self.viewing = self.factions.dryad
    self.sitting = nil
end

function Game:updateAddToDeck(update)
    card = Card:new(cards[update.template], update.card)
    self.factions[update.faction].deck:addCard(card)
end

function Game:updateFromDeck(update)
    card = self.factions[update.faction].deck:removeTop()
    self.carried[card.id] = card
end

function Game:updateFromField(update)
    card = self.factions[update.faction].field:removeID(card.id)
    self.carried[card.id] = card
end

function Game:updateFromHand(update)
    card = self.factions[update.faction].hand:removeID(card.id)
    self.carried[card.id] = card
end

function Game:updateToField(update)
    local card = self.carried[card.id]
    self.carried[card.id] = nil
    card.x = update.x
    card.y = update.y
    self.factions[update.faction].field:addCard(card)
end

function Game:updateToHand(update)
    local card = self.carried[card.id]
    self.carried[card.id] = nil
    card = self.factions[update.faction].hand:addCard(card)
end

function Game:processUpdate(update)
    if update.action == "addToDeck" then
        self:updateAddToDeck(update)
    elseif update.action == "fromDeck" then
        self:updateFromDeck(update)
    elseif update.action == "fromField" then
        self:updateFromField(update)
    elseif update.action == "fromHand" then
        self:updateFromHand(update)
    elseif update.action == "toField" then
        self:updateToField(update)
    elseif update.action == "toHand" then
        self:updateToHand(update)
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
        self.net:send{action="fromDeck", card=card.id, faction=self.viewing.name}
    elseif self.viewing.hand:isClicked(x, y) then
        self.viewing.hand:fromAt(x, y, self.carry)
        self.net:send{action="fromHand", card=card.id, faction=self.viewing.name}
    elseif self.viewing.field:getCardAt(x, y) then
        self.viewing.field:fromAt(x, y, self.carry)
        self.net:send{action="fromField", card=card.id, faction=self.viewing.name}
    end
end

function Game:leftreleased(x, y)
    if self.carry:hasCard() then
        if self.viewing.hand:isClicked(x, y) then
            self.carry:to(self.viewing.hand)
            self.net:send{action="toHand", card=card.id, faction=self.viewing.name}
        else
            self.carry:to(self.viewing.field)
            self.net:send{action="toField", card=card.id, faction=self.viewing.name, x=x, y=y}
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
