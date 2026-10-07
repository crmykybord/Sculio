SMODS.Joker {
  key = 'binary',
  attributes = { 'chips', 'mult', 'modify_card', 'chance', "scaling" },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  rental_compat = true,
  config = { extra = { odds = 2, chips_gain = 2, mult_gain = 2, chips = 0, mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 4 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'binary')
    return { vars = { numerator, denominator, card.ability.extra.chips_gain, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return { chips = card.ability.extra.chips, mult = card.ability.extra.mult }
    end
    if context.first_hand_drawn and context.hand_drawn and not context.blueprint then
      local extra = card.ability.extra
      local chips_gained, mult_gained = 0, 0
      for _, drawn in ipairs(context.hand_drawn) do
        if SMODS.pseudorandom_probability(card, 'binary', 1, extra.odds) then
          drawn:juice_up(0.3, 0.5)
          if pseudorandom('binary_side') < 0.5 then
            extra.chips = extra.chips + extra.chips_gain
            chips_gained = chips_gained + extra.chips_gain
          else
            extra.mult = extra.mult + extra.mult_gain
            mult_gained = mult_gained + extra.mult_gain
          end
        end
      end
      if chips_gained > 0 or mult_gained > 0 then
        local chips_side = chips_gained >= mult_gained
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {
              message = localize(chips_side and 'k_Sculio_binary_scale_chips' or 'k_Sculio_binary_scale_mult'),
              colour = chips_side and G.C.CHIPS or G.C.MULT,
            })
            return true
          end,
        }))
      end
    end
  end
}