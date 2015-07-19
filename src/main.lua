local Gamestate = require "lib.hump.gamestate"

local menu = require "states.menu"

function love.load()
    love.graphics.setBackgroundColor(50,50,50,255)
    Gamestate.registerEvents()
    Gamestate.switch(menu)
    scale = 1280/1920
end

function love.resize(w, h)
    desiredAspect = 16.0/9.0
    givenAspect = w/h
    if desiredAspect > givenAspect then
        scale = w/1920
    else
        scale = h/1080
    end
end
