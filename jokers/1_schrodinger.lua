SMODS.Joker {
  key = 'schrodinger',

  config = { extra = { odds = 2, x_mult = 2 } },
  unlocked = true,
  discovered = false,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 0 },
  cost = 4,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'schrodinger')
    return { vars = { numerator, denominator, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and SMODS.pseudorandom_probability(card, 'schrodinger', 1, card.ability.extra.odds) then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}
