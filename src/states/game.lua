local game = {}

local loveframes = nil
function menu:init()
    loveframes = require('lib.loveframes')
end

function menu:update(dt)

    -- your code

    loveframes.update(dt)

end

function menu:draw()

    -- your code

    loveframes.draw()

end

function menu:mousepressed(x, y, button)

    -- your code

    loveframes.mousepressed(x, y, button)

end

function menu:mousereleased(x, y, button)

    -- your code

    loveframes.mousereleased(x, y, button)

end

function menu:keypressed(key, unicode)

    -- your code

    loveframes.keypressed(key, unicode)

end

function menu:keyreleased(key)

    -- your code

    loveframes.keyreleased(key)

end

function menu:textinput(text)

    -- your code

    loveframes.textinput(text)
end