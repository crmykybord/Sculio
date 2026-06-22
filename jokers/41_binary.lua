SMODS.Joker {
  key = 'binary',
  attributes = { 'chips', 'mult', 'modify_card', 'chance', "scaling" },

  config = { extra = { odds = 2, chips_gain = 2, mult_gain = 2, chips = 0, mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 4 },
  cost = 4,
  blueprint_compat = true,
  perishable_compat = false,
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'binary')
    return { vars = { numerator, denominator, card.ability.extra.chips_gain, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return { chips = card.ability.extra.chips, mult = card.ability.extra.mult }
    end
    if context.end_of_round and context.individual and context.cardarea == G.hand and not context.blueprint then
      if SMODS.pseudorandom_probability(card, 'binary', 1, card.ability.extra.odds) then
        local other_card = context.other_card
        if pseudorandom('binary_side') < 0.5 then
          card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
          other_card:juice_up(0.3, 0.5)
          return { message = localize('k_Sculio_binary_scale_chips'), colour = G.C.CHIPS, card = other_card }
        else
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
          other_card:juice_up(0.3, 0.5)
          return { message = localize('k_Sculio_binary_scale_mult'), colour = G.C.MULT, card = other_card }
        end
      end
    end
  end
}
