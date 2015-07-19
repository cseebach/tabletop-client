local class = require "lib/middleclass"
local utils = require "utils"

local Card = class("Card")

Card.static.default_scale = 0.5

local memoized = {}
local function memoize(imagePath)
    if not memoized[imagePath] then
        memoized[imagePath] = love.graphics.newImage(imagePath)
    end
    return memoized[imagePath]
end

function Card:initialize(cardData, id)
    self.front = memoize("images/fronts/"..cardData.front)
    self.back  = memoize("images/backs/"..cardData.back)
    self.faceDown = true
    self.used = false
    self.x = 0
    self.y = 0
    self.scale = Card.default_scale
    self.id = id
    self.used = false
end

function Card:flip()
    self.faceDown = not self.faceDown
end

function Card:toggleUsed()
    self.used = not self.used
end

function Card:draw()
    local image = self.front
    if self.faceDown then
        image = self.back
    end
    if self.used then
        love.graphics.draw(
            image,
            self.x+375/4, self.y+525/4,
            math.pi/2,
            self.scale, self.scale,
            375/2, 525/2)
    else
        love.graphics.draw(image, self.x, self.y, 0, self.scale)
    end
end

function Card:inside(x, y)
    return  utils.within(self.x, 375/2, x) and
            utils.within(self.y, 525/2, y)
end

return Card
