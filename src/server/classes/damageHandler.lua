local DamageHandler = lib.class("DamageHandler")

function DamageHandler:constructor(repository)
    self.repository = repository

    self:registerListeners()
end

function DamageHandler:verifyData(src, data)
    local victim <const> = self.repository:getPlayerBySrc(data.matchmakingId, src)

    if not victim then
        return
    end

    victim.src = tostring(victim.src)

    local attacker = {
        src = "Unknown",
        nick = "Unknown",
        side = "Unknown",
    }

    if data.attackerPedNetId then
        local attackerPed <const> = NetworkGetEntityFromNetworkId(data.attackerPedNetId)

        if not attackerPed then
            return
        end

        attacker = self.repository:getPlayerByPed(data.matchmakingId, attackerPed)
        attacker.src = tostring(attacker.src)
    end

    self.repository:recordDamage(victim, attacker, {
        matchmakingId = data.matchmakingId,
        bone = data.bone,
        weapon = data.weapon,
        damage = data.damage,
    })
end

function DamageHandler:registerListeners()
    RegisterNetEvent("ws-combatreport:server:damageInput", function(data)
        self:verifyData(source, data)
    end)
end

return DamageHandler
