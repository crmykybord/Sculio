SMODS.Joker {
  key = 'house_party',
  attributes = { 'xmult', 'hand_type', 'reset', 'scaling' },
  config = { extra = { x_mult = 1, x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 0 },
  cost = 6,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      if (next(context.poker_hands['Full House']) or next(context.poker_hands['Flush House'])) then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
      elseif card.ability.extra.x_mult > 1 then
        card.ability.extra.x_mult = 1
        return { message = localize('k_reset') }
      end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return { xmult = card.ability.extra.x_mult }
    end
  end
}
