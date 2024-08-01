---@class Repository
local Repository = lib.class("Repository")

Repository.games = {}

function Repository:matchmakingStarted(matchmakingId, data)
    self.games[matchmakingId] = lib.table.deepclone(data)

    for _, players in pairs(self.games[matchmakingId].players.data) do
        for _, v in pairs(players) do
            TriggerClientEvent("ws-combatreport:client:matchmakingStarted", v.src, matchmakingId)
        end
    end
end

function Repository:matchmakingEnd(matchmakingId)
    for _, players in pairs(self.games[matchmakingId].players.data) do
        for _, v in pairs(players) do
            TriggerClientEvent("ws-combatreport:client:matchmakingEnd", v.src)
        end
    end

    self.games[matchmakingId] = data
end

function Repository:roundStarted(matchmakingId)
    self.games[matchmakingId].rounds.current = self.games[matchmakingId].rounds.current + 1

    for _, players in pairs(self.games[matchmakingId].players.data) do
        for _, v in pairs(players) do
            TriggerClientEvent("ws-combatreport:client:roundStarted", v.src)
        end
    end
end

function Repository:getMatchmakingData(matchmakingId)
    return lib.table.deepclone(self.games[matchmakingId])
end

function Repository:matchmakingExist(matchmakingId)
    if self.games[matchmakingId] then
        return true
    end

    return false
end

function Repository:getPlayerBySrc(matchmakingId, src)
    if not Repository:matchmakingExist(matchmakingId) then
        return false
    end

    for side, players in pairs(self.games[matchmakingId].players.data) do
        for _, v in pairs(players) do
            if v.src == src then
                local data = lib.table.deepclone(v)

                data.side = side

                return data
            end
        end
    end
end

function Repository:getPlayerByPed(matchmakingId, ped)
    if not Repository:matchmakingExist(matchmakingId) then
        return false
    end

    for side, players in pairs(self.games[matchmakingId].players.data) do
        for _, v in pairs(players) do
            if GetPlayerPed(v.src) == ped then
                local data = lib.table.deepclone(v)

                data.side = side

                return data
            end
        end
    end
end

function Repository:verifyCurrentRoundPlayerStruct(currentRound, src)
    if currentRound[src] == nil then
        currentRound[src] = {
            input = {},
            output = {},
        }
    end
end

function Repository:recordInputDamage(victim, attacker, data, currentRoundData)
    self:verifyCurrentRoundPlayerStruct(currentRoundData, victim.src)

    local inputData = currentRoundData[victim.src].input

    if inputData[attacker.src] == nil then
        inputData[attacker.src] = {
            nick = attacker.nick,
            side = attacker.side,
            damages = {},
        }
    end

    inputData[attacker.src].damages[#inputData[attacker.src].damages + 1] = {
        damage = data.damage,
        bone = data.bone,
        weapon = data.weapon,
    }

    return inputData
end

function Repository:recordOutputDamage(victim, attacker, data, currentRoundData)
    self:verifyCurrentRoundPlayerStruct(currentRoundData, attacker.src)

    local outputData = currentRoundData[attacker.src].output

    if outputData[victim.src] == nil then
        outputData[victim.src] = {
            nick = victim.nick,
            side = victim.side,
            damages = {},
        }
    end

    outputData[victim.src].damages[#outputData[victim.src].damages + 1] = {
        damage = data.damage,
        bone = data.bone,
        weapon = data.weapon,
    }

    return outputData
end

function Repository:recordDamage(victim, attacker, data)
    local matchmakingRounds = self.games[data.matchmakingId].rounds
    local currentRoundData = matchmakingRounds.data[matchmakingRounds.current]

    TriggerClientEvent(
        "ws-combatreport:client:setInput",
        tonumber(victim.src),
        self:recordInputDamage(victim, attacker, data, currentRoundData)
    )

    if attacker.src == "Unknown" then
        return
    end

    TriggerClientEvent(
        "ws-combatreport:client:setOutput",
        tostring(victim.src),
        self:recordOutputDamage(victim, attacker, data, currentRoundData)
    )
end

return Repository
