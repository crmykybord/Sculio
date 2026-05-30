SMODS.Joker {
  key = 'binary',

  config = { extra = { odds = 2, chips_gain = 2, mult_gain = 2, chips = 0, mult = 0 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
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
    if context.end_of_round and not context.individual and not context.repetition and not context.game_over and not context.blueprint then
      local cards_in_hand = #G.hand.cards
      if cards_in_hand > 0 then
        local chips_stacks = 0
        local mult_stacks = 0
        for i = 1, cards_in_hand do
          if pseudorandom('binary') < 0.5 then
            chips_stacks = chips_stacks + 2
          else
            mult_stacks = mult_stacks + 2
          end
        end
        
        card.ability.extra.chips = card.ability.extra.chips + chips_stacks
        card.ability.extra.mult = card.ability.extra.mult + mult_stacks
        
        return { message = localize('k_Sculio_binary_upgrade'), colour = G.C.GREEN }
      end
    end
  end
}
