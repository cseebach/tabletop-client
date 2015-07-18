local game = {}

local loveframes = nil
local Game = require "states.game.Game"
local Card = require "states.game.Card"
local cards = require "states.game.cards"
local SocketWrapper = require "states.game.SocketWrapper"
local JSON = require "lib.JSON"

function game:init()
    loveframes = require('lib.loveframes')
    self.tableImage = love.graphics.newImage("images/tabletop_background.png")
end

function game:setSocket(socket)
    socket:settimeout(.01)
    self.net = SocketWrapper(socket)
end

function game:enter()
    loveframes.SetState("game")
    love.graphics.setBackgroundColor(20,20,20,20)

    self.game = Game:new(self.net)
end

function game:ping()
    self.net:send{action="ping"}
    response, error = self.net:receive()
    if response then
        self.game:processUpdates(response.updates)
    end
end

function game:update(dt)
    self:ping()

    loveframes.update(dt)
end

function game:draw()
    love.graphics.draw(self.tableImage, 0, 0, 0)
    self.game:draw()

    loveframes.draw()
end

function game:mousemoved(x, y)
    self.lastMouse = {x=x, y=y}
	self.game:mouseMoved(x, y)
end

function game:send(table)
    self.socket:send(JSON:encode(table).."\n")
end

function game:mousepressed(x, y, button)
	if button == "l" then self.game:leftpressed(x, y) end

    loveframes.mousepressed(x, y, button)
end

function game:mousereleased(x, y, button)
    if button == "l" then self.game:leftreleased(x, y) end

    loveframes.mousereleased(x, y, button)
end
--
function game:keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
    elseif key == "f" then
        self.game:flip()
    elseif key == "u" then
        self.game:use()
    elseif key == "s" then
        self.game:sit()
    elseif key == "1" then
        self.game:switchView(1)
    elseif key == "2" then
        self.game:switchView(2)
    elseif key == "3" then
        self.game:switchView(3)
    elseif key == "4" then
        self.game:switchView(4)
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
