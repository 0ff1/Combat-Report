---@class Server
local Server = lib.class("Server")

function Server:constructor()
    self.repository = require("src.server.classes.repository"):new()
    self.damageHandler = require("src.server.classes.damageHandler"):new(self.repository)

    self:registerListeners()
    self:registerExports()
end

function Server:registerListeners()
    ---@param matchmakingId string Matchmaking identifier.
    ---@param data string Matchmaking data.
    AddEventHandler("ws-combatreport:server:matchmakingStarted", function(matchmakingId, data)
        self.repository:matchmakingStarted(matchmakingId, data)
    end)

    ---@param matchmakingId string Matchmaking identifier.
    AddEventHandler("ws-combatreport:server:matchmakingEnd", function(matchmakingId)
        self.repository:matchmakingEnd(matchmakingId)
    end)

    ---@param matchmakingId string Matchmaking identifier.
    AddEventHandler("ws-combatreport:server:roundStarted", function(matchmakingId)
        self.repository:roundStarted(matchmakingId)
    end)
end

function Server:registerExports()
    ---@param matchmakingId string Matchmaking identifier.
    ---@return table
    exports("getMatchmakingData", function(matchmakingId)
        return self.repository:getMatchmakingData(matchmakingId)
    end)
end

Server:new()
