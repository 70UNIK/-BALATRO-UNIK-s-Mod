

local updateHook = Game.update
function Game:update(dt)
    --Artisan builds
    if G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss and (
        ((G.GAME.defeated_blinds["bl_unik_artisan_builds"] or 
        G.GAME.defeated_blinds["bl_unik_epic_artisan"]) 
        and (G.GAME.round_resets.blind_choices.Boss == "bl_cry_obsidian_orb" or
        G.GAME.round_resets.blind_choices.Big == "bl_cry_obsidian_orb" or
        G.GAME.round_resets.blind_choices.Small == "bl_cry_obsidian_orb"))
        or 
        G.GAME.round_resets.blind_choices.Boss == 'bl_unik_artisan_builds' or
        G.GAME.round_resets.blind_choices.Boss == 'bl_unik_epic_artisan' or 
        G.GAME.round_resets.blind_choices.Big == 'bl_unik_epic_artisan' or 
        G.GAME.round_resets.blind_choices.Small == 'bl_unik_epic_artisan' or 
        G.GAME.round_resets.blind_choices.Big == 'bl_unik_artisan_builds' or  
        G.GAME.round_resets.blind_choices.Small == 'bl_unik_artisan_builds'
        ) then
        G.GAME.unik_artisan_reroll_time = true
    else
        G.GAME.unik_artisan_reroll_time = nil
        G.GAME.ante_rerolls = 0
    end
    if G.GAME.unik_dynamic_text_realtime then
		G.GAME.blind:set_text()
    end
    local res = updateHook(self,dt)
    if G.ARGS.LOC_COLOURS then
        self.C.UNIK_RGB_HUE = self.C.UNIK_RGB_HUE or 0
		local r, g, b = hsv2222(self.C.UNIK_RGB_HUE / 360, .5, 1)

		self.C.UNIK_RGB[1] = r
		self.C.UNIK_RGB[3] = g
		self.C.UNIK_RGB[2] = b

		self.C.UNIK_RGB_HUE = (self.C.UNIK_RGB_HUE + 0.5) % 360
		G.ARGS.LOC_COLOURS.UNIK_RGB = self.C.UNIK_RGB
		
	end
    G.GAME.OvershootFXVal = G.GAME.OvershootFXVal or 0
    G.GAME.unik_overshoot = G.GAME.unik_overshoot or 0
    if G.GAME.unik_overshoot < 6 then
        G.GAME.OvershootFXVal = 0
    elseif G.GAME.unik_overshoot < 10 then
        G.GAME.OvershootFXVal = 1
    elseif G.GAME.unik_overshoot < 15 then
        G.GAME.OvershootFXVal = 2
    elseif G.GAME.unik_overshoot < 18 then
        G.GAME.OvershootFXVal = 3
    elseif G.GAME.unik_overshoot < 20 then
        G.GAME.OvershootFXVal = 4
    else
         G.GAME.OvershootFXVal = 5
    end
    return res
end


--rgb hsv stuff
function hsv2222(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

