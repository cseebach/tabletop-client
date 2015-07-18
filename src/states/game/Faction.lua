local class = require "lib.middleclass"

local zones = require "states.game.zones"

local Faction = class("Faction")

function Faction:initialize(name)
    self.zones = {
        deck=zones.Deck:new(),
        carry=zones.Carry:new(),
        hand=zones.Hand:new(),
        field=zones.Field:new()
    }

    self.cards = {}
end

function Faction:drawToCarry()

end

function Faction:fieldToCarry(card_id)

end

function Faction:handToCarry(card_id)

end

function Faction:carryToHand()

end

function Faction:carryToField(x, y)

end

return Faction
