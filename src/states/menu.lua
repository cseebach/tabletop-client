local menu = {}

local loveframes = nil
local socket = require "socket"
local Gamestate = require "lib.hump.gamestate"
local SocketWrapper = require "SocketWrapper"

local game = require "states.game.state"

function menu:switchToGame()
    game:setSocket(self.socket)
    Gamestate.switch(game)
end

function menu:joinGame(name, password, faction)
    local message = {
        action="joinGame",
        name=name,
        password=password,
        faction=faction
    }
    self.net:send(message)
    local response = self.net:receiveAll()
    if response.action == "joined" then
        self:switchToGame()
    end
end

function menu:createGame(name, password, faction)
    local message = {
        action="createGame",
        name=name,
        password=password,
        faction=faction
    }
    self.net:send(message)
    local response = self.net:receiveAll()
    if response.action == "created" then
        self:switchToGame()
    end
end

function menu:createNewGameForm()
    local createForm = loveframes.Create("form", menuPanel)
    createForm:SetState("menu")
    createForm:SetName("Create Game:")

    local createGameName = loveframes.Create("textinput")
    createGameName:SetLimit(50)
    createGameName:SetPlaceholderText("game name")
    createForm:AddItem(createGameName)

    local createGamePassword = loveframes.Create("textinput")
    createGamePassword:SetLimit(50)
    createGamePassword:SetPlaceholderText("game password")
    createForm:AddItem(createGamePassword)

    local createButton = loveframes.Create("button")
    createButton:SetText("Create")
    function createButton.OnClick(object)
        self:createGame(createGameName:GetText(), createGamePassword:GetText())
    end
    createForm:AddItem(createButton)

    return createForm
end

function menu:createJoinGameForm()
    local joinForm = loveframes.Create("form", menuPanel)
    joinForm:SetState("menu")
    joinForm:SetName("Join Game:")

    local joinGameName = loveframes.Create("textinput")
    joinGameName:SetLimit(50)
    joinGameName:SetPlaceholderText("game name")
    joinForm:AddItem(joinGameName)

    local joinGamePassword = loveframes.Create("textinput")
    joinGamePassword:SetLimit(50)
    joinGamePassword:SetPlaceholderText("game password")
    joinForm:AddItem(joinGamePassword)

    local joinButton = loveframes.Create("button")
    joinButton:SetText("Create")
    function joinButton.OnClick(object)
        self:joinGame(joinGameName:GetText(), joinGamePassword:GetText())
    end
    joinForm:AddItem(joinButton)

    return joinForm
end

function menu:init()
    loveframes = require('lib.loveframes')
    self.socket = socket.connect("45.55.211.1", 56789)
    self.net = SocketWrapper:new(self.socket)

    local menuGrid = loveframes.Create("grid")
    menuGrid:SetState("menu")

    menuGrid:SetRows(1)
    menuGrid:SetColumns(2)
    menuGrid:SetCellWidth(300)
    menuGrid:SetCellHeight(500)

    menuGrid:SetSize(600, 500)
    menuGrid:CenterWithinArea(0,0,1920,1080)

    local createForm = self:createNewGameForm()
    menuGrid:AddItem(createForm, 1, 1)

    local joinForm = self:createJoinGameForm()
    menuGrid:AddItem(joinForm, 1, 2)
end

function menu:enter(previous)
    loveframes.SetState("menu")

end

function menu:update(dt)

    -- your code

    loveframes.update(dt)

end

function menu:draw()

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

    if key == "escape" then love.event.quit() end

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

return menu
