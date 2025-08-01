
--Properly making depleted jokers work
--Clicked cookie
SMODS.Joker:take_ownership("j_cry_clicked_cookie",{
	config = {
		extra = {
			chips = 200,
			chip_mod = 1,
			depleted_threshold = -200,
		},
	},
	pools = { ["autocannibalism_food"] = true },
	loc_vars = function(self, info_queue, center)
		local key = 'j_cry_clicked_cookie2'
		local sign = "+"
		if center.ability and center.ability.unik_depleted then
			key = 'j_cry_clicked_cookie_depleted'
		end
		if center.ability and center.ability.extra and center.ability.extra.chips and center.ability.extra.chips <= 0 then
			sign = ""
		end 
		return {
			key = key,
			vars = {
				sign,
				center.ability.extra.chips,
				center.ability.extra.chip_mod,
				center.ability.extra.depleted_threshold,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			local sign = "+"
			if  to_big(card.ability.extra.chips) <=  to_big(0) then
				sign = ""
			end 
			return {
				card = card,
				chip_mod = lenient_bignum(card.ability.extra.chips),
				message = sign .. number_format(card.ability.extra.chips),
				colour = G.C.CHIPS,
			}
		end
		if context.cry_press  and not context.blueprint then
			if (not card.ability.unik_depleted and to_big(card.ability.extra.chips) - to_big(card.ability.extra.chip_mod) <= to_big(0))
				or (card.ability.unik_depleted and to_big(card.ability.extra.chips) - to_big(card.ability.extra.chip_mod) <= to_big(card.ability.extra.depleted_threshold))
			then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_eaten_ex"), colour = G.C.CHIPS }
				)
			else
				card.ability.extra.chips =
					lenient_bignum(to_big(card.ability.extra.chips) - card.ability.extra.chip_mod)
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ message = "-" .. number_format(card.ability.extra.chip_mod), colour = G.C.CHIPS }
				)
			end
		end
	end,
}, true)
--Ice cream
SMODS.Joker:take_ownership("j_ice_cream",{
	config = {
		extra = {chips = 100, chip_mod = 5,depleted_threshold = -100}
	},
	loc_vars = function(self, info_queue, center)
		local key = 'j_ice_cream'
		local sign = "+"
		if center.ability.unik_depleted then
			key = 'j_ice_cream_depleted'
		end
		if lenient_bignum(center.ability.extra.chips) <= lenient_bignum(0) then
			sign = ""
		end 
		return {
			key = key,
			vars = {
				number_format(center.ability.extra.chips),
				number_format(center.ability.extra.chip_mod),
				sign,
				number_format(center.ability.extra.depleted_threshold),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			if (card.ability.unik_depleted and card.ability.extra.chips - card.ability.extra.chip_mod < card.ability.extra.depleted_threshold) or (not card.ability.unik_depleted and card.ability.extra.chips - card.ability.extra.chip_mod <= 0) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					message = localize('k_melted_ex'),
					colour = G.C.CHIPS
				}
			else
				card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
				return {
					message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.chip_mod}},
					colour = G.C.CHIPS
				}
			end
		end
		if context.joker_main then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips, 
				colour = G.C.CHIPS
			}
		end
	end,

}, true)
--Popcorn
SMODS.Joker:take_ownership("j_popcorn",{
	config = {
		extra = {mult = 20, extra = 4,depleted_threshold = -20},
	},
	loc_vars = function(self, info_queue, center)
		local key = 'j_popcorn'
		local sign = "+"
		if center.ability.unik_depleted then
			key = 'j_popcorn_depleted'
		end
		if lenient_bignum(center.ability.extra.mult) <= lenient_bignum(0) then
			sign = ""
		end 
		return {
			key = key,
			vars = {
				number_format(center.ability.extra.mult),
				number_format(center.ability.extra.extra),
				sign,
				number_format(center.ability.extra.depleted_threshold),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round 
			and context.cardarea == G.jokers and not context.repetition and not context.blueprint then
			-- adding depleted functionality for popcorn
			if (card.ability.unik_depleted and card.ability.extra.mult - card.ability.extra.extra < card.ability.extra.depleted_threshold) or (not card.ability.unik_depleted and card.ability.extra.mult - card.ability.extra.extra <= 0) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					message = localize('k_eaten_ex'),
					colour = G.C.RED
				}
			else
				card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.extra
				return {
					message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.extra}},
					colour = G.C.MULT
				}
			end
		end
		if context.joker_main then
			return {
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
				mult_mod = card.ability.extra.mult
			}
		end
	end
}, true)
--Ramen
SMODS.Joker:take_ownership("j_ramen",{
	config = {
		extra = {Xmult = 2, extra = 0.01,depleted_threshold = 0},
	},
	loc_vars = function(self, info_queue, center)
		local key = 'j_ramen'
		if center.ability.unik_depleted then
			key = 'j_ramen_depleted'
		end
		return {
			key = key,
			vars = {
				number_format(center.ability.extra.Xmult),
				number_format(center.ability.extra.extra),
				number_format(center.ability.extra.depleted_threshold),
			},
		}
	end,
	calculate = function(self, card, context)
		if (context.discard and not context.blueprint) then
			if (card.ability.unik_depleted and card.ability.extra.Xmult - card.ability.extra.extra < card.ability.extra.depleted_threshold) or (not card.ability.unik_depleted and card.ability.extra.Xmult - card.ability.extra.extra <= 1) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					card = card,
					message = localize('k_eaten_ex'),
					colour = G.C.FILTER
				}
			else
				card.ability.extra.Xmult = card.ability.extra.Xmult -  card.ability.extra.extra
				return {
					delay = 0.2,
					card = card,
					message = localize{type='variable',key='a_xmult_minus',vars={ card.ability.extra.extra}},
					colour = G.C.RED
				}
			end
		end
		if context.joker_main then
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult } }),
				Xmult_mod = card.ability.extra.Xmult,
				colour = G.C.MULT,
			}
		end
	end
}, true)

--TURtuuuLE BEEEEANANNN!!!
SMODS.Joker:take_ownership("j_turtle_bean",{
	config = {
		extra = {h_size = 5, h_mod = 1,depleted_threshold = -5},
	},
	loc_vars = function(self, info_queue, center)
		local key = 'j_turtle_bean'
		local sign = "+"
		if center.ability.unik_depleted then
			key = 'j_turtle_bean_depleted'
		end
		if lenient_bignum(center.ability.extra.h_size) <= lenient_bignum(0) then
			sign = ""
		end 
		return {
			key = key,
			vars = {
				number_format(center.ability.extra.h_size),
				number_format(center.ability.extra.h_mod),
				sign,
				number_format(center.ability.extra.depleted_threshold),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round 
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker then
			if (card.ability.unik_depleted and card.ability.extra.h_size - card.ability.extra.h_mod < card.ability.extra.depleted_threshold) or (not (card.ability.unik_depleted) and card.ability.extra.h_size - card.ability.extra.h_mod <= 0) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					card = card,
					message = localize('k_eaten_ex'),
					colour = G.C.FILTER
				}
			else
				card.ability.extra.h_size = card.ability.extra.h_size - card.ability.extra.h_mod
				G.hand:change_size(- card.ability.extra.h_mod)
				return {
					message = localize{type='variable',key='a_handsize_minus',vars={card.ability.extra.h_mod}},
					colour = G.C.FILTER
				}
			end
		end
	end
}, true)
--TODO: lolipop, nachos
--Lollipop
SMODS.Joker:take_ownership("j_mf_lollipop",{
	loc_vars = function(self, info_queue, center)
		local key = 'j_mf_lollipop'
		if center.ability.unik_depleted then
			key = 'j_mf_lollipop_depleted'
		end
		return {
		key = key,
		vars = { center.ability.x_mult, center.ability.extra,0 }
		}
	end,
	pools = { ["autocannibalism_food"] = true },
	calculate = function(self, card, context)
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and not context.retrigger_joker then
		if (card.ability.x_mult - card.ability.extra <= 1.01 and not card.ability.unik_depleted) or (card.ability.x_mult - card.ability.extra <= 0 and card.ability.unik_depleted) then 
			G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:remove()
					card = nil
					return true; end})) 
				return true
			end
			})) 
			return {
			message = localize('k_eaten_ex'),
			colour = G.C.FILTER
			}
		else
			card.ability.x_mult = card.ability.x_mult - card.ability.extra
			return {
			message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra}},
			colour = G.C.RED
			}
		end
		elseif context.forcetrigger or (context.cardarea == G.jokers and context.joker_main) then
			return {
			message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
			Xmult_mod = card.ability.x_mult,
			}
		end
	end
}, true)
--Nachos
SMODS.Joker:take_ownership("j_paperback_nachos",{
	loc_vars = function(self, info_queue, card)
		local key = 'j_paperback_nachos'
		if card.ability.unik_depleted then
			key = 'j_paperback_nachos_depleted'
		end
		return {
		key = key,
		vars = {
			card.ability.extra.X_chips,
			card.ability.extra.reduction_amount,
			0,
		}
		}
	end,
	pools = { ["autocannibalism_food"] = true },
	calculate = function(self, card, context)
		-- Gives the xChips during play
		if context.joker_main then
		return {
			x_chips = card.ability.extra.X_chips
		}
		end
		if context.discard and not context.blueprint then
			-- Reduce the xChips value
			card.ability.extra.X_chips = card.ability.extra.X_chips - card.ability.extra.reduction_amount

			-- Destroy Nachos if the current value is <= 1
			if (card.ability.extra.X_chips <= 1 and not card.ability.unik_depleted) or (card.ability.extra.X_chips <= 0 and card.ability.unik_depleted) then
				PB_UTIL.destroy_joker(card)

				return {
				message = localize('k_eaten_ex'),
				colour = G.C.FILTER,
				card = card
				}
			else
				return {
				delay = 0.2,
				message = localize {
					type = 'variable',
					key = 'a_xchips_minus',
					vars = { card.ability.extra.reduction_amount }
				},
				colour = G.C.CHIPS,
				card = card
				}
			end
		end
	end
}, true)
--Cube pools