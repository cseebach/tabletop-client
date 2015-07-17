local Gamestate = require "lib.hump.gamestate"

local menu = require "states.menu"
local game = require "states.game"

function love.load()
    love.graphics.setBackgroundColor(50,50,50,255)
    Gamestate.registerEvents()
    Gamestate.switch(game)
end



-- local game = {}
-- local tableImage = nil
-- local lastMouse = {x=0, y=0}

-- local host = nil
-- local server = nil
-- function love.load()
    -- loveframes = require "lib.loveframes"

	-- love.graphics.setBackgroundColor(20,20,20,20)
	-- tableImage = love.graphics.newImage("images/tabletop_background.png")

    -- game = {
        -- deck=zones.Deck:new(),
        -- carry=zones.Carry:new(),
        -- hand=zones.Hand:new(),
        -- field=zones.Field:new()
    -- }
	-- game.deck:setCards(decks.load("igor"))

    -- host = enet.host_create()
    -- server = host:connect("45.55.211.1:56789")
-- end

-- function love.keypressed(key, unicode)
	-- if key == "escape" then
		-- love.event.quit()
	-- elseif key == "f" then
        -- hovering = game.field:getCardAt(lastMouse.x, lastMouse.y)
        -- if hovering then hovering:flip() end
    -- elseif key == "t" then
        -- hovering = game.field:getCardAt(lastMouse.x, lastMouse.y)
        -- if hovering then hovering:toggleUsed() end
    -- end

    -- loveframes.keypressed(key, unicode)
-- end

-- function love.keyreleased(key)

    -- your code

    -- loveframes.keyreleased(key)

-- end

-- function love.textinput(text)

-- your code

-- loveframes.textinput(text)
-- end

-- function love.update(dt)
    -- loveframes.update(dt)

    -- local event = host:service(10)
    -- while event do
        -- if event then
            -- if event.type == "connect" then
                -- print("Connected to", event.peer)
                -- event.peer:send("hello world")
            -- elseif event.type == "receive" then
                -- print("Got message: ", event.data, event.peer)
                -- done = true
            -- end
        -- end
        -- event = host:service()
    -- end
-- end

-- function love.draw()
	-- love.graphics.draw(tableImage, 0, 0, 0)
    -- game.field:draw()
	-- game.deck:draw()
    -- game.hand:draw()
    -- game.carry:draw()

    -- loveframes.draw()
-- end

-- function love.mousemoved(x, y)
	-- game.carry:mouseMoved(x, y)
    -- lastMouse.x = x
    -- lastMouse.y = y
-- end

-- local function drawToCarry()
    -- card = game.deck:removeTop()
    -- game.carry:addCard(card)
-- end

-- local function fieldToCarry(x, y)
    -- card = game.field:removeCardAt(x, y)
    -- game.carry:addCard(card)
-- end

-- local function handToCarry(x, y)
    -- card = game.hand:removeCardAt(x, y)
    -- game.carry:addCard(card)
-- end

-- function love.mousepressed(x, y, button)
	-- if game.deck:isClicked(x, y) then
		-- drawToCarry()
    -- elseif game.hand:isClicked(x, y) then
		-- handToCarry(x, y)
	-- elseif game.field:getCardAt(x, y) then
        -- fieldToCarry(x, y)
    -- end

    -- loveframes.mousepressed(x, y, button)
-- end

-- function love.mousereleased(x, y, button)
	-- if game.hand:isClicked(x, y) then
		-- game.hand:addCard(game.carry:removeTop())
	-- else
        -- game.field:addCard(game.carry:removeTop())
    -- end

    -- loveframes.mousereleased(x, y, button)
-- end
