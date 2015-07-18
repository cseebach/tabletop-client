local class = require "lib.middleclass"
local JSON = require "lib.JSON"

local SocketWrapper = class("SocketWrapper")

function SocketWrapper:initialize(socket)
    self.socket = socket
end

function SocketWrapper:send(table)
    self.socket:send(JSON:encode(table).."\n")
end

function SocketWrapper:receive()
    local response, error = self.socket:receive()
    if not error then
        local decoded = JSON:decode(response)
        return decoded, error
    else
        return nil, error
    end
end

return SocketWrapper
