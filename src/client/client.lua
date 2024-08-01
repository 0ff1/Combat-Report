---@class Client
local Client = lib.class("Client")

function Client:constructor()
    self.repository = require("src.client.classes.repository"):new()
    self.damageColletor = require("src.client.classes.damageColletor"):new(self.repository)
end

Client:new()
