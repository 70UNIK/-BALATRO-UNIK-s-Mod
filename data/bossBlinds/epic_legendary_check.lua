function CanSpawnEpic()
    if Cryptid.gameset() == "modest" then
        return false
    end
    if G.GAME.unik_force_epic_plus > 0 then
        return true
    end
    if G.GAME.modifiers.unik_legendary_at_any_time then
        return true
    end
    if G.GAME.round >= 40 then
        if G.GAME.unik_scores_really_big_back > 10 then
            return true
        end
    end
    return false
end
function CanSpawnLegendary()
    if Cryptid.gameset() == "modest" then
        return false
    end
    if G.GAME.modifiers.unik_legendary_at_any_time then
        return true
    end
    if G.GAME.round >= 90 then
        if G.GAME.unik_scores_really_big_back > 15 then
            return true
        end
    end
    return false
end

