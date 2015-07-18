local game = {}

local loveframes = nil
local zones = require "zones"
local Card = require "Card"
local cards = require "cards"
local JSON = require "lib.JSON"

function game:init()
    loveframes = require('lib.loveframes')
    self.tableImage = love.graphics.newImage("images/tabletop_background.png")
end

function game:setSocket(socket)
    self.socket = socket
    self.socket:settimeout(.01)
end

function game:enter()
    loveframes.SetState("game")
    love.graphics.setBackgroundColor(20,20,20,20)

    self.zones = {
        deck=zones.Deck:new(),
        carry=zones.Carry:new(),
        hand=zones.Hand:new(),
        field=zones.Field:new()
    }

    self.cards = {}

    self.lastMouse={x=0, y=0}
end

function game:send(table)
    self.socket:send(JSON:encode(message).."\n")
end

function game:receive()
    local response, error = self.socket:receive()
    if not error then
        local decoded = JSON:decode(response)
        return decoded, error
    else
        return nil, error
    end
end

function game:processUpdate(update)
    if update.action == "addToDeck" then
        card = Card(cards[update.template], update.card)
        self.cards[update.card] = card
        self.zones.deck:addCard(card)
    end
end

function game:processUpdates(updates)
    for _, update in ipairs(updates) do
        self:processUpdate(update)
    end
end

function game:ping()
    self:send{action="ping"}
    response, error = self:receive()
    if response then
        self:processUpdates(response.updates)
    end
end

function game:update(dt)
    self:ping()

    loveframes.update(dt)
end

function game:draw()
    love.graphics.draw(self.tableImage, 0, 0, 0)
    self.zones.field:draw()
    self.zones.deck:draw()
    self.zones.hand:draw()
    self.zones.carry:draw()

    loveframes.draw()
end

function game:mousemoved(x, y)
    self.lastMouse = {x=x, y=y}
	self.zones.carry:mouseMoved(x, y)
end

function game:send(table)
    self.socket:send(JSON:encode(table).."\n")
end

function game:drawToCarry()
    card = self.zones.deck:removeTop()
    self.zones.carry:addCard(card)
    self:send{command="drawToCarry", card=card.id}
end

local function fieldToCarry(zones, x, y)
    card = zones.field:removeCardAt(x, y)
    zones.carry:addCard(card)
end

local function handToCarry(zones, x, y)
    card = zones.hand:removeCardAt(x, y)
    zones.carry:addCard(card)
end

local function carryToHand(zones)
    zones.hand:addCard(zones.carry:removeTop())
end

local function carryToField(zones)
    zones.field:addCard(zones.carry:removeTop())
end

function game:mousepressed(x, y, button)
	if self.zones.deck:isClicked(x, y) then
		self:drawToCarry()
    elseif self.zones.hand:isClicked(x, y) then
		handToCarry(self.zones, x, y)
	elseif self.zones.field:getCardAt(x, y) then
        fieldToCarry(self.zones, x, y)
    end

    loveframes.mousepressed(x, y, button)
end

function game:mousereleased(x, y, button)
    if self.zones.carry:hasCards() then
    	if self.zones.hand:isClicked(x, y) then
    		carryToHand(self.zones)
    	else
            carryToField(self.zones)
        end
    end

    loveframes.mousereleased(x, y, button)
end

function game:keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
    elseif key == "f" then
        hovering = self.zones.field:getCardAt(self.lastMouse.x, self.lastMouse.y)
        if hovering then hovering:flip() end
    elseif key == "t" then
        hovering = self.zones.field:getCardAt(self.lastMouse.x, self.lastMouse.y)
        if hovering then hovering:toggleUsed() end
    end

    loveframes.keypressed(key, unicode)
end

function game:keyreleased(key)
    -- your code

    loveframes.keyreleased(key)
end

function game:textinput(text)
    -- your code

    loveframes.textinput(text)
end

return game
