local Gamestate = require "lib.hump.gamestate"

local menu = require "states.menu"

function love.load()
    love.graphics.setBackgroundColor(50,50,50,255)
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
