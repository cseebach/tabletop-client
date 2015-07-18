local class = require "lib.middleclass"

local zones = require "states.game.zones"

local Faction = class("Faction")

function Faction:initialize(name)
    self.name = name

    self.deck=zones.Deck:new()
    self.hand=zones.Hand:new()
    self.field=zones.Field:new()

    self.cards = {}
end

function Faction:draw(sitting)
    self.field:draw()
    self.deck:draw()
    self.hand:draw(sitting)
end



return Faction
