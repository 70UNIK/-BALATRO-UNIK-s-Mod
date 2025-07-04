--set money to -$6666
SMODS.Consumable{
    set = 'unik_lartceps', 
	atlas = 'unik_lartceps',
    cost = 0,
	pos = {x = 6, y = 0},
	key = 'unik_extortion',
    config = {extra = {money = 6666}},
    no_doe = true,
    no_grc = true,
	no_ccd = true,
    can_use = function(self, card)
		return true
	end,
    loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money,
			},
		}
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound("timpani")
			ease_dollars(math.floor(-G.GAME.dollars)-math.abs(card.ability.extra.money))
			card:juice_up(0.3, 0.5)
		return true end })) 
    end,
    in_pool = function()
		return lartcepsCheck()
	end,
}