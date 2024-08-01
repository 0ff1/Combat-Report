---@class DamageColletor
local DamageColletor = lib.class("DamageColletor")

function DamageColletor:constructor(repository)
    self.repository = repository

    self:registerListeners()
end

function DamageColletor:registerListeners()
    AddEventHandler("gameEventTriggered", function(name, data)
        if not self.repository.matchmakingId then
            return
        end

        if name ~= "CEventNetworkEntityDamage" then
            return
        end

        local victim <const>, attacker <const>, victimDied <const>, weapon <const> = data[1], data[2], data[4], data[7]

        if not IsEntityAPed(victim) or victim ~= lib.cache("ped") then
            return
        end

        local curHealth <const> = GetEntityHealth(victim)
        local _, damageBone <const> = GetPedLastDamageBone(victim)

        local data = {
            matchmakingId = self.repository.matchmakingId,
            attackerPedNetId = nil,
            bone = damageBone,
            weapon = weapon,
            damage = self.repository.health - curHealth,
        }

        self.repository.health = curHealth

        if data.damage <= 0 then
            return
        end

        if IsEntityAPed(attacker) and victim ~= attacker and IsPedAPlayer(attacker) then
            data.attackerPedNetId = NetworkGetNetworkIdFromEntity(attacker)
        end

        TriggerServerEvent("ws-combatreport:server:damageInput", data)
    end)
end

return DamageColletor
