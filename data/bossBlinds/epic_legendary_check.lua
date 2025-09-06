function CanSpawnEpic()
    G.GAME.OvershootFXVal = G.GAME.OvershootFXVal or 0
    if G.GAME.unik_force_epic_plus > 0 then
        return true
    end
    if G.GAME.modifiers.unik_legendary_at_any_time then
        return true
    end
    if G.GAME.round >= 40 then
        if G.GAME.OvershootFXVal >= 2 then
            return true
        end
    end
    if G.GAME.unik_overshoot and G.GAME.OvershootFXVal >= 3 then
        return true
    end
    return false
end
function CanSpawnLegendary()
    G.GAME.OvershootFXVal = G.GAME.OvershootFXVal or 0
    if G.GAME.modifiers.unik_legendary_at_any_time then
        return true
    end
    if G.GAME.round >= 90 then
        if G.GAME.OvershootFXVal >= 3 then
            return true
        end
    end
    if G.GAME.unik_overshoot and G.GAME.OvershootFXVal >= 4 then
        return true
    end
    return false
end

