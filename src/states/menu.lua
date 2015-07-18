local menu = {}

local loveframes = nil
local socket = require "socket"
local Gamestate = require "lib.hump.gamestate"
local JSON = require "lib.JSON"

local game = require "states.game"

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
    self.socket:send(JSON:encode(message).."\n")
    local response, error = self.socket:receive()
    print(response)
    print(error)
    local response = JSON:decode(response)
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
    self.socket:send(JSON:encode(message).."\n")
    local response, error = self.socket:receive()
    print(response)
    print(error)
    local response = JSON:decode(response)
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

    local createFactionLabel = loveframes.Create("text")
    createFactionLabel:SetText("I'd like to play:")
    createForm:AddItem(createFactionLabel)

    local createFactionGrid = loveframes.Create("grid")
    createFactionGrid:SetRows(2)
    createFactionGrid:SetColumns(2)
    createFactionGrid:SetCellWidth(90)
    createFactionGrid:SetCellHeight(25)
    createFactionGrid:SetCellPadding(5)
    createFactionGrid:SetItemAutoSize(true)

    local dryadsButton = loveframes.Create("button")
    dryadsButton:SetText("Dryads")
    createFactionGrid:AddItem(dryadsButton, 1, 1)

    local gearpunkButton = loveframes.Create("button")
    gearpunkButton:SetText("Gearpunk")
    createFactionGrid:AddItem(gearpunkButton, 1, 2)

    local iceButton = loveframes.Create("button")
    iceButton:SetText("Ice Dragons")
    createFactionGrid:AddItem(iceButton, 2, 1)

    local minotaurButton = loveframes.Create("button")
    minotaurButton:SetText("Minotaurs")
    createFactionGrid:AddItem(minotaurButton, 2, 2)

    createForm:AddItem(createFactionGrid)

    function dryadsButton.OnClick(object)
        menu:createGame(
            createGameName:GetText(),
            createGamePassword:GetText(),
            "dryad")
    end

    function gearpunkButton.OnClick(object)
        menu:createGame(
            createGameName:GetText(),
            createGamePassword:GetText(),
            "gearpunk")
    end

    function iceButton.OnClick(object)
        menu:createGame(
            createGameName:GetText(),
            createGamePassword:GetText(),
            "ice")
    end

    function minotaurButton.OnClick(object)
        menu:createGame(
            createGameName:GetText(),
            createGamePassword:GetText(),
            "minotaur")
    end

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

    local joinFactionLabel = loveframes.Create("text")
    joinFactionLabel:SetText("I'd like to play:")
    joinForm:AddItem(joinFactionLabel)

    local joinFactionGrid = loveframes.Create("grid")
    joinFactionGrid:SetRows(2)
    joinFactionGrid:SetColumns(2)
    joinFactionGrid:SetCellWidth(90)
    joinFactionGrid:SetCellHeight(25)
    joinFactionGrid:SetCellPadding(5)
    joinFactionGrid:SetItemAutoSize(true)

    local dryadsButton = loveframes.Create("button")
    -- dryadsButton:SetEnabled(false)
    dryadsButton:SetText("Dryads")
    joinFactionGrid:AddItem(dryadsButton, 1, 1)

    local gearpunkButton = loveframes.Create("button")
    -- gearpunkButton:SetEnabled(false)
    gearpunkButton:SetText("Gearpunk")
    joinFactionGrid:AddItem(gearpunkButton, 1, 2)

    local iceButton = loveframes.Create("button")
    -- iceButton:SetEnabled(false)
    iceButton:SetText("Ice Dragons")
    joinFactionGrid:AddItem(iceButton, 2, 1)

    local minotaurButton = loveframes.Create("button")
    -- minotaurButton:SetEnabled(false)
    minotaurButton:SetText("Minotaurs")
    joinFactionGrid:AddItem(minotaurButton, 2, 2)

    function dryadsButton.OnClick(object)
        self:joinGame(
            joinGameName:GetText(),
            joinGamePassword:GetText(),
            "dryads")
    end

    function gearpunkButton.OnClick(object)
        self:joinGame(
            joinGameName:GetText(),
            joinGamePassword:GetText(),
            "gearpunk")
    end

    function iceButton.OnClick(object)
        self:joinGame(
            joinGameName:GetText(),
            joinGamePassword:GetText(),
            "ice")
    end

    function minotaurButton.OnClick(object)
        self:joinGame(
            joinGameName:GetText(),
            joinGamePassword:GetText(),
            "minotaur")
    end

    joinForm:AddItem(joinFactionGrid)

    return joinForm
end

function menu:init()
    loveframes = require('lib.loveframes')
    self.socket = socket.connect("localhost", 56789)

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
