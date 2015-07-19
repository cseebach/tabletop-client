local class = require "lib.middleclass"
local MessagePack = require "lib.MessagePack"

local SocketWrapper = class("SocketWrapper")

function SocketWrapper:initialize(socket)
    self.socket = socket
    self.mode = "byte_length"
    self.partials = {}
    self.remaining_length = 0
end

function SocketWrapper:send(table)
    local encoded = MessagePack.pack(table)
    self.socket:send(tostring(#encoded).."\n")
    self.socket:send(encoded)
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
    if self.mode == "byte_length" then
        local response, error, partial = self.socket:receive()
        if response == nil and error == "timeout" then
            if partial then 
                table.insert(self.partials, partial)
            end
            return nil, "got byte length"
        else 
            self.remaining_length = tonumber(response)
            self.mode = "message"
            return nil, "timeout"
        end
    elseif self.mode == "message" then
        local response, error, partial = self.socket:receive(self.remaining_length)
        if response then
            table.insert(self.partials, response)
            self.mode = "byte_length"
            return MessagePack.unpack(self:joinPartials())
        elseif error == "timeout" then
            if partial then 
                table.insert(self.partials, partial)
                self.remaining_length = self.remaining_length - #partial
            end
            return nil, "timeout"
        end
    end
end

return SocketWrapper
