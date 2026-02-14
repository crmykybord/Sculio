SMODS.Joker {
  key = 'house_party',

  config = { extra = { x_mult = 1, x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = false,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 0 },
  cost = 6,
  blueprint_compat = true,
  perishable_compat = false,
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
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}
