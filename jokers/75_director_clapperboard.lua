SMODS.Joker {
  key = 'director_clapperboard',
  attributes = { 'xmult', 'reset' },
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  rental_compat = true,
  config = { extra = { x_mult = 1, x_mult_gain = 0.1 } },
  unlocked = true,
  discovered = false,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 7, y = 7 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
      card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
    end
    if context.joker_main and card.ability.extra.x_mult > 1 then
      return { xmult = card.ability.extra.x_mult }
    end
    if context.end_of_round and context.main_eval and not context.blueprint and card.ability.extra.x_mult > 1 then
      card.ability.extra.x_mult = 1
      return { message = localize('k_reset'), colour = G.C.MULT, card = card }
    end
  end,
}
