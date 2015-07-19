local class = require "lib.middleclass"
local serpent = require "lib.serpent"

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
    
    self.cards = {}

    self.carried = {}
    self.carry = Carry:new(net)

    self.viewing = self.factions.dryad
    self.sitting = nil
    
    self.mouse = {x=0, y=0}
end

local onUpdate = {}

function onUpdate.addToDeck(game, update)
    local card = Card:new(cards[update.template], update.card)
    game.cards[update.card] = card
    game.factions[update.faction].deck:addCard(card)
end

function onUpdate.fromDeck(game, update)
    local card = game.factions[update.faction].deck:removeTop()
    game.carried[card.id] = card
end

function onUpdate.fromField(game, update)
    local card = game.factions[update.faction].field:removeID(update.card)
    game.carried[card.id] = card
end

function onUpdate.fromHand(game, update)
    local card = game.factions[update.faction].hand:removeID(update.card)
    game.carried[card.id] = card
end

function onUpdate.toField(game, update)
    local card = game.carried[update.card]
    game.carried[card.id] = nil
    card.x = update.x
    card.y = update.y
    game.factions[update.faction].field:addCard(card)
end

function onUpdate.toHand(game, update)
    local card = game.carried[update.card]
    game.carried[card.id] = nil
    card = game.factions[update.faction].hand:addCard(card)
end

function onUpdate.flip(game, update)
    local card = game.cards[update.card]
    card:flip()
end

function onUpdate.use(game, update)
    local card = game.cards[update.card]
    card:toggleUsed()
end

function Game:processUpdate(update)
    local action = update.action
    if onUpdate[action] then
        onUpdate[action](self, update)
    end
end

function Game:processUpdates(updates)
    for _, update in ipairs(updates) do
        -- print(serpent.block(update))
        self:processUpdate(update)
        -- print(serpent.block(self.carried))
    end
end

function Game:highlightSet(on)
    self.highlightOn = on
end

function Game:draw()


    local sitting = self.sitting == self.viewing
    self.viewing:draw(sitting)
    self.carry:draw()
    
    if self.highlightOn then
        self:highlight()
    end

end

function Game:highlight()
    if self.viewing.field:getCardAt(self.mouse.x, self.mouse.y) then
        self.viewing.field:getCardAt(self.mouse.x, self.mouse.y):highlight()
    elseif self.viewing.hand:getCardAt(self.mouse.x, self.mouse.y) then
        self.viewing.hand:getCardAt(self.mouse.x, self.mouse.y):highlight()
    end
end

function Game:mouseMoved(x, y)
    x = x / scale
    y = y / scale
    self.carry:mouseMoved(x, y)
    self.mouse = {x=x, y=y}
end

function Game:leftpressed(x, y)
    local hand = self.viewing.hand
    if self.viewing.deck:isClicked(x, y) then
        local card = self.viewing.deck:from(self.carry)
        self.net:send{action="fromDeck", card=card.id, faction=self.viewing.name}
    elseif hand:isClicked(x, y) and hand:getCardAt(x, y) then
        local card = self.viewing.hand:fromAt(x, y, self.carry)
        self.net:send{action="fromHand", card=card.id, faction=self.viewing.name}
    elseif self.viewing.field:getCardAt(x, y) then
        local card = self.viewing.field:fromAt(x, y, self.carry)
        self.net:send{action="fromField", card=card.id, faction=self.viewing.name}
    end
end

function Game:leftreleased(x, y)
    if self.carry:hasCard() then
        if self.viewing.hand:isClicked(x, y) then
            local card = self.carry:to(self.viewing.hand)
            self.net:send{action="toHand", card=card.id, faction=self.viewing.name}
        else
            local card = self.carry:to(self.viewing.field)
            self.net:send{action="toField", card=card.id, faction=self.viewing.name, x=card.x, y=card.y}
        end
    end
end

function Game:flip()
    local card = self.viewing.field:getCardAt(self.mouse.x, self.mouse.y)
    if card then
        card:flip()
        self.net:send{action="flip", card=card.id}
    end
end

function Game:use()
    local card = self.viewing.field:getCardAt(self.mouse.x, self.mouse.y)
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
