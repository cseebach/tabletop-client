local class = require "lib.middleclass"
local JSON = require "lib.JSON"

local SocketWrapper = class("SocketWrapper")

function SocketWrapper:initialize(socket)
    self.socket = socket
    self.partials = {}
    self.remaining_length = 0
end

function SocketWrapper:send(table)
    self.socket:send(JSON:encode(table).."\n")
end

function SocketWrapper:joinPartials()
    local result = table.concat(self.partials)
    self.partials = {}
    return result
end

function SocketWrapper:receiveAll()
    local response, error = self:receive()
    while not response do
        response, error = self:receive()
    end
    return response
end

function SocketWrapper:receive()
    local data, error, partial = self.socket:receive()
    if error == "timeout" then
        table.insert(self.partials, partial)
        return nil, "timeout"
    elseif data then
        table.insert(self.partials, data)
        result = JSON:decode(table.concat(self.partials))
        self.partials = {}
        return result, nil
    end
end

return SocketWrapper
