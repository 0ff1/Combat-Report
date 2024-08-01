---@class Repository
local Repository = lib.class("Repository")

Repository.health = 0
Repository.matchmakingId = nil
Repository.input = {}
Repository.output = {}

function Repository:constructor()
    self:registerListeners()
end

function Repository:resetData()
    Repository.health = GetEntityHealth(lib.cache("ped"))
    self.input = {}
    self.output = {}
end

function Repository:registerListeners()
    RegisterNetEvent("ws-combatreport:client:matchmakingStarted", function(matchmakingId)
        self:resetData()

        Repository.matchmakingId = matchmakingId
    end)

    RegisterNetEvent("ws-combatreport:client:matchmakingEnd", function()
        self:resetData()

        Repository.matchmakingId = nil
    end)

    RegisterNetEvent("ws-combatreport:client:roundStarted", function()
        self:resetData()
    end)

    RegisterNetEvent("ws-combatreport:client:setInput", function(data)
        self.input = data
    end)

    RegisterNetEvent("ws-combatreport:client:setOutput", function(data)
        self.output = data
    end)
end

return Repository
